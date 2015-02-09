Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62029 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbbBIUEC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:04:02 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 16/16] Btrfs-progs: fix bad extent flag
Date: Mon, 9 Feb 2015 15:03:19 -0500
Message-ID: <1423512199-16552-17-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can have FULL_BACKREF set or not set when we need the opposite, this patch
fixes this problem by setting a bit when the flag is set improperly.  This way
we can either correct the problem when we re-create the extent item if the
backrefs are also wrong, or we can just set the flag properly in the extent
item.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 261 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 159 insertions(+), 102 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9c379e6..ce0ac88 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -119,12 +119,13 @@ struct extent_record {
 	u64 info_objectid;
 	u32 num_duplicates;
 	u8 info_level;
+	int flag_block_full_backref;
 	unsigned int found_rec:1;
 	unsigned int content_checked:1;
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
 	unsigned int metadata:1;
-	unsigned int flag_block_full_backref:1;
+	unsigned int bad_full_backref:1;
 };
 
 struct inode_backref {
@@ -145,6 +146,7 @@ struct root_item_record {
 	struct list_head list;
 	u64 objectid;
 	u64 bytenr;
+	u64 last_snapshot;
 	u8 level;
 	u8 drop_level;
 	int level_size;
@@ -3679,7 +3681,8 @@ static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 {
 	if (rec->content_checked && rec->owner_ref_checked &&
 	    rec->extent_item_refs == rec->refs && rec->refs > 0 &&
-	    rec->num_duplicates == 0 && !all_backpointers_checked(rec, 0)) {
+	    rec->num_duplicates == 0 && !all_backpointers_checked(rec, 0) &&
+	    !rec->bad_full_backref) {
 		remove_cache_extent(extent_cache, &rec->cache);
 		free_all_extent_backrefs(rec);
 		list_del_init(&rec->list);
@@ -4338,6 +4341,8 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->owner_ref_checked = 0;
 	rec->num_duplicates = 0;
 	rec->metadata = metadata;
+	rec->flag_block_full_backref = -1;
+	rec->bad_full_backref = 0;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
 	INIT_LIST_HEAD(&rec->list);
@@ -5563,27 +5568,41 @@ static int is_dropped_key(struct btrfs_key *key,
 	return 0;
 }
 
+/*
+ * Here are the rules for FULL_BACKREF.
+ *
+ * 1) If BTRFS_HEADER_FLAG_RELOC is set then we have FULL_BACKREF set.
+ * 2) If btrfs_header_owner(buf) no longer points to buf then we have
+ *	FULL_BACKREF set.
+ * 3) We cow'ed the block walking down a reloc tree.  This is impossible to tell
+ *    if it happened after the relocation occurred since we'll have dropped the
+ *    reloc root, so it's entirely possible to have FULL_BACKREF set on buf and
+ *    have no real way to know for sure.
+ *
+ * We process the blocks one root at a time, and we start from the lowest root
+ * objectid and go to the highest.  So we can just lookup the owner backref for
+ * the record and if we don't find it then we know it doesn't exist and we have
+ * a FULL BACKREF.
+ *
+ * FIXME: if we ever start reclaiming root objectid's then we need to fix this
+ * assumption and simply indicate that we _think_ that the FULL BACKREF needs to
+ * be set or not and then we can check later once we've gathered all the refs.
+ */
 static int calc_extent_flag(struct btrfs_root *root,
 			   struct cache_tree *extent_cache,
 			   struct extent_buffer *buf,
 			   struct root_item_record *ri,
 			   u64 *flags)
 {
-	int i;
-	int nritems = btrfs_header_nritems(buf);
-	struct btrfs_key key;
 	struct extent_record *rec;
 	struct cache_extent *cache;
-	struct data_backref *dback;
 	struct tree_backref *tback;
-	struct extent_buffer *new_buf;
 	u64 owner = 0;
-	u64 bytenr;
-	u64 offset;
-	u64 ptr;
-	int size;
-	int ret;
-	u8 level;
+
+	cache = lookup_cache_extent(extent_cache, buf->start, 1);
+	/* we have added this extent before */
+	BUG_ON(!cache);
+	rec = container_of(cache, struct extent_record, cache);
 
 	/*
 	 * Except file/reloc tree, we can not have
@@ -5596,91 +5615,28 @@ static int calc_extent_flag(struct btrfs_root *root,
 	 */
 	if (buf->start == ri->bytenr)
 		goto normal;
-	if (btrfs_is_leaf(buf)) {
-		/*
-		 * we are searching from original root, world
-		 * peace is achieved, we use normal backref.
-		 */
-		owner = btrfs_header_owner(buf);
-		if (owner == ri->objectid)
-			goto normal;
-		/*
-		 * we check every eb here, and if any of
-		 * eb dosen't have original root refers
-		 * to this eb, we set full backref flag for
-		 * this extent, otherwise normal backref.
-		 */
-		for (i = 0; i < nritems; i++) {
-			struct btrfs_file_extent_item *fi;
-			btrfs_item_key_to_cpu(buf, &key, i);
 
-			if (key.type != BTRFS_EXTENT_DATA_KEY)
-				continue;
-			fi = btrfs_item_ptr(buf, i,
-					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) ==
-			    BTRFS_FILE_EXTENT_INLINE)
-				continue;
-			if (btrfs_file_extent_disk_bytenr(buf, fi) == 0)
-				continue;
-			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
-			cache = lookup_cache_extent(extent_cache, bytenr, 1);
-			if (!cache)
-				goto full_backref;
-			offset = btrfs_file_extent_offset(buf, fi);
-			rec = container_of(cache, struct extent_record, cache);
-			dback = find_data_backref(rec, 0, ri->objectid, owner,
-					key.offset - offset, 1, bytenr, bytenr);
-			if (!dback)
-				goto full_backref;
-		}
+	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
 		goto full_backref;
-	} else {
-		level = btrfs_header_level(buf);
-		for (i = 0; i < nritems; i++) {
-			ptr = btrfs_node_blockptr(buf, i);
-			size = btrfs_level_size(root, level);
-			if (i == 0) {
-				new_buf = read_tree_block(root, ptr, size, 0);
-				if (!extent_buffer_uptodate(new_buf)) {
-					free_extent_buffer(new_buf);
-					ret = -EIO;
-					return ret;
-				}
-				/*
-				 * we are searching from origin root, world
-				 * peace is achieved, we use normal backref.
-				 */
-				owner = btrfs_header_owner(new_buf);
-				free_extent_buffer(new_buf);
-				if (owner == ri->objectid)
-					goto normal;
-			}
-			cache = lookup_cache_extent(extent_cache, ptr, size);
-			if (!cache)
-				goto full_backref;
-			rec = container_of(cache, struct extent_record, cache);
-			tback = find_tree_backref(rec, 0, owner);
-			if (!tback)
-				goto full_backref;
-		}
 
-	}
+	owner = btrfs_header_owner(buf);
+	if (owner == ri->objectid)
+		goto normal;
+
+	tback = find_tree_backref(rec, 0, owner);
+	if (!tback)
+		goto full_backref;
 normal:
 	*flags = 0;
-	cache = lookup_cache_extent(extent_cache, buf->start, 1);
-	/* we have added this extent before */
-	BUG_ON(!cache);
-	rec = container_of(cache, struct extent_record, cache);
-	rec->flag_block_full_backref = 0;
+	if (rec->flag_block_full_backref != -1 &&
+	    rec->flag_block_full_backref != 0)
+		rec->bad_full_backref = 1;
 	return 0;
 full_backref:
 	*flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
-	cache = lookup_cache_extent(extent_cache, buf->start, 1);
-	/* we have added this extent before */
-	BUG_ON(!cache);
-	rec = container_of(cache, struct extent_record, cache);
-	rec->flag_block_full_backref = 1;
+	if (rec->flag_block_full_backref != -1 &&
+	    rec->flag_block_full_backref != 1)
+		rec->bad_full_backref = 1;
 	return 0;
 }
 
@@ -5767,10 +5723,6 @@ static int run_next_block(struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(buf);
 
-	/*
-	 * FIXME, this only works only if we don't have any full
-	 * backref mode.
-	 */
 	flags = 0;
 	if (!init_extent_tree) {
 		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
@@ -5793,11 +5745,37 @@ static int run_next_block(struct btrfs_root *root,
 	}
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
-		if (rec)
-			rec->flag_block_full_backref = 1;
+		if (ri != NULL &&
+		    ri->objectid != BTRFS_TREE_RELOC_OBJECTID &&
+		    ri->objectid == btrfs_header_owner(buf)) {
+			/*
+			 * Ok we got to this block from it's original owner and
+			 * we have FULL_BACKREF set.  Relocation can leave
+			 * converted blocks over so this is altogether possible,
+			 * however it's not possible if the generation > the
+			 * last snapshot, so check for this case.
+			 */
+			if (!btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC) &&
+			    btrfs_header_generation(buf) > ri->last_snapshot) {
+				flags &= ~BTRFS_BLOCK_FLAG_FULL_BACKREF;
+				rec->bad_full_backref = 1;
+			}
+		}
+	} else {
+		if (ri != NULL &&
+		    (ri->objectid == BTRFS_TREE_RELOC_OBJECTID ||
+		     btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))) {
+			flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+			rec->bad_full_backref = 1;
+		}
+	}
+
+	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
+		rec->flag_block_full_backref = 1;
 		parent = bytenr;
 		owner = 0;
 	} else {
+		rec->flag_block_full_backref = 0;
 		parent = 0;
 		owner = btrfs_header_owner(buf);
 	}
@@ -6283,7 +6261,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 					   parent, tback->root, 0, 0);
 		fprintf(stderr, "adding new tree backref on "
 			"start %llu len %llu parent %llu root %llu\n",
-			rec->start, rec->max_size, tback->parent, tback->root);
+			rec->start, rec->max_size, parent, tback->root);
 	}
 	if (ret)
 		goto fail;
