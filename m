Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754094AbeAKFK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4169149F0E40
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:18 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 57/67] btrfs-progs: add the stack prefix for super_nodesize set/get function
Date: Thu, 11 Jan 2018 13:09:29 +0800
Message-ID: <20180111050939.21251-58-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_nodesize set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c           |  4 ++--
 cmds-check.c              |  6 +++---
 cmds-inspect-dump-super.c |  2 +-
 convert/common.c          |  2 +-
 ctree.h                   |  2 +-
 disk-io.c                 | 13 +++++++------
 find-root.c               |  2 +-
 image/main.c              |  4 ++--
 mkfs/common.c             |  2 +-
 9 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index c91236d4..788b241b 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1476,7 +1476,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
-	fs_info->nodesize = btrfs_super_nodesize(disk_super);
+	fs_info->nodesize = btrfs_stack_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(disk_super, OPEN_CTREE_WRITES);
@@ -1535,7 +1535,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 	}
 
 	rc->sectorsize = btrfs_stack_super_sectorsize(sb);
-	rc->nodesize = btrfs_super_nodesize(sb);
+	rc->nodesize = btrfs_stack_super_nodesize(sb);
 	rc->generation = btrfs_stack_super_generation(sb);
 	rc->chunk_root_generation = btrfs_stack_super_chunk_root_generation(sb);
 	rc->csum_size = btrfs_super_csum_size(sb);
diff --git a/cmds-check.c b/cmds-check.c
index 5d4c2339..6c7f9f76 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12279,7 +12279,7 @@ static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
 	struct btrfs_path path;
 	struct extent_buffer *eb;
 	struct extent_buffer *node;
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nodesize = btrfs_stack_super_nodesize(fs_info->super_copy);
 	int err = 0;
 	int ret;
 
@@ -12656,7 +12656,7 @@ static int check_extent_item(struct btrfs_trans_handle *trans,
 	unsigned long ptr;
 	int slot = path->slots[0];
 	int type;
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nodesize = btrfs_stack_super_nodesize(fs_info->super_copy);
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
@@ -12946,7 +12946,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_chunk *chunk;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nodesize = btrfs_stack_super_nodesize(fs_info->super_copy);
 	u64 flags;
 	u64 bg_flags;
 	u64 used;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 42ee7b2b..7320bc28 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -396,7 +396,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("sectorsize\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_sectorsize(sb));
 	printf("nodesize\t\t%llu\n",
-	       (unsigned long long)btrfs_super_nodesize(sb));
+	       (unsigned long long)btrfs_stack_super_nodesize(sb));
 	printf("leafsize (deprecated)\t\t%u\n",
 	       le32_to_cpu(sb->__unused_leafsize));
 	printf("stripesize\t\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index 307255fa..81fe80df 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -129,7 +129,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_super_bytes_used(super, 6 * cfg->nodesize);
 	btrfs_set_stack_super_sectorsize(super, cfg->sectorsize);
 	super->__unused_leafsize = cpu_to_le32(cfg->nodesize);
-	btrfs_set_super_nodesize(super, cfg->nodesize);
+	btrfs_set_stack_super_nodesize(super, cfg->nodesize);
 	btrfs_set_super_stripesize(super, cfg->stripesize);
 	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
diff --git a/ctree.h b/ctree.h
index 05b88c6a..a8bad6f2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2190,7 +2190,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_bytes_used, struct btrfs_super_block,
 			 bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
diff --git a/disk-io.c b/disk-io.c
index 1bbac5bf..d17c4163 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1163,7 +1163,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 	fs_info->sectorsize = btrfs_stack_super_sectorsize(disk_super);
-	fs_info->nodesize = btrfs_super_nodesize(disk_super);
+	fs_info->nodesize = btrfs_stack_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
 
 	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
@@ -1340,13 +1340,13 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 			btrfs_stack_super_log_root(sb));
 		goto error_out;
 	}
-	if (btrfs_super_nodesize(sb) < 4096) {
+	if (btrfs_stack_super_nodesize(sb) < 4096) {
 		error("nodesize too small: %u < 4096",
-			btrfs_super_nodesize(sb));
+			btrfs_stack_super_nodesize(sb));
 		goto error_out;
 	}
-	if (!IS_ALIGNED(btrfs_super_nodesize(sb), 4096)) {
-		error("nodesize unaligned: %u", btrfs_super_nodesize(sb));
+	if (!IS_ALIGNED(btrfs_stack_super_nodesize(sb), 4096)) {
+		error("nodesize unaligned: %u", btrfs_stack_super_nodesize(sb));
 		goto error_out;
 	}
 	if (btrfs_stack_super_sectorsize(sb) < 4096) {
@@ -1363,7 +1363,8 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		error("invalid total_bytes 0");
 		goto error_out;
 	}
-	if (btrfs_stack_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+	if (btrfs_stack_super_bytes_used(sb) <
+			6 * btrfs_stack_super_nodesize(sb)) {
 		error("invalid bytes_used %llu",
 		      btrfs_stack_super_bytes_used(sb));
 		goto error_out;
diff --git a/find-root.c b/find-root.c
index 7e4c51f6..39ae782d 100644
--- a/find-root.c
+++ b/find-root.c
@@ -110,7 +110,7 @@ int btrfs_find_root_search(struct btrfs_fs_info *fs_info,
 	u64 chunk_offset = 0;
 	u64 chunk_size = 0;
 	u64 offset = 0;
-	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nodesize = btrfs_stack_super_nodesize(fs_info->super_copy);
 	int suppress_errors = 0;
 	int ret = 0;
 
diff --git a/image/main.c b/image/main.c
index a4c5a8ad..1a77de98 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1599,7 +1599,7 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
 	}
 
 	super = (struct btrfs_super_block *)outbuf;
-	mdres->nodesize = btrfs_super_nodesize(super);
+	mdres->nodesize = btrfs_stack_super_nodesize(super);
 	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
 	memcpy(mdres->uuid, super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
@@ -2044,7 +2044,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	pthread_mutex_lock(&mdres->mutex);
 	super = (struct btrfs_super_block *)buffer;
 	chunk_root_bytenr = btrfs_stack_super_chunk_root(super);
-	mdres->nodesize = btrfs_super_nodesize(super);
+	mdres->nodesize = btrfs_stack_super_nodesize(super);
 	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
 	memcpy(mdres->uuid, super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
diff --git a/mkfs/common.c b/mkfs/common.c
index ed491c20..d51f2e15 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -168,7 +168,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_bytes_used(&super, 6 * cfg->nodesize);
 	btrfs_set_stack_super_sectorsize(&super, cfg->sectorsize);
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
-	btrfs_set_super_nodesize(&super, cfg->nodesize);
+	btrfs_set_stack_super_nodesize(&super, cfg->nodesize);
 	btrfs_set_super_stripesize(&super, cfg->stripesize);
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root_generation(&super, 1);
-- 
2.15.1



