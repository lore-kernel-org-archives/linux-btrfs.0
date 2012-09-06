Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:39578 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2IFBMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 21:12:47 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz
Subject: [PATCH v2 2/2] Btrfs: snapshot-aware defrag
Date: Thu,  6 Sep 2012 09:10:52 +0800
Message-Id: <1346893852-9815-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346893852-9815-1-git-send-email-bo.li.liu@oracle.com>
References: <1346893852-9815-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This comes from one of btrfs's project ideas,
As we defragment files, we break any sharing from other snapshots.
The balancing code will preserve the sharing, and defrag needs to grow this
as well.

Now we're able to fill the blank with this patch, in which we make full use of
backref walking stuff.

Here is the basic idea,
o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
o  at endio, after we finish updating fs tree, we use backref walking to find
   all parents of the ranges and re-link them with the new COWed file layout by
   adding corresponding backrefs.

Original-Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: rebase against the latest btrfs-repo

 fs/btrfs/inode.c |  617 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 617 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 55857eb..0470802 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -54,6 +54,7 @@
 #include "locking.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "backref.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -1846,6 +1847,600 @@ out:
 	return ret;
 }
 
+struct extent_backref {
+	struct rb_node node;
+	struct old_extent *old;
+	u64 root_id;
+	u64 inum;
+	u64 file_pos;
+	u64 extent_offset;
+	u64 num_bytes;
+	u64 generation;
+};
+
+struct old_extent {
+	struct list_head list;
+	struct new_extent *new;
+
+	u64 extent_offset;
+	u64 bytenr;
+	u64 offset;
+	u64 len;
+	int count;
+};
+
+struct new_extent {
+	struct rb_root root;
+	struct list_head head;
+	struct btrfs_path *path;
+	struct inode *inode;
+	u64 file_pos;
+	u64 len;
+	u64 bytenr;
+	u64 disk_len;
+	u64 compress_type;
+};
+
+struct relink_work {
+	struct work_struct work;
+	struct new_extent *new;
+};
+
+static int backref_comp(struct extent_backref *b1, struct extent_backref *b2)
+{
+	if (b1->root_id < b2->root_id)
+		return -1;
+	else if (b1->root_id > b2->root_id)
+		return 1;
+
+	if (b1->inum < b2->inum)
+		return -1;
+	else if (b1->inum > b2->inum)
+		return 1;
+
+	if (b1->file_pos < b2->file_pos)
+		return -1;
+	else if (b1->file_pos > b2->file_pos)
+		return 1;
+
+	WARN_ON(1);
+	return 0;
+}
+
+static void backref_insert(struct rb_root *root, struct extent_backref *backref)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct extent_backref *entry;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct extent_backref, node);
+
+		ret = backref_comp(backref, entry);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&backref->node, parent, p);
+	rb_insert_color(&backref->node, root);
+}
+
+/*
+ * Note the backref might has changed, and in this case we just return 0.
+ */
+static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
+				       void *ctx)
+{
+	struct btrfs_file_extent_item *extent;
+	struct btrfs_fs_info *fs_info;
+	struct old_extent *old = ctx;
+	struct new_extent *new = old->new;
+	struct btrfs_path *path = new->path;
+	struct btrfs_key key;
+	struct btrfs_root *root;
+	struct extent_backref *backref;
+	struct extent_buffer *leaf;
+	struct inode *inode = new->inode;
+	int slot;
+	int ret;
+	u64 extent_offset;
+	u64 num_bytes;
+
+	if (BTRFS_I(inode)->root->root_key.objectid == root_id &&
+	    inum == btrfs_ino(inode))
+		return 0;
+
+	key.objectid = root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	fs_info = BTRFS_I(inode)->root->fs_info;
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root)) {
+		if (PTR_ERR(root) == -ENOENT)
+			return 0;
+		WARN_ON(1);
+		return PTR_ERR(root);
+	}
+
+	key.objectid = inum;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	if (offset > (u64)-1 << 32)
+		key.offset = 0;
+	else
+		key.offset = offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		WARN_ON(1);
+		return ret;
+	}
+
+	while (1) {
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (key.objectid != inum || key.type != BTRFS_EXTENT_DATA_KEY)
+			goto next;
+
+		extent = btrfs_item_ptr(leaf, slot,
+					struct btrfs_file_extent_item);
+
+		if (btrfs_file_extent_disk_bytenr(leaf, extent) != old->bytenr)
+			goto next;
+
+		if (key.offset - btrfs_file_extent_offset(leaf, extent) !=
+		    offset)
+			goto next;
+
+		break;
+next:
+		path->slots[0]++;
+	}
+
+	extent_offset = btrfs_file_extent_offset(leaf, extent);
+	num_bytes = btrfs_file_extent_num_bytes(leaf, extent);
+
+	if (extent_offset >= old->extent_offset + old->offset + old->len ||
+	    extent_offset + num_bytes < old->extent_offset + old->offset)
+		goto out;
+
+	backref = kmalloc(sizeof(*backref), GFP_NOFS);
+	if (!backref) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	backref->root_id = root_id;
+	backref->inum = inum;
+	backref->file_pos = offset + extent_offset;
+	backref->num_bytes = num_bytes;
+	backref->extent_offset = extent_offset;
+	backref->generation = btrfs_file_extent_generation(leaf, extent);
+	backref->old = old;
+	backref_insert(&new->root, backref);
+	old->count++;
+out:
+	btrfs_release_path(path);
+	WARN_ON(ret);
+	return ret;
+}
+
+static noinline bool record_extent_backrefs(struct btrfs_path *path,
+				   struct new_extent *new)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(new->inode)->root->fs_info;
+	struct old_extent *old, *tmp;
+	int ret;
+	bool del = false;
+
+	new->path = path;
+
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		if (del)
+			goto del;
+
+		ret = iterate_inodes_from_logical(old->bytenr, fs_info,
+						  path, record_one_backref,
+						  old);
+		WARN_ON(ret < 0);
+del:
+		/* no backref to be processed for this extent */
+		if (!old->count) {
+			list_del(&old->list);
+			kfree(old);
+		}
+	}
+
+	if (list_empty(&new->head))
+		return false;
+
+	return true;
+}
+
+/*
+ * Note the backref might has changed, and in this case we just return 0.
+ */
+static noinline int relink_extent_backref(struct btrfs_path *path,
+				 struct extent_backref *prev,
+				 struct extent_backref *backref)
+{
+	struct btrfs_file_extent_item *extent;
+	struct btrfs_file_extent_item *item;
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct old_extent *old = backref->old;
+	struct new_extent *new = old->new;
+	struct inode *src_inode = new->inode;
+	struct inode *inode;
+	struct extent_state *cached = NULL;
+	int ret = 0;
+	u64 hint_byte;
+	u64 start;
+	u64 len;
+	bool merge = false;
+
+	if (prev && prev->root_id == backref->root_id &&
+	    prev->inum == backref->inum &&
+	    prev->extent_offset == backref->extent_offset &&
+	    prev->file_pos + prev->num_bytes == backref->file_pos)
+		merge = true;
+
+	key.objectid = backref->root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	fs_info = BTRFS_I(src_inode)->root->fs_info;
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root)) {
+		if (PTR_ERR(root) == -ENOENT)
+			return 0;
+		return PTR_ERR(root);
+	}
+
+	key.objectid = backref->inum;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+	if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
+		if (inode && !IS_ERR(inode))
+			iput(inode);
+		return 0;
+	}
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, backref->file_pos,
+			 backref->file_pos + backref->num_bytes, 0, &cached);
+
+	ordered = btrfs_lookup_first_ordered_extent(inode,
+						    backref->file_pos +
+						    backref->num_bytes);
+	if (ordered) {
+		btrfs_put_ordered_extent(ordered);
+		goto out_unlock;
+	}
+
+	trans = btrfs_start_transaction(root, 3);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
+
+	key.objectid = backref->inum;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = backref->file_pos;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out_free_path;
+	} else if (ret > 0) {
+		ret = 0;
+		goto out_free_path;
+	}
+
+	extent = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_generation(path->nodes[0], extent) !=
+	    backref->generation)
+		goto out_free_path;
+
+	btrfs_release_path(path);
+
+	start = backref->file_pos;
+	if (backref->extent_offset < old->extent_offset + old->offset)
+		start += old->extent_offset + old->offset -
+			 backref->extent_offset;
+
+	len = min(backref->extent_offset + backref->num_bytes,
+		  old->extent_offset + old->offset + old->len);
+	len -= max(backref->extent_offset, old->extent_offset + old->offset);
+
+	ret = btrfs_drop_extents(trans, inode, start,
+				 start + len, &hint_byte, 1);
+	if (ret)
+		goto out_free_path;
+again:
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = start;
+
+	if (merge) {
+		struct btrfs_file_extent_item *fi;
+		u64 extent_len;
+		struct btrfs_key found_key;
+
+		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+		if (ret < 0)
+			goto out_free_path;
+
+		path->slots[0]--;
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
+
+		if (btrfs_file_extent_disk_bytenr(leaf, fi) == new->bytenr &&
+		    btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_REG &&
+		    !btrfs_file_extent_compression(leaf, fi) &&
+		    !btrfs_file_extent_encryption(leaf, fi) &&
+		    !btrfs_file_extent_other_encoding(leaf, fi) &&
+		    extent_len + found_key.offset == start) {
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_len + len);
+			btrfs_mark_buffer_dirty(leaf);
+			inode_add_bytes(inode, len);
+
+			ret = 1;
+			goto out_free_path;
+		} else {
+			merge = false;
+			btrfs_release_path(path);
+			goto again;
+		}
+	}
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+					sizeof(*extent));
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	item = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_file_extent_item);
+	btrfs_set_file_extent_disk_bytenr(leaf, item, new->bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, item, new->disk_len);
+	btrfs_set_file_extent_offset(leaf, item, start - new->file_pos);
+	btrfs_set_file_extent_num_bytes(leaf, item, len);
+	btrfs_set_file_extent_ram_bytes(leaf, item, new->len);
+	btrfs_set_file_extent_generation(leaf, item, trans->transid);
+	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_compression(leaf, item, new->compress_type);
+	btrfs_set_file_extent_encryption(leaf, item, 0);
+	btrfs_set_file_extent_other_encoding(leaf, item, 0);
+
+	btrfs_mark_buffer_dirty(leaf);
+	inode_add_bytes(inode, len);
+
+	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
+			new->disk_len, 0,
+			backref->root_id, backref->inum,
+			start, 0);
+	BUG_ON(ret);
+
+	ret = 1;
+out_free_path:
+	btrfs_release_path(path);
+	btrfs_end_transaction(trans, root);
+out_unlock:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, backref->file_pos,
+			     backref->file_pos + backref->num_bytes,
+			     &cached, GFP_NOFS);
+	iput(inode);
+	return ret;
+}
+
+static void relink_file_extents(struct work_struct *work)
+{
+	struct relink_work *rwork;
+	struct btrfs_path *path;
+	struct new_extent *new;
+	struct old_extent *old, *tmp;
+	struct extent_backref *backref;
+	struct extent_backref *prev = NULL;
+	struct inode *inode;
+	struct btrfs_root *root;
+	struct rb_node *node;
+	struct extent_state *cached = NULL;
+	int ret;
+
+	rwork = container_of(work, struct relink_work, work);
+	new = rwork->new;
+	inode = new->inode;
+	root = BTRFS_I(inode)->root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	if (!record_extent_backrefs(path, new)) {
+		btrfs_free_path(path);
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, new->file_pos,
+			 new->file_pos + new->len, 0, &cached);
+
+	while (1) {
+		node = rb_first(&new->root);
+		if (!node)
+			break;
+		rb_erase(node, &new->root);
+
+		backref = rb_entry(node, struct extent_backref, node);
+
+		ret = relink_extent_backref(path, prev, backref);
+		WARN_ON(ret < 0);
+
+		kfree(prev);
+
+		if (ret == 1)
+			prev = backref;
+		else
+			prev = NULL;
+	};
+
+	kfree(prev);
+
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, new->file_pos,
+			     new->file_pos + new->len, &cached, GFP_NOFS);
+
+	btrfs_free_path(path);
+
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		list_del(&old->list);
+		kfree(old);
+	}
+out:
+	atomic_dec(&root->fs_info->defrag_running);
+	wake_up(&root->fs_info->transaction_wait);
+
+	kfree(new);
+	kfree(rwork);
+}
+
+static struct new_extent *
+record_old_file_extents(struct inode *inode,
+			struct btrfs_ordered_extent *ordered)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct old_extent *old, *tmp;
+	struct new_extent *new;
+	int ret;
+
+	new = kmalloc(sizeof(*new), GFP_NOFS);
+	if (!new)
+		return NULL;
+
+	new->inode = inode;
+	new->file_pos = ordered->file_offset;
+	new->len = ordered->len;
+	new->bytenr = ordered->start;
+	new->disk_len = ordered->disk_len;
+	new->compress_type = ordered->compress_type;
+	new->root = RB_ROOT;
+	INIT_LIST_HEAD(&new->head);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		goto out_kfree;
+
+	key.objectid = btrfs_ino(inode);
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = new->file_pos;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out_free_path;
+	if (ret > 0 && path->slots[0] > 0)
+		path->slots[0]--;
+
+	/* find out all the old extents for the file range */
+	while (1) {
+		struct btrfs_file_extent_item *extent;
+		struct extent_buffer *l;
+		int slot;
+		u64 num_bytes;
+		u64 offset;
+		u64 end;
+
+		l = path->nodes[0];
+		slot = path->slots[0];
+
+		if (slot >= btrfs_header_nritems(l)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out_free_list;
+			else if (ret > 0)
+				break;
+			continue;
+		}
+
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (key.objectid != btrfs_ino(inode))
+			break;
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+		if (key.offset >= new->file_pos + new->len)
+			break;
+
+		extent = btrfs_item_ptr(l, slot, struct btrfs_file_extent_item);
+
+		num_bytes = btrfs_file_extent_num_bytes(l, extent);
+		if (key.offset + num_bytes < new->file_pos)
+			goto next;
+
+		old = kmalloc(sizeof(*old), GFP_NOFS);
+		if (!old)
+			goto out_free_list;
+
+		offset = max(new->file_pos, key.offset);
+		end = min(new->file_pos + new->len, key.offset + num_bytes);
+
+		old->bytenr = btrfs_file_extent_disk_bytenr(l, extent);
+		old->extent_offset = btrfs_file_extent_offset(l, extent);
+		old->offset = offset - key.offset;
+		old->len = end - offset;
+		old->new = new;
+		old->count = 0;
+		list_add_tail(&old->list, &new->head);
+next:
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+	atomic_inc(&root->fs_info->defrag_running);
+
+	return new;
+
+out_free_list:
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		list_del(&old->list);
+		kfree(old);
+	}
+out_free_path:
+	btrfs_free_path(path);
+out_kfree:
+	kfree(new);
+	return NULL;
+}
+
 /*
  * helper function for btrfs_finish_ordered_io, this
  * just reads in some of the csum leaves to prime them into ram
@@ -1863,6 +2458,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	struct btrfs_trans_handle *trans = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
+	struct relink_work *work = NULL;
 	int compress_type = 0;
 	int ret;
 	bool nolock;
@@ -1899,6 +2495,23 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state);
 
+	ret = test_range_bit(io_tree, ordered_extent->file_offset,
+			ordered_extent->file_offset + ordered_extent->len - 1,
+			EXTENT_DEFRAG, 1, cached_state);
+	if (ret && (btrfs_root_last_snapshot(&root->root_item) >=
+						BTRFS_I(inode)->generation)) {
+		/* the inode is shared */
+		work = kmalloc(sizeof(*work), GFP_NOFS);
+		if (work) {
+			work->new = record_old_file_extents(inode,
+							    ordered_extent);
+			if (!work->new) {
+				kfree(work);
+				work = NULL;
+			}
+		}
+	}
+
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
 	else
@@ -1975,6 +2588,10 @@ out:
 	 */
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
+	/* for snapshot-aware defrag */
+	if (work)
+		relink_file_extents(&work->work);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
-- 
1.7.7.6

