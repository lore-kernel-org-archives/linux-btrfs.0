Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43412 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S932319AbcJLRUW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 13:20:22 -0400
Date: Wed, 12 Oct 2016 13:19:37 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012171936.GD26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
In-Reply-To: <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 01:48:58PM +0800, Qu Wenruo wrote:
> >btrfs also doesn't avoid the raid5 write hole properly.  After a crash,
> >a btrfs filesystem (like mdadm raid[56]) _must_ be scrubbed (resynced)
> >to reconstruct any parity that was damaged by an incomplete data stripe
> >update.
> > As long as all disks are working, the parity can be reconstructed
> >from the data disks.  If a disk fails prior to the completion of the
> >scrub, any data stripes that were written during previous crashes may
> >be destroyed.  And all that assumes the scrub bugs are fixed first.
>=20
> This is true.
> I didn't take this into account.
>=20
> But this is not a *single* problem, but 2 problems.
> 1) Power loss
> 2) Device crash
>=20
> Before making things complex, why not focusing on single problem.

Solve one problem at a time--but don't lose sight of the whole list of
problems either, especially when they are interdependent.

> Not to mention the possibility is much smaller than single problem.

Having field experience with both problems, I disagree with that.
The power loss/system crash problem is much more common than the device
failure/scrub problems.  More data is lost when a disk fails, but the
amount of data lost in a power failure isn't zero.  Before I gave up
on btrfs raid5, it worked out to about equal amounts of admin time
recovering from the two different failure modes.

> >If writes occur after a disk fails, they all temporarily corrupt small
> >amounts of data in the filesystem.  btrfs cannot tolerate any metadata
> >corruption (it relies on redundant metadata to self-repair), so when a
> >write to metadata is interrupted, the filesystem is instantly doomed
> >(damaged beyond the current tools' ability to repair and mount
> >read-write).
>=20
> That's why we used higher duplication level for metadata by default.
> And considering metadata size, it's much acceptable to use RAID1 for
> metadata other than RADI5/6.

Data RAID5 metadata RAID1 makes a limited amount of sense.  Small amounts
of data are still lost on power failures due to RMW on the data stripes.
It just doesn't break the entire filesystem because the metadata is
on RAID1 and RAID1 doesn't use RMW.

Data RAID6 does not make sense, unless we also have a way to have RAID1
make more than one mirror copy.  With one mirror copy an array is not
able to tolerate two disk failures, so the Q stripe for RAID6 is wasted
CPU and space.

> >Currently the upper layers of the filesystem assume that once data
> >blocks are written to disk, they are stable.  This is not true in raid5/6
> >because the parity and data blocks within each stripe cannot be updated
> >atomically.
>=20
> True, but if we ignore parity, we'd find that, RAID5 is just RAID0.

Degraded RAID5 is not RAID0.  RAID5 has strict constraints that RAID0
does not.  The way a RAID5 implementation behaves in degraded mode is
the thing that usually matters after a disk fails.

> COW ensures (cowed) data and metadata are all safe and checksum will ensu=
re
> they are OK, so even for RAID0, it's not a problem for case like power lo=
ss.

This is not true.  btrfs does not use stripes correctly to get CoW to
work on RAID5/6.  This is why power failures result in small amounts of
data loss, if not filesystem-destroying disaster.

For CoW to work you have to make sure that you never modify a RAID stripe
that already contains committed data.  Let's consider a 5-disk array
and look at what we get when we try to reconstruct disk 2:

	Disk1  Disk2  Disk3  Disk4  Disk5
	Data1  Data2  Parity Data3  Data4

Suppose one transaction writes Data1-Data4 and Parity.  This is OK
because no metadata reference would point to this stripe before it
was committed to disk.  Here's some data as an example:

	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
	1111   2222   ffff   4444   8888   2222

(to keep things simpler I'm just using Parity =3D Data1 ^ Data2 ^ Data4 ^
Data5 here)

