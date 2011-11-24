From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 53/99] btrfs: btrfs_end_log_trans should return void
Date: Wed, 23 Nov 2011 19:36:26 -0500
Message-ID: <20111124004225.952822165@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_end_log_trans has no error conditions and should return void.
 Its callers ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/tree-log.c |    3 +--
 fs/btrfs/tree-log.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 483e280..2c45b3d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -212,14 +212,13 @@ int btrfs_pin_log_trans(struct btrfs_root *root)
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
 
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 2270ac5..862ac81 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -38,7 +38,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       const char *name, int name_len,
 			       struct inode *inode, u64 dirid);
-int btrfs_end_log_trans(struct btrfs_root *root);
+void btrfs_end_log_trans(struct btrfs_root *root);
 int btrfs_pin_log_trans(struct btrfs_root *root);
 int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct inode *inode,



