Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54565 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933851AbeAJQcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:32:17 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D6C4AE36
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 16:32:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH RESEND 2/4] btrfs: Remove code referencing unused TRANS_USERSPACE
Date: Wed, 10 Jan 2018 18:32:11 +0200
Message-Id: <1515601933-27331-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1515601933-27331-1-git-send-email-nborisov@suse.com>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that the userspace transaction ioctls have been removed,
TRANS_USERSPACE is no longer used hence we can remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 27 ++++++---------------------
 fs/btrfs/transaction.h |  5 +----
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04f07144b45c..d61d1fd59ccd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -37,22 +37,16 @@
 
 static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_RUNNING]		= 0U,
-	[TRANS_STATE_BLOCKED]		= (__TRANS_USERSPACE |
-					   __TRANS_START),
-	[TRANS_STATE_COMMIT_START]	= (__TRANS_USERSPACE |
-					   __TRANS_START |
-					   __TRANS_ATTACH),
-	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_USERSPACE |
-					   __TRANS_START |
+	[TRANS_STATE_BLOCKED]		=  __TRANS_START,
+	[TRANS_STATE_COMMIT_START]	= (__TRANS_START | __TRANS_ATTACH),
+	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN),
-	[TRANS_STATE_UNBLOCKED]		= (__TRANS_USERSPACE |
-					   __TRANS_START |
+	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
 					   __TRANS_JOIN_NOLOCK),
-	[TRANS_STATE_COMPLETED]		= (__TRANS_USERSPACE |
-					   __TRANS_START |
+	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
 					   __TRANS_JOIN_NOLOCK),
@@ -449,9 +443,6 @@ static int may_wait_transaction(struct btrfs_fs_info *fs_info, int type)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		return 0;
 
-	if (type == TRANS_USERSPACE)
-		return 1;
-
 	if (type == TRANS_START &&
 	    !atomic_read(&fs_info->open_ioctl_trans))
 		return 1;
@@ -593,7 +584,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 got_it:
 	btrfs_record_root_in_trans(h, root);
 
-	if (!current->journal_info && type != TRANS_USERSPACE)
+	if (!current->journal_info)
 		current->journal_info = h;
 	return h;
 
@@ -678,12 +669,6 @@ struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root
 				 BTRFS_RESERVE_NO_FLUSH, true);
 }
 
-struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)
-{
-	return start_transaction(root, 0, TRANS_USERSPACE,
-				 BTRFS_RESERVE_NO_FLUSH, true);
-}
-
 /*
  * btrfs_attach_transaction() - catch the running transaction
  *
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 6beee072b1bd..8bc25c7cca7b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -89,21 +89,18 @@ struct btrfs_transaction {
 
 #define __TRANS_FREEZABLE	(1U << 0)
 
-#define __TRANS_USERSPACE	(1U << 8)
 #define __TRANS_START		(1U << 9)
 #define __TRANS_ATTACH		(1U << 10)
 #define __TRANS_JOIN		(1U << 11)
 #define __TRANS_JOIN_NOLOCK	(1U << 12)
 #define __TRANS_DUMMY		(1U << 13)
 
-#define TRANS_USERSPACE		(__TRANS_USERSPACE | __TRANS_FREEZABLE)
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
 #define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
 
-#define TRANS_EXTWRITERS	(__TRANS_USERSPACE | __TRANS_START |	\
-				 __TRANS_ATTACH)
+#define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
 
 #define BTRFS_SEND_TRANS_STUB	((void *)1)
 
-- 
2.7.4

