Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab3CLOqT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 10:46:19 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: zab@redhat.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: clean up transaction abort messages
Date: Tue, 12 Mar 2013 15:46:08 +0100
Message-Id: <1363099568-29013-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction abort stacktrace is printed only once per module
lifetime, but we'd like to see it each time it happens per mounted
filesystem.  Introduce a fs_state flag that records it.

Tweak the messages around abort:
* add error number to the first abort
* print the exact negative errno from btrfs_decode_error
* clean up btrfs_decode_error and callers
* no dots at the end of the messages

Signed-off-by: David Sterba <dsterba@suse.cz>
---
v1->v2:
* drop nbuf parameter from btrfs_decode_error and update messages
  in callers, add 'errno=%d' to the message

 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/super.c       |   47 ++++++++++++++++++++++-------------------------
 fs/btrfs/transaction.c |    5 ++---
 3 files changed, 25 insertions(+), 28 deletions(-)

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
index eed1464..56ac46a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -63,9 +63,9 @@
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
 
-static const char *btrfs_decode_error(int errno, char nbuf[16])
+static const char *btrfs_decode_error(int errno)
 {
-	char *errstr = NULL;
+	char *errstr = "unknown";
 
 	switch (errno) {
 	case -EIO:
@@ -80,12 +80,6 @@ static const char *btrfs_decode_error(int errno, char nbuf[16])
 	case -EEXIST:
 		errstr = "Object already exists";
 		break;
-	default:
-		if (nbuf) {
-			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
-				errstr = nbuf;
-		}
-		break;
 	}
 
 	return errstr;
@@ -121,7 +115,6 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 		 * mounted writeable again, the device replace
 		 * operation continues.
 		 */
-//		WARN_ON(1);
 	}
 }
 
@@ -134,7 +127,6 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		       unsigned int line, int errno, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
-	char nbuf[16];
 	const char *errstr;
 
 	/*
@@ -144,7 +136,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
   		return;
 
-  	errstr = btrfs_decode_error(errno, nbuf);
+	errstr = btrfs_decode_error(errno);
 	if (fmt) {
 		struct va_format vaf;
 		va_list args;
@@ -153,12 +145,12 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s (%pV)\n",
-			sb->s_id, function, line, errstr, &vaf);
+		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s (%pV)\n",
+			sb->s_id, function, line, errno, errstr, &vaf);
 		va_end(args);
 	} else {
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s\n",
-			sb->s_id, function, line, errstr);
+		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s\n",
+			sb->s_id, function, line, errno, errstr);
 	}
 
 	/* Don't go through full error handling during mount */
@@ -247,17 +239,23 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
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
 	if (!trans->blocks_used) {
-		char nbuf[16];
 		const char *errstr;
 
-		errstr = btrfs_decode_error(errno, nbuf);
+		errstr = btrfs_decode_error(errno);
 		btrfs_printk(root->fs_info,
-			     "%s:%d: Aborting unused transaction(%s).\n",
+			     "%s:%d: Aborting unused transaction (%s)\n",
 			     function, line, errstr);
 		return;
 	}
@@ -271,7 +269,6 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...)
 {
-	char nbuf[16];
 	char *s_id = "<unknown>";
 	const char *errstr;
 	struct va_format vaf = { .fmt = fmt };
@@ -283,13 +280,13 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 	va_start(args, fmt);
 	vaf.va = &args;
 
-	errstr = btrfs_decode_error(errno, nbuf);
+	errstr = btrfs_decode_error(errno);
 	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
-		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
-			s_id, function, line, &vaf, errstr);
+		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+			s_id, function, line, &vaf, errno, errstr);
 
-	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
-	       s_id, function, line, &vaf, errstr);
+	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+	       s_id, function, line, &vaf, errno, errstr);
 	va_end(args);
 	/* Caller calls BUG() */
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

