Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726604AbeG3LEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 07:04:37 -0400
Subject: Re: [PATCH 14/15] btrfs-progs: Wire up delayed refs
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-15-git-send-email-nborisov@suse.com>
 <ae8a40ec-5708-7775-d02d-18f3dc5a12a0@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5a1abc9b-12b5-ca37-b4ba-eaa656cf9acb@suse.com>
Date: Mon, 30 Jul 2018 12:30:26 +0300
MIME-Version: 1.0
In-Reply-To: <ae8a40ec-5708-7775-d02d-18f3dc5a12a0@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.07.2018 11:33, Misono Tomohiro wrote:
> On 2018/06/08 21:47, Nikolay Borisov wrote:
>> This commit enables the delayed refs infrastructures. This entails doing
>> the following:
>>
>> 1. Replacing existing calls of btrfs_extent_post_op (which is the
>> equivalent of delayed refs) with the proper btrfs_run_delayed_refs.
>> As well as eliminating open-coded calls to finish_current_insert and
>> del_pending_extents which execute the delayed ops.
>>
>> 2. Wiring up the addition of delayed refs when freeing extents
>> (btrfs_free_extent) and when adding new extents (alloc_tree_block).
>>
>> 3. Adding calls to btrfs_run_delayed refs in the transaction commit
>> path alongside comments why every call is needed, since it's not always
>> obvious (those call sites were derived empirically by running and
>> debugging existing tests)
>>
>> 4. Correctly flagging the transaction in which we are reinitialising
>> the extent tree.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  check/main.c  |   3 +-
>>  extent-tree.c | 166 ++++++++++++++++++++++++++++++----------------------------
>>  transaction.c |  24 +++++++++
>>  3 files changed, 111 insertions(+), 82 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index b84903acdb25..7c9689f29fd3 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -8634,7 +8634,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
>>  			fprintf(stderr, "Error adding block group\n");
>>  			return ret;
>>  		}
>> -		btrfs_extent_post_op(trans);
>> +		btrfs_run_delayed_refs(trans, -1);
>>  	}
>>  
>>  	ret = reset_balance(trans, fs_info);
>> @@ -9682,6 +9682,7 @@ int cmd_check(int argc, char **argv)
>>  			goto close_out;
>>  		}
>>  
>> +		trans->reinit_extent_tree = true;
>>  		if (init_extent_tree) {
>>  			printf("Creating a new extent tree\n");
>>  			ret = reinit_extent_tree(trans, info,
>> diff --git a/extent-tree.c b/extent-tree.c
>> index 3208ed11cb91..9d085158f2d8 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -1418,8 +1418,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>  		err = ret;
>>  out:
>>  	btrfs_free_path(path);
>> -	finish_current_insert(trans);
>> -	del_pending_extents(trans);
>>  	BUG_ON(err);
>>  	return err;
>>  }
>> @@ -1602,8 +1600,6 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
>>  	btrfs_set_extent_flags(l, item, flags);
>>  out:
>>  	btrfs_free_path(path);
>> -	finish_current_insert(trans);
>> -	del_pending_extents(trans);
>>  	return ret;
>>  }
>>  
>> @@ -1701,7 +1697,6 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>>  				 struct btrfs_block_group_cache *cache)
>>  {
>>  	int ret;
>> -	int pending_ret;
>>  	struct btrfs_root *extent_root = trans->fs_info->extent_root;
>>  	unsigned long bi;
>>  	struct extent_buffer *leaf;
>> @@ -1717,12 +1712,8 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>>  	btrfs_mark_buffer_dirty(leaf);
>>  	btrfs_release_path(path);
>>  fail:
>> -	finish_current_insert(trans);
>> -	pending_ret = del_pending_extents(trans);
>>  	if (ret)
>>  		return ret;
>> -	if (pending_ret)
>> -		return pending_ret;
>>  	return 0;
>>  
>>  }
>> @@ -2050,6 +2041,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>>  	int skinny_metadata =
>>  		btrfs_fs_incompat(extent_root->fs_info, SKINNY_METADATA);
>>  
>> +
>>  	while(1) {
>>  		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
>>  					    &end, EXTENT_LOCKED);
>> @@ -2081,6 +2073,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>>  			BUG_ON(1);
>>  		}
>>  
>> +
>> +		printf("shouldn't be executed\n");
>>  		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED);
>>  		kfree(extent_op);
>>  	}
>> @@ -2380,7 +2374,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>>  	}
>>  fail:
>>  	btrfs_free_path(path);
>> -	finish_current_insert(trans);
>>  	return ret;
>>  }
>>  
>> @@ -2463,33 +2456,30 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>>  		      u64 bytenr, u64 num_bytes, u64 parent,
>>  		      u64 root_objectid, u64 owner, u64 offset)
>>  {
>> -	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> -	int pending_ret;
>>  	int ret;
>>  
>>  	WARN_ON(num_bytes < root->fs_info->sectorsize);
>> -	if (root == extent_root) {
>> -		struct pending_extent_op *extent_op;
>> -
>> -		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
>> -		BUG_ON(!extent_op);
>> -
>> -		extent_op->type = PENDING_EXTENT_DELETE;
>> -		extent_op->bytenr = bytenr;
>> -		extent_op->num_bytes = num_bytes;
>> -		extent_op->level = (int)owner;
>> -
>> -		set_extent_bits(&root->fs_info->pending_del,
>> -				bytenr, bytenr + num_bytes - 1,
>> -				EXTENT_LOCKED);
>> -		set_state_private(&root->fs_info->pending_del,
>> -				  bytenr, (unsigned long)extent_op);
>> -		return 0;
>> +	/*
>> +	 * tree log blocks never actually go into the extent allocation
>> +	 * tree, just update pinning info and exit early.
>> +	 */
>> +	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
>> +		printf("PINNING EXTENTS IN LOG TREE\n");
>> +		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
>> +		btrfs_pin_extent(trans->fs_info, bytenr, num_bytes);
>> +		ret = 0;
>> +	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>> +		BUG_ON(offset);
>> +		ret = btrfs_add_delayed_tree_ref(trans->fs_info, trans,
>> +						 bytenr, num_bytes, parent,
>> +						 root_objectid, (int)owner,
>> +						 BTRFS_DROP_DELAYED_REF,
>> +						 NULL, NULL, NULL);
>> +	} else {
>> +		ret = __free_extent(trans, bytenr, num_bytes, parent,
>> +				    root_objectid, owner, offset, 1);
>>  	}
>> -	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
>> -			    root_objectid, owner, offset, 1);
>> -	pending_ret = del_pending_extents(trans);
>> -	return ret ? ret : pending_ret;
>> +	return ret;
>>  }
>>  
>>  static u64 stripe_align(struct btrfs_root *root, u64 val)
>> @@ -2695,6 +2685,8 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>>  	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
>>  	struct btrfs_key ins;
>>  	bool skinny_metadata = btrfs_fs_incompat(trans->fs_info, SKINNY_METADATA);
>> +	int ret;
>> +	u64 start, end;
>>  
>>  	ins.objectid = node->bytenr;
>>  	if (skinny_metadata) {
>> @@ -2705,10 +2697,25 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>>  		ins.type = BTRFS_EXTENT_ITEM_KEY;
>>  	}
>>  
>> -	return alloc_reserved_tree_block(trans, ref->root, trans->transid,
>> -					 extent_op->flags_to_set,
>> -					 &extent_op->key, ref->level, &ins);
>> +	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
>> +		ret = find_first_extent_bit(&trans->fs_info->extent_ins,
>> +					    node->bytenr, &start, &end,
>> +					    EXTENT_LOCKED);
>> +		ASSERT(!ret);
>> +		ASSERT(start == node->bytenr);
>> +		ASSERT(end == node->bytenr + node->num_bytes - 1);
>> +	}
>> +
>> +	ret = alloc_reserved_tree_block(trans, ref->root, trans->transid,
>> +					extent_op->flags_to_set,
>> +					&extent_op->key, ref->level, &ins);
>>  
>> +	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
>> +		clear_extent_bits(&trans->fs_info->extent_ins, start, end,
>> +				  EXTENT_LOCKED);
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>> @@ -2773,39 +2780,50 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
>>  			    u64 search_end, struct btrfs_key *ins)
>>  {
>>  	int ret;
>> +	u64 extent_size;
>> +	struct btrfs_delayed_extent_op *extent_op;
>> +	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
>> +						 SKINNY_METADATA);
>> +
>> +	extent_op = btrfs_alloc_delayed_extent_op();
>> +	if (!extent_op)
>> +		return -ENOMEM;
>> +
>>  	ret = btrfs_reserve_extent(trans, root, num_bytes, empty_size,
>>  				   hint_byte, search_end, ins, 0);
>>  	BUG_ON(ret);
>>  
>> +	if (key)
>> +		memcpy(&extent_op->key, key, sizeof(extent_op->key));
>> +	else
>> +		memset(&extent_op->key, 0, sizeof(extent_op->key));
>> +	extent_op->flags_to_set = flags;
>> +	extent_op->update_key = skinny_metadata ? false : true;
>> +	extent_op->update_flags = true;
>> +	extent_op->is_data = false;
>> +	extent_op->level = level;
>> +
>> +	extent_size = ins->offset;
>> +
>> +	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
>> +		ins->offset = level;
>> +		ins->type = BTRFS_METADATA_ITEM_KEY;
>> +	}
>> +
>> +	/* Ensure this reserved extent is not found by the allocator */
>>  	if (root_objectid == BTRFS_EXTENT_TREE_OBJECTID) {
>> -		struct pending_extent_op *extent_op;
>> -
>> -		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
>> -		BUG_ON(!extent_op);
>> -
>> -		extent_op->type = PENDING_EXTENT_INSERT;
>> -		extent_op->bytenr = ins->objectid;
>> -		extent_op->num_bytes = ins->offset;
>> -		extent_op->level = level;
>> -		extent_op->flags = flags;
>> -		memcpy(&extent_op->key, key, sizeof(*key));
>> -
>> -		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
>> -				ins->objectid + ins->offset - 1,
>> -				EXTENT_LOCKED);
>> -		set_state_private(&root->fs_info->extent_ins,
>> -				  ins->objectid, (unsigned long)extent_op);
>> -	} else {
>> -		if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
>> -			ins->offset = level;
>> -			ins->type = BTRFS_METADATA_ITEM_KEY;
>> -		}
>> -		ret = alloc_reserved_tree_block(trans, root, root_objectid,
>> -						generation, flags,
>> -						key, level, ins);
>> -		finish_current_insert(trans);
>> -		del_pending_extents(trans);
>> +		ret = set_extent_bits(&trans->fs_info->extent_ins,
>> +				      ins->objectid,
>> +				      ins->objectid + extent_size - 1,
>> +				      EXTENT_LOCKED);
>> +
>> +		BUG_ON(ret);
>>  	}
>> +
>> +	ret = btrfs_add_delayed_tree_ref(root->fs_info, trans, ins->objectid,
>> +					 extent_size, 0, root_objectid,
>> +					 level, BTRFS_ADD_DELAYED_EXTENT,
>> +					 extent_op, NULL, NULL);
>>  	return ret;
>>  }
>>  
>> @@ -3330,11 +3348,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>>  				sizeof(cache->item));
>>  	BUG_ON(ret);
>>  
>> -	ret = finish_current_insert(trans);
>> -	BUG_ON(ret);
>> -	ret = del_pending_extents(trans);
>> -	BUG_ON(ret);
>> -
>>  	return 0;
>>  }
>>  
>> @@ -3430,10 +3443,6 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
>>  					sizeof(cache->item));
>>  		BUG_ON(ret);
>>  
>> -		finish_current_insert(trans);
>> -		ret = del_pending_extents(trans);
>> -		BUG_ON(ret);
>> -
>>  		cur_start = cache->key.objectid + cache->key.offset;
>>  	}
>>  	return 0;
>> @@ -3815,14 +3824,9 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
>>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>>  	struct btrfs_root *root = fs_info->extent_root;
>>  
>> -	while(extent_root_pending_ops(fs_info)) {
>> -		ret = finish_current_insert(trans);
>> -		if (ret)
>> -			return ret;
>> -		ret = del_pending_extents(trans);
>> -		if (ret)
>> -			return ret;
>> -	}
>> +	ret = btrfs_run_delayed_refs(trans, -1);
>> +	if (ret)
>> +		return ret;
>>  
>>  	while(1) {
>>  		cache = btrfs_lookup_first_block_group(fs_info, start);
>> @@ -4027,7 +4031,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>>  		} else if (ret != -EEXIST) {
>>  			goto fail;
>>  		}
>> -		btrfs_extent_post_op(trans);
>> +		btrfs_run_delayed_refs(trans, -1);
>>  		extent_bytenr = disk_bytenr;
>>  		extent_num_bytes = num_bytes;
>>  		extent_offset = 0;
>> diff --git a/transaction.c b/transaction.c
>> index ecafbb156610..b2d613ee88d0 100644
>> --- a/transaction.c
>> +++ b/transaction.c
>> @@ -98,6 +98,17 @@ int commit_tree_roots(struct btrfs_trans_handle *trans,
>>  	if (ret)
>>  		return ret;
>>  
>> +	/*
>> +	 * If the above CoW is the first one to dirty the current tree_root,
>> +	 * delayed refs for it won't be run until after this function has
>> +	 * finished executing, meaning we won't process the extent tree root,
>> +	 * which will have been added to ->dirty_cowonly_roots.  So run
>> +	 * delayed refs here as well.
>> +	 */
>> +	ret = btrfs_run_delayed_refs(trans, -1);
>> +	if (ret)
>> +		return ret;
>> +
>>  	while(!list_empty(&fs_info->dirty_cowonly_roots)) {
>>  		next = fs_info->dirty_cowonly_roots.next;
>>  		list_del_init(next);
>> @@ -147,6 +158,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  
>>  	if (trans->fs_info->transaction_aborted)
>>  		return -EROFS;
>> +	/*
>> +	 * Flush all accumulated delayed refs so that root-tree updates are
>> +	 * consistent
>> +	 */
>> +	ret = btrfs_run_delayed_refs(trans, -1);
>> +	BUG_ON(ret);
>>  
>>  	if (root->commit_root == root->node)
>>  		goto commit_tree;
>> @@ -164,9 +181,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  	ret = btrfs_update_root(trans, root->fs_info->tree_root,
>>  				&root->root_key, &root->root_item);
>>  	BUG_ON(ret);
>> +
>>  commit_tree:
>>  	ret = commit_tree_roots(trans, fs_info);
>>  	BUG_ON(ret);
>> +	/*
>> +	 * Ensure that all comitted roots are properly accounted in the
>> +	 * extent tree
>> +	 */
>> +	ret = btrfs_run_delayed_refs(trans, -1);
>> +	BUG_ON(ret);
> 
> Is "btrfs_write_dirty_block_groups(trans, root);" needed here
> since above run_delayed_refs() may update block_group_cache?

Yes, it is indeed. At the moment the delayed refs support
freeing/allocating metadata blocks. So when running delayed refs we can
modify the in-memory state of the block groups with the following call
chain (in the alloc case, freeing is analogical):

run_delayed_refs
  alloc_reserved_tree_block
   update_block_group  <-- used space of block groups is modified.

So block groups state needs to be written after the final delayed ref is
run. As a matter of fact I think btrfs_write_dirty_block_groups should
really be called once in btrfs_commit_transaction, i.e the calls in
update_cowonly_roots could be lifted in either btrfs_commit_transaction
or in __commit_transaction.

I will consider this when sending v2 and also running this test to
ensure we don't regress.

Thank you for the review.

> 
> [long explanation] 
> 
> I observed fsck-tests/020 fails with low-mem mode in current devel branch.
> i.e.
> 
>   $ make test-fsck TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem TEST=020\*
> 
> fails and log indicates mismatch of used value in block group item:
> 
> =====
> <snip>
>   [2/7] checking extents   
>   ERROR: block group[4194304 8388608] used 20480 but extent items used 24576
>   ERROR: block group[20971520 16777216] used 659456 but extent items used 655360
> <snip>
> =====
> 
> I found that before this commit it works fine. 
> It turned out that "btrfs-image -r" actually causes the problem as it modifies
> DEV_ITEM in fixup_devices() and commits transaction, which misses to write
> block group cache before __commit_transaction() for
> tests/fsck-tests/020-extent/ref-cases/keyed_data_ref_with_shared_leaf.img.
> 
> (Used value check of block group item only exists in low-mem mode and therefore
> original mode does not complain.)
> 
> With "btrfs_write_dirty_block_groups()" I don't see any failure with both original
> and low-mem mode (in all fsck tests).
> 
> Thanks,
> Misono
> 
>>  	ret = __commit_transaction(trans, root);
>>  	BUG_ON(ret);
>>  	write_ctree_super(trans);
>>
> 
> 
