Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44206 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752285AbcFVUfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 16:35:11 -0400
Date: Wed, 22 Jun 2016 16:35:04 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160622203504.GQ15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wfe1KbQWcwuymTys"
In-Reply-To: <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Wfe1KbQWcwuymTys
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 11:14:30AM -0600, Chris Murphy wrote:
> > Before deploying raid5, I tested these by intentionally corrupting
> > one disk in an otherwise healthy raid5 array and watching the result.
>=20
> It's difficult to reproduce if no one understands how you
> intentionally corrupted that disk. Literal reading, you corrupted the
> entire disk, but that's impractical. The fs is expected to behave
> differently depending on what's been corrupted and how much.

The first round of testing I did (a year ago, when deciding whether
btrfs raid5 was mature enough to start using) was:

	Create a 5-disk RAID5

	Put some known data on it until it's full (i.e. random test
	patterns).  At the time I didn't do any tests involving
	compressible data, which I now realize was a serious gap in
	my test coverage.

	Pick 1000 random blocks (excluding superblocks) on one of the
	disks and write random data to them

	Read and verify the data through the filesystem, do scrub, etc.
	Exercise all the btrfs features related to error reporting
	and recovery.

I expected scrub and dev stat to report accurate corruption counts (except
for the 1 in 4 billion case where a bad csum matches by random chance),
and I expect all the data to be reconstructed since only one drive was
corrupted (assuming there are no unplanned disk failures during the
test, obviously) and the corruption occurred while the filesystem was
offline so there was no possibility of RAID write hole.

My results from that testing were that everything worked except for the
mostly-harmless quirk where scrub counts errors on random disks instead
of the disk where the errors occur.

> I don't often use the -Bd options, so I haven't tested it thoroughly,
> but what you're describing sounds like a bug in user space tools. I've
> found it reflects the same information as btrfs dev stats, and dev
> stats have been reliable in my testing.

Don't the user space tools just read what the kernel tells them?
I don't know how *not* to produce this behavior on btrfs raid5 or raid6.
It should show up on any btrfs raid56 system.

> > A different thing happens if there is a crash.  In that case, scrub can=
not
> > repair the errors.  Every btrfs raid5 filesystem I've deployed so far
> > behaves this way when disks turn bad.  I had assumed it was a software =
bug
> > in the comparatively new raid5 support that would get fixed eventually.
>=20
> This is really annoyingly vague. You don't give a complete recipe for
> reproducing this sequence. Here's what I'm understanding and what I'm
> missing:
>=20
> 1. The intentional corruption, extent of which is undefined, is still pre=
sent.

