Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:57403 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752113AbcJKJCP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 05:02:15 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix -EINVEL in tree log recovering
Date: Tue, 11 Oct 2016 17:01:14 +0800
Message-Id: <1476176474-15900-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

when tree log recovery, space_cache rebuild or dirty maybe save the cache.
and then replay extent with disk_bytenr and disk_num_bytes,
but disk_bytenr and disk_num_bytes maybe had been use for free space inode,
will lead to -EINVEL.

BTRFS: error in btrfs_replay_log:2446: errno=-22 unknown (Failed to recover log tree)

therefore, we not save cache when tree log recovering.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 665da8f..38b932c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3434,6 +3434,7 @@ again:
 
 	spin_lock(&block_group->lock);
 	if (block_group->cached != BTRFS_CACHE_FINISHED ||
+		block_group->fs_info->log_root_recovering ||
 	    !btrfs_test_opt(root->fs_info, SPACE_CACHE)) {
 		/*
 		 * don't bother trying to write stuff out _if_
-- 
1.9.1

