Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387897AbeGTR1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45E72AD65
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/7] btrfs: remove fs_info argument from update_dev_stat_item
Date: Fri, 20 Jul 2018 19:37:49 +0300
Message-Id: <1532104673-28311-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 844e5d4fd3e4..35cc5b6a06e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7035,9 +7035,9 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 }
 
 static int update_dev_stat_item(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
 				struct btrfs_device *device)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -7130,7 +7130,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 		 */
 		smp_rmb();
 
-		ret = update_dev_stat_item(trans, fs_info, device);
+		ret = update_dev_stat_item(trans, device);
 		if (!ret)
 			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
 	}
-- 
2.7.4

