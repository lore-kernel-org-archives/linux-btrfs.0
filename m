Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57879 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751304AbdJWKvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 06:51:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C30E7AE18
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 10:51:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Move checks from btrfs_wq_run_delayed_node to btrfs_balance_delayed_items
Date: Mon, 23 Oct 2017 13:51:49 +0300
Message-Id: <1508755909-16838-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1508755909-16838-1-git-send-email-nborisov@suse.com>
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_balance_delayed_items is the sole caller of btrfs_wq_run_delayed_node and
already includes one of the checks whether the delayed inodes should be run. On
the other hand btrfs_wq_run_delayed_node duplicates that check and performs an
additional one for wq congestion.

Let's remove the duplicate check and move the congestion one in
btrfs_balance_delayed_items, leaving btrfs_wq_run_delayed_node to only care
about setting up the wq run. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1bfdb90d7633..b7a0ec2c41e6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1371,10 +1371,6 @@ static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
 {
 	struct btrfs_async_delayed_work *async_work;
 
-	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND ||
-	    btrfs_workqueue_normal_congested(fs_info->delayed_workers))
-		return 0;
-
 	async_work = kmalloc(sizeof(*async_work), GFP_NOFS);
 	if (!async_work)
 		return -ENOMEM;
@@ -1410,7 +1406,8 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_delayed_root *delayed_root = fs_info->delayed_root;
 
-	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
+	if ((atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND) ||
+		btrfs_workqueue_normal_congested(fs_info->delayed_workers))
 		return;
 
 	if (atomic_read(&delayed_root->items) >= BTRFS_DELAYED_WRITEBACK) {
-- 
2.7.4

