Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbeBWLAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 06:00:31 -0500
Subject: Re: [PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per
 inode qgroup rsv
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Jeff Mahoney <jeffm@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171222061847.13158-1-wqu@suse.com>
 <20171222061847.13158-11-wqu@suse.com>
 <bab66d63-620e-1ffd-cd24-6c1a81dab402@suse.com>
 <d8e5c4c8-1c20-6cfb-c34d-59fc8b857264@gmx.com>
 <23c9039f-b574-b7f1-b954-ebb48dea8740@suse.com>
 <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <72620a92-ef6a-05af-1dc3-e9fee55e10d7@suse.com>
Date: Fri, 23 Feb 2018 13:00:27 +0200
MIME-Version: 1.0
In-Reply-To: <50dcc8d5-706b-dc75-5346-3d9e85f3819a@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.02.2018 11:06, Qu Wenruo wrote:
> 
> 
> On 2018年02月23日 16:14, Nikolay Borisov wrote:
>>
>>
>> On 23.02.2018 01:34, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年02月23日 06:44, Jeff Mahoney wrote:
>>>> On 12/22/17 1:18 AM, Qu Wenruo wrote:
>>>>> Unlike reservation calculation used in inode rsv for metadata, qgroup
>>>>> doesn't really need to care things like csum size or extent usage for
>>>>> whole tree COW.
>>>>>
>>>>> Qgroup care more about net change of extent usage.
>>>>> That's to say, if we're going to insert one file extent, it will mostly
>>>>> find its place in CoWed tree block, leaving no change in extent usage.
>>>>> Or cause leaf split, result one new net extent, increasing qgroup number
>>>>> by nodesize.
>>>>> (Or even more rare case, increase the tree level, increasing qgroup
>>>>> number by 2 * nodesize)
>>>>>
>>>>> So here instead of using the way overkilled calculation for extent
>>>>> allocator, which cares more about accurate and no error, qgroup doesn't
>>>>> need that over-calculated reservation.
>>>>>
>>>>> This patch will maintain 2 new members in btrfs_block_rsv structure for
>>>>> qgroup, using much smaller calculation for qgroup rsv, reducing false
>>>>> EDQUOT.
>>>>
>>>>
>>>> I think this is the right idea but, rather than being the last step in a
>>>> qgroup rework, it should be the first.
>>>
>>> That's right.
>>>
>>> Although putting it as 1st patch needs extra work to co-operate with
>>> later type seperation.
>>>
>>>>  Don't qgroup reservation
>>>> lifetimes match the block reservation lifetimes?
>>>
>>> Also correct, but...
>>>
>>>>  We wouldn't want a
>>>> global reserve and we wouldn't track usage on a per-block basis, but
>>>> they should otherwise match.  We already have clear APIs surrounding the
>>>> use of block reservations, so it seems to me that it'd make sense to
>>>> extend those to cover the qgroup cases as well.  Otherwise, the rest of
>>>> your patchset makes a parallel reservation system with a different API.
>>>> That keeps the current state of qgroups as a bolt-on that always needs
>>>> to be tracked separately (and which developers need to ensure they get
>>>> right).
>>>
>>> The problem is, block reservation is designed to ensure every CoW could
>>> be fulfilled without error.
>>>
>>> That's to say, for case like CoW write with csum, we need to care about
>>> space reservation not only for EXTENT_DATA in fs tree, but also later
>>> EXTENT_ITEM for extent tree, and CSUM_ITEM for csum tree.
>>>
>>> However extent tree and csum tree doesn't contribute to quota at all.
>>> If we follow such over-reservation, it would be much much easier to hit
>>> false EDQUOTA early.
>>>
>>> That's the main reason why a separate (and a little simplified) block
>>> rsv tracking system.
>>>
>>> And if there is better solution, I'm all ears.
>>
>> So looking at the code the main hurdles seems to be the fact that the
>> btrfs_block_rsv_* API's take a raw byte count, which is derived from
>> btrfs_calc_trans_metadata_size, which in turn is passed the number of
>> items we want.
>>
>> So what if we extend the block_rsv_* apis to take an additional
>> 'quota_bytes' or somesuch argument which would represent the amount we
>> would like to be charged to the qgroups. This will force us to revisit
>> every call site of block_rsv API's and adjust the code accordingly so
>> that callers pass the correct number. This will lead to code such as:
>>
>> if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) { blah }
> 
> We don't need to do such check at call site.
> 
> Just do the calculation (which should be really simple, as simple as
> nodesize * nr_items_to_add), and pass it to btrfs_qgroup_reserve_* APIs,
> which would handle the quota enabled check.
> 
>>
>> be contained into the block rsv apis. This will ensure lifetime of
>> blockrsv/qgroups is always consistent. I think this only applies to
>> qgroup metadata reservations.
> 
> Yep, and only applies to PREALLOC type metadata reservation.
> For per-transaction rsv, it's handled by PERTRANS type.

