Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48405 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753208AbdHUJn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD78CABF3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/10] btrfs: Remove redundant argument of __link_block_group
Date: Mon, 21 Aug 2017 12:43:50 +0300
Message-Id: <1503308630-6652-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__link_block_group is called from only 2 places and at each call site the
space_info being passed is the same as the space info assigned to the passed
cache struct. Let's remove the redundant argument and make the function
reference the space_info from the passed block_group_cache. No functional
changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1a80f6e58296..6ca75dc62a3c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9886,9 +9886,9 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	return 0;
 }
 
-static void __link_block_group(struct btrfs_space_info *space_info,
-			       struct btrfs_block_group_cache *cache)
+static void __link_block_group(struct btrfs_block_group_cache *cache)
 {
+	struct btrfs_space_info *space_info = cache->space_info;
 	int index = get_block_group_index(cache);
 	bool first = false;
 
@@ -10096,7 +10096,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 
 		cache->space_info = space_info;
 
-		__link_block_group(space_info, cache);
+		__link_block_group(cache);
 
 		set_avail_alloc_bits(info, cache->flags);
 		if (btrfs_chunk_readonly(info, cache->key.objectid)) {
@@ -10255,7 +10255,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 				cache->bytes_super, &cache->space_info);
 	update_global_block_rsv(fs_info);
 
-	__link_block_group(cache->space_info, cache);
+	__link_block_group(cache);
 
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
 
-- 
2.7.4

