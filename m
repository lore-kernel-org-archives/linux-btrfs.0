Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:44993 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeGSM02 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:26:28 -0400
Received: by mail-io0-f196.google.com with SMTP id q19-v6so6785673ioh.11
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 04:43:41 -0700 (PDT)
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <330020d0-c611-54f6-cbf2-fe9fa6bd3782@gmail.com>
Date: Thu, 19 Jul 2018 07:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-18 15:42, Goffredo Baroncelli wrote:
> On 07/18/2018 09:20 AM, Duncan wrote:
>> Goffredo Baroncelli posted on Wed, 18 Jul 2018 07:59:52 +0200 as
>> excerpted:
>>
>>> On 07/17/2018 11:12 PM, Duncan wrote:
>>>> Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
>>>> excerpted:
>>>>
>>>>> On 07/15/2018 04:37 PM, waxhead wrote:
>>>>
>>>>> Striping and mirroring/pairing are orthogonal properties; mirror and
>>>>> parity are mutually exclusive.
>>>>
>>>> I can't agree.  I don't know whether you meant that in the global
>>>> sense,
>>>> or purely in the btrfs context (which I suspect), but either way I
>>>> can't agree.
>>>>
>>>> In the pure btrfs context, while striping and mirroring/pairing are
>>>> orthogonal today, Hugo's whole point was that btrfs is theoretically
>>>> flexible enough to allow both together and the feature may at some
>>>> point be added, so it makes sense to have a layout notation format
>>>> flexible enough to allow it as well.
>>>
>>> When I say orthogonal, It means that these can be combined: i.e. you can
>>> have - striping (RAID0)
>>> - parity  (?)
>>> - striping + parity  (e.g. RAID5/6)
>>> - mirroring  (RAID1)
>>> - mirroring + striping  (RAID10)
>>>
>>> However you can't have mirroring+parity; this means that a notation
>>> where both 'C' ( = number of copy) and 'P' ( = number of parities) is
>>> too verbose.
>>
>> Yes, you can have mirroring+parity, conceptually it's simply raid5/6 on
>> top of mirroring or mirroring on top of raid5/6, much as raid10 is
>> conceptually just raid0 on top of raid1, and raid01 is conceptually raid1
>> on top of raid0.
> And what about raid 615156156 (raid 6 on top of raid 1 on top of raid 5 on top of....) ???
> 
> Seriously, of course you can combine a lot of different profile; however the only ones that make sense are the ones above.
No, there are cases where other configurations make sense.

RAID05 and RAID06 are very widely used, especially on NAS systems where 
you have lots of disks.  The RAID5/6 lower layer mitigates the data loss 
risk of RAID0, and the RAID0 upper-layer mitigates the rebuild 
scalability issues of RAID5/6.  In fact, this is pretty much the 
standard recommended configuration for large ZFS arrays that want to use 
parity RAID.  This could be reasonably easily supported to a rudimentary 
degree in BTRFS by providing the ability to limit the stripe width for 
the parity profiles.

Some people use RAID50 or RAID60, although they are strictly speaking 
inferior in almost all respects to RAID05 and RAID06.

RAID01 is also used on occasion, it ends up having the same storage 
capacity as RAID10, but for some RAID implementations it has a different 
performance envelope and different rebuild characteristics.  Usually, 
when it is used though, it's software RAID0 on top of hardware RAID1.

RAID51 and RAID61 used to be used, but aren't much now.  They provided 
an easy way to have proper data verification without always having the 
rebuild overhead of RAID5/6 and without needing to do checksumming. 
They are pretty much useless for BTRFS, as it can already tell which 
copy is correct.

RAID15 and RAID16 are a similar case to RAID51 and RAID61, except they 
might actually make sense in BTRFS to provide a backup means of 
rebuilding blocks that fail checksum validation if both copies fail.
> 
> The fact that you can combine striping and mirroring (or pairing) makes sense because you could have a speed gain (see below).
> [....]
>>>>
>>>> As someone else pointed out, md/lvm-raid10 already work like this.
>>>> What btrfs calls raid10 is somewhat different, but btrfs raid1 pretty
>>>> much works this way except with huge (gig size) chunks.
>>>
>>> As implemented in BTRFS, raid1 doesn't have striping.
>>
>> The argument is that because there's only two copies, on multi-device
>> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
>> alternate device pairs, it's effectively striped at the macro level, with
>> the 1 GiB device-level chunks effectively being huge individual device
>> strips of 1 GiB.
> 
> The striping concept is based to the fact that if the "stripe size" is small enough you have a speed benefit because the reads may be performed in parallel from different disks.
That's not the only benefit of striping though.  The other big one is 
that you now have one volume that's the combined size of both of the 
original devices.  Striping is arguably better for this even if you're 
using a large stripe size because it better balances the wear across the 
devices than simple concatenation.

> With a "stripe size" of 1GB, it is very unlikely that this would happens.
That's a pretty big assumption.  There are all kinds of access patterns 
that will still distribute the load reasonably evenly across the 
constituent devices, even if they don't parallelize things.

If, for example, all your files are 64k or less, and you only read whole 
files, there's no functional difference between RAID0 with 1GB blocks 
and RAID0 with 64k blocks.  Such a workload is not unusual on a very 
busy mail-server.
> 
>   
>> At 1 GiB strip size it doesn't have the typical performance advantage of
>> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
>> strips/chunks.