And what about the btrfs_qgroup_reserve_meta()-type reservations, this
function doesn't take a transaction, what kind of reservation is that o_O

To sum it up we have  PERTRANS, PREALLOC and  btrfs_qgroup_reserve_meta
and those are 3 distinct type of reservations, correct?
> 
> Thanks,
> Qu
> 
>>
>>
>>
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> -Jeff
>>>>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>>  fs/btrfs/ctree.h       | 18 +++++++++++++++++
>>>>>  fs/btrfs/extent-tree.c | 55 ++++++++++++++++++++++++++++++++++++++++----------
>>>>>  2 files changed, 62 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>>> index 0c58f92c2d44..97783ba91e00 100644
>>>>> --- a/fs/btrfs/ctree.h
>>>>> +++ b/fs/btrfs/ctree.h
>>>>> @@ -467,6 +467,24 @@ struct btrfs_block_rsv {
>>>>>  	unsigned short full;
>>>>>  	unsigned short type;
>>>>>  	unsigned short failfast;
>>>>> +
>>>>> +	/*
>>>>> +	 * Qgroup equivalent for @size @reserved
>>>>> +	 *
>>>>> +	 * Unlike normal normal @size/@reserved for inode rsv,
>>>>> +	 * qgroup doesn't care about things like csum size nor how many tree
>>>>> +	 * blocks it will need to reserve.
>>>>> +	 *
>>>>> +	 * Qgroup cares more about *NET* change of extent usage.
>>>>> +	 * So for ONE newly inserted file extent, in worst case it will cause
>>>>> +	 * leaf split and level increase, nodesize for each file extent
>>>>> +	 * is already way overkilled.
>>>>> +	 *
>>>>> +	 * In short, qgroup_size/reserved is the up limit of possible needed
>>>>> +	 * qgroup metadata reservation.
>>>>> +	 */
>>>>> +	u64 qgroup_rsv_size;
>>>>> +	u64 qgroup_rsv_reserved;
>>>>>  };
>>>>>  
>>>>>  /*
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index 986660f301de..9d579c7bcf7f 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -5565,14 +5565,18 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
>>>>>  
>>>>>  static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
>>>>>  				    struct btrfs_block_rsv *block_rsv,
>>>>> -				    struct btrfs_block_rsv *dest, u64 num_bytes)
>>>>> +				    struct btrfs_block_rsv *dest, u64 num_bytes,
>>>>> +				    u64 *qgroup_to_release_ret)
>>>>>  {
>>>>>  	struct btrfs_space_info *space_info = block_rsv->space_info;
>>>>> +	u64 qgroup_to_release = 0;
>>>>>  	u64 ret;
>>>>>  
>>>>>  	spin_lock(&block_rsv->lock);
>>>>> -	if (num_bytes == (u64)-1)
>>>>> +	if (num_bytes == (u64)-1) {
>>>>>  		num_bytes = block_rsv->size;
>>>>> +		qgroup_to_release = block_rsv->qgroup_rsv_size;
>>>>> +	}
>>>>>  	block_rsv->size -= num_bytes;
>>>>>  	if (block_rsv->reserved >= block_rsv->size) {
>>>>>  		num_bytes = block_rsv->reserved - block_rsv->size;
>>>>> @@ -5581,6 +5585,12 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
>>>>>  	} else {
>>>>>  		num_bytes = 0;
>>>>>  	}
>>>>> +	if (block_rsv->qgroup_rsv_reserved >= block_rsv->qgroup_rsv_size) {
>>>>> +		qgroup_to_release = block_rsv->qgroup_rsv_reserved -
>>>>> +				    block_rsv->qgroup_rsv_size;
>>>>> +		block_rsv->qgroup_rsv_reserved = block_rsv->qgroup_rsv_size;
>>>>> +	} else
>>>>> +		qgroup_to_release = 0;
>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>  
>>>>>  	ret = num_bytes;
>>>>> @@ -5603,6 +5613,8 @@ static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
>>>>>  			space_info_add_old_bytes(fs_info, space_info,
>>>>>  						 num_bytes);
>>>>>  	}
>>>>> +	if (qgroup_to_release_ret)
>>>>> +		*qgroup_to_release_ret = qgroup_to_release;
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> @@ -5744,17 +5756,21 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>>>>>  	struct btrfs_root *root = inode->root;
>>>>>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
>>>>>  	u64 num_bytes = 0;
>>>>> +	u64 qgroup_num_bytes = 0;
>>>>>  	int ret = -ENOSPC;
>>>>>  
>>>>>  	spin_lock(&block_rsv->lock);
>>>>>  	if (block_rsv->reserved < block_rsv->size)
>>>>>  		num_bytes = block_rsv->size - block_rsv->reserved;
>>>>> +	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
>>>>> +		qgroup_num_bytes = block_rsv->qgroup_rsv_size -
>>>>> +				   block_rsv->qgroup_rsv_reserved;
>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>  
>>>>>  	if (num_bytes == 0)
>>>>>  		return 0;
>>>>>  
>>>>> -	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
>>>>> +	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes, true);
>>>>>  	if (ret)
>>>>>  		return ret;
>>>>>  	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
>>>>> @@ -5762,7 +5778,13 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>>>>>  		block_rsv_add_bytes(block_rsv, num_bytes, 0);
>>>>>  		trace_btrfs_space_reservation(root->fs_info, "delalloc",
>>>>>  					      btrfs_ino(inode), num_bytes, 1);
>>>>> -	}
>>>>> +
>>>>> +		/* Don't forget to increase qgroup_rsv_reserved */
>>>>> +		spin_lock(&block_rsv->lock);
>>>>> +		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
>>>>> +		spin_unlock(&block_rsv->lock);
>>>>> +	} else
>>>>> +		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> @@ -5784,20 +5806,23 @@ void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
>>>>>  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
>>>>>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
>>>>>  	u64 released = 0;
>>>>> +	u64 qgroup_to_release = 0;
>>>>>  
>>>>>  	/*
>>>>>  	 * Since we statically set the block_rsv->size we just want to say we
>>>>>  	 * are releasing 0 bytes, and then we'll just get the reservation over
>>>>>  	 * the size free'd.
>>>>>  	 */
>>>>> -	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0);
>>>>> +	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0,
>>>>> +					   &qgroup_to_release);
>>>>>  	if (released > 0)
>>>>>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>>>>>  					      btrfs_ino(inode), released, 0);
>>>>>  	if (qgroup_free)
>>>>> -		btrfs_qgroup_free_meta_prealloc(inode->root, released);
>>>>> +		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
>>>>>  	else
>>>>> -		btrfs_qgroup_convert_reserved_meta(inode->root, released);
>>>>> +		btrfs_qgroup_convert_reserved_meta(inode->root,
>>>>> +						   qgroup_to_release);
>>>>>  }
>>>>>  
>>>>>  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>>>>> @@ -5809,7 +5834,7 @@ void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>>>>>  	if (global_rsv == block_rsv ||
>>>>>  	    block_rsv->space_info != global_rsv->space_info)
>>>>>  		global_rsv = NULL;
>>>>> -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes);
>>>>> +	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NULL);
>>>>>  }
>>>>>  
>>>>>  static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
>>>>> @@ -5889,7 +5914,7 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
>>>>>  static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
>>>>>  {
>>>>>  	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
>>>>> -				(u64)-1);
>>>>> +				(u64)-1, NULL);
>>>>>  	WARN_ON(fs_info->trans_block_rsv.size > 0);
>>>>>  	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
>>>>>  	WARN_ON(fs_info->chunk_block_rsv.size > 0);
>>>>> @@ -5931,7 +5956,7 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
>>>>>  	WARN_ON_ONCE(!list_empty(&trans->new_bgs));
>>>>>  
>>>>>  	block_rsv_release_bytes(fs_info, &fs_info->chunk_block_rsv, NULL,
>>>>> -				trans->chunk_bytes_reserved);
>>>>> +				trans->chunk_bytes_reserved, NULL);
>>>>>  	trans->chunk_bytes_reserved = 0;
>>>>>  }
>>>>>  
>>>>> @@ -6036,6 +6061,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>>>>>  {
>>>>>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
>>>>>  	u64 reserve_size = 0;
>>>>> +	u64 qgroup_rsv_size = 0;
>>>>>  	u64 csum_leaves;
>>>>>  	unsigned outstanding_extents;
>>>>>  
>>>>> @@ -6048,9 +6074,16 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>>>>>  						 inode->csum_bytes);
>>>>>  	reserve_size += btrfs_calc_trans_metadata_size(fs_info,
>>>>>  						       csum_leaves);
>>>>> +	/*
>>>>> +	 * For qgroup rsv, the calculation is very simple:
>>>>> +	 * nodesize for each outstanding extent.
>>>>> +	 * This is already overkilled under most case.
>>>>> +	 */
>>>>> +	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
>>>>>  
>>>>>  	spin_lock(&block_rsv->lock);
>>>>>  	block_rsv->size = reserve_size;
>>>>> +	block_rsv->qgroup_rsv_size = qgroup_rsv_size;
>>>>>  	spin_unlock(&block_rsv->lock);
>>>>>  }
>>>>>  
>>>>> @@ -8405,7 +8438,7 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
>>>>>  			    struct btrfs_block_rsv *block_rsv, u32 blocksize)
>>>>>  {
>>>>>  	block_rsv_add_bytes(block_rsv, blocksize, 0);
>>>>> -	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0);
>>>>> +	block_rsv_release_bytes(fs_info, block_rsv, NULL, 0, NULL);
>>>>>  }
>>>>>  
>>>>>  /*
>>>>>
>>>>
>>>>
>>>
> 
