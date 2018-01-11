Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753776AbeAKFKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:11 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9CFD248AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:55 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 12/67] btrfs-progs: add the stack prefix for root_flags set/get function
Date: Thu, 11 Jan 2018 13:08:44 +0800
Message-ID: <20180111050939.21251-13-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-list.c | 2 +-
 ctree.h      | 2 +-
 print-tree.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5b870ba6..85e34116 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1024,7 +1024,7 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_stack_root_generation(ri);
-				flags = btrfs_root_flags(ri);
+				flags = btrfs_stack_root_flags(ri);
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
 					otime = btrfs_stack_timespec_sec(&ri->otime);
diff --git a/ctree.h b/ctree.h
index 9b96268a..bd0374d3 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2058,7 +2058,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_root_dirid, struct btrfs_root_item, root_dirid,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_refs, struct btrfs_root_item, refs, 32);
-BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
diff --git a/print-tree.c b/print-tree.c
index 8c53bb85..f82b3ec7 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -585,7 +585,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 
 	memset(&root_item, 0, sizeof(root_item));
 	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
-	root_flags_to_str(btrfs_root_flags(&root_item), flags_str);
+	root_flags_to_str(btrfs_stack_root_flags(&root_item), flags_str);
 
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu level %hhu refs %u\n",
 		(unsigned long long)btrfs_stack_root_generation(&root_item),
@@ -597,7 +597,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		(unsigned long long)btrfs_root_last_snapshot(&root_item),
 		(unsigned long long)btrfs_root_limit(&root_item),
 		(unsigned long long)btrfs_root_used(&root_item),
-		(unsigned long long)btrfs_root_flags(&root_item),
+		(unsigned long long)btrfs_stack_root_flags(&root_item),
 		flags_str);
 
 	if (root_item.generation == root_item.generation_v2) {
-- 
2.15.1



