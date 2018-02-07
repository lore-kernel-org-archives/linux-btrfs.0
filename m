Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56385 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754553AbeBGP4F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78BBAADD5
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/14] btrfs: Don't pass fs_info to __btrfs_run_delayed_items
Date: Wed,  7 Feb 2018 17:55:42 +0200
Message-Id: <1518018950-31456-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass the transactino handle, which contains a refrence to
the fs_info so grab it from there. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1c0bab4080a0..1305872bbff8 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1114,9 +1114,9 @@ __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
  * Returns < 0 on error and returns with an aborted transaction with any
  * outstanding delayed items cleaned up.
  */
-static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info, int nr)
+static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans, int nr)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_delayed_node *curr_node, *prev_node;
 	struct btrfs_path *path;
@@ -1164,13 +1164,13 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info)
 {
-	return __btrfs_run_delayed_items(trans, fs_info, -1);
+	return __btrfs_run_delayed_items(trans, -1);
 }
 
 int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info, int nr)
 {
-	return __btrfs_run_delayed_items(trans, fs_info, nr);
+	return __btrfs_run_delayed_items(trans, nr);
 }
 
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
-- 
2.7.4

