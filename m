Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbbABHOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 02:14:37 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t027E3KB008896
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Jan 2015 15:14:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/5] btrfs-progs: Record and report every file extent hole.
Date: Fri, 2 Jan 2015 15:12:31 +0800
Message-ID: <1420182753-2724-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Record every file extent discontinuous hole in inode_record using a
rb_tree member.

Before the patch, btrfsck will only record the first file extent hole by
using first_extent_gap, that's good for detecting error, but not
suitable for fixing it.

This patch provides the ability to record every file extent hole and
report it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   None
---
 cmds-check.c | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 231 insertions(+), 13 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 20a6ac2..76216c5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -167,6 +167,202 @@ struct root_item_record {
 #define REF_ERR_DUP_ROOT_REF		(1 << 11)
 #define REF_ERR_DUP_ROOT_BACKREF	(1 << 12)
 
+struct file_extent_hole {
+	struct rb_node node;
+	u64 start;
+	u64 len;
+};
+
+/* Compatible function to allow reuse of old codes */
+static u64 first_extent_gap(struct rb_root *holes)
+{
+	struct file_extent_hole *hole;
+
+	if (RB_EMPTY_ROOT(holes))
+		return (u64)-1;
+
+	hole = rb_entry(rb_first(holes), struct file_extent_hole, node);
+	return hole->start;
+}
+
+int compare_hole(struct rb_node *node1, struct rb_node *node2)
+{
+	struct file_extent_hole *hole1;
+	struct file_extent_hole *hole2;
+
+	hole1 = rb_entry(node1, struct file_extent_hole, node);
+	hole2 = rb_entry(node2, struct file_extent_hole, node);
+
+	if (hole1->start > hole2->start)
+		return -1;
+	if (hole1->start < hole2->start)
+		return 1;
+	/* Now hole1->start == hole2->start */
+	if (hole1->len >= hole2->len)
+		/*
+		 * Hole 1 will be merge center
+		 * Same hole will be merged later
+		 */
+		return -1;
+	/* Hole 2 will be merge center */
+	return 1;
+}
+
+/*
+ * Add a hole to the record
+ *
+ * This will do hole merge for copy_file_extent_holes(),
+ * which will ensure there won't be continuous holes.
+ */
+static int add_file_extent_hole(struct rb_root *holes,
+				u64 start, u64 len)
+{
+	struct file_extent_hole *hole;
+	struct file_extent_hole *prev = NULL;
+	struct file_extent_hole *next = NULL;
+
+	hole = malloc(sizeof(*hole));
+	if (!hole)
+		return -ENOMEM;
+	hole->start = start;
+	hole->len = len;
+	/* Since compare will not return 0, no -EEXIST will happen */
+	rb_insert(holes, &hole->node, compare_hole);
+
+	/* simple merge with previous hole */
+	if (rb_prev(&hole->node))
+		prev = rb_entry(rb_prev(&hole->node), struct file_extent_hole,
+				node);
+	if (prev && prev->start + prev->len >= hole->start) {
+		hole->len = hole->start + hole->len - prev->start;
+		hole->start = prev->start;
+		rb_erase(&prev->node, holes);
+		free(prev);
+		prev = NULL;
+	}
+
+	/* iterate merge with next holes */
+	while (1) {
+		if (!rb_next(&hole->node))
+			break;
+		next = rb_entry(rb_next(&hole->node), struct file_extent_hole,
+					node);
+		if (hole->start + hole->len >= next->start) {
+			if (hole->start + hole->len <= next->start + next->len)
+				hole->len = next->start + next->len -
+					    hole->start;
+			rb_erase(&next->node, holes);
+			free(next);
+			next = NULL;
+		} else
+			break;
+	}
+	return 0;
+}
+
+static int compare_hole_range(struct rb_node *node, void *data)
+{
+	struct file_extent_hole *hole;
+	u64 start;
+
+	hole = (struct file_extent_hole *)data;
+	start = hole->start;
+
+	hole = rb_entry(node, struct file_extent_hole, node);
+	if (start < hole->start)
+		return -1;
+	if (start >= hole->start && start < hole->start + hole->len)
+		return 0;
+	return 1;
+}
+
+/*
+ * Delete a hole in the record
+ *
+ * This will do the hole split and is much restrict than add.
+ */
+static int del_file_extent_hole(struct rb_root *holes,
+				u64 start, u64 len)
+{
+	struct file_extent_hole *hole;
+	struct file_extent_hole tmp;
+	struct file_extent_hole prev;
+	struct file_extent_hole next;
+	struct rb_node *node;
+	int have_prev = 0;
+	int have_next = 0;
+	int ret = 0;
+
+	tmp.start = start;
+	tmp.len = len;
+	node = rb_search(holes, &tmp, compare_hole_range, NULL);
+	if (!node)
+		return -EEXIST;
+	hole = rb_entry(node, struct file_extent_hole, node);
+	if (start + len > hole->start + hole->len)
+		return -EEXIST;
+
+	/*
+	 * Now there will be no overflap, delete the hole and re-add the
+	 * split(s) if they exists.
+	 */
+	if (start > hole->start) {
+		prev.start = hole->start;
+		prev.len = start - hole->start;
+		have_prev = 1;
+	}
+	if (hole->start + hole->len > start + len) {
+		next.start = start + len;
+		next.len = hole->start + hole->len - start - len;
+		have_next = 1;
+	}
+	rb_erase(node, holes);
+	free(hole);
+	if (have_prev) {
+		ret = add_file_extent_hole(holes, prev.start, prev.len);
+		if (ret < 0)
+			return ret;
+	}
+	if (have_next) {
+		ret = add_file_extent_hole(holes, next.start, next.len);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int copy_file_extent_holes(struct rb_root *dst,
+				  struct rb_root *src)
+{
+	struct file_extent_hole *hole;
+	struct rb_node *node;
+	int ret = 0;
+
+	node = rb_first(src);
+	while (node) {
+		hole = rb_entry(node, struct file_extent_hole, node);
+		ret = add_file_extent_hole(dst, hole->start, hole->len);
+		if (ret)
+			break;
+		node = rb_next(node);
+	}
+	return ret;
+}
+
+static void free_file_extent_holes(struct rb_root *holes)
+{
+	struct rb_node *node;
+	struct file_extent_hole *hole;
+
+	node = rb_first(holes);
+	while (node) {
+		hole = rb_entry(node, struct file_extent_hole, node);
+		rb_erase(node, holes);
+		free(hole);
+		node = rb_first(holes);
+	}
+}
+
 struct inode_record {
 	struct list_head backrefs;
 	unsigned int checked:1;
@@ -189,7 +385,7 @@ struct inode_record {
 	u64 found_size;
 	u64 extent_start;
 	u64 extent_end;
-	u64 first_extent_gap;
+	struct rb_root holes;
 
 	u32 refs;
 };
@@ -374,6 +570,20 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 	if (errors & I_ERR_LINK_COUNT_WRONG)
 		fprintf(stderr, ", link count wrong");
 	fprintf(stderr, "\n");
+	/* Print the holes if needed */
+	if (errors & I_ERR_FILE_EXTENT_DISCOUNT) {
+		struct file_extent_hole *hole;
+		struct rb_node *node;
+
+		node = rb_first(&rec->holes);
+		fprintf(stderr, "Found file extent holes:\n");
+		while (node) {
+			hole = rb_entry(node, struct file_extent_hole, node);
+			fprintf(stderr, "\tstart: %llu, len:%llu\n",
+				hole->start, hole->len);
+			node = rb_next(node);
+		}
+	}
 }
 
 static void print_ref_error(int errors)
@@ -428,9 +638,9 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec = calloc(1, sizeof(*rec));
 		rec->ino = ino;
 		rec->extent_start = (u64)-1;
-		rec->first_extent_gap = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
+		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
 		node->cache.start = ino;
@@ -459,6 +669,7 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
+	free_file_extent_holes(&rec->holes);
 	free(rec);
 }
 
@@ -506,11 +717,9 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 			rec->errors |= I_ERR_ODD_DIR_ITEM;
 		if (rec->found_size != rec->nbytes)
 			rec->errors |= I_ERR_FILE_NBYTES_WRONG;
-		if (rec->extent_start == (u64)-1 || rec->extent_start > 0)
-			rec->first_extent_gap = 0;
 		if (rec->nlink > 0 && !no_holes &&
 		    (rec->extent_end < rec->isize ||
-		     rec->first_extent_gap < rec->isize))
+		     first_extent_gap(&rec->holes) < rec->isize))
 			rec->errors |= I_ERR_FILE_EXTENT_DISCOUNT;
 	}
 
