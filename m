From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/4] Btrfs: re-work delalloc flushing
Date: Fri, 15 Oct 2010 17:28:33 -0400
Message-ID: <1287178115-18229-3-git-send-email-josef@redhat.com>
References: <1287178115-18229-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287178115-18229-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently we try and flush delalloc, but we only do that in a sort of weak way,
which works fine in most cases but if we're under heavy pressure we need to be
able to wait for flushing to happen.  Also instead of checking the bytes
reserved in the block_rsv, check the space info since it is more accurate.  The
sync option will be used in a future patch.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 ++-
 fs/btrfs/extent-tree.c |   26 ++++++++++++++------------
 fs/btrfs/inode.c       |    8 ++++++--
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4833a01..72f5e1a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2439,7 +2439,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput);
+int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput,
+				   int sync);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d532f00..14a52dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3342,9 +3342,10 @@ static int maybe_allocate_chunk(struct btrfs_trans_handle *trans,
  * shrink metadata reservation for delalloc
  */
 static int shrink_delalloc(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 to_reclaim)
+			   struct btrfs_root *root, u64 to_reclaim, int sync)
 {
 	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_space_info *space_info;
 	u64 reserved;
 	u64 max_reclaim;
 	u64 reclaimed = 0;
@@ -3353,9 +3354,10 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	int ret;
 
 	block_rsv = &root->fs_info->delalloc_block_rsv;
-	spin_lock(&block_rsv->lock);
-	reserved = block_rsv->reserved;
-	spin_unlock(&block_rsv->lock);
+	space_info = block_rsv->space_info;
+	spin_lock(&space_info->lock);
+	reserved = space_info->bytes_reserved;
+	spin_unlock(&space_info->lock);
 
 	if (reserved == 0)
 		return 0;
@@ -3363,7 +3365,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	max_reclaim = min(reserved, to_reclaim);
 
 	while (1) {
-		ret = btrfs_start_one_delalloc_inode(root, trans ? 1 : 0);
+		ret = btrfs_start_one_delalloc_inode(root, trans ? 1 : 0, sync);
 		if (!ret) {
 			if (no_reclaim > 2)
 				break;
@@ -3378,11 +3380,11 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 			pause = 1;
 		}
 
-		spin_lock(&block_rsv->lock);
-		if (reserved > block_rsv->reserved)
-			reclaimed = reserved - block_rsv->reserved;
-		reserved = block_rsv->reserved;
-		spin_unlock(&block_rsv->lock);
+		spin_lock(&space_info->lock);
+		if (reserved > space_info->bytes_reserved)
+			reclaimed = reserved - space_info->bytes_reserved;
+		reserved = space_info->bytes_reserved;
+		spin_unlock(&space_info->lock);
 
 		if (reserved == 0 || reclaimed >= max_reclaim)
 			break;
@@ -3411,7 +3413,7 @@ static int should_retry_reserve(struct btrfs_trans_handle *trans,
 	if (trans && trans->transaction->in_commit)
 		return -ENOSPC;
 
-	ret = shrink_delalloc(trans, root, num_bytes);
+	ret = shrink_delalloc(trans, root, num_bytes, 0);
 	if (ret)
 		return ret;
 
@@ -3960,7 +3962,7 @@ again:
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
 	if (block_rsv->size > 512 * 1024 * 1024)
-		shrink_delalloc(NULL, root, to_reserve);
+		shrink_delalloc(NULL, root, to_reserve, 0);
 
 	return 0;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1d17518..8b678dc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6683,7 +6683,8 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	return 0;
 }
 
-int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput)
+int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput,
+				   int sync)
 {
 	struct btrfs_inode *binode;
 	struct inode *inode = NULL;
@@ -6705,7 +6706,10 @@ int btrfs_start_one_delalloc_inode(struct btrfs_root *root, int delay_iput)
 	spin_unlock(&root->fs_info->delalloc_lock);
 
 	if (inode) {
-		write_inode_now(inode, 0);
+		if (sync)
+			filemap_write_and_wait(inode->i_mapping);
+		else
+			filemap_flush(inode->i_mapping);
 		if (delay_iput)
 			btrfs_add_delayed_iput(inode);
 		else
-- 
1.6.6.1

