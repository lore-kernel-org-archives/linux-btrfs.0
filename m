Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57877 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdJWKvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 06:51:53 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 80CD8AE15
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 10:51:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Make btrfs_async_run_delayed_root use a loop rather than multiple labels
Date: Mon, 23 Oct 2017 13:51:48 +0300
Message-Id: <1508755909-16838-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_async_run_delayed_root's implementation uses 3 goto labels to
mimic the functionality of a simple do {} while loop. Refactor the function
to use a do {} while construct, making intention clear and code easier to
follow. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-inode.c | 52 +++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 19e4ad2f3f2e..1bfdb90d7633 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1323,40 +1323,42 @@ static void btrfs_async_run_delayed_root(struct btrfs_work *work)
 	if (!path)
 		goto out;
 
-again:
-	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND / 2)
-		goto free_path;
+	do {
+		if (atomic_read(&delayed_root->items) <
+		    BTRFS_DELAYED_BACKGROUND / 2)
+			break;
 
-	delayed_node = btrfs_first_prepared_delayed_node(delayed_root);
-	if (!delayed_node)
-		goto free_path;
+		delayed_node = btrfs_first_prepared_delayed_node(delayed_root);
+		if (!delayed_node)
+			break;
 
-	path->leave_spinning = 1;
-	root = delayed_node->root;
+		path->leave_spinning = 1;
+		root = delayed_node->root;
 
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans))
-		goto release_path;
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			btrfs_release_path(path);
+			btrfs_release_prepared_delayed_node(delayed_node);
+			total_done++;
+			continue;
+		}
 
-	block_rsv = trans->block_rsv;
-	trans->block_rsv = &root->fs_info->delayed_block_rsv;
+		block_rsv = trans->block_rsv;
+		trans->block_rsv = &root->fs_info->delayed_block_rsv;
 
-	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
+		__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
 
-	trans->block_rsv = block_rsv;
-	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty_nodelay(root->fs_info);
+		trans->block_rsv = block_rsv;
+		btrfs_end_transaction(trans);
+		btrfs_btree_balance_dirty_nodelay(root->fs_info);
 
-release_path:
-	btrfs_release_path(path);
-	total_done++;
+		btrfs_release_path(path);
+		btrfs_release_prepared_delayed_node(delayed_node);
+		total_done++;
 
-	btrfs_release_prepared_delayed_node(delayed_node);
-	if ((async_work->nr == 0 && total_done < BTRFS_DELAYED_WRITEBACK) ||
-	    total_done < async_work->nr)
-		goto again;
+	} while ((async_work->nr == 0 && total_done < BTRFS_DELAYED_WRITEBACK)
+		 || total_done < async_work->nr);
 
-free_path:
 	btrfs_free_path(path);
 out:
 	wake_up(&delayed_root->wait);
-- 
2.7.4

