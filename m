Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbeAEU7M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 15:59:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05KvSof027794
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:59:11 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fagex030n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 20:59:11 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks9FJ010334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks9VX031552
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 04/10] Btrfs: move extent map specific code to extent_map.c
Date: Fri,  5 Jan 2018 12:51:11 -0700
Message-Id: <20180105195117.5131-5-bo.li.liu@oracle.com>
In-Reply-To: <20180105195117.5131-1-bo.li.liu@oracle.com>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These helpers are extent map specific, move them to extent_map.c.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h      |   2 -
 fs/btrfs/extent_map.c | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_map.h |   2 +
 fs/btrfs/inode.c      | 107 ------------------------------------------
 4 files changed, 127 insertions(+), 109 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 328f40f..b2e09fe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3148,8 +3148,6 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 						    int delay_iput);
 void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 
-int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
-			     struct extent_map **em_in, u64 start, u64 len);
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
 		u64 len, int create);
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2e348fb..6fe8b14 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -454,3 +454,128 @@ void replace_extent_mapping(struct extent_map_tree *tree,
 
 	setup_extent_mapping(tree, new, modified);
 }
+
+static struct extent_map *next_extent_map(struct extent_map *em)
+{
+	struct rb_node *next;
+
+	next = rb_next(&em->rb_node);
+	if (!next)
+		return NULL;
+	return container_of(next, struct extent_map, rb_node);
+}
+
+static struct extent_map *prev_extent_map(struct extent_map *em)
+{
+	struct rb_node *prev;
+
+	prev = rb_prev(&em->rb_node);
+	if (!prev)
+		return NULL;
+	return container_of(prev, struct extent_map, rb_node);
+}
+
+/* helper for btfs_get_extent.  Given an existing extent in the tree,
+ * the existing extent is the nearest extent to map_start,
+ * and an extent that you want to insert, deal with overlap and insert
+ * the best fitted new extent into the tree.
+ */
+static int merge_extent_mapping(struct extent_map_tree *em_tree,
+				struct extent_map *existing,
+				struct extent_map *em,
+				u64 map_start)
+{
+	struct extent_map *prev;
+	struct extent_map *next;
+	u64 start;
+	u64 end;
+	u64 start_diff;
+
+	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
+
+	if (existing->start > map_start) {
+		next = existing;
+		prev = prev_extent_map(next);
+	} else {
+		prev = existing;
+		next = next_extent_map(prev);
+	}
+
+	start = prev ? extent_map_end(prev) : em->start;
+	start = max_t(u64, start, em->start);
+	end = next ? next->start : extent_map_end(em);
+	end = min_t(u64, end, extent_map_end(em));
+	start_diff = start - em->start;
+	em->start = start;
+	em->len = end - start;
+	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
+	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
+		em->block_start += start_diff;
+		em->block_len = em->len;
+	}
+	return add_extent_mapping(em_tree, em, 0);
+}
+
+/**
+ * btrfs_add_extent_mapping - add extent mapping into em_tree
+ * @em_tree - the extent tree into which we want to insert the extent mapping
+ * @em_in   - extent we are inserting
+ * @start   - start of the logical range btrfs_get_extent() is requesting
+ * @len     - length of the logical range btrfs_get_extent() is requesting
+ *
+ * Note that @em_in's range may be different from [start, start+len),
+ * but they must be overlapped.
+ *
+ * Insert @em_in into @em_tree. In case there is an overlapping range, handle
+ * the -EEXIST by either:
+ * a) Returning the existing extent in @em_in if @start is within the
+ *    existing em.
+ * b) Merge the existing extent with @em_in passed in.
+ *
+ * Return 0 on success, otherwise -EEXIST.
+ *
+ */
+int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+			     struct extent_map **em_in, u64 start, u64 len)
+{
+	int ret;
+	struct extent_map *em = *em_in;
+
+	ret = add_extent_mapping(em_tree, em, 0);
+	/* it is possible that someone inserted the extent into the tree
+	 * while we had the lock dropped.  It is also possible that
+	 * an overlapping map exists in the tree
+	 */
+	if (ret == -EEXIST) {
+		struct extent_map *existing;
+
+		ret = 0;
+
+		existing = search_extent_mapping(em_tree, start, len);
+		/*
+		 * existing will always be non-NULL, since there must be
+		 * extent causing the -EEXIST.
+		 */
+		if (start >= existing->start &&
+		    start < extent_map_end(existing)) {
+			free_extent_map(em);
+			*em_in = existing;
+			ret = 0;
+		} else {
+			/*
+			 * The existing extent map is the one nearest to
+			 * the [start, start + len) range which overlaps
+			 */
+			ret = merge_extent_mapping(em_tree, existing,
+						   em, start);
+			free_extent_map(existing);
+			if (ret) {
+				free_extent_map(em);
+				*em_in = NULL;
+			}
+		}
+	}
+
+	ASSERT(ret == 0 || ret == -EEXIST);
+	return ret;
+}
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 64365bb..40f34ad 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -92,4 +92,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
+int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
+			     struct extent_map **em_in, u64 start, u64 len);
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 876118c..b2272f9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6803,68 +6803,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	goto out_fail;
 }
 
