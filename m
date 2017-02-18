Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34369 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752640AbdBRB3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:21 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/7] Btrfs: do not add extra mirror when dev_replace target dev is not available
Date: Fri, 17 Feb 2017 17:28:19 -0800
Message-Id: <1487381301-865-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this, we can avoid allocating memory for dev replace copies if the
target dev is not available.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c434489..bcd44eb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5153,7 +5153,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	free_extent_map(em);
 
 	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace) &&
+	    fs_info->dev_replace.tgtdev)
 		ret++;
 	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
 
@@ -5858,7 +5859,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 
 	num_alloc_stripes = num_stripes;
-	if (dev_replace_is_ongoing) {
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL) {
 		if (op == BTRFS_MAP_WRITE)
 			num_alloc_stripes <<= 1;
 		if (op == BTRFS_MAP_GET_READ_MIRRORS)
@@ -5871,7 +5872,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (dev_replace_is_ongoing)
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
 		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
 
 	/* build raid_map */
-- 
2.5.5

