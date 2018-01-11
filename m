Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754020AbeAKFKX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:23 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A199C48AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:13 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 47/67] btrfs-progs: add the stack prefix for super_chunk_root_generation set/get function
Date: Thu, 11 Jan 2018 13:09:19 +0800
Message-ID: <20180111050939.21251-48-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_chunk_root_generation set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-find-root.c         | 2 +-
 chunk-recover.c           | 2 +-
 cmds-inspect-dump-super.c | 2 +-
 ctree.h                   | 2 +-
 disk-io.c                 | 4 ++--
 mkfs/common.c             | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index df241c97..56179935 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -69,7 +69,7 @@ static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
 		break;
 	case BTRFS_CHUNK_TREE_OBJECTID:
 		level = btrfs_super_chunk_root_level(super);
-		gen = btrfs_super_chunk_root_generation(super);
+		gen = btrfs_stack_super_chunk_root_generation(super);
 		break;
 	case BTRFS_TREE_LOG_OBJECTID:
 		level = btrfs_super_log_root_level(super);
diff --git a/chunk-recover.c b/chunk-recover.c
index df5e2850..a01d4c4f 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1536,7 +1536,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 	rc->sectorsize = btrfs_super_sectorsize(sb);
 	rc->nodesize = btrfs_super_nodesize(sb);
 	rc->generation = btrfs_stack_super_generation(sb);
-	rc->chunk_root_generation = btrfs_super_chunk_root_generation(sb);
+	rc->chunk_root_generation = btrfs_stack_super_chunk_root_generation(sb);
 	rc->csum_size = btrfs_super_csum_size(sb);
 
 	/* if seed, the result of scanning below will be partial */
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 0f28f1c9..49cabca0 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -376,7 +376,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("sys_array_size\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_sys_array_size(sb));
 	printf("chunk_root_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_chunk_root_generation(sb));
+	       (unsigned long long)btrfs_stack_super_chunk_root_generation(sb));
 	printf("root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_super_root_level(sb));
 	printf("chunk_root\t\t%llu\n",
diff --git a/ctree.h b/ctree.h
index 49b047c5..919ada4b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2170,7 +2170,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_generation, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(stack_super_root, struct btrfs_super_block, root, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
-BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
+BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root_generation,
 			 struct btrfs_super_block, chunk_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root_level, struct btrfs_super_block,
 			 root_level, 8);
diff --git a/disk-io.c b/disk-io.c
index b077e8f0..9b3b64c5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1041,7 +1041,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	if (ret)
 		return ret;
 
-	generation = btrfs_super_chunk_root_generation(sb);
+	generation = btrfs_stack_super_chunk_root_generation(sb);
 
 	if (chunk_root_bytenr && !IS_ALIGNED(chunk_root_bytenr,
 					    fs_info->sectorsize)) {
@@ -1615,7 +1615,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 				   chunk_root->node->start);
 	btrfs_set_super_chunk_root_level(fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
-	btrfs_set_super_chunk_root_generation(fs_info->super_copy,
+	btrfs_set_stack_super_chunk_root_generation(fs_info->super_copy,
 				btrfs_header_generation(chunk_root->node));
 
 	ret = write_all_supers(fs_info);
diff --git a/mkfs/common.c b/mkfs/common.c
index 2d31b3e6..fa7abf93 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -171,7 +171,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_nodesize(&super, cfg->nodesize);
 	btrfs_set_super_stripesize(&super, cfg->stripesize);
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
-	btrfs_set_super_chunk_root_generation(&super, 1);
+	btrfs_set_stack_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
 	btrfs_set_super_incompat_flags(&super, cfg->features);
 	if (cfg->label)
-- 
2.15.1



