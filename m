Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754113AbeAKFKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1585449F0E48
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:21 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 63/67] btrfs-progs: add the stack prefix for super_incompat_flags set/get function
Date: Thu, 11 Jan 2018 13:09:35 +0800
Message-ID: <20180111050939.21251-64-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_incompat_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfstune.c               | 4 ++--
 cmds-inspect-dump-super.c | 4 ++--
 convert/common.c          | 2 +-
 ctree.h                   | 4 ++--
 disk-io.c                 | 6 +++---
 mkfs/common.c             | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index e502126a..daf7b22a 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -81,11 +81,11 @@ static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 	int ret;
 
 	disk_super = root->fs_info->super_copy;
-	super_flags = btrfs_super_incompat_flags(disk_super);
+	super_flags = btrfs_stack_super_incompat_flags(disk_super);
 	super_flags |= flags;
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_super_incompat_flags(disk_super, super_flags);
+	btrfs_set_stack_super_incompat_flags(disk_super, super_flags);
 	ret = btrfs_commit_transaction(trans, root);
 
 	return ret;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 8c51b6f0..dd6e68fb 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -411,8 +411,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_stack_super_compat_ro_flags(sb));
 	print_readable_compat_ro_flag(btrfs_stack_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_incompat_flags(sb));
-	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
+	       (unsigned long long)btrfs_stack_super_incompat_flags(sb));
+	print_readable_incompat_flag(btrfs_stack_super_incompat_flags(sb));
 	printf("cache_generation\t%llu\n",
 	       (unsigned long long)btrfs_super_cache_generation(sb));
 	printf("uuid_tree_generation\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index ce32e96e..97e9938d 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -134,7 +134,7 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root(super, chunk_bytenr);
 	btrfs_set_super_cache_generation(super, -1);
-	btrfs_set_super_incompat_flags(super, cfg->features);
+	btrfs_set_stack_super_incompat_flags(super, cfg->features);
 	if (cfg->label)
 		__strncpy_null(super->label, cfg->label, BTRFS_LABEL_SIZE - 1);
 
diff --git a/ctree.h b/ctree.h
index 14f2e732..2f1a6be4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2202,7 +2202,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_compat_ro_flags, struct btrfs_super_block,
 			 compat_ro_flags, 64);
-BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
@@ -2448,7 +2448,7 @@ static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 {
 	struct btrfs_super_block *disk_super;
 	disk_super = fs_info->super_copy;
-	return !!(btrfs_super_incompat_flags(disk_super) & flag);
+	return !!(btrfs_stack_super_incompat_flags(disk_super) & flag);
 }
 
 #define btrfs_fs_compat_ro(fs_info, opt) \
diff --git a/disk-io.c b/disk-io.c
index 6f8f9e87..c37a40e4 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -755,7 +755,7 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
 {
 	u64 features;
 
-	features = btrfs_super_incompat_flags(sb) &
+	features = btrfs_stack_super_incompat_flags(sb) &
 		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		printk("couldn't open because of unsupported "
@@ -764,10 +764,10 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
 		return -ENOTSUP;
 	}
 
-	features = btrfs_super_incompat_flags(sb);
+	features = btrfs_stack_super_incompat_flags(sb);
 	if (!(features & BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF)) {
 		features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-		btrfs_set_super_incompat_flags(sb, features);
+		btrfs_set_stack_super_incompat_flags(sb, features);
 	}
 
 	features = btrfs_stack_super_compat_ro_flags(sb);
diff --git a/mkfs/common.c b/mkfs/common.c
index 1d259da5..40f2a9f4 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -173,7 +173,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_stack_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
-	btrfs_set_super_incompat_flags(&super, cfg->features);
+	btrfs_set_stack_super_incompat_flags(&super, cfg->features);
 	if (cfg->label)
 		__strncpy_null(super.label, cfg->label, BTRFS_LABEL_SIZE - 1);
 
-- 
2.15.1



