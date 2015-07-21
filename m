Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30688 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbbGULHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 07:07:09 -0400
Message-ID: <55AE27D2.7060904@oracle.com>
Date: Tue, 21 Jul 2015 19:06:58 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add raid56 support for updating num_tolerated_disk_barrier_failures
 in btrfs_balance()
References: <d950ef643a834a687164bfa6cc140fe5db3527cc.1437048934.git.zhaolei@cn.fujitsu.com> <55A8C6DB.80208@oracle.com> <02a801d0c074$58ce7890$0a6b69b0$@cn.fujitsu.com> <032101d0c2cb$11649b20$342dd160$@cn.fujitsu.com>
In-Reply-To: <032101d0c2cb$11649b20$342dd160$@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


(I was off couple of days, sorry for the delay),

On 20/07/2015 17:04, Zhao Lei wrote:
> Hi, Anand Jain
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Zhao Lei
>> Sent: Friday, July 17, 2015 5:39 PM
>> To: 'Anand Jain'; linux-btrfs@vger.kernel.org
>> Subject: RE: [PATCH] btrfs: Add raid56 support for updating
>> num_tolerated_disk_barrier_failures in btrfs_balance()
>>
>> Hi, Anand Jain
>>
>> Thanks for review it.
>>
>>> -----Original Message-----
>>> From: Anand Jain [mailto:anand.jain@oracle.com]
>>> Sent: Friday, July 17, 2015 5:12 PM
>>> To: Zhaolei; linux-btrfs@vger.kernel.org
>>> Subject: Re: [PATCH] btrfs: Add raid56 support for updating
>>> num_tolerated_disk_barrier_failures in btrfs_balance()
>>>
>>>
>>>
>>> nice clean up thanks. but... more below.
>>>
>>> On 07/16/2015 08:15 PM, Zhaolei wrote:
>>>> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>>>>
>>>> Code for updating fs_info->num_tolerated_disk_barrier_failures in
>>>> btrfs_balance() lacks raid56 support.
>>>>
>>>> Reason:
>>>>    Above code was wroten in 2012-08-01, together with
>>>>    btrfs_calc_num_tolerated_disk_barrier_failures()'s first version.
>>>>
>>>>    Then, btrfs_calc_num_tolerated_disk_barrier_failures() was updated
>>>>    later to support raid56, but code in btrfs_balance() was not
>>>>    updated together.
>>>>
>>>> Fix:
>>>>    Merge these similar code by adding a argument to
>>>>    btrfs_calc_num_tolerated_disk_barrier_failures() to make it
>>>>    support both case.
>>>>
>>>>    It can fix this bug with a bonus of cleanup, and make these code
>>>>    never in current no-sync state from now on.
>>>>
>>>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>>>> ---
>>>>    fs/btrfs/disk-io.c |  9 +++++----
>>>>    fs/btrfs/disk-io.h |  2 +-
>>>>    fs/btrfs/volumes.c | 28 +++++++++-------------------
>>>>    3 files changed, 15 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c index
>>>> b6600c7..ac26111 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -2946,7 +2946,7 @@ retry_root_backup:
>>>>    		goto fail_sysfs;
>>>>    	}
>>>>    	fs_info->num_tolerated_disk_barrier_failures =
>>>> -		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>>>> +		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info, 0);
>>>>    	if (fs_info->fs_devices->missing_devices >
>>>>    	     fs_info->num_tolerated_disk_barrier_failures &&
>>>>    	    !(sb->s_flags & MS_RDONLY)) { @@ -3441,7 +3441,7 @@ static
>>>> int barrier_all_devices(struct btrfs_fs_info
>>> *info)
>>>>    }
>>>>
>>>>    int btrfs_calc_num_tolerated_disk_barrier_failures(
>>>> -	struct btrfs_fs_info *fs_info)
>>>> +	struct btrfs_fs_info *fs_info, u64 extra_flags)
>>>>    {
>>>
>>>    extra_flags not required. since .. more below.
>>>
>>>>    	struct btrfs_ioctl_space_info space;
>>>>    	struct btrfs_space_info *sinfo;
>>>> @@ -3481,7 +3481,7 @@ int
>>> btrfs_calc_num_tolerated_disk_barrier_failures(
>>>>    						   &space);
>>>>    			if (space.total_bytes == 0 || space.used_bytes == 0)
>>>>    				continue;
>>>> -			flags = space.flags;
>>>> +			flags = space.flags | extra_flags;
>>>>    			/*
>>>>    			 * return
>>>>    			 * 0: if dup, single or RAID0 is configured for @@ -3493,7
>>>> +3493,8 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
>>>>    			 */
>>>>    			if (num_tolerated_disk_barrier_failures > 0 &&
>>>>    			    ((flags & (BTRFS_BLOCK_GROUP_DUP |
>>>> -				       BTRFS_BLOCK_GROUP_RAID0)) ||
>>>> +				       BTRFS_BLOCK_GROUP_RAID0 |
>>>> +				       BTRFS_AVAIL_ALLOC_BIT_SINGLE)) ||
>>>>    			     ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) ==
>>> 0)))
>>>>    				num_tolerated_disk_barrier_failures = 0;
>>>>    			else if (num_tolerated_disk_barrier_failures > 1 && diff
>>> --git
>>>> a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h index d4cbfee..aceaa8d
>>>> 100644
>>>> --- a/fs/btrfs/disk-io.h
>>>> +++ b/fs/btrfs/disk-io.h
>>>> @@ -140,7 +140,7 @@ struct btrfs_root *btrfs_create_tree(struct
>>> btrfs_trans_handle *trans,
>>>>    int btree_lock_page_hook(struct page *page, void *data,
>>>>    				void (*flush_fn)(void *));
>>>>    int btrfs_calc_num_tolerated_disk_barrier_failures(
>>>> -	struct btrfs_fs_info *fs_info);
>>>> +	struct btrfs_fs_info *fs_info, u64 extra_flags);
>>>>    int __init btrfs_end_io_wq_init(void);
>>>>    void btrfs_end_io_wq_exit(void);
>>>>
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c index
>>>> fbe7c10..d739915 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -1812,7 +1812,8 @@ int btrfs_rm_device(struct btrfs_root *root,
>>>> char
>>> *device_path)
>>>>    	}
>>>>
>>>>    	root->fs_info->num_tolerated_disk_barrier_failures =
>>>> -		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
>>>> +		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info,
>>>> +							       0);
>>>>
>>>>    	/*
>>>>    	 * at this point, the device is zero sized.  We want to @@
>>>> -2342,7
>>>> +2343,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char
>>> *device_path)
>>>>    	}
>>>>
>>>>    	root->fs_info->num_tolerated_disk_barrier_failures =
>>>> -		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
>>>> +		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info,
>>>> +							       0);
>>>>    	ret = btrfs_commit_transaction(trans, root);
>>>>
>>>>    	if (seeding_dev) {
>>>> @@ -3573,23 +3575,10 @@ int btrfs_balance(struct
>>>> btrfs_balance_control
>>> *bctl,
>>>>    	} while (read_seqretry(&fs_info->profiles_lock, seq));
>>>>
>>>>    	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>>>> -		int num_tolerated_disk_barrier_failures;
>>>> -		u64 target = bctl->sys.target;
>>>> -
>>>> -		num_tolerated_disk_barrier_failures =
>>>> -			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>>>> -		if (num_tolerated_disk_barrier_failures > 0 &&
>>>> -		    (target &
>>>> -		     (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
>>>> -		      BTRFS_AVAIL_ALLOC_BIT_SINGLE)))
>>>> -			num_tolerated_disk_barrier_failures = 0;
>>>> -		else if (num_tolerated_disk_barrier_failures > 1 &&
>>>> -			 (target &
>>>> -			  (BTRFS_BLOCK_GROUP_RAID1 |
>>> BTRFS_BLOCK_GROUP_RAID10)))
>>>> -			num_tolerated_disk_barrier_failures = 1;
>>>> -
>>>>    		fs_info->num_tolerated_disk_barrier_failures =
>>>> -			num_tolerated_disk_barrier_failures;
>>>> +			btrfs_calc_num_tolerated_disk_barrier_failures(
>>>> +				fs_info,
>>>> +				bctl->sys.target);
>>>>    	}
>>
>>
>>>
>>>    target is part of the user-end set item. please don't propagate
>>>    that to the function btrfs_calc_num_tolerated_disk_barrier_failures()
>>>    which is quite usefully used by many more functions. target must be
>>>    handled in here.	
>>>
>>>    Also, while you are here it looks like this and
>>>     btrfs_chunk_max_errors() can be merged as well.
>>>
>>
>> Do you means use btrfs_chunk_max_errors() here to calculate
>> s_info->num_tolerated_disk_barrier_failures here, instead of adding a extea
>> argument to btrfs_calc_num_tolerated_disk_barrier_failures(),
>> like:
>>
>> info->num_tolerated_disk_barrier_failures =
>> min(
>> btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
>> btrfs_chunk_max_errors(bctl->sys.target)
>> );
>>

> I'll send v2 based on your comment of:
> Don't propagate extra argument to btrfs_calc_num_tolerated_disk_barrier_failures()
> which is quite usefully used by many more functions.

thanks.

> btrfs_chunk_max_errors() is similar but have little different with our request,
> so I merged and move these common code into new function:
> btrfs_calc_num_tolerated_disk_barrier_failures()
>
> different of these functions are:
>    btrfs_calc_num_tolerated_disk_barrier_failures(): max wrong disks
>    btrfs_chunk_max_errors(): max wrong mirrors
> For dup, max wrong disks is 0, and max wrong mirrors is 1.

  I didn't intended to do that as part this patch, thats for
  another patch for optimizing code.

Thanks, Anand

> Thanks
> Zhaolei
>
>> Thanks
>> Zhaolei
>>
>>> Thanks. Anand
>>>
>>>
>>>>    	ret = insert_balance_item(fs_info->tree_root, bctl); @@ -3616,7
>>>> +3605,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>>>>
>>>>    	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>>>>    		fs_info->num_tolerated_disk_barrier_failures =
>>>> -			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>>>> +			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info,
>>>> +								       0);
>>>>    	}
>>>>
>>>>    	if (bargs) {
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
