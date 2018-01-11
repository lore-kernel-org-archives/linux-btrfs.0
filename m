Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750892AbeAKFKX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:23 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CC3C148AEA1C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:16 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 54/67] btrfs-progs: add the stack prefix for super_total_bytes set/get function
Date: Thu, 11 Jan 2018 13:09:26 +0800
Message-ID: <20180111050939.21251-55-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_total_bytes set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c              | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 cmds-inspect-dump-tree.c  | 2 +-
 convert/common.c          | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 2 +-
 extent-tree.c             | 2 +-
 mkfs/common.c             | 2 +-
 mkfs/main.c               | 3 ++-
 utils.c                   | 5 +++--
 volumes.c                 | 7 ++++---
 11 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 40be3c7b..5d4c2339 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11271,7 +11271,7 @@ static bool is_super_size_valid(struct btrfs_fs_info *fs_info)
 	struct btrfs_device *dev;
 	struct list_head *dev_list = &fs_info->fs_devices->devices;
 	u64 total_bytes = 0;
-	u64 super_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	u64 super_bytes = btrfs_stack_super_total_bytes(fs_info->super_copy);
 
 	list_for_each_entry(dev, dev_list, dev_list)
 		total_bytes += dev->total_bytes;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 3e23184c..7855f8ce 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -390,7 +390,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("log_root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_log_root_level(sb));
 	printf("total_bytes\t\t%llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(sb));
+	       (unsigned long long)btrfs_stack_super_total_bytes(sb));
 	printf("bytes_used\t\t%llu\n",
 	       (unsigned long long)btrfs_super_bytes_used(sb));
 	printf("sectorsize\t\t%llu\n",
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 92aec858..43cd1648 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -575,7 +575,7 @@ no_node:
 		print_old_roots(info->super_copy);
 
 	printf("total bytes %llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(info->super_copy));
+	(unsigned long long)btrfs_stack_super_total_bytes(info->super_copy));
 	printf("bytes used %llu\n",
 	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
 	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
diff --git a/convert/common.c b/convert/common.c
index 44944e4e..6f994699 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -120,7 +120,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_super_generation(super, 1);
 	btrfs_set_stack_super_root(super, root_bytenr);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
-	btrfs_set_super_total_bytes(super, cfg->num_bytes);
+	btrfs_set_stack_super_total_bytes(super, cfg->num_bytes);
 	/*
 	 * Temporary filesystem will only have 6 tree roots:
 	 * chunk tree, root tree, extent_tree, device tree, fs tree
diff --git a/ctree.h b/ctree.h
index 3fe38461..5df2f9d8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2184,7 +2184,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
-BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(super_bytes_used, struct btrfs_super_block,
 			 bytes_used, 64);
diff --git a/disk-io.c b/disk-io.c
index 1d55bf22..c6adb168 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1358,7 +1358,7 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		error("sectorsize unaligned: %u", btrfs_super_sectorsize(sb));
 		goto error_out;
 	}
-	if (btrfs_super_total_bytes(sb) == 0) {
+	if (btrfs_stack_super_total_bytes(sb) == 0) {
 		error("invalid total_bytes 0");
 		goto error_out;
 	}
diff --git a/extent-tree.c b/extent-tree.c
index f4ca2348..a59761e3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3400,7 +3400,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 
 	block_group_cache = &fs_info->block_group_cache;
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	total_bytes = btrfs_stack_super_total_bytes(fs_info->super_copy);
 	group_align = 64 * fs_info->sectorsize;
 
 	cur_start = 0;
diff --git a/mkfs/common.c b/mkfs/common.c
index 75f8a5f8..60214c0e 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -164,7 +164,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_generation(&super, 1);
 	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
 	btrfs_set_stack_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
-	btrfs_set_super_total_bytes(&super, num_bytes);
+	btrfs_set_stack_super_total_bytes(&super, num_bytes);
 	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
 	super.__unused_leafsize = cpu_to_le32(cfg->nodesize);
diff --git a/mkfs/main.c b/mkfs/main.c
index 107c391e..0c58181f 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1938,7 +1938,8 @@ raid_groups:
 		printf("Node size:          %u\n", nodesize);
 		printf("Sector size:        %u\n", sectorsize);
 		printf("Filesystem size:    %s\n",
-			pretty_size(btrfs_super_total_bytes(fs_info->super_copy)));
+			pretty_size(btrfs_stack_super_total_bytes(
+					fs_info->super_copy)));
 		printf("Block group profiles:\n");
 		if (allocation.data)
 			printf("  Data:             %-8s %16s\n",
diff --git a/utils.c b/utils.c
index d80e02d1..6787efa1 100644
--- a/utils.c
+++ b/utils.c
@@ -228,8 +228,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	fs_total_bytes = btrfs_super_total_bytes(super) + device_total_bytes;
-	btrfs_set_super_total_bytes(super, fs_total_bytes);
+	fs_total_bytes = btrfs_stack_super_total_bytes(super) +
+				device_total_bytes;
+	btrfs_set_stack_super_total_bytes(super, fs_total_bytes);
 
 	num_devs = btrfs_super_num_devices(super) + 1;
 	btrfs_set_super_num_devices(super, num_devs);
diff --git a/volumes.c b/volumes.c
index 8601dbe6..5ae2aa81 100644
--- a/volumes.c
+++ b/volumes.c
@@ -951,7 +951,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	/* we don't want a chunk larger than 10% of the FS */
-	percent_max = div_factor(btrfs_super_total_bytes(info->super_copy), 1);
+	percent_max = div_factor(btrfs_stack_super_total_bytes(
+					info->super_copy), 1);
 	max_chunk_size = min(percent_max, max_chunk_size);
 
 again:
@@ -2438,7 +2439,7 @@ int btrfs_fix_super_size(struct btrfs_fs_info *fs_info)
 	struct btrfs_device *device;
 	struct list_head *dev_list = &fs_info->fs_devices->devices;
 	u64 total_bytes = 0;
-	u64 old_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	u64 old_bytes = btrfs_stack_super_total_bytes(fs_info->super_copy);
 	int ret;
 
 	list_for_each_entry(device, dev_list, dev_list) {
@@ -2458,7 +2459,7 @@ int btrfs_fix_super_size(struct btrfs_fs_info *fs_info)
 	if (total_bytes == old_bytes)
 		return 0;
 
-	btrfs_set_super_total_bytes(fs_info->super_copy, total_bytes);
+	btrfs_set_stack_super_total_bytes(fs_info->super_copy, total_bytes);
 
 	/* Commit transaction to update all super blocks */
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
-- 
2.15.1



