Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31451 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2JRGci (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 02:32:38 -0400
Message-ID: <507FA266.5020508@oracle.com>
Date: Thu, 18 Oct 2012 14:32:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] __tree_mod_log_rewind  makes extent buffers larger than
 leafsize
References: <507ECE60.7090309@oracle.com> <507F970E.4070403@jan-o-sch.net>
In-Reply-To: <507F970E.4070403@jan-o-sch.net>
Content-Type: multipart/mixed;
 boundary="------------070801090900090503010003"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070801090900090503010003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/18/2012 01:43 PM, Jan Schmidt wrote:
> Hi liubo,
> 
> On Wed, October 17, 2012 at 17:27 (+0200), Liu Bo wrote:
>> Hi Jan,
>>
>> Here is the steps,
>>
>> 1. apply the three patches onto the latest btrfs
> 
> Can you give me a commit id? They don't apply to cmason/master as of today.
> Patch 1 looks reversed, by the way.
> 

Oh, I'm so sorry, there is a conflict of btrfs_drop_extents.

I've attached the new version test patches, which should work onto the latest for-linus branch.

> I'd comment on patch 2, but it's hard to comment on something in a tar archive.
> You probably wanted to add "add++" where you added "add = 0" for the second time.
> 

Yeah, I noticed this, thanks for pointing it out ;)

>> 2. run the script 'debug.sh'[1]
>>    (NOTE: edit the script and the fio job file[2] to get device and mount point right before running it)
>>
>> 3. it will crash after a few seconds. [3]
[...]
>>
>> [3]
>> [   71.980881] device fsid bc47c36a-7e90-453d-aa6b-8c4a12e30dc0 devid 1 transid 4 /dev/sda5
>> [   71.984162] btrfs: enabling auto defrag
>> [   71.984168] btrfs: disk space caching is enabled
>> [   72.051464] root last_snapshot 5
>> [   95.789404] root last_snapshot 6
>> [  100.229357] root last_snapshot 7
>> [  103.252999] record_old_file_extents: ino 257 new file_pos 38273024 len 1048576 bytenr 2387300352 disk_len 1048576
>> [  103.255989] record_extent_backrefs file_pos 38273024 len 1048576
>> [  103.348648] eb->start 66080768 eb->len 4096 eb->level 1 nritems 66 n 176 rm 110 add 0
> 
> Even the first line tells us there's something wrong. n shouldn't exceed 124
> with 4k leaves. If you lower the debug output restriction (n > 130) we might
> already see through here.
> 

ok, besides, I add two more index: rm_free and rm_move.

> A guess is that we've probably queued some MOD_LOG_MOVE_KEYS operations that
> should have modified n.
> 

IMHO MOD_LOG_KEY_REMOVE_WHILE_MOVING does not need to modify n, since nritems remain
unchanged when we move items inside an node, don't they?

thanks,
liubo

> Thanks,
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------070801090900090503010003
Content-Type: text/x-patch;
 name="0001-Btrfs-snapshot-aware-defrag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Btrfs-snapshot-aware-defrag.patch"

>From a4247f484a6c52916d82492c31e7651210db365f Mon Sep 17 00:00:00 2001
From: Liu Bo <bo.li.liu@oracle.com>
Date: Thu, 9 Aug 2012 12:04:33 +0800
Subject: [PATCH 1/3] Btrfs: snapshot-aware defrag

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

Originally patch by Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |  617 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 617 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85a1e50..cef281a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -54,6 +54,7 @@
 #include "locking.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "backref.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -1839,6 +1840,608 @@ out:
 	return ret;
 }
 