-/* Find next extent map of a given extent map, caller needs to ensure locks */
-static struct extent_map *next_extent_map(struct extent_map *em)
-{
-	struct rb_node *next;
-
-	next = rb_next(&em->rb_node);
-	if (!next)
-		return NULL;
-	return container_of(next, struct extent_map, rb_node);
-}
-
-static struct extent_map *prev_extent_map(struct extent_map *em)
-{
-	struct rb_node *prev;
-
-	prev = rb_prev(&em->rb_node);
-	if (!prev)
-		return NULL;
-	return container_of(prev, struct extent_map, rb_node);
-}
-
-/* helper for btfs_get_extent.  Given an existing extent in the tree,
- * the existing extent is the nearest extent to map_start,
- * and an extent that you want to insert, deal with overlap and insert
- * the best fitted new extent into the tree.
- */
-static int merge_extent_mapping(struct extent_map_tree *em_tree,
-				struct extent_map *existing,
-				struct extent_map *em,
-				u64 map_start)
-{
-	struct extent_map *prev;
-	struct extent_map *next;
-	u64 start;
-	u64 end;
-	u64 start_diff;
-
-	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
-
-	if (existing->start > map_start) {
-		next = existing;
-		prev = prev_extent_map(next);
-	} else {
-		prev = existing;
-		next = next_extent_map(prev);
-	}
-
-	start = prev ? extent_map_end(prev) : em->start;
-	start = max_t(u64, start, em->start);
-	end = next ? next->start : extent_map_end(em);
-	end = min_t(u64, end, extent_map_end(em));
-	start_diff = start - em->start;
-	em->start = start;
-	em->len = end - start;
-	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
-	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
-		em->block_start += start_diff;
-		em->block_len = em->len;
-	}
-	return add_extent_mapping(em_tree, em, 0);
-}
-
 static noinline int uncompress_inline(struct btrfs_path *path,
 				      struct page *page,
 				      size_t pg_offset, u64 extent_offset,
@@ -6911,51 +6849,6 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	return ret;
 }
 
-int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
-			     struct extent_map **em_in, u64 start, u64 len)
-{
-	int ret;
-	struct extent_map *em = *em_in;
-
-	ret = add_extent_mapping(em_tree, em, 0);
-	/* it is possible that someone inserted the extent into the tree
-	 * while we had the lock dropped.  It is also possible that
-	 * an overlapping map exists in the tree
-	 */
-	if (ret == -EEXIST) {
-		struct extent_map *existing;
-
-		ret = 0;
-
-		existing = search_extent_mapping(em_tree, start, len);
-		/*
-		 * existing will always be non-NULL, since there must be
-		 * extent causing the -EEXIST.
-		 */
-		if (start >= existing->start &&
-		    start < extent_map_end(existing)) {
-			free_extent_map(em);
-			*em_in = existing;
-			ret = 0;
-		} else {
-			/*
-			 * The existing extent map is the one nearest to
-			 * the [start, start + len) range which overlaps
-			 */
-			ret = merge_extent_mapping(em_tree, existing,
-						   em, start);
-			free_extent_map(existing);
-			if (ret) {
-				free_extent_map(em);
-				*em_in = NULL;
-			}
-		}
-	}
-
-	ASSERT(ret == 0 || ret == -EEXIST);
-	return ret;
-}
-
 /*
  * a bit scary, this does extent mapping from logical file offset to the disk.
  * the ugly parts come from merging extents from the disk with the in-ram
-- 
2.9.4

