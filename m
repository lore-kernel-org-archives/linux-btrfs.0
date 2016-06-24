Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34947 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbcFXLgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 07:36:51 -0400
Received: by mail-io0-f177.google.com with SMTP id f30so96827833ioj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 04:36:51 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <20160624101658.GI3325@carfax.org.uk>
 <CAA91j0XuC4BCk5qXwDURQLHp6rg6qVL3fYrZbH=9RM65nMHbGA@mail.gmail.com>
 <20160624105959.GJ3325@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <edab8dbd-60e7-fafa-7267-d1e65a897353@gmail.com>
Date: Fri, 24 Jun 2016 07:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <20160624105959.GJ3325@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-24 06:59, Hugo Mills wrote:
> On Fri, Jun 24, 2016 at 01:19:30PM +0300, Andrei Borzenkov wrote:
>> On Fri, Jun 24, 2016 at 1:16 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> On Fri, Jun 24, 2016 at 12:52:21PM +0300, Andrei Borzenkov wrote:
>>>> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>>> On Fri, Jun 24, 2016 at 07:02:34AM +0300, Andrei Borzenkov wrote:
>>>>>> 24.06.2016 04:47, Zygo Blaxell пишет:
>>>>>>> On Thu, Jun 23, 2016 at 06:26:22PM -0600, Chris Murphy wrote:
>>>>>>>> On Thu, Jun 23, 2016 at 1:32 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>>>>>>>>> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the checksum.
>>>>>>>>
>>>>>>>> Yeah I'm kinda confused on this point.
>>>>>>>>
>>>>>>>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>>>>>>>
>>>>>>>> It says there is a write hole for Btrfs. But defines it in terms of
>>>>>>>> parity possibly being stale after a crash. I think the term comes not
>>>>>>>> from merely parity being wrong but parity being wrong *and* then being
>>>>>>>> used to wrongly reconstruct data because it's blindly trusted.
>>>>>>>
>>>>>>> I think the opposite is more likely, as the layers above raid56
>>>>>>> seem to check the data against sums before raid56 ever sees it.
>>>>>>> (If those layers seem inverted to you, I agree, but OTOH there are
>>>>>>> probably good reason to do it that way).
>>>>>>>
>>>>>>
>>>>>> Yes, that's how I read code as well. btrfs layer that does checksumming
>>>>>> is unaware of parity blocks at all; for all practical purposes they do
>>>>>> not exist. What happens is approximately
>>>>>>
>>>>>> 1. logical extent is allocated and checksum computed
>>>>>> 2. it is mapped to physical area(s) on disks, skipping over what would
>>>>>> be parity blocks
>>>>>> 3. when these areas are written out, RAID56 parity is computed and filled in
>>>>>>
>>>>>> IOW btrfs checksums are for (meta)data and RAID56 parity is not data.
>>>>>
>>>>>    Checksums are not parity, correct. However, every data block
>>>>> (including, I think, the parity) is checksummed and put into the csum
>>>>> tree. This allows the FS to determine where damage has occurred,
>>>>> rather thansimply detecting that it has occurred (which would be the
>>>>> case if the parity doesn't match the data, or if the two copies of a
>>>>> RAID-1 array don't match).
>>>>>
>>>>
>>>> Yes, that is what I wrote below. But that means that RAID5 with one
>>>> degraded disk won't be able to reconstruct data on this degraded disk
>>>> because reconstructed extent content won't match checksum. Which kinda
>>>> makes RAID5 pointless.
>>>
>>>    Eh? How do you come to that conclusion?
>>>
>>>    For data, say you have n-1 good devices, with n-1 blocks on them.
>>> Each block has a checksum in the metadata, so you can read that
>>> checksum, read the blocks, and verify that they're not damaged. From
>>> those n-1 known-good blocks (all data, or one parity and the rest
>>
>> We do not know whether parity is good or not because as far as I can
>> tell parity is not checksummed.
>
>    I was about to write a devastating rebuttal of this... then I
> actually tested it, and holy crap you're right.
>
>    I've just closed the terminal in question by accident, so I can't
> copy-and-paste, but the way I checked was:
>
> # mkfs.btrfs -mraid1 -draid5 /dev/loop{0,1,2}
> # mount /dev/loop0 foo
> # dd if=/dev/urandom of=foo/file bs=4k count=32
> # umount /dev/loop0
> # btrfs-debug-tree /dev/loop0
>
> then look at the csum tree:
>
>      item 0 key (EXTENT_CSUM EXTENT_CSUM 351469568) itemoff 16155 itemsize 128
>      	  extent csum item
>
> There is a single csum item in it, of length 128. At 4 bytes per csum,
> that's 32 checksums, which covers the 32 4KiB blocks I wrote, leaving
> nothing for the parity.
>
>    This is fundamentally broken, and I think we need to change the
> wiki to indicate that the parity RAID implementation is not
> recommended, because it doesn't actually do the job it's meant to in a
> reliable way. :(
>
So item 4 now then, together with:
1. Rebuilds seemingly randomly decide based on the filesystem whether or 
not to take an insanely long time (always happens on some arrays, never 
happens on others, I have yet to see a report where it happens 
intermittently).
2. Failed disks seem to occasionally cause irreversible data corruption.
3. Classic erasure-code write-hole, just slightly different because of COW.

TBH, as much as I hate to say this, it looks like the raid5/6 code needs 
redone from scratch.  At an absolute minimum, we need to put a warning 
in mkfs for people using raid5/6 to tell them they shouldn't be using it 
outside of testing.
