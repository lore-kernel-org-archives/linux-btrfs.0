Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36137 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760150AbdKPQru (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 11:47:50 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
 <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
Date: Thu, 16 Nov 2017 11:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-16 09:06, Qu Wenruo wrote:
> 
> 
> On 2017年11月16日 20:33, Zdenek Kabelac wrote:
>> Dne 16.11.2017 v 11:04 Qu Wenruo napsal(a):
>>>
>>>
>>> On 2017年11月16日 17:43, Zdenek Kabelac wrote:
>>>> Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
>>>>>
>>>>>
>>>>>>>>>>
>>>>>>>>> [What we have]
>>>>>>>>> The nearest infrastructure I found in kernel is
>>>>>>>>> bio_integrity_payload.
>>>>>>>>>
>>>>
>>>> Hi
>>>>
>>>> We already have  dm-integrity target upstream.
>>>> What's missing in this target ?
>>>
>>> If I didn't miss anything, the dm-integrity is designed to calculate and
>>> restore csum into its space to verify the integrity.
>>> The csum happens when bio reaches dm-integrity.
>>>
>>> However what I want is, fs generate bio with attached verification hook,
>>> and pass to lower layers to verify it.
>>>
>>> For example, if we use the following device mapper layout:
>>>
>>>           FS (can be any fs with metadata csum)
>>>                   |
>>>                dm-integrity
>>>                   |
>>>                dm-raid1
>>>                  / \
>>>            disk1     disk2
>>>
>>> If some data in disk1 get corrupted (the disk itself is still good), and
>>> when dm-raid1 tries to read the corrupted data, it may return the
>>> corrupted one, and then caught by dm-integrity, finally return -EIO to
>>> FS.
>>>
>>> But the truth is, we could at least try to read out data in disk2 if we
>>> know the csum for it.
>>> And use the checksum to verify if it's the correct data.
>>>
>>>
>>> So my idea will be:
>>>        FS (with metadata csum, or even data csum support)
>>>                   |  READ bio for metadata
>>>                   |  -With metadata verification hook
>>>               dm-raid1
>>>                  / \
>>>             disk1   disk2
>>>
>>> dm-raid1 handles the bio, reading out data from disk1.
>>> But the result can't pass verification hook.
>>> Then retry with disk2.
>>>
>>> If result from disk2 passes verification hook. That's good, returning
>>> the result from disk2 to upper layer (fs).
>>> And we can even submit WRITE bio to try to write the good result back to
>>> disk1.
>>>
>>> If result from disk2 doesn't pass verification hook, then we return -EIO
>>> to upper layer.
>>>
>>> That's what btrfs has already done for DUP/RAID1/10 (although RAID5/6
>>> will also try to rebuild data, but it still has some problem).
>>>
>>> I just want to make device-mapper raid able to handle such case too.
>>> Especially when most fs supports checksum for their metadata.
>>>
>>
>> Hi
>>
>> IMHO you are looking for too complicated solution.
> 
> This is at least less complicated than dm-integrity.
> 
> Just a new hook for READ bio. And it can start from easy part.
> Like starting from dm-raid1 and other fs support.
It's less complicated for end users (in theory, but cryptsetup devs are 
working on that for dm-integrity), but significantly more complicated 
for developers.

It also brings up the question of what happens when you want some other 
layer between the filesystem and the MD/DM RAID layer (say, running 
bcache or dm-cache on top of the RAID array).  In the case of 
dm-integrity, that's not an issue because dm-integrity is entirely 
self-contained, it doesn't depend on other layers beyond the standard 
block interface.

As I mentioned in my other reply on this thread, running with 
dm-integrity _below_ the RAID layer instead of on top of it will provide 
the same net effect, and in fact provide a stronger guarantee than what 
you are proposing (because dm-integrity does real cryptographic 
integrity verification, as opposed to just checking for bit-rot).
> 
>>
>> If your checksum is calculated and checked at FS level there is no added
>> value when you spread this logic to other layers.
> 
> That's why I'm moving the checking part to lower level, to make more
> value from the checksum.
> 
>>
>> dm-integrity adds basic 'check-summing' to any filesystem without the
>> need to modify fs itself
> 
> Well, despite the fact that modern filesystem has already implemented
> their metadata csum.
> 
>   - the paid price is - if there is bug between
>> passing data from  'fs' to dm-integrity'  it cannot be captured.
>>
>> Advantage of having separated 'fs' and 'block' layer is in its
>> separation and simplicity at each level.
> 
> Totally agreed on this.
> 
> But the idea here should not bring that large impact (compared to big
> things like ZFS/Btrfs).
> 
> 1) It only affect READ bio
> 2) Every dm target can choose if to support or pass down the hook.
>     no mean to support it for RAID0 for example.
>     And for complex raid like RAID5/6 no need to support it from the very
>     beginning.
> 3) Main part of the functionality is already implemented
>     The core complexity contains 2 parts:
>     a) checksum calculation and checking
>        Modern fs is already doing this, at least for metadata.
>     b) recovery
>        dm targets already have this implemented for supported raid
>        profile.
>     All these are already implemented, just moving them to different
>     timing is not bringing such big modification IIRC.
>>
>> If you want integrated solution - you are simply looking for btrfs where
>> multiple layers are integrated together.
> 
> If with such verification hook (along with something extra to handle
> scrub), btrfs chunk mapping can be re-implemented with device-mapper:
> 
> In fact btrfs logical space is just a dm-linear device, and each chunk
> can be implemented by its corresponding dm-* module like:
> 
> dm-linear:       | btrfs chunk 1 | btrfs chunk 2 | ... | btrfs chunk n |
> and
> btrfs chunk 1: metadata, using dm-raid1 on diskA and diskB
> btrfs chunk 2: data, using dm-raid0 on disk A B C D
> ...
> btrfs chunk n: system, using dm-raid1 on disk A B
> 
> At least btrfs can take the advantage of the simplicity of separate layers.
> 
> And other filesystem can get a little higher chance to recover its
> metadata if built on dm-raid.
Again, just put dm-integrity below dm-raid.  The other filesystems 
primarily have metadata checksums to catch data corruption, not repair 
it, and I severely doubt that you will manage to convince developers to 
add support in their filesystem (especially XFS) because:
1. It's a layering violation (yes, I know BTRFS is too, but that's a bit 
less of an issue because it's a completely self-contained layering 
violation, while this isn't).
2. There's no precedent in hardware (I challenge you to find a block 
device that lets you respond to a read completing with 'Hey, this data 
is bogus, give me the real data!').
3. You can get the same net effect with a higher guarantee of security 
using dm-integrity.
> 
> Thanks,
> Qu
> 
>>
>> You are also possibly missing feature of dm-interity - it's not just
>> giving you 'checksum' - it also makes you sure - device has proper
>> content - you can't just 'replace block' even with proper checksum for a
>> block somewhere in the middle of you device... and when joined with
>> crypto - it makes it way more secure...
>>
>> Regards
>>
>> Zdenek
> 

