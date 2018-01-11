Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21049 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751042AbeAKHbJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:09 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 8C79448AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:04 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 06/17] btrfs-progs: lowmem check: introduce force_cow_in_new_chunk()
Date: Thu, 11 Jan 2018 15:35:00 +0800
Message-ID: <20180111073511.25288-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce create_chunk_and_block_block_group() to allocate new chunk
and corresponding block group.

The new function force_cow_in_new_chunk() first allocates new chunk
and records its start.
Then it modifies all metadata block groups cached and full.
Finally it marks the new block group uncached and unfree.
In the next CoW, extents states will be updated automatically by
cache_block_group().

is_chunk_almost_full() is for further patch.
If one chunk is not enough for CoW or uses more than 90% of capacity.
we thinks it's almost full.

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d4bf2175b96d..795e452a4e63 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10927,6 +10927,153 @@ static int clear_block_groups_full(struct btrfs_fs_info *fs_info, u64 flags)
 	return modify_block_groups_cache(fs_info, flags, 0);
 }
 
+static int create_chunk_and_block_group(struct btrfs_fs_info *fs_info,
+					u64 flags, u64 *start, u64 *nbytes)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->extent_root;
+	int ret;
+
+	if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0)
+		return -EINVAL;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("error starting transaction %s", strerror(-ret));
+		return ret;
+	}
+	ret = btrfs_alloc_chunk(trans, fs_info, start, nbytes, flags);
+	if (ret) {
+		error("fail to allocate new chunk %s", strerror(-ret));
+		goto out;
+	}
+	ret = btrfs_make_block_group(trans, fs_info, 0, flags,
+			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, *start, *nbytes);
+	if (ret) {
+		error("fail to make block group for chunk %llu %llu %s",
+		      *start, *nbytes, strerror(-ret));
+		goto out;
+	}
+out:
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
+static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info,
+				  u64 *start_ret)
+{
+	struct btrfs_block_group_cache *bg;
+	u64 start;
+	u64 nbytes;
+	u64 alloc_profile;
+	u64 flags;
+	int ret;
+
+	alloc_profile = (fs_info->avail_metadata_alloc_bits &
+			 fs_info->metadata_alloc_profile);
+	flags = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
+	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS))
+		flags |= BTRFS_BLOCK_GROUP_DATA;
+
+	ret = create_chunk_and_block_group(fs_info, flags, &start, &nbytes);
+	if (ret)
+		goto err;
+	printf("Created new chunk [%llu %llu]\n", start, nbytes);
+
+	flags = BTRFS_BLOCK_GROUP_METADATA;
+	/* Mark all metadata block groups cached and full in free space*/
+	ret = mark_block_groups_full(fs_info, flags);
+	if (ret)
+		goto clear_bgs_full;
+
+	bg = btrfs_lookup_block_group(fs_info, start);
+	if (!bg) {
+		ret = -ENOENT;
+		error("fail to look up block group %llu %llu", start, nbytes);
+		goto clear_bgs_full;
+	}
+
+	/* Clear block group cache just allocated */
+	ret = modify_block_group_cache(fs_info, bg, 0);
+	if (ret)
+		goto clear_bgs_full;
+	if (start_ret)
+		*start_ret = start;
+	return 0;
+
+clear_bgs_full:
+	clear_block_groups_full(fs_info, flags);
+err:
+	return ret;
+}
+
+/*
+ * Returns 0 means not almost full.
+ * Returns >0 means almost full.
+ * Returns <0 means fatal error.
+ */
+static int is_chunk_almost_full(struct btrfs_fs_info *fs_info, u64 start)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_block_group_item *bi;
+	struct btrfs_block_group_item bg_item;
+	struct extent_buffer *eb;
+	u64 used;
+	u64 total;
+	u64 min_free;
+	int ret;
+	int slot;
+
+	key.objectid = start;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (!ret)
+		ret = -EIO;
+	if (ret < 0)
+		goto out;
+	ret = btrfs_previous_item(root, &path, start,
+				  BTRFS_BLOCK_GROUP_ITEM_KEY);
+	if (ret) {
+		error("failed to find block group %llu", start);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	eb = path.nodes[0];
+	slot = path.slots[0];
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	if (key.objectid != start) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	total = key.offset;
+	bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
+	read_extent_buffer(eb, &bg_item, (unsigned long)bi, sizeof(bg_item));
+	used = btrfs_block_group_used(&bg_item);
+
+	/*
+	 * if the free space in the chunk is less than %10 of total,
+	 * or not not enough for CoW once, we think the chunk is almost full.
+	 */
+	min_free = max_t(u64, (BTRFS_MAX_LEVEL + 1) * fs_info->nodesize,
+			 div_factor(total, 1));
+
+	if ((total - used) > min_free)
+		ret = 0;
+	else
+		ret = 1;
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



