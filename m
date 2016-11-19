Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41526 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751919AbcKSIXF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 03:23:05 -0500
Date: Sat, 19 Nov 2016 03:22:52 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RFC: raid with a variable stripe size
Message-ID: <20161119082252.GU21290@hungrycats.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+hZIELbchok2+JHy"
In-Reply-To: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+hZIELbchok2+JHy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2016 at 07:15:12PM +0100, Goffredo Baroncelli wrote:
> Hello,
>
> these are only my thoughts; no code here, but I would like to share
> it hoping that it could be useful.
>
> As reported several times by Zygo (and others), one of the problem of
> raid5/6 is the write hole. Today BTRFS is not capable to address it.
>
> The problem is that the stripe size is bigger than the "sector size"
> (ok sector is not the correct word, but I am referring to the basic
> unit of writing on the disk, which is 4k or 16K in btrfs).  So when
> btrfs writes less data than the stripe, the stripe is not filled; when
> it is filled by a subsequent write, a RMW of the parity is required.

The key point in the problem statement is that subsequent writes are
allowed to modify stripes while they contain data.  Proper CoW would
never do that.

Stripes should never contain data from two separate transactions--that
would imply that CoW rules have been violated.

Currently there is no problem for big writes on empty disks because
the data block allocator happens to do the right thing accidentally in
such cases.  It's only when the allocator allocates new data to partially
filled stripes that the problems occur.

For metadata the allocator currently stumbles into RMW writes so badly
that the difference between the current allocator and the worst possible
allocator is only a few percent.

> On the best of my understanding (which could be very wrong) ZFS try
> to solve this issue using a variable length stripe.

ZFS ties the parity blocks to what btrfs would call extents.  It prevents
multiple writes to the same RAID stripe in different transactions by
dynamically defining the RAID stripe boundaries *around* the write
boundaries.  This is very different from btrfs's current on-disk
structure.

e.g. if we were to write:

	extent D, 7 blocks
	extent E, 3 blocks
	extent F, 9 blocks

the disk in btrfs looks something like:

	D1 D2 D3 D4 P1
	D5 D6 D7 P2 E1
	E2 E3 P3 F1 F2
	F3 P4 F4 F5 F6
	P5 F7 F8 F9 xx

	P1 =3D parity(D1..D4)
	P2 =3D parity(D5..D7, E1)
	P3 =3D parity(E2, E3, F1, F2)
	P4 =3D parity(F3..F6)
	P5 =3D parity(F7..F9)

If D, E, and F were written in different transactions, it could make P2
and P3 invalid.

The disk in ZFS looks something like:

	D1 D2 D3 D4 P1
	D5 D6 D7 P2 E1
	E2 E3 P3 F1 F2
	F3 F4 P4 F5 F6
	F7 F8 P5 F9 P6

where:

	P1 is parity(D1..D4)
	P2 is parity(D5..D7)
	P3 is parity(E1..E3)
	P4 is parity(F1..F4)
	P5 is parity(F5..F8)
	P6 is parity(F9)

Each parity value contains only data from one extent, which makes it
impossible for any P block to contain data from different transactions.
Every extent is striped across a potentially different number of disks,
so it's less efficient than "pure" raid5 would be with the same quantity
of data.

This would require pushing the parity allocation all the way up into
the extent layer in btrfs, which would be a massive change that could
introduce regressions into all the other RAID levels; on the other hand,
if it was pushed up to that level, it would be possible to checksum the
parity blocks...

> On BTRFS this could be achieved using several BGs (=3D=3D block group or
> chunk), one for each stripe size.

Actually it's one per *possibly* failed disk (N^2 - N disks for RAID6).
Block groups are composed of *specific* disks...

> For example, if a filesystem - RAID5 is composed by 4 DISK, the
> filesystem should have three BGs: BG #1,composed by two disks (1
> data+ 1 parity) BG #2 composed by three disks (2 data + 1 parity)
> BG #3 composed by four disks (3 data + 1 parity).

=2E..i.e. you'd need block groups for disks ABCD, ABC, ABD, ACD, and BCD.

Btrfs doesn't allocate block groups that way anyway.  A much simpler
version of this is to make two changes:

	1.  Identify when disks go offline and mark block groups touching
	these disks as 'degraded'.  Currently this only happens at mount
	time, so the btrfs change would be to add the detection of state
	transition at the instant when a disk fails.

	2.  When a block group is degraded (i.e. some of its disks are
	missing), mark it strictly read-only and disable nodatacow.

Btrfs can already do #2 when balancing.  I've used this capability to
repair broken raid5 arrays.  Currently btrfs does *not* do this for
ordinary data writes, and that's the required change.

The trade-off for this approach is that if you didn't have any unallocated
space when a disk failed, you'll get ENOSPC for everything, because
there's no disk you could be allocating new metadata pages on.  That
makes it hard to add or replace disks.

