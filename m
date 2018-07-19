Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([213.209.14.32]:55635 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732015AbeGSSWP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 14:22:15 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
 <330020d0-c611-54f6-cbf2-fe9fa6bd3782@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <d8071de6-7c02-c8cf-074e-9a52ed9f3fac@inwind.it>
Date: Thu, 19 Jul 2018 19:29:51 +0200
MIME-Version: 1.0
In-Reply-To: <330020d0-c611-54f6-cbf2-fe9fa6bd3782@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/19/2018 01:43 PM, Austin S. Hemmelgarn wrote:
> On 2018-07-18 15:42, Goffredo Baroncelli wrote:
>> On 07/18/2018 09:20 AM, Duncan wrote:
>>> Goffredo Baroncelli posted on Wed, 18 Jul 2018 07:59:52 +0200 as
>>> excerpted:
>>>
>>>> On 07/17/2018 11:12 PM, Duncan wrote:
>>>>> Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
>>>>> excerpted:
>>>>>
[...]
>>>>
>>>> When I say orthogonal, It means that these can be combined: i.e. you can
>>>> have - striping (RAID0)
>>>> - parity  (?)
>>>> - striping + parity  (e.g. RAID5/6)
>>>> - mirroring  (RAID1)
>>>> - mirroring + striping  (RAID10)
>>>>
>>>> However you can't have mirroring+parity; this means that a notation
>>>> where both 'C' ( = number of copy) and 'P' ( = number of parities) is
>>>> too verbose.
>>>
>>> Yes, you can have mirroring+parity, conceptually it's simply raid5/6 on
>>> top of mirroring or mirroring on top of raid5/6, much as raid10 is
>>> conceptually just raid0 on top of raid1, and raid01 is conceptually raid1
>>> on top of raid0.
>> And what about raid 615156156 (raid 6 on top of raid 1 on top of raid 5 on top of....) ???
>>
>> Seriously, of course you can combine a lot of different profile; however the only ones that make sense are the ones above.
> No, there are cases where other configurations make sense.
> 
> RAID05 and RAID06 are very widely used, especially on NAS systems where you have lots of disks.  The RAID5/6 lower layer mitigates the data loss risk of RAID0, and the RAID0 upper-layer mitigates the rebuild scalability issues of RAID5/6.  In fact, this is pretty much the standard recommended configuration for large ZFS arrays that want to use parity RAID.  This could be reasonably easily supported to a rudimentary degree in BTRFS by providing the ability to limit the stripe width for the parity profiles.
> 
> Some people use RAID50 or RAID60, although they are strictly speaking inferior in almost all respects to RAID05 and RAID06.
> 
> RAID01 is also used on occasion, it ends up having the same storage capacity as RAID10, but for some RAID implementations it has a different performance envelope and different rebuild characteristics.  Usually, when it is used though, it's software RAID0 on top of hardware RAID1.
> 
> RAID51 and RAID61 used to be used, but aren't much now.  They provided an easy way to have proper data verification without always having the rebuild overhead of RAID5/6 and without needing to do checksumming. They are pretty much useless for BTRFS, as it can already tell which copy is correct.

So until now you are repeating what I told: the only useful raid profile are 
- striping 
- mirroring
- striping+paring (even limiting the number of disk involved)
- striping+mirroring

> 
> RAID15 and RAID16 are a similar case to RAID51 and RAID61, except they might actually make sense in BTRFS to provide a backup means of rebuilding blocks that fail checksum validation if both copies fail.
If you need further redundancy, it is easy to implement a parity3 and parity4 raid profile instead of stacking a raid6+raid1

>>
>> The fact that you can combine striping and mirroring (or pairing) makes sense because you could have a speed gain (see below).
>> [....]
>>>>>
>>>>> As someone else pointed out, md/lvm-raid10 already work like this.
>>>>> What btrfs calls raid10 is somewhat different, but btrfs raid1 pretty
>>>>> much works this way except with huge (gig size) chunks.
>>>>
>>>> As implemented in BTRFS, raid1 doesn't have striping.
>>>
>>> The argument is that because there's only two copies, on multi-device
>>> btrfs raid1 with 4+ devices of equal size so chunk allocations tend to
>>> alternate device pairs, it's effectively striped at the macro level, with
>>> the 1 GiB device-level chunks effectively being huge individual device
>>> strips of 1 GiB.
>>
>> The striping concept is based to the fact that if the "stripe size" is small enough you have a speed benefit because the reads may be performed in parallel from different disks.
> That's not the only benefit of striping though.  The other big one is that you now have one volume that's the combined size of both of the original devices.  Striping is arguably better for this even if you're using a large stripe size because it better balances the wear across the devices than simple concatenation.

Striping means that the data is interleaved between the disks with a reasonable "block unit". Otherwise which would be the difference between btrfs-raid0 and btrfs-single ?

> 
>> With a "stripe size" of 1GB, it is very unlikely that this would happens.
> That's a pretty big assumption.  There are all kinds of access patterns that will still distribute the load reasonably evenly across the constituent devices, even if they don't parallelize things.
> 
> If, for example, all your files are 64k or less, and you only read whole files, there's no functional difference between RAID0 with 1GB blocks and RAID0 with 64k blocks.  Such a workload is not unusual on a very busy mail-server.

I fully agree that 64K may be too much for some workload, however I have to point out that I still find difficult to imagine that you can take advantage of parallel read from multiple disks with a 1GB stripe unit for a *common workload*. Pay attention that btrfs inline in the metadata the small files, so even if the file is smaller than 64k, a 64k read (or more) will be required in order to access it.


>>
>>  
>>> At 1 GiB strip size it doesn't have the typical performance advantage of
>>> striping, but conceptually, it's equivalent to raid10 with huge 1 GiB
>>> strips/chunks.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
