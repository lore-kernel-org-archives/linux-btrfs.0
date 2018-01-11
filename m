Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753899AbeAKFKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:11 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8F0D248AEA0B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:54 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/67] btrfs-progs: add the stack prefix for root_dirid set/get function
Date: Thu, 11 Jan 2018 13:08:42 +0800
Message-ID: <20180111050939.21251-11-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_dirid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c   | 4 ++--
 convert/main.c | 4 ++--
 ctree.h        | 3 ++-
 inode.c        | 2 +-
 mkfs/main.c    | 2 +-
 print-tree.c   | 2 +-
 utils.c        | 2 +-
 7 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index cd2ad5f4..836f3c7e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3178,7 +3178,7 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 				 int delete)
 {
 	struct inode_backref *tmp, *backref;
-	u64 root_dirid = btrfs_root_dirid(&root->root_item);
+	u64 root_dirid = btrfs_stack_root_dirid(&root->root_item);
 	int ret = 0;
 	int repaired = 0;
 
@@ -3844,7 +3844,7 @@ static int check_inode_recs(struct btrfs_root *root,
 	int ret = 0;
 	int err = 0;
 	u64 error = 0;
-	u64 root_dirid = btrfs_root_dirid(&root->root_item);
+	u64 root_dirid = btrfs_stack_root_dirid(&root->root_item);
 
 	if (btrfs_root_refs(&root->root_item) == 0) {
 		if (!cache_tree_empty(inode_cache))
diff --git a/convert/main.c b/convert/main.c
index 7453077a..a3bcfbd3 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -981,7 +981,7 @@ static int init_btrfs(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
 				btrfs_super_root_dir(fs_info->super_copy), 0);
 	if (ret)
 		goto err;
-	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
+	btrfs_set_stack_root_dirid(&fs_info->fs_root->root_item,
 			     BTRFS_FIRST_FREE_OBJECTID);
 
 	/* subvol for fs image file */
@@ -1578,7 +1578,7 @@ static int do_rollback(const char *devname)
 	}
 
 	/* Search the image file */
-	root_dir = btrfs_root_dirid(&image_root->root_item);
+	root_dir = btrfs_stack_root_dirid(&image_root->root_item);
 	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
 			image_name, strlen(image_name), 0);
 
diff --git a/ctree.h b/ctree.h
index d954c032..7a59665b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2055,7 +2055,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_generation, struct btrfs_root_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_level, struct btrfs_root_item, level, 8);
-BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_root_dirid, struct btrfs_root_item, root_dirid,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
diff --git a/inode.c b/inode.c
index 2398bca4..a5c69b1d 100644
--- a/inode.c
+++ b/inode.c
@@ -588,7 +588,7 @@ struct btrfs_root *btrfs_mksubvol(struct btrfs_root *root,
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u64 dirid = btrfs_root_dirid(&root->root_item);
+	u64 dirid = btrfs_stack_root_dirid(&root->root_item);
 	u64 index = 2;
 	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
 	int len;
diff --git a/mkfs/main.c b/mkfs/main.c
index ae237e14..107c391e 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -835,7 +835,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 
 	btrfs_init_path(&path);
 
-	root_dir_key.objectid = btrfs_root_dirid(&root->root_item);
+	root_dir_key.objectid = btrfs_stack_root_dirid(&root->root_item);
 	root_dir_key.offset = 0;
 	root_dir_key.type = BTRFS_INODE_ITEM_KEY;
 	ret = btrfs_lookup_inode(trans, root, &path, &root_dir_key, 1);
diff --git a/print-tree.c b/print-tree.c
index 741fc9a9..7a1626ea 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -589,7 +589,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu level %hhu refs %u\n",
 		(unsigned long long)btrfs_stack_root_generation(&root_item),
-		(unsigned long long)btrfs_root_dirid(&root_item),
+		(unsigned long long)btrfs_stack_root_dirid(&root_item),
 		(unsigned long long)btrfs_stack_root_bytenr(&root_item),
 		btrfs_stack_root_level(&root_item),
 		btrfs_root_refs(&root_item));
diff --git a/utils.c b/utils.c
index 524f463d..2f57617f 100644
--- a/utils.c
+++ b/utils.c
@@ -402,7 +402,7 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto error;
 
-	btrfs_set_root_dirid(&root->root_item, objectid);
+	btrfs_set_stack_root_dirid(&root->root_item, objectid);
 	ret = 0;
 error:
 	return ret;
-- 
2.15.1



