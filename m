Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53372 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3FCTSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 15:18:47 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 506207C0434
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 13:18:47 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id ZHxF2ry7r0ZCNlv4 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 13:18:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix fsck dealing with finding backrefs first
Date: Mon, 3 Jun 2013 15:18:43 -0400
Message-ID: <1370287123-3365-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a problem where if we find a backref extent record first that doesn't
match a extent item we will delete some of the duplicates but not others.  In
order to deal with this we need to make sure we only pay attention to duplicates
that actually have duplicate extent items.  If a extent_rec has a duplicate but
the record itself doesn't have an associated extent item we promote the
duplicate to the extent record and just discard the original extent_rec since it
was just added by the backref.  We copy the backref onto the promoted extent
record and then continue processing.  This allowed me to fix a file system that
previously was not able to be fixed by fsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 119 insertions(+), 15 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 288b36e..bbef89a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -88,6 +88,7 @@ struct extent_record {
 	struct list_head list;
 	struct cache_extent cache;
 	struct btrfs_disk_key parent_key;
+	unsigned int found_rec;
 	u64 start;
 	u64 max_size;
 	u64 nr;
@@ -95,13 +96,12 @@ struct extent_record {
 	u64 extent_item_refs;
 	u64 generation;
 	u64 info_objectid;
+	u64 num_duplicates;
 	u8 info_level;
 	unsigned int content_checked:1;
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
 	unsigned int metadata:1;
-	unsigned int found_rec:1;
-	unsigned int has_duplicate:1;
 };
 
 struct inode_backref {
@@ -2010,9 +2010,10 @@ static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 {
 	if (rec->content_checked && rec->owner_ref_checked &&
 	    rec->extent_item_refs == rec->refs && rec->refs > 0 &&
-	    !all_backpointers_checked(rec, 0)) {
+	    rec->num_duplicates == 0 && !all_backpointers_checked(rec, 0)) {
 		remove_cache_extent(extent_cache, &rec->cache);
 		free_all_extent_backrefs(rec);
+		list_del_init(&rec->list);
 		free(rec);
 	}
 	return 0;
@@ -2304,7 +2305,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		 * the backrefs.
 		 */
 		if (extent_rec) {
-			if (rec->found_rec) {
+			if (start != rec->start || rec->found_rec) {
 				struct extent_record *tmp;
 
 				dup = 1;
@@ -2326,13 +2327,14 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 				tmp->nr = nr;
 				tmp->found_rec = 1;
 				tmp->metadata = metadata;
+				tmp->extent_item_refs = extent_item_refs;
 				INIT_LIST_HEAD(&tmp->list);
 				list_add_tail(&tmp->list, &rec->dups);
-				rec->has_duplicate = 1;
+				rec->num_duplicates++;
 			} else {
 				rec->nr = nr;
+				rec->found_rec = 1;
 			}
-			rec->found_rec = 1;
 		}
 
 		if (extent_item_refs && !dup) {
@@ -2369,7 +2371,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->found_rec = extent_rec;
 	rec->content_checked = 0;
 	rec->owner_ref_checked = 0;
-	rec->has_duplicate = 0;
+	rec->num_duplicates = 0;
 	rec->metadata = metadata;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
@@ -4023,6 +4025,85 @@ out:
 	return ret;
 }
 
+static int process_duplicates(struct btrfs_root *root,
+			      struct cache_tree *extent_cache,
+			      struct extent_record *rec)
+{
+	struct extent_record *good, *tmp;
+	struct cache_extent *cache;
+	int ret;
+
+	/*
+	 * If we found a extent record for this extent then return, or if we
+	 * have more than one duplicate we are likely going to need to delete
+	 * something.
+	 */
+	if (rec->found_rec || rec->num_duplicates > 1)
+		return 0;
+
+	/* Shouldn't happen but just in case */
+	BUG_ON(!rec->num_duplicates);
+
+	/*
+	 * So this happens if we end up with a backref that doesn't match the
+	 * actual extent entry.  So either the backref is bad or the extent
+	 * entry is bad.  Either way we want to have the extent_record actually
+	 * reflect what we found in the extent_tree, so we need to take the
+	 * duplicate out and use that as the extent_record since the only way we
+	 * get a duplicate is if we find a real life BTRFS_EXTENT_ITEM_KEY.
+	 */
+	remove_cache_extent(extent_cache, &rec->cache);
+
+	good = list_entry(rec->dups.next, struct extent_record, list);
+	list_del_init(&good->list);
+	INIT_LIST_HEAD(&good->backrefs);
+	INIT_LIST_HEAD(&good->dups);
+	good->cache.start = good->start;
+	good->cache.size = good->nr;
+	good->content_checked = 0;
+	good->owner_ref_checked = 0;
+	good->num_duplicates = 0;
+	good->refs = rec->refs;
+	list_splice_init(&rec->backrefs, &good->backrefs);
+	while (1) {
+		cache = find_cache_extent(extent_cache, good->start,
+					  good->nr);
+		if (!cache)
+			break;
+		tmp = container_of(cache, struct extent_record, cache);
+
+		/*
+		 * If we find another overlapping extent and it's found_rec is
+		 * set then it's a duplicate and we need to try and delete
+		 * something.
+		 */
+		if (tmp->found_rec || tmp->num_duplicates > 0) {
+			if (list_empty(&good->list))
+				list_add_tail(&good->list,
+					      &duplicate_extents);
+			good->num_duplicates += tmp->num_duplicates + 1;
+			list_splice_init(&tmp->dups, &good->dups);
+			list_del_init(&tmp->list);
+			list_add_tail(&tmp->list, &good->dups);
+			remove_cache_extent(extent_cache, &tmp->cache);
+			continue;
+		}
+
+		/*
+		 * Ok we have another non extent item backed extent rec, so lets
+		 * just add it to this extent and carry on like we did above.
+		 */
+		good->refs += tmp->refs;
+		list_splice_init(&tmp->backrefs, &good->backrefs);
+		remove_cache_extent(extent_cache, &tmp->cache);
+		free(tmp);
+	}
+	ret = insert_existing_cache_extent(extent_cache, &good->cache);
+	BUG_ON(ret);
+	free(rec);
+	return good->num_duplicates ? 0 : 1;
+}
+
 static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root,
 				    struct extent_record *rec)
@@ -4030,6 +4111,7 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 	LIST_HEAD(delete_list);
 	struct btrfs_path *path;
 	struct extent_record *tmp, *good, *n;
+	int nr_del = 0;
 	int ret = 0;
 	struct btrfs_key key;
 
@@ -4069,6 +4151,8 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 
 	root = root->fs_info->extent_root;
 	list_for_each_entry(tmp, &delete_list, list) {
+		if (tmp->found_rec == 0)
+			continue;
 		key.objectid = tmp->start;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.offset = tmp->nr;
@@ -4091,6 +4175,7 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 		btrfs_release_path(root, path);
+		nr_del++;
 	}
 
 out:
@@ -4110,7 +4195,10 @@ out:
 
 	btrfs_free_path(path);
 
-	return ret;
+	if (!ret && !nr_del)
+		rec->num_duplicates = 0;
+
+	return ret ? ret : nr_del;
 }
 
 /*
@@ -4361,7 +4449,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct cache_tree *extent_cache, int repair)
 {
-	struct extent_record *rec, *n;
+	struct extent_record *rec;
 	struct cache_extent *cache;
 	int err = 0;
 	int ret = 0;
@@ -4404,14 +4492,30 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	 * could mess up the extent tree when we have backrefs that actually
 	 * belong to a different extent item and not the weird duplicate one.
 	 */
-	list_for_each_entry_safe(rec, n, &duplicate_extents, list) {
-		if (!repair)
-			break;
+	while (repair && !list_empty(&duplicate_extents)) {
+		rec = list_entry(duplicate_extents.next, struct extent_record,
+				 list);
 		list_del_init(&rec->list);
-		had_dups = 1;
+
+		/* Sometimes we can find a backref before we find an actual
+		 * extent, so we need to process it a little bit to see if there
+		 * truly are multiple EXTENT_ITEM_KEY's for the same range, or
+		 * if this is a backref screwup.  If we need to delete stuff
+		 * process_duplicates() will return 0, otherwise it will return
+		 * 1 and we
+		 */
+		if (process_duplicates(root, extent_cache, rec))
+			continue;
 		ret = delete_duplicate_records(trans, root, rec);
-		if (ret)
+		if (ret < 0)
 			return ret;
+		/*
+		 * delete_duplicate_records will return the number of entries
+		 * deleted, so if it's greater than 0 then we know we actually
+		 * did something and we need to remove.
+		 */
+		if (ret)
+			had_dups = 1;
 	}
 
 	if (had_dups)
@@ -4423,7 +4527,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		if (!cache)
 			break;
 		rec = container_of(cache, struct extent_record, cache);
-		if (rec->has_duplicate) {
+		if (rec->num_duplicates) {
 			fprintf(stderr, "extent item %llu has multiple extent "
 				"items\n", (unsigned long long)rec->start);
 			err = 1;
-- 
1.7.7.6

