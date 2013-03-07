Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39808 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3CGTYE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 14:24:04 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 853917C0430
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 12:24:04 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id tgNccMc4ro6UhgCx (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 12:24:03 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add skinny metadata support to progs
Date: Thu, 7 Mar 2013 14:31:14 -0500
Message-ID: <1362684674-19468-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes up the progs to properly deal with skinny metadata.  This adds the -x
option to mkfs and btrfstune for enabling the skinny metadata option.  This also
makes changes to fsck so it can properly deal with the skinny metadata entries.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfstune.c   |   28 +++++++-
 cmds-check.c  |   78 ++++++++++++++------
 ctree.c       |    6 +-
 ctree.h       |   23 +++++-
 extent-tree.c |  226 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 mkfs.c        |   13 +++-
 print-tree.c  |   20 ++++-
 7 files changed, 334 insertions(+), 60 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 6e68bda..74ee8eb 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -81,11 +81,28 @@ int enable_extrefs_flag(struct btrfs_root *root)
 	return 0;
 }
 
+int enable_skinny_metadata(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+
+	disk_super = &root->fs_info->super_copy;
+	super_flags = btrfs_super_incompat_flags(disk_super);
+	super_flags |= BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA;
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_incompat_flags(disk_super, super_flags);
+	btrfs_commit_transaction(trans, root);
+
+	return 0;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
 	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
+	fprintf(stderr, "\t-x enable skinny metadata extent refs\n");
 }
 
 int main(int argc, char *argv[])
@@ -95,10 +112,11 @@ int main(int argc, char *argv[])
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	int seeding_value = 0;
+	int skinny_flag = 0;
 	int ret;
 
 	while(1) {
-		int c = getopt(argc, argv, "S:r");
+		int c = getopt(argc, argv, "S:rx");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -109,6 +127,9 @@ int main(int argc, char *argv[])
 		case 'r':
 			extrefs_flag = 1;
 			break;
+		case 'x':
+			skinny_flag = 1;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -145,6 +166,11 @@ int main(int argc, char *argv[])
 		success++;
 	}
 
+	if (skinny_flag) {
+		enable_skinny_metadata(root);
+		success++;
+	}
+
 	if (success > 0) {
 		ret = 0;
 	} else {
diff --git a/cmds-check.c b/cmds-check.c
index d63e945..35e9177 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -43,6 +43,7 @@ static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
 static u64 total_btree_bytes = 0;
 static u64 total_fs_tree_bytes = 0;
+static u64 total_extent_tree_bytes = 0;
 static u64 btree_space_waste = 0;
 static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
@@ -91,6 +92,7 @@ struct extent_record {
 	unsigned int content_checked:1;
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
+	unsigned int metadata:1;
 };
 
 struct inode_backref {
@@ -1208,7 +1210,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
 	ret = btrfs_lookup_extent_info(NULL, root,
 				       path->nodes[*level]->start,
-				       path->nodes[*level]->len, &refs, NULL);
+				       *level, 1, &refs, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -1236,8 +1238,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
 		blocksize = btrfs_level_size(root, *level - 1);
-		ret = btrfs_lookup_extent_info(NULL, root, bytenr, blocksize,
-					       &refs, NULL);
+		ret = btrfs_lookup_extent_info(NULL, root, bytenr, *level - 1,
+					       1, &refs, NULL);
 		if (ret < 0)
 			refs = 0;
 
@@ -2224,7 +2226,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 			  struct btrfs_key *parent_key,
 			  u64 start, u64 nr, u64 extent_item_refs,
 			  int is_root, int inc_ref, int set_checked,
-			  u64 max_size)
+			  int metadata, u64 max_size)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
@@ -2277,6 +2279,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->nr = max(nr, max_size);
 	rec->content_checked = 0;
 	rec->owner_ref_checked = 0;
+	rec->metadata = metadata;
 	INIT_LIST_HEAD(&rec->backrefs);
 
 	if (is_root)
@@ -2320,7 +2323,8 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
-		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0, 0);
+		add_extent_rec(extent_cache, NULL, bytenr,
+			       1, 0, 0, 0, 0, 1, 0);
 		cache = find_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
@@ -2368,7 +2372,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
 		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0,
