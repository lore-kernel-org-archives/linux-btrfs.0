Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35288 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938676AbcLWMny (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 07:43:54 -0500
Received: by mail-io0-f193.google.com with SMTP id f73so32008163ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 04:43:54 -0800 (PST)
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
To: Adam Borowski <kilobyte@angband.pl>
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
 <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>
 <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
 <pan$67936$e25a272c$77926cea$931807ed@cox.net>
 <20161222151425.ecryyvnz2feaygrr@angband.pl>
 <67d0fb6f-a4d9-5a2a-d5b9-ccdfd3fb64f6@gmail.com>
 <20161223081402.dawagp67j35jrdcj@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <af8d5201-9bd3-f68f-c429-d94ea35864cb@gmail.com>
Date: Fri, 23 Dec 2016 07:43:50 -0500
MIME-Version: 1.0
In-Reply-To: <20161223081402.dawagp67j35jrdcj@angband.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-23 03:14, Adam Borowski wrote:
> On Thu, Dec 22, 2016 at 01:28:37PM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-12-22 10:14, Adam Borowski wrote:
>>> On the other, other filesystems:
>>> * suffer from silent data loss every time the disk doesn't notice an error!
>>>   Allowing silent data loss fails the most basic requirement for a
>>>   filesystem.  Btrfs at least makes that loss noisy (single) so you can
>>>   recover from backups, or handles it (redundant RAID).
>> No, allowing silent data loss fails the most basic requirement for a
>> _storage system_.  A filesystem is generally a key component in a data
>> storage system, but people regularly conflate the two as having the same
>> meaning, which is absolutely wrong.  Most traditional filesystems are
>> designed under the assumption that if someone cares about at-rest data
>> integrity, they will purchase hardware to ensure at-rest data integrity.
>
> You mean, like per-sector checksums even cheapest disks are supposed to
> have?  I don't think storage-side hardware can possibly ensure such
> integrity, they can at most be better made than bottom-of-the-barrel disks.
Or RAID arrays, or some other setup.
>
> There's a difference between detecting corruption (checksums) and rectifying
> it; the latter relies on the former done reliably.
Agreed, but there are situations in which even BTRFS can't detect things 
reliably.
>
>> This is a perfectly reasonable stance, especially considering that ensuring
>> at-rest data integrity is _hard_ (BTRFS is better at it than most
>> filesystems, but it still can't do it to the degree that most of the people
>> who actually require it need).  A filesystem's job is traditionally to
>> organize things, not verify them or provide redundancy.
>
> Which layer do you propose to verify integrity of the data then?  Anything
> even remotely complete would need to be closely integrated with the
> filesystem -- and thus it might be done outright as a part of the filesystem
> rather than as an afterthought.
I'm not saying a filesystem shouldn't verify data integrity, I'm saying 
that many don't because they rely on another layer (usually between them 
and the block device) to do so, which is a perfectly reasonable approach.
>
>>> So sorry, but I had enough woe with those "fully mature and stable"
>>> filesystems.  Thus I use btrfs pretty much everywhere, backing up my crap
>>> every 24 hours, important bits every 3 hours.
>> I use BTRFS pretty much everywhere too.  I've also had more catastrophic
>> failures from BTRFS than any other filesystem I've used except FAT (NTFS is
>> a close third).
>
> Perhaps it's just a matter of luck, but my personal experience doesn't paint
> btrfs in such a bad light.  Non-dev woes that I suffered are:
>
> * 2.6.31: ENOSPC that no deletion/etc could recover from, had to backup and
>   restore
>
> * 3.14: deleting ~100k daily snapshots in one go on a box with only 3G RAM
>   OOMed (slab allocation, despite lots of free swap user pages could be
>   swapped to).  I aborted mount after several hours, dmesg suggested it was
>   making progress, but I didn't wait and instead nuked it and restored from
>   the originals (these were backups).
>
> * 3.8 vendor kernel: on an arm SoC[1] that's been pounded for ~3 years with
>   heavy load (3 jobs doing snapshot+dpkg+compile+teardown) I once hit
>   unrecoverable corruption somewhere on a snapshot, had to copy base images
>   (less work than recreating, they were ok), nuke and re-mkfs.  Had this
>   been real data rather than transient retryable working copy, it'd be lost.
I've lost about 6 filesystems to various issues since I started using 
BTRFS.  Given that that's 6 filesystems since about 3.10, which work out 
to about 2 filesystems a year (and this is still not counting hardware 
failures or issues I caused myself while poking around at things I 
shouldn't have been).  In comparison to about 4 in 10 years aggregated 
over every other filesystem I've ever used (NTFS, FAT32, exFAT, XFS, 
JFS, NILFS2, ext{2,3,4}, HFS+, SquashFS, and a couple of others), which 
works out to 1 every 2.5 years.  BTRFS has a pretty blatantly worse 
track record than anything else I've used.

