Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754024AbeAKFK2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:28 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3977E486A78B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 44/67] btrfs-progs: add the stack prefix for super_generation set/get function
Date: Thu, 11 Jan 2018 13:09:16 +0800
Message-ID: <20180111050939.21251-45-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_generation set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         |  2 +-
 chunk-recover.c           |  2 +-
 cmds-check.c              |  2 +-
 cmds-inspect-dump-super.c |  2 +-
 cmds-restore.c            |  2 +-
 convert/common.c          |  2 +-
 ctree.h                   |  2 +-
 disk-io.c                 | 12 ++++++------
 mkfs/common.c             |  2 +-
 super-recover.c           |  4 ++--
 volumes.c                 |  2 +-
 11 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index e2d2e70c..df241c97 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -65,7 +65,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
 		level = btrfs_super_root_level(super);
-		gen = btrfs_super_generation(super);
+		gen = btrfs_stack_super_generation(super);
 		break;
 	case BTRFS_CHUNK_TREE_OBJECTID:
 		level = btrfs_super_chunk_root_level(super);
diff --git a/chunk-recover.c b/chunk-recover.c
index 6734212c..d0a7cfe0 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1535,7 +1535,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 
 	rc->sectorsize = btrfs_super_sectorsize(sb);
 	rc->nodesize = btrfs_super_nodesize(sb);
-	rc->generation = btrfs_super_generation(sb);
+	rc->generation = btrfs_stack_super_generation(sb);
 	rc->chunk_root_generation = btrfs_super_chunk_root_generation(sb);
 	rc->csum_size = btrfs_super_csum_size(sb);
 
diff --git a/cmds-check.c b/cmds-check.c
index 170da424..6218eddb 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8647,7 +8647,7 @@ static int check_space_cache(struct btrfs_root *root)
 	int error = 0;
 
 	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
-	    btrfs_super_generation(root->fs_info->super_copy) !=
+	    btrfs_stack_super_generation(root->fs_info->super_copy) !=
 	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
 		printf("cache and super generation don't match, space cache "
 		       "will be invalidated\n");
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 3a8acd7e..d525fb4f 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -370,7 +370,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	putchar('\n');
 
 	printf("generation\t\t%llu\n",
-	       (unsigned long long)btrfs_super_generation(sb));
+	       (unsigned long long)btrfs_stack_super_generation(sb));
 	printf("root\t\t\t%llu\n", (unsigned long long)btrfs_super_root(sb));
 	printf("sys_array_size\t\t%llu\n",
 	       (unsigned long long)btrfs_super_sys_array_size(sb));
diff --git a/cmds-restore.c b/cmds-restore.c
index 37368766..416ff32d 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1303,7 +1303,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 		root = fs_info->tree_root;
 		if (!root_location)
 			root_location = btrfs_super_root(fs_info->super_copy);
-		generation = btrfs_super_generation(fs_info->super_copy);
+		generation = btrfs_stack_super_generation(fs_info->super_copy);
 		root->node = read_tree_block(fs_info, root_location,
 					     generation);
 		if (!extent_buffer_uptodate(root->node)) {
diff --git a/convert/common.c b/convert/common.c
index 38769081..e509fe5d 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -117,7 +117,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_super_bytenr(super, cfg->super_bytenr);
 	btrfs_set_super_num_devices(super, 1);
 	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
-	btrfs_set_super_generation(super, 1);
+	btrfs_set_stack_super_generation(super, 1);
 	btrfs_set_super_root(super, root_bytenr);
 	btrfs_set_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_total_bytes(super, cfg->num_bytes);
diff --git a/ctree.h b/ctree.h
index fdf274d6..bf7a4d75 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2165,7 +2165,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_bytenr, struct btrfs_super_block, bytenr,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_flags, struct btrfs_super_block, flags,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_generation, struct btrfs_super_block,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
diff --git a/disk-io.c b/disk-io.c
index 3a3275b5..c5c7ee10 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -522,7 +522,7 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 			 BTRFS_TREE_LOG_OBJECTID);
 
 	log_root->node = read_tree_block(fs_info, blocknr,
-				     btrfs_super_generation(disk_super) + 1);
+				btrfs_stack_super_generation(disk_super) + 1);
 
 	fs_info->log_root_tree = log_root;
 
@@ -793,7 +793,7 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
 static int find_best_backup_root(struct btrfs_super_block *super)
 {
 	struct btrfs_root_backup *backup;
-	u64 orig_gen = btrfs_super_generation(super);
+	u64 orig_gen = btrfs_stack_super_generation(super);
 	u64 gen = 0;
 	int best_index = 0;
 	int i;
@@ -847,7 +847,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 
 	root = fs_info->tree_root;
 	btrfs_setup_root(root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
-	generation = btrfs_super_generation(sb);
+	generation = btrfs_stack_super_generation(sb);
 
 	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
 		root_tree_bytenr = btrfs_super_root(sb);
@@ -1486,9 +1486,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			continue;
 		}
 
-		if (btrfs_super_generation(buf) > transid) {
+		if (btrfs_stack_super_generation(buf) > transid) {
 			memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
-			transid = btrfs_super_generation(buf);
+			transid = btrfs_stack_super_generation(buf);
 		}
 	}
 
@@ -1603,7 +1603,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	if (fs_info->readonly)
 		return 0;
 
-	btrfs_set_super_generation(fs_info->super_copy,
+	btrfs_set_stack_super_generation(fs_info->super_copy,
 				   trans->transid);
 	btrfs_set_super_root(fs_info->super_copy,
 			     tree_root->node->start);
diff --git a/mkfs/common.c b/mkfs/common.c
index 1845cb14..1ebacbc6 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -161,7 +161,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_bytenr(&super, cfg->blocks[MKFS_SUPER_BLOCK]);
 	btrfs_set_super_num_devices(&super, 1);
 	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
-	btrfs_set_super_generation(&super, 1);
+	btrfs_set_stack_super_generation(&super, 1);
 	btrfs_set_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
 	btrfs_set_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_super_total_bytes(&super, num_bytes);
diff --git a/super-recover.c b/super-recover.c
index 6b80416f..2a82aa75 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -133,7 +133,7 @@ read_dev_supers(char *filename, struct btrfs_recover_superblock *recover)
 							&recover->good_supers);
 			if (ret)
 				goto out;
-			max_gen = btrfs_super_generation(sb);
+			max_gen = btrfs_stack_super_generation(sb);
 			if (max_gen > recover->max_generation)
 				recover->max_generation = max_gen;
 		} else if (ret == -EIO){
@@ -169,7 +169,7 @@ static int read_fs_supers(struct btrfs_recover_superblock *recover)
 	}
 	list_for_each_entry_safe(record, next_record,
 			&recover->good_supers, list) {
-		gen = btrfs_super_generation(&record->sb);
+		gen = btrfs_stack_super_generation(&record->sb);
 		if (gen < recover->max_generation)
 			list_move_tail(&record->list, &recover->bad_supers);
 	}
diff --git a/volumes.c b/volumes.c
index 90c23582..20203024 100644
--- a/volumes.c
+++ b/volumes.c
@@ -89,7 +89,7 @@ static int device_list_add(const char *path,
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
-	u64 found_transid = btrfs_super_generation(disk_super);
+	u64 found_transid = btrfs_stack_super_generation(disk_super);
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
-- 
2.15.1