-			       max_size);
+			       0, max_size);
 		cache = find_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
@@ -2506,7 +2510,8 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 }
 #endif
 
-static int process_extent_item(struct cache_tree *extent_cache,
+static int process_extent_item(struct btrfs_root *root,
+			       struct cache_tree *extent_cache,
 			       struct extent_buffer *eb, int slot)
 {
 	struct btrfs_extent_item *ei;
@@ -2520,9 +2525,18 @@ static int process_extent_item(struct cache_tree *extent_cache,
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 refs = 0;
 	u64 offset;
+	u64 num_bytes;
+	int metadata = 0;
 
 	btrfs_item_key_to_cpu(eb, &key, slot);
 
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		metadata = 1;
+		num_bytes = root->leafsize;
+	} else {
+		num_bytes = key.offset;
+	}
+
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		struct btrfs_extent_item_v0 *ei0;
@@ -2533,17 +2547,19 @@ static int process_extent_item(struct cache_tree *extent_cache,
 		BUG();
 #endif
 		return add_extent_rec(extent_cache, NULL, key.objectid,
-				      key.offset, refs, 0, 0, 0, key.offset);
+				      num_bytes, refs, 0, 0, 0, metadata,
+				      num_bytes);
 	}
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	refs = btrfs_extent_refs(eb, ei);
 
-	add_extent_rec(extent_cache, NULL, key.objectid, key.offset,
-		       refs, 0, 0, 0, key.offset);
+	add_extent_rec(extent_cache, NULL, key.objectid, num_bytes,
+		       refs, 0, 0, 0, metadata, num_bytes);
 
 	ptr = (unsigned long)(ei + 1);
-	if (btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+	if (btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK &&
+	    key.type == BTRFS_EXTENT_ITEM_KEY)
 		ptr += sizeof(struct btrfs_tree_block_info);
 
 	end = (unsigned long)ei + item_size;
@@ -2568,18 +2584,18 @@ static int process_extent_item(struct cache_tree *extent_cache,
 								       dref),
 					btrfs_extent_data_ref_offset(eb, dref),
 					btrfs_extent_data_ref_count(eb, dref),
-					0, key.offset);
+					0, num_bytes);
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = (struct btrfs_shared_data_ref *)(iref + 1);
 			add_data_backref(extent_cache, key.objectid, offset,
 					0, 0, 0,
 					btrfs_shared_data_ref_count(eb, sref),
-					0, key.offset);
+					0, num_bytes);
 			break;
 		default:
 			fprintf(stderr, "corrupt extent record: key %Lu %u %Lu\n",
-				key.objectid, key.type, key.offset);
+				key.objectid, key.type, num_bytes);
 			goto out;
 		}
 		ptr += btrfs_extent_inline_ref_size(type);
@@ -2657,7 +2673,9 @@ static int run_next_block(struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(buf);
 
-	ret = btrfs_lookup_extent_info(NULL, root, bytenr, size, NULL, &flags);
+	ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+				       btrfs_header_level(buf), 1, NULL,
+				       &flags);
 	if (ret < 0)
 		flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
