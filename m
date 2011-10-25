From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 42/66] btrfs: btrfs_run_defrag_inodes should return void
Date: Mon, 24 Oct 2011 21:03:18 -0400
Message-ID: <20111025010855.386283687@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
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


