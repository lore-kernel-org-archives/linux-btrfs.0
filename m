Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25689 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751836AbcHHAjL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Aug 2016 20:39:11 -0400
Subject: Re: [PATCH v2 1/3] btrfs: qgroup: Refactor
 btrfs_qgroup_insert_dirty_extent()
To: Goldwyn Rodrigues <rgoldwyn@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20160805022923.6170-1-quwenruo@cn.fujitsu.com>
 <20160805022923.6170-2-quwenruo@cn.fujitsu.com>
 <e3bae83d-bb48-48ef-4614-963b7119c4e4@suse.com>
CC: Mark Fasheh <mfasheh@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <25363e5c-3f2b-2364-5ad4-3f87c3c9af61@cn.fujitsu.com>
Date: Mon, 8 Aug 2016 08:39:01 +0800
MIME-Version: 1.0
In-Reply-To: <e3bae83d-bb48-48ef-4614-963b7119c4e4@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/07/2016 01:19 AM, Goldwyn Rodrigues wrote:
> Thanks Qu,
>
> This patch set fixes all the reported problems. However, I have some
> minor issues with coding style.
>

Thanks for the test.

>
> On 08/04/2016 09:29 PM, Qu Wenruo wrote:
>> Refactor btrfs_qgroup_insert_dirty_extent() function, to two functions:
>> 1. _btrfs_qgroup_insert_dirty_extent()
>>    Almost the same with original code.
>>    For delayed_ref usage, which has delayed refs locked.
>>
>>    Change the return value type to int, since caller never needs the
>>    pointer, but only needs to know if they need to free the allocated
>>    memory.
>>
>> 2. btrfs_qgroup_record_dirty_extent()
>>    The more encapsulated version.
>>
>>    Will do the delayed_refs lock, memory allocation, quota enabled check
>>    and other misc things.
>>
>> The original design is to keep exported functions to minimal, but since
>> more btrfs hacks exposed, like replacing path in balance, needs us to
>> record dirty extents manually, so we have to add such functions.
>>
>> Also, add comment for both functions, to info developers how to keep
>> qgroup correct when doing hacks.
>>
>> Cc: Mark Fasheh <mfasheh@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/delayed-ref.c |  5 +----
>>  fs/btrfs/extent-tree.c | 36 +++++-------------------------------
>>  fs/btrfs/qgroup.c      | 39 ++++++++++++++++++++++++++++++++++-----
>>  fs/btrfs/qgroup.h      | 44 +++++++++++++++++++++++++++++++++++++++++---
>>  4 files changed, 81 insertions(+), 43 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 430b368..5eed597 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -541,7 +541,6 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>  	struct btrfs_delayed_ref_head *existing;
>>  	struct btrfs_delayed_ref_head *head_ref = NULL;
>>  	struct btrfs_delayed_ref_root *delayed_refs;
>> -	struct btrfs_qgroup_extent_record *qexisting;
>>  	int count_mod = 1;
>>  	int must_insert_reserved = 0;
>>
>> @@ -606,9 +605,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>  		qrecord->num_bytes = num_bytes;
>>  		qrecord->old_roots = NULL;
>>
>> -		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
>> -							     qrecord);
>> -		if (qexisting)
>> +		if(_btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
>>  			kfree(qrecord);
>>  	}
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9fcb8c9..47c85ff 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8519,34 +8519,6 @@ reada:
>>  	wc->reada_slot = slot;
>>  }
>>
>> -/*
>> - * These may not be seen by the usual inc/dec ref code so we have to
>> - * add them here.
>> - */
>> -static int record_one_subtree_extent(struct btrfs_trans_handle *trans,
>> -				     struct btrfs_root *root, u64 bytenr,
>> -				     u64 num_bytes)
>> -{
>> -	struct btrfs_qgroup_extent_record *qrecord;
>> -	struct btrfs_delayed_ref_root *delayed_refs;
>> -
>> -	qrecord = kmalloc(sizeof(*qrecord), GFP_NOFS);
>> -	if (!qrecord)
>> -		return -ENOMEM;
>> -
>> -	qrecord->bytenr = bytenr;
>> -	qrecord->num_bytes = num_bytes;
>> -	qrecord->old_roots = NULL;
>> -
>> -	delayed_refs = &trans->transaction->delayed_refs;
>> -	spin_lock(&delayed_refs->lock);
>> -	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
>> -		kfree(qrecord);
>> -	spin_unlock(&delayed_refs->lock);
>> -
>> -	return 0;
>> -}
>> -
>>  static int account_leaf_items(struct btrfs_trans_handle *trans,
>>  			      struct btrfs_root *root,
>>  			      struct extent_buffer *eb)
>> @@ -8580,7 +8552,8 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
>>
>>  		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
>>
>> -		ret = record_one_subtree_extent(trans, root, bytenr, num_bytes);
>> +		ret = btrfs_qgroup_record_dirty_extent(trans, root->fs_info,
>> +				bytenr, num_bytes, GFP_NOFS);
>>  		if (ret)
>>  			return ret;
>>  	}
>> @@ -8729,8 +8702,9 @@ walk_down:
>>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>  			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
>>
>> -			ret = record_one_subtree_extent(trans, root, child_bytenr,
>> -							root->nodesize);
>> +			ret = btrfs_qgroup_record_dirty_extent(trans,
>> +					root->fs_info, child_bytenr,
>> +					root->nodesize, GFP_NOFS);
>>  			if (ret)
>>  				goto out;
>>  		}
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 9d4c05b..76d4f67 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1453,9 +1453,9 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>>  	return ret;
>>  }
>>
>> -struct btrfs_qgroup_extent_record
>> -*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
>> -				  struct btrfs_qgroup_extent_record *record)
>> +int _btrfs_qgroup_insert_dirty_extent(
>> +		struct btrfs_delayed_ref_root *delayed_refs,
>> +		struct btrfs_qgroup_extent_record *record)
>
> Why do you rename the function preceding with an underscore? just leave
> it as it is.

