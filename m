Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45422 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbeHJJuq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 05:50:46 -0400
Date: Fri, 10 Aug 2018 03:12:18 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: erenthetitan@mail.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Message-ID: <20180810071218.GA13528@hungrycats.org>
References: <20180810014023.C3FBD8073A@smtp03.mail.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <20180810014023.C3FBD8073A@smtp03.mail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 10, 2018 at 03:40:23AM +0200, erenthetitan@mail.de wrote:
> I am searching for more information regarding possible bugs related to
> BTRFS Raid 5/6. All sites i could find are incomplete and information
> contradicts itself:
>
> The Wiki Raid 5/6 Page (https://btrfs.wiki.kernel.org/index.php/RAID56)
> warns of the write hole bug, stating that your data remains safe
> (except data written during power loss, obviously) upon unclean shutdown
> unless your data gets corrupted by further issues like bit-rot, drive
> failure etc.

The raid5/6 write hole bug exists on btrfs (as of 4.14-4.16) and there are
no mitigations to prevent or avoid it in mainline kernels.

The write hole results from allowing a mixture of old (committed) and
new (uncommitted) writes to the same RAID5/6 stripe (i.e. a group of
blocks consisting of one related data or parity block from each disk
in the array, such that writes to any of the data blocks affect the
correctness of the parity block and vice versa).  If the writes were
not completed and one or more of the data blocks are not online, the
data blocks reconstructed by the raid5/6 algorithm will be corrupt.

If all disks are online, the write hole does not immediately
damage user-visible data as the old data blocks can still be read
directly; however, should a drive failure occur later, old data may
not be recoverable because the parity block will not be correct for
reconstructing the missing data block.  A scrub can fix write hole
errors if all disks are online, and a scrub should be performed after
any unclean shutdown to recompute parity data.

The write hole always puts both old and new data at risk of damage;
however, due to btrfs's copy-on-write behavior, only the old damaged
data can be observed after power loss.  The damaged new data will have
no references to it written to the disk due to the power failure, so
there is no way to observe the new damaged data using the filesystem.
Not every interrupted write causes damage to old data, but some will.

Two possible mitigations for the write hole are:

	- modify the btrfs allocator to prevent writes to partially filled
	raid5/6 stripes (similar to what the ssd mount option does, except
	with the correct parameters to match RAID5/6 stripe boundaries),
	and advise users to run btrfs balance much more often to reclaim
	free space in partially occupied raid stripes

	- add a stripe write journal to the raid5/6 layer (either in
	btrfs itself, or in a lower RAID5 layer).

There are assorted other ideas (e.g. copy the RAID-Z approach from zfs
to btrfs or dramatically increase the btrfs block size) that also solve
the write hole problem but are somewhat more invasive and less practical
for btrfs.

Note that the write hole also affects btrfs on top of other similar
raid5/6 implementations (e.g. mdadm raid5 without stripe journal).
The btrfs CoW layer does not understand how to allocate data to avoid RMW
raid5 stripe updates without corrupting existing committed data, and this
limitation applies to every combination of unjournalled raid5/6 and btrfs.

> The Wiki Gotchas Page (https://btrfs.wiki.kernel.org/index.php/Gotchas)
> warns of possible incorrigible "transid" mismatch, not stating which
> versions are affected or what transid mismatch means for your data. It
> does not mention the write hole at all.

Neither raid5 nor write hole are required to produce a transid mismatch
failure.  transid mismatch usually occurs due to a lost write.  Write hole
is a specific case of lost write, but write hole does not usually produce
transid failures (it produces header or csum failures instead).

During real disk failure events, multiple distinct failure modes can
occur concurrently.  i.e. both transid failure and write hole can occur
at different places in the same filesystem as a result of attempting to
use a failing disk over a long period of time.

A transid verify failure is metadata damage.  It will make the filesystem
readonly and make some data inaccessible as described below.

> This Mail Archive (linux-btrfs@vger.kernel.org/msg55161.html"
> target=3D"_blank">https://www.mail-archive.com/linux-btrfs@vger.kernel.or=
g/msg55161.html)
> states that scrubbing BTRFS Raid 5/6 will always repair Data Corruption,
> but may corrupt your Metadata while trying to do so - meaning you have
> to scrub twice in a row to ensure data integrity.

Simple corruption (without write hole errors) is fixed by scrubbing
as of the last...at least six months?  Kernel v4.14.xx and later can
definitely do it these days.  Both data and metadata.

If the metadata is damaged in any way (corruption, write hole, or transid
verify failure) on btrfs and btrfs cannot use the raid profile for
metadata to recover the damaged data, the filesystem is usually forever
readonly, and anywhere from 0 to 100% of the filesystem may be readable
depending on where in the metadata tree structure the error occurs (the
closer to the root, the more data is lost).  This is the same for dup,
raid1, raid5, raid6, and raid10 profiles.  raid0 and single profiles are
not a good idea for metadata if you want a filesystem that can persist
across reboots (some use cases don't require persistence, so they can
use -msingle/-mraid0 btrfs as a large-scale tmpfs).

For all metadata raid profiles, recovery can fail due to risks including
RAM corruption, multiple drives having defects in the same locations,
or multiple drives with identically-behaving firmware bugs.  For raid5/6
metadata there is the *additional* risk of the write hole bug preventing
recovery of metadata.

If the filesystem is -draid5 -mraid1 then the metadata is not vulnerable
to the write hole, but data is.  In this configuration you can determine
with high confidence which files you need to restore from backup, and
the filesystem will remain writable to replace the restored data, because
raid1 does not have the write hole bug.

More than one scrub for a single write hole event won't help (and never
did).  If the first scrub doesn't fix all the errors then your kernel
probably also has a race condition bug or regression that will permanently
corrupt the data (this was true in 2016 when the referenced mailing
list post was written).

Current kernels don't have such bugs--if the first scrub can correct
the data, it does, and if the first scrub can't correct the data then
all future scrubs will produce identical results.

Older kernels (2016) had problems reconstructing data during read()
operations but could fix data during scrub or balance operations.
These bugs, as far as I am able to test, have been fixed by v4.17 and
backported to v4.14.

> The Bugzilla Entry
> (https://bugzilla.kernel.org/buglist.cgi?component=3Dbtrfs) contains
> mostly unanswered bugs, which may or may not still count (2013 - 2018).

I find that any open bug over three years old on b.k.o can be safely
ignored because it has either already been fixed or there is not enough
information provided to understand what is going on.

> This Spinics Discussion
> (https://www.spinics.net/lists/linux-btrfs/msg76471.html) states
> that the write hole can even damage old data eg. data that was not
> accessed during unclean shutdown, the opposite of what the Raid5/6
> Status Page states!

Correct, write hole can *only* damage old data as described above.

> This Spinics comment
> (https://www.spinics.net/lists/linux-btrfs/msg76412.html) informs that
> hot-plugging a device will trigger the write hole. Accessed data will
> therefore be corrupted.  In case the earlier statement about old data
> corruption is true, random data could be permamently lost.  This is even
> more dangerous if you are connecting your devices via USB, as USB can
> unconnect due to external influence, eg. touching the cables, shaking...

Hot-unplugging a device can cause many lost write events at once, and
each lost write event is very bad.

btrfs does not reject and resynchronize a device from a raid array if a
write to the device fails (unlike every other working RAID implementation
on Earth...).  If the device reconnects, btrfs will read a mixture of
old and new data and rely on checksums to determine which blocks are
out of date (as opposed to treating the departed disk as entirely out
of date and initiating a disk replace operation when it reconnects).

A scrub after a momentary disconnect can reconstruct most missing data,
but not all.  CRC32 lets one error through per 16 TB of corrupted blocks,
and all nodatasum/nodatacow files modified while a drive was offline
will be corrupted without detection or recovery by btrfs.

Device replace is currently the best recovery option from this kind
of failure.  Ideally btrfs would implement something like mdadm write
intent bitmaps so only those block groups that were modified while
the device as offline would be replaced, but this is the btrfs we want
not the btrfs we have.

> Lastly, this Superuser question
> (https://superuser.com/questions/1325245/btrfs-transid-failure#1344494)
> assumes that the transid mismatch bug could toggle your system
> unmountable.  While it might be possible to restore your data using
> sudo BTRFS Restore, it is still unknown how the transid mismatch is
> even toggled, meaning that your file system could fail at any time!

Note that transid failure risk applies to all btrfs configurations.
It is not specific to raid5/6.  The write hole errors from raid5/6 will
typically produce a header or csum failure (from reading garbage) not a
transid failure (from reading an old, valid, but deleted metadata block).

transid mismatch is pretty simple:  one of your disk drives, or some
caching or translation layer between btrfs and your disk drives, dropped
a write (or, less likely, read from or wrote to the wrong sector address).
btrfs detects this by embedding transids into all data structures where
one object points to another object in a different block.

transid mismatch is also hard:  you then have to figure out which layer
of your possibly quite complicated RAID setup is doing that, and make
it stop.  This process almost never involves btrfs.  Sometimes it's the
bottom layer (i.e. the drives themselves) but the more layers you add,
the more candidates need to be eliminated before the cause can be found.
Sometimes it's a *power supply* (i.e. the drive controller CPU browns
out and forgets it was writing something or corrupts its embedded RAM).
Sometimes it's host RAM going bad, corrupting and breaking everything
it touches.

I have a variety of test setups and the correlation between hardware
model (especially drive model, but also some SATA controller models)
and total filesystem loss due to transid verify failure is very strong.
Out of 10 drive models from 5 vendors, 2 models can't keep a filesystem
intact for more than a few months, while the other models average 3 years
old and still hold the first btrfs filesystem they were formatted with.

Disabling drive write caching sometimes helps, but some hardware eats
a filesystem every few months no matter what settings I change.  If the
problem is a broken SATA controller or cable then changing drive settings
won't help.

It's fun and/or scary to put known good and bad hardware in the same
RAID1 array and watch btrfs autocorrecting the bad data after every
other power failure; however, the bad hardware is clearly not sufficient
to implement any sort of reliable data persistence, and arrays with bad
hardware in them will eventually fail.

The bad drives can still contribute to society as media cache servers or
point-of-sale terminals where the only response to any data integrity
issue is a full reformat and image reinstall.  This seems to be the
target market that low-end consumer drives are aiming for, as they seem
to be useless for anything else.

Adopt a zero-tolerance policy for drive resets after the array is
mounted and active.  A drive reset means a potential lost write leading
to a transid verify failure.  Swap out both drive and SATA cable the
first time a reset occurs during a read or write operation, and consider
swapping out SATA controller, changing drive model, and upgrading power
supply if it happens twice.

> Do you know of any comprehensive and complete Bug list?

=2E..related to raid5/6:

	- no write hole mitigation (at least two viable strategies
	available)

	- no device bouncing mitigation (mdadm had this working 20
	years ago)

	- probably slower than it could be

	- no recovery strategy other than raid (btrfs check --repair is
	useless on non-trivial filesytems, and a single-bit uncorrected
	metadata error makes the filesystem unusable)

> Do you know more about the stated Bugs?
>
> Do you know further Bugs that are not addressed in any of these sites?

My testing on raid5/6 filesystems is producing pretty favorable results
these days.  There do not seem to be many bugs left.

I have one test case where I write millions of errors into a raid5/6 and
the filesystem recovers every single one transparently while verifying
SHA1 hashes of test data.  After years of rebuilding busted ext3 on
mdadm-raid5 filesystems, watching btrfs do it all automatically is
just...beautiful.

I think once the write hole and device bouncing mitigations are in place,
I'll start looking at migrating -draid1/-mraid1 setups to -draid5/-mraid1,
assuming the performance isn't too painful.

> -------------------------------------------------------------------------=
------------------------
> FreeMail powered by mail.de - MEHR SICHERHEIT, SERIOSIT=C4T UND KOMFORT

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW206zwAKCRCB+YsaVrMb
nKjJAKDQL1JutctuL/jFDde3ms+s/F2TjgCfZQFCn+ydiSvpfIqZZ1wBVPIQ6Ww=
=z7GD
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
