Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8623 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751660AbdDKC1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 22:27:46 -0400
Subject: Re: About the behavior of inline extent
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <dsterba@suse.cz>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <f9dc56cc-720e-0df1-f6c7-790e93276ee0@cn.fujitsu.com>
 <68B899DF-1EFE-4463-A3F8-BD03E0B811DC@toxicpanda.com>
 <20170410153437.GB4781@suse.cz>
 <e223a5e6-75d6-80f6-2fac-db9416d4b9df@cn.fujitsu.com>
Message-ID: <cddfb51b-1a7e-f4ab-25ae-d32afa5fef49@cn.fujitsu.com>
Date: Tue, 11 Apr 2017 10:27:41 +0800
MIME-Version: 1.0
In-Reply-To: <e223a5e6-75d6-80f6-2fac-db9416d4b9df@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/11/2017 10:20 AM, Qu Wenruo wrote:
> 
> 
> At 04/10/2017 11:34 PM, David Sterba wrote:
>> On Mon, Apr 10, 2017 at 10:17:52AM -0400, Josef Bacik wrote:
>>>
>>>> On Apr 9, 2017, at 11:27 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> Recent btrfs/137 test case makes me wonder what's the designed 
>>>> behavior of btrfs inline data extent.
>>>>
>>>> The current behavior in fact is quite a chaos.
>>>> We need a standard of how inline extent should behave.
>>>>
>>>> 1) max_inline limit
>>>>    The problem of current max_inline is, it's never clear what it is
>>>>    limiting.
>>>>
>>>>    For example, we don't allow page sized inline extent if not
>>>>    compressed.
>>>>    But we allow page sized inline extent if it's compressed.
>>>>    Is it just limiting size after compression?
>>>>    What if we really want to limit size before compression?
>>>>
>>>
>>> max_inline is for the actual space on disk.  Compression takes up less
>>> space, therefore you can fit bigger actual data into the inline area.
>>
>> But in practice the other limits apply so we never inline file larger
>> than sectorsize. So the percieved behaviour is more like it's limit of
>> the file size, not the actual storage.
> 
> +1 for file size here.
> 
> Although both makes sense, the file size limit cause less confuse and 
> easier to understand.
> 
>>
>>>> 2) inline extent condition
>>>>    Is inline extent allowed if we have following regular extent?
>>>>
>>>>    For plain extent, prealloc can cause regular extent to co-exist with
>>>>    inlined one.
>>>>    While normal write will only convert inlined extent to regular one.
>>>>
>>>>    While for compressed extent, it can co-exist with regular extent, by
>>>>    # xfs_io -f -c "pwrite 0 4k" -c sync -c "pwrite 4k 16k" 
>>>> /mnt/btrfs/file
>>>>
>>>>    So which is the correct behavior?
>>>>    Personally I think we should not allow co-exist, as it's already
>>>>    causing a lot of fixes for it, that's to say neither current
>>>>    behavior is correct.
>>>
>>> Historically we didn't have [inline][regular] because inline was
>>> always < block size, so any change to the inline extent to extend it
>>> resulted in a regular extent.  Obviously that changed with fallocate,
>>> so it is perfectly reasonable to have [inline][regular extent]
> 
> Even without fallocating, compression also makes difference.
> 
> # xfs_io -f -c "pwrite 0 4K" -c sync -c "pwrite 4k 8K" -c sync 
> /mnt/btrfs/file
> 
> Without compression, it causes one 12K extent.

Sorry , one 4K and one 8K, both regular here.

> 
> With compression, it causes one inline extent and one 8K compressed extent.
> 
> 
> Furthermore, even for compression, the extent layout change if the first 
> write is smaller than 4K.
> 
> # xfs_io -f -c "pwrite 0 4K" -c sync -c "pwrite 4k 8K" -c sync 
> /mnt/btrfs/file
> ^^^ This will cause inline extent with regular compressed extent.
> 
> 
> # xfs_io -f -c "pwrite 0 2K" -c sync -c "pwrite 4k 8K" -c sync 
> /mnt/btrfs/file
> ^^^ While this will cause one compressed regular extent without inlined one
> 
> At least this behavior is confusing.
> 
>>
>> I'm not sure it's perfectly reasonable, makes things confusing. Does all
>> the extent handling code expect another extent after an inline?
> 
> Not really until recent.
> 
> For example, send can't handle it (at least not at best practice) until 
> this patch:
> https://patchwork.kernel.org/patch/9667783/
> 
> And such inline-then-regular can even cause read corruption, fixed by 
> this one:
> https://patchwork.kernel.org/patch/9449103/
> 
> And even before it, such layout can cause -EIO when reading:
> https://patchwork.kernel.org/patch/9137293/
> 
> So it has been proven to be bug prone.
> 
>>
>> In my understanding, more from the user's perspective, is that inline
>> extent covers entire file smaller than some limit, otherwise it's all
>> regular extents.
> 
> +1 for all inline or all regular.
> 
>>
>>>> 3) inline extent and fallocate
>>>>    For inline extent, as long as we are calling fallocate inside the
>>>>    page size, only the isize is expanded.
>>>>
>>>>    Only beyond page size, we get prealloc extents.
>>>>    (However inlined extent is still here, not converted)
>>>>
>>>>    What's the designed behavior? Convert inline to regular or just
>>>>    leave it as is?
>>>
>>> Leave it.
>>
>> "Convert."
>>
>>> fallocate doesn't change anything about existing regular
>>> extents.  Calling fallocate on a range completely inside of a regular
>>> extent does nothing, why would this change with an inline extent?
> 
> But at least the nbytes is not correct.
> 
> # xfs_io -f -c "pwrite 0 2K" -c sync -c "falloc 2k 2k" -c sync 
> /mnt/btrfs/file1
> 
> The nbytes of that inode is still 2K, not 4K.
> 
> Thanks,
> Qu
> 
>>
>> Because this leads to unexpected extent layout, contradicting what we've
>> told users for a long time.  Inline + regular does not bring anything
>> special anyway.
>>
>>> Now
>>> past the inline extent you get a new extent, exactly the same behavior
>>> as a regular extent.  Thanks,
>>
>>
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


