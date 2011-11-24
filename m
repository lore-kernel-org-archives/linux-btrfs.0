From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 62/99] btrfs: btrfs_run_defrag_inodes should return void
Date: Wed, 23 Nov 2011 19:36:35 -0500
Message-ID: <20111124004226.995032449@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_run_defrag_inodes has no error conditions and should return
 void. Its callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/file.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2606,7 +2606,7 @@ int btrfs_defrag_file(struct inode *inod
 /* file.c */
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct inode *inode);
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
+void btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -193,7 +193,7 @@ struct inode_defrag *btrfs_find_defrag_i
  * run through the list of inodes in the FS that need
  * defragging
  */
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+void btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 {
 	struct inode_defrag *defrag;
 	struct btrfs_root *inode_root;
@@ -296,7 +296,6 @@ next_free:
 	 * wait for the defragger to stop
 	 */
 	wake_up(&fs_info->transaction_wait);
-	return 0;
 }
 
 /* simple helper to fault in pages and copy.  This should go away