That said, I have not lost a single FS since 3.18 using BTRFS, but most 
of that is that the parts I actually use (raid1 mode, checksumming, 
single snapshots per subvolume) are functionally stable, and that I've 
gotten much smarter about keeping things from getting into states where 
the filesystem will get irreversibly wedged into a corner.
>
> (Obviously not counting regular hardware failures.)
>
>> I've also recovered sanely without needing a new filesystem and a full
>> data restoration on ext4, FAT, and even XFS more than I have on BTRFS
>
> Right; thought I did have one case when btrfs saved me when ext4 would have
> not -- previous generation was readily available when the most recent write
> hit a newly bad sector.
Same, but I also wouldn't have been using ext4 by itself, I would have 
been using it on top of LVM based RAID, and thus would have survived 
anyway with a better than 50% chance of having the correct data.  You 
can't compare BTRFS as-is with it's default feature set to ext4 or XFS 
by themselves in terms of reliability, because BTRFS tries to do more. 
You need to be comparing to an equivalent storage setup (so either ZFS, 
or ext4/XFS on top of a good RAID array), in which case it generally 
loses pretty bad.
>
> And being recently burned by ext4 silently losing data, then shortly later
> btrfs nicely informing me about such loss (immediately rectified by taking
> from backups and replacing the disk), I'm really reluctant about using any
> filesystem without checksums.
>
>> That said, the two of us and most of the other list regulars have a much
>> better understanding of the involved risks than a significant majority of
>> 'normal' users
>
> True that.  BTRFS is... quirky.
I think the bigger issues are that it's significantly different from ZFS 
in many respects (which is the closest experience most seasoned 
sysadmins will have had), and many distros started shipping 'support' 
for it way sooner than they should have.
>
>> and in terms of performance too, even mounted with no checksumming
>> and no COW for everything but metadata, ext4 and XFS still beat the tar out
>> of BTRFS in terms of performance)
>
> Pine64, class 4 SD card (quoting numbers from memory, 3 tries each):
> * git reset --hard of a big tree: btrfs 3m45s, f2fs 4m, ext4 12m, xfs 16-18m
>   (big variance)
> * ./configure && make -j4 && make test of a shit package with only ~2MB of
>   persistent writes: f2fs 95s, btrfs 97s, xfs 120s, ext4 122s.  I don't even
>   understand where the difference comes from, on a CPU-bound task with
>   virtually no writeout...
An SD card benefits very significantly from the COW nature of BTRFS 
though because it makes the firmware's job of wear-leveling easier. 
Doing similar on an x86 system with a good SSD (high-quality 
wear-leveling, no built-in deduplication, no built-in compression, only 
about 5% difference between read and write speed) or a decent consumer 
HDD (7200 RPM 1TB SATA 3), I see BTRFS do roughly 10-20% worse than XFS 
and ext4 (I've not tested F2FS much, it holds little interest for me for 
multiple reasons).  Same storage stack, I see similar relative 
performance for runs of iozone and fio, and roughly similar relative 
performance for xfstests restricted to just the stuff that runs on all 
three filesystems.  Now, part of this may be because it's x86, but I 
doubt it since it's a recent 64-bit processor.
>
>
> Meow!
>
> [1]. Using Samsung's fancy-schmancy über eMMC -- like Ukrainian brewers, too
> backward to know corpo beer is supposed to be made from urine, no one told
> those guys flash is supposed to have sharply limited write endurance.
>

