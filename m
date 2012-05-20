Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56209 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2ETXoe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 19:44:34 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 60BB53EE0B5
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 08:44:32 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 47F7945DEB3
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 08:44:32 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2E59D45DE7E
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 08:44:32 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 227391DB803F
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 08:44:32 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B9C931DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2012 08:44:31 +0900 (JST)
Message-ID: <4FB981D2.9040209@jp.fujitsu.com>
Date: Mon, 21 May 2012 08:44:18 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/24] Btrfs: add tree modification log functions
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net> <16caf75ba5c8419abeb8bbe889d388682bb720f3.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <16caf75ba5c8419abeb8bbe889d388682bb720f3.1337525292.git.list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

(2012/05/21 1:06), Jan Schmidt wrote:
> The tree mod log will log modifications made fs-tree nodes. Most
> modifications are done by autobalance of the tree. Such changes are recorded
> as long as a block entry exists. When released, the log is cleaned.
> 
> With the tree modification log, it's possible to reconstruct a consistent
> old state of the tree. This is required to do backref walking on a busy
> file system.
> 
> Signed-off-by: Jan Schmidt<list.btrfs@jan-o-sch.net>
> ---
>   fs/btrfs/ctree.c   |  409 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/ctree.h   |    7 +-
>   fs/btrfs/disk-io.c |    2 +-
>   3 files changed, 416 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 56485b3..6420638 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -18,6 +18,7 @@
> 
>   #include<linux/sched.h>
>   #include<linux/slab.h>
> +#include<linux/rbtree.h>
>   #include "ctree.h"
>   #include "disk-io.h"
>   #include "transaction.h"
> @@ -288,6 +289,414 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
>   	return 0;
>   }
> 
> +enum mod_log_op {
> +	MOD_LOG_KEY_REPLACE,
> +	MOD_LOG_KEY_ADD,
> +	MOD_LOG_KEY_REMOVE,
> +	MOD_LOG_KEY_REMOVE_WHILE_FREEING,
> +	MOD_LOG_MOVE_KEYS,
> +	MOD_LOG_ROOT_REPLACE,
> +};
> +
> +struct tree_mod_move {
> +	int dst_slot;
> +	int nr_items;
> +};
> +
> +struct tree_mod_root {
> +	u64 logical;
> +	u8 level;
> +};
> +
> +struct tree_mod_elem {
> +	struct rb_node node;
> +	u64 index;		/* shifted logical */
> +	struct seq_list elem;
> +	enum mod_log_op op;
> +
> +	/* this is used for MOD_LOG_KEY_* and MOD_LOG_MOVE_KEYS operations */
> +	int slot;
> +
> +	/* this is used for MOD_LOG_KEY* and MOD_LOG_ROOT_REPLACE */
> +	u64 generation;
> +
> +	/* those are used for op == MOD_LOG_KEY_{REPLACE,REMOVE} */
> +	struct btrfs_disk_key key;
> +	u64 blockptr;
> +
> +	/* this is used for op == MOD_LOG_MOVE_KEYS */
> +	struct tree_mod_move move;
> +
> +	/* this is used for op == MOD_LOG_ROOT_REPLACE */
> +	struct tree_mod_root old_root;
> +};
> +
> +static inline void
> +__get_tree_mod_seq(struct btrfs_fs_info *fs_info, struct seq_list *elem)
> +{
> +	elem->seq = atomic_inc_return(&fs_info->tree_mod_seq);
> +	list_add_tail(&elem->list,&fs_info->tree_mod_seq_list);
> +}
> +
> +void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
> +			    struct seq_list *elem)
> +{
> +	elem->flags = 1;
> +	spin_lock(&fs_info->tree_mod_seq_lock);
> +	__get_tree_mod_seq(fs_info, elem);
> +	spin_unlock(&fs_info->tree_mod_seq_lock);
> +}
> +
> +void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
> +			    struct seq_list *elem)
> +{
> +	struct rb_root *tm_root;
> +	struct rb_node *node;
> +	struct rb_node *next;
> +	struct seq_list *cur_elem;
> +	struct tree_mod_elem *tm;
> +	u64 min_seq = (u64)-1;
> +	u64 seq_putting = elem->seq;
> +
> +	if (!seq_putting)
> +		return;
> +
> +	BUG_ON(!(elem->flags&  1));
> +	spin_lock(&fs_info->tree_mod_seq_lock);
> +	list_del(&elem->list);
> +
> +	list_for_each_entry(cur_elem,&fs_info->tree_mod_seq_list, list) {
> +		if ((cur_elem->flags&  1)&&  cur_elem->seq<  min_seq) {
> +			if (seq_putting>  cur_elem->seq) {
> +				/*
> +				 * blocker with lower sequence number exists, we
> +				 * cannot remove anything from the log
> +				 */
> +				goto out;
> +			}
> +			min_seq = cur_elem->seq;
> +		}
> +	}
> +
> +	/*
> +	 * anything that's lower than the lowest existing (read: blocked)
> +	 * sequence number can be removed from the tree.
> +	 */
> +	write_lock(&fs_info->tree_mod_log_lock);
> +	tm_root =&fs_info->tree_mod_log;
> +	for (node = rb_first(tm_root); node; node = next) {
> +		next = rb_next(node);
> +		tm = container_of(node, struct tree_mod_elem, node);
> +		if (tm->elem.seq>  min_seq)
> +			continue;
> +		rb_erase(node, tm_root);
> +		list_del(&tm->elem.list);
> +		kfree(tm);
> +	}
> +	write_unlock(&fs_info->tree_mod_log_lock);
> +out:
> +	spin_unlock(&fs_info->tree_mod_seq_lock);
> +}
> +
> +/*
> + * key order of the log:
> + *       index ->  sequence
> + *
> + * the index is the shifted logical of the *new* root node for root replace
> + * operations, or the shifted logical of the affected block for all other
> + * operations.
> + */
> +static noinline int
> +__tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
> +{
> +	struct rb_root *tm_root;
> +	struct rb_node **new;
> +	struct rb_node *parent = NULL;
> +	struct tree_mod_elem *cur;
> +
> +	BUG_ON(!tm || !tm->elem.seq);
> +
> +	write_lock(&fs_info->tree_mod_log_lock);
> +	tm_root =&fs_info->tree_mod_log;
> +	new =&tm_root->rb_node;
> +	while (*new) {
> +		cur = container_of(*new, struct tree_mod_elem, node);
> +		parent = *new;
> +		if (cur->index<  tm->index)
> +			new =&((*new)->rb_left);
> +		else if (cur->index>  tm->index)
> +			new =&((*new)->rb_right);
> +		else if (cur->elem.seq<  tm->elem.seq)
> +			new =&((*new)->rb_left);
> +		else if (cur->elem.seq>  tm->elem.seq)
> +			new =&((*new)->rb_right);
> +		else {
> +			kfree(tm);
> +			return -EEXIST;

I think that write_unlock() is necessary for here.

> +		}
> +	}
> +
> +	rb_link_node(&tm->node, parent, new);
> +	rb_insert_color(&tm->node, tm_root);
> +	write_unlock(&fs_info->tree_mod_log_lock);
> +
> +	return 0;
> +}
> +
> +int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
> +		   struct tree_mod_elem **tm_ret)
> +{
> +	struct tree_mod_elem *tm;
> +	u64 seq = 0;
> +
> +	/*
> +	 * we want to avoid a malloc/free cycle if there's no blocker in the
> +	 * list.
> +	 * we also want to avoid atomic malloc. so we must drop the spinlock
> +	 * before calling kzalloc and recheck afterwards.
> +	 */
> +	spin_lock(&fs_info->tree_mod_seq_lock);
> +	if (list_empty(&fs_info->tree_mod_seq_list))
> +		goto out;
> +
> +	spin_unlock(&fs_info->tree_mod_seq_lock);
> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
> +	if (!tm)
> +		return -ENOMEM;
> +
> +	spin_lock(&fs_info->tree_mod_seq_lock);
> +	if (list_empty(&fs_info->tree_mod_seq_list)) {
> +		kfree(tm);
> +		goto out;
> +	}
> +
> +	__get_tree_mod_seq(fs_info,&tm->elem);
> +	seq = tm->elem.seq;
> +	tm->elem.flags = 0;
> +
> +out:
> +	spin_unlock(&fs_info->tree_mod_seq_lock);
> +	return seq;
> +}
> +
> +static noinline int
> +tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
> +			     struct extent_buffer *eb, int slot,
> +			     enum mod_log_op op, gfp_t flags)
> +{
> +	struct tree_mod_elem *tm;
> +	int ret;
> +
> +	ret = tree_mod_alloc(fs_info, flags,&tm);
> +	if (ret<= 0)
> +		return ret;
> +
> +	tm->index = eb->start>>  PAGE_CACHE_SHIFT;
> +	if (op != MOD_LOG_KEY_ADD) {
> +		btrfs_node_key(eb,&tm->key, slot);
> +		tm->blockptr = btrfs_node_blockptr(eb, slot);
> +	}
> +	tm->op = op;
> +	tm->slot = slot;
> +	tm->generation = btrfs_node_ptr_generation(eb, slot);
> +
> +	return __tree_mod_log_insert(fs_info, tm);
> +}
> +
> +static noinline int
> +tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> +			int slot, enum mod_log_op op)
> +{
> +	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op, GFP_NOFS);
> +}
> +
> +static noinline int
> +tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
> +			 struct extent_buffer *eb, int dst_slot, int src_slot,
> +			 int nr_items, gfp_t flags)
> +{
> +	struct tree_mod_elem *tm;
> +	int ret;
> +
> +	ret = tree_mod_alloc(fs_info, flags,&tm);
> +	if (ret<= 0)
> +		return ret;
> +
> +	tm->index = eb->start>>  PAGE_CACHE_SHIFT;
> +	tm->slot = src_slot;
> +	tm->move.dst_slot = dst_slot;
> +	tm->move.nr_items = nr_items;
> +	tm->op = MOD_LOG_MOVE_KEYS;
> +
> +	return __tree_mod_log_insert(fs_info, tm);
> +}
> +
> +static noinline int
> +tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
> +			 struct extent_buffer *old_root,
> +			 struct extent_buffer *new_root, gfp_t flags)
> +{
> +	struct tree_mod_elem *tm;
> +	int ret;
> +
> +	ret = tree_mod_alloc(fs_info, flags,&tm);
> +	if (ret<= 0)
> +		return ret;
> +
> +	tm->index = new_root->start>>  PAGE_CACHE_SHIFT;
> +	tm->old_root.logical = old_root->start;
> +	tm->old_root.level = btrfs_header_level(old_root);
> +	tm->generation = btrfs_header_generation(old_root);
> +	tm->op = MOD_LOG_ROOT_REPLACE;
> +
> +	return __tree_mod_log_insert(fs_info, tm);
> +}
> +
> +static struct tree_mod_elem *
> +__tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
> +		      int smallest)
> +{
> +	struct rb_root *tm_root;
> +	struct rb_node *node;
> +	struct tree_mod_elem *cur = NULL;
> +	struct tree_mod_elem *found = NULL;
> +	u64 index = start>>  PAGE_CACHE_SHIFT;
> +
> +	read_lock(&fs_info->tree_mod_log_lock);
> +	tm_root =&fs_info->tree_mod_log;
> +	node = tm_root->rb_node;
> +	while (node) {
> +		cur = container_of(node, struct tree_mod_elem, node);
> +		if (cur->index<  index) {
> +			node = node->rb_left;
> +		} else if (cur->index>  index) {
> +			node = node->rb_right;
> +		} else if (cur->elem.seq<  min_seq) {
> +			node = node->rb_left;
> +		} else if (!smallest) {
> +			/* we want the node with the highest seq */
> +			if (found)
> +				BUG_ON(found->elem.seq>  cur->elem.seq);
> +			found = cur;
> +			node = node->rb_left;
> +		} else if (cur->elem.seq>  min_seq) {
> +			/* we want the node with the smallest seq */
> +			if (found)
> +				BUG_ON(found->elem.seq<  cur->elem.seq);
> +			found = cur;
> +			node = node->rb_right;
> +		} else {

I think read_unlock() is necessary for here.

Thanks,
Tsutomu

> +			return cur;
> +		}
> +	}
> +	read_unlock(&fs_info->tree_mod_log_lock);
> +
> +	return found;
> +}
> +
> +/*
> + * this returns the element from the log with the smallest time sequence
> + * value that's in the log (the oldest log item). any element with a time
> + * sequence lower than min_seq will be ignored.
> + */
> +static struct tree_mod_elem *
> +tree_mod_log_search_oldest(struct btrfs_fs_info *fs_info, u64 start,
> +			   u64 min_seq)
> +{
> +	return __tree_mod_log_search(fs_info, start, min_seq, 1);
> +}
> +
> +/*
> + * this returns the element from the log with the largest time sequence
> + * value that's in the log (the most recent log item). any element with
> + * a time sequence lower than min_seq will be ignored.
> + */
> +static struct tree_mod_elem *
> +tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
> +{
> +	return __tree_mod_log_search(fs_info, start, min_seq, 0);
> +}
> +
> +static inline void
> +__copy_extent_buffer_log(struct btrfs_fs_info *fs_info,
> +			 struct extent_buffer *dst, struct extent_buffer *src,
> +			 unsigned long dst_offset, unsigned long src_offset,
> +			 int nr_items, size_t item_size)
> +{
> +	int ret;
> +	int i;
> +
> +	/* speed this up by single seq for all operations? */
> +	for (i = 0; i<  nr_items; i++) {
> +		ret = tree_mod_log_insert_key(fs_info, src, i + src_offset,
> +					      MOD_LOG_KEY_REMOVE);
> +		BUG_ON(ret<  0);
> +		ret = tree_mod_log_insert_key(fs_info, dst, i + dst_offset,
> +					      MOD_LOG_KEY_ADD);
> +		BUG_ON(ret<  0);
> +	}
> +
> +	copy_extent_buffer(dst, src, btrfs_node_key_ptr_offset(dst_offset),
> +			   btrfs_node_key_ptr_offset(src_offset),
> +			   nr_items * item_size);
> +}
> +
> +static inline void
> +__memmove_extent_buffer_log(struct btrfs_fs_info *fs_info,
> +			    struct extent_buffer *dst,
> +			    int dst_offset, int src_offset, int nr_items,
> +			    size_t item_size, int tree_mod_log)
> +{
> +	int ret;
> +	if (tree_mod_log) {
> +		ret = tree_mod_log_insert_move(fs_info, dst, dst_offset,
> +					       src_offset, nr_items, GFP_NOFS);
> +		BUG_ON(ret<  0);
> +	}
> +	memmove_extent_buffer(dst, btrfs_node_key_ptr_offset(dst_offset),
> +			      btrfs_node_key_ptr_offset(src_offset),
> +			      nr_items * item_size);
> +}
> +
> +static inline void
> +__set_node_key_log(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> +		   struct btrfs_disk_key *disk_key, int nr, int atomic)
> +{
> +	int ret;
> +
> +	ret = tree_mod_log_insert_key_mask(fs_info, eb, nr, MOD_LOG_KEY_REPLACE,
> +					   atomic ? GFP_ATOMIC : GFP_NOFS);
> +	BUG_ON(ret<  0);
> +
> +	btrfs_set_node_key(eb, disk_key, nr);
> +}
> +
> +static void __log_cleaning(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *eb)
> +{
> +	int i;
> +	int ret;
> +	u32 nritems;
> +
> +	nritems = btrfs_header_nritems(eb);
> +	for (i = nritems - 1; i>= 0; i--) {
> +		ret = tree_mod_log_insert_key(fs_info, eb, i,
> +					      MOD_LOG_KEY_REMOVE_WHILE_FREEING);
> +		BUG_ON(ret<  0);
> +	}
> +}
> +
> +static inline void
> +set_root_pointer(struct btrfs_root *root, struct extent_buffer *new_root_node)
> +{
> +	int ret;
> +	__log_cleaning(root->fs_info, root->node);
> +	ret = tree_mod_log_insert_root(root->fs_info, root->node,
> +				       new_root_node, GFP_NOFS);
> +	BUG_ON(ret<  0);
> +	rcu_assign_pointer(root->node, new_root_node);
> +}
> +
>   /*
>    * check if the tree block can be shared by multiple trees
>    */
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6774821..e53bfb9 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1132,7 +1132,7 @@ struct btrfs_fs_info {
>   	/* this protects tree_mod_seq_list */
>   	spinlock_t tree_mod_seq_lock;
>   	atomic_t tree_mod_seq;
> -	struct list_head tree_mod_list;
> +	struct list_head tree_mod_seq_list;
> 
>   	/* this protects tree_mod_log */
>   	rwlock_t tree_mod_log_lock;
> @@ -3114,4 +3114,9 @@ struct seq_list {
>   	u32 flags;
>   };
> 
> +void btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
> +			    struct seq_list *elem);
> +void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
> +			    struct seq_list *elem);
> +
>   #endif
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6aec7c6..f51ad84 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1921,7 +1921,7 @@ int open_ctree(struct super_block *sb,
>   	init_completion(&fs_info->kobj_unregister);
>   	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
>   	INIT_LIST_HEAD(&fs_info->space_info);
> -	INIT_LIST_HEAD(&fs_info->tree_mod_list);
> +	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
>   	btrfs_mapping_init(&fs_info->mapping_tree);
>   	btrfs_init_block_rsv(&fs_info->global_block_rsv);
>   	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv);

