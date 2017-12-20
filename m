Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17266 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754429AbdLTExo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:44 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce force_cow_in_new_chunk()
Date: Wed, 20 Dec 2017 12:57:20 +0800
Message-ID: <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
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

Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d98d4bda7357..311c8a9f45e8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10911,6 +10911,86 @@ out:
 	return ret;
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
+static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info)
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
+	if (!ret)
+		printf("Create new chunk %llu %llu\n", start, nbytes);
+	else
+		goto err;
+
+	flags = BTRFS_BLOCK_GROUP_METADATA;
+	/* Mark all metadata block groups cached and full in free space*/
+	ret = modify_block_groups_cache(fs_info, flags, 1);
+	if (ret)
+		goto clear_bg_cache;
+
+	bg = btrfs_lookup_block_group(fs_info, start);
+	if (!bg) {
+		ret = -ENOENT;
+		error("fail to look up block group %llu %llu", start, nbytes);
+		goto clear_bg_cache;
+	}
+
+	/* Clear block group cache just allocated */
+	ret = modify_block_group_cache(fs_info, bg, 0);
+	if (ret)
+		goto clear_bg_cache;
+
+	return 0;
+
+clear_bg_cache:
+	modify_block_groups_cache(fs_info, flags, 0);
+err:
+	return ret;
+}
+
 static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
-- 
2.15.1



