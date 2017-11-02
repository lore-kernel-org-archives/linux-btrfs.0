Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40691 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdKBFzQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 01:55:16 -0400
Subject: Re: [PATCH] btrfs: cleanup btrfs_async_submit_limit to return the
 final limit value
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171031125946.26844-1-anand.jain@oracle.com>
 <134be249-616f-1865-585b-7b66427320c1@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e9b338ee-853c-7666-6492-8486402a7243@oracle.com>
Date: Thu, 2 Nov 2017 13:55:15 +0800
MIME-Version: 1.0
In-Reply-To: <134be249-616f-1865-585b-7b66427320c1@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/31/2017 10:18 PM, Nikolay Borisov wrote:
> 
> 
> On 31.10.2017 14:59, Anand Jain wrote:
>> btrfs_async_submit_limit() would return the q depth to be 256, however
>> when we are using it we are making it 2/3 times of it. So instead let
>> the function return the final computed value.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Could you put a bit info about what exactly is this limit controlling in
> the changelog.

  Ok will update.

>> ---
>>   fs/btrfs/disk-io.c | 6 ++++--
>>   fs/btrfs/volumes.c | 1 -
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index dfdab849037b..e58bbc2a68a5 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -861,7 +861,10 @@ unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
>>   	unsigned long limit = min_t(unsigned long,
>>   				    info->thread_pool_size,
>>   				    info->fs_devices->open_devices);
>> -	return 256 * limit;
>> +	/*
>> +	 * As of now limit is computed as 2/3 * 256.
>> +	 */
> 
> Drop the "As of now" part, since it doesn't bring any value.

Ok.

Thanks
Anand

>> +	return 170 * limit;
>>   }
>>   
>>   static void run_one_async_start(struct btrfs_work *work)
>> @@ -887,7 +890,6 @@ static void run_one_async_done(struct btrfs_work *work)
>>   	fs_info = async->fs_info;
>>   
>>   	limit = btrfs_async_submit_limit(fs_info);
>> -	limit = limit * 2 / 3;
>>   
>>   	/*
>>   	 * atomic_dec_return implies a barrier for waitqueue_active
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index d1d8aa226bff..8044790c5de6 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -382,7 +382,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
>>   
>>   	bdi = device->bdev->bd_bdi;
>>   	limit = btrfs_async_submit_limit(fs_info);
>> -	limit = limit * 2 / 3;
>>   
>>   loop:
>>   	spin_lock(&device->io_lock);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
