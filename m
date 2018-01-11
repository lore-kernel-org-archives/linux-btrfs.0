Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754099AbeAKFKa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:30 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 308B549F0E44
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:19 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 59/67] btrfs-progs: add the stack prefix for super_root_dir set/get function
Date: Thu, 11 Jan 2018 13:09:31 +0800
Message-ID: <20180111050939.21251-60-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_root_dir set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 2 +-
 convert/main.c            | 6 +++---
 ctree.h                   | 2 +-
 dir-test.c                | 2 +-
 mkfs/main.c               | 2 +-
 utils.c                   | 3 ++-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 1a92a8dd..cbeef769 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -402,7 +402,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("stripesize\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_stripesize(sb));
 	printf("root_dir\t\t%llu\n",
-	       (unsigned long long)btrfs_super_root_dir(sb));
+	       (unsigned long long)btrfs_stack_super_root_dir(sb));
 	printf("num_devices\t\t%llu\n",
 	       (unsigned long long)btrfs_super_num_devices(sb));
 	printf("compat_flags\t\t0x%llx\n",
diff --git a/convert/main.c b/convert/main.c
index 66b839e2..8b2c61a5 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -972,13 +972,13 @@ static int init_btrfs(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
 	memcpy(&location, &root->root_key, sizeof(location));
 	location.offset = (u64)-1;
 	ret = btrfs_insert_dir_item(trans, fs_info->tree_root, "default", 7,
-				btrfs_super_root_dir(fs_info->super_copy),
+				btrfs_stack_super_root_dir(fs_info->super_copy),
 				&location, BTRFS_FT_DIR, 0);
 	if (ret)
 		goto err;
 	ret = btrfs_insert_inode_ref(trans, fs_info->tree_root, "default", 7,
-				location.objectid,
-				btrfs_super_root_dir(fs_info->super_copy), 0);
+			location.objectid,
+			btrfs_stack_super_root_dir(fs_info->super_copy), 0);
 	if (ret)
 		goto err;
 	btrfs_set_stack_root_dirid(&fs_info->fs_root->root_item,
diff --git a/ctree.h b/ctree.h
index ccad87e8..ccc97125 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2194,7 +2194,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
+BTRFS_SETGET_STACK_FUNCS(stack_super_root_dir, struct btrfs_super_block,
 			 root_dir_objectid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
 			 num_devices, 64);
diff --git a/dir-test.c b/dir-test.c
index 8fb23b82..15c83aaf 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -445,7 +445,7 @@ int main(int ac, char **av)
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(IS_ERR(trans));
 
-	dir_oid = btrfs_super_root_dir(&super);
+	dir_oid = btrfs_stack_super_root_dir(&super);
 
 	signal(SIGTERM, sigstopper);
 	signal(SIGINT, sigstopper);
diff --git a/mkfs/main.c b/mkfs/main.c
index 5cf265ea..51e176c4 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -183,7 +183,7 @@ static int make_root_dir(struct btrfs_trans_handle *trans,
 	location.offset = (u64)-1;
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 			"default", 7,
-			btrfs_super_root_dir(root->fs_info->super_copy),
+			btrfs_stack_super_root_dir(root->fs_info->super_copy),
 			&location, BTRFS_FT_DIR, 0);
 	if (ret)
 		goto err;
diff --git a/utils.c b/utils.c
index 6787efa1..150623fc 100644
--- a/utils.c
+++ b/utils.c
@@ -393,7 +393,8 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_timespec_nsec(&inode_item.otime, 0);
 
 	if (root->fs_info->tree_root == root)
-		btrfs_set_super_root_dir(root->fs_info->super_copy, objectid);
+		btrfs_set_stack_super_root_dir(root->fs_info->super_copy,
+					       objectid);
 
 	ret = btrfs_insert_inode(trans, root, objectid, &inode_item);
 	if (ret)
-- 
2.15.1



