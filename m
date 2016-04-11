Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35254 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcDKLeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 07:34:03 -0400
Received: by mail-lf0-f54.google.com with SMTP id c126so152421749lfb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 04:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJr-KHbpgDjCaLwFR29c_X8kn3gDQ+OhL9sKi+T13a3b6w@mail.gmail.com>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
	<CAPmG0jaxZY1d365KGy=HL+e7WNyZ7w6jtT2VJod00KD=JBC=ng@mail.gmail.com>
	<CALJXSJpSsxES=SvtscJYCy7J1V37=rhXfWg1DjqU3XpkzJ-M6A@mail.gmail.com>
	<CAPmG0jbYGBuDah_PvhzPVSdotqkGnO43Y3yi2ZYj94r+f9mt5w@mail.gmail.com>
	<CALJXSJr-KHbpgDjCaLwFR29c_X8kn3gDQ+OhL9sKi+T13a3b6w@mail.gmail.com>
Date: Mon, 11 Apr 2016 13:34:00 +0200
Message-ID: <CAPmG0jbC8Bc8+bnDcU1vyWUwd2zqotPU8mQcN45F3Hm3prA7eQ@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: Henk Slager <eye1tm@gmail.com>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 11, 2016 at 3:48 AM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> Sorry for the confusion, allow me to clarify and I will summarize with
> what I learned since I now understand that corruption was present
> before disk went bad.
>
> Note that this BTRFS was once on a MD RAID5 on LVM on LUKS before
> being moved in-place to LVM on LUKS on BTRFS RAID10. But since balance
> worked at the time.

I haven't used LVM for years, but those in-place actions normally work
if size calculations etc are correct. Otherwise you would know
immediately.

> Also note that this computer was booted twice for about 30 minutes
> period with bad ram before it was replaced.

This is very important info. It is clear now that there was bad memory
and that it is just half an hour.

> I think my checksums errors were present, but unknown to me, before
> the hardware disk failure. The bad memory might be the root cause of
> this problem but I can't be sure.

When I look at all the info now and also think of my own experience
with bad ram module and btrfs, I think this bad memory is the root
cause. I have seen btrfs RAID10 correcting a few errors (likely coming
from earlier crashes with btrfs RAID5 on older disks). If it can't
correct, there is something else wrong and likely affecting more
devices than the RAID profile is able to correct.

