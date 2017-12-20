Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38594 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754430AbdLTExq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:46 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 05/17] btrfs-progs: lowmem check: introduce modify_block_groups_cache()
Date: Wed, 20 Dec 2017 12:57:19 +0800
Message-ID: <20171220045731.19343-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Excluding or pining all metadata blocks is not time-efficient for large
storage filesystems.
Here is another way to mark all metadata block groups full and allocate
a new chunk for CoW. So new reservered extents never overwrite
extents.

Introduce modify_block_groups_cache() to modify all blocks groups
cache state and set all extents in block groups unfree in free space
cache.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index dd46569f3811..d98d4bda7357 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10828,6 +10828,89 @@ static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 	}
 }
 
+/*
+ * Mark all extents unfree in the block group. And set @block_group->cached
+ * according to @cache.
+ */
+static int modify_block_group_cache(struct btrfs_fs_info *fs_info,
+		    struct btrfs_block_group_cache *block_group, int cache)
+{
+	struct extent_io_tree *free_space_cache = &fs_info->free_space_cache;
+	u64 start = block_group->key.objectid;
+	u64 end = start + block_group->key.offset;
+
+	if (cache && !block_group->cached) {
+		block_group->cached = 1;
+		clear_extent_dirty(free_space_cache, start, end - 1);
+	}
+
+	if (!cache && block_group->cached) {
+		block_group->cached = 0;
+		clear_extent_dirty(free_space_cache, start, end - 1);
+	}
+	return 0;
+}
+
+/*
+ * Modify block groups which have @flags unfree in free space cache.
+ *
+ * @cache: if 0, clear block groups cache state;
+ *         not 0, mark blocks groups cached.
+ */
+static int modify_block_groups_cache(struct btrfs_fs_info *fs_info, u64 flags,
+				     int cache)
+{
+	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct btrfs_block_group_cache *bg_cache;
+	struct btrfs_block_group_item *bi;
+	struct btrfs_block_group_item bg_item;
+	struct extent_buffer *eb;
+	int slot;
+	int ret;
+
+	key.objectid = 0;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		error("fail to search block groups due to %s", strerror(-ret));
+		goto out;
+	}
+
+	while (1) {
+		eb = path.nodes[0];
+		slot = path.slots[0];
+		btrfs_item_key_to_cpu(eb, &key, slot);
+		bg_cache = btrfs_lookup_block_group(fs_info, key.objectid);
+		if (!bg_cache) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
+		read_extent_buffer(eb, &bg_item, (unsigned long)bi,
+				   sizeof(bg_item));
+		if (btrfs_block_group_flags(&bg_item) & flags)
+			modify_block_group_cache(fs_info, bg_cache, cache);
+
+		ret = btrfs_next_item(root, &path);
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
-- 
2.15.1



