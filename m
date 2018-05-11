Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44229 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeEKALf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:35 -0400
Received: by mail-pl0-f68.google.com with SMTP id e6-v6so2211884plt.11
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:34 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 02/12] Btrfs: fix error handling in btrfs_truncate_inode_items()
Date: Thu, 10 May 2018 17:11:12 -0700
Message-Id: <5afcb519e78bd1d5e1085e266eccb8c3ac3c1312.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_truncate_inode_items() uses two variables for error handling, ret
and err. These are not handled consistently, leading to a couple of
bugs.

- Errors from btrfs_del_items() are handled but not propagated to the
  caller
- If btrfs_run_delayed_refs() fails and aborts the transaction, we
  continue running

Just use ret everywhere and simplify things a bit, fixing both of these
issues.

Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
Fixes: 1262133b8d6f ("Btrfs: account for crcs in delayed ref processing")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 55 ++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fef8dbb6a93f..79d1da01a90d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4442,7 +4442,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int pending_del_slot = 0;
 	int extent_type = -1;
 	int ret;
-	int err = 0;
 	u64 ino = btrfs_ino(BTRFS_I(inode));
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
@@ -4494,22 +4493,19 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 * up a huge file in a single leaf.  Most of the time that
 	 * bytes_deleted is > 0, it will be huge by the time we get here
 	 */
-	if (be_nice && bytes_deleted > SZ_32M) {
-		if (btrfs_should_end_transaction(trans)) {
-			err = -EAGAIN;
-			goto error;
-		}
+	if (be_nice && bytes_deleted > SZ_32M &&
+	    btrfs_should_end_transaction(trans)) {
+		ret = -EAGAIN;
+		goto out;
 	}
 
-
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret < 0) {
-		err = ret;
+	if (ret < 0)
 		goto out;
-	}
 
 	if (ret > 0) {
+		ret = 0;
 		/* there are no items in the tree for us to truncate, we're
 		 * done
 		 */
@@ -4620,7 +4616,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				 * We have to bail so the last_size is set to
 				 * just before this extent.
 				 */
-				err = NEED_TRUNCATE_BLOCK;
+				ret = NEED_TRUNCATE_BLOCK;
 				break;
 			}
 
@@ -4687,7 +4683,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 						pending_del_nr);
 				if (ret) {
 					btrfs_abort_transaction(trans, ret);
-					goto error;
+					break;
 				}
 				pending_del_nr = 0;
 			}
@@ -4698,8 +4694,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					trans->delayed_ref_updates = 0;
 					ret = btrfs_run_delayed_refs(trans,
 								   updates * 2);
-					if (ret && !err)
-						err = ret;
+					if (ret)
+						break;
 				}
 			}
 			/*
@@ -4707,8 +4703,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			 * and let the transaction restart
 			 */
 			if (should_end) {
-				err = -EAGAIN;
-				goto error;
+				ret = -EAGAIN;
+				break;
 			}
 			goto search_again;
 		} else {
@@ -4716,32 +4712,37 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		}
 	}
 out:
-	if (pending_del_nr) {
-		ret = btrfs_del_items(trans, root, path, pending_del_slot,
+	if (ret >= 0 && pending_del_nr) {
+		int err;
+
+		err = btrfs_del_items(trans, root, path, pending_del_slot,
 				      pending_del_nr);
-		if (ret)
-			btrfs_abort_transaction(trans, ret);
+		if (err) {
+			btrfs_abort_transaction(trans, err);
+			ret = err;
+		}
 	}
-error:
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		ASSERT(last_size >= new_size);
-		if (!err && last_size > new_size)
+		if (!ret && last_size > new_size)
 			last_size = new_size;
 		btrfs_ordered_update_i_size(inode, last_size, NULL);
 	}
 
 	btrfs_free_path(path);
 
-	if (be_nice && bytes_deleted > SZ_32M) {
+	if (be_nice && bytes_deleted > SZ_32M && (ret >= 0 || ret == -EAGAIN)) {
 		unsigned long updates = trans->delayed_ref_updates;
+		int err;
+
 		if (updates) {
 			trans->delayed_ref_updates = 0;
-			ret = btrfs_run_delayed_refs(trans, updates * 2);
-			if (ret && !err)
-				err = ret;
+			err = btrfs_run_delayed_refs(trans, updates * 2);
+			if (err)
+				ret = err;
 		}
 	}
-	return err;
+	return ret;
 }
 
 /*
-- 
2.17.0