> On Sun, Apr 10, 2016 at 1:25 PM, Henk Slager <eye1tm@gmail.com> wrote:
>> It was not fully clear what the sequence of events were:
>> - HW problem
>> - btrfs SW problem
>> - 1st scrub
>> - the --repair-sector with hdparm
>> - 2nd scrub
>> - 3rd scrub?
>>
>
> 1. Errors in dmesg and confirmation from smartd that hardware problems
> were present.
> 2. Attempt to repair sector using --repair-sector which reset the
> sector to zeroes.
> 3. Scrub detected errors and fixed some but there were 18 uncorrectable.
> 4. Disk has been changed using btrfs replace. Corruption still present.
> 5. Balance attempted but aborts when encountering the first uncorrectable error.
> 6. Tentative to locate bad sector/inode without success leading to
> another scrub with the same errors.
> 7. Attempt to reset stats and scrub again. Still getting the same errors.
> 8. New disk added and data profile converted from RAID10 to RAID1,
> balance abort on first uncorrectable error.
>
>
>> There is also DM between the harddisk and btrfs and I am not sure if
>> whether the hdparm action did repair or further corrupt things.
>>
>
> I confirmed after using --repair-sector that the sector has been reset
> to zeroes using --read-sector. I also tried read-sector first which
> failed and added an entry to the SMART log. After repair-sector,
> read-sector returned the zeroed sector.
>
>> How do you know for sure that the contents of the 'logical blocks' are
>> the same on both devices?
>>
>
> After a balance, here is what dmesg shows (complete warning output):
> BTRFS warning (device dm-36): csum failed ino 330 off 1809084416 csum
> 4147641019 expected csum 1755301217
> BTRFS warning (device dm-36): csum failed ino 330 off 1809195008 csum
> 1515428513 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809199104 csum
> 1927504681 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809211392 csum
> 3086571080 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809149952 csum
> 3254083717 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809162240 csum
> 3157020538 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809166336 csum
> 1092724678 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809178624 csum
> 4235459038 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809182720 csum
> 1764946502 expected csum 2566472073
> BTRFS warning (device dm-36): csum failed ino 330 off 1809084416 csum
> 4147641019 expected csum 1755301217
>
>
> After a scrub (complete error output):
> BTRFS error (device dm-36): bdev /dev/dm-32 errs: wr 0, rd 0, flush 0,
> corrupt 1, gen 0
> BTRFS error (device dm-36): bdev /dev/dm-32 errs: wr 0, rd 0, flush 0,
> corrupt 2, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334876672 on dev /dev/dm-32
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334987264 on dev /dev/dm-32
> BTRFS error (device dm-36): bdev /dev/dm-32 errs: wr 0, rd 0, flush 0,
> corrupt 3, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334991360 on dev /dev/dm-32
> BTRFS error (device dm-36): bdev /dev/dm-32 errs: wr 0, rd 0, flush 0,
> corrupt 4, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296335003648 on dev /dev/dm-32
> BTRFS error (device dm-36): bdev /dev/dm-36 errs: wr 0, rd 0, flush 0,
> corrupt 1, gen 0
> BTRFS error (device dm-36): bdev /dev/dm-36 errs: wr 0, rd 0, flush 0,
> corrupt 2, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334876672 on dev /dev/dm-36
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334987264 on dev /dev/dm-36
> BTRFS error (device dm-36): bdev /dev/dm-36 errs: wr 0, rd 0, flush 0,
> corrupt 3, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334991360 on dev /dev/dm-36
> BTRFS error (device dm-36): bdev /dev/dm-36 errs: wr 0, rd 0, flush 0,
> corrupt 4, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296335003648 on dev /dev/dm-36
> BTRFS error (device dm-36): bdev /dev/dm-35 errs: wr 0, rd 0, flush 0,
> corrupt 1, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334942208 on dev /dev/dm-35
> BTRFS error (device dm-36): bdev /dev/dm-35 errs: wr 0, rd 0, flush 0,
> corrupt 2, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334954496 on dev /dev/dm-35
> BTRFS error (device dm-36): bdev /dev/dm-35 errs: wr 0, rd 0, flush 0,
> corrupt 3, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334958592 on dev /dev/dm-35
> BTRFS error (device dm-36): bdev /dev/dm-35 errs: wr 0, rd 0, flush 0,
> corrupt 4, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334970880 on dev /dev/dm-35
> BTRFS error (device dm-36): bdev /dev/dm-35 errs: wr 0, rd 0, flush 0,
> corrupt 5, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334974976 on dev /dev/dm-35
> BTRFS error (device dm-36): bdev /dev/dm-34 errs: wr 0, rd 0, flush 0,
> corrupt 1, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334942208 on dev /dev/dm-34
> BTRFS error (device dm-36): bdev /dev/dm-34 errs: wr 0, rd 0, flush 0,
> corrupt 2, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334954496 on dev /dev/dm-34
> BTRFS error (device dm-36): bdev /dev/dm-34 errs: wr 0, rd 0, flush 0,
> corrupt 3, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334958592 on dev /dev/dm-34
> BTRFS error (device dm-36): bdev /dev/dm-34 errs: wr 0, rd 0, flush 0,
> corrupt 4, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334970880 on dev /dev/dm-34
> BTRFS error (device dm-36): bdev /dev/dm-34 errs: wr 0, rd 0, flush 0,
> corrupt 5, gen 0
> BTRFS error (device dm-36): unable to fixup (regular) error at logical
> 1296334974976 on dev /dev/dm-34
>
> device stats:
> [/dev/mapper/luksbtrfsdata1 /dev/dm-32].corruption_errs 4
> [/dev/mapper/luksbtrfsdata6 /dev/dm-36].corruption_errs 4
> [/dev/mapper/luksbtrfsdata3 /dev/dm-34].corruption_errs 5
> [/dev/mapper/luksbtrfsdata2 /dev/dm-33].corruption_errs 0
> [/dev/mapper/luksbtrfsdata5 /dev/dm-35].corruption_errs 5
> [/dev/mapper/luksbtrfsdata7 /dev/dm-48].corruption_errs 0
>
>
>
> If we combine everything, we notice that...
> * dm-32 and dm-36 have the same number of uncorrectable errors.
> * dm-34 and dm-35 have the same number of uncorrectable errors.
> * Scrub output is not helpful at identifying checksum errors. Balance
> output is not useful at identifying the physical device.
> * Scrub output confirms where the errors are and each logical sector
> appear twice on different devices.
> * Balance output also shows each offset twice with VERY suspicious
> expected checksums.
>
> A wild guess would be that memory corruption caused the checksums to
> be incorrectly written to disk.