@@ -7121,6 +7099,7 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 		if (!back->found_ref)
 			continue;
 
+		rec->bad_full_backref = 0;
 		ret = record_extent(trans, info, path, rec, back, allocated, flags);
 		allocated = 1;
 
@@ -7138,6 +7117,67 @@ out:
 	return ret;
 }
 
+static int fixup_extent_flags(struct btrfs_fs_info *fs_info,
+			      struct extent_record *rec)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_extent_item *ei;
+	struct btrfs_key key;
+	u64 flags;
+	int ret = 0;
+
+	key.objectid = rec->start;
+	if (rec->metadata) {
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = rec->info_level;
+	} else {
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = rec->max_size;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0) {
+		btrfs_free_path(path);
+		btrfs_commit_transaction(trans, root);
+		return ret;
+	} else if (ret) {
+		fprintf(stderr, "Didn't find extent for %llu\n",
+			(unsigned long long)rec->start);
+		btrfs_free_path(path);
+		btrfs_commit_transaction(trans, root);
+		return -ENOENT;
+	}
+
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_extent_item);
+	flags = btrfs_extent_flags(path->nodes[0], ei);
+	if (rec->flag_block_full_backref) {
+		fprintf(stderr, "setting full backref on %llu\n",
+			(unsigned long long)key.objectid);
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	} else {
+		fprintf(stderr, "clearing full backref on %llu\n",
+			(unsigned long long)key.objectid);
+		flags &= ~BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	}
+	btrfs_set_extent_flags(path->nodes[0], ei, flags);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	btrfs_free_path(path);
+	return btrfs_commit_transaction(trans, root);
+}
+
 /* right now we only prune from the extent allocation tree */
 static int prune_one_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *info,
