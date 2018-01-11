Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753660AbeAKFJ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:09:59 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 06E5648AEA0B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:50 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/67] btrfs-progs: add the stack prefix for block_group_chunk_objectid set/get function
Date: Thu, 11 Jan 2018 13:08:34 +0800
Message-ID: <20180111050939.21251-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The block_group_chunk_objectid set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c  | 2 +-
 convert/common.c | 2 +-
 ctree.h          | 2 +-
 extent-tree.c    | 5 +++--
 print-tree.c     | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 998b2d8f..31de1354 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1373,7 +1373,7 @@ static int __insert_block_group(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	btrfs_set_stack_block_group_used(&bg_item, used);
-	btrfs_set_block_group_chunk_objectid(&bg_item, used);
+	btrfs_set_stack_block_group_chunk_objectid(&bg_item, used);
 	btrfs_set_block_group_flags(&bg_item, chunk_rec->type_flags);
 	key.objectid = chunk_rec->offset;
 	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
diff --git a/convert/common.c b/convert/common.c
index ca3a4768..8dbad917 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -675,7 +675,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 
 	btrfs_set_block_group_flags(&bgi, flag);
 	btrfs_set_stack_block_group_used(&bgi, used);
-	btrfs_set_block_group_chunk_objectid(&bgi,
+	btrfs_set_stack_block_group_chunk_objectid(&bgi,
 			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	write_extent_buffer(buf, &bgi, btrfs_item_ptr_offset(buf, *slot),
 			    sizeof(bgi));
diff --git a/ctree.h b/ctree.h
index 77cab9af..71635318 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1562,7 +1562,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_block_group_used, struct btrfs_block_group_item,
 			 used, 64);
 BTRFS_SETGET_FUNCS(disk_block_group_used, struct btrfs_block_group_item,
 			 used, 64);
-BTRFS_SETGET_STACK_FUNCS(block_group_chunk_objectid,
+BTRFS_SETGET_STACK_FUNCS(stack_block_group_chunk_objectid,
 			struct btrfs_block_group_item, chunk_objectid, 64);
 
 BTRFS_SETGET_FUNCS(disk_block_group_chunk_objectid,
diff --git a/extent-tree.c b/extent-tree.c
index f9849f27..033bf53b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3327,7 +3327,8 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	btrfs_set_stack_block_group_used(&cache->item, bytes_used);
-	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
+	btrfs_set_stack_block_group_chunk_objectid(&cache->item,
+						   chunk_objectid);
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
@@ -3437,7 +3438,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 		cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 
 		btrfs_set_stack_block_group_used(&cache->item, 0);
-		btrfs_set_block_group_chunk_objectid(&cache->item,
+		btrfs_set_stack_block_group_chunk_objectid(&cache->item,
 						     chunk_objectid);
 		btrfs_set_block_group_flags(&cache->item, group_type);
 
diff --git a/print-tree.c b/print-tree.c
index e8c045fb..6c5aaea4 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1000,7 +1000,7 @@ static void print_block_group_item(struct extent_buffer *eb,
 	bg_flags_to_str(btrfs_block_group_flags(&bg_item), flags_str);
 	printf("\t\tblock group used %llu chunk_objectid %llu flags %s\n",
 		(unsigned long long)btrfs_stack_block_group_used(&bg_item),
-		(unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
+		(unsigned long long)btrfs_stack_block_group_chunk_objectid(&bg_item),
 		flags_str);
 }
 
-- 
2.15.1



