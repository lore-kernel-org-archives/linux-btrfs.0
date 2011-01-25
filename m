From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: change reserved_extents to an atomic_t
Date: Tue, 25 Jan 2011 16:33:16 -0500
Message-ID: <1295991196-975-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We track delayed allocation per inodes via 2 counters, one is
outstanding_extents and reserved_extents.  Outstanding_extents is already an
atomic_t, but reserved_extents is not and is protected by a spinlock.  So
convert this to an atomic_t and instead of using a spinlock, use atomic_cmpxchg
when releasing delalloc bytes.  This makes our inode 72 bytes smaller, and
reduces locking overhead (albiet it was minimal to begin with).  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    3 +--
 fs/btrfs/extent-tree.c |   41 +++++++++++++++++++++++++----------------
 fs/btrfs/inode.c       |    5 ++---
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ccc991c..57c3bb2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -136,9 +136,8 @@ struct btrfs_inode {
 	 * items we think we'll end up using, and reserved_extents is the number
 	 * of extent items we've reserved metadata for.
 	 */
-	spinlock_t accounting_lock;
 	atomic_t outstanding_extents;
-	int reserved_extents;
+	atomic_t reserved_extents;
 
 	/*
 	 * ordered_data_close is set by truncate when a file that used
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 355665b..77b31f5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3991,6 +3991,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve;
 	int nr_extents;
+	int reserved_extents;
 	int ret;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
@@ -3998,26 +3999,24 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
-	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents) + 1;
-	if (nr_extents > BTRFS_I(inode)->reserved_extents) {
-		nr_extents -= BTRFS_I(inode)->reserved_extents;
+	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
+
+	if (nr_extents > reserved_extents) {
+		nr_extents -= reserved_extents;
 		to_reserve = calc_trans_metadata_size(root, nr_extents);
 	} else {
 		nr_extents = 0;
 		to_reserve = 0;
 	}
-	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
 	if (ret)
 		return ret;
 
-	spin_lock(&BTRFS_I(inode)->accounting_lock);
-	BTRFS_I(inode)->reserved_extents += nr_extents;
+	atomic_add(nr_extents, &BTRFS_I(inode)->reserved_extents);
 	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
-	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
@@ -4032,19 +4031,29 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 to_free;
 	int nr_extents;
+	int reserved_extents;
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
 
-	spin_lock(&BTRFS_I(inode)->accounting_lock);
-	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents);
-	if (nr_extents < BTRFS_I(inode)->reserved_extents) {
-		nr_extents = BTRFS_I(inode)->reserved_extents - nr_extents;
-		BTRFS_I(inode)->reserved_extents -= nr_extents;
-	} else {
-		nr_extents = 0;
-	}
-	spin_unlock(&BTRFS_I(inode)->accounting_lock);
+	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
+	do {
+		int old, new;
+
+		nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents);
+		if (nr_extents >= reserved_extents) {
+			nr_extents = 0;
+			break;
+		}
+		old = reserved_extents;
+		nr_extents = reserved_extents - nr_extents;
+		new = reserved_extents - nr_extents;
+		old = atomic_cmpxchg(&BTRFS_I(inode)->reserved_extents,
+				     reserved_extents, new);
+		if (likely(old == reserved_extents))
+			break;
+		reserved_extents = old;
+	} while (1);
 
 	to_free = calc_csum_metadata_size(inode, num_bytes);
 	if (nr_extents > 0)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e353da5..a744a4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6495,9 +6495,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->index_cnt = (u64)-1;
 	ei->last_unlink_trans = 0;
 
-	spin_lock_init(&ei->accounting_lock);
 	atomic_set(&ei->outstanding_extents, 0);
-	ei->reserved_extents = 0;
+	atomic_set(&ei->reserved_extents, 0);
 
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
@@ -6533,7 +6532,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
 	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents));
-	WARN_ON(BTRFS_I(inode)->reserved_extents);
+	WARN_ON(atomic_read(&BTRFS_I(inode)->reserved_extents));
 
 	/*
 	 * This can happen where we create an inode, but somebody else also
-- 
1.6.6.1

