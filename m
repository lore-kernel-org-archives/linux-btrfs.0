Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754574AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41DCBADCB
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:05 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/14] btrfs: Don't pass fs_info to commit_cowonly_roots
Date: Wed,  7 Feb 2018 17:55:45 +0200
Message-Id: <1518018950-31456-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass a transaction handle which refrences the fs_info so
we can grab it from there. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d58c4cf461f3..354143e6d440 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1160,9 +1160,9 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
  * failures will cause the file system to go offline. We still need
  * to clean up the delayed refs.
  */
-static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info)
+static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct list_head *dirty_bgs = &trans->transaction->dirty_bgs;
 	struct list_head *io_bgs = &trans->transaction->io_bgs;
 	struct list_head *next;
@@ -1402,7 +1402,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 * like chunk and root tree, as they won't affect qgroup.
 	 * And we don't write super to avoid half committed status.
 	 */
-	ret = commit_cowonly_roots(trans, fs_info);
+	ret = commit_cowonly_roots(trans);
 	if (ret)
 		goto out;
 	switch_commit_roots(trans->transaction, fs_info);
@@ -2202,7 +2202,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	ret = commit_cowonly_roots(trans, fs_info);
+	ret = commit_cowonly_roots(trans);
 	if (ret) {
 		mutex_unlock(&fs_info->tree_log_mutex);
 		mutex_unlock(&fs_info->reloc_mutex);
-- 
2.7.4