@@ -2679,7 +2697,13 @@ static int run_next_block(struct btrfs_root *root,
 			struct btrfs_file_extent_item *fi;
 			btrfs_item_key_to_cpu(buf, &key, i);
 			if (key.type == BTRFS_EXTENT_ITEM_KEY) {
-				process_extent_item(extent_cache, buf, i);
+				process_extent_item(root, extent_cache, buf,
+						    i);
+				continue;
+			}
+			if (key.type == BTRFS_METADATA_ITEM_KEY) {
+				process_extent_item(root, extent_cache, buf,
+						    i);
 				continue;
 			}
 			if (key.type == BTRFS_EXTENT_CSUM_KEY) {
@@ -2753,7 +2777,7 @@ static int run_next_block(struct btrfs_root *root,
 			ret = add_extent_rec(extent_cache, NULL,
 				   btrfs_file_extent_disk_bytenr(buf, fi),
 				   btrfs_file_extent_disk_num_bytes(buf, fi),
-				   0, 0, 1, 1,
+				   0, 0, 1, 1, 0,
 				   btrfs_file_extent_disk_num_bytes(buf, fi));
 			add_data_backref(extent_cache,
 				btrfs_file_extent_disk_bytenr(buf, fi),
@@ -2776,7 +2800,7 @@ static int run_next_block(struct btrfs_root *root,
 			u32 size = btrfs_level_size(root, level - 1);
 			btrfs_node_key_to_cpu(buf, &key, i);
 			ret = add_extent_rec(extent_cache, &key,
-					     ptr, size, 0, 0, 1, 0, size);
+					     ptr, size, 0, 0, 1, 0, 1, size);
 			BUG_ON(ret);
 
 			add_tree_backref(extent_cache, ptr, parent, owner, 1);
@@ -2793,6 +2817,8 @@ static int run_next_block(struct btrfs_root *root,
 	total_btree_bytes += buf->len;
 	if (fs_root_objectid(btrfs_header_owner(buf)))
 		total_fs_tree_bytes += buf->len;
+	if (btrfs_header_owner(buf) == BTRFS_EXTENT_TREE_OBJECTID)
+		total_extent_tree_bytes += buf->len;
 	if (!found_old_backref &&
 	    btrfs_header_owner(buf) == BTRFS_TREE_RELOC_OBJECTID &&
 	    btrfs_header_backref_rev(buf) == BTRFS_MIXED_BACKREF_REV &&
@@ -2815,7 +2841,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 	else
 		add_pending(pending, seen, buf->start, buf->len);
 	add_extent_rec(extent_cache, NULL, buf->start, buf->len,
-		       0, 1, 1, 0, buf->len);
+		       0, 1, 1, 0, 1, buf->len);
 
 	if (root_key->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
@@ -2936,6 +2962,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 			break;
 
 		if (found_key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    found_key.type != BTRFS_METADATA_ITEM_KEY &&
 		    found_key.type != BTRFS_TREE_BLOCK_REF_KEY &&
 		    found_key.type != BTRFS_EXTENT_DATA_REF_KEY &&
 		    found_key.type != BTRFS_EXTENT_REF_V0_KEY &&
@@ -2961,9 +2988,13 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 			break;
 		btrfs_release_path(NULL, path);
 
-		if (found_key.type == BTRFS_EXTENT_ITEM_KEY) {
+		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    found_key.type == BTRFS_METADATA_ITEM_KEY) {
+			u64 bytes = (found_key.type == BTRFS_EXTENT_ITEM_KEY) ?
+				found_key.offset : root->leafsize;
+
 			ret = btrfs_update_block_group(trans, root, bytenr,
-						       found_key.offset, 0, 0);
+						       bytes, 0, 0);
 			if (ret)
 				break;
 		}
@@ -3128,7 +3159,8 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 
 	/* remember our flags for recreating the extent */
 	ret = btrfs_lookup_extent_info(NULL, info->extent_root, rec->start,
-				       rec->max_size, NULL, &flags);
+				       rec->max_size, rec->metadata, NULL,
+				       &flags);
 	if (ret < 0)
 		flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
 
@@ -3677,6 +3709,8 @@ out:
 	       (unsigned long long)total_btree_bytes);
 	printf("total fs tree bytes: %llu\n",
 	       (unsigned long long)total_fs_tree_bytes);
+	printf("total extent tree bytes: %llu\n",
+	       (unsigned long long)total_extent_tree_bytes);
 	printf("btree space waste bytes: %llu\n",
 	       (unsigned long long)btree_space_waste);
 	printf("file data blocks allocated: %llu\n referenced %llu\n",
diff --git a/ctree.c b/ctree.c
index 1778a51..16f4daa 100644
--- a/ctree.c
+++ b/ctree.c
@@ -235,7 +235,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 
 	if (btrfs_block_can_be_shared(root, buf)) {
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
-					       buf->len, &refs, &flags);
+					       btrfs_header_level(buf), 1,
+					       &refs, &flags);
 		BUG_ON(ret);
 		BUG_ON(refs == 0);
 	} else {
@@ -277,7 +278,8 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		}
 		if (new_flags != 0) {
 			ret = btrfs_set_block_flags(trans, root, buf->start,
-						    buf->len, new_flags);
+						    btrfs_header_level(buf),
+						    new_flags);
 			BUG_ON(ret);
 		}
 	} else {
diff --git a/ctree.h b/ctree.h
index 12f8fe3..548f777 100644
--- a/ctree.h
+++ b/ctree.h
@@ -445,9 +445,10 @@ struct btrfs_super_block {
  * code was pretty buggy.  Lets not let them try anymore.
  */
 #define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
+#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 
-#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF   (1ULL << 6)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -458,7 +459,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
-	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -1034,6 +1036,12 @@ struct btrfs_root {
  */
 #define BTRFS_EXTENT_ITEM_KEY	168
 
+/*
+ * The same as the BTRFS_EXTENT_ITEM_KEY, except it's metadata we already know
+ * the length, so we save the level in key->offset instead of the length.
+ */
+#define BTRFS_METADATA_ITEM_KEY	169
+
 #define BTRFS_TREE_BLOCK_REF_KEY	176
 
 #define BTRFS_EXTENT_DATA_REF_KEY	178
@@ -2018,6 +2026,13 @@ static inline u32 btrfs_level_size(struct btrfs_root *root, int level) {
 	return root->nodesize;
 }
 
+static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	disk_super = &fs_info->super_copy;
+	return (btrfs_super_incompat_flags(disk_super) & flag);
+}
+
 /* helper function to cast into the data area of the leaf. */
 #define btrfs_item_ptr(leaf, slot, type) \
 	((type *)(btrfs_leaf_data(leaf) + \
@@ -2055,10 +2070,10 @@ int btrfs_alloc_extent(struct btrfs_trans_handle *trans,
 		       u64 search_end, struct btrfs_key *ins, int data);
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags);
+			     u64 offset, int metadata, u64 *refs, u64 *flags);
 int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
-			  u64 bytenr, u64 num_bytes, u64 flags);
+			  u64 bytenr, int level, u64 flags);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int record_parent);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 85f5670..eede633 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -115,7 +115,8 @@ static int cache_block_group(struct btrfs_root *root,
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 	key.objectid = last;
 	key.offset = 0;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	key.type = 0;
+
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
@@ -142,14 +143,18 @@ static int cache_block_group(struct btrfs_root *root,
 			break;
 		}
 
-		if (btrfs_key_type(&key) == BTRFS_EXTENT_ITEM_KEY) {
+		if (key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    key.type == BTRFS_METADATA_ITEM_KEY) {
 			if (key.objectid > last) {
 				hole_size = key.objectid - last;
 				set_extent_dirty(free_space_cache, last,
 						 last + hole_size - 1,
 						 GFP_NOFS);
 			}
-			last = key.objectid + key.offset;
+			if (key.type == BTRFS_METADATA_ITEM_KEY)
+				last = key.objectid + root->leafsize;
+			else
+				last = key.objectid + key.offset;
 		}
 next:
 		path->slots[0]++;
@@ -1024,6 +1029,9 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	int want;
 	int ret;
 	int err = 0;
+	int skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1034,11 +1042,44 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		extra_size = btrfs_extent_inline_ref_size(want);
 	else
 		extra_size = -1;
+
+	if (owner < BTRFS_FIRST_FREE_OBJECTID && skinny_metadata) {
+		skinny_metadata = 1;
+		key.type = BTRFS_METADATA_ITEM_KEY;
+		key.offset = owner;
+	} else if (skinny_metadata) {
+		skinny_metadata = 0;
+	}
+
+again:
 	ret = btrfs_search_slot(trans, root, &key, path, extra_size, 1);
 	if (ret < 0) {
 		err = ret;
 		goto out;
 	}
+
+	/*
+	 * We may be a newly converted file system which still has the old fat
+	 * extent entries for metadata, so try and see if we have one of those.
+	 */
+	if (ret > 0 && skinny_metadata) {
+		skinny_metadata = 0;
+		if (path->slots[0]) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    key.type == BTRFS_EXTENT_ITEM_KEY &&
+			    key.offset == num_bytes)
+				ret = 0;
+		}
+		if (ret) {
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = num_bytes;
+			goto again;
+		}
+	}
+
 	if (ret) {
 		printf("Failed to find [%llu, %u, %llu]\n", key.objectid, key.type, key.offset);
 		return -ENOENT;
@@ -1079,10 +1120,10 @@ static int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	ptr = (unsigned long)(ei + 1);
 	end = (unsigned long)ei + item_size;
 
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !skinny_metadata) {
 		ptr += sizeof(struct btrfs_tree_block_info);
 		BUG_ON(ptr > end);
-	} else {
+	} else if (!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
 		if (!(flags & BTRFS_EXTENT_FLAG_DATA)) {
 			return -EIO;
 		}
@@ -1439,7 +1480,7 @@ int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
-			     u64 num_bytes, u64 *refs, u64 *flags)
+			     u64 offset, int metadata, u64 *refs, u64 *flags)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -1450,16 +1491,54 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	u64 num_refs;
 	u64 extent_flags;
 