Later, a transaction deletes Data3 and Data 4.  Still OK, because
we didn't modify any data in the stripe, so we may still be able to
reconstruct the data from missing disks.  The checksums for Data4 and
Data5 are missing, so if there is any bitrot we lose the whole stripe
(we can't tell whether the data is wrong or parity, we can't ignore the
rotted data because it's included in the parity, and we didn't update
the parity because deleting an extent doesn't modify its data stripe).

	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
	1111   2222   ffff   4444   8888   2222

Now a third transaction allocates Data3 and Data 4.  Bad.  First, Disk4
is written and existing data is temporarily corrupted:

	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
	1111   2222   ffff   1234   8888   7452

then Disk5 is written, and the data is still corrupted:

	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
	1111   2222   ffff   1234   5678   aaa2

then parity is written, and the data isn't corrupted any more:

	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
	1111   2222   777f   1234   5678   2222

If we are interrupted at any point after writing Data4 and before writing
Parity (even if these writes are arranged in any order), previously
committed data is corrupted.  If the drives have deep queues we could have
multiple RAID stripes corrupted at once.  csum verification will not help
us because there are no csums for Disk4 and Disk5 yet--regardless of what
else happens, the csum tree is not committed until after we wrote Parity.

This is not CoW at all.  It's not a rare event because the btrfs allocator
intentionally tries to maintain locality, and therefore prefers to reuse
partially-filled RAID stripes instead of spreading allocations out over
empty stripes.  The location of damaged data changes rapidly over time,
but _something_ is damaged much of the time.

It's a filesystem-eating disaster if the stripe contains metadata and
Disk2 fails.

> So we should follow csum first and then parity.
>=20
> If we following this principle, RAID5 should be a raid0 with a little hig=
her
> possibility to recover some cases, like missing one device.

That is much less than what most users expect from the name "raid5", and
much less than what should be possible from a CoW filesystem as well.

> So, I'd like to fix RAID5 scrub to make it at least better than RAID0, not
> worse than RAID0.

Do please continue fixing scrub!  I meant to point out only that there
are several other problems to fix before we can consider using btrfs
raid5 and especially raid6 for the purposes that users expect.

> > btrfs doesn't avoid writing new data in the same RAID stripe
> >as old data (it provides a rmw function for raid56, which is simply a bug
> >in a CoW filesystem), so previously committed data can be lost.  If the
> >previously committed data is part of the metadata tree, the filesystem
> >is doomed; for ordinary data blocks there are just a few dozen to a few
> >thousand corrupted files for the admin to clean up after each crash.
>=20
> In fact, the _concept_ to solve such RMW behavior is quite simple:
>=20
> Make sector size equal to stripe length. (Or vice versa if you like)
>=20
> Although the implementation will be more complex, people like Chandan are
> already working on sub page size sector size support.

So...metadata blocks would be 256K on the 5-disk RAID5 example above,
and any file smaller than 256K would be stored inline?  Ouch.  That would
also imply the compressed extent size limit (currently 128K) has to become
much larger.

I had been thinking that we could inject "plug" extents to fill up
RAID5 stripes.  This lets us keep the 4K block size for allocations,
but at commit (or delalloc) time we would fill up any gaps in new RAID
stripes to prevent them from being modified.  As the real data is deleted
=66rom the RAID stripes, it would be replaced by "plug" extents to keep any
new data from being allocated in the stripe.  When the stripe consists
entirely of "plug" extents, the plug extent would be deleted, allowing
the stripe to be allocated again.  The "plug" data would be zero for
the purposes of parity reconstruction, regardless of what's on the disk.
Balance would just throw the plug extents away (no need to relocate them).

For nodatacow files, btrfs would need to ensure that a nodatacow extent
never appears in the same RAID stripe as a CoW extent.  nodatacow files
would use RMW writes and not preserve data integrity in the case of any
failure.

I'm not sure how to fit prealloc extents into this idea, since there would
be no way to safely write to them in sub-stripe-sized units.

> I think the sector size larger than page size is already on the TODO list
> and when it's done, we can do real COW RAID5/6 then.
>=20
> Thanks,
> Qu
>=20
> >
> >It might be possible to hack up the allocator to pack writes into empty
> >stripes to avoid the write hole, but every time I think about this it
> >looks insanely hard to do (or insanely wasteful of space) for data
> >stripes.
> >
>=20
>=20
>=20

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf+cKgACgkQgfmLGlazG5zF8QCggPRWY8dIxzD5eysYpNqqj1R4
/2IAn0ehjaniR4VwBilByEpaHXG0ZDrK
=mpic
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
