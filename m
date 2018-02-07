Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754382AbeBGP4H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:07 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88F0AACFB
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 14/14] btrfs: Remove fs_info argument of btrfs_write_and_wait_transaction
Date: Wed,  7 Feb 2018 17:55:50 +0200
Message-Id: <1518018950-31456-15-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass btrfs_trans_handle which contains a reference to the
fs_info so use that. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b8dbe4e88631..a57065f022ff 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1091,10 +1091,10 @@ int btrfs_wait_tree_log_extents(struct btrfs_root *log_root, int mark)
  *
  * @trans: transaction whose dirty pages we'd like to write
  */
-static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-					    struct btrfs_fs_info *fs_info)
+static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans)
 {
 	struct extent_io_tree *dirty_pages = &trans->transaction->dirty_pages;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct blk_plug plug;
 	int ret, ret2;
 
@@ -1406,7 +1406,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 	switch_commit_roots(trans->transaction);
-	ret = btrfs_write_and_wait_transaction(trans, fs_info);
+	ret = btrfs_write_and_wait_transaction(trans);
 	if (ret)
 		btrfs_handle_fs_error(fs_info, ret,
 			"Error while writing out transaction for qgroup");
@@ -2260,7 +2260,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	wake_up(&fs_info->transaction_wait);
 
-	ret = btrfs_write_and_wait_transaction(trans, fs_info);
+	ret = btrfs_write_and_wait_transaction(trans);
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,
 				      "Error while writing out transaction");
-- 
2.7.4

