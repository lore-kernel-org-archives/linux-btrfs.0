Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47811 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752009AbcFXBgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 21:36:07 -0400
Date: Thu, 23 Jun 2016 21:36:06 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624013605.GA14667@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 09:32:50PM +0200, Goffredo Baroncelli wrote:
> The raid write hole happens when a stripe is not completely written
> on the platters: the parity and the related data mismatch. In this
> case a "simple" raid5 may return wrong data if the parity is used to
> compute the data. But this happens because a "simple" raid5 is unable
> to detected if the returned data is right or none.
>=20
> The raid5 write hole is avoided in BTRFS (and in ZFS) thanks to the
> checksum.

Checksums do not help with the raid5 write hole.  The way btrfs does
checksums might even make it worse.

ZFS reduces the number of disks in a stripe when a disk failure
is detected so that writes are always in non-degraded mode, and they
presumably avoid sub-stripe-width data allocations or use journalling
to avoid the write hole.  btrfs seems to use neither tactic.  At best,
btrfs will avoid creating new block groups on disks that are missing at
mount time, and it doesn't deal with sub-stripe-width allocations at all.

I'm working from two assumptions as I haven't found all the relevant
code yet:

	1.  btrfs writes parity stripes at fixed locations relative to
	the data in the same stripe.  If this is true, then the parity
	blocks are _not_ CoW while the data blocks and their checksums
	_are_ CoW.  I don't know if the parity block checksums are also
	CoW.

	2.  btrfs sometimes puts data from two different transactions in
	the same stripe at the same time--a fundamental violation of the
	CoW concept.  I inferred this from the logical block addresses.

Unless I'm missing something in the code somewhere, parity blocks can
have out-of-date checksums for short periods of time between flushes and
commits.  This would lose data by falsely reporting valid parity blocks
as checksum failures.  If any *single* failure occurs at the same time
(such as a missing write or disk failure) a small amount of data will
be lost.

> BTRFS is able to discard the wrong data: i.e. in case of a 3 disks
> raid5, the right data may be extracted from the data1+data2 or if the
> checksum doesn't match from data1+parity or if the checksum doesn't
> match from data2+parity.

Suppose we have a sequence like this (3-disk RAID5 array, one stripe
containing 2 data and 1 parity block) starting with the stripe empty:

	1.  write data block 1 to disk 1 of stripe (parity is now invalid, no chec=
ksum yet)

	2.  write parity block to disk 3 in stripe (parity becomes valid again, no=
 checksum yet)

	3.  commit metadata pointing to block 1 (parity and checksums now valid)

	4.  write data block 2 to disk 2 of stripe (parity and parity checksum now=
 invalid)

	5.  write parity block to disk 3 in stripe (parity valid now, parity check=
sum still invalid)

	6.  commit metadata pointing to block 2 (parity and checksums now valid)

We can be interrupted at any point between step 1 and 4 with no data loss.
Before step 3 the data and parity blocks are not part of the extent
tree so their contents are irrelevant.  After step 3 (assuming each
step is completed in order) data block 1 is part of the extent tree and
can be reconstructed if any one disk fails.  This is the part of btrfs
raid5 that works.

If we are interrupted between steps 4 and 6 (e.g. power fails), a single
disk failure or corruption will cause data loss in block 1.  Note that
block 1 is *not* written between steps 4 and 6, so we are retroactively
damaging some previously written data that is not part of the current
transaction.

If we are interrupted between steps 4 and 5, we can no longer reconstruct
block 1 (block2 ^ parity) or block 2 (block1 ^ parity) because the parity
block doesn't match the data blocks in the same stripe
(i.e. block1 ^ block2 !=3D parity).

If we are interrupted between step 5 and 6, the parity block checksum
committed at step 3 will fail.  Data block 2 will not be accessible
since the metadata was not written to point to it, but data block 1
will be intact, readable, and have a correct checksum as long as none
of the disks fail.  This can be repaired by a scrub (scrub will simply
throw the parity block away and reconstruct it from block1 and block2).
If disk 1 fails before the next scrub, data block 1 will be lost because
btrfs will believe the parity block is incorrect even though it is not.