@@ -7408,6 +7448,18 @@ static int check_extent_refs(struct btrfs_root *root,
 			err = 1;
 			cur_err = 1;
 		}
+		if (rec->bad_full_backref) {
+			fprintf(stderr, "bad full backref, on [%llu]\n",
+				(unsigned long long)rec->start);
+			if (repair) {
+				ret = fixup_extent_flags(root->fs_info, rec);
+				if (ret)
+					goto repair_abort;
+				fixed = 1;
+			}
+			err = 1;
+			cur_err = 1;
+		}
 
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
@@ -7702,7 +7754,7 @@ static int check_devices(struct rb_root *dev_cache,
 }
 
 static int add_root_item_to_list(struct list_head *head,
-				  u64 objectid, u64 bytenr,
+				  u64 objectid, u64 bytenr, u64 last_snapshot,
 				  u8 level, u8 drop_level,
 				  int level_size, struct btrfs_key *drop_key)
 {
@@ -7716,6 +7768,7 @@ static int add_root_item_to_list(struct list_head *head,
 	ri_rec->level = level;
 	ri_rec->level_size = level_size;
 	ri_rec->drop_level = drop_level;
+	ri_rec->last_snapshot = last_snapshot;
 	if (drop_key)
 		memcpy(&ri_rec->drop_key, drop_key, sizeof(*drop_key));
 	list_add_tail(&ri_rec->list, head);
@@ -7863,14 +7916,14 @@ again:
 	root1 = root->fs_info->tree_root;
 	level = btrfs_header_level(root1->node);
 	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
-				    root1->node->start, level, 0,
+				    root1->node->start, 0, level, 0,
 				    btrfs_level_size(root1, level), NULL);
 	if (ret < 0)
 		goto out;
 	root1 = root->fs_info->chunk_root;
 	level = btrfs_header_level(root1->node);
 	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
-				    root1->node->start, level, 0,
+				    root1->node->start, 0, level, 0,
 				    btrfs_level_size(root1, level), NULL);
 	if (ret < 0)
 		goto out;
@@ -7895,15 +7948,18 @@ again:
 		btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
 		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
+			u64 last_snapshot;
 
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			last_snapshot = btrfs_root_last_snapshot(&ri);
 			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
 				level = btrfs_root_level(&ri);
 				level_size = btrfs_level_size(root, level);
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
-						btrfs_root_bytenr(&ri), level,
+						btrfs_root_bytenr(&ri),
+						last_snapshot, level,
 						0, level_size, NULL);
 				if (ret < 0)
 					goto out;
@@ -7916,7 +7972,8 @@ again:
 				ret = add_root_item_to_list(&dropping_trees,
 						objectid,
 						btrfs_root_bytenr(&ri),
-						level, ri.drop_level,
+						last_snapshot, level,
+						ri.drop_level,
 						level_size, &found_key);
 				if (ret < 0)
 					goto out;
-- 
1.8.3.1

