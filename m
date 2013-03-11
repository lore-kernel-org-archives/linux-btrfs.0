Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3CKRIm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 13:08:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AFBFEA4386
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 18:08:41 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs: clean up transaction abort messages
Date: Mon, 11 Mar 2013 18:08:40 +0100
Message-Id: <1363021720-15684-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction abort stacktrace is printed only once per module
lifetime, but we'd like to see it each time it happens per filesystem.
Introduce a fs_state flag that records the state.

Tweak the messages around abort:
* add error number to the first abor
* print the exact negative errno from btrfs_decode_error and
  don't expect a simple snprintf to fail
* no dots at the end of the messages

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/super.c       |   19 +++++++++++--------
 fs/btrfs/transaction.c |    5 ++---
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e391d6b..14d8f8d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -340,6 +340,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
  */
 #define BTRFS_FS_STATE_ERROR		0
 #define BTRFS_FS_STATE_REMOUNTING	1
+#define BTRFS_FS_STATE_TRANS_ABORTED	2
 
 /* Super block flags */
 /* Errors detected */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index eed1464..fe0d6ce 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -65,7 +65,7 @@ static struct file_system_type btrfs_fs_type;
 
 static const char *btrfs_decode_error(int errno, char nbuf[16])
 {
-	char *errstr = NULL;
+	char *errstr = nbuf;
 
 	switch (errno) {
 	case -EIO:
@@ -81,10 +81,7 @@ static const char *btrfs_decode_error(int errno, char nbuf[16])
 		errstr = "Object already exists";
 		break;
 	default:
-		if (nbuf) {
-			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
-				errstr = nbuf;
-		}
+		snprintf(nbuf, 16, "error %d", errno);
 		break;
 	}
 
@@ -121,7 +118,6 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 		 * mounted writeable again, the device replace
 		 * operation continues.
 		 */
-//		WARN_ON(1);
 	}
 }
 
@@ -247,7 +243,14 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
 {
-	WARN_ONCE(1, KERN_DEBUG "btrfs: Transaction aborted\n");
+	/*
+	 * Report first abort since mount
+	 */
+	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,
+				&root->fs_info->fs_state)) {
+		WARN(1, KERN_DEBUG "btrfs: Transaction aborted (error %d)\n",
+				errno);
+	}
 	trans->aborted = errno;
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
@@ -257,7 +260,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 
 		errstr = btrfs_decode_error(errno, nbuf);
 		btrfs_printk(root->fs_info,
-			     "%s:%d: Aborting unused transaction(%s).\n",
+			     "%s:%d: Aborting unused transaction (%s)\n",
 			     function, line, errstr);
 		return;
 	}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a0467eb..a5bbda1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1810,7 +1810,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = btrfs_write_and_wait_transaction(trans, root);
 	if (ret) {
 		btrfs_error(root->fs_info, ret,
-			    "Error while writing out transaction.");
+			    "Error while writing out transaction");
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		goto cleanup_transaction;
 	}
@@ -1866,8 +1866,7 @@ cleanup_transaction:
 		btrfs_qgroup_free(root, trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
-	btrfs_printk(root->fs_info, "Skipping commit of aborted transaction.\n");
-//	WARN_ON(1);
+	btrfs_printk(root->fs_info, "Skipping commit of aborted transaction\n");
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 	cleanup_transaction(trans, root, ret);
-- 
1.7.9

