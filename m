Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753776AbeAKFKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:07 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8880848AEA1B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:58 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 18/67] btrfs-progs: add the stack prefix for root_otransid set/get function
Date: Thu, 11 Jan 2018 13:08:50 +0800
Message-ID: <20180111050939.21251-19-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_otransid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-list.c | 2 +-
 ctree.h      | 2 +-
 print-tree.c | 2 +-
 send-utils.c | 5 +++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 85e34116..4a0db259 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1028,7 +1028,7 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
 					otime = btrfs_stack_timespec_sec(&ri->otime);
-					ogen = btrfs_root_otransid(ri);
+					ogen = btrfs_stack_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
 					memcpy(ruuid, ri->received_uuid, BTRFS_UUID_SIZE);
diff --git a/ctree.h b/ctree.h
index 6538bd23..9dad4928 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2069,7 +2069,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_generation_v2, struct btrfs_root_item,
 			 generation_v2, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_ctransid, struct btrfs_root_item,
 			 ctransid, 64);
-BTRFS_SETGET_STACK_FUNCS(root_otransid, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_otransid, struct btrfs_root_item,
 			 otransid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
 			 stransid, 64);
diff --git a/print-tree.c b/print-tree.c
index edffd6f2..20d74774 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -614,7 +614,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		if (root_item.ctransid) {
 			printf("\t\tctransid %llu otransid %llu stransid %llu rtransid %llu\n",
 				btrfs_stack_root_ctransid(&root_item),
-				btrfs_root_otransid(&root_item),
+				btrfs_stack_root_otransid(&root_item),
 				btrfs_root_stransid(&root_item),
 				btrfs_root_rtransid(&root_item));
 		}
diff --git a/send-utils.c b/send-utils.c
index c59e505b..1317030a 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -497,7 +497,7 @@ struct subvol_info *subvol_uuid_search2(struct subvol_uuid_search *s,
 	memcpy(info->received_uuid, root_item.received_uuid, BTRFS_UUID_SIZE);
 	memcpy(info->parent_uuid, root_item.parent_uuid, BTRFS_UUID_SIZE);
 	info->ctransid = btrfs_stack_root_ctransid(&root_item);
-	info->otransid = btrfs_root_otransid(&root_item);
+	info->otransid = btrfs_stack_root_otransid(&root_item);
 	info->stransid = btrfs_root_stransid(&root_item);
 	info->rtransid = btrfs_root_rtransid(&root_item);
 	if (type == subvol_search_by_path) {
@@ -674,7 +674,8 @@ int subvol_uuid_search_init(int mnt_fd, struct subvol_uuid_search *s)
 						BTRFS_UUID_SIZE);
 				si->ctransid = btrfs_stack_root_ctransid(
 							&root_item);
-				si->otransid = btrfs_root_otransid(&root_item);
+				si->otransid = btrfs_stack_root_otransid(
+							&root_item);
 				si->stransid = btrfs_root_stransid(&root_item);
 				si->rtransid = btrfs_root_rtransid(&root_item);
 				si->path = path;
-- 
2.15.1



