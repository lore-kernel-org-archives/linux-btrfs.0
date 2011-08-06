From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 04/12 v5] Btrfs: modify btrfs_drop_extents API
Date: Sat, 6 Aug 2011 17:37:39 +0800
Message-ID: <1312623467-31487-5-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We want to use btrfs_drop_extent() in log code.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |    3 ++-
 fs/btrfs/file.c     |    9 +++++++--
 fs/btrfs/inode.c    |    6 +++---
 fs/btrfs/ioctl.c    |    4 ++--
 fs/btrfs/tree-log.c |    2 +-
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 310f586..a8336e7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2615,7 +2615,8 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache);
+		       u64 start, u64 end, u64 *hint_byte, int drop_cache,
+		       int log);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 010aec8..7a84219 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -546,7 +546,8 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
  * is deleted from the tree.
  */
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache)
+		       u64 start, u64 end, u64 *hint_byte, int drop_cache,
+		       int log)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_buffer *leaf;
@@ -566,6 +567,10 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	int recow;
 	int ret;
 
+	/* drop the existed extents in log tree */
+	if (log)
+		root = root->log_root;
+
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
@@ -746,7 +751,7 @@ next_slot:
 						extent_end - key.offset);
 				extent_end = ALIGN(extent_end,
 						   root->sectorsize);
-			} else if (disk_bytenr > 0) {
+			} else if (disk_bytenr > 0 && !log) {
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 99eb0b3..b50ca12 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -246,7 +246,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_drop_extents(trans, inode, start, aligned_end,
-				 &hint_byte, 1);
+				 &hint_byte, 1, 0);
 	BUG_ON(ret);
 
 	if (isize > actual_end)
@@ -1657,7 +1657,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 * with the others.
 	 */
 	ret = btrfs_drop_extents(trans, inode, file_pos, file_pos + num_bytes,
-				 &hint, 0);
+				 &hint, 0, 0);
 	BUG_ON(ret);
 
 	ins.objectid = btrfs_ino(inode);
@@ -3509,7 +3509,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 			err = btrfs_drop_extents(trans, inode, cur_offset,
 						 cur_offset + hole_size,
-						 &hint_byte, 1);
+						 &hint_byte, 1, 0);
 			if (err)
 				break;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bc9a2ad..3448dbc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2340,7 +2340,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				ret = btrfs_drop_extents(trans, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
-							 &hint_byte, 1);
+							 &hint_byte, 1, 0);
 				BUG_ON(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
@@ -2395,7 +2395,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				ret = btrfs_drop_extents(trans, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
-							 &hint_byte, 1);
+							 &hint_byte, 1, 0);
 				BUG_ON(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5a026d2..a75990a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -562,7 +562,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
-				 &alloc_hint, 1);
+				 &alloc_hint, 1, 0);
 	BUG_ON(ret);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
-- 
1.6.5.2

