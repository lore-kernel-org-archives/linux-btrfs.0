Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34978 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753534AbcJMVEA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 17:04:00 -0400
Date: Thu, 13 Oct 2016 17:03:46 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161013210346.GY21290@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
 <20161012171936.GD26140@hungrycats.org>
 <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4mUolEm2oNas7DxE"
In-Reply-To: <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4mUolEm2oNas7DxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2016 at 08:35:02AM +0800, Qu Wenruo wrote:
> At 10/13/2016 01:19 AM, Zygo Blaxell wrote:
> >On Wed, Oct 12, 2016 at 01:48:58PM +0800, Qu Wenruo wrote:
> >>True, but if we ignore parity, we'd find that, RAID5 is just RAID0.
> >
> >Degraded RAID5 is not RAID0.  RAID5 has strict constraints that RAID0
> >does not.  The way a RAID5 implementation behaves in degraded mode is
> >the thing that usually matters after a disk fails.
> >
> >>COW ensures (cowed) data and metadata are all safe and checksum will en=
sure
> >>they are OK, so even for RAID0, it's not a problem for case like power =
loss.
> >
> >This is not true.  btrfs does not use stripes correctly to get CoW to
> >work on RAID5/6.  This is why power failures result in small amounts of
> >data loss, if not filesystem-destroying disaster.
>=20
> See my below comments.
>=20
> And, I already said, forget parity.
> In that case, RAID5 without parity is just RAID0 with device rotation.

This is only true in one direction.

If you start with RAID0, add parity, and rotate the blocks on the devices,
you get RAID5.  Each individual non-parity block is independent of every
other block on every other disk.

If you start with RAID5 and remove one device, the result is *not* RAID0.
Each individual block is now entangled with N other blocks on all the
other disks.

On RAID0 there's no parity.  On RAID5 with no failed devices parity is
irrelevant.  On RAID5 with a failed device, parity touches *all* data.

> >For CoW to work you have to make sure that you never modify a RAID stripe
> >that already contains committed data.  Let's consider a 5-disk array
> >and look at what we get when we try to reconstruct disk 2:
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5
> >	Data1  Data2  Parity Data3  Data4
> >
> >Suppose one transaction writes Data1-Data4 and Parity.  This is OK
> >because no metadata reference would point to this stripe before it
> >was committed to disk.  Here's some data as an example:
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
> >	1111   2222   ffff   4444   8888   2222
>=20
> Why do the d*mn reconstruction without checking csum?

If a disk fails, we need stripe reconstruction to rebuild the data before
we can verify its csum.  There is no disk to read the data from directly.

> My strategy is clear enough.
> Never trust parity unless all data and reconstructed data matches csum.
>=20
> Csum is more precious than the unreliable parity.

