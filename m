From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/9] Btrfs: modify btrfs_drop_extents API
Date: Thu, 19 May 2011 16:11:26 +0800
Message-ID: <1305792692-10635-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
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
index ef68108..1ba3f91 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2575,7 +2575,8 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
 extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache);
+		       u64 start, u64 end, u64 *hint_byte, int drop_cache,
+		       int log);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 75899a0..d19cf3a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -290,7 +290,8 @@ int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
  * is deleted from the tree.
  */
 int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
-		       u64 start, u64 end, u64 *hint_byte, int drop_cache)
+		       u64 start, u64 end, u64 *hint_byte, int drop_cache,
+		       int log)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_buffer *leaf;
@@ -309,6 +310,10 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	int recow;
 	int ret;
 
+	/* drop the existed extents in log tree */
+	if (log)
+		root = root->log_root;
+
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
@@ -489,7 +494,7 @@ next_slot:
 						extent_end - key.offset);
 				extent_end = ALIGN(extent_end,
 						   root->sectorsize);
-			} else if (disk_bytenr > 0) {
+			} else if (disk_bytenr > 0 && !log) {
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4cec4c9..d823467 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -244,7 +244,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_drop_extents(trans, inode, start, aligned_end,
-				 &hint_byte, 1);
+				 &hint_byte, 1, 0);
 	BUG_ON(ret);
 
 	if (isize > actual_end)
@@ -1639,7 +1639,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	 * with the others.
 	 */
 	ret = btrfs_drop_extents(trans, inode, file_pos, file_pos + num_bytes,
-				 &hint, 0);
+				 &hint, 0, 0);
 	BUG_ON(ret);
 
 	ins.objectid = inode->i_ino;
@@ -3649,7 +3649,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 			err = btrfs_drop_extents(trans, inode, cur_offset,
 						 cur_offset + hole_size,
-						 &hint_byte, 1);
+						 &hint_byte, 1, 0);
 			if (err)
 				break;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 142a82d..d5a6a19 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2014,7 +2014,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				ret = btrfs_drop_extents(trans, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
-							 &hint_byte, 1);
+							 &hint_byte, 1, 0);
 				BUG_ON(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
@@ -2069,7 +2069,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				ret = btrfs_drop_extents(trans, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
-							 &hint_byte, 1);
+							 &hint_byte, 1, 0);
 				BUG_ON(ret);
 
 				ret = btrfs_insert_empty_item(trans, root, path,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ecd2c5..51d5024 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -563,7 +563,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
-				 &alloc_hint, 1);
+				 &alloc_hint, 1, 0);
 	BUG_ON(ret);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
-- 
1.6.5.2

