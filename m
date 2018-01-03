Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:42549 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbeACBzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 20:55:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 03 Jan 2018 09:55:31 +0800
From: robbieko <robbieko@synology.com>
To: pg@btrfs.list.sabi.co.uk, quwenruo.btrfs@gmx.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: Btrfs reserve metadata problem
In-Reply-To: <23115.33889.91390.589211@tree.ty.sabi.co.uk>
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
 <23115.33889.91390.589211@tree.ty.sabi.co.uk>
Message-ID: <95211d8681c9335f2be2d8563839a492@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Do you have a patch to reduce meta rsv ?


Hi Peter Grandi,

1. all files have been initialized with dd, No need to change any 
metadata.
2. my test with Total volume size 190G, used 128G, available 60G, but 
only 60 MB dirty pages.
     According to the meta rsv rules, 1GB free space up to only 1MB dirty 
pages
3. cow enabled is also the same problem

It is a serious performance issue.

Thanks.
robbieko


pg@btrfs.list.sabi.co.UK 於 2018-01-02 21:08 寫到:
>> When testing Btrfs with fio 4k random write,
> 
> That's an exceptionally narrowly defined workload. Also it is
> narrower than that, because it must be without 'fsync' after
> each write, or else there would be no accumulation of dirty
> blocks in memory at all.
> 
>> I found that volume with smaller free space available has
>> lower performance.
> 
> That's an inappropriate use of "performance"... The speed may be
> lower, the performance is another matter.
> 
>> It seems that the smaller the free space of volume is, the
>> smaller amount of dirty page filesystem could have.
> 
> Is this a problem? Consider: all filesystems do less well when
> there is less free space (smaller chance of finding spatially
> compact allocations), it is usually good to minimize the the
> amont of dirty pages anyhow (even if there are reasons to keep
> delay writing them out).
> 
>> [ ... ] btrfs will reserve metadata for every write.  The
>> amount to reserve is calculated as follows: nodesize *
>> BTRFS_MAX_LEVEL(8) * 2, i.e., it reserves 256KB of metadata.
>> The maximum amount of metadata reservation depends on size of
>> metadata currently in used and free space within volume(free
>> chunk size /16) When metadata reaches the limit, btrfs will
>> need to flush the data to release the reservation.
> 
> I don't understand here: under POSIX semantics filesystems are
> not really allowed to avoid flushing *metadata* to disk for most
> operations, that is metadata operations have an implied 'fsync'.
> Your case of the "4k random write" with "cow disabled" the only
> metadata that should get updated is the last-modified timestamp,
> unless the user/application has been so amazingly stupid to not
> preallocate the file, and then they deserve whatever they get.
> 
>> 1. Is there any logic behind the value (free chunk size /16)
> 
>>   /*
>>    * If we have dup, raid1 or raid10 then only half of the free
>>    * space is actually useable. For raid56, the space info used
>>    * doesn't include the parity drive, so we don't have to
>>    * change the math
>>    */
>>   if (profile & (BTRFS_BLOCK_GROUP_DUP |
>>           BTRFS_BLOCK_GROUP_RAID1 |
>>           BTRFS_BLOCK_GROUP_RAID10))
>>    avail >>= 1;
> 
> As written there is a plausible logic, but it is quite crude.
> 
>>   /*
>>    * If we aren't flushing all things, let us overcommit up to
>>    * 1/2th of the space. If we can flush, don't let us overcommit
>>    * too much, let it overcommit up to 1/8 of the space.
>>    */
>>   if (flush == BTRFS_RESERVE_FLUSH_ALL)
>>    avail >>= 3;
>>   else
>>    avail >>= 1;
> 
> Presumably overcommitting beings some benefits on other workloads.
> 
> In particular other parts of Btrfs don't behave awesomely well
> when free space runs out.
> 
>> 2. Is there any way to improve this problem?
> 
> Again, is it a problem? More interestingly, if it is a problem
> is a solution available that does not impact other workloads?
> It is simply impossible to optimize a filesystem perfectly for
> every workload.
> 
> I'll try to summarize your report as I understand it:
> 
> * If:
>   - The workload is "4k random write" (without 'fsync').
>   - On a "cow disabled" file.
>   - The file is not preallocated.
>   - There is not much free space available.
> * Then allocation overcommitting results in a higher frequency
>   of unrequested metadata flushes, and those metadata flushes
>   slow down a specific benchmark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
