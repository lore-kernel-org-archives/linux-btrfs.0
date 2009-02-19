From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: make metadata hint's per-root instead of per-fs
Date: Thu, 19 Feb 2009 13:12:50 -0500
Message-ID: <1235067170-13038-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes the hint byte for metadata allocations per btrfs_root instead
of per fs_info.  Metadata allocations are usually done in big chunks so you
can put a bunch of leaves down together in one area instead of fragmenting them.
The problem with this is you get extent_root and normal root leaves being
allocated in these chunks, so you still end up with fragmentation between the
two trees.  This patch will make sure that these big chunks are for the most
part limited to the different roots, which makes reading from disk faster.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/transaction.c |    7 ++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dc473a3..58f4e16 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -792,7 +792,6 @@ struct btrfs_fs_info {
 	spinlock_t delalloc_lock;
 	spinlock_t new_trans_lock;
 	u64 delalloc_bytes;
-	u64 last_alloc;
 	u64 last_data_alloc;
 
 	spinlock_t ref_cache_lock;
@@ -845,6 +844,7 @@ struct btrfs_root {
 
 	u64 objectid;
 	u64 last_trans;
+	u64 last_alloc;
 
 	/* data allocations are done in sectorsize units */
 	u32 sectorsize;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 74696b1..22cedbd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3344,7 +3344,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		allowed_chunk_alloc = 1;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA) {
-		last_ptr = &root->fs_info->last_alloc;
+		last_ptr = &orig_root->last_alloc;
 		if (!btrfs_test_opt(root, SSD))
 			empty_cluster = 64 * 1024;
 	}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 14e626f..329492d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -53,7 +53,12 @@ static noinline int join_transaction(struct btrfs_root *root)
 					     GFP_NOFS);
 		BUG_ON(!cur_trans);
 		root->fs_info->generation++;
-		root->fs_info->last_alloc = 0;
+		root->fs_info->tree_root->last_alloc = 0;
+		root->fs_info->extent_root->last_alloc = 0;
+		root->fs_info->chunk_root->last_alloc = 0;
+		root->fs_info->dev_root->last_alloc = 0;
+		root->fs_info->fs_root->last_alloc = 0;
+		root->fs_info->csum_root->last_alloc = 0;
 		root->fs_info->last_data_alloc = 0;
 		cur_trans->num_writers = 1;
 		cur_trans->num_joined = 0;
-- 
1.5.4.3

