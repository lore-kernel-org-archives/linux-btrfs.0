Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753706AbeAKFKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:02 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7938B48AEA0C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:50 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/67] btrfs-progs: add the stack prefix for block_group_flags set/get function
Date: Thu, 11 Jan 2018 13:08:35 +0800
Message-ID: <20180111050939.21251-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The block_group_flags set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-fragments.c | 2 +-
 chunk-recover.c   | 2 +-
 cmds-check.c      | 6 +++---
 convert/common.c  | 2 +-
 ctree.h           | 2 +-
 extent-tree.c     | 6 +++---
 print-tree.c      | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index db79f969..91b683de 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -261,7 +261,7 @@ list_fragments(int fd, u64 flags, char *dir)
 
 				bg = (struct btrfs_block_group_item *)
 						(args.buf + off);
-				bgflags = btrfs_block_group_flags(bg);
+				bgflags = btrfs_stack_block_group_flags(bg);
 				bgused = btrfs_stack_block_group_used(bg);
 
 				printf("found block group %lld len %lld "
diff --git a/chunk-recover.c b/chunk-recover.c
index 31de1354..cfcf97d4 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1374,7 +1374,7 @@ static int __insert_block_group(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_block_group_used(&bg_item, used);
 	btrfs_set_stack_block_group_chunk_objectid(&bg_item, used);
-	btrfs_set_block_group_flags(&bg_item, chunk_rec->type_flags);
+	btrfs_set_stack_block_group_flags(&bg_item, chunk_rec->type_flags);
 	key.objectid = chunk_rec->offset;
 	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	key.offset = chunk_rec->length;
diff --git a/cmds-check.c b/cmds-check.c
index 9acf673f..207a927d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12956,7 +12956,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
 	read_extent_buffer(eb, &bg_item, (unsigned long)bi, sizeof(bg_item));
 	used = btrfs_stack_block_group_used(&bg_item);
-	bg_flags = btrfs_block_group_flags(&bg_item);
+	bg_flags = btrfs_stack_block_group_flags(&bg_item);
 
 	chunk_key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	chunk_key.type = BTRFS_CHUNK_ITEM_KEY;
@@ -13158,11 +13158,11 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_group_item);
 		read_extent_buffer(leaf, &bg_item, (unsigned long)bi,
 				   sizeof(bg_item));
-		if (btrfs_block_group_flags(&bg_item) != type) {
+		if (btrfs_stack_block_group_flags(&bg_item) != type) {
 			error(
 "chunk[%llu %llu) related block group item flags mismatch, wanted: %llu, have: %llu",
 				chunk_key.offset, chunk_end, type,
-				btrfs_block_group_flags(&bg_item));
+				btrfs_stack_block_group_flags(&bg_item));
 			err |= REFERENCER_MISSING;
 		}
 	}
diff --git a/convert/common.c b/convert/common.c
index 8dbad917..e288d129 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -673,7 +673,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 	btrfs_set_item_offset(buf, btrfs_item_nr(*slot), *itemoff);
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(bgi));
 
-	btrfs_set_block_group_flags(&bgi, flag);
+	btrfs_set_stack_block_group_flags(&bgi, flag);
 	btrfs_set_stack_block_group_used(&bgi, used);
 	btrfs_set_stack_block_group_chunk_objectid(&bgi,
 			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
diff --git a/ctree.h b/ctree.h
index 71635318..d4254b67 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1569,7 +1569,7 @@ BTRFS_SETGET_FUNCS(disk_block_group_chunk_objectid,
 		   struct btrfs_block_group_item, chunk_objectid, 64);
 BTRFS_SETGET_FUNCS(disk_block_group_flags,
 		   struct btrfs_block_group_item, flags, 64);
-BTRFS_SETGET_STACK_FUNCS(block_group_flags,
+BTRFS_SETGET_STACK_FUNCS(stack_block_group_flags,
 			struct btrfs_block_group_item, flags, 64);
 
 /* struct btrfs_free_space_info */
diff --git a/extent-tree.c b/extent-tree.c
index 033bf53b..9ca0339e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3275,7 +3275,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			continue;
 		}
 
-		cache->flags = btrfs_block_group_flags(&cache->item);
+		cache->flags = btrfs_stack_block_group_flags(&cache->item);
 		bit = 0;
 		if (cache->flags & BTRFS_BLOCK_GROUP_DATA) {
 			bit = BLOCK_GROUP_DATA;
@@ -3330,7 +3330,7 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	btrfs_set_stack_block_group_chunk_objectid(&cache->item,
 						   chunk_objectid);
 	cache->flags = type;
-	btrfs_set_block_group_flags(&cache->item, type);
+	btrfs_set_stack_block_group_flags(&cache->item, type);
 
 	account_super_bytes(fs_info, cache);
 	ret = update_space_info(fs_info, cache->flags, size, bytes_used,
@@ -3440,7 +3440,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 		btrfs_set_stack_block_group_used(&cache->item, 0);
 		btrfs_set_stack_block_group_chunk_objectid(&cache->item,
 						     chunk_objectid);
-		btrfs_set_block_group_flags(&cache->item, group_type);
+		btrfs_set_stack_block_group_flags(&cache->item, group_type);
 
 		cache->flags = group_type;
 
diff --git a/print-tree.c b/print-tree.c
index 6c5aaea4..96cca9d5 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -997,7 +997,7 @@ static void print_block_group_item(struct extent_buffer *eb,
 
 	read_extent_buffer(eb, &bg_item, (unsigned long)bgi, sizeof(bg_item));
 	memset(flags_str, 0, sizeof(flags_str));
-	bg_flags_to_str(btrfs_block_group_flags(&bg_item), flags_str);
+	bg_flags_to_str(btrfs_stack_block_group_flags(&bg_item), flags_str);
 	printf("\t\tblock group used %llu chunk_objectid %llu flags %s\n",
 		(unsigned long long)btrfs_stack_block_group_used(&bg_item),
 		(unsigned long long)btrfs_stack_block_group_chunk_objectid(&bg_item),
-- 
2.15.1