As indicated, this is the most obvious reason. I looks like basic RAID
could not do its work as all (2 in this case) block copies got
corrupted.

What I think is that the corruptions are outside the data objects. And
unfortunately difficult to fix (e.g. by doing some file-level
modifications) I think. That balance fails is not good, it also means
that some other action on chunk-level would also fail, so removing a
device for example might not be possible to complete. You'll have to
see if you can avoid re-creation of the fs I think.

It doesn't seem to be a bug in btrfs, but one thing you might try,
just to see if you can fix it without using backup, is to hack the
kernel so that it skips over the checksum error cases in a first step
and then in next step let it correct again hoping that CoW has helped
you. But maybe someone else sees a quick way to fix it.

>> If btrfs wants to read a diskblock and its csum doesn't match, then it
>> is an I/O error, same effect as an uncorrected badsector in the old
>> days. But in this case your (former/old) disk might still be OK, as
>> you suggest it might be due to some other error (HW or SW) that
>> content and csum don't match. It is hard to traceback based on the
>> info in the email thread. It looks like replace just copied the
>> problem and it seems a bottleneck now on filesystem level.
>>
>
> It seems like btrfs replace did indeed just copy the problem as-is,
> which is good since I could not have removed the old defective disk
> otherwise.
>
>>> Is it possible to reset the checksum on those? I couldn't find what
>>> file or metadata the blocks were pointing too.
>>
>> Could it be that they in the meantime have been removed?
>> It might be that you again need to run scrub in order to try to find
>> the problem spot/files.
>>
>
> Scrub / inspect-internal didn't help me find the file or metadata.
> Even crazy commands like:
> btrfs sub li /mnt/btrfs/ | cut -d' ' -f9 | xargs -n1 btrfs inspect
> logical-resolve -v 1296334991360
>
> I tried and md5sum'ed every files in the output with no known
> problems, no I/O errors.
>
>> Fixing individual csum's has been asked before, I don't remember if
>> there are people who did fix them by own extra scripts/C-code or
>> whatever. A brute force method is to recalculate and rewrite all
>> csums:  btrfs check --init-csum-tree , you probably know that. But
>> maybe you want a rsync -c compare with backups first. Kernel/tools
>> versions and btrfs fi us output might also give some hints.
>
> I though about using init-csum-tree but you are right, that wouldn't
> allow to identify the problem and which files/meta are affected.
>
> Here is the requested output:
>
> btrfs fi us /mnt/btrfs/
> Overall:
>     Device size:           6.32TiB
>     Device allocated:           1.28TiB
>     Device unallocated:           5.04TiB
>     Device missing:             0.00B
>     Used:               1.27TiB
>     Free (estimated):           2.52TiB    (min: 2.52TiB)
>     Data ratio:                  2.00
>     Metadata ratio:              2.00
>     Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,RAID1: Size:76.00GiB, Used:74.13GiB
>    /dev/dm-32      52.00GiB
>    /dev/dm-36      24.00GiB
>    /dev/dm-48      76.00GiB
>
> Data,RAID10: Size:576.00GiB, Used:575.99GiB
>    /dev/dm-32     105.00GiB
>    /dev/dm-33     117.50GiB
>    /dev/dm-34     118.00GiB
>    /dev/dm-35     118.00GiB
>    /dev/dm-36     117.50GiB
>
> Metadata,RAID10: Size:3.09GiB, Used:1.68GiB
>    /dev/dm-32     528.00MiB
>    /dev/dm-33     528.00MiB
>    /dev/dm-34     528.00MiB
>    /dev/dm-35     528.00MiB
>    /dev/dm-36     528.00MiB
>    /dev/dm-48     528.00MiB
>
> System,RAID10: Size:96.00MiB, Used:112.00KiB
>    /dev/dm-32      16.00MiB
>    /dev/dm-33      16.00MiB
>    /dev/dm-34      16.00MiB
>    /dev/dm-35      16.00MiB
>    /dev/dm-36      16.00MiB
>    /dev/dm-48      16.00MiB
>
> Unallocated:
>    /dev/dm-32       2.35TiB
>    /dev/dm-33     161.97GiB
>    /dev/dm-34     161.47GiB
>    /dev/dm-35     161.47GiB
>    /dev/dm-36       1.36TiB
>    /dev/dm-48       1.42TiB
