Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37490 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdFSOUv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 10:20:51 -0400
Received: by mail-it0-f45.google.com with SMTP id m47so58372986iti.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 07:20:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a194375b-f0e5-8f90-b001-83cb40fbd957@cn.fujitsu.com>
References: <CAPmG0jb=tokuCxBe6U3Rg+36X-70ptC2bhWx23e38ZxUjTgM4A@mail.gmail.com>
 <20170613072420.17314dbb@jupiter.sol.kaishome.de> <CAPmG0jbVju+S=jqmk+qr8L4MMe-5NirFVV8R7VQeczGjE=6Waw@mail.gmail.com>
 <CAPmG0jaVbfoL8-PpDT-=B+w_JH9H4ukJQm5UUkZFRKS6uSAs+Q@mail.gmail.com> <a194375b-f0e5-8f90-b001-83cb40fbd957@cn.fujitsu.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 19 Jun 2017 16:20:49 +0200
Message-ID: <CAPmG0jbjRODBLSCYBhZYxYZjFQAZjOzuy3HppmC-gjyEqv358Q@mail.gmail.com>
Subject: Re: csum failed root -9
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 15, 2017 at 9:13 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 06/14/2017 09:39 PM, Henk Slager wrote:
>>
>> On Tue, Jun 13, 2017 at 12:47 PM, Henk Slager <eye1tm@gmail.com> wrote:
>>>
>>> On Tue, Jun 13, 2017 at 7:24 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
>>>>
>>>> Am Mon, 12 Jun 2017 11:00:31 +0200
>>>> schrieb Henk Slager <eye1tm@gmail.com>:
>>>>
>>>>> Hi all,
>>>>>
>>>>> there is 1-block corruption a 8TB filesystem that showed up several
>>>>> months ago. The fs is almost exclusively a btrfs receive target and
>>>>> receives monthly sequential snapshots from two hosts but 1 received
>>>>> uuid. I do not know exactly when the corruption has happened but it
>>>>> must have been roughly 3 to 6 months ago. with monthly updated
>>>>> kernel+progs on that host.
>>>>>
>>>>> Some more history:
>>>>> - fs was created in november 2015 on top of luks
>>>>> - initially bcache between the 2048-sector aligned partition and luks.
>>>>> Some months ago I removed 'the bcache layer' by making sure that cache
>>>>> was clean and then zeroing 8K bytes at start of partition in an
>>>>> isolated situation. Then setting partion offset to 2064 by
>>>>> delete-recreate in gdisk.
>>>>> - in december 2016 there were more scrub errors, but related to the
>>>>> monthly snapshot of december2016. I have removed that snapshot this
>>>>> year and now only this 1-block csum error is the only issue.
>>>>> - brand/type is seagate 8TB SMR. At least since kernel 4.4+ that
>>>>> includes some SMR related changes in the blocklayer this disk works
>>>>> fine with btrfs.
>>>>> - the smartctl values show no error so far but I will run an extended
>>>>> test this week after another btrfs check which did not show any error
>>>>> earlier with the csum fail being there
>>>>> - I have noticed that the board that has the disk attached has been
>>>>> rebooted due to power-failures many times (unreliable power switch and
>>>>> power dips from energy company) and the 150W powersupply is broken and
>>>>> replaced since then. Also due to this, I decided to remove bcache
>>>>> (which has been in write-through and write-around only).
>>>>>
>>>>> Some btrfs inpect-internal exercise shows that the problem is in a
>>>>> directory in the root that contains most of the data and snapshots.
>>>>> But an  rsync -c  with an identical other clone snapshot shows no
>>>>> difference (no writes to an rw snapshot of that clone). So the fs is
>>>>> still OK as file-level backup, but btrfs replace/balance will fatal
>>>>> error on just this 1 csum error. It looks like that this is not a
>>>>> media/disk error but some HW induced error or SW/kernel issue.
>>>>> Relevant btrfs commands + dmesg info, see below.
>>>>>
>>>>> Any comments on how to fix or handle this without incrementally
>>>>> sending all snapshots to a new fs (6+ TiB of data, assuming this won't
>>>>> fail)?
>>>>>
>>>>>
>>>>> # uname -r
>>>>> 4.11.3-1-default
>>>>> # btrfs --version
>>>>> btrfs-progs v4.10.2+20170406
>>>>
>>>>
>>>> There's btrfs-progs v4.11 available...
>>>
>>>
>>> I started:
>>> # btrfs check -p --readonly /dev/mapper/smr
>>> but it stopped with printing 'Killed' while checking extents. The
>>> board has 8G RAM, no swap (yet), so I just started lowmem mode:
>>> # btrfs check -p --mode lowmem --readonly /dev/mapper/smr
>>>
>>> Now after a 1 day 77 lines like this are printed:
>>> ERROR: extent[5365470154752, 81920] referencer count mismatch (root:
>>> 6310, owner: 1771130, offset: 33243062272) wanted: 1, have: 2
>>>
>>> It is still running, hopefully it will finish within 2 days. But
>>> lateron I can compile/use latest progs from git. Same for kernel,
>>> maybe with some tweaks/patches, but I think I will also plug the disk
>>> into a faster machine then ( i7-4770 instead of the J1900 ).
>>>
>>>>> fs profile is dup for system+meta, single for data
>>>>>
>>>>> # btrfs scrub start /local/smr
>>>>
>>>>
>>>> What looks strange to me is that the parameters of the error reports
>>>> seem to be rotated by one... See below:
>>>>
>>>>> [27609.626555] BTRFS error (device dm-0): parent transid verify failed
>>>>> on 6350718500864 wanted 23170 found 23076
>>>>> [27609.685416] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350718500864 (dev /dev/mapper/smr sector 11681212672)
>>>>> [27609.685928] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350718504960 (dev /dev/mapper/smr sector 11681212680)
>>>>> [27609.686160] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350718509056 (dev /dev/mapper/smr sector 11681212688)
>>>>> [27609.687136] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350718513152 (dev /dev/mapper/smr sector 11681212696)
>>>>> [37663.606455] BTRFS error (device dm-0): parent transid verify failed
>>>>> on 6350453751808 wanted 23170 found 23075
>>>>> [37663.685158] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350453751808 (dev /dev/mapper/smr sector 11679647008)
>>>>> [37663.685386] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350453755904 (dev /dev/mapper/smr sector 11679647016)
>>>>> [37663.685587] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350453760000 (dev /dev/mapper/smr sector 11679647024)
>>>>> [37663.685798] BTRFS info (device dm-0): read error corrected: ino 1
>>>>> off 6350453764096 (dev /dev/mapper/smr sector 11679647032)
>>>>
>>>>
>>>> Why does it say "ino 1"? Does it mean devid 1?
>>>
>>>
>>> On a 3-disk btrfs raid1 fs I see in the journal also "read error
>>> corrected: ino 1" lines for all 3 disks. This was with a 4.10.x
>>> kernel, ATM I don't know if this is right or wrong.
>>>
>>>>> [43497.234598] BTRFS error (device dm-0): bdev /dev/mapper/smr errs:
>>>>> wr 0, rd 0, flush 0, corrupt 1, gen 0
>>>>> [43497.234605] BTRFS error (device dm-0): unable to fixup (regular)
>>>>> error at logical 7175413624832 on dev /dev/mapper/smr
>>>>>
>>>>> # < figure out which chunk with help of btrfs py lib >
>>>>>
>>>>> chunk vaddr 7174898057216 type 1 stripe 0 devid 1 offset 6696948727808
>>>>> length 1073741824 used 1073741824 used_pct 100
>>>>> chunk vaddr 7175971799040 type 1 stripe 0 devid 1 offset 6698022469632
>>>>> length 1073741824 used 1073741824 used_pct 100
>>>>>
>>>>> # btrfs balance start -v
>>>>> -dvrange=7174898057216..7174898057217 /local/smr
>>>>>
>>>>> [74250.913273] BTRFS info (device dm-0): relocating block group
>>>>> 7174898057216 flags data
>>>>> [74255.941105] BTRFS warning (device dm-0): csum failed root -9 ino
>>>>> 257 off 515567616 csum 0x589cb236 expected csum 0xee19bf74 mirror 1
>>>>> [74255.965804] BTRFS warning (device dm-0): csum failed root -9 ino
>>>>> 257 off 515567616 csum 0x589cb236 expected csum 0xee19bf74 mirror 1
>
>
> Root -9 is data relocation tree, which is used for relocation.

