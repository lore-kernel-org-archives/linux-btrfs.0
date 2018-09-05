Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbeIEMTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 08:19:36 -0400
Subject: Re: [PATCH 5/8] btrfs-progs: Wire up delayed refs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
 <1534425035-323-6-git-send-email-nborisov@suse.com>
 <811fcfa0-467a-ae61-a8a5-8fd7af1bfd73@gmx.com>
 <cb482805-b04c-3f5b-93fe-4066ab43a1c7@suse.com>
 <16b5bdcf-69c2-46af-00cb-853275c65f0a@gmx.com>
 <8d623310-baed-5384-93f1-3cd2c71c9884@suse.com>
 <b260214c-4c47-9663-a09f-49a94dabd4f5@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c9e419bd-7c43-99f6-d909-dbd606217286@suse.com>
Date: Wed, 5 Sep 2018 10:50:34 +0300
MIME-Version: 1.0
In-Reply-To: <b260214c-4c47-9663-a09f-49a94dabd4f5@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.09.2018 10:46, Qu Wenruo wrote:
> 
> 
> On 2018/9/5 下午3:41, Nikolay Borisov wrote:
>>
>>
>> On  5.09.2018 08:53, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/9/5 下午1:42, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On  5.09.2018 05:10, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2018/8/16 下午9:10, Nikolay Borisov wrote:
>>>>>> This commit enables the delayed refs infrastructures. This entails doing
>>>>>> the following:
>>>>>>
>>>>>> 1. Replacing existing calls of btrfs_extent_post_op (which is the
>>>>>> equivalent of delayed refs) with the proper btrfs_run_delayed_refs.
>>>>>> As well as eliminating open-coded calls to finish_current_insert and
>>>>>> del_pending_extents which execute the delayed ops.
>>>>>>
>>>>>> 2. Wiring up the addition of delayed refs when freeing extents
>>>>>> (btrfs_free_extent) and when adding new extents (alloc_tree_block).
>>>>>>
>>>>>> 3. Adding calls to btrfs_run_delayed refs in the transaction commit
>>>>>> path alongside comments why every call is needed, since it's not always
>>>>>> obvious (those call sites were derived empirically by running and
>>>>>> debugging existing tests)
>>>>>>
>>>>>> 4. Correctly flagging the transaction in which we are reinitialising
>>>>>> the extent tree.
>>>>>>
>>>>>> 5 Moving btrfs_write_dirty_block_groups to btrfs_write_dirty_block_groups
>>>>>> since blockgroups should be written to disk after the last delayed refs
>>>>>> have been run.
>>>>>>
>>>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>>>> Signed-off-by: David Sterba <dsterba@suse.com>
>>>>>
>>>>> Is there something (maybe btrfs_run_delayed_refs()?) missing in btrfs-image?
>>>>>
>>>>> btrfs-image from devel branch can't restore image correctly, the block
>>>>> group used bytes is not correct, thus it can't pass misc nor fsck tests.
>>>>
>>>> This is really strange, all fsck/misc tests passed with those patches.
>>>> Can you be more specific which tests exactly you mean ?
>>>
>>> One case is fsck/020 with lowmem mode. (Original mode lacks block
>>> group->used check).
>>>
>>> More specifically, fsck/020/keyed_data_ref_with_shared_leaf.img
>>>
>>> Using btrfs-image from my distribution (v4.17.1) and devel branch btrfs
>>> check: (cwd is btrfs-progs, devel branch)
>>>
>>> $ btrfs-image -r
>>> tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_shared_leaf.img ~/test.img
>>> $ btrfs check --mode=wmem ~/test.img
>>> Opening filesystem to check...
>>> Checking filesystem on /home/adam/test.img
>>> UUID: 12dabcf2-d4da-4a70-9701-9f3d48074e73
>>> [1/7] checking root items
>>> [2/7] checking extents
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> [5/7] checking only csums items (without verifying data)
>>> [6/7] checking root refs done with fs roots in lowmem mode, skipping
>>> [7/7] checking quota groups skipped (not enabled on this FS)
>>> found 1208320 bytes used, no error found
>>> total csum bytes: 512
>>> total tree bytes: 684032
>>> total fs tree bytes: 638976
>>> total extent tree bytes: 16384
>>> btree space waste bytes: 305606
>>> file data blocks allocated: 93847552
>>>  referenced 1773568
>>>
>>> But if using btrfs-image with your delayed ref patch:
>>> $ ./btrfs-image -r
>>> tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_with_shared_leaf.img ~/test.img
>>>
>>> # No matter if I'm using btrfs-check from devel or 4.17.1
>>> $ btrfs check --mode=wmem ~/test.img
>>> Opening filesystem to check...
>>> Checking filesystem on /home/adam/test.img
>>> UUID: 12dabcf2-d4da-4a70-9701-9f3d48074e73
>>> [1/7] checking root items
>>> [2/7] checking extents
>>> ERROR: block group[4194304 8388608] used 20480 but extent items used 24576
>>> ERROR: block group[20971520 16777216] used 659456 but extent items used
>>> 655360
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> [3/7] checking free space cache
>>> [4/7] checking fs roots
>>> [5/7] checking only csums items (without verifying data)
>>> [6/7] checking root refs done with fs roots in lowmem mode, skipping
>>> [7/7] checking quota groups skipped (not enabled on this FS)
>>> found 1208320 bytes used, error(s) found
>>> total csum bytes: 512
>>> total tree bytes: 684032
>>> total fs tree bytes: 638976
>>> total extent tree bytes: 16384
>>> btree space waste bytes: 305606
>>> file data blocks allocated: 93847552
>>>  referenced 1773568
>>>
>>> I'd say, although lowmem check is still far from perfect, it indeed has
>>> extra checks original mode lacks, and in this case it indeed exposes
>>> problem.
>>
>>
>> I'm not able to reproduce it: 
>>
>> make TEST_ENABLE_OVERRIDE=ue TEST_ARGS_CHECK="--mode=lowmem"  test-fsck
>>     [TEST]   fsck-tests.sh
>>     [TEST/fsck]   001-bad-file-extent-bytenr
>>     [TEST/fsck]   002-bad-transid
>>     [TEST/fsck]   003-shift-offsets
>>     [TEST/fsck]   004-no-dir-index
>>     [TEST/fsck]   005-bad-item-offset
>>     [TEST/fsck]   006-bad-root-items
>>     [TEST/fsck]   007-bad-offset-snapshots
>>     [TEST/fsck]   008-bad-dir-index-name
>>     [TEST/fsck]   009-no-dir-item-or-index
>>     [TEST/fsck]   010-no-rootdir-inode-item
>>     [TEST/fsck]   011-no-inode-item
>>     [TEST/fsck]   012-leaf-corruption
>>     [TEST/fsck]   013-extent-tree-rebuild
>>     [TEST/fsck]   014-no-extent-info
>>     [TEST/fsck]   015-tree-reloc-tree
>>     [TEST/fsck]   016-wrong-inode-nbytes
>>     [TEST/fsck]   017-missing-all-file-extent
>>     [TEST/fsck]   018-leaf-crossing-stripes
>>     [TEST/fsck]   019-non-skinny-false-alert
>>     [TEST/fsck]   020-extent-ref-cases
>>     [TEST/fsck]   021-partially-dropped-snapshot-case
>>     [TEST/fsck]   022-qgroup-rescan-halfway
>>     [TEST/fsck]   023-qgroup-stack-overflow
>>     [TEST/fsck]   024-clear-space-cache
>>     [TEST/fsck]   025-file-extents
>>     [TEST/fsck]   026-bad-dir-item-name
>>     [TEST/fsck]   027-bad-extent-inline-ref-type
>>     [TEST/fsck]   028-unaligned-super-dev-sizes
>>     [TEST/fsck]   029-valid-orphan-item
>>     [TEST/fsck]   030-reflinked-prealloc-extents
>>     [TEST/fsck]   031-metadatadump-check-data-csum
>>     [TEST/fsck]   032-corrupted-qgroup
>>     [TEST/fsck]   032-freespacetree-corrupted-extent-offset
>>     [TEST/fsck]   033-lowmem-collission-dir-items
>>     [TEST/fsck]   034-bad-inode-flags
>>     [TEST/fsck]   035-inline-bad-ram-bytes
>>     [TEST/fsck]   035-rescan-not-kicked-in
>>
>>
>> git bl -9 
>> dac6a0a6f5ca btrfs-progs: Merge alloc_reserved_tree_block(2|) (3 weeks ago) <Nikolay Borisov>
>> da184a3838e6 btrfs-progs: Remove __free_extent2 (3 weeks ago) <Nikolay Borisov>
>> 76b75e40606e btrfs-progs: Remove old delayed refs infrastructure (3 months ago) <Nikolay Borisov>
>> 870c58e08673 btrfs-progs: Wire up delayed refs (3 months ago) <Nikolay Borisov>
>> e045b219e397 btrfs-progs: Make btrfs_write_dirty_block_groups take only trans argument (3 weeks ago) <Nikolay Borisov>
>> 00f8d76c8a27 btrfs-progs: Add delayed refs infrastructure (3 months ago) <Nikolay Borisov>
>> d03f79e8deb6 btrfs-progs: Add alloc_reserved_tree_block2 function (3 months ago) <Nikolay Borisov>
>> d4a4831fffe9 btrfs-progs: Add __free_extent2 function (3 months ago) <Nikolay Borisov>
>> 7faaca0d9f78 Btrfs progs v4.17.1 (4 weeks ago) <David Sterba>
>>
>> Are you sure your branch is not dirty with other changes?
> 
> Oh, I'm using the (maybe out-of-data) David's devel branch.
> 
> For the "Wire up delayed refs" the commit hash is indeed different.
> In that branch it indeed has some difference.
> 
> Is there any branch I could fetch from?


