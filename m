Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7297 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbbABHOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 02:14:38 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t027E4Sg008899
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Jan 2015 15:14:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 4/5] btrfs-progs: Add repair and report function for orphan file extent.
Date: Fri, 2 Jan 2015 15:12:32 +0800
Message-ID: <1420182753-2724-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some fs tree leaf/node corruption case, file extents may be lost, but
in extent tree, its record may still exists.

This provide the possibility for such orphan file extents to be
recovered even we can't recover its compression and other info, we can
still insert it as a normal non-compression file extent.

This patch provides the repair and report function for such orphan file
extent.
Even after such repair, user may still need to try to decompress its
data if user knows that is a compressed extent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v2:
   Add orphan_extents list initialization in clone_inode_rec() to avoid
   segfault in snapshot cases like fsck-tests/006.
---
 cmds-check.c | 160 +++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 129 insertions(+), 31 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 76216c5..b880f4c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -86,7 +86,8 @@ struct data_backref {
 /*
  * Much like data_backref, just removed the undetermined members
  * and change it to use list_head.
- * Stored in the root->orphan_data_extents list
+ * During extent scan, it is stored in root->orphan_data_extent.
+ * During fs tree scan, it is then moved to inode_rec->orphan_data_extents.
  */
 struct orphan_data_extent {
 	struct list_head list;
@@ -386,6 +387,7 @@ struct inode_record {
 	u64 extent_start;
 	u64 extent_end;
 	struct rb_root holes;
+	struct list_head orphan_extents;
 
 	u32 refs;
 };
@@ -404,6 +406,7 @@ struct inode_record {
 #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
 #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
+#define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
 
 struct root_backref {
 	struct list_head list;
@@ -509,12 +512,15 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 	struct inode_record *rec;
 	struct inode_backref *backref;
 	struct inode_backref *orig;
+	struct orphan_data_extent *src_orphan;
+	struct orphan_data_extent *dst_orphan;
 	size_t size;
 
 	rec = malloc(sizeof(*rec));
 	memcpy(rec, orig_rec, sizeof(*rec));
 	rec->refs = 1;
 	INIT_LIST_HEAD(&rec->backrefs);
+	INIT_LIST_HEAD(&rec->orphan_extents);
 
 	list_for_each_entry(orig, &orig_rec->backrefs, list) {
 		size = sizeof(*orig) + orig->namelen + 1;
@@ -522,9 +528,32 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 		memcpy(backref, orig, size);
 		list_add_tail(&backref->list, &rec->backrefs);
 	}
+	list_for_each_entry(src_orphan, &orig_rec->orphan_extents, list) {
+		dst_orphan = malloc(sizeof(*dst_orphan));
+		/* TODO: Fix all the HELL of un-catched -ENOMEM case */
+		BUG_ON(!dst_orphan);
+		memcpy(dst_orphan, src_orphan, sizeof(*src_orphan));
+		list_add_tail(&dst_orphan->list, &rec->orphan_extents);
+	}
 	return rec;
 }
 
+static void print_orphan_data_extents(struct list_head *orphan_extents,
+				      u64 objectid)
+{
+	struct orphan_data_extent *orphan;
+
+	if (list_empty(orphan_extents))
+		return;
+	printf("The following data extent is lost in tree %llu:\n",
+	       objectid);
+	list_for_each_entry(orphan, orphan_extents, list) {
+		printf("\tinode: %llu, offset:%llu, disk_bytenr: %llu, disk_len: %llu\n",
+		       orphan->objectid, orphan->offset, orphan->disk_bytenr,
+		       orphan->disk_len);
+	}
+}
+
 static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 {
 	u64 root_objectid = root->root_key.objectid;
@@ -569,7 +598,13 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		fprintf(stderr, ", some csum missing");
 	if (errors & I_ERR_LINK_COUNT_WRONG)
 		fprintf(stderr, ", link count wrong");
+	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
+		fprintf(stderr, ", orphan file extent");
 	fprintf(stderr, "\n");
+	/* Print the orphan extents if needed */
+	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
+		print_orphan_data_extents(&rec->orphan_extents, root->objectid);
+
 	/* Print the holes if needed */
 	if (errors & I_ERR_FILE_EXTENT_DISCOUNT) {
 		struct file_extent_hole *hole;
@@ -640,6 +675,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->extent_start = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
+		INIT_LIST_HEAD(&rec->orphan_extents);
 		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
@@ -656,6 +692,18 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 	return rec;
 }
 
+static void free_orphan_data_extents(struct list_head *orphan_extents)
+{
+	struct orphan_data_extent *orphan;
+
+	while (!list_empty(orphan_extents)) {
+		orphan = list_entry(orphan_extents->next,
+				    struct orphan_data_extent, list);
+		list_del(&orphan->list);
+		free(orphan);
+	}
+}
+
 static void free_inode_rec(struct inode_record *rec)
 {
 	struct inode_backref *backref;
@@ -669,6 +717,7 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
+	free_orphan_data_extents(&rec->orphan_extents);
 	free_file_extent_holes(&rec->holes);
 	free(rec);
 }
@@ -2490,6 +2539,67 @@ out:
 	return ret;
 }
 
+static int repair_inode_orphan_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct btrfs_path *path,
+				      struct inode_record *rec)
+{
+	struct orphan_data_extent *orphan;
+	struct orphan_data_extent *tmp;
+	int ret = 0;
+
+	list_for_each_entry_safe(orphan, tmp, &rec->orphan_extents, list) {
+		/*
+		 * Check for conflicting file extents
+		 *
+		 * Here we don't know whether the extents is compressed or not,
+		 * so we can only assume it not compressed nor data offset,
+		 * and use its disk_len as extent length.
+		 */
+		ret = btrfs_get_extent(NULL, root, path, orphan->objectid,
+				       orphan->offset, orphan->disk_len, 0);
+		btrfs_release_path(path);
+		if (ret < 0)
+			goto out;
+		if (!ret) {
+			fprintf(stderr,
+				"orphan extent (%llu, %llu) conflicts, delete the orphan\n",
+				orphan->disk_bytenr, orphan->disk_len);
+			ret = btrfs_free_extent(trans,
+					root->fs_info->extent_root,
+					orphan->disk_bytenr, orphan->disk_len,
+					0, root->objectid, orphan->objectid,
+					orphan->offset);
+			if (ret < 0)
+				goto out;
+		}
+		ret = btrfs_insert_file_extent(trans, root, orphan->objectid,
+				orphan->offset, orphan->disk_bytenr,
+				orphan->disk_len, orphan->disk_len);
+		if (ret < 0)
+			goto out;
+
+		/* Update file size info */
+		rec->found_size += orphan->disk_len;
+		if (rec->found_size == rec->nbytes)
+			rec->errors &= ~I_ERR_FILE_NBYTES_WRONG;
+
+		/* Update the file extent hole info too */
+		ret = del_file_extent_hole(&rec->holes, orphan->offset,
+					   orphan->disk_len);
+		if (ret < 0)
+			goto out;
+		if (RB_EMPTY_ROOT(&rec->holes))
+			rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
+
+		list_del(&orphan->list);
+		free(orphan);
+	}
+	rec->errors &= ~I_ERR_FILE_EXTENT_ORPHAN;
+out:
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
@@ -2499,7 +2609,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
-			     I_ERR_NO_INODE_ITEM)))
+			     I_ERR_NO_INODE_ITEM |
+			     I_ERR_FILE_EXTENT_ORPHAN)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
@@ -2521,6 +2632,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 
 	if (rec->errors & I_ERR_NO_INODE_ITEM)
 		ret = repair_inode_no_item(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
+		ret = repair_inode_orphan_extent(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
@@ -3133,34 +3246,6 @@ out_free_path:
 	return ret;
 }
 
-static void print_orphan_data_extents(struct list_head *orphan_extents,
-				      u64 objectid)
-{
-	struct orphan_data_extent *orphan;
-
-	if (list_empty(orphan_extents))
-		return;
-	printf("The following data extent is lost in tree %llu:\n",
-	       objectid);
-	list_for_each_entry(orphan, orphan_extents, list) {
-		printf("\tinode: %llu, offset:%llu, disk_bytenr: %llu, disk_len: %llu\n",
-		       orphan->objectid, orphan->offset, orphan->disk_bytenr,
-		       orphan->disk_len);
-	}
-}
-
-static void free_orphan_data_extents(struct list_head *orphan_extents)
-{
-	struct orphan_data_extent *orphan;
-
-	while (!list_empty(orphan_extents)) {
-		orphan = list_entry(orphan_extents->next,
-				    struct orphan_data_extent, list);
-		list_del(&orphan->list);
-		free(orphan);
-	}
-}
-
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
 			 struct walk_control *wc)
