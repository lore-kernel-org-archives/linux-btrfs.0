Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45381 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753351AbdDNAkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 20:40:23 -0400
Subject: Re: BTRFS not mountable, recover won't work
To: Malte Eggers <m.eggers@campus.tu-berlin.de>, <linux-btrfs@vger.kernel.org>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
 <60ea5a28-cdd3-84d6-1dc6-0cbcbc28755c@cn.fujitsu.com>
 <1491813428.1899.3.camel@campus.tu-berlin.de>
 <c2d8533b-8502-292c-5a81-6831697f10e0@cn.fujitsu.com>
 <1492083934.1135.10.camel@campus.tu-berlin.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e3cc5629-1333-4734-c257-03c4c204faf9@cn.fujitsu.com>
Date: Fri, 14 Apr 2017 08:40:20 +0800
MIME-Version: 1.0
In-Reply-To: <1492083934.1135.10.camel@campus.tu-berlin.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/13/2017 07:45 PM, Malte Eggers wrote:
> On Mon, 2017-04-10 at 16:53 +0800, Qu Wenruo wrote:
>>
>> At 04/10/2017 04:37 PM, Malte Eggers wrote:
>>> On Mon, 2017-04-10 at 16:18 +0800, Qu Wenruo wrote:
>>>>
>>>> At 04/10/2017 01:17 AM, Malte Eggers wrote:
>>>>> Hi,
>>>>>
>>>>> After suspending and waking up my laptop with the external hard
>>>>> drive
>>>>> connected, I could no longer access the files on it. So I
>>>>> unmounted
>>>>> and
>>>>> remounted it, only to discover that I could no longer mount it.
>>>>>
>>>>>
>>>>> This is the error (mounting with usebackuproot, same error
>>>>> without):
>>>>>
>>>>> [891667.002861] BTRFS info (device dm-0): trying to use backup
>>>>> root
>>>>> at
>>>>> mount time
>>>>> [891667.002870] BTRFS info (device dm-0): disk space caching is
>>>>> enabled
>>>>> [891667.002876] BTRFS info (device dm-0): has skinny extents
>>>>> [891667.016395] BTRFS error (device dm-0): parent transid
>>>>> verify
>>>>> failed
>>>>> on 108855296 wanted 32139 found 32104
>>>>> [891667.017181] BTRFS error (device dm-0): parent transid
>>>>> verify
>>>>> failed
>>>>> on 108855296 wanted 32139 found 32104
>>>>> [891667.017194] BTRFS error (device dm-0): failed to recover
>>>>> balance:
>>>>> -5
>>>>
>>>> What about trying skip_balance mount option to skip balance
>>>
>>> Tried that, same error
>>>>
>>>>> [891667.078829] BTRFS error (device dm-0): open_ctree failed
>>>>>
>>>>>
>>>>> btrfs restore and btrfs-find-root fail like this (on both
>>>>> debian
>>>>> sid
>>>>> and fedora 25):
>>>>>
>>>>> parent transid verify failed on 108806144 wanted 32139 found
>>>>> 32104
>>>>> parent transid verify failed on 108806144 wanted 32139 found
>>>>> 32104
>>>>> parent transid verify failed on 108806144 wanted 32139 found
>>>>> 32104
>>>>> parent transid verify failed on 108806144 wanted 32139 found
>>>>> 32104
>>>>> Ignoring transid failure
>>>>
>>>> Would you please paste the output of "btrfs-debug-tree -b
>>>> 108806144
>>>> /dev/dm-0" ?
>>>>
>>>>> volumes.c:1645: btrfs_chunk_readonly: BUG_ON `!ce` triggered,
>>>>> value
>>>>> 1
>>>>
>>>> This BUG_ON() means we can't find a corresponding chunk for given
>>>> offset.
>>>>
>>>> "btrfs-debug-tree -t chunk" would help, if it executes without
>>>> problem.
>>>
>>> btrfs-debug-tree produces the same error
>>>>
>>>> If "btrfs-debug-tree" can't even open the fs, then "btrfs
>>>> inspect-internal dump-super -f /dev/dm-0" would help them.
>>>
>>> dump-super finishes as it appears without error: https://pastebin.c
>>> om/t
>>> i8xuuR5
>>> How would I proceed from here?
>>
>> The obvious problem I found is that, system chunk at bytenr 0 seems
>> invalid.
>> The physical address of that chunk is devid 1 offset 0, which is not
>> possible as 0~1M is reserved.
>>
>> According to the backtrace of btrfs-progs, it seems to be related to
>> chunk tree corruption.
>> Which btrfs chunk recovery may help.
>>
>> It's recommended to backup your system chunks and superblocks first.
>> ------
>> # Backup sys chunks
>>    dd if=/dev/dm-0 of=sys_chunk1_stripe_0 bs=1 count=8388608
>> skip=20971520
>>    dd if=/dev/dm-0 of=sys_chunk1_stripe_1 bs=1 count=8388608
>> skip=29360128
>>    dd if=/dev/dm-0 of=sys_chunk0_stripe_0 bs=1 count=4194304 skip=0
>> # Backup first superblock
>>    dd if=/dev/dm-0 of=superblock0 bs=1 count=4k skip=64k
>> ------
>>
>> Then try chunk recovery
>> ------
>>    btrfs rescue chunk-recover /dev/dm-0
>> ------
>>
>> It can be very slow since it may scan the full device.
>>
>> Thanks,
>> Qu
>>
>>>> Thanks,
>>>> Qu
>>>
>>> Thank you
>>>
>>>
>>
> Is there any way to just rescue whatever can still be reconstructed?
> Cheers,
> Malte

The problem is that, btrfs fails to build its chunk maps.

Unlike traditional fs, btrfs uses dynamically allocated chunk maps, so 
if btrfs fails to build its maps, nothing can be read out.

That's why we have special purposed chunk recover command, due to the 
importance of chunk maps.
(Although it doesn't work as expected sometimes)

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


