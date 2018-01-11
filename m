Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44389 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753212AbeAKFJ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:09:59 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 694C348AEA0A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:49 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/67] btrfs-progs: add the stack prefix for block_group_used set/get function
Date: Thu, 11 Jan 2018 13:08:33 +0800
Message-ID: <20180111050939.21251-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The block_group_used set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-fragments.c  |  2 +-
 chunk-recover.c    |  4 ++--
 cmds-check.c       |  2 +-
 convert/common.c   |  2 +-
 ctree.h            |  2 +-
 extent-tree.c      | 20 ++++++++++----------
 free-space-cache.c |  2 +-
 print-tree.c       |  2 +-
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index 46c78d2b..db79f969 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -262,7 +262,7 @@ list_fragments(int fd, u64 flags, char *dir)
 				bg = (struct btrfs_block_group_item *)
 						(args.buf + off);
 				bgflags = btrfs_block_group_flags(bg);
-				bgused = btrfs_block_group_used(bg);
+				bgused = btrfs_stack_block_group_used(bg);
 
 				printf("found block group %lld len %lld "
 					"flags %lld\n",
diff --git a/chunk-recover.c b/chunk-recover.c
index 4a6d7141..998b2d8f 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1119,7 +1119,7 @@ static int block_group_free_all_extent(struct btrfs_root *root,
 			BLOCK_GROUP_DIRTY);
 	set_extent_dirty(&info->free_space_cache, start, end);
 
-	btrfs_set_block_group_used(&cache->item, 0);
+	btrfs_set_stack_block_group_used(&cache->item, 0);
 
 	return 0;
 }
@@ -1372,7 +1372,7 @@ static int __insert_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret = 0;
 
-	btrfs_set_block_group_used(&bg_item, used);
+	btrfs_set_stack_block_group_used(&bg_item, used);
 	btrfs_set_block_group_chunk_objectid(&bg_item, used);
 	btrfs_set_block_group_flags(&bg_item, chunk_rec->type_flags);
 	key.objectid = chunk_rec->offset;
diff --git a/cmds-check.c b/cmds-check.c
index 7fc30da8..9acf673f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12955,7 +12955,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	btrfs_item_key_to_cpu(eb, &bg_key, slot);
 	bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
 	read_extent_buffer(eb, &bg_item, (unsigned long)bi, sizeof(bg_item));
-	used = btrfs_block_group_used(&bg_item);
+	used = btrfs_stack_block_group_used(&bg_item);
 	bg_flags = btrfs_block_group_flags(&bg_item);
 
 	chunk_key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