+/* snapshot-aware defrag */
+struct sa_defrag_extent_backref {
+	struct rb_node node;
+	struct old_sa_defrag_extent *old;
+	u64 root_id;
+	u64 inum;
+	u64 file_pos;
+	u64 extent_offset;
+	u64 num_bytes;
+	u64 generation;
+};
+
+struct old_sa_defrag_extent {
+	struct list_head list;
+	struct new_sa_defrag_extent *new;
+
+	u64 extent_offset;
+	u64 bytenr;
+	u64 offset;
+	u64 len;
+	int count;
+};
+
+struct new_sa_defrag_extent {
+	struct rb_root root;
+	struct list_head head;
+	struct btrfs_path *path;
+	struct inode *inode;
+	u64 file_pos;
+	u64 len;
+	u64 bytenr;
+	u64 disk_len;
+	u8 compress_type;
+};
+
+static int backref_comp(struct sa_defrag_extent_backref *b1,
+			struct sa_defrag_extent_backref *b2)
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
+static void backref_insert(struct rb_root *root,
+			   struct sa_defrag_extent_backref *backref)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct sa_defrag_extent_backref *entry;
+	int ret;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct sa_defrag_extent_backref, node);
+
+		ret = backref_comp(backref, entry);
+		if (ret < 0)
+			p = &(*p)->rb_left;
+		else if (ret > 0)
+			p = &(*p)->rb_right;
+		else
+			BUG_ON(1);
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
+	struct old_sa_defrag_extent *old = ctx;
+	struct new_sa_defrag_extent *new = old->new;
+	struct btrfs_path *path = new->path;
+	struct btrfs_key key;
+	struct btrfs_root *root;
+	struct sa_defrag_extent_backref *backref;
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
+		pr_debug("inum=%llu, offset=%llu, root_id=%llu\n",
+			 inum, offset, root_id);
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
+		cond_resched();
+
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
+		path->slots[0]++;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		if (key.objectid != inum || key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+
+		extent = btrfs_item_ptr(leaf, slot,
+					struct btrfs_file_extent_item);
+
+		if (btrfs_file_extent_disk_bytenr(leaf, extent) != old->bytenr)
+			continue;
+
+		if (key.offset - btrfs_file_extent_offset(leaf, extent) !=
+		    offset)
+			continue;
+
+		break;
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
+				   struct new_sa_defrag_extent *new)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(new->inode)->root->fs_info;
+	struct old_sa_defrag_extent *old, *tmp;
+	int ret;
+
+	new->path = path;
+
+	list_for_each_entry_safe(old, tmp, &new->head, list) {
+		ret = iterate_inodes_from_logical(old->bytenr, fs_info,
+						  path, record_one_backref,
+						  old);
+		WARN_ON(ret < 0);
+
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
+				 struct sa_defrag_extent_backref *prev,
+				 struct sa_defrag_extent_backref *backref)
+{
+	struct btrfs_file_extent_item *extent;
+	struct btrfs_file_extent_item *item;
+	struct btrfs_ordered_extent *ordered;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct old_sa_defrag_extent *old = backref->old;
+	struct new_sa_defrag_extent *new = old->new;
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
+	/*
+	 * 1 for drop_extents
+	 * 1 for merge clause's search_slot
+	 * 1 for insert items
+	 */
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
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out_free_path;
+	}
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
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out_free_path;
+	}
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
+static void relink_file_extents(struct new_sa_defrag_extent *new)
+{
+	struct btrfs_path *path;
+	struct old_sa_defrag_extent *old, *tmp;
+	struct sa_defrag_extent_backref *backref;
+	struct sa_defrag_extent_backref *prev = NULL;
+	struct inode *inode;
+	struct btrfs_root *root;
+	struct rb_node *node;
+	struct extent_state *cached = NULL;
+	int ret;
+
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
+		backref = rb_entry(node, struct sa_defrag_extent_backref, node);
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
+		cond_resched();
+	}
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
+}
+
+static struct new_sa_defrag_extent *
+record_old_file_extents(struct inode *inode,
+			struct btrfs_ordered_extent *ordered)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct old_sa_defrag_extent *old, *tmp;
+	struct new_sa_defrag_extent *new;
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
+		cond_resched();
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
@@ -1856,6 +2459,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	struct btrfs_trans_handle *trans = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
+	struct new_sa_defrag_extent *new = NULL;
 	int compress_type = 0;
 	int ret;
 	bool nolock;
@@ -1892,6 +2496,15 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state);
 
+	ret = test_range_bit(io_tree, ordered_extent->file_offset,
+			ordered_extent->file_offset + ordered_extent->len - 1,
+			EXTENT_DEFRAG, 1, cached_state);
+	if (ret && btrfs_root_last_snapshot(&root->root_item) >=
+						BTRFS_I(inode)->generation) {
+		/* the inode is shared */
+		new = record_old_file_extents(inode, ordered_extent);
+	}
+
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
 	else
@@ -1965,6 +2578,10 @@ out:
 	 */
 	btrfs_remove_ordered_extent(inode, ordered_extent);
 
+	/* for snapshot-aware defrag */
+	if (new)
+		relink_file_extents(new);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
-- 
1.7.7.6


--------------070801090900090503010003
Content-Type: text/x-patch;
 name="0002-Btrfs-debug-part-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-Btrfs-debug-part-1.patch"

>From accf27e37d7787b2f66512c85e5136a4935315b6 Mon Sep 17 00:00:00 2001
From: Liu Bo <bo.li.liu@oracle.com>
Date: Thu, 18 Oct 2012 14:14:57 +0800
Subject: [PATCH 2/3] Btrfs: debug part 1

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |   87 ++++++++++++++++++++++++-----------------------------
 1 files changed, 39 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cef281a..434ce43 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1893,7 +1893,6 @@ static int backref_comp(struct sa_defrag_extent_backref *b1,
 	else if (b1->file_pos > b2->file_pos)
 		return 1;
 
-	WARN_ON(1);
 	return 0;
 }
 
@@ -1912,10 +1911,8 @@ static void backref_insert(struct rb_root *root,
 		ret = backref_comp(backref, entry);
 		if (ret < 0)
 			p = &(*p)->rb_left;
-		else if (ret > 0)
-			p = &(*p)->rb_right;
 		else
-			BUG_ON(1);
+			p = &(*p)->rb_right;
 	}
 
 	rb_link_node(&backref->node, parent, p);
@@ -1996,7 +1993,10 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 
-		if (key.objectid != inum || key.type != BTRFS_EXTENT_DATA_KEY)
+		if (key.objectid > inum)
+			goto out;
+
+		if (key.objectid < inum || key.type != BTRFS_EXTENT_DATA_KEY)
 			continue;
 
 		extent = btrfs_item_ptr(leaf, slot,
@@ -2005,20 +2005,18 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		if (btrfs_file_extent_disk_bytenr(leaf, extent) != old->bytenr)
 			continue;
 
-		if (key.offset - btrfs_file_extent_offset(leaf, extent) !=
-		    offset)
+		extent_offset = btrfs_file_extent_offset(leaf, extent);
+		if (key.offset - extent_offset != offset)
+			continue;
+
+		num_bytes = btrfs_file_extent_num_bytes(leaf, extent);
+		if (extent_offset >= old->extent_offset + old->offset + old->len ||
+		    extent_offset + num_bytes <= old->extent_offset + old->offset)
 			continue;
 
 		break;
 	}
 
