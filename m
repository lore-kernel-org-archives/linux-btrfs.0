Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754392AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 013F5ACFB
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:05 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/14] btrfs: Don't pass fs_info to commit_fs_roots
Date: Wed,  7 Feb 2018 17:55:44 +0200
Message-Id: <1518018950-31456-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass the transaction handle which has a reference to the
fs_info. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f24f05fb508e..d58c4cf461f3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1256,9 +1256,9 @@ void btrfs_add_dead_root(struct btrfs_root *root)
 /*
  * update all the cowonly tree roots on disk
  */
-static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
-				    struct btrfs_fs_info *fs_info)
+static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *gang[8];
 	int i;
 	int ret;
@@ -1376,7 +1376,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&fs_info->tree_log_mutex);
 
-	ret = commit_fs_roots(trans, fs_info);
+	ret = commit_fs_roots(trans);
 	if (ret)
 		goto out;
 	ret = btrfs_qgroup_account_extents(trans, fs_info);
@@ -2162,7 +2162,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	mutex_lock(&fs_info->tree_log_mutex);
 
-	ret = commit_fs_roots(trans, fs_info);
+	ret = commit_fs_roots(trans);
 	if (ret) {
 		mutex_unlock(&fs_info->tree_log_mutex);
 		mutex_unlock(&fs_info->reloc_mutex);
-- 
2.7.4