diff --git a/convert/common.c b/convert/common.c
index 3860f3b9..ca3a4768 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -674,7 +674,7 @@ static void insert_temp_block_group(struct extent_buffer *buf,
 	btrfs_set_item_size(buf, btrfs_item_nr(*slot), sizeof(bgi));
 
 	btrfs_set_block_group_flags(&bgi, flag);
-	btrfs_set_block_group_used(&bgi, used);
+	btrfs_set_stack_block_group_used(&bgi, used);
 	btrfs_set_block_group_chunk_objectid(&bgi,
 			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	write_extent_buffer(buf, &bgi, btrfs_item_ptr_offset(buf, *slot),
diff --git a/ctree.h b/ctree.h
index ef422ea6..77cab9af 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1558,7 +1558,7 @@ static inline void btrfs_set_stripe_devid_nr(struct extent_buffer *eb,
 }
 
 /* struct btrfs_block_group_item */
-BTRFS_SETGET_STACK_FUNCS(block_group_used, struct btrfs_block_group_item,
+BTRFS_SETGET_STACK_FUNCS(stack_block_group_used, struct btrfs_block_group_item,
 			 used, 64);
 BTRFS_SETGET_FUNCS(disk_block_group_used, struct btrfs_block_group_item,
 			 used, 64);
diff --git a/extent-tree.c b/extent-tree.c
index 055582c3..f9849f27 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -347,7 +347,7 @@ btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
 		struct btrfs_block_group_cache *shint;
 		shint = btrfs_lookup_block_group(info, search_start);
 		if (shint && !shint->ro && block_group_bits(shint, data)) {
-			used = btrfs_block_group_used(&shint->item);
+			used = btrfs_stack_block_group_used(&shint->item);
 			if (used + shint->pinned <
 			    div_factor(shint->key.offset, factor)) {
 				return shint;
@@ -355,7 +355,7 @@ btrfs_find_block_group(struct btrfs_root *root, struct btrfs_block_group_cache
 		}
 	}
 	if (hint && !hint->ro && block_group_bits(hint, data)) {
-		used = btrfs_block_group_used(&hint->item);
+		used = btrfs_stack_block_group_used(&hint->item);
 		if (used + hint->pinned <
 		    div_factor(hint->key.offset, factor)) {
 			return hint;
@@ -383,7 +383,7 @@ again:
 
 		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
 		last = cache->key.objectid + cache->key.offset;
-		used = btrfs_block_group_used(&cache->item);
+		used = btrfs_stack_block_group_used(&cache->item);
 
 		if (!cache->ro && block_group_bits(cache, data)) {
 			if (full_search)
@@ -1962,7 +1962,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		set_extent_bits(&info->block_group_cache, start, end,
 				BLOCK_GROUP_DIRTY);
 
-		old_val = btrfs_block_group_used(&cache->item);
+		old_val = btrfs_stack_block_group_used(&cache->item);
 		num_bytes = min(total, cache->key.offset - byte_in_group);
 
 		if (alloc) {
@@ -1976,7 +1976,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 						bytenr, bytenr + num_bytes - 1);
 			}
 		}
-		btrfs_set_block_group_used(&cache->item, old_val);
+		btrfs_set_stack_block_group_used(&cache->item, old_val);
 		total -= num_bytes;
 		bytenr += num_bytes;
 	}
@@ -3291,8 +3291,8 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		account_super_bytes(info, cache);
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
-					btrfs_block_group_used(&cache->item),
-					&space_info);
+				btrfs_stack_block_group_used(&cache->item),
+				&space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
 
@@ -3326,7 +3326,7 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	cache->key.offset = size;
 
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	btrfs_set_block_group_used(&cache->item, bytes_used);
+	btrfs_set_stack_block_group_used(&cache->item, bytes_used);
 	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
@@ -3436,7 +3436,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 		cache->key.offset = group_size;
 		cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 
-		btrfs_set_block_group_used(&cache->item, 0);
+		btrfs_set_stack_block_group_used(&cache->item, 0);
 		btrfs_set_block_group_chunk_objectid(&cache->item,
 						     chunk_objectid);
 		btrfs_set_block_group_flags(&cache->item, group_type);
@@ -3867,7 +3867,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 		if (!cache)
 			break;
 		start = cache->key.objectid + cache->key.offset;
-		btrfs_set_block_group_used(&cache->item, 0);
+		btrfs_set_stack_block_group_used(&cache->item, 0);
 		cache->space_info->bytes_used = 0;
 		set_extent_bits(&root->fs_info->block_group_cache,
 				cache->key.objectid,
diff --git a/free-space-cache.c b/free-space-cache.c
index 50356d04..3d961b2b 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -437,7 +437,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_path *path;
-	u64 used = btrfs_block_group_used(&block_group->item);
+	u64 used = btrfs_stack_block_group_used(&block_group->item);
 	int ret = 0;
 	int matched;
 
diff --git a/print-tree.c b/print-tree.c
index d3fa8621..e8c045fb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -999,7 +999,7 @@ static void print_block_group_item(struct extent_buffer *eb,
 	memset(flags_str, 0, sizeof(flags_str));
 	bg_flags_to_str(btrfs_block_group_flags(&bg_item), flags_str);
 	printf("\t\tblock group used %llu chunk_objectid %llu flags %s\n",
-		(unsigned long long)btrfs_block_group_used(&bg_item),
+		(unsigned long long)btrfs_stack_block_group_used(&bg_item),
 		(unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
 		flags_str);
 }
-- 
2.15.1



