Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753765AbeAKFKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:07 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1688348AEA1A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:58 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/67] btrfs-progs: add the stack prefix for root_ctransid set/get function
Date: Thu, 11 Jan 2018 13:08:49 +0800
Message-ID: <20180111050939.21251-18-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_ctransid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h      | 2 +-
 print-tree.c | 2 +-
 send-utils.c | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index ab06e66a..6538bd23 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2067,7 +2067,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_generation_v2, struct btrfs_root_item,
 			 generation_v2, 64);
-BTRFS_SETGET_STACK_FUNCS(root_ctransid, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_ctransid, struct btrfs_root_item,
 			 ctransid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_otransid, struct btrfs_root_item,
 			 otransid, 64);
diff --git a/print-tree.c b/print-tree.c
index 7315a8bf..edffd6f2 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -613,7 +613,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		}
 		if (root_item.ctransid) {
 			printf("\t\tctransid %llu otransid %llu stransid %llu rtransid %llu\n",
-				btrfs_root_ctransid(&root_item),
+				btrfs_stack_root_ctransid(&root_item),
 				btrfs_root_otransid(&root_item),
 				btrfs_root_stransid(&root_item),
 				btrfs_root_rtransid(&root_item));
diff --git a/send-utils.c b/send-utils.c
index 7273d4ed..c59e505b 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -496,7 +496,7 @@ struct subvol_info *subvol_uuid_search2(struct subvol_uuid_search *s,
 	memcpy(info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
 	memcpy(info->received_uuid, root_item.received_uuid, BTRFS_UUID_SIZE);
 	memcpy(info->parent_uuid, root_item.parent_uuid, BTRFS_UUID_SIZE);
-	info->ctransid = btrfs_root_ctransid(&root_item);
+	info->ctransid = btrfs_stack_root_ctransid(&root_item);
 	info->otransid = btrfs_root_otransid(&root_item);
 	info->stransid = btrfs_root_stransid(&root_item);
 	info->rtransid = btrfs_root_rtransid(&root_item);
@@ -672,7 +672,8 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 				memcpy(si->received_uuid,
 						root_item.received_uuid,
 						BTRFS_UUID_SIZE);
-				si->ctransid = btrfs_root_ctransid(&root_item);
+				si->ctransid = btrfs_stack_root_ctransid(
+							&root_item);
 				si->otransid = btrfs_root_otransid(&root_item);
 				si->stransid = btrfs_root_stransid(&root_item);
 				si->rtransid = btrfs_root_rtransid(&root_item);
-- 
2.15.1



