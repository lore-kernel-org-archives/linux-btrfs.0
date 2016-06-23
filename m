Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbcFWT0J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 15:26:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 18073AC35
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 19:26:08 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: check: add helpers for converting between structures
Date: Thu, 23 Jun 2016 15:26:04 -0400
Message-Id: <1466709966-31506-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1466709966-31506-1-git-send-email-jeffm@suse.com>
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We either open code list_entry calls or outright cast between types.  The
compiler will do the right thing if we use static inlines to do
typesafe conversions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-check.c | 100 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 34 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ec0bbfd..a202a9d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -84,6 +84,12 @@ struct extent_backref {
 	unsigned int broken:1;
 };
 
+static inline struct extent_backref *
+to_extent_backref(struct list_head *entry)
+{
+	return list_entry(entry, struct extent_backref, list);
+}
+
 struct data_backref {
 	struct extent_backref node;
 	union {
@@ -99,6 +105,12 @@ struct data_backref {
 	u32 found_ref;
 };
 
+static inline struct data_backref *
+to_data_backref(struct extent_backref *back)
+{
+	return container_of(back, struct data_backref, node);
+}
+
 /*
  * Much like data_backref, just removed the undetermined members
  * and change it to use list_head.
@@ -122,6 +134,12 @@ struct tree_backref {
 	};
 };
 
+static inline struct tree_backref *
+to_tree_backref(struct extent_backref *back)
+{
+	return container_of(back, struct tree_backref, node);
+}
+
 /* Explicit initialization for extent_record::flag_block_full_backref */
 enum { FLAG_UNSET = 2 };
 
@@ -152,6 +170,12 @@ struct extent_record {
 	unsigned int wrong_chunk_type:1;
 };
 
+static inline struct extent_record *
+to_extent_record(struct list_head *entry)
+{
+	return container_of(entry, struct extent_record, list);
+}
+
 struct inode_backref {
 	struct list_head list;
 	unsigned int found_dir_item:1;
@@ -166,6 +190,12 @@ struct inode_backref {
 	char name[0];
 };
 
+static inline struct inode_backref *
+to_inode_backref(struct list_head *entry)
+{
+	return list_entry(entry, struct inode_backref, list);
+}
+
 struct root_item_record {
 	struct list_head list;
 	u64 objectid;
@@ -256,6 +286,12 @@ struct root_backref {
 	char name[0];
 };
 
+static inline struct root_backref *
+to_root_backref(struct list_head *entry)
+{
+	return list_entry(entry, struct root_backref, list);
+}
+
 struct root_record {
 	struct list_head backrefs;
 	struct cache_extent cache;
@@ -834,8 +870,7 @@ static void free_inode_rec(struct inode_record *rec)
 		return;
 
 	while (!list_empty(&rec->backrefs)) {
-		backref = list_entry(rec->backrefs.next,
-				     struct inode_backref, list);
+		backref = to_inode_backref(rec->backrefs.next);
 		list_del(&backref->list);
 		free(backref);
 	}
@@ -1979,7 +2014,7 @@ static int check_root_dir(struct inode_record *rec)
 		goto out;
 	if (list_empty(&rec->backrefs))
 		goto out;
-	backref = list_entry(rec->backrefs.next, struct inode_backref, list);
+	backref = to_inode_backref(rec->backrefs.next);
 	if (!backref->found_inode_ref)
 		goto out;
 	if (backref->index != 0 || backref->namelen != 2 ||
@@ -3116,8 +3151,7 @@ static void free_root_record(struct cache_extent *cache)
 
 	rec = container_of(cache, struct root_record, cache);
 	while (!list_empty(&rec->backrefs)) {
-		backref = list_entry(rec->backrefs.next,
-				     struct root_backref, list);
+		backref = to_root_backref(rec->backrefs.next);
 		list_del(&backref->list);
 		free(backref);
 	}
@@ -3751,14 +3785,14 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 	int err = 0;
 
 	while(cur != &rec->backrefs) {
-		back = list_entry(cur, struct extent_backref, list);
+		back = to_extent_backref(cur);
 		cur = cur->next;
 		if (!back->found_extent_tree) {
 			err = 1;
 			if (!print_errs)
 				goto out;
 			if (back->is_data) {
-				dback = (struct data_backref *)back;
+				dback = to_data_backref(back);
 				fprintf(stderr, "Backref %llu %s %llu"
 					" owner %llu offset %llu num_refs %lu"
 					" not found in extent tree\n",
@@ -3772,7 +3806,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)dback->offset,
 					(unsigned long)dback->num_refs);
 			} else {
-				tback = (struct tree_backref *)back;
+				tback = to_tree_backref(back);
 				fprintf(stderr, "Backref %llu parent %llu"
 					" root %llu not found in extent tree\n",
 					(unsigned long long)rec->start,
@@ -3784,7 +3818,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 			err = 1;
 			if (!print_errs)
 				goto out;
-			tback = (struct tree_backref *)back;
+			tback = to_tree_backref(back);
 			fprintf(stderr, "Backref %llu %s %llu not referenced back %p\n",
 				(unsigned long long)rec->start,
 				back->full_backref ? "parent" : "root",
@@ -3793,7 +3827,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				(unsigned long long)tback->root, back);
 		}
 		if (back->is_data) {
-			dback = (struct data_backref *)back;
+			dback = to_data_backref(back);
 			if (dback->found_ref != dback->num_refs) {
 				err = 1;
 				if (!print_errs)
@@ -3837,7 +3871,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 		if (!back->is_data) {
 			found += 1;
 		} else {
-			dback = (struct data_backref *)back;
+			dback = to_data_backref(back);
 			found += dback->found_ref;
 		}
 	}
@@ -3861,7 +3895,7 @@ static int free_all_extent_backrefs(struct extent_record *rec)
 	struct list_head *cur;
 	while (!list_empty(&rec->backrefs)) {
 		cur = rec->backrefs.next;
-		back = list_entry(cur, struct extent_backref, list);
+		back = to_extent_backref(cur);
 		list_del(cur);
 		free(back);
 	}
@@ -3922,7 +3956,7 @@ static int check_owner_ref(struct btrfs_root *root,
 			continue;
 		if (node->full_backref)
 			continue;
-		back = (struct tree_backref *)node;
+		back = to_tree_backref(node);
 		if (btrfs_header_owner(buf) == back->root)
 			return 0;
 	}
@@ -3966,11 +4000,11 @@ static int is_extent_tree_record(struct extent_record *rec)
 	int is_extent = 0;
 
 	while(cur != &rec->backrefs) {
-		node = list_entry(cur, struct extent_backref, list);
+		node = to_extent_backref(cur);
 		cur = cur->next;
 		if (node->is_data)
 			return 0;
-		back = (struct tree_backref *)node;
+		back = to_tree_backref(node);
 		if (node->full_backref)
 			return 0;
 		if (back->root == BTRFS_EXTENT_TREE_OBJECTID)
@@ -4353,11 +4387,11 @@ static struct tree_backref *find_tree_backref(struct extent_record *rec,
 	struct tree_backref *back;
 
 	while(cur != &rec->backrefs) {
-		node = list_entry(cur, struct extent_backref, list);
+		node = to_extent_backref(cur);
 		cur = cur->next;
 		if (node->is_data)
 			continue;
-		back = (struct tree_backref *)node;
+		back = to_tree_backref(node);
 		if (parent > 0) {
 			if (!node->full_backref)
 				continue;
@@ -4404,11 +4438,11 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 	struct data_backref *back;
 
 	while(cur != &rec->backrefs) {
-		node = list_entry(cur, struct extent_backref, list);
+		node = to_extent_backref(cur);
 		cur = cur->next;
 		if (!node->is_data)
 			continue;
-		back = (struct data_backref *)node;
+		back = to_data_backref(node);
 		if (parent > 0) {
 			if (!node->full_backref)
 				continue;
@@ -4494,8 +4528,7 @@ static void check_extent_type(struct extent_record *rec)
 		struct tree_backref *tback;
 		u64 bg_type;
 
-		node = list_entry(rec->backrefs.next, struct extent_backref,
-				  list);
+		node = to_extent_backref(rec->backrefs.next);
 		if (node->is_data) {
 			/* tree block shouldn't have data backref */
 			rec->wrong_chunk_type = 1;
@@ -6507,7 +6540,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 		} else {
 			struct btrfs_disk_key copy_key;;
 
-			tback = (struct tree_backref *)back;
+			tback = to_tree_backref(back);
 			bi = (struct btrfs_tree_block_info *)(ei + 1);
 			memset_extent_buffer(leaf, 0, (unsigned long)bi,
 					     sizeof(*bi));
@@ -6536,7 +6569,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 		u64 parent;
 		int i;
 
-		dback = (struct data_backref *)back;
+		dback = to_data_backref(back);
 		if (back->full_backref)
 			parent = dback->parent;
 		else
@@ -6574,7 +6607,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 	} else {
 		u64 parent;
 
-		tback = (struct tree_backref *)back;
+		tback = to_tree_backref(back);
 		if (back->full_backref)
 			parent = tback->parent;
 		else
@@ -6823,7 +6856,7 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 		if (back->full_backref || !back->is_data)
 			continue;
 
-		dback = (struct data_backref *)back;
+		dback = to_data_backref(back);
 
 		/*
 		 * We only pay attention to backrefs that we found a real
@@ -6949,7 +6982,7 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 		if (back->full_backref || !back->is_data)
 			continue;
 
-		dback = (struct data_backref *)back;
+		dback = to_data_backref(back);
 
 		/*
 		 * Still ignoring backrefs that don't have a real ref attached
@@ -7013,7 +7046,7 @@ static int process_duplicates(struct btrfs_root *root,
 	 */
 	remove_cache_extent(extent_cache, &rec->cache);
 
-	good = list_entry(rec->dups.next, struct extent_record, list);
+	good = to_extent_record(rec->dups.next);
 	list_del_init(&good->list);
 	INIT_LIST_HEAD(&good->backrefs);
 	INIT_LIST_HEAD(&good->dups);
@@ -7147,7 +7180,7 @@ static int delete_duplicate_records(struct btrfs_root *root,
 		ret = err;
 out:
 	while (!list_empty(&delete_list)) {
-		tmp = list_entry(delete_list.next, struct extent_record, list);
+		tmp = to_extent_record(delete_list.next);
 		list_del_init(&tmp->list);
 		if (tmp == rec)
 			continue;
@@ -7155,7 +7188,7 @@ out:
 	}
 
 	while (!list_empty(&rec->dups)) {
-		tmp = list_entry(rec->dups.next, struct extent_record, list);
+		tmp = to_extent_record(rec->dups.next);
 		list_del_init(&tmp->list);
 		free(tmp);
 	}
@@ -7187,7 +7220,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 		if (back->full_backref || !back->is_data)
 			continue;
 
-		dback = (struct data_backref *)back;
+		dback = to_data_backref(back);
 
 		/* We found this one, we don't need to do a lookup */
 		if (dback->found_ref)
@@ -7286,7 +7319,7 @@ static int record_orphan_data_extents(struct btrfs_fs_info *fs_info,
 		if (back->full_backref || !back->is_data ||
 		    !back->found_extent_tree)
 			continue;
-		dback = (struct data_backref *)back;
+		dback = to_data_backref(back);
 		if (dback->found_ref)
 			continue;
 		key.objectid = dback->root;
@@ -7403,7 +7436,7 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 
 	/* step three, recreate all the refs we did find */
 	while(cur != &rec->backrefs) {
-		back = list_entry(cur, struct extent_backref, list);
+		back = to_extent_backref(cur);
 		cur = cur->next;
 
 		/*
@@ -7660,8 +7693,7 @@ static int check_extent_refs(struct btrfs_root *root,
 	 * belong to a different extent item and not the weird duplicate one.
 	 */
 	while (repair && !list_empty(&duplicate_extents)) {
-		rec = list_entry(duplicate_extents.next, struct extent_record,
-				 list);
+		rec = to_extent_record(duplicate_extents.next);
 		list_del_init(&rec->list);
 
 		/* Sometimes we can find a backref before we find an actual
-- 
2.7.1

