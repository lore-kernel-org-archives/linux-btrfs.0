Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEDHxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 03:53:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E4004ACDD
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 07:53:06 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove devid parameter from btrfs_rmap_block
Date: Fri,  4 May 2018 10:53:05 +0300
Message-Id: <1525420385-19112-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used in only one place and devid argument is always
passed 0. So just remove it, similarly to how it was removed in the
userspace code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/volumes.c     | 7 ++-----
 fs/btrfs/volumes.h     | 5 ++---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2f16b68fcbf..1776d06e1f48 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -256,7 +256,7 @@ static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = btrfs_rmap_block(fs_info, cache->key.objectid,
-				       bytenr, 0, &logical, &nr, &stripe_len);
+				       bytenr, &logical, &nr, &stripe_len);
 		if (ret)
 			return ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 292266f6ab9c..c2664c65b270 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6034,9 +6034,8 @@ int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret, 0, 1);
 }
 
-int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
-		     u64 chunk_start, u64 physical, u64 devid,
-		     u64 **logical, int *naddrs, int *stripe_len)
+int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
+		     u64 physical, u64 **logical, int *naddrs, int *stripe_len)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -6068,8 +6067,6 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 	BUG_ON(!buf); /* -ENOMEM */
 
 	for (i = 0; i < map->num_stripes; i++) {
-		if (devid && map->stripes[i].dev->devid != devid)
-			continue;
 		if (map->stripes[i].physical > physical ||
 		    map->stripes[i].physical + length <= physical)
 			continue;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 79096884654f..4bc799432064 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -393,9 +393,8 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
 		     struct btrfs_bio **bbio_ret);
-int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
-		     u64 chunk_start, u64 physical, u64 devid,
-		     u64 **logical, int *naddrs, int *stripe_len);
+int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
+		     u64 physical, u64 **logical, int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-- 
2.7.4

