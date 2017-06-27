Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38885 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752413AbdF0NZ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 09:25:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D19FAB9D
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 13:25:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: remove unused sectorsize member
Date: Tue, 27 Jun 2017 16:25:52 +0300
Message-Id: <1498569952-672-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1498488155-9941-1-git-send-email-nborisov@suse.com>
References: <1498488155-9941-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The sectorsize member of btrfs_block_group_cache is unused. So remove it, this
reduces the number of holes in the struct.

With patch:
/* size: 856, cachelines: 14, members: 40 */
/* sum members: 837, holes: 4, sum holes: 19 */
/* bit holes: 1, sum bit holes: 29 bits */
/* last cacheline: 24 bytes */

Without patch:
/* size: 864, cachelines: 14, members: 41 */
/* sum members: 841, holes: 5, sum holes: 23 */
/* bit holes: 1, sum bit holes: 29 bits */
/* last cacheline: 32 bytes */
---

Changes since v1: 
 * Missed the usage in btrfs-tests.c

 fs/btrfs/ctree.h             | 1 -
 fs/btrfs/extent-tree.c       | 1 -
 fs/btrfs/tests/btrfs-tests.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a75a23f9d68e..cdd3775e930b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -559,7 +559,6 @@ struct btrfs_block_group_cache {
 	u64 bytes_super;
 	u64 flags;
 	u64 cache_generation;
-	u32 sectorsize;
 
 	/*
 	 * If the free space extent count exceeds this number, convert the block
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a08a743a8e09..2a0d300c7d1a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9904,7 +9904,6 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 	cache->key.offset = size;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 
-	cache->sectorsize = fs_info->sectorsize;
 	cache->fs_info = fs_info;
 	cache->full_stripe_len = btrfs_full_stripe_len(fs_info,
 						       &fs_info->mapping_tree,
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index b18ab8f327a5..d3f25376a0f8 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -211,7 +211,6 @@ btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_info,
 	cache->key.objectid = 0;
 	cache->key.offset = length;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = fs_info->sectorsize;
 	cache->full_stripe_len = fs_info->sectorsize;
 	cache->fs_info = fs_info;
 
-- 
2.7.4

