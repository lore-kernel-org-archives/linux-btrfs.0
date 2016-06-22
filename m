Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36603 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbcFVROd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 13:14:33 -0400
Received: by mail-oi0-f50.google.com with SMTP id f189so32006015oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 10:14:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160621015559.GM15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org> <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org> <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Jun 2016 11:14:30 -0600
Message-ID: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 7:55 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Jun 20, 2016 at 03:27:03PM -0600, Chris Murphy wrote:
>> On Mon, Jun 20, 2016 at 2:40 PM, Zygo Blaxell
>> <ce3g8jdj@umail.furryterror.org> wrote:
>> > On Mon, Jun 20, 2016 at 01:30:11PM -0600, Chris Murphy wrote:
>>
>> >> For me the critical question is what does "some corrupted sectors" mean?
>> >
>> > On other raid5 arrays, I would observe a small amount of corruption every
>> > time there was a system crash (some of which were triggered by disk
>> > failures, some not).
>>
>> What test are you using to determine there is corruption, and how much
>> data is corrupted? Is this on every disk? Non-deterministically fewer
>> than all disks? Have you identified this as a torn write or
>> misdirected write or is it just garbage at some sectors? And what's
>> the size? Partial sector? Partial md chunk (or fs block?)
>
> In earlier cases, scrub, read(), and btrfs dev stat all reported the
> incidents differently.  Scrub would attribute errors randomly to disks
> (error counts spread randomly across all the disks in the 'btrfs scrub
> status -d' output).  'dev stat' would correctly increment counts on only
> those disks which had individually had an event (e.g. media error or
> SATA bus reset).
>
> Before deploying raid5, I tested these by intentionally corrupting
> one disk in an otherwise healthy raid5 array and watching the result.

It's difficult to reproduce if no one understands how you
intentionally corrupted that disk. Literal reading, you corrupted the
entire disk, but that's impractical. The fs is expected to behave
differently depending on what's been corrupted and how much.

> When scrub identified an inode and offset in the kernel log, the csum
> failure log message matched the offsets producing EIO on read(), but
> the statistics reported by scrub about which disk had been corrupted
> were mostly wrong.  In such cases a scrub could repair the data.

I don't often use the -Bd options, so I haven't tested it thoroughly,
but what you're describing sounds like a bug in user space tools. I've
found it reflects the same information as btrfs dev stats, and dev
stats have been reliable in my testing.


> A different thing happens if there is a crash.  In that case, scrub cannot
> repair the errors.  Every btrfs raid5 filesystem I've deployed so far
> behaves this way when disks turn bad.  I had assumed it was a software bug
> in the comparatively new raid5 support that would get fixed eventually.

This is really annoyingly vague. You don't give a complete recipe for
reproducing this sequence. Here's what I'm understanding and what I'm
missing:

1. The intentional corruption, extent of which is undefined, is still present.
2. A drive is bad, but that doesn't tell us if it's totally dead, or
only intermittently spitting out spurious information.
3. Is the volume remounted degraded or is the bad drive still being
used by Btrfs? Because Btrfs has no concept (patches pending) of drive
faulty state like md, let alone an automatic change to that faulty
state. It just keeps on trying to read or write to bad drives, even if
they're physically removed.
4. You've initiated a scrub, and the corruption in 1 is not fixed.

OK so what am I missing?

Because it sounds to me like you have two copies of data that are
gone. For raid 5 that's data loss, scrub can't fix things. Corruption
is missing data. The bad drive is missing data.

What values do you get for

smartctl -l scterc /dev/sdX
cat /sys/block/sdX/device/timeout



>> This is on Btrfs? This isn't supposed to be possible. Even a literal
>> overwrite of a file is not an overwrite on Btrfs unless the file is
>> nodatacow. Data extents get written, then the metadata is updated to
>> point to those new blocks. There should be flush or fua requests to
>> make sure the order is such that the fs points to either the old or
>> new file, in either case uncorrupted. That's why I'm curious about the
>> nature of this corruption. It sounds like your hardware is not exactly
>> honoring flush requests.
>
> That's true when all the writes are ordered within a single device, but
> possibly not when writes must be synchronized across multiple devices.

I think that's a big problem, the fs cannot be consistent if the super
block points to any tree whose metadata or data isn't on stable media.

But if you think it's happening you might benefit from integrity
checking, maybe try just the metadata one for starters which is the
check_int mount option (it must be compiled in first for that mount
option to work).

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/fs/btrfs/check-integrity.c?id=refs/tags/v4.6.2



> It could be possible to corrupt existing data if:
>
>         - btrfs puts multiple extents in the same RAID5 stripe
>
>         - writes two of the extents in different transactions
>
>         - the array is degraded so the RAID5 write hole applies
>
>         - writes stop (crash, powerfail, etc) after updating some of
>         the blocks in the stripe but not others in the second transaction.

I do not know the exact nature of the Btrfs raid56 write hole. Maybe a
dev or someone who knows can explain it.

However, from btrfs-debug-tree from a 3 device raid5 volume:

item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 15621 itemsize 144
chunk length 2147483648 owner 2 stripe_len 65536
type DATA|RAID5 num_stripes 3
stripe 0 devid 2 offset 9437184
dev uuid: 3c6f37eb-5cae-455a-82bc-a1b0877dea55
stripe 1 devid 1 offset 1094713344
dev uuid: 13104709-6f30-4982-979e-4f055c326fad
stripe 2 devid 3 offset 1083179008
dev uuid: d45fc482-a0c1-46b1-98c1-41cea5a11c80

I expect that parity is in this data block group, and therefore is
checksummed the same as any other data in that block group. While
parity could become stale like with conventional raid5, unlike
conventional raid 5, Btrfs would know about this because there'd be a
checksum mismatch.

So in your example of degraded writes, no matter what the on disk
format makes it discoverable there is a problem:

A. The "updating" is still always COW so there is no overwriting.

B. The updated data extent is supposed to be on stable media before
both metadata pointing to it and including its checksum (in the extent
csum tree) are on stable media. Perhaps it's acceptable for certain
metadata could be written out of order with data? But certainly not
the superblock being updated to point to updates trees that haven't
actually been set to stable media yet.

But even if that were to happen due to some hardware bug, the fs can
figure this out at mount time as it boot straps itself from the super,
and will then fail to mount. This is what -o recovery  (now
usebackuproot in newer kernels) is used for; so that in effect the fs
is rolled back to a state where the super points to completely valid
roots. But these mount options are considered red flags for hardware
doing the wrong thing. Yes you lose some data, which is bad anyway due
to writes being interrupted during an oops, but at least the fs is OK.



> This corrupts the data written in the first transaction, unless there's
> something in btrfs that explicitly prevents this from happening (e.g.
> the allocator prevents the second step, which would seem to burn up a
> lot of space).

I don't follow your steps how the data in the first transaction is
corrupt. Everything is copy on write in Btrfs including raid5. So that
new transaction does not overwrite the first, it's a new write, and
what should happen is that data gets written to unused sectors, then
metadata is written to point to those sectors (chunk tree, dev tree,
extent tree, csum tree, fs tree, etc), and once that's on stable
media, then the superblock is updated. There are all kinds of
optimizations happening that probably allow some of those things to
happen in different order depending on what's going on, and then the
drive also will reorder those writes, but when Btrfs issues req_flush
to the drive before it writes an updated superblock, and the drive
lies that it has flushed when it hasn't? That's when problems happen.

And perhaps naively, I'd expect in any multiple device volume, that
Btrfs issues req_flush right before and after it updates supers on all
the drives. If that's really honored by the drive, then the writing of
supers doesn't happen until everything before the req_flush is
actually on stable media.

The very fact you're not getting mount failures tells me all the
supers on all the drives must be the same, or Btrfs would complain.
There are generally at least three super blocks on each drive, and
each super has four backup roots. So that's 15 opportunities per drive
to determine right off the bat if something is really screwy, and just
fail to mount.

But you're not seeing mount failure. I think something else is going
on. Possibly there was already some weird corruption before either
your intentional corruption or the bad drive happened.


> The filesystem would continue to work afterwards with raid1 metadata
> because every disk in raid1 updates its blocks in the same order,
> and there are no interdependencies between blocks on different disks
> (not like a raid5 stripe, anyway).

I'm not sure what you mean by this. Btrfs raid1 means two copies. It
doesn't matter how many drives there are, there are two copies of
metadata in your case, and you have no idea which drives those
metadata block groups are on without checking btrfs-debug-tree.


>
> Excluding the current event, this only happened to me when the disks
> were doing other questionable things, like SATA link resets or dropping
> off the SATA bus, so there could have been an additional hardware issue.

Link resets are bad. There's bad hardware, bad cable, or highly likely
and common is bad sectors plus a misconfiguration of drive error
recovery and the SCSI command timer.


> This does happen on _every_ raid5 deployment I've run so far, though,
> and they don't share any common hardware or firmware components.

Misconfigurations in raid 5 are default. I've mentioned this before on
this list. And linux-raid@ list is full of such problem. It's pretty
much a weekly occurrence someone loses all data on a raid5 array due
to this very common misconfiguration.


> I've met many btrfs users on IRC but never one with a successful raid56
> recovery story.  Give me a shout on IRC if you have one.  ;)

You'd have to check the archives, they do exist. But typically by the
time they're on this list, the problems are too far gone. It's also
very common on linux-raid@. The issue is people treat their arrays
like they're backups or like they're permission to delay backup
frequency, rather than treating them for the sole purpose they're
intended for which is to extend uptime in the face of a *single*
hardware failure, specifically one drive. The instant there are two
problems, implosion is almost certain.


-- 
Chris Murphy
