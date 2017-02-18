Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34367 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdBRB3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 20:29:21 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 7/7] Btrfs: convert BUG_ON to WARN_ON
Date: Fri, 17 Feb 2017 17:28:21 -0800
Message-Id: <1487381301-865-8-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two BUG_ON()s would never be true, ensured by callers' logic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4a334a9..ce74b6c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5170,7 +5170,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	unsigned long len = fs_info->sectorsize;
 
 	em = get_chunk_map(fs_info, logical, len);
-	BUG_ON(IS_ERR(em));
+	WARN_ON(IS_ERR(em));
 
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
@@ -5187,7 +5187,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	em = get_chunk_map(fs_info, logical, len);
-	BUG_ON(IS_ERR(em));
+	WARN_ON(IS_ERR(em));
 
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-- 
2.5.5