-	extent_offset = btrfs_file_extent_offset(leaf, extent);
-	num_bytes = btrfs_file_extent_num_bytes(leaf, extent);
-
-	if (extent_offset >= old->extent_offset + old->offset + old->len ||
-	    extent_offset + num_bytes < old->extent_offset + old->offset)
-		goto out;
-
 	backref = kmalloc(sizeof(*backref), GFP_NOFS);
 	if (!backref) {
 		ret = -ENOENT;
@@ -2053,7 +2051,7 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 		ret = iterate_inodes_from_logical(old->bytenr, fs_info,
 						  path, record_one_backref,
 						  old);
-		WARN_ON(ret < 0);
+		BUG_ON(ret < 0 && ret != -ENOENT);
 
 		/* no backref to be processed for this extent */
 		if (!old->count) {
@@ -2092,11 +2090,12 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	u64 hint_byte;
 	u64 start;
 	u64 len;
+	u64 lock_start;
+	u64 lock_end;
 	bool merge = false;
 
 	if (prev && prev->root_id == backref->root_id &&
 	    prev->inum == backref->inum &&
-	    prev->extent_offset == backref->extent_offset &&
 	    prev->file_pos + prev->num_bytes == backref->file_pos)
 		merge = true;
 
@@ -2123,26 +2122,15 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 		return 0;
 	}
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, backref->file_pos,
-			 backref->file_pos + backref->num_bytes, 0, &cached);
-
-	ordered = btrfs_lookup_first_ordered_extent(inode,
-						    backref->file_pos +
-						    backref->num_bytes);
-	if (ordered) {
-		btrfs_put_ordered_extent(ordered);
-		goto out_unlock;
-	}
-
 	/*
 	 * 1 for drop_extents
 	 * 1 for merge clause's search_slot
 	 * 1 for insert items
 	 */
-	trans = btrfs_start_transaction(root, 3);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out_unlock;
+		goto out_free_path;
 	}
 
 	key.objectid = backref->inum;
@@ -2175,10 +2163,21 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 		  old->extent_offset + old->offset + old->len);
 	len -= max(backref->extent_offset, old->extent_offset + old->offset);
 
+	lock_start = backref->file_pos;
+	lock_end = backref->file_pos + backref->num_bytes - 1;
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, lock_end, 0, &cached);
+
+	ordered = btrfs_lookup_first_ordered_extent(inode, lock_end);
+	if (ordered) {
+		btrfs_put_ordered_extent(ordered);
+		goto out_unlock;
+	}
+
+
 	ret = btrfs_drop_extents(trans, inode, start,
 				 start + len, &hint_byte, 1);
 	if (ret)
-		goto out_free_path;
+		goto out_unlock;
 again:
 	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -2191,7 +2190,7 @@ again:
 
 		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
 		if (ret < 0)
-			goto out_free_path;
+			goto out_unlock;
 
 		path->slots[0]--;
 		leaf = path->nodes[0];
@@ -2213,7 +2212,7 @@ again:
 			inode_add_bytes(inode, len);
 
 			ret = 1;
-			goto out_free_path;
+			goto out_unlock;
 		} else {
 			merge = false;
 			btrfs_release_path(path);
@@ -2225,7 +2224,7 @@ again:
 					sizeof(*extent));
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
-		goto out_free_path;
+		goto out_unlock;
 	}
 
 	leaf = path->nodes[0];
@@ -2248,20 +2247,19 @@ again:
 	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
 			new->disk_len, 0,
 			backref->root_id, backref->inum,
-			start, 0);
+			new->file_pos, 0);	/* start - extent_offset */
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
-		goto out_free_path;
+		goto out_unlock;
 	}
 
 	ret = 1;
+out_unlock:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end, &cached, GFP_NOFS);
 out_free_path:
 	btrfs_release_path(path);
-	btrfs_end_transaction(trans, root);
-out_unlock:
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, backref->file_pos,
-			     backref->file_pos + backref->num_bytes,
-			     &cached, GFP_NOFS);
+	if (trans)
+		btrfs_end_transaction(trans, root);
 	iput(inode);
 	return ret;
 }
@@ -2275,7 +2273,6 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
 	struct inode *inode;
 	struct btrfs_root *root;
 	struct rb_node *node;
-	struct extent_state *cached = NULL;
 	int ret;
 
 	inode = new->inode;
@@ -2291,9 +2288,6 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
 	}
 	btrfs_release_path(path);
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, new->file_pos,
-			 new->file_pos + new->len, 0, &cached);
-
 	while (1) {
 		node = rb_first(&new->root);
 		if (!node)
@@ -2313,12 +2307,8 @@ static void relink_file_extents(struct new_sa_defrag_extent *new)
 			prev = NULL;
 		cond_resched();
 	}
