Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52531 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcLWIOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 03:14:09 -0500
Date: Fri, 23 Dec 2016 09:14:02 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
Message-ID: <20161223081402.dawagp67j35jrdcj@angband.pl>
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
 <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>
 <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
 <pan$67936$e25a272c$77926cea$931807ed@cox.net>
 <20161222151425.ecryyvnz2feaygrr@angband.pl>
 <67d0fb6f-a4d9-5a2a-d5b9-ccdfd3fb64f6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <67d0fb6f-a4d9-5a2a-d5b9-ccdfd3fb64f6@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 22, 2016 at 01:28:37PM -0500, Austin S. Hemmelgarn wrote:
> On 2016-12-22 10:14, Adam Borowski wrote:
> > On the other, other filesystems:
> > * suffer from silent data loss every time the disk doesn't notice an error!
> >   Allowing silent data loss fails the most basic requirement for a
> >   filesystem.  Btrfs at least makes that loss noisy (single) so you can
> >   recover from backups, or handles it (redundant RAID).
> No, allowing silent data loss fails the most basic requirement for a
> _storage system_.  A filesystem is generally a key component in a data
> storage system, but people regularly conflate the two as having the same
> meaning, which is absolutely wrong.  Most traditional filesystems are
> designed under the assumption that if someone cares about at-rest data
> integrity, they will purchase hardware to ensure at-rest data integrity.

You mean, like per-sector checksums even cheapest disks are supposed to
have?  I don't think storage-side hardware can possibly ensure such
integrity, they can at most be better made than bottom-of-the-barrel disks.

There's a difference between detecting corruption (checksums) and rectifying
it; the latter relies on the former done reliably.

> This is a perfectly reasonable stance, especially considering that ensuring
> at-rest data integrity is _hard_ (BTRFS is better at it than most
> filesystems, but it still can't do it to the degree that most of the people
> who actually require it need).  A filesystem's job is traditionally to
> organize things, not verify them or provide redundancy.

Which layer do you propose to verify integrity of the data then?  Anything
even remotely complete would need to be closely integrated with the
filesystem -- and thus it might be done outright as a part of the filesystem
rather than as an afterthought.

> > So sorry, but I had enough woe with those "fully mature and stable"
> > filesystems.  Thus I use btrfs pretty much everywhere, backing up my crap
> > every 24 hours, important bits every 3 hours.
> I use BTRFS pretty much everywhere too.  I've also had more catastrophic
> failures from BTRFS than any other filesystem I've used except FAT (NTFS is
> a close third).

Perhaps it's just a matter of luck, but my personal experience doesn't paint
btrfs in such a bad light.  Non-dev woes that I suffered are:

* 2.6.31: ENOSPC that no deletion/etc could recover from, had to backup and
  restore

* 3.14: deleting ~100k daily snapshots in one go on a box with only 3G RAM
  OOMed (slab allocation, despite lots of free swap user pages could be
  swapped to).  I aborted mount after several hours, dmesg suggested it was
  making progress, but I didn't wait and instead nuked it and restored from
  the originals (these were backups).

* 3.8 vendor kernel: on an arm SoC[1] that's been pounded for ~3 years with
  heavy load (3 jobs doing snapshot+dpkg+compile+teardown) I once hit
  unrecoverable corruption somewhere on a snapshot, had to copy base images
  (less work than recreating, they were ok), nuke and re-mkfs.  Had this
  been real data rather than transient retryable working copy, it'd be lost.

(Obviously not counting regular hardware failures.)

> I've also recovered sanely without needing a new filesystem and a full
> data restoration on ext4, FAT, and even XFS more than I have on BTRFS

Right; thought I did have one case when btrfs saved me when ext4 would have
not -- previous generation was readily available when the most recent write
hit a newly bad sector.

And being recently burned by ext4 silently losing data, then shortly later
btrfs nicely informing me about such loss (immediately rectified by taking
from backups and replacing the disk), I'm really reluctant about using any
filesystem without checksums.

> That said, the two of us and most of the other list regulars have a much
> better understanding of the involved risks than a significant majority of
> 'normal' users

True that.  BTRFS is... quirky.

> and in terms of performance too, even mounted with no checksumming
> and no COW for everything but metadata, ext4 and XFS still beat the tar out
> of BTRFS in terms of performance)

Pine64, class 4 SD card (quoting numbers from memory, 3 tries each):
* git reset --hard of a big tree: btrfs 3m45s, f2fs 4m, ext4 12m, xfs 16-18m
  (big variance)
* ./configure && make -j4 && make test of a shit package with only ~2MB of
  persistent writes: f2fs 95s, btrfs 97s, xfs 120s, ext4 122s.  I don't even
  understand where the difference comes from, on a CPU-bound task with
  virtually no writeout...


Meow!

[1]. Using Samsung's fancy-schmancy über eMMC -- like Ukrainian brewers, too
backward to know corpo beer is supposed to be made from urine, no one told
those guys flash is supposed to have sharply limited write endurance.
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
