Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45888 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932904AbdKQMWO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 07:22:14 -0500
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
 <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
 <b439a2d7-18f6-62cd-2038-a2f052ae554a@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6da792a1-3c15-73b9-8e13-29f762c47252@gmail.com>
Date: Fri, 17 Nov 2017 07:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <b439a2d7-18f6-62cd-2038-a2f052ae554a@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-16 20:30, Qu Wenruo wrote:
> 
> 
> On 2017年11月17日 00:47, Austin S. Hemmelgarn wrote:
> 
>>>
>>> This is at least less complicated than dm-integrity.
>>>
>>> Just a new hook for READ bio. And it can start from easy part.
>>> Like starting from dm-raid1 and other fs support.
>> It's less complicated for end users (in theory, but cryptsetup devs are
>> working on that for dm-integrity), but significantly more complicated
>> for developers.
>>
>> It also brings up the question of what happens when you want some other
>> layer between the filesystem and the MD/DM RAID layer (say, running
>> bcache or dm-cache on top of the RAID array).  In the case of
>> dm-integrity, that's not an issue because dm-integrity is entirely
>> self-contained, it doesn't depend on other layers beyond the standard
>> block interface.
> 
> Each layer can choose to drop the support for extra verification.
> 
> If the layer is not modifying the data, it can pass it do lower layer.
> Just as integrity payload.
Which then makes things a bit more complicated in every other layer as 
well, in turn making things more complicated for all developers.
> 
>>
>> As I mentioned in my other reply on this thread, running with
>> dm-integrity _below_ the RAID layer instead of on top of it will provide
>> the same net effect, and in fact provide a stronger guarantee than what
>> you are proposing (because dm-integrity does real cryptographic
>> integrity verification, as opposed to just checking for bit-rot).
> 
> Although with more CPU usage for each device even they are containing
> same data.
I never said it wasn't higher resource usage.
> 
>>>
>>>>
>>>> If your checksum is calculated and checked at FS level there is no added
>>>> value when you spread this logic to other layers.
>>>
>>> That's why I'm moving the checking part to lower level, to make more
>>> value from the checksum.
>>>
>>>>
>>>> dm-integrity adds basic 'check-summing' to any filesystem without the
>>>> need to modify fs itself
>>>
>>> Well, despite the fact that modern filesystem has already implemented
>>> their metadata csum.
>>>
>>>    - the paid price is - if there is bug between
>>>> passing data from  'fs' to dm-integrity'  it cannot be captured.
>>>>
>>>> Advantage of having separated 'fs' and 'block' layer is in its
>>>> separation and simplicity at each level.
>>>
>>> Totally agreed on this.
>>>
>>> But the idea here should not bring that large impact (compared to big
>>> things like ZFS/Btrfs).
>>>
>>> 1) It only affect READ bio
>>> 2) Every dm target can choose if to support or pass down the hook.
>>>      no mean to support it for RAID0 for example.
>>>      And for complex raid like RAID5/6 no need to support it from the very
>>>      beginning.
>>> 3) Main part of the functionality is already implemented
>>>      The core complexity contains 2 parts:
>>>      a) checksum calculation and checking
>>>         Modern fs is already doing this, at least for metadata.
>>>      b) recovery
>>>         dm targets already have this implemented for supported raid
>>>         profile.
>>>      All these are already implemented, just moving them to different
>>>      timing is not bringing such big modification IIRC.
>>>>
>>>> If you want integrated solution - you are simply looking for btrfs where
>>>> multiple layers are integrated together.
>>>
>>> If with such verification hook (along with something extra to handle
>>> scrub), btrfs chunk mapping can be re-implemented with device-mapper:
>>>
>>> In fact btrfs logical space is just a dm-linear device, and each chunk
>>> can be implemented by its corresponding dm-* module like:
>>>
>>> dm-linear:       | btrfs chunk 1 | btrfs chunk 2 | ... | btrfs chunk n |
>>> and
>>> btrfs chunk 1: metadata, using dm-raid1 on diskA and diskB
>>> btrfs chunk 2: data, using dm-raid0 on disk A B C D
>>> ...
>>> btrfs chunk n: system, using dm-raid1 on disk A B
>>>
>>> At least btrfs can take the advantage of the simplicity of separate
>>> layers.
>>>
>>> And other filesystem can get a little higher chance to recover its
>>> metadata if built on dm-raid.
>> Again, just put dm-integrity below dm-raid.  The other filesystems
>> primarily have metadata checksums to catch data corruption, not repair
>> it,
> 
> Because they have no extra copy.
> If they have, they will definitely use the extra copy to repair.
But they don't have those extra copies now, so that really becomes 
irrelevant as an argument (especially since it's not likely they will 
add data or metadata replication in the filesystem any time in the near 
future).
> 
>> and I severely doubt that you will manage to convince developers to
>> add support in their filesystem (especially XFS) because:
>> 1. It's a layering violation (yes, I know BTRFS is too, but that's a bit
>> less of an issue because it's a completely self-contained layering
>> violation, while this isn't).
> 
> If passing something along with bio is violating layers, then integrity
> payload is already doing this for a long time.
The block integrity layer is also interfacing directly with hardware and 
_needs_ to pass that data down.  Unless I'm mistaken, it also doesn't do 
any verification except in the filesystem layer, and doesn't pass down 
any complaints about the integrity of the data (it may try to re-read 
it, but that's not the same as what you're talking about).
> 
>> 2. There's no precedent in hardware (I challenge you to find a block
>> device that lets you respond to a read completing with 'Hey, this data
>> is bogus, give me the real data!').
>> 3. You can get the same net effect with a higher guarantee of security
>> using dm-integrity.
> 
> With more CPU and IO overhead (journal mode will write data twice, one
> for journal and one for real data).
If you're concerned about that, then the same argument could be made 
about having checksumming at all.  Yes, it's not cheap, but security and 
data safety almost never are.  CoW semantics in BTRFS are just as 
resource intensive (if not more so).

