Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753762AbeAKFKJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8D2CE48AEA13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:56 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 14/67] btrfs-progs: add the stack prefix for root_limit set/get function
Date: Thu, 11 Jan 2018 13:08:46 +0800
Message-ID: <20180111050939.21251-15-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_limit set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h      | 3 ++-
 print-tree.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index a49f9dda..7c72b5d6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2061,7 +2061,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_used, struct btrfs_root_item, bytes_used,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_root_limit, struct btrfs_root_item, byte_limit,
+			 64);
 BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
 BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
diff --git a/print-tree.c b/print-tree.c
index c2d19f38..fb9b0412 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -595,7 +595,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		btrfs_stack_root_refs(&root_item));
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
 		(unsigned long long)btrfs_root_last_snapshot(&root_item),
-		(unsigned long long)btrfs_root_limit(&root_item),
+		(unsigned long long)btrfs_stack_root_limit(&root_item),
 		(unsigned long long)btrfs_stack_root_used(&root_item),
 		(unsigned long long)btrfs_stack_root_flags(&root_item),
 		flags_str);
-- 
2.15.1



