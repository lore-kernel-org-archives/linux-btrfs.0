Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16329 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750724AbdAWBeP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Jan 2017 20:34:15 -0500
Subject: Re: RAID56 status?
To: Jan Vales <jan@jvales.net>, Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net>
 <20170122223906.GA24076@carfax.org.uk>
 <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <35d49fbd-102c-3e54-4e40-5f71fb88d2da@cn.fujitsu.com>
Date: Mon, 23 Jan 2017 09:34:10 +0800
MIME-Version: 1.0
In-Reply-To: <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/23/2017 08:25 AM, Jan Vales wrote:
> On 01/22/2017 11:39 PM, Hugo Mills wrote:
>> On Sun, Jan 22, 2017 at 11:35:49PM +0100, Christoph Anton Mitterer wrote:
>>> On Sun, 2017-01-22 at 22:22 +0100, Jan Vales wrote:
>>>> Therefore my question: whats the status of raid5/6 is in btrfs?
>>>> Is it somehow "production"-ready by now?
>>> AFAIK, what's on the - apparently already no longer updated -
>>> https://btrfs.wiki.kernel.org/index.php/Status still applies, and
>>> RAID56 is not yet usable for anything near production.
>>
>>    It's still all valid. Nothing's changed.
>>
>>    How would you like it to be updated? "Nope, still broken"?
>>
>>    Hugo.
>>
>>

I'd like to update the wiki to "More and more RAID5/6 bugs are found" :)

OK, no kidding, at least we did exposed several new bugs, and reports 
already exists for a while in mail list.

Some examples are:

1) RAID5/6 scrub will repair data while corrupting parity
    Quite ironic, repairing is just changing one corruption to
    another.

2) RAID5/6 scrub can report false alerts on csum error

3) Dev-replace cancel sometimes can cause kernel panic.

And if we find more bugs, I'm not surprised at all.

So, if really want to use RAID5/6, please use soft raid, then build 
single volume btrfs on it.

I'm seriously considering to re-implement btrfs RAID5/6 using device 
mapper, which is tried and true.

>
> As the changelog stops at 4.7 the wiki seemed a little dead - "still
> broken as of $(date)" or something like that would be nice ^.^
>
> Also some more exact documentation/definition of btrfs' raid-levels
> would be cool, as they seem to mismatch traditional raid-levels - or at
> least I as an ignorant user fail to understand them...

man mkfs.btrfs has a quite good table for the btrfs profiles.

>
> Correct me, if im wrong...
> * It seems, raid1(btrfs) is actually raid10, as there are no more than 2
> copies of data, regardless of the count of devices.

Somewhat right, despite the stripe size of RAID10 is 64K while RAID1 is 
chunk size(1G for data normally), and the large stripe size for RAID1 
makes it meaningless to call it RAID0.

> ** Is there a way to duplicate data n-times?

The only supported n-times duplication is 3-times duplication, which 
uses RAID6 on 3 devices, and I don't consider it safe compared to RAID1.

> ** If there are only 3 devices and the wrong device dies... is it dead?

For RAID1/10/5/6, theoretically it's still alive.
RAID5/6 is of course no problem for it.

For RAID1, always 2 mirrors and mirrors are always located on difference 
device, so no matter which mirrors dies, btrfs can still read it out.

But in practice, it's btrfs, you know right?

> * Whats the diffrence of raid1(btrfs) and raid10(btrfs)?

RAID1: Pure mirror, no striping
           Disk 1                |           Disk 2
----------------------------------------------------------------
  Data Data Data Data Data       | Data Data Data Data Data
  \                      /
      Full one chunk

While chunks are always allocated to the device with most unallocated 
space, you can consider it as extent level RAID1 with chunk level RAID0.

RAID10: RAID1 first, then RAID0
         IIRC RAID0 stripe size is 64K

Disk 1 | Data 1 (64K) Data 4 (64K)
Disk 2 | Data 1 (64K) Data 4 (64K)
---------------------------------------
Disk 3 | Data 2 (64K)
Disk 4 | Data 2 (64K)
---------------------------------------
Disk 5 | Data 3 (64K)
Disk 6 | Data 3 (64K)


> ** After reading like 5 diffrent wiki pages, I understood, that there
> are diffrences ... but not what they are and how they affect me :/

Chunk level striping won't have any obvious performance advantage, while 
64K level striping do.

> * Whats the diffrence of raid0(btrfs) and "normal" multi-device
> operation which seems like a traditional raid0 to me?

What's "normal" or traditional RAID0?
Doesn't it uses all devices for striping? Or just uses 2?



Btrfs RAID0 is always using stripe size 64K (not only RAID0, but also 
RAID10/5/6).

While btrfs chunk allocation also provide chunk size level striping, 
which is 1G for data (considering your fs is larger than 10G) or 256M 
for metadata.

But that striping size won't provide anything useful.
So you could just forgot that chunk level thing.

Despite that, btrfs RAID should quite match normal RAID.

Thanks,
Qu

>
> Maybe rename/alias raid-levels that do not match traditional
> raid-levels, so one cannot expect some behavior that is not there.
> The extreme example is imho raid1(btrfs) vs raid1.
> I would expect that if i have 5 btrfs-raid1-devices, 4 may die and btrfs
> should be able to fully recover, which, if i understand correctly, by
> far does not hold.
> If you named that raid-level say "george" ... I would need to consult
> the docs and I obviously would not expect any behavior. :)
>
> regards,
> Jan Vales
> --
> I only read plaintext emails.
>


