Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbeDIMBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2B1EAD39
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs: use fs_info for btrfs_handle_em_exist tracepoint
Date: Mon,  9 Apr 2018 13:58:59 +0200
Message-Id: <03827d85f2986d6c4dd1d72b477c74464559ebd3.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We really want to know to which filesystem the extent map events belong,
but as it cannot be reached from the extent_map pointers, we need to
pass it down the callchain.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_map.c             |  6 ++++--
 fs/btrfs/extent_map.h             |  3 ++-
 fs/btrfs/inode.c                  |  2 +-
 fs/btrfs/tests/extent-map-tests.c |  8 ++++----
 include/trace/events/btrfs.h      | 12 +++++++-----
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 53a0633c6ef7..581b42d23e0d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -517,6 +517,7 @@ static noinline int merge_extent_mapping(struct extent_map_tree *em_tree,
 
 /**
  * btrfs_add_extent_mapping - add extent mapping into em_tree
+ * @fs_info - used for tracepoint
  * @em_tree - the extent tree into which we want to insert the extent mapping
  * @em_in   - extent we are inserting
  * @start   - start of the logical range btrfs_get_extent() is requesting
@@ -534,7 +535,8 @@ static noinline int merge_extent_mapping(struct extent_map_tree *em_tree,
  * Return 0 on success, otherwise -EEXIST.
  *
  */
-int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+int btrfs_add_extent_mapping(struct btrfs_fs_info *fs_info,
+			     struct extent_map_tree *em_tree,
 			     struct extent_map **em_in, u64 start, u64 len)
 {
 	int ret;
@@ -552,7 +554,7 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
 
 		existing = search_extent_mapping(em_tree, start, len);
 
-		trace_btrfs_handle_em_exist(existing, em, start, len);
+		trace_btrfs_handle_em_exist(fs_info, existing, em, start, len);
 
 		/*
 		 * existing will always be non-NULL, since there must be
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index f6f8ba114977..f55c8b4ef120 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -91,6 +91,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
-int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+int btrfs_add_extent_mapping(struct btrfs_fs_info *fs_info,
+			     struct extent_map_tree *em_tree,
 			     struct extent_map **em_in, u64 start, u64 len);
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f091c2358a4..18c31006865f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7092,7 +7092,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 	err = 0;
 	write_lock(&em_tree->lock);
-	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
+	err = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
 out:
 
diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 33760a7f580d..d6c687267572 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -104,7 +104,7 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 	em->len = len;
 	em->block_start = start;
 	em->block_len = len;
-	ret = btrfs_add_extent_mapping(em_tree, &em, em->start, em->len);
+	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, em->start, em->len);
 	if (ret)
 		test_msg("case1 [%llu %llu]: ret %d\n", start, start + len, ret);
 	if (em &&
@@ -168,7 +168,7 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 	em->len = SZ_1K;
 	em->block_start = EXTENT_MAP_INLINE;
 	em->block_len = (u64)-1;
-	ret = btrfs_add_extent_mapping(em_tree, &em, em->start, em->len);
+	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, em->start, em->len);
 	if (ret)
 		test_msg("case2 [0 1K]: ret %d\n", ret);
 	if (em &&
@@ -214,7 +214,7 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 	em->len = SZ_16K;
 	em->block_start = 0;
 	em->block_len = SZ_16K;
-	ret = btrfs_add_extent_mapping(em_tree, &em, start, len);
+	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	if (ret)
 		test_msg("case3 [0x%llx 0x%llx): ret %d\n",
 			 start, start + len, ret);
@@ -301,7 +301,7 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 	em->len = SZ_32K;
 	em->block_start = 0;
 	em->block_len = SZ_32K;
-	ret = btrfs_add_extent_mapping(em_tree, &em, start, len);
+	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	if (ret)
 		test_msg("case4 [0x%llx 0x%llx): ret %d\n",
 			 start, len, ret);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 9be469706d30..d78d8ab4bc86 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -256,11 +256,13 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 
 TRACE_EVENT(btrfs_handle_em_exist,
 
-	TP_PROTO(const struct extent_map *existing, const struct extent_map *map, u64 start, u64 len),
+	TP_PROTO(struct btrfs_fs_info *fs_info,
+		const struct extent_map *existing, const struct extent_map *map,
+		u64 start, u64 len),
 
-	TP_ARGS(existing, map, start, len),
+	TP_ARGS(fs_info, existing, map, start, len),
 
-	TP_STRUCT__entry(
+	TP_STRUCT__entry_btrfs(
 		__field(	u64,  e_start		)
 		__field(	u64,  e_len		)
 		__field(	u64,  map_start		)
@@ -269,7 +271,7 @@ TRACE_EVENT(btrfs_handle_em_exist,
 		__field(	u64,  len		)
 	),
 
-	TP_fast_assign(
+	TP_fast_assign_btrfs(fs_info,
 		__entry->e_start	= existing->start;
 		__entry->e_len		= existing->len;
 		__entry->map_start	= map->start;
@@ -278,7 +280,7 @@ TRACE_EVENT(btrfs_handle_em_exist,
 		__entry->len		= len;
 	),
 
-	TP_printk("start=%llu len=%llu "
+	TP_printk_btrfs("start=%llu len=%llu "
 		  "existing(start=%llu len=%llu) "
 		  "em(start=%llu len=%llu)",
 		  __entry->start,
-- 
2.16.2

