From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [2.6.38-rc6] create->rebalance->mount crash...
Date: Fri, 25 Feb 2011 10:19:18 +0800
Message-ID: <4D6711A6.2030208@cn.fujitsu.com>
References: <AANLkTik-WE+1FYAE6D--fN9GJpThCXwxgejiOsiTk_3k@mail.gmail.com> <4D665396.2040105@cn.fujitsu.com> <1298557709-sup-774@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298557709-sup-774@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris and Liu

On thu, 24 Feb 2011 09:35:32 -0500, Chris Mason wrote:
[SNIP]
>> [PATCH] btrfs: fix OOPS of empty filesystem after balance
>>
>> btrfs will exclude unused block groups via a thread.
>> When a empty filesystem is balanced, the block group with tag "DATA" may be dropped,
>> and after umount, this will lead to OOPS when we mount it again.
>
> Thanks for tracking this down!  Comment below:
[SNIP]
>> -static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
>> +static int init_global_block_rsv(struct btrfs_fs_info *fs_info)
>>   {
>>       struct btrfs_space_info *space_info;
>>
>> +    space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
>> +    if (!space_info)
>> +        return -EAGAIN;
>> +
>>       space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
>>       fs_info->chunk_block_rsv.space_info = space_info;
>>       fs_info->chunk_block_rsv.priority = 10;
>> @@ -3884,6 +3888,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
>>       btrfs_add_durable_block_rsv(fs_info,&fs_info->delalloc_block_rsv);
>>
>>       update_global_block_rsv(fs_info);
>> +
>> +    return 0;
>>   }
>>
>>   static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
>> @@ -8514,7 +8520,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>>               set_block_group_ro(cache);
>>       }
>>
>> -    init_global_block_rsv(info);
>> +again:
>> +    ret = init_global_block_rsv(info);
>> +    if (ret == -EAGAIN) {
>> +        update_space_info(info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
>> +&space_info);
>> +        goto again;
>> +    }
>>       ret = 0;
>
> Are we looping here because we expect the init_global_block_rsv to fail
> more than once?  If so we need a cond_resched or something in there.
>
> But if the EAGAIN is only returned once we should avoid the loop and
> open code the call again.

I don't think we should create a space information object in init_global_block_rsv(),
which just does initialize the global block reservation object.

I think it is better to split btrfs_read_block_group() to three steps.
Step 1: create and initialize the space information object.
Step 2: read the block groups and update the space information.
Step 3: initialize the global block reservation object.
In this way, the logic of the source is clear, and avoid sometrivial mistake.

BTW: I found the btrfs filesystem just has three types of data(file data, meta data,
system meta data), why not add a space information array with three elements into fs_info?
In this way, we can simplify the source code of the space information, and needn't use
RCU lock to protect the space information object list. (I didn't find a lock to protect
the space information object list in the write-side. Is it right?)

Regards
Miao

>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

