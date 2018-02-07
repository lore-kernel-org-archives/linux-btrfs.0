Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56401 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754582AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF4CEADDA
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:05 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/14] btrfs: Remove fs_info argument from switch_commit_roots
Date: Wed,  7 Feb 2018 17:55:47 +0200
Message-Id: <1518018950-31456-12-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have the fs_info from the passed transaction so use it
directly. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b8fd9fe8a9c1..81143ac1d88d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -126,9 +126,9 @@ static void clear_btree_io_tree(struct extent_io_tree *tree)
 	spin_unlock(&tree->lock);
 }
 
-static noinline void switch_commit_roots(struct btrfs_transaction *trans,
-					 struct btrfs_fs_info *fs_info)
+static noinline void switch_commit_roots(struct btrfs_transaction *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root, *tmp;
 
 	down_write(&fs_info->commit_root_sem);
@@ -1405,7 +1405,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = commit_cowonly_roots(trans);
 	if (ret)
 		goto out;
-	switch_commit_roots(trans->transaction, fs_info);
+	switch_commit_roots(trans->transaction);
 	ret = btrfs_write_and_wait_transaction(trans, fs_info);
 	if (ret)
 		btrfs_handle_fs_error(fs_info, ret,
@@ -2233,7 +2233,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	list_add_tail(&fs_info->chunk_root->dirty_list,
 		      &cur_trans->switch_commits);
 
-	switch_commit_roots(cur_trans, fs_info);
+	switch_commit_roots(cur_trans);
 
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
 	ASSERT(list_empty(&cur_trans->io_bgs));
-- 
2.7.4

