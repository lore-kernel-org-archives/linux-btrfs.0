Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39526 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753427AbcK2Wv3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 17:51:29 -0500
Date: Tue, 29 Nov 2016 17:51:27 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RFC: raid with a variable stripe size
Message-ID: <20161129225127.GS8685@hungrycats.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
 <20161129035355.GQ8685@hungrycats.org>
 <4270b44d-7336-cd22-104a-c79058955757@cn.fujitsu.com>
 <20161129045537.GR8685@hungrycats.org>
 <07d2e8cf-fb23-b2f1-cc69-f329d8347301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Sf3MmCJcUNNLokcm"
In-Reply-To: <07d2e8cf-fb23-b2f1-cc69-f329d8347301@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Sf3MmCJcUNNLokcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 01:49:09PM +0800, Qu Wenruo wrote:
> >>>My proposal requires only a modification to the extent allocator.
> >>>The behavior at the block group layer and scrub remains exactly the sa=
me.
> >>>We just need to adjust the allocator slightly to take the RAID5 CoW
> >>>constraints into account.
> >>
> >>Then, you'd need to allow btrfs to split large buffered/direct write in=
to
> >>small extents(not 128M anymore).
> >>Not sure if we need to do extra work for DirectIO.
> >
> >Nope, that's not my proposal.  My proposal is to simply ignore free
> >space whenever it's inside a partially filled raid stripe (optimization:
> >...which was empty at the start of the current transaction).
>=20
> Still have problems.
>=20
> Allocator must handle fs under device remove or profile converting (from 4
> disks raid5 to 5 disk raid5/6) correctly.
> Which already seems complex for me.

Those would be allocations in separate block groups with different stripe
widths.  Already handled in btrfs.

> And further more, for fs with more devices, for example, 9 devices RAID5.
> It will be a disaster to just write a 4K data and take up the whole 8 * 6=
4K
> space.
> It will  definitely cause huge ENOSPC problem.

If you called fsync() after every 4K, yes; otherwise you can just batch
up small writes into full-size stripes.  The worst case isn't common
enough to be a serious problem for a lot of the common RAID5 use cases
(i.e. non-database workloads).  I wouldn't try running a database on
it--I'd use a RAID1 or RAID10 array for that instead, because the other
RAID5 performance issues would be deal-breakers.

On ZFS the same case degenerates into something like btrfs RAID1 over
the 9 disks, which burns over 50% of the space.  More efficient than=20
wasting 99% of the space, but still wasteful.

> If you really think it's easy, make a RFC patch, which should be easy if =
it
> is, then run fstest auto group on it.

I plan to when I get time; however, that could be some months in the
future and I don't want to "claim" the task and stop anyone else from
taking a crack at it in the meantime.

> Easy words won't turn emails into real patch.
>=20
> >That avoids modifying a stripe with committed data and therefore plugs t=
he
> >write hole.
> >
> >For nodatacow, prealloc (and maybe directio?) extents the behavior
> >wouldn't change (you'd have write hole, but only on data blocks not
> >metadata, and only on files that were already marked as explicitly not
> >requiring data integrity).
> >
> >>And in fact, you're going to support variant max file extent size.
> >
> >The existing extent sizing behavior is not changed *at all* in my propos=
al,
> >only the allocator's notion of what space is 'free'.
> >
> >We can write an extent across multiple RAID5 stripes so long as we
> >finish writing the entire extent before pointing committed metadata to
> >it.  btrfs does that already otherwise checksums wouldn't work.
> >
> >>This makes delalloc more complex (Wang enhanced dealloc support for var=
iant
> >>file extent size, to fix ENOSPC problem for dedupe and compression).
> >>
> >>This is already much more complex than you expected.
> >
> >The complexity I anticipate is having to deal with two implementations
> >of the free space search, one for free space cache and one for free
> >space tree.
> >
> >It could be as simple as calling the existing allocation functions and
> >just filtering out anything that isn't suitably aligned inside a raid56
> >block group (at least for a proof of concept).
> >
> >>And this is the *BIGGEST* problem of current btrfs:
> >>No good enough(if there is any) *ISOLATION* for such a complex fs.
> >>
> >>So even "small" modification can lead to unexpected bugs.
> >>
> >>That's why I want to isolate the fix in RAID56 layer, not any layer upw=
ards.
> >
> >I don't think the write hole is fixable in the current raid56 layer, at
> >least not without a nasty brute force solution like stripe update journa=
l.
> >
> >Any of the fixes I'd want to use fix the problem from outside.
> >
> >>If not possible, I prefer not to do anything yet, until we are sure the=
 very
