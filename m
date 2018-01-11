Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754107AbeAKFKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9727549F0E47
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:20 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 62/67] btrfs-progs: add the stack prefix for super_compat_ro_flags set/get function
Date: Thu, 11 Jan 2018 13:09:34 +0800
Message-ID: <20180111050939.21251-63-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_compat_ro_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 4 ++--
 ctree.h                   | 4 ++--
 disk-io.c                 | 4 ++--
 free-space-tree.c         | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 24037125..8c51b6f0 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -408,8 +408,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("compat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_stack_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
-	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
-	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
+	       (unsigned long long)btrfs_stack_super_compat_ro_flags(sb));
+	print_readable_compat_ro_flag(btrfs_stack_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
diff --git a/ctree.h b/ctree.h
index c18b5577..14f2e732 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2200,7 +2200,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_num_devices, struct btrfs_super_block,
 			 num_devices, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
-BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_compat_ro_flags, struct btrfs_super_block,
 			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
@@ -2458,7 +2458,7 @@ static inline int __btrfs_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag)
 {
 	struct btrfs_super_block *disk_super;
 	disk_super = fs_info->super_copy;
-	return !!(btrfs_super_compat_ro_flags(disk_super) & flag);
+	return !!(btrfs_stack_super_compat_ro_flags(disk_super) & flag);
 }
 
 /* helper function to cast into the data area of the leaf. */
diff --git a/disk-io.c b/disk-io.c
index d6bc057b..6f8f9e87 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -770,12 +770,12 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb,
 		btrfs_set_super_incompat_flags(sb, features);
 	}
 
-	features = btrfs_super_compat_ro_flags(sb);
+	features = btrfs_stack_super_compat_ro_flags(sb);
 	if (flags & OPEN_CTREE_WRITES) {
 		if (flags & OPEN_CTREE_INVALIDATE_FST) {
 			/* Clear the FREE_SPACE_TREE_VALID bit on disk... */
 			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID;
-			btrfs_set_super_compat_ro_flags(sb, features);
+			btrfs_set_stack_super_compat_ro_flags(sb, features);
 			/* ... and ignore the free space tree bit. */
 			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE;
 		}
diff --git a/free-space-tree.c b/free-space-tree.c
index 69a4eca8..4a87b5be 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -119,10 +119,10 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	features = btrfs_super_compat_ro_flags(fs_info->super_copy);
+	features = btrfs_stack_super_compat_ro_flags(fs_info->super_copy);
 	features &= ~(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID |
 		      BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE);
-	btrfs_set_super_compat_ro_flags(fs_info->super_copy, features);
+	btrfs_set_stack_super_compat_ro_flags(fs_info->super_copy, features);
 	fs_info->free_space_root = NULL;
 
 	ret = clear_free_space_tree(trans, free_space_root);
-- 
2.15.1



