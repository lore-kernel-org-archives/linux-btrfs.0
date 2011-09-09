From: jeffm@suse.com
Subject: [patch v3 20/23] btrfs: file.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:23:00 -0400
Message-ID: <20110909002733.597043485@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_run_defrag_inodes contains no error conditions and should return
 void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/file.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2612,7 +2612,7 @@ int btrfs_defrag_file(struct inode *inod
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
@@ -191,7 +191,7 @@ struct inode_defrag *btrfs_find_defrag_i
  * run through the list of inodes in the FS that need
  * defragging
  */
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+void btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 {
 	struct inode_defrag *defrag;
 	struct btrfs_root *inode_root;
@@ -294,7 +294,6 @@ next_free:
 	 * wait for the defragger to stop
 	 */
 	wake_up(&fs_info->transaction_wait);
-	return 0;
 }
 
 /* simple helper to fault in pages and copy.  This should go away