Ok, then I can understand the negative sign.

> I'm not sure if both lowmem and original mode fsck can handle it well as the
> tree only exists for a short time.
>
> I think the problem is not for data relocation tree it self, but the
> original data on that disk, no longer matches its checksum.
> Relocation (balance) is just trying to read that data out, going through
> normal csum check, but found it wrong.
>
> The real data is at logical bytenr (7174898057216 + 515567616).
>
> Scrub should output the file related to that logical bytenr, but I saw
> strange transid error, and even more strangely the read error is fixed up.

I used balance just for 1 1G-chunk to trigger a csum failure message
from the kernel, as I was (and am not) able to figure out what file or
user data is on the logical bytenr (7174898057216 + 515567616).

I must say I have seen this before on a 4TB filesystem, so doing a
scrub but no indication from kernel what file was affected. But on
that filesystem also 20KiB with csum error that were clearly
identified in kernel dmesg by file path (shared multiple snapshots).
Some time later, after old snapshot removal and new scrub, only the
20KiB with csum error were left there.

>>>> And why does it say "root -9"? Shouldn't it be "failed -9 root 257 ino
>>>> 515567616"? In that case the "off" value would be completely missing...
>>>>
>>>> Those "rotations" may mess up with where you try to locate the error on
>>>> disk...
>>>
>>>
>>> I hadn't looked at the numbers like that, but as you indicate, I also
>>> think that the 1-block csum fail location is bogus because the kernel
>>> calculates that based on some random corruption in critical btrfs
>>> structures, also looking at the 77 referencer count mismatches. A
>>> negative root ID is already a sort of red flag. When I can mount the
>>> fs again after the check is finished, I can hopefully use the output
>>> of the check to get clearer how big the 'damage' is.
>>
>>
>> The btrfs lowmem mode check ends with:
>>
>> ERROR: root 7331 EXTENT_DATA[928390 3506176] shouldn't be hole
>> ERROR: errors found in fs roots
>> found 6968612982784 bytes used, error(s) found
>> total csum bytes: 6786376404
>> total tree bytes: 25656016896
>> total fs tree bytes: 14857535488
>> total extent tree bytes: 3237216256
>> btree space waste bytes: 3072362630
>> file data blocks allocated: 38874881994752
>>   referenced 36477629964288
>>
>> In total 2000+ of those "shouldn't be hole" lines.
>>
>> A non-lowmem check, now done with kernel 4.11.4 and progs v4.11 and
>> 16G swap added ends with 'noerrors found'
>
>
> Well, at least metadata seems valid.
>
>>
>> W.r.t. holes, maybe it is woth to mention the super-flags:
>> incompat_flags          0x369
>>                          ( MIXED_BACKREF |
>>                            COMPRESS_LZO |
>>                            BIG_METADATA |
>>                            EXTENDED_IREF |
>>                            SKINNY_METADATA |
>>                            NO_HOLES )
>
>
> There maybe another corner case for NO_HOLES, I should double check the hole
> check for lowmem and add test case for it.

