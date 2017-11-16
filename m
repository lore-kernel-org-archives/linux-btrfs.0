Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38098 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754009AbdKPMl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 07:41:27 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Zdenek Kabelac <zkabelac@redhat.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5e5f8561-655f-7a9b-78a2-c775443b2adb@gmail.com>
Date: Thu, 16 Nov 2017 07:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-16 07:33, Zdenek Kabelac wrote:
> Dne 16.11.2017 v 11:04 Qu Wenruo napsal(a):
>>
>>
>> On 2017年11月16日 17:43, Zdenek Kabelac wrote:
>>> Dne 16.11.2017 v 09:08 Qu Wenruo napsal(a):
>>>>
>>>>
>>>>>>>>>
>>>>>>>> [What we have]
>>>>>>>> The nearest infrastructure I found in kernel is
>>>>>>>> bio_integrity_payload.
>>>>>>>>
>>>
>>> Hi
>>>
>>> We already have  dm-integrity target upstream.
>>> What's missing in this target ?
>>
>> If I didn't miss anything, the dm-integrity is designed to calculate and
>> restore csum into its space to verify the integrity.
>> The csum happens when bio reaches dm-integrity.
>>
>> However what I want is, fs generate bio with attached verification hook,
>> and pass to lower layers to verify it.
>>
>> For example, if we use the following device mapper layout:
>>
>>          FS (can be any fs with metadata csum)
>>                  |
>>               dm-integrity
>>                  |
>>               dm-raid1
>>                 / \
>>           disk1     disk2
>>
>> If some data in disk1 get corrupted (the disk itself is still good), and
>> when dm-raid1 tries to read the corrupted data, it may return the
>> corrupted one, and then caught by dm-integrity, finally return -EIO to 
>> FS.
>>
>> But the truth is, we could at least try to read out data in disk2 if we
>> know the csum for it.
>> And use the checksum to verify if it's the correct data.
>>
>>
>> So my idea will be:
>>       FS (with metadata csum, or even data csum support)
>>                  |  READ bio for metadata
>>                  |  -With metadata verification hook
>>              dm-raid1
>>                 / \
>>            disk1   disk2
>>
>> dm-raid1 handles the bio, reading out data from disk1.
>> But the result can't pass verification hook.
>> Then retry with disk2.
>>
>> If result from disk2 passes verification hook. That's good, returning
>> the result from disk2 to upper layer (fs).
>> And we can even submit WRITE bio to try to write the good result back to
>> disk1.
>>
>> If result from disk2 doesn't pass verification hook, then we return -EIO
>> to upper layer.
>>
>> That's what btrfs has already done for DUP/RAID1/10 (although RAID5/6
>> will also try to rebuild data, but it still has some problem).
>>
>> I just want to make device-mapper raid able to handle such case too.
>> Especially when most fs supports checksum for their metadata.
>>
> 
> Hi
> 
> IMHO you are looking for too complicated solution.
> 
> If your checksum is calculated and checked at FS level there is no added 
> value when you spread this logic to other layers.
> 
> dm-integrity adds basic 'check-summing' to any filesystem without the 
> need to modify fs itself - the paid price is - if there is bug between 
> passing data from  'fs' to dm-integrity'  it cannot be captured.
But that is true of pretty much any layering, not just dm-integrity. 
There's just a slightly larger window for corruption with dm-integrity.
> 
> Advantage of having separated 'fs' and 'block' layer is in its 
> separation and simplicity at each level.
> 
> If you want integrated solution - you are simply looking for btrfs where 
> multiple layers are integrated together.
> 
> You are also possibly missing feature of dm-interity - it's not just 
> giving you 'checksum' - it also makes you sure - device has proper 
> content - you can't just 'replace block' even with proper checksum for a 
> block somewhere in the middle of you device... and when joined with 
> crypto - it makes it way more secure...
And to expand a bit further, the correct way to integrate dm-integrity 
into the stack when RAID is involved is to put it _below_ the RAID 
layer, so each underlying device is it's own dm-integrity target. 
Assuming I understand the way dm-raid and md handle -EIO, that should 
get you a similar level of protection to BTRFS (worse in some ways, 
better in others).
