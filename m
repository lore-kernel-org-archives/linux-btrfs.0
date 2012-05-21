Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:49957 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2EUGGp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 02:06:45 -0400
Message-ID: <4FB9DB74.9000200@jan-o-sch.net>
Date: Mon, 21 May 2012 08:06:44 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/24] Btrfs: add tree modification log functions
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net> <16caf75ba5c8419abeb8bbe889d388682bb720f3.1337525292.git.list.btrfs@jan-o-sch.net> <4FB981D2.9040209@jp.fujitsu.com>
In-Reply-To: <4FB981D2.9040209@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tsutomu,

On Mon, May 21, 2012 at 01:44 (+0200), Tsutomu Itoh wrote:
>> +static noinline int
>> +__tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>> +{
>> +	struct rb_root *tm_root;
>> +	struct rb_node **new;
>> +	struct rb_node *parent = NULL;
>> +	struct tree_mod_elem *cur;
>> +
>> +	BUG_ON(!tm || !tm->elem.seq);
>> +
>> +	write_lock(&fs_info->tree_mod_log_lock);
>> +	tm_root =&fs_info->tree_mod_log;
>> +	new =&tm_root->rb_node;
>> +	while (*new) {
>> +		cur = container_of(*new, struct tree_mod_elem, node);
>> +		parent = *new;
>> +		if (cur->index<  tm->index)
>> +			new =&((*new)->rb_left);
>> +		else if (cur->index>  tm->index)
>> +			new =&((*new)->rb_right);
>> +		else if (cur->elem.seq<  tm->elem.seq)
>> +			new =&((*new)->rb_left);
>> +		else if (cur->elem.seq>  tm->elem.seq)
>> +			new =&((*new)->rb_right);
>> +		else {
>> +			kfree(tm);
>> +			return -EEXIST;
> 
> I think that write_unlock() is necessary for here.

I thought about calling write_unlock() here and decided against, because
we cannot handle EEXIST anyway. If it ever occurs, there's a bug in the
code and we hit a BUG_ON immediately after.

To make that more explicit, I'll change it to either call BUG() here
directly or do the write_unlock nevertheless.

>> +		}
>> +	}
>> +
>> +	rb_link_node(&tm->node, parent, new);
>> +	rb_insert_color(&tm->node, tm_root);
>> +	write_unlock(&fs_info->tree_mod_log_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
>> +		   struct tree_mod_elem **tm_ret)
>> +{
>> +	struct tree_mod_elem *tm;
>> +	u64 seq = 0;
>> +
>> +	/*
>> +	 * we want to avoid a malloc/free cycle if there's no blocker in the
>> +	 * list.
>> +	 * we also want to avoid atomic malloc. so we must drop the spinlock
>> +	 * before calling kzalloc and recheck afterwards.
>> +	 */
>> +	spin_lock(&fs_info->tree_mod_seq_lock);
>> +	if (list_empty(&fs_info->tree_mod_seq_list))
>> +		goto out;
>> +
>> +	spin_unlock(&fs_info->tree_mod_seq_lock);
>> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
>> +	if (!tm)
>> +		return -ENOMEM;
>> +
>> +	spin_lock(&fs_info->tree_mod_seq_lock);
>> +	if (list_empty(&fs_info->tree_mod_seq_list)) {
>> +		kfree(tm);
>> +		goto out;
>> +	}
>> +
>> +	__get_tree_mod_seq(fs_info,&tm->elem);
>> +	seq = tm->elem.seq;
>> +	tm->elem.flags = 0;
>> +
>> +out:
>> +	spin_unlock(&fs_info->tree_mod_seq_lock);
>> +	return seq;
>> +}
>> +
>> +static noinline int
>> +tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
>> +			     struct extent_buffer *eb, int slot,
>> +			     enum mod_log_op op, gfp_t flags)
>> +{
>> +	struct tree_mod_elem *tm;
>> +	int ret;
>> +
>> +	ret = tree_mod_alloc(fs_info, flags,&tm);
>> +	if (ret<= 0)
>> +		return ret;
>> +
>> +	tm->index = eb->start>>  PAGE_CACHE_SHIFT;
>> +	if (op != MOD_LOG_KEY_ADD) {
>> +		btrfs_node_key(eb,&tm->key, slot);
>> +		tm->blockptr = btrfs_node_blockptr(eb, slot);
>> +	}
>> +	tm->op = op;
>> +	tm->slot = slot;
>> +	tm->generation = btrfs_node_ptr_generation(eb, slot);
>> +
>> +	return __tree_mod_log_insert(fs_info, tm);
>> +}
>> +
>> +static noinline int
>> +tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>> +			int slot, enum mod_log_op op)
>> +{
>> +	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op, GFP_NOFS);
>> +}
>> +
>> +static noinline int
>> +tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>> +			 struct extent_buffer *eb, int dst_slot, int src_slot,
>> +			 int nr_items, gfp_t flags)
>> +{
>> +	struct tree_mod_elem *tm;
>> +	int ret;
>> +
>> +	ret = tree_mod_alloc(fs_info, flags,&tm);
>> +	if (ret<= 0)
>> +		return ret;
>> +
>> +	tm->index = eb->start>>  PAGE_CACHE_SHIFT;
>> +	tm->slot = src_slot;
>> +	tm->move.dst_slot = dst_slot;
>> +	tm->move.nr_items = nr_items;
>> +	tm->op = MOD_LOG_MOVE_KEYS;
>> +
>> +	return __tree_mod_log_insert(fs_info, tm);
>> +}
>> +
>> +static noinline int
>> +tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>> +			 struct extent_buffer *old_root,
>> +			 struct extent_buffer *new_root, gfp_t flags)
>> +{
>> +	struct tree_mod_elem *tm;
>> +	int ret;
>> +
>> +	ret = tree_mod_alloc(fs_info, flags,&tm);
>> +	if (ret<= 0)
>> +		return ret;
>> +
>> +	tm->index = new_root->start>>  PAGE_CACHE_SHIFT;
>> +	tm->old_root.logical = old_root->start;
>> +	tm->old_root.level = btrfs_header_level(old_root);
>> +	tm->generation = btrfs_header_generation(old_root);
>> +	tm->op = MOD_LOG_ROOT_REPLACE;
>> +
>> +	return __tree_mod_log_insert(fs_info, tm);
>> +}
>> +
>> +static struct tree_mod_elem *
>> +__tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
>> +		      int smallest)
>> +{
>> +	struct rb_root *tm_root;
>> +	struct rb_node *node;
>> +	struct tree_mod_elem *cur = NULL;
>> +	struct tree_mod_elem *found = NULL;
>> +	u64 index = start>>  PAGE_CACHE_SHIFT;
>> +
>> +	read_lock(&fs_info->tree_mod_log_lock);
>> +	tm_root =&fs_info->tree_mod_log;
>> +	node = tm_root->rb_node;
>> +	while (node) {
>> +		cur = container_of(node, struct tree_mod_elem, node);
>> +		if (cur->index<  index) {
>> +			node = node->rb_left;
>> +		} else if (cur->index>  index) {
>> +			node = node->rb_right;
>> +		} else if (cur->elem.seq<  min_seq) {
>> +			node = node->rb_left;
>> +		} else if (!smallest) {
>> +			/* we want the node with the highest seq */
>> +			if (found)
>> +				BUG_ON(found->elem.seq>  cur->elem.seq);
>> +			found = cur;
>> +			node = node->rb_left;
>> +		} else if (cur->elem.seq>  min_seq) {
>> +			/* we want the node with the smallest seq */
>> +			if (found)
>> +				BUG_ON(found->elem.seq<  cur->elem.seq);
>> +			found = cur;
>> +			node = node->rb_right;
>> +		} else {
> 
> I think read_unlock() is necessary for here.

Right, I'll add that. Strange lockdep didn't catch this one.

Thanks for looking!
-Jan