> >>basic part of RAID56 is stable.
> >>
> >>Thanks,
> >>Qu
> >>
> >>>
> >>>It's not as efficient as the ZFS approach, but it doesn't require an
> >>>incompatible disk format change either.
> >>>
> >>>>>On BTRFS this could be achieved using several BGs (=3D=3D block grou=
p or chunk), one for each stripe size.
> >>>>>
> >>>>>For example, if a filesystem - RAID5 is composed by 4 DISK, the file=
system should have three BGs:
> >>>>>BG #1,composed by two disks (1 data+ 1 parity)
> >>>>>BG #2 composed by three disks (2 data + 1 parity)
> >>>>>BG #3 composed by four disks (3 data + 1 parity).
> >>>>
> >>>>Too complicated bg layout and further extent allocator modification.
> >>>>
> >>>>More code means more bugs, and I'm pretty sure it will be bug prone.
> >>>>
> >>>>
> >>>>Although the idea of variable stripe size can somewhat reduce the pro=
blem
> >>>>under certain situation.
> >>>>
> >>>>For example, if sectorsize is 64K, and we make stripe len to 32K, and=
 use 3
> >>>>disc RAID5, we can avoid such write hole problem.
> >>>>Withouth modification to extent/chunk allocator.
> >>>>
> >>>>And I'd prefer to make stripe len mkfs time parameter, not possible to
> >>>>modify after mkfs. To make things easy.
> >>>>
> >>>>Thanks,
> >>>>Qu
> >>>>
> >>>>>
> >>>>>If the data to be written has a size of 4k, it will be allocated to =
the BG #1.
> >>>>>If the data to be written has a size of 8k, it will be allocated to =
the BG #2
> >>>>>If the data to be written has a size of 12k, it will be allocated to=
 the BG #3
> >>>>>If the data to be written has a size greater than 12k, it will be al=
located to the BG3, until the data fills a full stripes; then the remainder=
 will be stored in BG #1 or BG #2.
> >>>>>
> >>>>>
> >>>>>To avoid unbalancing of the disk usage, each BG could use all the di=
sks, even if a stripe uses less disks: i.e
> >>>>>
> >>>>>DISK1 DISK2 DISK3 DISK4
> >>>>>S1    S1    S1    S2
> >>>>>S2    S2    S3    S3
> >>>>>S3    S4    S4    S4
> >>>>>[....]
> >>>>>
> >>>>>Above is show a BG which uses all the four disks, but has a stripe w=
hich spans only 3 disks.
> >>>>>
> >>>>>
> >>>>>Pro:
> >>>>>- btrfs already is capable to handle different BG in the filesystem,=
 only the allocator has to change
> >>>>>- no more RMW are required (=3D=3D higher performance)
> >>>>>
> >>>>>Cons:
> >>>>>- the data will be more fragmented
> >>>>>- the filesystem, will have more BGs; this will require time-to time=
 a re-balance. But is is an issue which we already know (even if may be not=
 100% addressed).
> >>>>>
> >>>>>
> >>>>>Thoughts ?
> >>>>>
> >>>>>BR
> >>>>>G.Baroncelli
> >>>>>
> >>>>>
> >>>>>
> >>>>
> >>>>
> >>
> >>
>=20
>=20

--Sf3MmCJcUNNLokcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg+Bm8ACgkQgfmLGlazG5yvAgCg6rIJeFuPSO0XMEGpuSkeirOd
OfIAn13DpVg6XtgbUZPX9PNZQIZ8DcC+
=KIyT
-----END PGP SIGNATURE-----

--Sf3MmCJcUNNLokcm--
