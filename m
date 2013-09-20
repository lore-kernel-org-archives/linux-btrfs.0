Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40953 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3ITJ4D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 05:56:03 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so132469eek.30
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 02:56:01 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs-progs: drop unused parameter from btrfs_item_nr
Date: Fri, 20 Sep 2013 10:55:26 +0100
Message-Id: <1379670926-24008-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused eb parameter from btrfs_item_nr, unused since introduced
in 7777e63b425f1444d2472ea05a6b2b9cf865f35b

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 btrfs-calc-size.c |    2 +-
 btrfs-image.c     |    6 +++---
 cmds-restore.c    |    2 +-
 ctree.c           |   30 +++++++++++++++---------------
 ctree.h           |   13 ++++++-------
 dir-item.c        |    2 +-
 print-tree.c      |    2 +-
 root-tree.c       |    2 +-
 utils.c           |   36 ++++++++++++++++++------------------
 9 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index c4adfb0..ba0d42d 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -74,7 +74,7 @@ static int walk_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		if (btrfs_file_extent_type(b, fi) == BTRFS_FILE_EXTENT_INLINE)
 			stat->total_inline +=
 				btrfs_file_extent_inline_item_len(b,
-							btrfs_item_nr(b, i));
+							btrfs_item_nr(i));
 	}
 
 	return 0;
diff --git a/btrfs-image.c b/btrfs-image.c
index 82aa4f3..879ca72 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -494,7 +494,7 @@ static void zero_items(struct metadump_struct *md, u8 *dst,
 	int i, extent_type;
 
 	for (i = 0; i < nritems; i++) {
-		item = btrfs_item_nr(src, i);
+		item = btrfs_item_nr(i);
 		btrfs_item_key_to_cpu(src, &key, i);
 		if (key.type == BTRFS_CSUM_ITEM_KEY) {
 			size = btrfs_item_size_nr(src, i);
@@ -1437,7 +1437,7 @@ static void truncate_item(struct extent_buffer *eb, int slot, u32 new_size)
 
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
-		item = btrfs_item_nr(eb, i);
+		item = btrfs_item_nr(i);
 		ioff = btrfs_item_offset(eb, item);
 		btrfs_set_item_offset(eb, item, ioff + size_diff);
 	}
@@ -1445,7 +1445,7 @@ static void truncate_item(struct extent_buffer *eb, int slot, u32 new_size)
 	memmove_extent_buffer(eb, btrfs_leaf_data(eb) + data_end + size_diff,
 			      btrfs_leaf_data(eb) + data_end,
 			      old_data_start + new_size - data_end);
-	item = btrfs_item_nr(eb, slot);
+	item = btrfs_item_nr(slot);
 	btrfs_set_item_size(eb, item, new_size);
 }
 
diff --git a/cmds-restore.c b/cmds-restore.c
index e48df40..6db6598 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -223,7 +223,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 			    struct btrfs_file_extent_item);
 	ptr = btrfs_file_extent_inline_start(fi);
 	len = btrfs_file_extent_inline_item_len(leaf,
-					btrfs_item_nr(leaf, path->slots[0]));
+					btrfs_item_nr(path->slots[0]));
 	read_extent_buffer(leaf, buf, ptr, len);
 
 	compress = btrfs_file_extent_compression(leaf, fi);
diff --git a/ctree.c b/ctree.c
index 1a4f3f0..c42c84f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1792,7 +1792,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	i = left_nritems - 1;
 	while (i >= nr) {
-		item = btrfs_item_nr(left, i);
+		item = btrfs_item_nr(i);
 
 		if (path->slots[0] == i)
 			push_space += data_size + sizeof(*item);
@@ -1848,7 +1848,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(root);
 	for (i = 0; i < right_nritems; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 		push_space -= btrfs_item_size(right, item);
 		btrfs_set_item_offset(right, item, push_space);
 	}
@@ -1939,7 +1939,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		nr = right_nritems - 1;
 
 	for (i = 0; i < nr; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 
 		if (path->slots[0] == i)
 			push_space += data_size + sizeof(*item);
@@ -1980,7 +1980,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	for (i = old_left_nritems; i < old_left_nritems + push_items; i++) {
 		u32 ioff;
 
-		item = btrfs_item_nr(left, i);
+		item = btrfs_item_nr(i);
 		ioff = btrfs_item_offset(left, item);
 		btrfs_set_item_offset(left, item,
 		      ioff - (BTRFS_LEAF_DATA_SIZE(root) - old_left_item_size));
@@ -2010,7 +2010,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(root);
 	for (i = 0; i < right_nritems; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 		push_space = push_space - btrfs_item_size(right, item);
 		btrfs_set_item_offset(right, item, push_space);
 	}
@@ -2075,7 +2075,7 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 		      btrfs_item_end_nr(l, mid);
 
 	for (i = 0; i < nritems; i++) {
-		struct btrfs_item *item = btrfs_item_nr(right, i);
+		struct btrfs_item *item = btrfs_item_nr(i);
 		u32 ioff = btrfs_item_offset(right, item);
 		btrfs_set_item_offset(right, item, ioff + rt_data_off);
 	}
@@ -2324,7 +2324,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 
 split:
-	item = btrfs_item_nr(leaf, path->slots[0]);
+	item = btrfs_item_nr(path->slots[0]);
 	orig_offset = btrfs_item_offset(leaf, item);
 	item_size = btrfs_item_size(leaf, item);
 
@@ -2348,7 +2348,7 @@ split:
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
 	btrfs_set_item_key(leaf, &disk_key, slot);
 
-	new_item = btrfs_item_nr(leaf, slot);
+	new_item = btrfs_item_nr(slot);
 
 	btrfs_set_item_offset(leaf, new_item, orig_offset);
 	btrfs_set_item_size(leaf, new_item, item_size - split_offset);
@@ -2418,7 +2418,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
-		item = btrfs_item_nr(leaf, i);
+		item = btrfs_item_nr(i);
 		ioff = btrfs_item_offset(leaf, item);
 		btrfs_set_item_offset(leaf, item, ioff + size_diff);
 	}
@@ -2464,7 +2464,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 			fixup_low_keys(trans, root, path, &disk_key, 1);
 	}
 
-	item = btrfs_item_nr(leaf, slot);
+	item = btrfs_item_nr(slot);
 	btrfs_set_item_size(leaf, item, new_size);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -2515,7 +2515,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
-		item = btrfs_item_nr(leaf, i);
+		item = btrfs_item_nr(i);
 		ioff = btrfs_item_offset(leaf, item);
 		btrfs_set_item_offset(leaf, item, ioff - data_size);
 	}
