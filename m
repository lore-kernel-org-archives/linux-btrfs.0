Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753885AbeAKFKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9966348AEA18
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:57 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 16/67] btrfs-progs: add the stack prefix for root_generation_v2 set/get function
Date: Thu, 11 Jan 2018 13:08:48 +0800
Message-ID: <20180111050939.21251-17-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_generation_v2 set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ctree.h      | 2 +-
 root-tree.c  | 6 ++++--
 send-utils.c | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index b5379d3b..ab06e66a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2065,7 +2065,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_limit, struct btrfs_root_item, byte_limit,
 			 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_last_snapshot, struct btrfs_root_item,
 			 last_snapshot, 64);
-BTRFS_SETGET_STACK_FUNCS(root_generation_v2, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_generation_v2, struct btrfs_root_item,
 			 generation_v2, 64);
 BTRFS_SETGET_STACK_FUNCS(root_ctransid, struct btrfs_root_item,
 			 ctransid, 64);
diff --git a/root-tree.c b/root-tree.c
index 2de63f6c..d6c4bd62 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -121,7 +121,8 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	 * Update generation_v2 so at the next mount we know the new root
 	 * fields are valid.
 	 */
-	btrfs_set_root_generation_v2(item, btrfs_stack_root_generation(item));
+	btrfs_set_stack_root_generation_v2(item,
+					   btrfs_stack_root_generation(item));
 
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -139,7 +140,8 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	/*
 	 * Make sure generation v1 and v2 match. See update_root for details.
 	 */
-	btrfs_set_root_generation_v2(item, btrfs_stack_root_generation(item));
+	btrfs_set_stack_root_generation_v2(item,
+					   btrfs_stack_root_generation(item));
 	ret = btrfs_insert_item(trans, root, key, item, sizeof(*item));
 	return ret;
 }
diff --git a/send-utils.c b/send-utils.c
index 3da6b9c7..7273d4ed 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -153,7 +153,8 @@ static int btrfs_read_root_item(int mnt_fd, u64 root_id,
 		return ret;
 
 	if (read_len < sizeof(*item) ||
-	    btrfs_stack_root_generation(item) != btrfs_root_generation_v2(item))
+	    btrfs_stack_root_generation(item) !=
+			btrfs_stack_root_generation_v2(item))
 		memset(&item->generation_v2, 0,
 			sizeof(*item) - offsetof(struct btrfs_root_item,
 						 generation_v2));
-- 
2.15.1



