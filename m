Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932691AbdC1Mqc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:46:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 61C76AE17
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 12:46:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: drop redundant parameters from btrfs_map_sblock
Date: Tue, 28 Mar 2017 14:45:22 +0200
Message-Id: <20170328124522.30810-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass 0 for mirror_num and 1 for need_raid_map.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c   | 6 +++---
 fs/btrfs/volumes.c | 6 ++----
 fs/btrfs/volumes.h | 3 +--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb1239f..c1a1fa6e9cce 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1331,7 +1331,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 		 * represents one mirror
 		 */
 		ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
-				logical, &mapped_length, &bbio, 0, 1);
+				logical, &mapped_length, &bbio);
 		if (ret || !bbio || mapped_length < sublen) {
 			btrfs_put_bbio(bbio);
 			return -EIO;
@@ -2188,7 +2188,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	int i;
 
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
-			&length, &bbio, 0, 1);
+			&length, &bbio);
 	if (ret || !bbio || !bbio->raid_map)
 		goto bbio_out;
 
@@ -2776,7 +2776,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 
 	length = sparity->logic_end - sparity->logic_start;
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_WRITE, sparity->logic_start,
-			       &length, &bbio, 0, 1);
+			       &length, &bbio);
 	if (ret || !bbio || !bbio->raid_map)
 		goto bbio_out;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73d56eef5e60..e8e7b1f9b6d9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5886,11 +5886,9 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 /* For Scrub/replace */
 int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
-		     struct btrfs_bio **bbio_ret, int mirror_num,
-		     int need_raid_map)
+		     struct btrfs_bio **bbio_ret)
 {
-	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret,
-				 mirror_num, need_raid_map);
+	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret, 0, 1);
 }
 
 int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 59be81206dd7..a399d40686dc 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -400,8 +400,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		    struct btrfs_bio **bbio_ret, int mirror_num);
 int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
-		     struct btrfs_bio **bbio_ret, int mirror_num,
-		     int need_raid_map);
+		     struct btrfs_bio **bbio_ret);
 int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
-- 
2.12.0