-	WARN_ON(num_bytes < root->sectorsize);
+	if (metadata &&
+	    !btrfs_fs_incompat(root->fs_info,
+			       BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)) {
+		offset = root->leafsize;
+		metadata = 0;
+	}
+
 	path = btrfs_alloc_path();
 	path->reada = 1;
+
 	key.objectid = bytenr;
-	key.offset = num_bytes;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	key.offset = offset;
+	if (metadata)
+		key.type = BTRFS_METADATA_ITEM_KEY;
+	else
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+
+again:
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
 				0, 0);
 	if (ret < 0)
 		goto out;
+
+	/*
+	 * Deal with the fact that we may have mixed SKINNY and normal refs.  If
+	 * we didn't find what we wanted check and see if we have a normal ref
+	 * right next to us, or re-search if we are on the edge of the leaf just
+	 * to make sure.
+	 */
+	if (ret > 0 && metadata) {
+		if (path->slots) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    key.type == BTRFS_METADATA_ITEM_KEY)
+				ret = 0;
+		}
+
+		if (ret) {
+			btrfs_release_path(root, path);
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = root->leafsize;
+			metadata = 0;
+			goto again;
+		}
+	}
+
 	if (ret != 0) {
 		ret = -EIO;
 		goto out;
@@ -1497,7 +1576,7 @@ out:
 
 int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
-			  u64 bytenr, u64 num_bytes, u64 flags)
+			  u64 bytenr, int level, u64 flags)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -1505,17 +1584,47 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 	struct extent_buffer *l;
 	struct btrfs_extent_item *item;
 	u32 item_size;
