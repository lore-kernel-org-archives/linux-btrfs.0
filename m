From: jeffm@suse.com
Subject: [patch v3 15/23] btrfs: tree-log.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:55 -0400
Message-ID: <20110909002732.599988432@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_end_log_trans and wait_for_writer have no error conditions and should
 return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/tree-log.c |    6 ++----
 fs/btrfs/tree-log.h |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -212,14 +212,13 @@ int btrfs_pin_log_trans(struct btrfs_roo
  * indicate we're done making changes to the log tree
  * and wake up anyone waiting to do a sync
  */
-int btrfs_end_log_trans(struct btrfs_root *root)
+void btrfs_end_log_trans(struct btrfs_root *root)
 {
 	if (atomic_dec_and_test(&root->log_writers)) {
 		smp_mb();
 		if (waitqueue_active(&root->log_writer_wait))
 			wake_up(&root->log_writer_wait);
 	}
-	return 0;
 }
 
 
@@ -1945,7 +1944,7 @@ static int wait_log_commit(struct btrfs_
 	return 0;
 }
 
-static int wait_for_writer(struct btrfs_trans_handle *trans,
+static void wait_for_writer(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root)
 {
 	DEFINE_WAIT(wait);
@@ -1959,7 +1958,6 @@ static int wait_for_writer(struct btrfs_
 		mutex_lock(&root->log_mutex);
 		finish_wait(&root->log_writer_wait, &wait);
 	}
-	return 0;
 }
 
 /*
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -38,7 +38,7 @@ int btrfs_del_inode_ref_in_log(struct bt
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
 			       struct inode *inode, u64 dirid);
-int btrfs_end_log_trans(struct btrfs_root *root);
+void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct inode *inode,


