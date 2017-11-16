Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbdKPHmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 02:42:36 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
Date: Thu, 16 Nov 2017 09:42:31 +0200
MIME-Version: 1.0
In-Reply-To: <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.11.2017 09:38, Qu Wenruo wrote:
> 
> 
> On 2017年11月16日 14:54, Nikolay Borisov wrote:
>>
>>
>> On 16.11.2017 04:18, Qu Wenruo wrote:
>>> Hi all,
>>>
>>> [Background]
>>> Recently I'm considering the possibility to use checksum from filesystem
>>> to enhance device-mapper raid.
>>>
>>> The idea behind it is quite simple, since most modern filesystems have
>>> checksum for their metadata, and even some (btrfs) have checksum for data.
>>>
>>> And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read time
>>> it can use the checksum to determine which copy is correct so it can
>>> return the correct data even one copy get corrupted.
>>>
>>> [Objective]
>>> The final objective is to allow device mapper to do the checksum
>>> verification (and repair if possible).
>>>
>>> If only for verification, it's not much different from current endio
>>> hook method used by most of the fs.
>>> However if we can move the repair part from filesystem (well, only btrfs
>>> supports it yet), it would benefit all fs.
>>>
>>> [What we have]
>>> The nearest infrastructure I found in kernel is bio_integrity_payload.
>>>
>>> However I found it's bounded to device, as it's designed to support
>>> SCSI/SATA integrity protocol.
>>> While for such use case, it's more bounded to filesystem, as fs (or
>>> higher layer dm device) is the source of integrity data, and device
>>> (dm-raid) only do the verification and possible repair.
>>>
>>> I'm not sure if this is a good idea to reuse or abuse
>>> bio_integrity_payload for this purpose.
>>>
>>> Should we use some new infrastructure or enhance existing
>>> bio_integrity_payload?
>>>
>>> (Or is this a valid idea or just another crazy dream?)
>>>
>>
>> This sounds good in principle, however I think there is one crucial
>> point which needs to be considered:
>>
>> All fs with checksums store those checksums in some specific way, then
>> when they fetch data from disk they they also know how to acquire the
>> respective checksum.
> 
> Just like integrity payload, we generate READ bio attached with checksum
> hook function and checksum data.

So how is this checksum data acquired in the first place?

> 
> So for data read, we read checksum first and attach it to data READ bio,
> then submit it.
> 
> And for metadata read, in most case the checksum is integrated into
> metadata header, like what we did in btrfs.
> 
> In that case we attach empty checksum data to bio, but use metadata
> specific function hook to handle it.
> 
>> What you suggest might be doable but it will
>> require lower layers (dm) be aware of how to acquire the specific
>> checksum for some data.
> 
> In above case, dm only needs to call the verification hook function.
> If verification passed, that's good.
> If not, try other copy if we have.
> 
> In this case, I don't think dm layer needs any extra interface to
> communicate with higher layer.


Well that verification function is the interface I meant, you are
communicating the checksum out of band essentially (notwithstanding the
metadata case, since you said checksum is in the actual metadata header)

In the end - which problem are you trying to solve, allow for a generic
checksumming layer which filesystems may use if they decide to ?

> 
> Thanks,
> Qu
> 
>> I don't think at this point there is such infra
>> and frankly I cannot even envision how it will work elegantly. Sure you
>> can create a dm-checksum target (which I believe dm-verity is very
>> similar to) that stores checksums alongside data but at this point the
>> fs is really out of the picture.
>>
>>
>>> Thanks,
>>> Qu
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