No intentional corruption here (quote:  "A different thing happens if
there is a crash...").  Now we are talking about the baseline behavior
when there is a crash on a btrfs raid5 array, especially crashes
triggered by a disk-level failure (e.g. watchdog timeout because a disk
or controller has hung) but also ordinary power failures or other crashes
triggered by external causes.

> 2. A drive is bad, but that doesn't tell us if it's totally dead, or
> only intermittently spitting out spurious information.

The most common drive-initiated reboot case is that one drive temporarily
locks up and triggers the host to perform a watchdog reset.  The reset
is successful and the filesystem can be mounted again with all drives
present; however, a small amount of raid5 data appears to be corrupted
each time.  The raid1 metadata passes all the integrity checks I can
throw at it:  btrfs check, scrub, balance, walk the filesystem with find
-type f -exec cat ..., compare with the last backup, etc.

Usually when I detect this case, I delete any corrupted data, delete
the disk that triggers the lockups and have no further problems with
that array.

> 3. Is the volume remounted degraded or is the bad drive still being
> used by Btrfs? Because Btrfs has no concept (patches pending) of drive
> faulty state like md, let alone an automatic change to that faulty
> state. It just keeps on trying to read or write to bad drives, even if
> they're physically removed.

In the baseline case the filesystem has all drives present after remount.
It could be as simple as power-cycling the host while writes are active.

> 4. You've initiated a scrub, and the corruption in 1 is not fixed.

In this pattern, btrfs may find both correctable and uncorrectable
corrupted data, usually on one of the drives.  scrub fixes the correctable
corruption, but fails on the uncorrectable.

> OK so what am I missing?

Nothing yet.  The above is the "normal" btrfs raid5 crash experience with
a non-degraded raid5 array.  A few megabytes of corrupt extents can easily
be restored from backups or deleted and everything's fine after that.

In my *current* failure case, I'm experiencing *additional* issues.
In total:

	all of the above, plus:

	BUG_ON()s as described in the first mail on this thread,

	additional csum failure kernel messages without corresponding
	dev stat increments,

	several problems that seem to occur only on kernel 4.6.2 and
	not 4.5.7.

Another distinction between the current case and the previous cases is
that this time the array is degraded:  one drive is entirely missing.

The current case seems to be hitting code paths in the kernel that I've
never seen executed before, and it looks like there are problems with
them (e.g. any function with a mirror_num parameter does not seem to be
valid for raid56, and yet the kernel is crashing in some of them).

> Because it sounds to me like you have two copies of data that are
> gone. For raid 5 that's data loss, scrub can't fix things. Corruption
> is missing data. The bad drive is missing data.
>=20
> What values do you get for
>=20
> smartctl -l scterc /dev/sdX
> cat /sys/block/sdX/device/timeout

"SCT Error Recovery Control command not supported" and "30" respectively.

There are no kernel log messages suggesting timeouts in the current case
after the failed drive was disconnected from the system.  There were
plenty of these starting just after the drive failed, but that's to be
expected, and should be tolerated by a raid5 implementation.

All remaining drives appear to be healthy.  The array completed a scrub
two weeks before the disk failure with no errors (as it has every two
weeks since it was created).

> I do not know the exact nature of the Btrfs raid56 write hole. Maybe a
> dev or someone who knows can explain it.

If you have 3 raid5 devices, they might be laid out on disk like this
(e.g. with a 16K stripe width):

	Address:  0..16K        16..32K         32..64K
        Disk 1: [0..16K]        [32..64K]       [PARITY]
        Disk 2: [16..32K]       [PARITY]        [80..96K]
        Disk 3: [PARITY]        [64..80K]       [96..112K]

btrfs logical address ranges are inside [].  Disk physical address ranges
are shown at the top of each column.  (I've simplified the mapping here;
pretend all the addresses are relative to the start of a block group).

If we want to write a 32K extent at logical address 0, we'd write all
three disks in one column (disk1 gets 0..16K, disk2 gets 16..32K, disk3
gets parity for the other two disks).  The parity will be temporarily
invalid for the time between the first disk write and the last disk write.
In non-degraded mode the parity isn't necessary, but in degraded mode
the entire column cannot be reconstructed because of invalid parity.

To see why this could be a problem, suppose btrfs writes a 4K extent at
logical address 32K.  This requires updating (at least) disk 1 (where the
logical address 32K resides) and disk 2 (the parity for this column).
This means any data that existed at logical addresses 36K..80K (or at
least 32..36K and 64..68K) has its parity temporarily invalidated between
the write to the first and last disks.  If there were metadata pointing
to other blocks in this column, the metadata temporarily points to
damaged data during the write.  If there is no data in other blocks in
this column then it doesn't matter that the parity doesn't match--the
content of the reconstructed unallocated blocks would be undefined
even in the success cases.

Last time I checked, btrfs doesn't COW entire RAID stripes (it does
RMW them but that's not the same thing at all).  COW affects only extents
in the logical address space.  To avoid the write hole issue, btrfs
would have to avoid writing to any column that is partially occupied by
existing committed data (i.e. it would have to write the entire column
in a single transaction or not write to the column at all).

btrfs doesn't do this, which can be proven with a simple experiment:

	# btrfs sub create tmp && cd tmp
	# for x in $(seq 0 9); do head -c 4096 < /dev/urandom >> f; sync; done; fi=
lefrag -v f
	Filesystem type is: 9123683e
	File size of f is 40960 (10 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..       0: 2412725689..2412725689:      1:           =20
	   1:        1..       1: 2412725690..2412725690:      1:           =20
	   2:        2..       2: 2412725691..2412725691:      1:           =20
	   3:        3..       3: 2412725692..2412725692:      1:           =20
	   4:        4..       4: 2412725693..2412725693:      1:           =20
	   5:        5..       5: 2412725694..2412725694:      1:           =20
	   6:        6..       6: 2412725695..2412725695:      1:           =20
	   7:        7..       7: 2412725698..2412725698:      1: 2412725696:
	   8:        8..       8: 2412725699..2412725699:      1:           =20
	   9:        9..       9: 2412725700..2412725700:      1:             last=
,eof
	f: 2 extents found

Here I have allocated 10 consecutive physical blocks in 10 separate
btrfs transactions on a 5-disk raid5 array.

Those physical_offset blocks need to be at least N-1 blocks apart (for a
5-disk array, this is 4) to avoid the write hole problem (except for the
special case of one block at the end of a column adjacent to the first
block of the next column).  They certainly cannot _all_ be adjacent.

If block #3 in this file is modified, btrfs will free physical block
2412725692 because of CoW:

	# head -c 4096 < /dev/urandom | dd seek=3D3 bs=3D4k of=3Df conv=3Dnotrunc;=
 sync
	1+0 records in
	1+0 records out
	4096 bytes (4.1 kB) copied, 9.3396e-05 s, 43.9 MB/s
	Filesystem type is: 9123683e
	File size of f is 40960 (10 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..       0: 2412725689..2412725689:      1:           =20
	   1:        1..       1: 2412725690..2412725690:      1:           =20
	   2:        2..       2: 2412725691..2412725691:      1:           =20
	   3:        3..       3: 2412725701..2412725701:      1: 2412725692:
	   4:        4..       4: 2412725693..2412725693:      1: 2412725702:
	   5:        5..       5: 2412725694..2412725694:      1:           =20
	   6:        6..       6: 2412725695..2412725695:      1:           =20
	   7:        7..       7: 2412725698..2412725698:      1: 2412725696:
	   8:        8..       8: 2412725699..2412725699:      1:           =20
	   9:        9..       9: 2412725700..2412725700:      1:             last=
,eof
	f: 4 extents found

If in the future btrfs allocates physical block 2412725692 to
a different file, up to 3 other blocks in this file (most likely
2412725689..2412725691) could be lost if a crash or disk I/O error also
occurs during the same transaction.  btrfs does do this--in fact, the
_very next block_ allocated by the filesystem is 2412725692:

	# head -c 4096 < /dev/urandom >> f; sync; filefrag -v f
	Filesystem type is: 9123683e
	File size of f is 45056 (11 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..       0: 2412725689..2412725689:      1:           =20
	   1:        1..       1: 2412725690..2412725690:      1:           =20
	   2:        2..       2: 2412725691..2412725691:      1:           =20
	   3:        3..       3: 2412725701..2412725701:      1: 2412725692:
	   4:        4..       4: 2412725693..2412725693:      1: 2412725702:
	   5:        5..       5: 2412725694..2412725694:      1:           =20
	   6:        6..       6: 2412725695..2412725695:      1:           =20
	   7:        7..       7: 2412725698..2412725698:      1: 2412725696:
	   8:        8..       8: 2412725699..2412725699:      1:           =20
	   9:        9..       9: 2412725700..2412725700:      1:           =20
	  10:       10..      10: 2412725692..2412725692:      1: 2412725701: last=
,eof
	f: 5 extents found

These extents all have separate transids too:

	# btrfs sub find-new . 1
	inode 257 file offset 0 len 4096 disk start 9882524422144 offset 0 gen 143=
2814 flags NONE f
	inode 257 file offset 4096 len 4096 disk start 9882524426240 offset 0 gen =
1432816 flags NONE f
	inode 257 file offset 8192 len 4096 disk start 9882524430336 offset 0 gen =
1432817 flags NONE f
	inode 257 file offset 12288 len 4096 disk start 9882524471296 offset 0 gen=
 1432825 flags NONE f
	inode 257 file offset 16384 len 4096 disk start 9882524438528 offset 0 gen=
 1432819 flags NONE f
	inode 257 file offset 20480 len 4096 disk start 9882524442624 offset 0 gen=
 1432820 flags NONE f
	inode 257 file offset 24576 len 4096 disk start 9882524446720 offset 0 gen=
 1432821 flags NONE f
	inode 257 file offset 28672 len 4096 disk start 9882524459008 offset 0 gen=
 1432822 flags NONE f
	inode 257 file offset 32768 len 4096 disk start 9882524463104 offset 0 gen=
 1432823 flags NONE f
	inode 257 file offset 36864 len 4096 disk start 9882524467200 offset 0 gen=
 1432824 flags NONE f
	inode 257 file offset 40960 len 4096 disk start 9882524434432 offset 0 gen=
 1432826 flags NONE f
	transid marker was 1432826

> > The filesystem would continue to work afterwards with raid1 metadata
> > because every disk in raid1 updates its blocks in the same order,
> > and there are no interdependencies between blocks on different disks
> > (not like a raid5 stripe, anyway).
>=20
> I'm not sure what you mean by this. Btrfs raid1 means two copies. It
> doesn't matter how many drives there are, there are two copies of
> metadata in your case, and you have no idea which drives those
> metadata block groups are on without checking btrfs-debug-tree.

What I mean is that there are no dependencies between logically adjacent
blocks on physically separate disks in raid1 as there are in raid5,
because there are no stripes in raid1.  The whole above scenario
cannot occur in raid1.


--Wfe1KbQWcwuymTys
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldq9ngACgkQgfmLGlazG5xp9QCgqLTwI17KHwykPqXXQulkam91
fvUAn30agO/F6vzV2ZRs4Vrj0j5eOSf0
=gyyt
-----END PGP SIGNATURE-----

--Wfe1KbQWcwuymTys--