+	int skinny_metadata =
+		btrfs_fs_incompat(root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
-	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
 	path->reada = 1;
+
 	key.objectid = bytenr;
-	key.offset = num_bytes;
-	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
+	if (skinny_metadata) {
+		key.offset = level;
+		key.type = BTRFS_METADATA_ITEM_KEY;
+	} else {
+		key.offset = root->leafsize;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+	}
+
+again:
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key, path,
 				0, 0);
 	if (ret < 0)
 		goto out;
+
+	if (ret > 0 && skinny_metadata) {
+		skinny_metadata = 0;
+		if (path->slots[0]--) {
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(path->nodes[0], &key,
+					      path->slots[0]);
+			if (key.objectid == bytenr &&
+			    key.offset == root->leafsize &&
+			    key.type == BTRFS_EXTENT_ITEM_KEY)
+				ret = 0;
+		}
+		if (ret) {
+			btrfs_release_path(root, path);
+			key.offset = root->leafsize;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			goto again;
+		}
+	}
+
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
 		printk("failed to find block number %Lu\n",
@@ -1985,6 +2094,9 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
 	int ret;
+	int skinny_metadata =
+		btrfs_fs_incompat(extent_root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
 
@@ -2000,14 +2112,19 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 
 		if (extent_op->type == PENDING_EXTENT_INSERT) {
 			key.objectid = start;
-			key.offset = end + 1 - start;
-			key.type = BTRFS_EXTENT_ITEM_KEY;
+			if (skinny_metadata) {
+				key.offset = extent_op->level;
+				key.type = BTRFS_METADATA_ITEM_KEY;
+			} else {
+				key.offset = extent_op->num_bytes;
+				key.type = BTRFS_EXTENT_ITEM_KEY;
+			}
 			ret = alloc_reserved_tree_block(trans, extent_root,
 						extent_root->root_key.objectid,
 						trans->transid,
 						extent_op->flags,
 						&extent_op->key,
-					       	extent_op->level, &key);
+						extent_op->level, &key);
 		} else {
 			BUG_ON(1);
 		}
@@ -2088,6 +2205,9 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	int num_to_del = 1;
 	u32 item_size;
 	u64 refs;
+	int skinny_metadata =
+		btrfs_fs_incompat(extent_root->fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	if (root->fs_info->free_extent_hook) {
 		root->fs_info->free_extent_hook(trans, root, bytenr, num_bytes,
@@ -2103,6 +2223,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	path->leave_spinning = 1;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
+	if (is_data)
+		skinny_metadata = 0;
 	BUG_ON(!is_data && refs_to_drop != 1);
 
 	ret = lookup_extent_backref(trans, extent_root, path, &iref,
@@ -2121,6 +2243,11 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 				found_extent = 1;
 				break;
 			}
+			if (key.type == BTRFS_METADATA_ITEM_KEY &&
+			    key.offset == owner_objectid) {
+				found_extent = 1;
+				break;
+			}
 			if (path->slots[0] - extent_slot > 5)
 				break;
 			extent_slot--;
@@ -2140,11 +2267,37 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			path->leave_spinning = 1;
 
 			key.objectid = bytenr;
-			key.type = BTRFS_EXTENT_ITEM_KEY;
-			key.offset = num_bytes;
+
+			if (skinny_metadata) {
+				key.type = BTRFS_METADATA_ITEM_KEY;
+				key.offset = owner_objectid;
+			} else {
+				key.type = BTRFS_EXTENT_ITEM_KEY;
+				key.offset = num_bytes;
+			}
 
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
+			if (ret > 0 && skinny_metadata && path->slots[0]) {
+				path->slots[0]--;
+				btrfs_item_key_to_cpu(path->nodes[0],
+						      &key,
+						      path->slots[0]);
+				if (key.objectid == bytenr &&
+				    key.type == BTRFS_EXTENT_ITEM_KEY &&
+				    key.offset == num_bytes)
+					ret = 0;
+			}
+
+			if (ret > 0 && skinny_metadata) {
+				skinny_metadata = 0;
+				btrfs_release_path(extent_root, path);
+				key.type = BTRFS_EXTENT_ITEM_KEY;
+				key.offset = num_bytes;
+				ret = btrfs_search_slot(trans, extent_root,
+							&key, path, -1, 1);
+			}
+
 			if (ret) {
 				printk(KERN_ERR "umm, got %d back from search"
 				       ", was looking for %llu\n", ret,
@@ -2199,7 +2352,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(item_size < sizeof(*ei));
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
-	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
+	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID &&
+	    key.type == BTRFS_EXTENT_ITEM_KEY) {
 		struct btrfs_tree_block_info *bi;
 		BUG_ON(item_size < sizeof(*ei) + sizeof(*bi));
 		bi = (struct btrfs_tree_block_info *)(ei + 1);
@@ -2571,7 +2725,13 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
+	u32 size = sizeof(*extent_item) + sizeof(*iref);
+	int skinny_metadata =
+		btrfs_fs_incompat(fs_info,
+				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
+
+	if (!skinny_metadata)
+		size += sizeof(*block_info);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -2588,19 +2748,23 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_set_extent_generation(leaf, extent_item, generation);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
-	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 
-	btrfs_set_tree_block_key(leaf, block_info, key);
-	btrfs_set_tree_block_level(leaf, block_info, level);
+	if (skinny_metadata) {
+		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
+	} else {
+		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
+		btrfs_set_tree_block_key(leaf, block_info, key);
+		btrfs_set_tree_block_level(leaf, block_info, level);
+		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
+	}
 
-	iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	btrfs_set_extent_inline_ref_type(leaf, iref, BTRFS_TREE_BLOCK_REF_KEY);
 	btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset,
+	ret = update_block_group(trans, root, ins->objectid, root->leafsize,
 				 1, 0);
 	return 0;
 }
@@ -2636,6 +2800,11 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 		set_state_private(&root->fs_info->extent_ins,
 				  ins->objectid, (unsigned long)extent_op);
 	} else {
+		if (btrfs_fs_incompat(root->fs_info,
+				BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)) {
+			ins->offset = level;
+			ins->type = BTRFS_METADATA_ITEM_KEY;
+		}
 		ret = alloc_reserved_tree_block(trans, root, root_objectid,
 						generation, flags,
 						key, level, ins);
@@ -3336,6 +3505,8 @@ static int btrfs_count_extents_in_block_group(struct btrfs_root *root,
 			break;
 		if (key.type == BTRFS_EXTENT_ITEM_KEY)
 			bytes_used += key.offset;
+		if (key.type == BTRFS_METADATA_ITEM_KEY)
+			bytes_used += root->leafsize;
 		path->slots[0]++;
 	}
 	*total = bytes_used;
@@ -3448,6 +3619,11 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 			ret = btrfs_update_block_group(trans, root,
 				  key.objectid, key.offset, 1, 0);
 			BUG_ON(ret);
+		} else if (key.type == BTRFS_METADATA_ITEM_KEY) {
+			bytes_used += root->leafsize;
+			ret = btrfs_update_block_group(trans, root,
+				  key.objectid, root->leafsize, 1, 0);
+			BUG_ON(ret);
 		}
 		path.slots[0]++;
 	}
diff --git a/mkfs.c b/mkfs.c
index 5ece186..52e17e4 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -336,6 +336,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
+	fprintf(stderr, "\t -x --skinny-extents use the new skinny extent disk format");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -395,6 +396,7 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
+	{ "skinny-extents", 0, NULL, 'x'},
 	{ 0, 0, 0, 0}
 };
 
@@ -1367,6 +1369,7 @@ int main(int ac, char **av)
 	int nodiscard = 0;
 	int ssd = 0;
 	int force_overwrite = 0;
+	int skinny_meta_extents = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1379,8 +1382,8 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:r:VMK", long_options,
-				&option_index);
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:r:VMKx",
+				long_options, &option_index);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -1431,6 +1434,9 @@ int main(int ac, char **av)
 			case 'K':
 				nodiscard=1;
 				break;
+			case 'x':
+				skinny_meta_extents = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -1657,6 +1663,9 @@ raid_groups:
 	if (mixed)
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
 
+	if (skinny_meta_extents)
+		flags |= BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA;
+
 	btrfs_set_super_incompat_flags(super, flags);
 
 	if ((data_profile | metadata_profile) &
diff --git a/print-tree.c b/print-tree.c
index c9e891b..49c8384 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -202,7 +202,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	       btrfs_file_extent_compression(eb, fi));
 }
 