@@ -2527,7 +2527,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 
 	data_end = old_data;
 	old_size = btrfs_item_size_nr(leaf, slot);
-	item = btrfs_item_nr(leaf, slot);
+	item = btrfs_item_nr(slot);
 	btrfs_set_item_size(leaf, item, old_size + data_size);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -2608,7 +2608,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		for (i = slot; i < nritems; i++) {
 			u32 ioff;
 
-			item = btrfs_item_nr(leaf, i);
+			item = btrfs_item_nr(i);
 			ioff = btrfs_item_offset(leaf, item);
 			btrfs_set_item_offset(leaf, item, ioff - total_data);
 		}
@@ -2629,7 +2629,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	for (i = 0; i < nr; i++) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key + i);
 		btrfs_set_item_key(leaf, &disk_key, slot + i);
-		item = btrfs_item_nr(leaf, slot + i);
+		item = btrfs_item_nr(slot + i);
 		btrfs_set_item_offset(leaf, item, data_end - data_size[i]);
 		data_end -= data_size[i];
 		btrfs_set_item_size(leaf, item, data_size[i]);
@@ -2782,7 +2782,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		for (i = slot + nr; i < nritems; i++) {
 			u32 ioff;
 
-			item = btrfs_item_nr(leaf, i);
+			item = btrfs_item_nr(i);
 			ioff = btrfs_item_offset(leaf, item);
 			btrfs_set_item_offset(leaf, item, ioff + dsize);
 		}
diff --git a/ctree.h b/ctree.h
index 0b0d701..7f40b3b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1549,8 +1549,7 @@ static inline unsigned long btrfs_item_nr_offset(int nr)
 		sizeof(struct btrfs_item) * nr;
 }
 
-static inline struct btrfs_item *btrfs_item_nr(struct extent_buffer *eb,
-					       int nr)
+static inline struct btrfs_item *btrfs_item_nr(int nr)
 {
 	return (struct btrfs_item *)btrfs_item_nr_offset(nr);
 }
