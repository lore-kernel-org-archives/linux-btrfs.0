Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab2E2U6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 16:58:24 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4TKwOL4020599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:58:24 -0400
Received: from localhost.localdomain.com (vpn-10-107.rdu.redhat.com [10.11.10.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4TKwNaw002944
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:58:24 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check to see if the inode is in the log before fsyncing
Date: Tue, 29 May 2012 16:58:23 -0400
Message-Id: <1338325103-9245-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have this check down in the actual logging code, but this is after we
start a transaction and all that good stuff.  So move the helper
inode_in_log() out so we can call it in fsync() and avoid starting a
transaction altogether and just exit if we've already fsync()'ed this file
recently.  You would notice this issue if you fsync()'ed a file over and
over again until the transaction committed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |   13 +++++++++++++
 fs/btrfs/file.c        |    3 ++-
 fs/btrfs/tree-log.c    |   17 +----------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ce2c9d6..e616f887 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -199,4 +199,17 @@ static inline bool btrfs_is_free_space_inode(struct btrfs_root *root,
 	return false;
 }
 
+static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	mutex_lock(&root->log_mutex);
+	if (BTRFS_I(inode)->logged_trans == generation &&
+	    BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
+		ret = 1;
+	mutex_unlock(&root->log_mutex);
+	return ret;
+}
+
 #endif
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5a525d0..70dc8ca 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1552,7 +1552,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * syncing
 	 */
 	smp_mb();
-	if (BTRFS_I(inode)->last_trans <=
+	if (btrfs_inode_in_log(inode, root->fs_info->generation) ||
+	    BTRFS_I(inode)->last_trans <=
 	    root->fs_info->last_trans_committed) {
 		BTRFS_I(inode)->last_trans = 0;
 		mutex_unlock(&inode->i_mutex);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6f22a4f..425014b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3038,21 +3038,6 @@ out:
 	return ret;
 }
 
-static int inode_in_log(struct btrfs_trans_handle *trans,
-		 struct inode *inode)
-{
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	int ret = 0;
-
-	mutex_lock(&root->log_mutex);
-	if (BTRFS_I(inode)->logged_trans == trans->transid &&
-	    BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
-		ret = 1;
-	mutex_unlock(&root->log_mutex);
-	return ret;
-}
-
-
 /*
  * helper function around btrfs_log_inode to make sure newly created
  * parent directories also end up in the log.  A minimal inode and backref
@@ -3093,7 +3078,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
-	if (inode_in_log(trans, inode)) {
+	if (btrfs_inode_in_log(inode, trans->transid)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;
 	}
-- 
1.7.7.6

