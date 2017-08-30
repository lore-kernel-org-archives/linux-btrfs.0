Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47777 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751485AbdH3Qfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 12:35:46 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove memory barrier from block_group_cache_done
Date: Wed, 30 Aug 2017 19:35:42 +0300
Message-Id: <1504110942-23146-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This memory barrier was introduced in 817d52f8dba2 ("Btrfs: async block group
caching"), but even at that time it's usage was broken since it didn't pair
with anything. There was one situation where the cached member was set to
BTRFS_CACHE_FINISHED in a spinlock region which *might* have acted as a pairing
barrier. Since there is no clear semantics how it's supposed to work better
to just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 21c78c48e15b..10c2ef1a9fd2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -112,7 +112,6 @@ static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
-	smp_mb();
 	return cache->cached == BTRFS_CACHE_FINISHED ||
 		cache->cached == BTRFS_CACHE_ERROR;
 }
-- 
2.7.4

