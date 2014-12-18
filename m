Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54475 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbaLRDkF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 22:40:05 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBI3dbg3002156
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 11:39:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: Record orphan data extent ref to corresponding root.
Date: Thu, 18 Dec 2014 11:37:56 +0800
Message-ID: <1418873880-7916-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418873880-7916-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, when a extent's data ref points to a invalid key in
fs tree, this happens if a leaf/node of fs tree is corrupted, btrfsck
can't do any repair and just exit.

In fact, such problem can be handled in fs tree repair routines, rebuild
the inode item(if missing) and add back the extent data (with some
assumption).

So this patch records such data extent refs for later fs tree recovery
routine.

TODO:
    Restore orphan data extent refs into btrfs_root is not the best
    method. It's best to directly restore it into inode_record, however
    current extent tree and fs tree can't cooperate together, so use
    btrfs_root as a temporary storage until inode_cache is built.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 ctree.h      |  10 +++++
 disk-io.c    |   1 +
 3 files changed, 129 insertions(+), 8 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6eea36c..059c53a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -83,6 +83,20 @@ struct data_backref {
 	u32 found_ref;
 };
 
+/*
+ * Much like data_backref, just removed the undetermined members
+ * and change it to use list_head.
+ * Stored in the root->orphan_data_extents list
+ */
+struct orphan_data_extent {
+	struct list_head list;
+	u64 root;
+	u64 objectid;
+	u64 offset;
+	u64 disk_bytenr;
+	u64 disk_len;
+};
+
 struct tree_backref {
 	struct extent_backref node;
 	union {
@@ -2894,6 +2908,34 @@ out:
 	return ret;
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
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
 			 struct walk_control *wc)
@@ -3025,6 +3067,8 @@ skip_walking:
 
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
+	print_orphan_data_extents(&root->orphan_data_extents, root->objectid);
+	free_orphan_data_extents(&root->orphan_data_extents);
 	return ret;
 }
 
@@ -6537,6 +6581,59 @@ static int find_possible_backrefs(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * Record orphan data ref into corresponding root.
+ *
+ * Return 0 if the extent item contains data ref and recorded.
+ * Return 1 if the extent item contains no data ref
+ * (Only shared data ref or metadata and we can't use it)
+ * Return <0 if something goes wrong.
+ */
+static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
+				      struct extent_record *rec)
+{
+	struct btrfs_key key;
+	struct btrfs_root *dest_root;
+	struct extent_backref *back;
+	struct data_backref *dback;
+	struct orphan_data_extent *orphan;
+	int found_data_ref = 0;
+
+	if (rec->metadata)
+		return 1;
+	list_for_each_entry(back, &rec->backrefs, list) {
+		if (back->full_backref || !back->is_data ||
+		    !back->found_extent_tree)
+			continue;
+		dback = (struct data_backref *)back;
+		if (dback->found_ref)
+			continue;
+		key.objectid = dback->root;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		dest_root = btrfs_read_fs_root(fs_info, &key);
+
+		/* For non-exist root we just skip it */
+		if (IS_ERR(dest_root) || !dest_root)
+			continue;
+		orphan = malloc(sizeof(*orphan));
+		if (!orphan)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&orphan->list);
+		orphan->root = dback->root;
+		orphan->objectid = dback->owner;
+		orphan->offset = dback->offset;
+		orphan->disk_bytenr = rec->cache.start;
+		orphan->disk_len = rec->cache.size;
+		list_add(&dest_root->orphan_data_extents, &orphan->list);
+		found_data_ref = 1;
+	}
+	if (!found_data_ref)
+		return 1;
+	return 0;
+}
+
+/*
  * when an incorrect extent item is found, this will delete
  * all of the existing entries for it and recreate them
  * based on what the tree scan found.
@@ -6753,6 +6850,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int fixed = 0;
 	int had_dups = 0;
+	int recorded = 0;
 
 	if (repair) {
 		/*
@@ -6816,6 +6914,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 
 	while(1) {
 		fixed = 0;
+		recorded = 0;
 		cache = search_cache_extent(extent_cache, 0);
 		if (!cache)
 			break;
@@ -6833,12 +6932,24 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			fprintf(stderr, "extent item %llu, found %llu\n",
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
-			if (!fixed && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info,
+			ret = record_orphan_data_extents(root->fs_info, rec);
+			if (ret < 0)
+				goto repair_abort;
+			if (ret == 0) {
+				recorded = 1;
+			} else {
+				/*
+				 * we can't use the extent to repair file
+				 * extent, let the fallback method handle it.
+				 */
+				if (!fixed && repair) {
+					ret = fixup_extent_refs(trans,
+							root->fs_info,
 							extent_cache, rec);
-				if (ret)
-					goto repair_abort;
-				fixed = 1;
+					if (ret)
+						goto repair_abort;
+					fixed = 1;
+				}
 			}
 			err = 1;
 
@@ -6848,21 +6959,20 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 
-			if (!fixed && repair) {
+			if (!fixed && !recorded && repair) {
 				ret = fixup_extent_refs(trans, root->fs_info,
 							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
 				fixed = 1;
 			}
-
 			err = 1;
 		}
 		if (!rec->owner_ref_checked) {
 			fprintf(stderr, "owner ref check failed [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
-			if (!fixed && repair) {
+			if (!fixed && !recorded && repair) {
 				ret = fixup_extent_refs(trans, root->fs_info,
 							extent_cache, rec);
 				if (ret)
diff --git a/ctree.h b/ctree.h
index 7861940..0963fc0 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1039,6 +1039,16 @@ struct btrfs_root {
 	u64 highest_inode;
 	u64 last_inode_alloc;
 
+	/*
+	 * Record orphan data extent ref
+	 *
+	 * TODO: Don't restore things in btrfs_root.
+	 * Directly record it into inode_record, which needs a lot of
+	 * infrastructure change to allow cooperation between extent
+	 * and fs tree scan.
+	 */
+	struct list_head orphan_data_extents;
+
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 	struct rb_node rb_node;
diff --git a/disk-io.c b/disk-io.c
index 03edf8e..91daea5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -377,6 +377,7 @@ int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->last_inode_alloc = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
+	INIT_LIST_HEAD(&root->orphan_data_extents);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	root->root_key.objectid = objectid;
-- 
2.1.3

