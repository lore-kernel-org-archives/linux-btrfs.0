Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59024 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab2FYM7A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 08:59:00 -0400
Message-ID: <4FE8607E.7010609@fusionio.com>
Date: Mon, 25 Jun 2012 08:58:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: flush delayed inodes if we're short on space V2
References: <1340378761-8705-1-git-send-email-jbacik@fusionio.com> <4FE522C0.2010802@cn.fujitsu.com>
In-Reply-To: <4FE522C0.2010802@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2012 09:58 PM, Miao Xie wrote:
> On fri, 22 Jun 2012 11:26:01 -0400, Josef Bacik wrote:
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4b5a1e1..4053e3e 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3727,6 +3727,62 @@ commit:
>>   	return btrfs_commit_transaction(trans, root);
>>   }
>>
>> +enum flush_state {
>> +	FLUSH_DELALLOC		=	1,
>> +	FLUSH_DELALLOC_WAIT	=	2,
>> +	FLUSH_DELAYED_ITEMS_NR	=	3,
>> +	FLUSH_DELAYED_ITEMS	=	4,
>> +	COMMIT_TRANS		=	5,
>> +};
>> +
>> +static int flush_space(struct btrfs_root *root,
>> +		       struct btrfs_space_info *space_info, u64 num_bytes,
>> +		       u64 orig_bytes, int *state)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	int nr;
>> +	int ret;
>> +
>> +	switch (*state) {
>> +	case FLUSH_DELALLOC:
>> +	case FLUSH_DELALLOC_WAIT:
>> +		ret = shrink_delalloc(root, num_bytes,
>> +				      *state == FLUSH_DELALLOC_WAIT);
>> +		if (ret > 0)
>> +			ret = 0;
>> +		break;
>> +	case FLUSH_DELAYED_ITEMS_NR:
>> +	case FLUSH_DELAYED_ITEMS:
>> +		if (*state == FLUSH_DELAYED_ITEMS_NR) {
>> +			u64 bytes = btrfs_calc_trans_metadata_size(root, 1);
>> +
>> +			nr = (int)div64_u64(num_bytes, bytes);
>> +			if (!nr)
>> +				nr = 1;
>> +			nr *= 2;
>> +		} else {
>> +			nr = -1;
>> +		}
>> +		trans = btrfs_join_transaction(root);
>> +		if (IS_ERR(trans)) {
>> +			ret = PTR_ERR(trans);
>> +			break;
>> +		}
>> +		ret = btrfs_run_delayed_items_nr(trans, root, nr);
>
> why not use btrfs_wq_run_delayed_node() ?

Because I do not want it to be async, I want it to be flushed now and I 
need to be able to control how many we run through, not just 4 or all.

>
>> +		btrfs_end_transaction(trans, root);
>> +		break;
>> +	case COMMIT_TRANS:
>> +		ret = may_commit_transaction(root, space_info, orig_bytes, 0);
>> +		break;
>> +	default:
>> +		ret = -ENOSPC;
>> +		break;
>> +	}
>> +
>> +	if (!ret)
>> +		(*state)++;
>
> It is better that this function just do flush, and do not update state. and the caller
> decides to do the higher level flush or just go back. I think.
>
>> +	return ret;
>> +}
>>   /**
>>    * reserve_metadata_bytes - try to reserve bytes from the block_rsv's space
>>    * @root - the root we're allocating for
>> @@ -3748,11 +3804,10 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
>>   	struct btrfs_space_info *space_info = block_rsv->space_info;
>>   	u64 used;
>>   	u64 num_bytes = orig_bytes;
>> -	int retries = 0;
>> +	int flush_state = FLUSH_DELALLOC;
>>   	int ret = 0;
>> -	bool committed = false;
>>   	bool flushing = false;
>> -	bool wait_ordered = false;
>> +	bool committed = false;
>>
>>   again:
>>   	ret = 0;
>> @@ -3811,9 +3866,8 @@ again:
>>   		 * amount plus the amount of bytes that we need for this
>>   		 * reservation.
>>   		 */
>> -		wait_ordered = true;
>>   		num_bytes = used - space_info->total_bytes +
>> -			(orig_bytes * (retries + 1));
>> +			(orig_bytes * 2);
>>   	}
>>
>>   	if (ret) {
>> @@ -3866,8 +3920,6 @@ again:
>>   			trace_btrfs_space_reservation(root->fs_info,
>>   				"space_info", space_info->flags, orig_bytes, 1);
>>   			ret = 0;
>> -		} else {
>> -			wait_ordered = true;
>>   		}
>>   	}
>>
>> @@ -3886,36 +3938,10 @@ again:
>>   	if (!ret || !flush)
>>   		goto out;
>>
>> -	/*
>> -	 * We do synchronous shrinking since we don't actually unreserve
>> -	 * metadata until after the IO is completed.
>> -	 */
>> -	ret = shrink_delalloc(root, num_bytes, wait_ordered);
>> -	if (ret < 0)
>> -		goto out;
>> -
>> -	ret = 0;
>> -
>> -	/*
>> -	 * So if we were overcommitted it's possible that somebody else flushed
>> -	 * out enough space and we simply didn't have enough space to reclaim,
>> -	 * so go back around and try again.
>> -	 */
>> -	if (retries < 2) {
>> -		wait_ordered = true;
>> -		retries++;
>> -		goto again;
>> -	}
>> -
>> -	ret = -ENOSPC;
>> -	if (committed)
>> -		goto out;
>> -
>> -	ret = may_commit_transaction(root, space_info, orig_bytes, 0);
>> -	if (!ret) {
>> -		committed = true;
>> +	ret = flush_space(root, space_info, num_bytes, orig_bytes,
>> +			  &flush_state);
>> +	if (!ret)
>>   		goto again;
>> -	}
>
> It is better to try do the higher level flush if flush_space() fails. I think.
>

Agreed, I'll fix that up.  Thanks,

Josef
