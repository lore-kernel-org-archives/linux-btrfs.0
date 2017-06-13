Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752019AbdFMJTv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 16/19] btrfs-progs: Refactor btrfs_chunk_readonly to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:32 +0800
Message-ID: <20170613091935.23277-17-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 2 +-
 volumes.c     | 6 +++---
 volumes.h     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 9aa47c55..683cb583 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3286,7 +3286,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			bit = BLOCK_GROUP_METADATA;
 		}
 		set_avail_alloc_bits(info, cache->flags);
-		if (btrfs_chunk_readonly(root, cache->key.objectid))
+		if (btrfs_chunk_readonly(info, cache->key.objectid))
 			cache->ro = 1;
 
 		account_super_bytes(info, cache);
diff --git a/volumes.c b/volumes.c
index 5b3b142d..bdaca19d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1636,11 +1636,11 @@ btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
 	return NULL;
 }
 
-int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
+int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
 	struct cache_extent *ce;
 	struct map_lookup *map;
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	int readonly = 0;
 	int i;
 
@@ -1649,7 +1649,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	 * corresponding chunk, we will rebuild it later
 	 */
 	ce = search_cache_extent(&map_tree->cache_tree, chunk_offset);
-	if (!root->fs_info->is_chunk_recover)
+	if (!fs_info->is_chunk_recover)
 		BUG_ON(!ce);
 	else
 		return 0;
diff --git a/volumes.h b/volumes.h
index 783b3566..44130adb 100644
--- a/volumes.h
+++ b/volumes.h
@@ -232,7 +232,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 struct list_head *btrfs_scanned_uuids(void);
 int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
-int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
+int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset);
 struct btrfs_device *
 btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
 			   u64 devid, int instance);
-- 
2.13.1



