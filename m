Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51932 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2INObm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 10:31:42 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 35ECz1zKvV7Oaxac (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 08:31:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix race in sync and freeze again
Date: Fri, 14 Sep 2012 10:37:06 -0400
Message-ID: <1347633426-13674-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I screwed this up, there is a race between checking if there is a running
transaction and actually starting a transaction in sync where we could race
with a freezer and get ourselves into trouble.  To fix this we need to make
a new join type to only do the try lock on the freeze stuff.  If it fails
we'll return EPERM and just return from sync.  This fixes a hang Liu Bo
reported when running xfstest 68 in a loop.  Thanks,

Reported-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c       |   15 ++++++---------
 fs/btrfs/transaction.c |   12 +++++++++++-
 fs/btrfs/transaction.h |    1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 867e8e7..903ab2d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -854,16 +854,13 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	spin_lock(&fs_info->trans_lock);
-	if (!fs_info->running_transaction) {
-		spin_unlock(&fs_info->trans_lock);
-		return 0;
-	}
-	spin_unlock(&fs_info->trans_lock);
-
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
+	trans = btrfs_join_transaction_freeze(root);
+	if (IS_ERR(trans)) {
+		/* Frozen, don't bother */
+		if (PTR_ERR(trans) == -EPERM)
+			return 0;
 		return PTR_ERR(trans);
+	}
 	return btrfs_commit_transaction(trans, root);
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c01dec7..e4bfac8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -272,6 +272,7 @@ enum btrfs_trans_type {
 	TRANS_JOIN,
 	TRANS_USERSPACE,
 	TRANS_JOIN_NOLOCK,
+	TRANS_JOIN_FREEZE,
 };
 
 static int may_wait_transaction(struct btrfs_root *root, int type)
@@ -341,7 +342,11 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
-	sb_start_intwrite(root->fs_info->sb);
+	if (!__sb_start_write(root->fs_info->sb, SB_FREEZE_FS, false)) {
+		if (type == TRANS_JOIN_FREEZE)
+			return ERR_PTR(-EPERM);
+		sb_start_intwrite(root->fs_info->sb);
+	}
 
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
@@ -424,6 +429,11 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root
 	return start_transaction(root, 0, TRANS_USERSPACE, 0);
 }
 
+struct btrfs_trans_handle *btrfs_join_transaction_freeze(struct btrfs_root *root)
+{
+	return start_transaction(root, 0, TRANS_JOIN_FREEZE, 0);
+}
+
 /* wait for a transaction commit to be fully complete */
 static noinline void wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index b6463e1..fbf8313 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -102,6 +102,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_noflush(
 					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_join_transaction_freeze(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