-static void print_extent_item(struct extent_buffer *eb, int slot)
+static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
@@ -237,7 +237,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	       (unsigned long long)btrfs_extent_generation(eb, ei),
 	       (unsigned long long)flags);
 
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !metadata) {
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
@@ -245,7 +245,13 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		btrfs_print_key(&key);
 		printf(" level %d\n", btrfs_tree_block_level(eb, info));
 		iref = (struct btrfs_extent_inline_ref *)(info + 1);
-	} else {
+	} else if (metadata) {
+		struct btrfs_key tmp;
+
+		btrfs_item_key_to_cpu(eb, &tmp, slot);
+		printf("\t\ttree block skinny level %d\n", (int)tmp.offset);
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	} else{
 		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
 	}
 
@@ -440,6 +446,9 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_EXTENT_ITEM_KEY:
 		printf("EXTENT_ITEM");
 		break;
+	case BTRFS_METADATA_ITEM_KEY:
+		printf("METADATA_ITEM");
+		break;
 	case BTRFS_TREE_BLOCK_REF_KEY:
 		printf("TREE_BLOCK_REF");
 		break;
@@ -699,7 +708,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			print_root_ref(l, i, "backref");
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
-			print_extent_item(l, i);
+			print_extent_item(l, i, 0);
+			break;
+		case BTRFS_METADATA_ITEM_KEY:
+			print_extent_item(l, i, 1);
 			break;
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			printf("\t\ttree block backref\n");
-- 
1.7.7.6

