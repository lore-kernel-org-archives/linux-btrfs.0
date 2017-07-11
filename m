Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37355 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755513AbdGKN4F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 09:56:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 998EBABD9
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2017 13:56:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Prevent possible ERR_PTR() dereference
Date: Tue, 11 Jul 2017 16:55:51 +0300
Message-Id: <1499781351-3156-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_full_stripe_len/btrfs_is_parity_mirror we have similar code which
gets the chunk map for a particular range via get_chunk_map. However,
get_chunk_map can return an ERR_PTR value and while the 2 callers do catch
this with a WARN_ON they then proceed to indiscriminately dereference the
extent map. This of course leads to a crash. Fix the offenders by making the
dereference conditional on IS_ERR.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c95f018d4a1e..6959177154b0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5180,12 +5180,13 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	unsigned long len = fs_info->sectorsize;
 
 	em = get_chunk_map(fs_info, logical, len);
-	WARN_ON(IS_ERR(em));
 
-	map = em->map_lookup;
-	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-		len = map->stripe_len * nr_data_stripes(map);
-	free_extent_map(em);
+	if (!WARN_ON(IS_ERR(em))) {
+		map = em->map_lookup;
+		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
+			len = map->stripe_len * nr_data_stripes(map);
+		free_extent_map(em);
+	}
 	return len;
 }
 
@@ -5197,12 +5198,13 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	em = get_chunk_map(fs_info, logical, len);
-	WARN_ON(IS_ERR(em));
 
-	map = em->map_lookup;
-	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-		ret = 1;
-	free_extent_map(em);
+	if(!WARN_ON(IS_ERR(em))) {
+		map = em->map_lookup;
+		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
+			ret = 1;
+		free_extent_map(em);
+	}
 	return ret;
 }
 
-- 
2.7.4

