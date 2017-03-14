Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35562 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752851AbdCNUfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 16:35:14 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 7/7] Btrfs: convert BUG_ON to WARN_ON
Date: Tue, 14 Mar 2017 13:34:01 -0700
Message-Id: <1489523641-10345-8-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two BUG_ON()s would never be true, ensured by callers' logic.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 10f69d1..61b96ec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5168,7 +5168,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	unsigned long len = fs_info->sectorsize;
 
 	em = get_chunk_map(fs_info, logical, len);
-	BUG_ON(IS_ERR(em));
+	WARN_ON(IS_ERR(em));
 
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
@@ -5185,7 +5185,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	em = get_chunk_map(fs_info, logical, len);
-	BUG_ON(IS_ERR(em));
+	WARN_ON(IS_ERR(em));
 
 	map = em->map_lookup;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-- 
2.5.5