This risk happens on *every* write to a stripe that is not a full stripe
write and contains existing committed data blocks.  It will occur more
often on full and heavily fragmented filesystems (filesystems which=20
have these properties are more likely to write new data on stripes that=20
already contain old data).

In cases where an entire stripe is written at once, or a stripe is
partially filled but no further writes ever modify the stripe, everything
works as intended in btrfs.

> NOTE2: this works if only one write is corrupted. If more writes (=3D=3D
> more disks) are involved, you got checksum mismatch. If more than one
> write are corrupted, raid5 is unable to protect you.

No write corruption is required for data loss.  Data can be lost with
any single disk failure.

> In case of "degraded mode", you don't have any redundancy. So if a
> stripe of a degraded filesystem is not fully written to the disk,
> is like a block not fully written to the disk. And you have checksums
> mismatch. But this is not what is called raid write hole.

If a block is not fully written to the disk, btrfs should not update
the metadata tree to point to it, so no (committed) data will be lost.

> On 2016-06-22 22:35, Zygo Blaxell wrote:
> > If in the future btrfs allocates physical block 2412725692 to
> > a different file, up to 3 other blocks in this file (most likely
> > 2412725689..2412725691) could be lost if a crash or disk I/O error also
> > occurs during the same transaction.  btrfs does do this--in fact, the
> > _very next block_ allocated by the filesystem is 2412725692:
> >=20
> > 	# head -c 4096 < /dev/urandom >> f; sync; filefrag -v f
> > 	Filesystem type is: 9123683e
> > 	File size of f is 45056 (11 blocks of 4096 bytes)
> > 	 ext:     logical_offset:        physical_offset: length:   expected: =
flags:
> > 	   0:        0..       0: 2412725689..2412725689:      1:           =
=20
> > 	   1:        1..       1: 2412725690..2412725690:      1:           =
=20
> > 	   2:        2..       2: 2412725691..2412725691:      1:           =
=20
> > 	   3:        3..       3: 2412725701..2412725701:      1: 2412725692:
> > 	   4:        4..       4: 2412725693..2412725693:      1: 2412725702:
> > 	   5:        5..       5: 2412725694..2412725694:      1:           =
=20
> > 	   6:        6..       6: 2412725695..2412725695:      1:           =
=20
> > 	   7:        7..       7: 2412725698..2412725698:      1: 2412725696:
> > 	   8:        8..       8: 2412725699..2412725699:      1:           =
=20
> > 	   9:        9..       9: 2412725700..2412725700:      1:           =
=20
> > 	  10:       10..      10: 2412725692..2412725692:      1: 2412725701: =
last,eof
> > 	f: 5 extents found
>=20
> You are assuming that if you touch a block, all the blocks of the same
> stripe spread over the disks are involved. I disagree. The only parts
> which are involved, are the part of stripe which contains the changed
> block and the parts which contains the parity.

Any block change always affects all others in the stripe.  With checksums,
every write temporarily puts each stripe in degraded mode (although
this only happens to the parity blocks as the data blocks are protected
by CoW algorithms).  Checksums are CoW and updated in strictly-ordered
transactions with write barriers; stripes are modified in-place and they
are a function of the contents of many non-atomically-updated disks.

> If both the parts become corrupted, RAID5 is unable to protect you
> (two failure, when raid 5 has only _one_ redundancy). But if only
> one of these is corrupted, BTRFS with the help of the checksum is
> capable to detect which one is corrupted and to return good data
> (and to rebuild the bad parts).

This is only true for stripes that are not being updated.  During a stripe
update, btrfs raid5 seems to be much less tolerant, only one disk failure
away from data loss (of a single stripe) instead of the expected two.

All this rests on my assumptions above.  If those turn out to be wrong,
then most of the above is wrong too, and I need a new theory to explain
why almost every unplanned reboot corrupts a small amount of data on
big raid5 filesystems.=20


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldsjoUACgkQgfmLGlazG5wTlwCeNktDYt+OGoF+O1CLO7Ho+feq
/XYAoNmuGFsosGu8M/SqBtjAdMWrZJTZ
=ZeYn
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
