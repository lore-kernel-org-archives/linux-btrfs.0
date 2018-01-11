Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753620AbeAKFKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 05BE849F0E4A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:22 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 65/67] btrfs-progs: add the stack prefix for super_cache_generation set/get function
Date: Thu, 11 Jan 2018 13:09:37 +0800
Message-ID: <20180111050939.21251-66-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_cache_generation set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c              | 7 ++++---
 cmds-inspect-dump-super.c | 2 +-
 convert/common.c          | 2 +-
 ctree.h                   | 2 +-
 image/main.c              | 2 +-
 mkfs/common.c             | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6c7f9f76..982f9a0e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8646,9 +8646,10 @@ static int check_space_cache(struct btrfs_root *root)
 	int ret;
 	int error = 0;
 
-	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
+	if (btrfs_stack_super_cache_generation(root->fs_info->super_copy) !=
+			-1ULL &&
 	    btrfs_stack_super_generation(root->fs_info->super_copy) !=
-	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
+	    btrfs_stack_super_cache_generation(root->fs_info->super_copy)) {
 		printf("cache and super generation don't match, space cache "
 		       "will be invalidated\n");
 		return 0;
@@ -14552,7 +14553,7 @@ static int clear_free_space_cache(struct btrfs_fs_info *fs_info)
 		error("failed to update super block cache generation");
 		return PTR_ERR(trans);
 	}
-	btrfs_set_super_cache_generation(fs_info->super_copy, (u64)-1);
+	btrfs_set_stack_super_cache_generation(fs_info->super_copy, (u64)-1);
 	btrfs_commit_transaction(trans, fs_info->tree_root);
 
 	return ret;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 5e036536..877b3b77 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -414,7 +414,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_stack_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_stack_super_incompat_flags(sb));
 	printf("cache_generation\t%llu\n",
-	       (unsigned long long)btrfs_super_cache_generation(sb));
+	       (unsigned long long)btrfs_stack_super_cache_generation(sb));
 	printf("uuid_tree_generation\t%llu\n",
 	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
 
diff --git a/convert/common.c b/convert/common.c
index 925c7348..d5ae385f 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -133,7 +133,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_super_stripesize(super, cfg->stripesize);
 	btrfs_set_stack_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
-	btrfs_set_super_cache_generation(super, -1);
+	btrfs_set_stack_super_cache_generation(super, -1);
 	btrfs_set_stack_super_incompat_flags(super, cfg->features);
 	if (cfg->label)
 		__strncpy_null(super->label, cfg->label, BTRFS_LABEL_SIZE - 1);
diff --git a/ctree.h b/ctree.h
index 8639d0c1..a7aacf40 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2206,7 +2206,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
-BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
 			 uuid_tree_generation, 64);
diff --git a/image/main.c b/image/main.c
index 69fca3c3..dcf21025 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1185,7 +1185,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 	}
 
 	if (mdres->clear_space_cache)
-		btrfs_set_super_cache_generation(super, 0);
+		btrfs_set_stack_super_cache_generation(super, 0);
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
 	btrfs_set_stack_super_flags(super, flags);
diff --git a/mkfs/common.c b/mkfs/common.c
index fcc3216f..6046d449 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -172,7 +172,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_stack_super_stripesize(&super, cfg->stripesize);
 	btrfs_set_stack_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root_generation(&super, 1);
-	btrfs_set_super_cache_generation(&super, -1);
+	btrfs_set_stack_super_cache_generation(&super, -1);
 	btrfs_set_stack_super_incompat_flags(&super, cfg->features);
 	if (cfg->label)
 		__strncpy_null(super.label, cfg->label, BTRFS_LABEL_SIZE - 1);
-- 
2.15.1



