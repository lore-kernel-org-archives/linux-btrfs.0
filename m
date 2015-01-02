Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbbABHOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 02:14:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t027E2Ou008890
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Jan 2015 15:14:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/5] btrfs-progs: Record orphan data extent ref to corresponding root.
Date: Fri, 2 Jan 2015 15:12:29 +0800
Message-ID: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
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
Changelog:
v2:
   Do not record file extent if the file extent pointed by the data
   backref exists but only bytenr mismatch.
   This fix a regression bug causing fsck-test 001 fail.
---
 cmds-check.c | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 ctree.h      |  10 ++++
 disk-io.c    |   1 +
 3 files changed, 158 insertions(+), 8 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d2d218a..20a6ac2 100644
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
@@ -2901,6 +2915,34 @@ out_free_path:
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
@@ -3032,6 +3074,8 @@ skip_walking:
 
 	free_corrupt_blocks_tree(&corrupt_blocks);
 	root->fs_info->corrupt_blocks = NULL;
+	print_orphan_data_extents(&root->orphan_data_extents, root->objectid);
+	free_orphan_data_extents(&root->orphan_data_extents);
 	return ret;
 }
 
@@ -6544,6 +6588,88 @@ static int find_possible_backrefs(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * Record orphan data ref into corresponding root.
+ *
+ * Return 0 if the extent item contains data ref and recorded.
+ * Return 1 if the extent item contains no useful data ref
+ *   On that case, it may contains only shared_dataref or metadata backref
+ *   or the file extent exists(this should be handled by the extent bytenr
+ *   recovery routine)
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
+	struct btrfs_path *path;
+	int recorded_data_ref = 0;
+	int ret = 0;
+
+	if (rec->metadata)
+		return 1;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
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
+
+		key.objectid = dback->owner;
+		key.type = BTRFS_EXTENT_DATA_KEY;
+		key.offset = dback->offset;
+
+		ret = btrfs_search_slot(NULL, dest_root, &key, path, 0, 0);
+		/*
+		 * For ret < 0, it's OK since the fs-tree may be corrupted,
+		 * we need to record it for inode/file extent rebuild.
+		 * For ret > 0, we record it only for file extent rebuild.
+		 * For ret == 0, the file extent exists but only bytenr
+		 * mismatch, let the original bytenr fix routine to handle,
+		 * don't record it.
+		 */
+		if (ret == 0)
+			continue;
+		ret = 0;
+		orphan = malloc(sizeof(*orphan));
+		if (!orphan) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(&orphan->list);
+		orphan->root = dback->root;
+		orphan->objectid = dback->owner;
+		orphan->offset = dback->offset;
+		orphan->disk_bytenr = rec->cache.start;
+		orphan->disk_len = rec->cache.size;
+		list_add(&dest_root->orphan_data_extents, &orphan->list);
+		recorded_data_ref = 1;
+	}
+out:
+	btrfs_free_path(path);
+	if (!ret)
+		return !recorded_data_ref;
+	else
+		return ret;
+}
+
+/*
  * when an incorrect extent item is found, this will delete
  * all of the existing entries for it and recreate them
  * based on what the tree scan found.
@@ -6760,6 +6886,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	int fixed = 0;
 	int had_dups = 0;
+	int recorded = 0;
 
 	if (repair) {
 		/*
@@ -6823,6 +6950,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 
 	while(1) {
 		fixed = 0;
+		recorded = 0;
 		cache = search_cache_extent(extent_cache, 0);
 		if (!cache)
 			break;
@@ -6840,12 +6968,24 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
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
 
@@ -6855,21 +6995,20 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
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
index 2bf8586..521e1bd 100644
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
2.2.1

