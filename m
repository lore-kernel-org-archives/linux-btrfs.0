Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3JGVnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:17 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhH4O030378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:17 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/12] btrfs-progs: remove dead block group checking
Date: Mon,  7 Oct 2013 14:42:59 -0700
Message-Id: <1381182185-10896-7-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't carry around dead code.  If its needed again, it's only a few git
commands away.  This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-check.c | 50 --------------------------------------------------
 1 file changed, 50 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c91cc4a..ebba58e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4937,55 +4937,6 @@ static void free_corrupt_block(struct cache_extent *cache)
 
 FREE_EXTENT_CACHE_BASED_TREE(corrupt_blocks, free_corrupt_block);
 
-static int check_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *info,
-			      struct map_lookup *map,
-			      int *reinit)
-{
-	struct btrfs_key key;
-	struct btrfs_path path;
-	int ret;
-
-	key.objectid = map->ce.start;
-	key.offset = map->ce.size;
-	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-
-	btrfs_init_path(&path);
-	ret = btrfs_search_slot(NULL, info->extent_root,
-				&key, &path, 0, 0);
-	btrfs_release_path(&path);
-	if (ret <= 0)
-		goto out;
-
-	ret = btrfs_make_block_group(trans, info->extent_root, 0, map->type,
-			       BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			       key.objectid, key.offset);
-	*reinit = 1;
-out:
-	return ret;
-}
-
-static int check_block_groups(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *info, int *reinit)
-{
-	struct cache_extent *ce;
-	struct map_lookup *map;
-	struct btrfs_mapping_tree *map_tree = &info->mapping_tree;
-
-	/* this isn't quite working */
-	return 0;
-
-	ce = search_cache_extent(&map_tree->cache_tree, 0);
-	while (1) {
-		if (!ce)
-			break;
-		map = container_of(ce, struct map_lookup, ce);
-		check_block_group(trans, info, map, reinit);
-		ce = next_cache_extent(ce);
-	}
-	return 0;
-}
-
 static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *cache;
@@ -5047,7 +4998,6 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			cache = next_cache_extent(cache);
 		}
 		prune_corrupt_blocks(trans, root->fs_info);
-		check_block_groups(trans, root->fs_info, &reinit);
 		if (reinit)
 			btrfs_read_block_groups(root->fs_info->extent_root);
 		reset_cached_block_groups(root->fs_info);
-- 
1.7.11.7

