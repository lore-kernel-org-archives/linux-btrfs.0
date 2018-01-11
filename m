Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753855AbeAKFKJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0B8E448AEA14
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:57 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 15/67] btrfs-progs: add the stack prefix for root_last_snapshot set/get function
Date: Thu, 11 Jan 2018 13:08:47 +0800
Message-ID: <20180111050939.21251-16-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_last_snapshot set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 ctree.c      | 2 +-
 ctree.h      | 2 +-
 print-tree.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b79e9f6c..6070e8d5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11538,7 +11538,7 @@ again:
 
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
-			last_snapshot = btrfs_root_last_snapshot(&ri);
+			last_snapshot = btrfs_stack_root_last_snapshot(&ri);
 			if (btrfs_stack_disk_key_objectid(&ri.drop_progress)
 					== 0) {
 				level = btrfs_stack_root_level(&ri);
diff --git a/ctree.c b/ctree.c
index 86df6bd9..7a55f6ac 100644
--- a/ctree.c
+++ b/ctree.c
@@ -151,7 +151,7 @@ static int btrfs_block_can_be_shared(struct btrfs_root *root,
 	if (root->ref_cows &&
 	    buf != root->node && buf != root->commit_root &&
 	    (btrfs_header_generation(buf) <=
-	     btrfs_root_last_snapshot(&root->root_item) ||
+	     btrfs_stack_root_last_snapshot(&root->root_item) ||
 	     btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
 		return 1;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
diff --git a/ctree.h b/ctree.h
index 7c72b5d6..b5379d3b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2063,7 +2063,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_used, struct btrfs_root_item, bytes_used,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_limit, struct btrfs_root_item, byte_limit,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
 BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
 			 generation_v2, 64);
diff --git a/print-tree.c b/print-tree.c
index fb9b0412..7315a8bf 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -594,7 +594,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		btrfs_stack_root_level(&root_item),
 		btrfs_stack_root_refs(&root_item));
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
-		(unsigned long long)btrfs_root_last_snapshot(&root_item),
+		(unsigned long long)btrfs_stack_root_last_snapshot(&root_item),
 		(unsigned long long)btrfs_stack_root_limit(&root_item),
 		(unsigned long long)btrfs_stack_root_used(&root_item),
 		(unsigned long long)btrfs_stack_root_flags(&root_item),
-- 
2.15.1



