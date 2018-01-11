Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753964AbeAKFKO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:14 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EF13D486A78B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:59 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 20/67] btrfs-progs: add the stack prefix for root_rtransid set/get function
Date: Thu, 11 Jan 2018 13:08:52 +0800
Message-ID: <20180111050939.21251-21-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_rtransid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h      | 2 +-
 print-tree.c | 2 +-
 send-utils.c | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index bce1b0d4..fa05adea 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2073,7 +2073,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_otransid, struct btrfs_root_item,
 			 otransid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_stransid, struct btrfs_root_item,
 			 stransid, 64);
-BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
 
 static inline struct btrfs_timespec* btrfs_root_ctime(
diff --git a/print-tree.c b/print-tree.c
index 6ab7c76c..e91f11a1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -616,7 +616,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 				btrfs_stack_root_ctransid(&root_item),
 				btrfs_stack_root_otransid(&root_item),
 				btrfs_stack_root_stransid(&root_item),
-				btrfs_root_rtransid(&root_item));
+				btrfs_stack_root_rtransid(&root_item));
 		}
 		if (btrfs_timespec_sec(leaf, btrfs_root_ctime(ri)))
 			print_timespec(leaf, btrfs_root_ctime(ri),
diff --git a/send-utils.c b/send-utils.c
index 8d0fdca4..db84c9d5 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -499,7 +499,7 @@ struct subvol_info *subvol_uuid_search2(struct subvol_uuid_search *s,
 	info->ctransid = btrfs_stack_root_ctransid(&root_item);
 	info->otransid = btrfs_stack_root_otransid(&root_item);
 	info->stransid = btrfs_stack_root_stransid(&root_item);
-	info->rtransid = btrfs_root_rtransid(&root_item);
+	info->rtransid = btrfs_stack_root_rtransid(&root_item);
 	if (type == subvol_search_by_path) {
 		info->path = strdup(path);
 		if (!info->path) {
@@ -678,7 +678,8 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 							&root_item);
 				si->stransid = btrfs_stack_root_stransid(
 							&root_item);
-				si->rtransid = btrfs_root_rtransid(&root_item);
+				si->rtransid = btrfs_stack_root_rtransid(
+							&root_item);
 				si->path = path;
 				subvol_uuid_search_add(s, si);
 				root_item_valid = 0;
-- 
2.15.1



