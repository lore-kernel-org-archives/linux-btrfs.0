Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45046 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752894AbcK2EC7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 23:02:59 -0500
Date: Mon, 28 Nov 2016 22:53:55 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RFC: raid with a variable stripe size
Message-ID: <20161129035355.GQ8685@hungrycats.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4IFtMBbmeqbTM/ox"
In-Reply-To: <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4IFtMBbmeqbTM/ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 08:48:19AM +0800, Qu Wenruo wrote:
> At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
> >Hello,
> >
> >these are only my thoughts; no code here, but I would like to share it h=
oping that it could be useful.
> >
> >As reported several times by Zygo (and others), one of the problem
> of raid5/6 is the write hole. Today BTRFS is not capable to address it.
>=20
> I'd say, no need to address yet, since current soft RAID5/6 can't handle =
it
> yet.
>=20
> Personally speaking, Btrfs should implementing RAID56 support just like
> Btrfs on mdadm.

Even mdadm doesn't implement it the way btrfs does (assuming all bugs
are fixed) any more.

> See how badly the current RAID56 works?

> The marginally benefit of btrfs RAID56 to scrub data better than tradition
> RAID56 is just a joke in current code base.

> >The problem is that the stripe size is bigger than the "sector size"
> (ok sector is not the correct word, but I am referring to the basic
> unit of writing on the disk, which is 4k or 16K in btrfs).  >So when
> btrfs writes less data than the stripe, the stripe is not filled; when
> it is filled by a subsequent write, a RMW of the parity is required.
> >
> >On the best of my understanding (which could be very wrong) ZFS try
> to solve this issue using a variable length stripe.
>
> Did you mean ZFS record size?
> IIRC that's file extent minimum size, and I didn't see how that can handle
> the write hole problem.
>=20
> Or did ZFS handle the problem?

ZFS's strategy does solve the write hole.  In btrfs terms, ZFS embeds the
parity blocks within extents, so it behaves more like btrfs compression
in the sense that the data in a RAID-Z extent is encoded differently
=66rom the data in the file, and the kernel has to transform it on reads
and writes.

No ZFS stripe can contain blocks from multiple different
transactions because the RAID-Z stripes begin and end on extent
(single-transaction-write) boundaries, so there is no write hole on ZFS.

There is some space waste in ZFS because the minimum allocation unit
is two blocks (one data one parity) so any free space that is less
than two blocks long is unusable.  Also the maximum usable stripe width
(number of disks) is the size of the data in the extent plus one parity
block.  It means if you write a lot of discontiguous 4K blocks, you
effectively get 2-disk RAID1 and that may result in disappointing
storage efficiency.

(the above is for RAID-Z1.  For Z2 and Z3 add an extra block or two
for additional parity blocks).

One could implement RAID-Z on btrfs, but it's by far the most invasive
proposal for fixing btrfs's write hole so far (and doesn't actually fix
anything, since the existing raid56 format would still be required to
read old data, and it would still be broken).

> Anyway, it should be a low priority thing, and personally speaking,
> any large behavior modification involving  both extent allocator and bg
> allocator will be bug prone.

My proposal requires only a modification to the extent allocator.
The behavior at the block group layer and scrub remains exactly the same.
We just need to adjust the allocator slightly to take the RAID5 CoW
constraints into account.

It's not as efficient as the ZFS approach, but it doesn't require an
incompatible disk format change either.

> >On BTRFS this could be achieved using several BGs (=3D=3D block group or=
 chunk), one for each stripe size.
> >
> >For example, if a filesystem - RAID5 is composed by 4 DISK, the filesyst=
em should have three BGs:
> >BG #1,composed by two disks (1 data+ 1 parity)
> >BG #2 composed by three disks (2 data + 1 parity)
> >BG #3 composed by four disks (3 data + 1 parity).
>=20
> Too complicated bg layout and further extent allocator modification.
>=20
> More code means more bugs, and I'm pretty sure it will be bug prone.
>=20
>=20
> Although the idea of variable stripe size can somewhat reduce the problem
> under certain situation.
>=20
> For example, if sectorsize is 64K, and we make stripe len to 32K, and use=
 3
> disc RAID5, we can avoid such write hole problem.
> Withouth modification to extent/chunk allocator.
>=20
> And I'd prefer to make stripe len mkfs time parameter, not possible to
> modify after mkfs. To make things easy.
>=20
> Thanks,
> Qu
>=20
> >
> >If the data to be written has a size of 4k, it will be allocated to the =
BG #1.
> >If the data to be written has a size of 8k, it will be allocated to the =
BG #2
> >If the data to be written has a size of 12k, it will be allocated to the=
 BG #3
> >If the data to be written has a size greater than 12k, it will be alloca=
ted to the BG3, until the data fills a full stripes; then the remainder wil=
l be stored in BG #1 or BG #2.
> >
> >
> >To avoid unbalancing of the disk usage, each BG could use all the disks,=
 even if a stripe uses less disks: i.e
> >
> >DISK1 DISK2 DISK3 DISK4
> >S1    S1    S1    S2
> >S2    S2    S3    S3
> >S3    S4    S4    S4
> >[....]
> >
> >Above is show a BG which uses all the four disks, but has a stripe which=
 spans only 3 disks.
> >
> >
> >Pro:
> >- btrfs already is capable to handle different BG in the filesystem, onl=
y the allocator has to change
> >- no more RMW are required (=3D=3D higher performance)
> >
> >Cons:
> >- the data will be more fragmented
> >- the filesystem, will have more BGs; this will require time-to time a r=
e-balance. But is is an issue which we already know (even if may be not 100=
% addressed).
> >
> >
> >Thoughts ?
> >
> >BR
> >G.Baroncelli
> >
> >
> >
>=20
>=20

--4IFtMBbmeqbTM/ox
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg8+9MACgkQgfmLGlazG5y09gCfRWWsD73X+o1aoPhgP2iJjf9Q
JocAoJ44AR/RwdjdrZIU8E7k7p2+57z4
=LvSJ
-----END PGP SIGNATURE-----

--4IFtMBbmeqbTM/ox--
