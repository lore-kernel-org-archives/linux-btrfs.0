Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63005 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbaLRDkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 22:40:09 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBI3ddGN002168
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 11:39:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs-progs: Add repair and report function for orphan file exntent.
Date: Thu, 18 Dec 2014 11:37:59 +0800
Message-ID: <1418873880-7916-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some fs tree leaf/node corruption case, file extents may be lost, but
in extent tree, its record may still exists.

This provide the possiblity for such orphan file extents to be
recovered even we can't recover its compression and other info, we can
still insert it as a normal non-compression file extent.

This patch provides the repair and report function for such orphan file
extent.
Even after such repair, user may still need to try to decompress its
data if user knows that is a compressed extent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 119 insertions(+), 31 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 51b416b..1e9bc56 100644
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
@@ -525,6 +528,22 @@ static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
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
@@ -569,7 +588,13 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
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
@@ -640,6 +665,7 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
 		rec->extent_start = (u64)-1;
 		rec->refs = 1;
 		INIT_LIST_HEAD(&rec->backrefs);
+		INIT_LIST_HEAD(&rec->orphan_extents);
 		rec->holes = RB_ROOT;
 
 		node = malloc(sizeof(*node));
@@ -656,6 +682,18 @@ static struct inode_record *get_inode_rec(struct cache_tree *inode_cache,
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
@@ -669,6 +707,7 @@ static void free_inode_rec(struct inode_record *rec)
 		list_del(&backref->list);
 		free(backref);
 	}
+	free_orphan_data_extents(&rec->orphan_extents);
 	free_file_extent_holes(&rec->holes);
 	free(rec);
 }
@@ -2484,6 +2523,67 @@ out:
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
@@ -2493,7 +2593,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
 			     I_ERR_NO_ORPHAN_ITEM |
 			     I_ERR_LINK_COUNT_WRONG |
-			     I_ERR_NO_INODE_ITEM)))
+			     I_ERR_NO_INODE_ITEM |
+			     I_ERR_FILE_EXTENT_ORPHAN)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
@@ -2515,6 +2616,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 
 	if (rec->errors & I_ERR_NO_INODE_ITEM)
 		ret = repair_inode_no_item(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_FILE_EXTENT_ORPHAN)
+		ret = repair_inode_orphan_extent(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_DIR_ISIZE_WRONG)
 		ret = repair_inode_isize(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
@@ -3126,34 +3229,6 @@ out:
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
@@ -3167,6 +3242,8 @@ static int check_fs_root(struct btrfs_root *root,
 	struct root_record *rec;
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct cache_tree corrupt_blocks;
+	struct orphan_data_extent *orphan;
+	struct orphan_data_extent *tmp;
 	enum btrfs_tree_block_status status;
 
 	/*
@@ -3177,6 +3254,7 @@ static int check_fs_root(struct btrfs_root *root,
 	 */
 	cache_tree_init(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = &corrupt_blocks;
+
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		rec = get_root_rec(root_cache, root->root_key.objectid);
 		if (btrfs_root_refs(root_item) > 0)
@@ -3188,6 +3266,17 @@ static int check_fs_root(struct btrfs_root *root,
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
@@ -3285,7 +3374,6 @@ skip_walking:
 
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
-	print_orphan_data_extents(&root->orphan_data_extents, root->objectid);
 	free_orphan_data_extents(&root->orphan_data_extents);
 	return ret;
 }
-- 
2.1.3

