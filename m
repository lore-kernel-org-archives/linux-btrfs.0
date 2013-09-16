Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53180 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3IPO7t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 10:59:49 -0400
Received: by mail-ee0-f44.google.com with SMTP id b47so2098668eek.31
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Sep 2013 07:59:47 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs: drop unused parameter from btrfs_item_nr
Date: Mon, 16 Sep 2013 15:58:09 +0100
Message-Id: <1379343489-20066-2-git-send-email-ross.kirk@gmail.com>
In-Reply-To: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
References: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused eb parameter from btrfs_item_nr

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 fs/btrfs/backref.c    |    2 +-
 fs/btrfs/ctree.c      |   34 +++++++++++++++++-----------------
 fs/btrfs/ctree.h      |   13 ++++++-------
 fs/btrfs/dir-item.c   |    2 +-
 fs/btrfs/inode-item.c |    2 +-
 fs/btrfs/inode.c      |    4 ++--
 fs/btrfs/print-tree.c |    2 +-
 fs/btrfs/send.c       |    4 ++--
 8 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index eaf1333..25b3c55 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1591,7 +1591,7 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		btrfs_release_path(path);
 
-		item = btrfs_item_nr(eb, slot);
+		item = btrfs_item_nr(slot);
 		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
 
 		for (cur = 0; cur < btrfs_item_size(eb, item); cur += len) {
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5bf4c39..63cde75 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3336,8 +3336,8 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
 	if (!nr)
 		return 0;
 	btrfs_init_map_token(&token);
-	start_item = btrfs_item_nr(l, start);
-	end_item = btrfs_item_nr(l, end);
+	start_item = btrfs_item_nr(start);
+	end_item = btrfs_item_nr(end);
 	data_len = btrfs_token_item_offset(l, start_item, &token) +
 		btrfs_token_item_size(l, start_item, &token);
 	data_len = data_len - btrfs_token_item_offset(l, end_item, &token);
@@ -3405,7 +3405,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	slot = path->slots[1];
 	i = left_nritems - 1;
 	while (i >= nr) {
-		item = btrfs_item_nr(left, i);
+		item = btrfs_item_nr(i);
 
 		if (!empty && push_items > 0) {
 			if (path->slots[0] > i)
@@ -3469,7 +3469,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(root);
 	for (i = 0; i < right_nritems; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 		push_space -= btrfs_token_item_size(right, item, &token);
 		btrfs_set_token_item_offset(right, item, push_space, &token);
 	}
@@ -3611,7 +3611,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		nr = min(right_nritems - 1, max_slot);
 
 	for (i = 0; i < nr; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 
 		if (!empty && push_items > 0) {
 			if (path->slots[0] < i)
@@ -3662,7 +3662,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	for (i = old_left_nritems; i < old_left_nritems + push_items; i++) {
 		u32 ioff;
 
-		item = btrfs_item_nr(left, i);
+		item = btrfs_item_nr(i);
 
 		ioff = btrfs_token_item_offset(left, item, &token);
 		btrfs_set_token_item_offset(left, item,
@@ -3693,7 +3693,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(right, right_nritems);
 	push_space = BTRFS_LEAF_DATA_SIZE(root);
 	for (i = 0; i < right_nritems; i++) {
-		item = btrfs_item_nr(right, i);
+		item = btrfs_item_nr(i);
 
 		push_space = push_space - btrfs_token_item_size(right,
 								item, &token);
@@ -3834,7 +3834,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 		      btrfs_item_end_nr(l, mid);
 
 	for (i = 0; i < nritems; i++) {
-		struct btrfs_item *item = btrfs_item_nr(right, i);
+		struct btrfs_item *item = btrfs_item_nr(i);
 		u32 ioff;
 
 		ioff = btrfs_token_item_offset(right, item, &token);
@@ -4177,7 +4177,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_path_blocking(path);
 
-	item = btrfs_item_nr(leaf, path->slots[0]);
+	item = btrfs_item_nr(path->slots[0]);
 	orig_offset = btrfs_item_offset(leaf, item);
 	item_size = btrfs_item_size(leaf, item);
 
@@ -4200,7 +4200,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
 	btrfs_cpu_key_to_disk(&disk_key, new_key);
 	btrfs_set_item_key(leaf, &disk_key, slot);
 
-	new_item = btrfs_item_nr(leaf, slot);
+	new_item = btrfs_item_nr(slot);
 
 	btrfs_set_item_offset(leaf, new_item, orig_offset);
 	btrfs_set_item_size(leaf, new_item, item_size - split_offset);
@@ -4339,7 +4339,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
-		item = btrfs_item_nr(leaf, i);
+		item = btrfs_item_nr(i);
 
 		ioff = btrfs_token_item_offset(leaf, item, &token);
 		btrfs_set_token_item_offset(leaf, item,
@@ -4387,7 +4387,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			fixup_low_keys(root, path, &disk_key, 1);
 	}
 
-	item = btrfs_item_nr(leaf, slot);
+	item = btrfs_item_nr(slot);
 	btrfs_set_item_size(leaf, item, new_size);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -4441,7 +4441,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	/* first correct the data pointers */
 	for (i = slot; i < nritems; i++) {
 		u32 ioff;
-		item = btrfs_item_nr(leaf, i);
+		item = btrfs_item_nr(i);
 
 		ioff = btrfs_token_item_offset(leaf, item, &token);
 		btrfs_set_token_item_offset(leaf, item,
@@ -4455,7 +4455,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 
 	data_end = old_data;
 	old_size = btrfs_item_size_nr(leaf, slot);
-	item = btrfs_item_nr(leaf, slot);
+	item = btrfs_item_nr(slot);
 	btrfs_set_item_size(leaf, item, old_size + data_size);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -4514,7 +4514,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 		for (i = slot; i < nritems; i++) {
 			u32 ioff;
 
-			item = btrfs_item_nr(leaf, i);
+			item = btrfs_item_nr( i);
 			ioff = btrfs_token_item_offset(leaf, item, &token);
 			btrfs_set_token_item_offset(leaf, item,
 						    ioff - total_data, &token);
@@ -4535,7 +4535,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	for (i = 0; i < nr; i++) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key + i);
 		btrfs_set_item_key(leaf, &disk_key, slot + i);
-		item = btrfs_item_nr(leaf, slot + i);
+		item = btrfs_item_nr(slot + i);
 		btrfs_set_token_item_offset(leaf, item,
 					    data_end - data_size[i], &token);
 		data_end -= data_size[i];
@@ -4730,7 +4730,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		for (i = slot + nr; i < nritems; i++) {
 			u32 ioff;
 
-			item = btrfs_item_nr(leaf, i);
+			item = btrfs_item_nr(i);
 			ioff = btrfs_token_item_offset(leaf, item, &token);
 			btrfs_set_token_item_offset(leaf, item,
 						    ioff + dsize, &token);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..e0bab4d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2411,8 +2411,7 @@ static inline unsigned long btrfs_item_nr_offset(int nr)
 		sizeof(struct btrfs_item) * nr;
 }
 
-static inline struct btrfs_item *btrfs_item_nr(struct extent_buffer *eb,
-					       int nr)
+static inline struct btrfs_item *btrfs_item_nr(int nr)
 {
 	return (struct btrfs_item *)btrfs_item_nr_offset(nr);
 }
@@ -2425,30 +2424,30 @@ static inline u32 btrfs_item_end(struct extent_buffer *eb,
 
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
 
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 79e594e..1c529db 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -58,7 +58,7 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		return ERR_PTR(ret);
 	WARN_ON(ret > 0);
 	leaf = path->nodes[0];
-	item = btrfs_item_nr(leaf, path->slots[0]);
+	item = btrfs_item_nr(path->slots[0]);
 	ptr = btrfs_item_ptr(leaf, path->slots[0], char);
 	BUG_ON(data_size > btrfs_item_size(leaf, item));
 	ptr += btrfs_item_size(leaf, item) - data_size;
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index e0b7034..ec82fae 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -369,7 +369,7 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 		goto out;
 
 	leaf = path->nodes[0];
-	item = btrfs_item_nr(leaf, path->slots[0]);
+	item = btrfs_item_nr(path->slots[0]);
 	ptr = (unsigned long)btrfs_item_ptr(leaf, path->slots[0], char);
 	ptr += btrfs_item_size(leaf, item) - ins_len;
 	extref = (struct btrfs_inode_extref *)ptr;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b7c2487..d872e5e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5095,7 +5095,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			continue;
 		}
 
-		item = btrfs_item_nr(leaf, slot);
+		item = btrfs_item_nr(slot);
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 		if (found_key.objectid != key.objectid)
@@ -5892,7 +5892,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	compress_type = btrfs_file_extent_compression(leaf, item);
 	max_size = btrfs_file_extent_ram_bytes(leaf, item);
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
-					btrfs_item_nr(leaf, path->slots[0]));
+					btrfs_item_nr(path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
 	if (!tmp)
 		return -ENOMEM;
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..fc01f42 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -180,7 +180,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l));
 	for (i = 0 ; i < nr ; i++) {
-		item = btrfs_item_nr(l, i);
+		item = btrfs_item_nr(i);
 		btrfs_item_key_to_cpu(l, &key, i);
 		type = btrfs_key_type(&key);
 		printk(KERN_INFO "\titem %d key (%llu %x %llu) itemoff %d "
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d3f3b43..99d76cb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -790,7 +790,7 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 	if (found_key->type == BTRFS_INODE_REF_KEY) {
 		ptr = (unsigned long)btrfs_item_ptr(eb, slot,
 						    struct btrfs_inode_ref);
-		item = btrfs_item_nr(eb, slot);
+		item = btrfs_item_nr(slot);
 		total = btrfs_item_size(eb, item);
 		elem_size = sizeof(*iref);
 	} else {
@@ -904,7 +904,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 
 	eb = path->nodes[0];
 	slot = path->slots[0];
-	item = btrfs_item_nr(eb, slot);
+	item = btrfs_item_nr(slot);
 	di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 	cur = 0;
 	len = 0;
-- 
1.7.7.6

