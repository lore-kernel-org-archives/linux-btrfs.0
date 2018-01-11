Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21049 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753567AbeAKHbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:11 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id A604348AEA14
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:06 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 07/17] btrfs-progs: lowmem check: introduce try_avoid_extents_overwrite()
Date: Thu, 11 Jan 2018 15:35:01 +0800
Message-ID: <20180111073511.25288-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Define a global enum extents_operation to record extents are excluded
or new chunk is allocated for extents.
Another global u64 last_allocated_chunk records the last chunk start
allocated by lowmem repair.
Although global variable is not so graceful, it simplifies codes much.

New function try_to_force_cow_in_new_chunk() will try to mark block
groups full, allocate a new chunk and records the start.
If the last allocated chunk is almost full, a new chunk will be
allocated.

try_avoid_extents_overwrite() prefer to allocates new chunk first.
If it failed because of no space or wrong used bytes(fsck-tests/004),
then it try to exclude metadata blocks but costs lots of time in
large filesystem.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 795e452a4e63..8ebd1a38a1b9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -84,6 +84,15 @@ enum btrfs_check_mode {
 
 static enum btrfs_check_mode check_mode = CHECK_MODE_DEFAULT;
 
+enum lowmem_extents_operation {
+	EXTENTS_NONE,
+	EXTENTS_EXCLUDE,
+	EXTENTS_MARK_BG_FULL,
+};
+
+static enum lowmem_extents_operation extents_operation = EXTENTS_NONE;
+static u64 last_allocated_chunk;
+
 struct extent_backref {
 	struct rb_node node;
 	unsigned int is_data:1;
@@ -11074,6 +11083,23 @@ out:
 	return ret;
 }
 
+/*
+ * Returns <0 for error.
+ * Returns 0 for success.
+ */
+static int try_to_force_cow_in_new_chunk(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	if (last_allocated_chunk) {
+		ret = is_chunk_almost_full(fs_info, last_allocated_chunk);
+		if (ret <= 0)
+			return ret;
+	}
+	ret = force_cow_in_new_chunk(fs_info, &last_allocated_chunk);
+	return ret;
+}
+
 static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
@@ -13600,6 +13626,92 @@ out:
 	return err;
 }
 
+static void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
+static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	switch (extents_operation) {
+	case EXTENTS_EXCLUDE:
+		cleanup_excluded_extents(fs_info);
+		ret = 0;
+		break;
+	case EXTENTS_MARK_BG_FULL:
+		ret = modify_block_groups_cache(fs_info,
+						BTRFS_BLOCK_GROUP_METADATA, 0);
+		break;
+	case EXTENTS_NONE:
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (!ret)
+		extents_operation = EXTENTS_NONE;
+	return ret;
+}
+
+static int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
+static int exclude_metadata_blocks(struct btrfs_fs_info *fs_info);
+/*
+ * NOTE: Do not call this function during transaction.
+ */
+static int avoid_extents_overwrite(struct btrfs_fs_info *fs_info,
+				   enum lowmem_extents_operation op)
+{
+	int ret;
+
+	if (op == extents_operation && EXTENTS_MARK_BG_FULL != op)
+		return 0;
+
+	switch (op) {
+	case EXTENTS_EXCLUDE:
+		ret = exclude_metadata_blocks(fs_info);
+		break;
+	case EXTENTS_MARK_BG_FULL:
+		ret = try_to_force_cow_in_new_chunk(fs_info);
+		break;
+	case EXTENTS_NONE:
+		ret = end_avoid_extents_overwrite(fs_info);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* extents_operation should be assigned anyway for latter clean up. */
+	extents_operation = op;
+
+	if (ret)
+		end_avoid_extents_overwrite(fs_info);
+	return ret;
+}
+
+static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+	int mixed = btrfs_fs_incompat(fs_info, MIXED_GROUPS);
+
+	if (extents_operation != EXTENTS_NONE &&
+	    extents_operation != EXTENTS_MARK_BG_FULL)
+		return 0;
+	ret = avoid_extents_overwrite(fs_info, EXTENTS_MARK_BG_FULL);
+
+	/*
+	 * If there is no space left to allocate, try to exclude all metadata
+	 * blocks. Mix filesystem is unsupported.
+	 */
+	if (ret && ret == -ENOSPC && !mixed) {
+		printf(
+	"Try to exclude all metadata blcoks and extents, it may be slow\n");
+		ret = avoid_extents_overwrite(fs_info, EXTENTS_EXCLUDE);
+	}
+
+	if (ret)
+		error("failed to avoid extents overwrite %s", strerror(-ret));
+	return ret;
+}
+
 /*
  * Low memory usage version check_chunks_and_extents.
  */
-- 
2.15.1