I've just pushed a delayed-refs-v2 branch to :
https://github.com/lorddoskias/btrfs-progs/tree/delayed-refs-v2

> 
> Thanks,
> Qu
> 
>>
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>> ---
>>>>>>  check/main.c  |   3 +-
>>>>>>  extent-tree.c | 166 ++++++++++++++++++++++++++++++----------------------------
>>>>>>  transaction.c |  27 +++++++++-
>>>>>>  3 files changed, 112 insertions(+), 84 deletions(-)
>>>>>>
>>>>>> diff --git a/check/main.c b/check/main.c
>>>>>> index bc2ee22f7943..b361cd7e26a0 100644
>>>>>> --- a/check/main.c
>>>>>> +++ b/check/main.c
>>>>>> @@ -8710,7 +8710,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
>>>>>>  			fprintf(stderr, "Error adding block group\n");
>>>>>>  			return ret;
>>>>>>  		}
>>>>>> -		btrfs_extent_post_op(trans);
>>>>>> +		btrfs_run_delayed_refs(trans, -1);
>>>>>>  	}
>>>>>>  
>>>>>>  	ret =eset_balance(trans, fs_info);
>>>>>> @@ -9767,6 +9767,7 @@ int cmd_check(int argc, char **argv)
>>>>>>  			goto close_out;
>>>>>>  		}
>>>>>>  
>>>>>> +		trans->reinit_extent_tree =rue;
>>>>>>  		if (init_extent_tree) {
>>>>>>  			printf("Creating a new extent tree\n");
>>>>>>  			ret =einit_extent_tree(trans, info,
>>>>>> diff --git a/extent-tree.c b/extent-tree.c
>>>>>> index 7d6c37c6b371..2fa51bbc0359 100644
>>>>>> --- a/extent-tree.c
>>>>>> +++ b/extent-tree.c
>>>>>> @@ -1418,8 +1418,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>>>>>>  		err =et;
>>>>>>  out:
>>>>>>  	btrfs_free_path(path);
>>>>>> -	finish_current_insert(trans);
>>>>>> -	del_pending_extents(trans);
>>>>>>  	BUG_ON(err);
>>>>>>  	return err;
>>>>>>  }
>>>>>> @@ -1602,8 +1600,6 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
>>>>>>  	btrfs_set_extent_flags(l, item, flags);
>>>>>>  out:
>>>>>>  	btrfs_free_path(path);
>>>>>> -	finish_current_insert(trans);
>>>>>> -	del_pending_extents(trans);
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> @@ -1701,7 +1697,6 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>>>>>>  				 struct btrfs_block_group_cache *cache)
>>>>>>  {
>>>>>>  	int ret;
>>>>>> -	int pending_ret;
>>>>>>  	struct btrfs_root *extent_root =rans->fs_info->extent_root;
>>>>>>  	unsigned long bi;
>>>>>>  	struct extent_buffer *leaf;
>>>>>> @@ -1717,12 +1712,8 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>>>>>>  	btrfs_mark_buffer_dirty(leaf);
>>>>>>  	btrfs_release_path(path);
>>>>>>  fail:
>>>>>> -	finish_current_insert(trans);
>>>>>> -	pending_ret =el_pending_extents(trans);
>>>>>>  	if (ret)
>>>>>>  		return ret;
>>>>>> -	if (pending_ret)
>>>>>> -		return pending_ret;
>>>>>>  	return 0;
>>>>>>  
>>>>>>  }
>>>>>> @@ -2049,6 +2040,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>>>>>>  	int skinny_metadata >>>>  		btrfs_fs_incompat(extent_root->fs_info, SKINNY_METADATA);
>>>>>>  
>>>>>> +
>>>>>>  	while(1) {
>>>>>>  		ret =ind_first_extent_bit(&info->extent_ins, 0, &start,
>>>>>>  					    &end, EXTENT_LOCKED);
>>>>>> @@ -2080,6 +2072,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>>>>>>  			BUG_ON(1);
>>>>>>  		}
>>>>>>  
>>>>>> +
>>>>>> +		printf("shouldn't be executed\n");
>>>>>>  		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED);
>>>>>>  		kfree(extent_op);
>>>>>>  	}
>>>>>> @@ -2379,7 +2373,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>>>>>>  	}
>>>>>>  fail:
>>>>>>  	btrfs_free_path(path);
>>>>>> -	finish_current_insert(trans);
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> @@ -2462,33 +2455,30 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>>>>>>  		      u64 bytenr, u64 num_bytes, u64 parent,
>>>>>>  		      u64 root_objectid, u64 owner, u64 offset)
>>>>>>  {
>>>>>> -	struct btrfs_root *extent_root =oot->fs_info->extent_root;
>>>>>> -	int pending_ret;
>>>>>>  	int ret;
>>>>>>  
>>>>>>  	WARN_ON(num_bytes < root->fs_info->sectorsize);
>>>>>> -	if (root =extent_root) {
>>>>>> -		struct pending_extent_op *extent_op;
>>>>>> -
>>>>>> -		extent_op =malloc(sizeof(*extent_op), GFP_NOFS);
>>>>>> -		BUG_ON(!extent_op);
>>>>>> -
>>>>>> -		extent_op->type =ENDING_EXTENT_DELETE;
>>>>>> -		extent_op->bytenr =ytenr;
>>>>>> -		extent_op->num_bytes =um_bytes;
>>>>>> -		extent_op->level =int)owner;
>>>>>> -
>>>>>> -		set_extent_bits(&root->fs_info->pending_del,
>>>>>> -				bytenr, bytenr + num_bytes - 1,
>>>>>> -				EXTENT_LOCKED);
>>>>>> -		set_state_private(&root->fs_info->pending_del,
>>>>>> -				  bytenr, (unsigned long)extent_op);
>>>>>> -		return 0;
>>>>>> +	/*
>>>>>> +	 * tree log blocks never actually go into the extent allocation
>>>>>> +	 * tree, just update pinning info and exit early.
>>>>>> +	 */
>>>>>> +	if (root_objectid =BTRFS_TREE_LOG_OBJECTID) {
>>>>>> +		printf("PINNING EXTENTS IN LOG TREE\n");
>>>>>> +		WARN_ON(owner >=TRFS_FIRST_FREE_OBJECTID);
>>>>>> +		btrfs_pin_extent(trans->fs_info, bytenr, num_bytes);
>>>>>> +		ret =;
>>>>>> +	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>>>>>> +		BUG_ON(offset);
>>>>>> +		ret =trfs_add_delayed_tree_ref(trans->fs_info, trans,
>>>>>> +						 bytenr, num_bytes, parent,
>>>>>> +						 root_objectid, (int)owner,
>>>>>> +						 BTRFS_DROP_DELAYED_REF,
>>>>>> +						 NULL, NULL, NULL);
>>>>>> +	} else {
>>>>>> +		ret =_free_extent(trans, bytenr, num_bytes, parent,
>>>>>> +				    root_objectid, owner, offset, 1);
>>>>>>  	}
>>>>>> -	ret =_free_extent(trans, bytenr, num_bytes, parent,
>>>>>> -			    root_objectid, owner, offset, 1);
>>>>>> -	pending_ret =el_pending_extents(trans);
>>>>>> -	return ret ? ret : pending_ret;
>>>>>> +	return ret;
>>>>>>  }
>>>>>>  
>>>>>>  static u64 stripe_align(struct btrfs_root *root, u64 val)
>>>>>> @@ -2694,6 +2684,8 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>>>>>>  	struct btrfs_delayed_tree_ref *ref =trfs_delayed_node_to_tree_ref(node);
>>>>>>  	struct btrfs_key ins;
>>>>>>  	bool skinny_metadata =trfs_fs_incompat(trans->fs_info, SKINNY_METADATA);
>>>>>> +	int ret;
>>>>>> +	u64 start, end;
>>>>>>  
>>>>>>  	ins.objectid =ode->bytenr;
>>>>>>  	if (skinny_metadata) {
>>>>>> @@ -2704,10 +2696,25 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>>>>>>  		ins.type =TRFS_EXTENT_ITEM_KEY;
>>>>>>  	}
>>>>>>  
>>>>>> -	return alloc_reserved_tree_block(trans, ref->root, trans->transid,
>>>>>> -					 extent_op->flags_to_set,
>>>>>> -					 &extent_op->key, ref->level, &ins);
>>>>>> +	if (ref->root =BTRFS_EXTENT_TREE_OBJECTID) {
>>>>>> +		ret =ind_first_extent_bit(&trans->fs_info->extent_ins,
>>>>>> +					    node->bytenr, &start, &end,
>>>>>> +					    EXTENT_LOCKED);
>>>>>> +		ASSERT(!ret);
>>>>>> +		ASSERT(start =node->bytenr);
>>>>>> +		ASSERT(end =node->bytenr + node->num_bytes - 1);
>>>>>> +	}
>>>>>> +
>>>>>> +	ret =lloc_reserved_tree_block(trans, ref->root, trans->transid,
>>>>>> +					extent_op->flags_to_set,
>>>>>> +					&extent_op->key, ref->level, &ins);
>>>>>>  
>>>>>> +	if (ref->root =BTRFS_EXTENT_TREE_OBJECTID) {
>>>>>> +		clear_extent_bits(&trans->fs_info->extent_ins, start, end,
>>>>>> +				  EXTENT_LOCKED);
>>>>>> +	}
>>>>>> +
>>>>>> +	return ret;
>>>>>>  }
>>>>>>  
>>>>>>  static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>>>>>> @@ -2772,39 +2779,50 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
>>>>>>  			    u64 search_end, struct btrfs_key *ins)
>>>>>>  {
>>>>>>  	int ret;
>>>>>> +	u64 extent_size;
>>>>>> +	struct btrfs_delayed_extent_op *extent_op;
>>>>>> +	bool skinny_metadata =trfs_fs_incompat(root->fs_info,
>>>>>> +						 SKINNY_METADATA);
>>>>>> +
>>>>>> +	extent_op =trfs_alloc_delayed_extent_op();
>>>>>> +	if (!extent_op)
>>>>>> +		return -ENOMEM;
>>>>>> +
>>>>>>  	ret =trfs_reserve_extent(trans, root, num_bytes, empty_size,
>>>>>>  				   hint_byte, search_end, ins, 0);
>>>>>>  	BUG_ON(ret);
>>>>>>  
>>>>>> +	if (key)
>>>>>> +		memcpy(&extent_op->key, key, sizeof(extent_op->key));
>>>>>> +	else
>>>>>> +		memset(&extent_op->key, 0, sizeof(extent_op->key));
>>>>>> +	extent_op->flags_to_set =lags;
>>>>>> +	extent_op->update_key =kinny_metadata ? false : true;
>>>>>> +	extent_op->update_flags =rue;
>>>>>> +	extent_op->is_data =alse;
>>>>>> +	extent_op->level =evel;
>>>>>> +
>>>>>> +	extent_size =ns->offset;
>>>>>> +
>>>>>> +	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
>>>>>> +		ins->offset =evel;
>>>>>> +		ins->type =TRFS_METADATA_ITEM_KEY;
>>>>>> +	}
>>>>>> +
>>>>>> +	/* Ensure this reserved extent is not found by the allocator */
>>>>>>  	if (root_objectid =BTRFS_EXTENT_TREE_OBJECTID) {
>>>>>> -		struct pending_extent_op *extent_op;
>>>>>> -
>>>>>> -		extent_op =malloc(sizeof(*extent_op), GFP_NOFS);
>>>>>> -		BUG_ON(!extent_op);
>>>>>> -
>>>>>> -		extent_op->type =ENDING_EXTENT_INSERT;
>>>>>> -		extent_op->bytenr =ns->objectid;
>>>>>> -		extent_op->num_bytes =ns->offset;
>>>>>> -		extent_op->level =evel;
>>>>>> -		extent_op->flags =lags;
>>>>>> -		memcpy(&extent_op->key, key, sizeof(*key));
>>>>>> -
>>>>>> -		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
>>>>>> -				ins->objectid + ins->offset - 1,
>>>>>> -				EXTENT_LOCKED);
>>>>>> -		set_state_private(&root->fs_info->extent_ins,
>>>>>> -				  ins->objectid, (unsigned long)extent_op);
>>>>>> -	} else {
>>>>>> -		if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
>>>>>> -			ins->offset =evel;
>>>>>> -			ins->type =TRFS_METADATA_ITEM_KEY;
>>>>>> -		}
>>>>>> -		ret =lloc_reserved_tree_block(trans, root_objectid,
>>>>>> -						generation, flags,
>>>>>> -						key, level, ins);
>>>>>> -		finish_current_insert(trans);
>>>>>> -		del_pending_extents(trans);
>>>>>> +		ret =et_extent_bits(&trans->fs_info->extent_ins,
>>>>>> +				      ins->objectid,
>>>>>> +				      ins->objectid + extent_size - 1,
>>>>>> +				      EXTENT_LOCKED);
>>>>>> +
>>>>>> +		BUG_ON(ret);
>>>>>>  	}
>>>>>> +
>>>>>> +	ret =trfs_add_delayed_tree_ref(root->fs_info, trans, ins->objectid,
>>>>>> +					 extent_size, 0, root_objectid,
>>>>>> +					 level, BTRFS_ADD_DELAYED_EXTENT,
>>>>>> +					 extent_op, NULL, NULL);
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> @@ -3329,11 +3347,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>>>>>>  				sizeof(cache->item));
>>>>>>  	BUG_ON(ret);
>>>>>>  
>>>>>> -	ret =inish_current_insert(trans);
>>>>>> -	BUG_ON(ret);
>>>>>> -	ret =el_pending_extents(trans);
>>>>>> -	BUG_ON(ret);
>>>>>> -
>>>>>>  	return 0;
>>>>>>  }
>>>>>>  
>>>>>> @@ -3429,10 +3442,6 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
>>>>>>  					sizeof(cache->item));
>>>>>>  		BUG_ON(ret);
>>>>>>  
>>>>>> -		finish_current_insert(trans);
>>>>>> -		ret =el_pending_extents(trans);
>>>>>> -		BUG_ON(ret);
>>>>>> -
>>>>>>  		cur_start =ache->key.objectid + cache->key.offset;
>>>>>>  	}
>>>>>>  	return 0;
>>>>>> @@ -3814,14 +3823,9 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
>>>>>>  	struct btrfs_fs_info *fs_info =rans->fs_info;
>>>>>>  	struct btrfs_root *root =s_info->extent_root;
>>>>>>  
>>>>>> -	while(extent_root_pending_ops(fs_info)) {
>>>>>> -		ret =inish_current_insert(trans);
>>>>>> -		if (ret)
>>>>>> -			return ret;
>>>>>> -		ret =el_pending_extents(trans);
>>>>>> -		if (ret)
>>>>>> -			return ret;
>>>>>> -	}
>>>>>> +	ret =trfs_run_delayed_refs(trans, -1);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>>  
>>>>>>  	while(1) {
>>>>>>  		cache =trfs_lookup_first_block_group(fs_info, start);
>>>>>> @@ -4026,7 +4030,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>>>>>>  		} else if (ret !=EEXIST) {
>>>>>>  			goto fail;
>>>>>>  		}
>>>>>> -		btrfs_extent_post_op(trans);
>>>>>> +		btrfs_run_delayed_refs(trans, -1);
>>>>>>  		extent_bytenr =isk_bytenr;
>>>>>>  		extent_num_bytes =um_bytes;
>>>>>>  		extent_offset =;
>>>>>> diff --git a/transaction.c b/transaction.c
>>>>>> index 96d9891b0d1c..bfda769210ee 100644
>>>>>> --- a/transaction.c
>>>>>> +++ b/transaction.c
>>>>>> @@ -61,7 +61,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>>>>>>  	u64 old_root_bytenr;
>>>>>>  	struct btrfs_root *tree_root =oot->fs_info->tree_root;
>>>>>>  
>>>>>> -	btrfs_write_dirty_block_groups(trans);
>>>>>>  	while(1) {
>>>>>>  		old_root_bytenr =trfs_root_bytenr(&root->root_item);
>>>>>>  		if (old_root_bytenr =root->node->start)
>>>>>> @@ -98,6 +97,17 @@ int commit_tree_roots(struct btrfs_trans_handle *trans,
>>>>>>  	if (ret)
>>>>>>  		return ret;
>>>>>>  
>>>>>> +	/*
>>>>>> +	 * If the above CoW is the first one to dirty the current tree_root,
>>>>>> +	 * delayed refs for it won't be run until after this function has
>>>>>> +	 * finished executing, meaning we won't process the extent tree root,
>>>>>> +	 * which will have been added to ->dirty_cowonly_roots.  So run
>>>>>> +	 * delayed refs here as well.
>>>>>> +	 */
>>>>>> +	ret =trfs_run_delayed_refs(trans, -1);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>> +
>>>>>>  	while(!list_empty(&fs_info->dirty_cowonly_roots)) {
>>>>>>  		next =s_info->dirty_cowonly_roots.next;
>>>>>>  		list_del_init(next);
>>>>>> @@ -147,6 +157,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>>>>>  
>>>>>>  	if (trans->fs_info->transaction_aborted)
>>>>>>  		return -EROFS;
>>>>>> +	/*
>>>>>> +	 * Flush all accumulated delayed refs so that root-tree updates are
>>>>>> +	 * consistent
>>>>>> +	 */
>>>>>> +	ret =trfs_run_delayed_refs(trans, -1);
>>>>>> +	BUG_ON(ret);
>>>>>>  
>>>>>>  	if (root->commit_root =root->node)
>>>>>>  		goto commit_tree;
>>>>>> @@ -164,11 +180,18 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>>>>>  	ret =trfs_update_root(trans, root->fs_info->tree_root,
>>>>>>  				&root->root_key, &root->root_item);
>>>>>>  	BUG_ON(ret);
>>>>>> +
>>>>>>  commit_tree:
>>>>>>  	ret =ommit_tree_roots(trans, fs_info);
>>>>>>  	BUG_ON(ret);
>>>>>> -	ret =_commit_transaction(trans, root);
>>>>>> +	/*
>>>>>> +	 * Ensure that all comitted roots are properly accounted in the
>>>>>> +	 * extent tree
>>>>>> +	 */
>>>>>> +	ret =trfs_run_delayed_refs(trans, -1);
>>>>>>  	BUG_ON(ret);
>>>>>> +	btrfs_write_dirty_block_groups(trans);
>>>>>> +	__commit_transaction(trans, root);
>>>>>>  	write_ctree_super(trans);
>>>>>>  	btrfs_finish_extent_commit(trans, fs_info->extent_root,
>>>>>>  			           &fs_info->pinned_extents);
>>>>>>
>>>>>
>>>
> 