Because these two functions have different usage.

the underscore one are used when caller has already acquired needed 
lock, which is used by delayed-refs code.

And the one without underscore is for other usage.

Despite the lock, these two functions are all the same.

So I prefer to use underscore.

>
>>  {
>>  	struct rb_node **p = &delayed_refs->dirty_extent_root.rb_node;
>>  	struct rb_node *parent_node = NULL;
>> @@ -1474,12 +1474,41 @@ struct btrfs_qgroup_extent_record
>>  		else if (bytenr > entry->bytenr)
>>  			p = &(*p)->rb_right;
>>  		else
>> -			return entry;
>> +			return 1;
>
> return -EALREADY?

Since the existing case is quite common, I prefer to use >=0 return 
value, other than minus return value which is more common for error case.

Thanks,
Qu

>
>>  	}
>>
>>  	rb_link_node(&record->node, parent_node, p);
>>  	rb_insert_color(&record->node, &delayed_refs->dirty_extent_root);
>> -	return NULL;
>> +	return 0;
>> +}
>> +
>> +int btrfs_qgroup_record_dirty_extent(struct btrfs_trans_handle *trans,
>> +		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>> +		gfp_t gfp_flag)
>> +{
>> +	struct btrfs_qgroup_extent_record *record;
>> +	struct btrfs_delayed_ref_root *delayed_refs;
>> +	int ret;
>> +
>> +	if (!fs_info->quota_enabled || bytenr == 0 || num_bytes == 0)
>> +		return 0;
>> +	if (WARN_ON(trans == NULL))
>> +		return -EINVAL;
>> +	record = kmalloc(sizeof(*record), gfp_flag);
>> +	if (!record)
>> +		return -ENOMEM;
>> +
>> +	delayed_refs = &trans->transaction->delayed_refs;
>> +	record->bytenr = bytenr;
>> +	record->num_bytes = num_bytes;
>> +	record->old_roots = NULL;
>> +
>> +	spin_lock(&delayed_refs->lock);
>> +	ret = _btrfs_qgroup_insert_dirty_extent(delayed_refs, record);
>> +	spin_unlock(&delayed_refs->lock);
>> +	if (ret > 0)
>> +		kfree(record);
>> +	return 0;
>>  }
>>
>>  #define UPDATE_NEW	0
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index ecb2c14..f6691e3 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -63,9 +63,47 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
>>  struct btrfs_delayed_extent_op;
>>  int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>>  					 struct btrfs_fs_info *fs_info);
>> -struct btrfs_qgroup_extent_record
>> -*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
>> -				  struct btrfs_qgroup_extent_record *record);
>> +
>> +/*
>> + * Insert one dirty extent record into delayed_refs for qgroup.
>> + * Caller must ensure the delayed_refs are already locked and quota is enabled.
>> + *
>> + * Return 0 if there is no existing dirty extent record for that bytenr, and
>> + * insert that record into delayed_refs.
>> + * Return > 0 if there is already existing dirty extent record for that bytenr.
>> + * Caller then can free the record structure.
>> + * Error is not possible
>
> You can remove this if you intend to return EALREADY.
>
>> + *
>> + * For caller needs better encapsulated interface, call
>> + * btrfs_qgroup_record_dirty_extent(), which will handle locks and memory
>> + * allocation.
>> + */
>> +int _btrfs_qgroup_insert_dirty_extent(
>> +		struct btrfs_delayed_ref_root *delayed_refs,
>> +		struct btrfs_qgroup_extent_record *record);
>> +
>> +/*
>> + * Info qgroup to track one extent, so at trans commit time qgroup can
>> + * update qgroup accounts for that extent.
>> + *
>> + * That extent can be either meta or data.
>> + * This function can be called several times for any extent and won't cause
>> + * any qgroup incorrectness.
>> + * As long as dirty extent is recorded, qgroup can hardly go wrong.
>> + *
>> + * This function should be called when owner of extent is changed and the
>> + * code uses hack to avoid normal inc/dev_extent_ref().
>> + * For example, swapping two tree blocks in balance or modifying file extent
>> + * disk bytenr manually.
>> + *
>> + * Return 0 if the operation is done.
>> + * Return <0 for error, like memory allocation failure or invalid parameter
>> + * (NULL trans)
>> + */
>> +int btrfs_qgroup_record_dirty_extent(struct btrfs_trans_handle *trans,
>> +		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>> +		gfp_t gfp_flag);
>> +
>>  int
>>  btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
>>  			    struct btrfs_fs_info *fs_info,
>>
>


