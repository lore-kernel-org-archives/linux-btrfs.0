Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24045 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdCNUfN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 16:35:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 5/7] Btrfs: do not add extra mirror when dev_replace target dev is not available
Date: Tue, 14 Mar 2017 13:33:59 -0700
Message-Id: <1489523641-10345-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this, we can avoid allocating memory for dev replace copies if the
target dev is not available.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2fae62c..bc9d6fc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5151,7 +5151,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	free_extent_map(em);
 
 	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
-	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace) &&
+	    fs_info->dev_replace.tgtdev)
 		ret++;
 	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
 
@@ -5839,7 +5840,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 
 	num_alloc_stripes = num_stripes;
-	if (dev_replace_is_ongoing) {
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL) {
 		if (op == BTRFS_MAP_WRITE)
 			num_alloc_stripes <<= 1;
 		if (op == BTRFS_MAP_GET_READ_MIRRORS)
@@ -5852,7 +5853,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (dev_replace_is_ongoing)
+	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
 		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
 
 	/* build raid_map */
-- 
2.5.5

