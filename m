Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750735AbeAKFK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:29 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id AD81E48AE82D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 45/67] btrfs-progs: add the stack prefix for super_root set/get function
Date: Thu, 11 Jan 2018 13:09:17 +0800
Message-ID: <20180111050939.21251-46-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 3 ++-
 cmds-restore.c            | 3 ++-
 convert/common.c          | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 9 +++++----
 mkfs/common.c             | 2 +-
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index d525fb4f..44dab1bc 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -371,7 +371,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 
 	printf("generation\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_generation(sb));
-	printf("root\t\t\t%llu\n", (unsigned long long)btrfs_super_root(sb));
+	printf("root\t\t\t%llu\n",
+	       (unsigned long long)btrfs_stack_super_root(sb));
 	printf("sys_array_size\t\t%llu\n",
 	       (unsigned long long)btrfs_super_sys_array_size(sb));
 	printf("chunk_root_generation\t%llu\n",
diff --git a/cmds-restore.c b/cmds-restore.c
index 416ff32d..f9e529b6 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1302,7 +1302,8 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 		root = fs_info->tree_root;
 		if (!root_location)
-			root_location = btrfs_super_root(fs_info->super_copy);
+			root_location = btrfs_stack_super_root(
+						fs_info->super_copy);
 		generation = btrfs_stack_super_generation(fs_info->super_copy);
 		root->node = read_tree_block(fs_info, root_location,
 					     generation);
diff --git a/convert/common.c b/convert/common.c
index e509fe5d..bca52547 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -118,7 +118,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_super_num_devices(super, 1);
 	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(super, 1);
-	btrfs_set_super_root(super, root_bytenr);
+	btrfs_set_stack_super_root(super, root_bytenr);
 	btrfs_set_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_total_bytes(super, cfg->num_bytes);
 	/*
diff --git a/ctree.h b/ctree.h
index bf7a4d75..8e21ffa6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2167,7 +2167,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_flags, struct btrfs_super_block, flags,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_generation, struct btrfs_super_block,
 			 generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_super_root, struct btrfs_super_block, root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
diff --git a/disk-io.c b/disk-io.c
index c5c7ee10..7dbac348 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -850,7 +850,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	generation = btrfs_stack_super_generation(sb);
 
 	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
-		root_tree_bytenr = btrfs_super_root(sb);
+		root_tree_bytenr = btrfs_stack_super_root(sb);
 	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
 		struct btrfs_root_backup *backup;
 		int index = find_best_backup_root(sb);
@@ -1324,8 +1324,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		goto error_out;
 	}
 
-	if (!IS_ALIGNED(btrfs_super_root(sb), 4096)) {
-		error("tree_root block unaligned: %llu", btrfs_super_root(sb));
+	if (!IS_ALIGNED(btrfs_stack_super_root(sb), 4096)) {
+		error("tree_root block unaligned: %llu",
+		      btrfs_stack_super_root(sb));
 		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096)) {
@@ -1605,7 +1606,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_super_generation(fs_info->super_copy,
 				   trans->transid);
-	btrfs_set_super_root(fs_info->super_copy,
+	btrfs_set_stack_super_root(fs_info->super_copy,
 			     tree_root->node->start);
 	btrfs_set_super_root_level(fs_info->super_copy,
 				   btrfs_header_level(tree_root->node));
diff --git a/mkfs/common.c b/mkfs/common.c
index 1ebacbc6..33cd5ed9 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -162,7 +162,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_num_devices(&super, 1);
 	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(&super, 1);
-	btrfs_set_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
+	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
 	btrfs_set_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_super_total_bytes(&super, num_bytes);
 	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
-- 
2.15.1