> If the data to be written has a size of 4k, it will be allocated to
> the BG #1.  If the data to be written has a size of 8k, it will be
> allocated to the BG #2 If the data to be written has a size of 12k,
> it will be allocated to the BG #3 If the data to be written has a size
> greater than 12k, it will be allocated to the BG3, until the data fills
> a full stripes; then the remainder will be stored in BG #1 or BG #2.

OK I think I'm beginning to understand this idea better.  Short writes
degenerate to RAID1, and large writes behave more like RAID5.  No disk
format change is required because newer kernels would just allocate
block groups and distribute data differently.

That might be OK on SSD, but on spinning rust (where you're most likely
to find a RAID5 array) it'd be really seeky.  It'd also make 'df' output
even less predictive of actual data capacity.

Going back to the earlier example (but on 5 disks) we now have:

	block groups with 5 disks:
	D1 D2 D3 D4 P1
	F1 F2 F3 P2 F4
	F5 F6 P3 F7 F8

	block groups with 4 disks:
	E1 E2 E3 P4
	D5 D6 P5 D7

	block groups with 3 disks:
	(none)

	block groups with 2 disks:
	F9 P6

Now every parity block contains data from only one transaction, but=20
extents D and F are separated by up to 4GB of disk space.

> To avoid unbalancing of the disk usage, each BG could use all the disks,
> even if a stripe uses less disks: i.e
>
> DISK1 DISK2 DISK3 DISK4 S1    S1    S1    S2 S2    S2    S3    S3 S3
> S4    S4    S4 [....]
>
> Above is show a BG which uses all the four disks, but has a stripe
> which spans only 3 disks.

This isn't necessary.  Ordinary btrfs block group allocations will take
care of this if they use the most-free-disk-space-first algorithm (like
raid1 does, spreading out block groups using pairs of disks across all
the available disks).  The only requirement is to have separate block
groups divided into groups with 2, 3, and 4 (up to N) disks in them.
The final decision of _which_ disks to allocate can be done on the fly
as required by space demands.

When the disk does get close to full, this would lead to some nasty
early-ENOSPC issues.  It's bad enough now with just two competing
allocators (metadata and data)...imagine those problems multiplied by
10 on a big RAID5 array.

> Pro: - btrfs already is capable to handle different BG in the
> filesystem, only the allocator has to change - no more RMW are required
> (=3D=3D higher performance)
>
> Cons: - the data will be more fragmented - the filesystem, will have
> more BGs; this will require time-to time a re-balance. But is is an
> issue which we already know (even if may be not 100% addressed).
>
>
> Thoughts ?

I initially proposed "plug extents" as an off-the-cuff strawman to show
how absurd an idea it was, but the more I think about it, the more I
think it might be the best hope for a short-term fix.

The original "plug extents" statement was:

	we would inject "plug" extents to fill up RAID5 stripes.  This
	lets us keep the 4K block size for allocations, but at commit
	(or delalloc) time we would fill up any gaps in new RAID stripes
	to prevent them from being modified.  As the real data is deleted
	from the RAID stripes, it would be replaced by "plug" extents to
	keep any new data from being allocated in the stripe.  When the
	stripe consists entirely of "plug" extents, the plug extent would
	be deleted, allowing the stripe to be allocated again.	The "plug"
	data would be zero for the purposes of parity reconstruction,
	regardless of what's on the disk.  Balance would just throw the
	plug extents away (no need to relocate them).

With the same three extents again:

	D1 D2 D3 D4 P1
	D5 D6 D7 P2 xx
	E1 E2 P3 E3 xx
	F1 P4 F2 F3 F4
	P5 F5 F6 F7 F8
	F9 xx xx xx P6

This doesn't fragment the data or the free space, but it does waste
some space between extents.  If all three extents were committed
in the same transaction, we don't need the plug extents, so it
looks like

	D1 D2 D3 D4 P1
	D5 D6 D7 P2 E1
	E2 E3 P3 F1 F2
	F3 P4 F4 F5 F6
	P5 F7 F8 F9 xx

which is the same as what btrfs does now *except* we would *only*
allow this when D, E, and F are part of the *same* transaction, and a
new transaction wouldn't allocate anything in the block after F9.

I now realize there's no need for any "plug extent" to physically
exist--the allocator can simply infer their existence on the fly by
noticing where the RAID stripe boundaries are, and remembering which
blocks it had allocated in the current uncommitted transaction.

Plug extents require no disk format change, older and newer kernels would
both read and write the same disk format, but newer kernels would write
with properly working CoW.

The tradeoff is that more balances would be required to avoid free space
fragmentation; on the other hand, typical RAID5 use cases involve storing
a lot of huge files, so the fragmentation won't be a very large percentage
of total space.  A few percent of disk capacity is a fair price to pay for
data integrity.

>
> BR G.Baroncelli
>
>
>
> -- gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5 --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

--+hZIELbchok2+JHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgwC9wACgkQgfmLGlazG5ysXwCgwQXT326ozyJJxWOFqcNQ/KVM
xxgAn2Evuo6JGUvPDyF5nnq5xEPNrKPr
=RQ9z
-----END PGP SIGNATURE-----

--+hZIELbchok2+JHy--
