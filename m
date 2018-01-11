Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753959AbeAKFKV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:21 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7798648AEA13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:14 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 49/67] btrfs-progs: add the stack prefix for super_chunk_root set/get function
Date: Thu, 11 Jan 2018 13:09:21 +0800
Message-ID: <20180111050939.21251-50-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_chunk_root set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 convert/common.c          | 4 ++--
 ctree.h                   | 2 +-
 disk-io.c                 | 8 ++++----
 image/main.c              | 2 +-
 mkfs/common.c             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 39c8b536..bdc10211 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -380,7 +380,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_root_level(sb));
 	printf("chunk_root\t\t%llu\n",
-	       (unsigned long long)btrfs_super_chunk_root(sb));
+	       (unsigned long long)btrfs_stack_super_chunk_root(sb));
 	printf("chunk_root_level\t%llu\n",
 	       (unsigned long long)btrfs_super_chunk_root_level(sb));
 	printf("log_root\t\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index 58b071c8..44944e4e 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -119,7 +119,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_super_magic(super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(super, 1);
 	btrfs_set_stack_super_root(super, root_bytenr);
-	btrfs_set_super_chunk_root(super, chunk_bytenr);
+	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_total_bytes(super, cfg->num_bytes);
 	/*
 	 * Temporary filesystem will only have 6 tree roots:
@@ -132,7 +132,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_super_nodesize(super, cfg->nodesize);
 	btrfs_set_super_stripesize(super, cfg->stripesize);
 	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
-	btrfs_set_super_chunk_root(super, chunk_bytenr);
+	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_cache_generation(super, -1);
 	btrfs_set_super_incompat_flags(super, cfg->features);
 	if (cfg->label)
diff --git a/ctree.h b/ctree.h
index 3ca18e22..a525f958 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2174,7 +2174,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root_generation,
 			 struct btrfs_super_block, chunk_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_root_level, struct btrfs_super_block,
 			 root_level, 8);
-BTRFS_SETGET_STACK_FUNCS(super_chunk_root, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_chunk_root, struct btrfs_super_block,
 			 chunk_root, 64);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
 			 chunk_root_level, 8);
diff --git a/disk-io.c b/disk-io.c
index e9411681..56de9bd2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1051,7 +1051,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	}
 
 	if (!chunk_root_bytenr)
-		chunk_root_bytenr = btrfs_super_chunk_root(sb);
+		chunk_root_bytenr = btrfs_stack_super_chunk_root(sb);
 	else
 		generation = 0;
 
@@ -1329,9 +1329,9 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		      btrfs_stack_super_root(sb));
 		goto error_out;
 	}
-	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096)) {
+	if (!IS_ALIGNED(btrfs_stack_super_chunk_root(sb), 4096)) {
 		error("chunk_root block unaligned: %llu",
-			btrfs_super_chunk_root(sb));
+			btrfs_stack_super_chunk_root(sb));
 		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096)) {
@@ -1611,7 +1611,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 			     tree_root->node->start);
 	btrfs_set_stack_super_root_level(fs_info->super_copy,
 				   btrfs_header_level(tree_root->node));
-	btrfs_set_super_chunk_root(fs_info->super_copy,
+	btrfs_set_stack_super_chunk_root(fs_info->super_copy,
 				   chunk_root->node->start);
 	btrfs_set_super_chunk_root_level(fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
diff --git a/image/main.c b/image/main.c
index bd10287d..718ab88e 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2043,7 +2043,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	pthread_mutex_lock(&mdres->mutex);
 	super = (struct btrfs_super_block *)buffer;
-	chunk_root_bytenr = btrfs_super_chunk_root(super);
+	chunk_root_bytenr = btrfs_stack_super_chunk_root(super);
 	mdres->nodesize = btrfs_super_nodesize(super);
 	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
 	memcpy(mdres->uuid, super->dev_item.uuid,
diff --git a/mkfs/common.c b/mkfs/common.c
index fa7abf93..75f8a5f8 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -163,7 +163,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_magic(&super, BTRFS_MAGIC_PARTIAL);
 	btrfs_set_stack_super_generation(&super, 1);
 	btrfs_set_stack_super_root(&super, cfg->blocks[MKFS_ROOT_TREE]);
-	btrfs_set_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
+	btrfs_set_stack_super_chunk_root(&super, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_super_total_bytes(&super, num_bytes);
 	btrfs_set_super_bytes_used(&super, 6 * cfg->nodesize);
 	btrfs_set_super_sectorsize(&super, cfg->sectorsize);
-- 
2.15.1