@@ -659,6 +868,7 @@ static int merge_inode_recs(struct inode_record *src, struct inode_record *dst,
 {
 	struct inode_backref *backref;
 	u32 dir_count = 0;
+	int ret = 0;
 
 	dst->merging = 1;
 	list_for_each_entry(backref, &src->backrefs, list) {
@@ -691,8 +901,11 @@ static int merge_inode_recs(struct inode_record *src, struct inode_record *dst,
 		dst->found_csum_item = 1;
 	if (src->some_csum_missing)
 		dst->some_csum_missing = 1;
-	if (dst->first_extent_gap > src->first_extent_gap)
-		dst->first_extent_gap = src->first_extent_gap;
+	if (first_extent_gap(&dst->holes) > first_extent_gap(&src->holes)) {
+		ret = copy_file_extent_holes(&dst->holes, &src->holes);
+		if (ret < 0)
+			return ret;
+	}
 
 	BUG_ON(src->found_link < dir_count);
 	dst->found_link += src->found_link - dir_count;
@@ -704,9 +917,11 @@ static int merge_inode_recs(struct inode_record *src, struct inode_record *dst,
 		} else {
 			if (dst->extent_end > src->extent_start)
 				dst->errors |= I_ERR_FILE_EXTENT_OVERLAP;
-			else if (dst->extent_end < src->extent_start &&
-				 dst->extent_end < dst->first_extent_gap)
-				dst->first_extent_gap = dst->extent_end;
+			else if (dst->extent_end < src->extent_start) {
+				ret = add_file_extent_hole(&dst->holes,
+					dst->extent_end,
+					src->extent_start - dst->extent_end);
+			}
 			if (dst->extent_end < src->extent_end)
 				dst->extent_end = src->extent_end;
 		}
@@ -1231,9 +1446,12 @@ static int process_file_extent(struct btrfs_root *root,
 
 	if (rec->extent_end > key->offset)
 		rec->errors |= I_ERR_FILE_EXTENT_OVERLAP;
-	else if (rec->extent_end < key->offset &&
-		 rec->extent_end < rec->first_extent_gap)
-		rec->first_extent_gap = rec->extent_end;
+	else if (rec->extent_end < key->offset) {
+		ret = add_file_extent_hole(&rec->holes, rec->extent_end,
+					   key->offset - rec->extent_end);
+		if (ret < 0)
+			return ret;
+	}
 
 	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 	extent_type = btrfs_file_extent_type(eb, fi);
-- 
2.2.1