@@ -1563,30 +1562,30 @@ static inline u32 btrfs_item_end(struct extent_buffer *eb,
 
 static inline u32 btrfs_item_end_nr(struct extent_buffer *eb, int nr)
 {
-	return btrfs_item_end(eb, btrfs_item_nr(eb, nr));
+	return btrfs_item_end(eb, btrfs_item_nr(nr));
 }
 
 static inline u32 btrfs_item_offset_nr(struct extent_buffer *eb, int nr)
 {
-	return btrfs_item_offset(eb, btrfs_item_nr(eb, nr));
+	return btrfs_item_offset(eb, btrfs_item_nr(nr));
 }
 
 static inline u32 btrfs_item_size_nr(struct extent_buffer *eb, int nr)
 {
-	return btrfs_item_size(eb, btrfs_item_nr(eb, nr));
+	return btrfs_item_size(eb, btrfs_item_nr(nr));
 }
 
 static inline void btrfs_item_key(struct extent_buffer *eb,
 			   struct btrfs_disk_key *disk_key, int nr)
 {
-	struct btrfs_item *item = btrfs_item_nr(eb, nr);
+	struct btrfs_item *item = btrfs_item_nr(nr);
 	read_eb_member(eb, item, struct btrfs_item, key, disk_key);
 }
 
 static inline void btrfs_set_item_key(struct extent_buffer *eb,
 			       struct btrfs_disk_key *disk_key, int nr)
 {
-	struct btrfs_item *item = btrfs_item_nr(eb, nr);
+	struct btrfs_item *item = btrfs_item_nr(nr);
 	write_eb_member(eb, item, struct btrfs_item, key, disk_key);
 }
 
diff --git a/dir-item.c b/dir-item.c
index f00485a..37a6227 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -48,7 +48,7 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		return ERR_PTR(ret);
 	WARN_ON(ret > 0);
 	leaf = path->nodes[0];
-	item = btrfs_item_nr(leaf, path->slots[0]);
+	item = btrfs_item_nr(path->slots[0]);
 	ptr = btrfs_item_ptr(leaf, path->slots[0], char);
 	BUG_ON(data_size > btrfs_item_size(leaf, item));
 	ptr += btrfs_item_size(leaf, item) - data_size;
diff --git a/print-tree.c b/print-tree.c
index aae47a9..fa37c78 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -657,7 +657,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	print_uuids(l);
 	fflush(stdout);
 	for (i = 0 ; i < nr ; i++) {
-		item = btrfs_item_nr(l, i);
+		item = btrfs_item_nr(i);
 		btrfs_item_key(l, &disk_key, i);
 		objectid = btrfs_disk_key_objectid(&disk_key);
 		type = btrfs_disk_key_type(&disk_key);
diff --git a/root-tree.c b/root-tree.c
index ba380bd..58961e9 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -173,7 +173,7 @@ int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid,
 			nritems = btrfs_header_nritems(leaf);
 			slot = path->slots[0];
 		}
-		item = btrfs_item_nr(leaf, slot);
+		item = btrfs_item_nr(slot);
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (btrfs_key_type(&key) != BTRFS_ROOT_ITEM_KEY)
 			goto next;
diff --git a/utils.c b/utils.c
index 7b4cd74..64ea769 100644
--- a/utils.c
+++ b/utils.c
@@ -169,8 +169,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_root_bytenr(&root_item, blocks[2]);
 	btrfs_set_disk_key_objectid(&disk_key, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 			    sizeof(root_item));
 	write_extent_buffer(buf, &root_item, btrfs_item_ptr_offset(buf,
 			    nritems), sizeof(root_item));
@@ -180,8 +180,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_root_bytenr(&root_item, blocks[4]);
 	btrfs_set_disk_key_objectid(&disk_key, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 			    sizeof(root_item));
 	write_extent_buffer(buf, &root_item,
 			    btrfs_item_ptr_offset(buf, nritems),
@@ -192,8 +192,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_root_bytenr(&root_item, blocks[5]);
 	btrfs_set_disk_key_objectid(&disk_key, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 			    sizeof(root_item));
 	write_extent_buffer(buf, &root_item,
 			    btrfs_item_ptr_offset(buf, nritems),
@@ -204,8 +204,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_root_bytenr(&root_item, blocks[6]);
 	btrfs_set_disk_key_objectid(&disk_key, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 			    sizeof(root_item));
 	write_extent_buffer(buf, &root_item,
 			    btrfs_item_ptr_offset(buf, nritems),
@@ -233,9 +233,9 @@ int make_btrfs(int fd, const char *device, const char *label,
 		btrfs_set_disk_key_offset(&disk_key, leafsize);
 		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
-		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
+		btrfs_set_item_offset(buf, btrfs_item_nr(nritems),
 				      itemoff);
-		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
+		btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 				    sizeof(struct btrfs_extent_item) +
 				    sizeof(struct btrfs_tree_block_info));
 		extent_item = btrfs_item_ptr(buf, nritems,
@@ -252,9 +252,9 @@ int make_btrfs(int fd, const char *device, const char *label,
 		btrfs_set_disk_key_offset(&disk_key, ref_root);
 		btrfs_set_disk_key_type(&disk_key, BTRFS_TREE_BLOCK_REF_KEY);
 		btrfs_set_item_key(buf, &disk_key, nritems);
-		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
+		btrfs_set_item_offset(buf, btrfs_item_nr(nritems),
 				      itemoff);
-		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems), 0);
+		btrfs_set_item_size(buf, btrfs_item_nr(nritems), 0);
 		nritems++;
 	}
 	btrfs_set_header_bytenr(buf, blocks[2]);
@@ -276,8 +276,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_disk_key_offset(&disk_key, 1);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems), item_size);
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems), item_size);
 
 	dev_item = btrfs_item_ptr(buf, nritems, struct btrfs_dev_item);
 	btrfs_set_device_id(buf, dev_item, 1);
@@ -308,8 +308,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_CHUNK_ITEM_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf,  nritems), item_size);
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems), item_size);
 
 	chunk = btrfs_item_ptr(buf, nritems, struct btrfs_chunk);
 	btrfs_set_chunk_length(buf, chunk, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
@@ -358,8 +358,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_disk_key_offset(&disk_key, 0);
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_EXTENT_KEY);
 	btrfs_set_item_key(buf, &disk_key, nritems);
-	btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
-	btrfs_set_item_size(buf, btrfs_item_nr(buf,  nritems),
+	btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
+	btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 			    sizeof(struct btrfs_dev_extent));
 	dev_extent = btrfs_item_ptr(buf, nritems, struct btrfs_dev_extent);
 	btrfs_set_dev_extent_chunk_tree(buf, dev_extent,
-- 
1.7.7.6

