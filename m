Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751175AbcKGESV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Nov 2016 23:18:21 -0500
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl can't
 be used?
To: Marc MERLIN <marc@merlins.org>
References: <20161107012009.xng7hyhoqwqres3u@merlins.org>
 <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
CC: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
Date: Mon, 7 Nov 2016 12:18:10 +0800
MIME-Version: 1.0
In-Reply-To: <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/07/2016 09:39 AM, Qu Wenruo wrote:
>
>
> At 11/07/2016 09:20 AM, Marc MERLIN wrote:
>> On Mon, Nov 07, 2016 at 09:11:54AM +0800, Qu Wenruo wrote:
>>>> Well, turns out you were right. My array is 14TB and dd was only
>>>> able to
>>>> copy 8.8TB out of it.
>>>>
>>>> I wonder if it's a bug with bcache and source devices that are too big?
>>>
>>> At least we know it's not a problem of btrfs-progs.
>>>
>>> And for bcache/soft raid/encryption, unfortunately I'm not familiar
>>> with any
>>> of them.
>>>
>>> I would recommend to report it to bcache/mdadm/encryption ML after
>>> locating
>>> the layer which returns EINVAL.
>>
>> So, Neil Brown found the problem.
>>
>> myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
>> dd: reading `/dev/md5': Invalid argument
>> 2+0 records in
>> 2+0 records out
>> 2147483648 bytes (2.1 GB) copied, 37.0785 s, 57.9 MB/s
>> myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
>> count=3 iflag=direct
>> 3+0 records in
>> 3+0 records out
>
> That's interesting.
>
>>
>>
>> On Mon, Nov 07, 2016 at 11:16:56AM +1100, NeilBrown wrote:
>>> EINVAL from a read() system call is surprising in this context.....
>>>
>>> do_generic_file_read can return it:
>>>     if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
>>>         return -EINVAL;
>
> At least the return value is a bug.
> Normally we should return -EFBIG instead of -EINVAL.
>
>>>
>>> s_maxbytes will be MAX_LFS_FILESIZE which, on a 32bit system, is
>>>
>>> #define MAX_LFS_FILESIZE        (((loff_t)PAGE_SIZE <<
>>> (BITS_PER_LONG-1))-1)
>>>
>>> That is 2^(12+31) or 2^43 or 8TB.
>>>
>>> Is this a 32bit system you are using?  Such systems can only support
>>> buffered IO up to 8TB.  If you use iflags=direct to avoid buffering, you
>>> should get access to the whole device.
>>
>> I am indeed using a 32bit system, and now we know why the kernel can
>> mount and use my filesystem just fine while btrfs check repair fails to
>> deal with it.
>> The filesystem is more than 8TB on a 32bit kernel with 32bit userland.
>>
>> Since iflag=direct fixes the issue with dd, it sounds like something
>> similar could be done for btrfs progs, to support filesystems bigger
>> than 8TB on 32bit systems.
>>
>> However, could you confirm that filesystems more than 8TB are supported
>> by the kernel code itself on 32bit systems? (I think so, but just
>> wanting to make sure)
>
> Yep, fs can support to u64 max size fs. (But I'd assume u63 max as some
> fs may use the highest bit for special purpose)
> Just VFS/mm layer is blocking things.
>
> Direct IO can handle it because it avoids cache, while for buffered IO,
> it's cache(memory) size limiting the offsize.
>
> It's good to locate the root cause.
>
> It doesn't look hard to add such workaround for btrfs-progs.
> I'll send such workaround soon.

I'm totally wrong here.

DirectIO needs the 'buf' parameter of read()/pread() to be 512 bytes 
aligned.

While we are using a lot of stack memory() and normal malloc()/calloc() 
allocated memory, which are seldom aligned to 512 bytes.

So to *workaround* the problem in btrfs-progs, we may need to change any 
pread() caller to use aligned memory allocation.

I really don't think David will accept such huge change for a workdaround...

Thanks,
Qu
>
> Thanks,
> Qu
>
>>
>> Thanks,
>> Marc
>>