With the patch you created applied, "shouldn't be hole" is gone in
lowmem mode, but the "referencer count mismatch" error messages are
still there. In normal more, no error at all is reported.

> Maybe the hole check is too restrict, as NO_HOLES allow holes exists.
> (That's why I hate btrfs allowing users to modify their incompat flags so
> that we must support both old and new behavior in the same fs)

I now wish I hadn't changed that flag, but for some case (a 17TB
btrfs-image of a broken fs) on btrfs on SSD, I saw that it made a
difference and it looked to be a good speedup, also for bcached-btrfs.
This was with kernel at least before 4.8, 4.5 or so. But for 25GB
images for Virtualbox, with initially half of it holes, the big speed
difference is comming from SSD caching of a btrfs fs on HDD. Due to
the bug mentioned below, I ran into space and speed troubles, so I
modified btrfstune.c such that it can toggle NO_HOLES flag. I realize
that it is tricky, but recreating multi-TB filesystems with rather
complex subvolume setup is also tricky and so far, the other
filesystems that have undergone this NO_HOLES flag toggle are running
fine.

>> The fs has received snapshots from source fs that had NO_HOLES enabled
>> for some time, but after registed this bug:
>> https://bugzilla.kernel.org/show_bug.cgi?id=121321
>> I put back that NO_HOLES flag to zero on the source fs. It seems I
>> forgot to do that on the 8TB target/backup fs. But I don't know if
>> there is a relation between this flag flipping and the btrfs check
>> error messages.
>>
>> I think I leave it as is for the time being, unless there is some news
>> how to fix things with low risk (or maybe via a temp overlay snapshot
>> with DM). But the lowmem check took 2 days, that's not really fun.
>
>
> That's a trade between IO and memory.
> Just as you could see, without extra swap, original mode just get killed due
> to OOM.
>
> Unlike original mode, which reads out all metadata by sequence and record
> some important info into memory, lowmem doesn't record anything in memory,
> just searching on-disk to minimize memory usage.
>
> And with that behavior, lowmem mode is causing tons of random IO, some of
> them are even duplicated (searching the same tree for several times).
>
> I'm afraid the  time consumption can not be solved easily.
> (Well, adding swap for original mode is another solution anyway)

It is clear that for mechanical disk and re-reading stuff from disk
total check time is much longer. I basically just wanted to use it to
experience it, although I saw later that I had already shrunk the main
partition and created swapspace from that, but it was default off in
fstab.

For normal mode, I saw ~2G swapspace used in addition to the 8G RAM
usage and it took about 2 hours. In this case, and for the size of
btrfs filesystems I have, I prefer freeing some SSD space for swap
partition instead of using lowmem mode. This 8TB filesystem has a
monthly cycle so lowmem is no problem, but others a daily, so more
than ~16hours offline would need workarounds in scripts etc.
