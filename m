Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754110AbeFTMt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:28 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6B604ADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:27 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 27/34] btrfs: Remove fs_info from exclude_super_stripes
Date: Wed, 20 Jun 2018 15:49:09 +0300
Message-Id: <1529498956-4241-28-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed block group

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 196fd467cfac..d3d61e56b61a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -231,9 +231,9 @@ static void free_excluded_extents(struct btrfs_block_group_cache *cache)
 			  start, end, EXTENT_UPTODATE);
 }
 
-static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
-				 struct btrfs_block_group_cache *cache)
+static int exclude_super_stripes(struct btrfs_block_group_cache *cache)
 {
+	struct btrfs_fs_info *fs_info = cache->fs_info;
 	u64 bytenr;
 	u64 *logical;
 	int stripe_len;
@@ -10068,7 +10068,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		 * info has super bytes accounted for, otherwise we'll think
 		 * we have more space than we actually do.
 		 */
-		ret = exclude_super_stripes(info, cache);
+		ret = exclude_super_stripes(cache);
 		if (ret) {
 			/*
 			 * We may have excluded something, so call this just in
@@ -10219,7 +10219,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
 	cache->needs_free_space = 1;
-	ret = exclude_super_stripes(fs_info, cache);
+	ret = exclude_super_stripes(cache);
 	if (ret) {
 		/*
 		 * We may have excluded something, so call this just in
-- 
2.7.4

