Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3656 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756550AbbGGIPs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 5/7] btrfs-progs: extent-tree: Introduce functions to free in-memory block group cache
Date: Tue, 7 Jul 2015 16:15:26 +0800
Message-ID: <1436256928-23812-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce two functions, free_space_info and free_block_group_cache.

The former will free the space of a empty block group.
The latter will free the in memory block group cache along with its
space in space_info and device space.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index 499838c..39d6288 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1801,6 +1801,30 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 
 }
 
+static int free_space_info(struct btrfs_fs_info *fs_info, u64 flags,
+                          u64 total_bytes, u64 bytes_used,
+                          struct btrfs_space_info **space_info)
+{
+	struct btrfs_space_info *found;
+	/* only support free block group which is empty */
+	if (bytes_used)
+		return -ENOTTY;
+
+	found = __find_space_info(fs_info, flags);
+	if (!found)
+		return -ENOENT;
+	if (found->total_bytes < total_bytes) {
+		fprintf(stderr,
+			"warning, bad space info to free %llu only have %llu\n",
+			total_bytes, found->total_bytes);
+		return -EINVAL;
+	}
+	found->total_bytes -= total_bytes;
+	if (space_info)
+		*space_info = found;
+	return 0;
+}
+
 static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     struct btrfs_space_info **space_info)
@@ -3643,6 +3667,82 @@ out:
 	return ret;
 }
 
+static u64 get_dev_extent_len(struct map_lookup *map)
+{
+	int div;
+
+	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* Single */
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID1:
+		div = 1;
+		break;
+	case BTRFS_BLOCK_GROUP_RAID5:
+		div = (map->num_stripes - 1);
+		break;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		div = (map->num_stripes - 2);
+		break;
+	case BTRFS_BLOCK_GROUP_RAID10:
+		div = (map->num_stripes / map->sub_stripes);
+		break;
+	default:
+		/* normally, read chunk security hook should handled it */
+		BUG_ON(1);
+	}
+	return map->ce.size / div;
+}
+
+/* free block group/chunk related caches */
+static int free_block_group_cache(struct btrfs_trans_handle *trans,
+				  struct btrfs_fs_info *fs_info,
+				  u64 bytenr, u64 len)
+{
+	struct btrfs_block_group_cache *cache;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	int ret;
+	int i;
+	u64 flags;
+
+	/* Free block group cache first */
+	cache = btrfs_lookup_block_group(fs_info, bytenr);
+	if (!cache)
+		return -ENOENT;
+	flags = cache->flags;
+	if (cache->free_space_ctl) {
+		btrfs_remove_free_space_cache(cache);
+		kfree(cache->free_space_ctl);
+	}
+	clear_extent_bits(&fs_info->block_group_cache, bytenr, bytenr + len,
+			  (unsigned int)-1, GFP_NOFS);
+	ret = free_space_info(fs_info, flags, len, 0, NULL);
+	if (ret < 0)
+		goto out;
+	kfree(cache);
+
+	/* Then free mapping info and dev usage info */
+	ce = search_cache_extent(&fs_info->mapping_tree.cache_tree, bytenr);
+	if (!ce || ce->start != bytenr) {
+		ret = -ENOENT;
+		goto out;
+	}
+	map = container_of(ce, struct map_lookup, ce);
+	for (i = 0; i < map->num_stripes; i++) {
+		struct btrfs_device *device;
+
+		device = map->stripes[i].dev;
+		device->bytes_used -= get_dev_extent_len(map);
+		ret = btrfs_update_device(trans, device);
+		if (ret < 0)
+			goto out;
+	}
+	remove_cache_extent(&fs_info->mapping_tree.cache_tree, ce);
+	free(map);
+out:
+	return ret;
+}
+
 /*
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
-- 
2.4.4

