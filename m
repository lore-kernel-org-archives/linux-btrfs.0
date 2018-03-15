Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbeCOMgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:37 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B862AAE08
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:36 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/8] btrfs: remove max_active var from open_ctree
Date: Thu, 15 Mar 2018 14:36:26 +0200
Message-Id: <1521117389-13712-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduced by 5cdc7ad337fb ("btrfs: Replace fs_info->workers with
btrfs_workqueue.") but obsoleted by 2a4581983f90 ("btrfs: factor
btrfs_init_workqueues() out of open_ctree()")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 156116655a32..3809d6d66f6a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2390,7 +2390,6 @@ int open_ctree(struct super_block *sb,
 	int err = -EINVAL;
 	int num_backups_tried = 0;
 	int backup_index = 0;
-	u32 max_active;
 	int clear_free_space_tree = 0;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
@@ -2699,8 +2698,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	max_active = fs_info->thread_pool_size;
-
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
 		err = ret;
-- 
2.7.4