@@ -3174,6 +3259,8 @@ static int check_fs_root(struct btrfs_root *root,
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct cache_tree corrupt_blocks;
+	struct orphan_data_extent *orphan;
+	struct orphan_data_extent *tmp;
 	enum btrfs_tree_block_status status;
 
 	/*
@@ -3184,6 +3271,7 @@ static int check_fs_root(struct btrfs_root *root,
 	 */
 	cache_tree_init(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = &corrupt_blocks;
+
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		rec = get_root_rec(root_cache, root->root_key.objectid);
 		if (btrfs_root_refs(root_item) > 0)
@@ -3195,6 +3283,17 @@ static int check_fs_root(struct btrfs_root *root,
 	cache_tree_init(&root_node.root_cache);
 	cache_tree_init(&root_node.inode_cache);
 
+	/* Move the orphan extent record to corresponding inode_record */
+	list_for_each_entry_safe(orphan, tmp,
+				 &root->orphan_data_extents, list) {
+		struct inode_record *inode;
+
+		inode = get_inode_rec(&root_node.inode_cache, orphan->objectid,
+				      1);
+		inode->errors |= I_ERR_FILE_EXTENT_ORPHAN;
+		list_move(&orphan->list, &inode->orphan_extents);
+	}
+
 	level = btrfs_header_level(root->node);
 	memset(wc->nodes, 0, sizeof(wc->nodes));
 	wc->nodes[level] = &root_node;
@@ -3292,7 +3391,6 @@ skip_walking:
 
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
-	print_orphan_data_extents(&root->orphan_data_extents, root->objectid);
 	free_orphan_data_extents(&root->orphan_data_extents);
 	return ret;
 }
-- 
2.2.1

