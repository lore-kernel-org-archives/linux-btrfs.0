From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 32/65] btrfs: tree-log: btrfs_end_log_trans should return void
Date: Mon, 03 Oct 2011 23:23:02 -0400
Message-ID: <20111004032303.589463194@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_end_log_trans has no error conditions and should return void.
 Its callers ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/tree-log.c |    3 +--
 fs/btrfs/tree-log.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

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


