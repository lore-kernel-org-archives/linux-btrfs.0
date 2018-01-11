Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753858AbeAKFKJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1B95E48AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:56 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 13/67] btrfs-progs: add the stack prefix for root_used set/get function
Date: Thu, 11 Jan 2018 13:08:45 +0800
Message-ID: <20180111050939.21251-14-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_used set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 convert/common.c | 2 +-
 ctree.h          | 3 ++-
 extent-tree.c    | 4 ++--
 mkfs/common.c    | 2 +-
 print-tree.c     | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/convert/common.c b/convert/common.c
index 304ee6ed..9a386932 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -193,7 +193,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_stack_root_refs(&root_item, 1);
-	btrfs_set_root_used(&root_item, cfg->nodesize);
+	btrfs_set_stack_root_used(&root_item, cfg->nodesize);
 	btrfs_set_stack_root_generation(&root_item, 1);
 	btrfs_set_stack_root_bytenr(&root_item, bytenr);
 
diff --git a/ctree.h b/ctree.h
index bd0374d3..a49f9dda 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2059,7 +2059,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_dirid, struct btrfs_root_item, root_dirid,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_root_flags, struct btrfs_root_item, flags, 64);
-BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_root_used, struct btrfs_root_item, bytes_used,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
diff --git a/extent-tree.c b/extent-tree.c
index 9ca0339e..a3e4bd1a 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1943,12 +1943,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	btrfs_set_super_bytes_used(info->super_copy, old_val);
 
 	/* block accounting for root item */
-	old_val = btrfs_root_used(&root->root_item);
+	old_val = btrfs_stack_root_used(&root->root_item);
 	if (alloc)
 		old_val += num_bytes;
 	else
 		old_val -= num_bytes;
-	btrfs_set_root_used(&root->root_item, old_val);
+	btrfs_set_stack_root_used(&root->root_item, old_val);
 
 	while(total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
diff --git a/mkfs/common.c b/mkfs/common.c
index 82859503..0b3e8173 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -58,7 +58,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_stack_root_refs(&root_item, 1);
-	btrfs_set_root_used(&root_item, cfg->nodesize);
+	btrfs_set_stack_root_used(&root_item, cfg->nodesize);
 	btrfs_set_stack_root_generation(&root_item, 1);
 
 	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
diff --git a/print-tree.c b/print-tree.c
index f82b3ec7..c2d19f38 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -596,7 +596,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
 		(unsigned long long)btrfs_root_last_snapshot(&root_item),
 		(unsigned long long)btrfs_root_limit(&root_item),
-		(unsigned long long)btrfs_root_used(&root_item),
+		(unsigned long long)btrfs_stack_root_used(&root_item),
 		(unsigned long long)btrfs_stack_root_flags(&root_item),
 		flags_str);
 
-- 
2.15.1



