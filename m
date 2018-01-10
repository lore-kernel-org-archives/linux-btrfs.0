Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934224AbeAJQcS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:32:18 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F0D83AE82
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 16:32:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH RESEND 4/4] btrfs: Remove btrfs_fs_info::open_ioctl_trans
Date: Wed, 10 Jan 2018 18:32:13 +0200
Message-Id: <1515601933-27331-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1515601933-27331-1-git-send-email-nborisov@suse.com>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
 <1515601933-27331-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since userspace transaction have been removed we no longer have use
for this field so delete it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 9 +++------
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dc679246b8e8..57a0d0b0ea74 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -877,7 +877,6 @@ struct btrfs_fs_info {
 	struct rb_root tree_mod_log;
 
 	atomic_t async_delalloc_pages;
-	atomic_t open_ioctl_trans;
 
 	/*
 	 * this is used to protect the following list -- ordered_roots.
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8d51e4bb67c1..dcb059a46b77 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4329,8 +4329,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 
 		/* commit the current transaction and try again */
 commit_trans:
-		if (need_commit &&
-		    !atomic_read(&fs_info->open_ioctl_trans)) {
+		if (need_commit) {
 			need_commit--;
 
 			if (need_commit > 0) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d61d1fd59ccd..c5ef42318058 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -443,8 +443,7 @@ static int may_wait_transaction(struct btrfs_fs_info *fs_info, int type)
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		return 0;
 
-	if (type == TRANS_START &&
-	    !atomic_read(&fs_info->open_ioctl_trans))
+	if (type == TRANS_START)
 		return 1;
 
 	return 0;
@@ -774,8 +773,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid)
 
 void btrfs_throttle(struct btrfs_fs_info *fs_info)
 {
-	if (!atomic_read(&fs_info->open_ioctl_trans))
-		wait_current_trans(fs_info);
+	wait_current_trans(fs_info);
 }
 
 static int should_end_transaction(struct btrfs_trans_handle *trans)
@@ -857,8 +855,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_chunk_metadata(trans);
 
-	if (lock && !atomic_read(&info->open_ioctl_trans) &&
-	    should_end_transaction(trans) &&
+	if (lock && should_end_transaction(trans) &&
 	    READ_ONCE(cur_trans->state) == TRANS_STATE_RUNNING) {
 		spin_lock(&info->trans_lock);
 		if (cur_trans->state == TRANS_STATE_RUNNING)
-- 
2.7.4

