Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42022 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2INJAA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 05:00:00 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E8xvRf000621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 08:59:58 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E8xu4A003757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 08:59:57 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E8xuka024712
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 03:59:56 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs: fix deadlock with freeze and sync
Date: Fri, 14 Sep 2012 16:58:03 +0800
Message-Id: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While testing xfstests 068, I realized that

commit bd7de2c9a449e26a5493d918618eb20ae60d56bd
(Btrfs: fix deadlock with freeze and sync V2)

did not fix the bug yet, since someone might jump in between checking
running transaction and joining transaction, and we may still run into
deadlock between freeze and sync.

So IMO the safest and most efficient way is to check running transaction
in joining a transaction directly.

With this patch, I tested xfstests 068 for 120 times and it did not get
into deadlock at least here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/super.c       |    9 +--------
 fs/btrfs/transaction.c |   11 ++++++++++-
 fs/btrfs/transaction.h |    1 +
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index abb9081..02a3961 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -852,14 +852,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	spin_lock(&fs_info->trans_lock);
-	if (!fs_info->running_transaction) {
-		spin_unlock(&fs_info->trans_lock);
-		return 0;
-	}
-	spin_unlock(&fs_info->trans_lock);
-
-	trans = btrfs_join_transaction(root);
+	trans = btrfs_join_transaction_only(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	return btrfs_commit_transaction(trans, root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 27c2600..0c17d9e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -272,6 +272,7 @@ enum btrfs_trans_type {
 	TRANS_JOIN,
 	TRANS_USERSPACE,
 	TRANS_JOIN_NOLOCK,
+	TRANS_JOIN_ONLY,
 };
 
 static int may_wait_transaction(struct btrfs_root *root, int type)
@@ -302,12 +303,15 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		return ERR_PTR(-EROFS);
 
 	if (current->journal_info) {
-		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK);
+		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK &&
+			type != TRANS_JOIN_ONLY);
 		h = current->journal_info;
 		h->use_count++;
 		h->orig_rsv = h->block_rsv;
 		h->block_rsv = NULL;
 		goto got_it;
+	} else if (type == TRANS_JOIN_ONLY) {
+		return ERR_PTR(-ENOENT);
 	}
 
 	/*
@@ -405,6 +409,11 @@ struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root
 	return start_transaction(root, 0, TRANS_JOIN_NOLOCK);
 }
 
+struct btrfs_trans_handle *btrfs_join_transaction_only(struct btrfs_root *root)
+{
+	return start_transaction(root, 0, TRANS_JOIN_ONLY);
+}
+
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_USERSPACE);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e8b8416..59adf55 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -98,6 +98,7 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_join_transaction_only(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

