Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50639 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbcBHOX4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 09:23:56 -0500
Subject: Re: Use fast device only for metadata?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        Kai Krakow <hurikhan77@gmail.com>
References: <874mdktk4t.fsf@vostro.rath.org>
 <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
 <1507413.RERLDqpHyU@merkaba> <56B888FF.5080605@gmail.com>
 <56B8962C.6050302@gmx.com> <56B89839.1060709@gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56B8A4F5.1080405@gmx.com>
Date: Mon, 8 Feb 2016 22:23:49 +0800
MIME-Version: 1.0
In-Reply-To: <56B89839.1060709@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/08/2016 09:29 PM, Austin S. Hemmelgarn wrote:
> On 2016-02-08 08:20, Qu Wenruo wrote:
>> On 02/08/2016 08:24 PM, Austin S. Hemmelgarn wrote:
>>> On 2016-02-07 15:59, Martin Steigerwald wrote:
>>>> Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>>>>> Am Sun, 07 Feb 2016 11:06:58 -0800
>>>>>
>>>>> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>>>>>> Hello,
>>>>>>
>>>>>> I have a large home directory on a spinning disk that I regularly
>>>>>> synchronize between different computers using unison. That takes
>>>>>> ages,
>>>>>> even though the amount of changed files is typically small. I suspect
>>>>>> most if the time is spend walking through the file system and
>>>>>> checking
>>>>>> mtimes.
>>>>>>
>>>>>> So I was wondering if I could possibly speed-up this operation by
>>>>>> storing all btrfs metadata on a fast, SSD drive. It seems that
>>>>>> mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and
>>>>>> the
>>>>>> file contents in single mode. However, I could not find a way to tell
>>>>>> btrfs to use a device *only* for metadata. Is there a way to do that?
>>>>>>
>>>>>> Also, what is the difference between using "dup" and "raid1" for the
>>>>>> metadata?
>>>>>
>>>>> You may want to try bcache. It will speedup random access which is
>>>>> probably the main cause for your slow sync. Unfortunately it requires
>>>>> you to reformat your btrfs partitions to add a bcache superblock. But
>>>>> it's worth the efforts.
>>>>>
>>>>> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+
>>>>> hours
>>>>> to typically 1.5-3 depending on how much data changed.
>>>>
>>>> An alternative is using dm-cache, I think it doesn´t need to recreate
>>>> the
>>>> filesystem.
>>> That's correct, dm-cache can use a regular underlying storage device.
>>> This of course has potential implications for a multi-device filesystem
>>> (it can seriously confuse BTRFS and cause data corruption), but it works
>>> just fine for a single device filesystem.  This makes it a bit easier to
>>> test run, but also means you need more devices (internally, it uses 3,
>>> one backing device, one cache device, and a metadata device for
>>> persistently mapping between the two).  It's really easy to set up
>>> though if you have a recent version of LVM built with dm-cache support.
>>>
>>> In general, bcache takes a bit more setup, but avoids the multi-device
>>> issues, and importantly, doesn't require LVM or dmsetup (which are
>>> usually pretty big packages on many distros).  The caveat with bcache
>>> though is that there have been issues in the past with data integrity
>>> when used with BTRFS, but if you're on a recent kernel (at least 4.0 if
>>> you're using BTRFS for actual data storage), you should have no issues.
>>
>> And I just want to add more about using a device *only* for metadata.
>>
>> The short answer is, unfortunately, NO.
>>
>> 1) Even using bcache/dm-cache, it may still cache small data write
>>
>> Although I'm not quite sure about dm-cache/bcache, but as long as the
>> top file is Btrfs, it won't be possible to limit data/metadata to/from
>> specific device.
>>
>> IIRC, bcache or similiar method may cache most random r/w of metadata,
>> it's still quite possible to cache a lot of random r/w of data.
>>
>> And depending on the sector size(minimal data block size) and leaf size
>> (metadata block size), it's even more possible to cache small data other
>> than metadata under specific worload.
>> As default sectorsize is 4K, but leafsize is 16K.
> The mention of dm-cache/bcache was more intended as an alternative,
> since BTRFS currently can't do what Nikolaus was trying to achieve.
> Neither will give quite the performance profile that a dedicated
> metadata device might, but they should still significantly improve
> general performance.  In essence, these function for BTRFS like L2ARC on
> an SSD does for ZFS.
>>
>> 2) Btrfs don't have special preference on chunk allocation.
>>
>> Btrfs just allocate chunks in the order of unallocated space.
>> So, even there is a super big TB or PB spinning device, and GB level
>> SSD, btrfs will just trust them according to unallocated space.
> On at least the project page, there is a suggestion to provide this
> functionality.  In a way, it's essentially equivalent to the external
> journal device supported by ext4, XFS, OCFS2 and some other filesystems,
> and as such, I'd say it's a feature we should seriously consider looking
> at implementing eventually, even if just for feature parity, and even if
> we speed up metadata operations in BTRFS.

Yes, that's quite a good feature, not only for metadata speedup, but 
also for better metadata safety.

But on the other hand, I also suspect lock concurrency other than device 
speed is causing slow btrfs metadata performance.

Fortunately, that's also in the project page.
But unfortunately, it may be much harder to implement than special 
behaved chunk allocation.

Thanks,
Qu

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