We always have csum to verify at the end (and if we aren't verifying it at
the end, that's a bug).  It doesn't help the parity to be more reliable.

> So, please forget csum first, just consider it as RAID0, and add parity b=
ack
> when all csum matches with each other.

I can't reconstruct parity in the degraded RAID5 write case.  That only
works in the scrub case.

Even with all disks present on RAID5, parity gets corrupted during writes.
The corruption is hidden by the fact that we can ignore parity and use the
data blocks instead, but it is revealed when one of the disks is missing
or has a csum failure.

> >(to keep things simpler I'm just using Parity =3D Data1 ^ Data2 ^ Data4 ^
> >Data5 here)
> >
> >Later, a transaction deletes Data3 and Data 4.  Still OK, because
> >we didn't modify any data in the stripe, so we may still be able to
> >reconstruct the data from missing disks.  The checksums for Data4 and
> >Data5 are missing, so if there is any bitrot we lose the whole stripe
> >(we can't tell whether the data is wrong or parity, we can't ignore the
> >rotted data because it's included in the parity, and we didn't update
> >the parity because deleting an extent doesn't modify its data stripe).
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
> >	1111   2222   ffff   4444   8888   2222
>=20
> So data stripes are 1111, 2222, 4444, 8888.
> If trans committed, then csum and extents of 4444,8888 is also deleted.
> If trans not committed, 4444,8888 csum and extents exists.
>=20
> Any way, if we check data stripes against their csum, they should match.

Let's assume they do.  If any one of the csums are wrong and all the
disks are online, we need correct parity to reconstruct the data blocks
with bad csums.  This imposes a requirement that we keep parity correct!

If any of the csums are wrong *and* a disk is missing, the affected
data blocks are irretrievable because there is no redundant data to
reconstruct them.  Since that case isn't very interesting, let's only
consider what happens with no csum failures anywhere (only disk failures).

> Either way, we know all data stripes matches their csum, that's enough.
> No matter parity matches or not, it's just rubbish.
> Re-calculate it using scrub.

When one of the disks is missing, we must reconstruct from parity.
At this point we still can, because the stripe isn't modified when we
delete extents within it.

> >Now a third transaction allocates Data3 and Data 4.  Bad.  First, Disk4
> >is written and existing data is temporarily corrupted:
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
> >	1111   2222   ffff   1234   8888   7452
>=20
> Forget the d*mn parity please.

Can't.  Disk2 is missing, and all the data on it must be reconstructed
=66rom parity and other data blocks.  If we can't keep the parity correct
all the time then btrfs "raid5" is just a slow RAID0 with bitrot
self-repair.

> If trans not committed, 1234 doesn't have csum nor extent.
> If trans committed, 1234 has csum nor extent.

If Disk2 is missing, we have csums for Disk1 and Disk2, and parity for
Disk1 ^ Disk2 ^ Disk4 ^ Disk5; however, the Disk4 in Parity was not
computed with the data currently on Disk4, so when we recalculate the
data on the missing Disk2 (which is Disk1 ^ Disk3 ^ Disk4 ^ Disk5), we
get garbage (7452 instead of 2222).  We compare this with the checksum
of the data on Disk2 and determine (correctly) that it is wrong.

There is no csum for Disk4 until we committed the csum tree.  We can't
commit the csum tree before we write the data on Disk4 because then the
csum tree would have a mismatch for Disk4 until the write was finished.
If we write the data on Disk4 first then Parity is wrong and we can't
reconstruct Disk2.  If we write Parity first then Disk4 is wrong and
we can't reconstruct Disk2.

The data in Disk2 is not recoverable in this case.  csums are irrelevant.

There is another way to fix btrfs raid5 hidden in this:  We could keep the
parity correct if we updated the parity block when the blocks on Disk4
or Disk5 are deleted from the extent tree (i.e.  we'd define Parity =3D
xor(all blocks with csums), so Parity would be Disk1 ^ Disk2 and we could
reconstruct Disk2 (which is Disk1 ^ Parity) if it failed.  To do this,
we would need some way to update the Parity block and the csum tree
atomically, like a mirrored (not raid5 or raid6) stripe update journal.
btrfs currently doesn't have one of these, so a disk format change would
be required.  I don't think would be particularly fast when implemented,
either.  IMHO it's better to avoid modifying RAID5 stripes in-place
at all.

> 8888 has no extents nor csum, csum check will just skip it.
>=20
> Either way, they match csum thanks for COW.
> Parity is rubbish again.

If Disk2 is missing, we cannot reconstruct a block with a matching
csum any more because Parity is already wrong.

> I think you should get my point now.

I think we may be talking about completely different things.

> Parity is just rubbish, until csum mismatch with data.

Parity is the whole point of bothering with RAID5 in the first place.

> Thanks,
> Qu
> >
> >then Disk5 is written, and the data is still corrupted:
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
> >	1111   2222   ffff   1234   5678   aaa2
> >
> >then parity is written, and the data isn't corrupted any more:
> >
> >	Disk1  Disk2  Disk3  Disk4  Disk5  Reconstructed Disk2
> >	1111   2222   777f   1234   5678   2222
> >
> >If we are interrupted at any point after writing Data4 and before writing
> >Parity (even if these writes are arranged in any order), previously
> >committed data is corrupted.  If the drives have deep queues we could ha=
ve
> >multiple RAID stripes corrupted at once.  csum verification will not help
> >us because there are no csums for Disk4 and Disk5 yet--regardless of what
> >else happens, the csum tree is not committed until after we wrote Parity.
> >
> >This is not CoW at all.  It's not a rare event because the btrfs allocat=
or
> >intentionally tries to maintain locality, and therefore prefers to reuse
> >partially-filled RAID stripes instead of spreading allocations out over
> >empty stripes.  The location of damaged data changes rapidly over time,
> >but _something_ is damaged much of the time.
> >
> >It's a filesystem-eating disaster if the stripe contains metadata and
> >Disk2 fails.
> >
> >>So we should follow csum first and then parity.
> >>
> >>If we following this principle, RAID5 should be a raid0 with a little h=
igher
> >>possibility to recover some cases, like missing one device.
> >
> >That is much less than what most users expect from the name "raid5", and
> >much less than what should be possible from a CoW filesystem as well.
> >
> >>So, I'd like to fix RAID5 scrub to make it at least better than RAID0, =
not
> >>worse than RAID0.
> >
> >Do please continue fixing scrub!  I meant to point out only that there
> >are several other problems to fix before we can consider using btrfs
> >raid5 and especially raid6 for the purposes that users expect.
> >
> >>>btrfs doesn't avoid writing new data in the same RAID stripe
> >>>as old data (it provides a rmw function for raid56, which is simply a =
bug
> >>>in a CoW filesystem), so previously committed data can be lost.  If the
> >>>previously committed data is part of the metadata tree, the filesystem
> >>>is doomed; for ordinary data blocks there are just a few dozen to a few
> >>>thousand corrupted files for the admin to clean up after each crash.
> >>
> >>In fact, the _concept_ to solve such RMW behavior is quite simple:
> >>
> >>Make sector size equal to stripe length. (Or vice versa if you like)
> >>
> >>Although the implementation will be more complex, people like Chandan a=
re
> >>already working on sub page size sector size support.
> >
> >So...metadata blocks would be 256K on the 5-disk RAID5 example above,
> >and any file smaller than 256K would be stored inline?  Ouch.  That would
> >also imply the compressed extent size limit (currently 128K) has to beco=
me
> >much larger.
> >
> >I had been thinking that we could inject "plug" extents to fill up
> >RAID5 stripes.  This lets us keep the 4K block size for allocations,
> >but at commit (or delalloc) time we would fill up any gaps in new RAID
> >stripes to prevent them from being modified.  As the real data is deleted
> >from the RAID stripes, it would be replaced by "plug" extents to keep any
> >new data from being allocated in the stripe.  When the stripe consists
> >entirely of "plug" extents, the plug extent would be deleted, allowing
> >the stripe to be allocated again.  The "plug" data would be zero for
> >the purposes of parity reconstruction, regardless of what's on the disk.
> >Balance would just throw the plug extents away (no need to relocate them=
).
> >
> >For nodatacow files, btrfs would need to ensure that a nodatacow extent
> >never appears in the same RAID stripe as a CoW extent.  nodatacow files
> >would use RMW writes and not preserve data integrity in the case of any
> >failure.
> >
> >I'm not sure how to fit prealloc extents into this idea, since there wou=
ld
> >be no way to safely write to them in sub-stripe-sized units.
> >
> >>I think the sector size larger than page size is already on the TODO li=
st
> >>and when it's done, we can do real COW RAID5/6 then.
> >>
> >>Thanks,
> >>Qu
> >>
> >>>
> >>>It might be possible to hack up the allocator to pack writes into empty
> >>>stripes to avoid the write hole, but every time I think about this it
> >>>looks insanely hard to do (or insanely wasteful of space) for data
> >>>stripes.
> >>>
> >>
> >>
> >>
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4mUolEm2oNas7DxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf/9rIACgkQgfmLGlazG5wjYgCgz+36+YT2dMW6duqrwHHa5G2S
FKMAoLputm1oDxT9FQMm4I8VECowV+4C
=+obR
-----END PGP SIGNATURE-----

--4mUolEm2oNas7DxE--
