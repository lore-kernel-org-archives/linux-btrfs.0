Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:41300 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab2IYMHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 08:07:13 -0400
Message-ID: <50619E64.1040808@oracle.com>
Date: Tue, 25 Sep 2012 20:07:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: limit thread pool size when remounting
References: <1348555713-7518-1-git-send-email-bo.li.liu@oracle.com> <20120925113938.GT14582@twin.jikos.cz>
In-Reply-To: <20120925113938.GT14582@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2012 07:39 PM, David Sterba wrote:
> On Tue, Sep 25, 2012 at 02:48:33PM +0800, Liu Bo wrote:
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1158,17 +1158,20 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>>  	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
>>  	       old_pool_size, new_pool_size);
>>  
>> -	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
>> +	btrfs_set_max_workers(&fs_info->generic_worker, min(1, new_pool_size));
> 
> How could new_pool_size be < 1 ?
> 
> There's a check in super.c to pick only values > 0
> 

I think we just need only 1 generic_worker

>>  	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
>> -	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
>> -	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
>> -	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
>> +	btrfs_set_max_workers(&fs_info->submit_workers,
>> +			      min_t(u64, fs_info->fs_devices->num_devices,
>> +			      new_pool_size));
> 
> This ask for update also when a new device is added/removed.
> 

Oh, yes, but we should do it in another new patch instead.

>> +	btrfs_set_max_workers(&fs_info->caching_workers, min(2, new_pool_size));
>> +	btrfs_set_max_workers(&fs_info->fixup_workers, min(1, new_pool_size));
> 
> Same as above, is it expected to be < 1 ?
> 
>>  	btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
>> -	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
>> +	btrfs_set_max_workers(&fs_info->endio_freespace_worker,
>> +			      min(1, new_pool_size));
> 
> Not sure, do we actually need more than 1 free space worker?
> 

Same as generic_worker and fixup_workers, I think only one is enough, that' why I make
the minimum limitation, or we can set it as 1 directly.


thanks,
liubo

>>  	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
>>  	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

