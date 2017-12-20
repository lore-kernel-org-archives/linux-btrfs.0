Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:24084 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754454AbdLTExs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:48 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 07/17] btrfs-progs: lowmem check: introduce try_avoid_extents_overwrite()
Date: Wed, 20 Dec 2017 12:57:21 +0800
Message-ID: <20171220045731.19343-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Define a global enum extents_operation to record extents are pinned,
excluded or new chunk is allocated for extents.
Although global variable is not so graceful, it simplifies codes much.

New function try_avoid_extents_overwrite() will try to mark block
groups full and allocate a new chunk. If it failed because of no space
or wrong used bytes(fsck-tests/004), then try to exclude metadata
blocks.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 311c8a9f45e8..9042bab93785 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -84,6 +84,15 @@ enum btrfs_check_mode {
 
 static enum btrfs_check_mode check_mode = CHECK_MODE_DEFAULT;
 
+enum lowmem_extents_operation {
+	EXTENTS_PIN,
+	EXTENTS_EXCLUDE,
+	EXTENTS_MARK_BG_FULL,
+	EXTENTS_NONE
+};
+
+static enum lowmem_extents_operation extents_operation = EXTENTS_NONE;
+
 struct extent_backref {
 	struct rb_node node;
 	unsigned int is_data:1;
@@ -13517,6 +13526,98 @@ out:
 	return err;
 }
 
+static void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
+static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	switch (extents_operation) {
+	case EXTENTS_PIN:
+		ret = btrfs_finish_extent_commit(NULL, fs_info->extent_root,
+						 &fs_info->pinned_extents);
+		break;
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
+	if (op == extents_operation)
+		return 0;
+
+	switch (op) {
+	case EXTENTS_PIN:
+		ret = pin_metadata_blocks(fs_info);
+		break;
+	case EXTENTS_EXCLUDE:
+		ret = exclude_metadata_blocks(fs_info);
+		break;
+	case EXTENTS_MARK_BG_FULL:
+		ret = force_cow_in_new_chunk(fs_info);
+		break;
+	case EXTENTS_NONE:
+		ret = 0;
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
+	if (extents_operation != EXTENTS_NONE)
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



