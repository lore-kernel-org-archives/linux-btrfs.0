Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56385 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754581AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0B65DADD2
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 12/14] btrfs: Remove fs_info argument from create_pending_snapshots/create_pending_snapshot
Date: Wed,  7 Feb 2018 17:55:48 +0200
Message-Id: <1518018950-31456-13-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass the trans handle which has a reference to fs_info to
create_pending_snapshot so we can refer to it directly. Doing this
obviates the need to pass the fs_info to create_pending_snapshots as
well. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 81143ac1d88d..abee26b269a1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1435,9 +1435,10 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
  * the creation of the pending snapshots, just return 0.
  */
 static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   struct btrfs_pending_snapshot *pending)
 {
+
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key key;
 	struct btrfs_root_item *new_root_item;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -1704,8 +1705,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 /*
  * create all the snapshots we've scheduled for creation
  */
-static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
-					     struct btrfs_fs_info *fs_info)
+static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_pending_snapshot *pending, *next;
 	struct list_head *head = &trans->transaction->pending_snapshots;
@@ -1713,7 +1713,7 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 
 	list_for_each_entry_safe(pending, next, head, list) {
 		list_del(&pending->list);
-		ret = create_pending_snapshot(trans, fs_info, pending);
+		ret = create_pending_snapshot(trans, pending);
 		if (ret)
 			break;
 	}
@@ -2110,7 +2110,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * deal with them in create_pending_snapshot(), which is the
 	 * core function of the snapshot creation.
 	 */
-	ret = create_pending_snapshots(trans, fs_info);
+	ret = create_pending_snapshots(trans);
 	if (ret) {
 		mutex_unlock(&fs_info->reloc_mutex);
 		goto scrub_continue;
-- 
2.7.4