-
 	kfree(prev);
 
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, new->file_pos,
-			     new->file_pos + new->len, &cached, GFP_NOFS);
-
 	btrfs_free_path(path);
 
 	list_for_each_entry_safe(old, tmp, &new->head, list) {
@@ -2414,6 +2404,7 @@ record_old_file_extents(struct inode *inode,
 		end = min(new->file_pos + new->len, key.offset + num_bytes);
 
 		old->bytenr = btrfs_file_extent_disk_bytenr(l, extent);
+		BUG_ON(!old->bytenr);
 		old->extent_offset = btrfs_file_extent_offset(l, extent);
 		old->offset = offset - key.offset;
 		old->len = end - offset;
-- 
1.7.7.6


--------------070801090900090503010003
Content-Type: text/x-patch;
 name="0003-Btrfs-debug-part-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-Btrfs-debug-part-2.patch"

>From 659ba0c292ab4302d1d067fb086ad0283fba4e37 Mon Sep 17 00:00:00 2001
From: Liu Bo <liub.liubo@gmail.com>
Date: Wed, 17 Oct 2012 22:59:22 +0800
Subject: [PATCH 3/3] Btrfs: debug part 2

Signed-off-by: Liu Bo <liub.liubo@gmail.com>
---
 fs/btrfs/ctree.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b334362..c18df16 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -379,6 +379,8 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	if (!elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
+
+		BUG_ON((fs_info->tree_mod_seq_list.prev)->next != (&fs_info->tree_mod_seq_list));
 	}
 	seq = btrfs_inc_tree_mod_seq(fs_info);
 	spin_unlock(&fs_info->tree_mod_seq_lock);
@@ -403,9 +405,11 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 
 	spin_lock(&fs_info->tree_mod_seq_lock);
 	list_del(&elem->list);
+
 	elem->seq = 0;
 
 	list_for_each_entry(cur_elem, &fs_info->tree_mod_seq_list, list) {
+		BUG_ON(!cur_elem);
 		if (cur_elem->seq < min_seq) {
 			if (seq_putting > cur_elem->seq) {
 				/*
@@ -1131,6 +1135,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	unsigned long o_dst;
 	unsigned long o_src;
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
+	int rm = 0, rm_free = 0, rm_move = 0, add = 0;;
 
 	n = btrfs_header_nritems(eb);
 	while (tm && tm->seq >= time_seq) {
@@ -1142,13 +1147,18 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		switch (tm->op) {
 		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
 			BUG_ON(tm->slot < n);
+			rm_free++;
 		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
+			if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_MOVING)
+				rm_move++;
 		case MOD_LOG_KEY_REMOVE:
 			btrfs_set_node_key(eb, &tm->key, tm->slot);
 			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
 			btrfs_set_node_ptr_generation(eb, tm->slot,
 						      tm->generation);
 			n++;
+			if (tm->op == MOD_LOG_KEY_REMOVE)
+				rm++;
 			break;
 		case MOD_LOG_KEY_REPLACE:
 			BUG_ON(tm->slot >= n);
@@ -1160,6 +1170,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		case MOD_LOG_KEY_ADD:
 			/* if a move operation is needed it's in the log */
 			n--;
+			add = 0;
 			break;
 		case MOD_LOG_MOVE_KEYS:
 			o_dst = btrfs_node_key_ptr_offset(tm->slot);
@@ -1186,6 +1197,10 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		if (tm->index != first_tm->index)
 			break;
 	}
+	if (n > 124 || (int)n < 0) {
+		printk("eb->start %llu eb->len %llu eb->level %d nritems %d n %d rm %d rm_free %d rm_move add %d\n",
+			eb->start, eb->len, btrfs_header_level(eb), btrfs_header_nritems(eb), n, rm, rm_free, rm_move, add);
+	}
 	btrfs_set_header_nritems(eb, n);
 }
 
@@ -1564,6 +1579,13 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
 
+		if (offset + sizeof(struct btrfs_disk_key) > eb->len) {
+			printk("offset %llu min_len %d eb->start %llu eb->len %llu, eb->level %d p %llu mid %d low %d high %d item %d max %d\n",
+				offset, sizeof(struct btrfs_disk_key), eb->start, eb->len, btrfs_header_level(eb),
+				p, mid, low, high, item_size, max);
+			BUG_ON(1);
+		}
+
 		if (!kaddr || offset < map_start ||
 		    (offset + sizeof(struct btrfs_disk_key)) >
 		    map_start + map_len) {
-- 
1.7.7.6


--------------070801090900090503010003
Content-Type: application/x-shellscript;
 name="debug.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="debug.sh"

IyEvYmluL2Jhc2gKCkQ9L2Rldi9zZGE1Ck09L21udC9idHJmcwoKdW1vdW50ICRNICRECm1r
ZnMuYnRyZnMgJEQKCm1vdW50ICREICRNIC1vIGF1dG9kZWZyYWcKCmZpbyBmaW9fc3luY19y
YW5kb21fd3JpdGVfNGtfY29uZmlnICYKCmZvciAoKGk9MDsgaTwyMDsgaSsrKSkKZG8KCWJ0
cmZzIHN1YiBzbmFwICRNICRNL3NfJGkKCXNsZWVwIDIKZG9uZSAmCg==
--------------070801090900090503010003
Content-Type: text/plain; charset=UTF-8;
 name="fio_sync_random_write_4k_config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio_sync_random_write_4k_config"

[global]
direct=0
ioengine=sync
size=800M
bs=4k
numjobs=1
group_reporting
invalidate=0
end_fsync=1
overwrite=0
directory=/mnt/btrfs


[job_sub0]
startdelay=0
rw=randwrite
filename=foo

--------------070801090900090503010003
Content-Type: text/plain; charset=UTF-8;
 name="crash.snapshot-defrag"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crash.snapshot-defrag"

[ 2843.633159] eb->start 77918208 eb->len 4096 eb->level 1 nritems 60 n 181 rm 61 rm_free 0 rm_move 60 add 0
[ 2843.633161] eb->start 77918208 eb->len 4096 eb->level 1 nritems 60 n 181 rm 61 rm_free 0 rm_move 60 add 0
[ 2843.633165] offset 4589 min_len 17 eb->start 77918208 eb->len 4096, eb->level 1 p 101 mid 136 low 91 high 181 item 33 max 181
[ 2843.633168] offset 4589 min_len 17 eb->start 77918208 eb->len 4096, eb->level 1 p 101 mid 136 low 91 high 181 item 33 max 181
[ 2843.633181] ------------[ cut here ]------------
[ 2843.633200] kernel BUG at fs/btrfs/ctree.c:1586!
[ 2843.633215] invalid opcode: 0000 [#1] SMP 
[ 2843.633231] Modules linked in: btrfs(O) zlib_deflate libcrc32c tcp_lp fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant i915 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer thinkpad_acpi snd iwlwifi cfg80211 btusb bluetooth wmi iTCO_wdt iTCO_vendor_support soundcore e1000e rfkill snd_page_alloc uinput coretemp crc32c_intel ghash_clmulni_intel joydev microcode pcspkr i2c_i801 lpc_ich mfd_core drm_kms_helper drm tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[ 2843.633491] CPU 2 
[ 2843.633500] Pid: 3159, comm: btrfs-endio-wri Tainted: G           O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
[ 2843.633528] RIP: 0010:[<ffffffffa05ad761>]  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.633569] RSP: 0018:ffff8801bd20f770  EFLAGS: 00010286
[ 2843.633585] RAX: 0000000000000071 RBX: 00000000000000b5 RCX: 00000000000041d4
[ 2843.633606] RDX: 000000000000784b RSI: 0000000000000046 RDI: 0000000000000246
[ 2843.633628] RBP: ffff8801bd20f820 R08: 33206d6574692031 R09: 38312078616d2033
[ 2843.633649] R10: 00000000000003dd R11: 3138312078616d20 R12: 00000000000011ed
[ 2843.633670] R13: 000000000000005b R14: ffff8801bfa5d988 R15: 0000000000000021
[ 2843.633691] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[ 2843.633714] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2843.633732] CR2: 00007f5663200000 CR3: 0000000001c0b000 CR4: 00000000000407e0
[ 2843.633753] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2843.633774] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2843.633795] Process btrfs-endio-wri (pid: 3159, threadinfo ffff8801bd20e000, task ffff8801f8179700)
[ 2843.633821] Stack:
[ 2843.633828]  0000000000000065 0000000000000088 ffff88010000005b ffff8801000000b5
[ 2843.633855]  ffff880100000021 00000000000000b5 0000000000001000 ffff8801bd20f88c
[ 2843.633881]  00000021000000b5 ffff8801bd20f906 ffff8801bd20f830 ffffffffa05a8d2a
[ 2843.633907] Call Trace:
[ 2843.633921]  [<ffffffffa05a8d2a>] ? __tree_mod_log_rewind+0x2ea/0x320 [btrfs]
[ 2843.633946]  [<ffffffffa05ad7b9>] bin_search+0x49/0x80 [btrfs]
[ 2843.633968]  [<ffffffffa05b0ca3>] btrfs_search_old_slot+0x2d3/0x7c0 [btrfs]
[ 2843.633993]  [<ffffffffa05b36ed>] btrfs_next_old_leaf+0xed/0x470 [btrfs]
[ 2843.634022]  [<ffffffffa0621f3d>] __resolve_indirect_refs+0x34d/0x6b0 [btrfs]
[ 2843.634051]  [<ffffffffa0601008>] ? btrfs_set_lock_blocking_rw+0xa8/0xf0 [btrfs]
[ 2843.634079]  [<ffffffffa0621a8a>] ? __merge_refs+0x6a/0xe0 [btrfs]
[ 2843.634103]  [<ffffffffa0622da4>] find_parent_nodes+0x784/0xf20 [btrfs]
[ 2843.634129]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.634155]  [<ffffffffa0623d15>] iterate_extent_inodes+0x135/0x370 [btrfs]
[ 2843.634180]  [<ffffffffa05ab7fe>] ? btrfs_put_tree_mod_seq+0xfe/0x150 [btrfs]
[ 2843.634206]  [<ffffffffa0623fe2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[ 2843.634233]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.634258]  [<ffffffffa05d1d84>] record_extent_backrefs+0x84/0xe0 [btrfs]
[ 2843.634285]  [<ffffffffa05dc0ee>] btrfs_finish_ordered_io+0x12e/0xa70 [btrfs]
[ 2843.634311]  [<ffffffffa05dca45>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2843.634336]  [<ffffffffa05f9a38>] worker_loop+0x148/0x580 [btrfs]
[ 2843.634360]  [<ffffffffa05f98f0>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[ 2843.634382]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[ 2843.634399]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[ 2843.635286]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[ 2843.636176]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[ 2843.637058] Code: 00 00 00 89 74 24 08 44 89 7c 24 20 4c 89 e6 89 5c 24 18 44 89 6c 24 10 89 44 24 28 48 c7 04 24 65 00 00 00 31 c0 e8 dd 9c 05 e1 <0f> 0b 89 de 45 31 ed 8b 5d 90 eb 8e 0f 1f 00 55 48 89 e5 66 66 
[ 2843.639114] RIP  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.640402]  RSP <ffff8801bd20f770>
[ 2843.649680] ---[ end trace b6796d9b5074249d ]---
[ 2843.649701] ------------[ cut here ]------------
[ 2843.649702] kernel BUG at fs/btrfs/ctree.c:1586!
[ 2843.649704] invalid opcode: 0000 [#2] SMP 
[ 2843.649731] Modules linked in: btrfs(O) zlib_deflate libcrc32c tcp_lp fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant i915 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer thinkpad_acpi snd iwlwifi cfg80211 btusb bluetooth wmi iTCO_wdt iTCO_vendor_support soundcore e1000e rfkill snd_page_alloc uinput coretemp crc32c_intel ghash_clmulni_intel joydev microcode pcspkr i2c_i801 lpc_ich mfd_core drm_kms_helper drm tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[ 2843.649734] CPU 1 
[ 2843.649734] Pid: 3139, comm: btrfs-endio-wri Tainted: G      D    O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
[ 2843.649746] RIP: 0010:[<ffffffffa05ad761>]  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.649747] RSP: 0018:ffff8801dff7f770  EFLAGS: 00010286
[ 2843.649748] RAX: 0000000000000071 RBX: 00000000000000b5 RCX: 00000000000041d1
[ 2843.649748] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000246
[ 2843.649749] RBP: ffff8801dff7f820 R08: 33206d6574692031 R09: 0000000000000005
[ 2843.649750] R10: ffffffff81e4c4bd R11: 3138312078616d20 R12: 00000000000011ed
[ 2843.649750] R13: 000000000000005b R14: ffff8801b7f03178 R15: 0000000000000021
[ 2843.649751] FS:  0000000000000000(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
[ 2843.649752] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2843.649753] CR2: 00007f5663200000 CR3: 00000001f37fd000 CR4: 00000000000407e0
[ 2843.649754] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2843.649755] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2843.649756] Process btrfs-endio-wri (pid: 3139, threadinfo ffff8801dff7e000, task ffff8801f8198000)
[ 2843.649756] Stack:
[ 2843.649758]  0000000000000065 0000000000000088 ffff88010000005b ffff8801000000b5
[ 2843.649760]  ffff880100000021 00000000000000b5 0000000000001000 ffff8801dff7f88c
[ 2843.649761]  00000021000000b5 ffff8801dff7f906 ffff8801dff7f830 ffffffffa05a8d2a
[ 2843.649762] Call Trace:
[ 2843.649769]  [<ffffffffa05a8d2a>] ? __tree_mod_log_rewind+0x2ea/0x320 [btrfs]
[ 2843.649776]  [<ffffffffa05ad7b9>] bin_search+0x49/0x80 [btrfs]
[ 2843.649782]  [<ffffffffa05b0ca3>] btrfs_search_old_slot+0x2d3/0x7c0 [btrfs]
[ 2843.649789]  [<ffffffffa05b36ed>] btrfs_next_old_leaf+0xed/0x470 [btrfs]
[ 2843.649800]  [<ffffffffa0621f3d>] __resolve_indirect_refs+0x34d/0x6b0 [btrfs]
[ 2843.649810]  [<ffffffffa0601008>] ? btrfs_set_lock_blocking_rw+0xa8/0xf0 [btrfs]
[ 2843.649819]  [<ffffffffa0621a8a>] ? __merge_refs+0x6a/0xe0 [btrfs]
[ 2843.649828]  [<ffffffffa0622da4>] find_parent_nodes+0x784/0xf20 [btrfs]
[ 2843.649837]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.649845]  [<ffffffffa0623d15>] iterate_extent_inodes+0x135/0x370 [btrfs]
[ 2843.649853]  [<ffffffffa0623fe2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[ 2843.649861]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.649869]  [<ffffffffa05d1d84>] record_extent_backrefs+0x84/0xe0 [btrfs]
[ 2843.649877]  [<ffffffffa05dc0ee>] btrfs_finish_ordered_io+0x12e/0xa70 [btrfs]
[ 2843.649885]  [<ffffffffa05dca45>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2843.649894]  [<ffffffffa05f9a38>] worker_loop+0x148/0x580 [btrfs]
[ 2843.649902]  [<ffffffffa05f98f0>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[ 2843.649905]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[ 2843.649908]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[ 2843.649909]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[ 2843.649911]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[ 2843.649926] Code: 00 00 00 89 74 24 08 44 89 7c 24 20 4c 89 e6 89 5c 24 18 44 89 6c 24 10 89 44 24 28 48 c7 04 24 65 00 00 00 31 c0 e8 dd 9c 05 e1 <0f> 0b 89 de 45 31 ed 8b 5d 90 eb 8e 0f 1f 00 55 48 89 e5 66 66 
[ 2843.649932] RIP  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.649933]  RSP <ffff8801dff7f770>
[ 2843.649934] ---[ end trace b6796d9b5074249e ]---
[ 2843.656802] eb->start 92053504 eb->len 4096 eb->level 1 nritems 58 n 179 rm 63 rm_free 0 rm_move 58 add 0
[ 2843.656804] eb->start 92053504 eb->len 4096 eb->level 1 nritems 58 n 179 rm 63 rm_free 0 rm_move 58 add 0
[ 2843.656825] eb->start 92053504 eb->len 4096 eb->level 1 nritems 58 n 179 rm 63 rm_free 0 rm_move 58 add 0
[ 2843.656826] eb->start 92053504 eb->len 4096 eb->level 1 nritems 58 n 179 rm 63 rm_free 0 rm_move 58 add 0
[ 2843.656908] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656909] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656933] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656934] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656958] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656959] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656991] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.656994] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657016] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657020] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657042] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657046] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657064] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657074] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657088] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657097] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657122] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657123] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657147] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657148] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657172] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657182] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657196] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657210] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657219] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657236] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657243] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657262] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657268] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657288] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657295] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657312] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657319] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657339] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657342] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657364] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657367] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657391] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657392] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657417] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657419] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657440] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657446] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657465] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657471] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657489] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657496] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657516] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657523] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657541] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657549] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657566] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657574] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657589] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657601] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657614] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657626] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657636] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657651] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657660] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657677] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657684] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657702] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657708] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657728] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657733] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657755] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657757] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657782] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657783] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657807] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657808] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657834] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657835] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657858] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657860] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657884] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657885] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657909] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657911] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657934] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657936] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657958] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657968] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657989] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.657995] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658014] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658020] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658038] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658046] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658062] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658072] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658085] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658098] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658108] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658125] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658132] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658152] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658157] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658180] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658182] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658207] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658208] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658210] offset 4523 min_len 17 eb->start 92053504 eb->len 4096, eb->level 1 p 101 mid 134 low 90 high 179 item 33 max 179
[ 2843.658227] ------------[ cut here ]------------
[ 2843.658233] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658259] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658290] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658312] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658339] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658363] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658390] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658417] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658443] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658472] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658498] eb->start 92053504 eb->len 4096 eb->level 1 nritems 60 n 179 rm 122 rm_free 0 rm_move 58 add 61
[ 2843.658500] offset 4523 min_len 17 eb->start 92053504 eb->len 4096, eb->level 1 p 101 mid 134 low 90 high 179 item 33 max 179
[ 2843.671265] kernel BUG at fs/btrfs/ctree.c:1586!
[ 2843.672198] invalid opcode: 0000 [#3] SMP 
[ 2843.673119] Modules linked in: btrfs(O) zlib_deflate libcrc32c tcp_lp fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant i915 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer thinkpad_acpi snd iwlwifi cfg80211 btusb bluetooth wmi iTCO_wdt iTCO_vendor_support soundcore e1000e rfkill snd_page_alloc uinput coretemp crc32c_intel ghash_clmulni_intel joydev microcode pcspkr i2c_i801 lpc_ich mfd_core drm_kms_helper drm tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[ 2843.678460] CPU 0 
[ 2843.678471] Pid: 3158, comm: btrfs-endio-wri Tainted: G      D    O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
[ 2843.680591] RIP: 0010:[<ffffffffa05ad761>]  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.681708] RSP: 0018:ffff8801bc373770  EFLAGS: 00010286
[ 2843.682811] RAX: 0000000000000071 RBX: 00000000000000b3 RCX: 0000000000004532
[ 2843.683947] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000246
[ 2843.685047] RBP: ffff8801bc373820 R08: 33206d6574692039 R09: 0000000000000001
[ 2843.686145] R10: ffffffff81e51761 R11: 3937312078616d20 R12: 00000000000011ab
[ 2843.687244] R13: 000000000000005a R14: ffff8801b5924ec8 R15: 0000000000000021
[ 2843.688346] FS:  0000000000000000(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
[ 2843.689456] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2843.690565] CR2: 00000000024a02b1 CR3: 0000000211c97000 CR4: 00000000000407f0
[ 2843.691680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2843.692796] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2843.693924] Process btrfs-endio-wri (pid: 3158, threadinfo ffff8801bc372000, task ffff8802119ec500)
[ 2843.695052] Stack:
[ 2843.696188]  0000000000000065 0000000000000086 ffff88010000005a ffff8801000000b3
[ 2843.697395]  ffff880100000021 00000000000000b3 0000000000001000 ffff8801bc37388c
[ 2843.698589]  00000021000000b3 ffff8801bc373906 ffff8801bc373830 ffffffffa05a8d2a
[ 2843.699786] Call Trace:
[ 2843.700946]  [<ffffffffa05a8d2a>] ? __tree_mod_log_rewind+0x2ea/0x320 [btrfs]
[ 2843.702113]  [<ffffffffa05ad7b9>] bin_search+0x49/0x80 [btrfs]
[ 2843.703279]  [<ffffffffa05b0ca3>] btrfs_search_old_slot+0x2d3/0x7c0 [btrfs]
[ 2843.704402]  [<ffffffffa05b36ed>] btrfs_next_old_leaf+0xed/0x470 [btrfs]
[ 2843.705477]  [<ffffffffa0621f3d>] __resolve_indirect_refs+0x34d/0x6b0 [btrfs]
[ 2843.706571]  [<ffffffffa0621a8a>] ? __merge_refs+0x6a/0xe0 [btrfs]
[ 2843.707628]  [<ffffffffa0622da4>] find_parent_nodes+0x784/0xf20 [btrfs]
[ 2843.708688]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.709756]  [<ffffffffa0623d15>] iterate_extent_inodes+0x135/0x370 [btrfs]
[ 2843.710802]  [<ffffffffa0623fe2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[ 2843.711882]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.712956]  [<ffffffffa05d1d84>] record_extent_backrefs+0x84/0xe0 [btrfs]
[ 2843.714043]  [<ffffffffa05dc0ee>] btrfs_finish_ordered_io+0x12e/0xa70 [btrfs]
[ 2843.715145]  [<ffffffffa05dca45>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2843.716259]  [<ffffffffa05f9a38>] worker_loop+0x148/0x580 [btrfs]
[ 2843.717389]  [<ffffffffa05f98f0>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[ 2843.718527]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[ 2843.719672]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[ 2843.720854]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[ 2843.722027]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[ 2843.723172] Code: 00 00 00 89 74 24 08 44 89 7c 24 20 4c 89 e6 89 5c 24 18 44 89 6c 24 10 89 44 24 28 48 c7 04 24 65 00 00 00 31 c0 e8 dd 9c 05 e1 <0f> 0b 89 de 45 31 ed 8b 5d 90 eb 8e 0f 1f 00 55 48 89 e5 66 66 
[ 2843.725684] RIP  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.726925]  RSP <ffff8801bc373770>
[ 2843.728098] ------------[ cut here ]------------
[ 2843.728400] ---[ end trace b6796d9b5074249f ]---
[ 2843.729997] kernel BUG at fs/btrfs/ctree.c:1586!
[ 2843.730851] invalid opcode: 0000 [#4] SMP 
[ 2843.731711] Modules linked in: btrfs(O) zlib_deflate libcrc32c tcp_lp fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant i915 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer thinkpad_acpi snd iwlwifi cfg80211 btusb bluetooth wmi iTCO_wdt iTCO_vendor_support soundcore e1000e rfkill snd_page_alloc uinput coretemp crc32c_intel ghash_clmulni_intel joydev microcode pcspkr i2c_i801 lpc_ich mfd_core drm_kms_helper drm tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[ 2843.736470] CPU 1 
[ 2843.736479] Pid: 3156, comm: btrfs-endio-wri Tainted: G      D    O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
[ 2843.738384] RIP: 0010:[<ffffffffa05ad761>]  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.739413] RSP: 0018:ffff8801becb9770  EFLAGS: 00010286
[ 2843.740393] RAX: 0000000000000071 RBX: 00000000000000b3 RCX: 0000000000004540
[ 2843.741373] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000246
[ 2843.742342] RBP: ffff8801becb9820 R08: 342074657366666f R09: 0000000000000001
[ 2843.743363] R10: ffffffff81e51ce9 R11: 6c5f6e696d203332 R12: 00000000000011ab
[ 2843.744332] R13: 000000000000005a R14: ffff8801ab9b1178 R15: 0000000000000021
[ 2843.745295] FS:  0000000000000000(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
[ 2843.746254] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2843.747209] CR2: 00007f5663200000 CR3: 00000001f37fd000 CR4: 00000000000407e0
[ 2843.748174] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2843.749157] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2843.750119] Process btrfs-endio-wri (pid: 3156, threadinfo ffff8801becb8000, task ffff8801f99e4500)
[ 2843.751088] Stack:
[ 2843.752070]  0000000000000065 0000000000000086 ffff88010000005a ffff8801000000b3
[ 2843.753050]  ffff880100000021 00000000000000b3 0000000000001000 ffff8801becb988c
[ 2843.754032]  00000021000000b3 ffff8801becb9906 ffff8801becb9830 ffffffffa05a8d2a
[ 2843.755022] Call Trace:
[ 2843.756006]  [<ffffffffa05a8d2a>] ? __tree_mod_log_rewind+0x2ea/0x320 [btrfs]
[ 2843.757008]  [<ffffffffa05ad7b9>] bin_search+0x49/0x80 [btrfs]
[ 2843.758007]  [<ffffffffa05b0ca3>] btrfs_search_old_slot+0x2d3/0x7c0 [btrfs]
[ 2843.759018]  [<ffffffffa05b36ed>] btrfs_next_old_leaf+0xed/0x470 [btrfs]
[ 2843.760028]  [<ffffffffa0621f3d>] __resolve_indirect_refs+0x34d/0x6b0 [btrfs]
[ 2843.761034]  [<ffffffffa0621a8a>] ? __merge_refs+0x6a/0xe0 [btrfs]
[ 2843.762037]  [<ffffffffa0622da4>] find_parent_nodes+0x784/0xf20 [btrfs]
[ 2843.763041]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.764040]  [<ffffffffa0623d15>] iterate_extent_inodes+0x135/0x370 [btrfs]
[ 2843.765045]  [<ffffffffa0623fe2>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[ 2843.766048]  [<ffffffffa05d4580>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[ 2843.767044]  [<ffffffffa05d1d84>] record_extent_backrefs+0x84/0xe0 [btrfs]
[ 2843.768046]  [<ffffffffa05dc0ee>] btrfs_finish_ordered_io+0x12e/0xa70 [btrfs]
[ 2843.769058]  [<ffffffffa05dca45>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2843.770341]  [<ffffffffa05f9a38>] worker_loop+0x148/0x580 [btrfs]
[ 2843.771699]  [<ffffffffa05f98f0>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[ 2843.772972]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[ 2843.774190]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[ 2843.775076]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[ 2843.775963]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[ 2843.776854] Code: 00 00 00 89 74 24 08 44 89 7c 24 20 4c 89 e6 89 5c 24 18 44 89 6c 24 10 89 44 24 28 48 c7 04 24 65 00 00 00 31 c0 e8 dd 9c 05 e1 <0f> 0b 89 de 45 31 ed 8b 5d 90 eb 8e 0f 1f 00 55 48 89 e5 66 66 
[ 2843.778874] RIP  [<ffffffffa05ad761>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[ 2843.779856]  RSP <ffff8801becb9770>
[ 2843.780823] ---[ end trace b6796d9b507424a0 ]---

--------------070801090900090503010003--
