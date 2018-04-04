Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40716 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752448AbeDDWiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 18:38:51 -0400
Date: Wed, 4 Apr 2018 18:38:39 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Status of RAID5/6
Message-ID: <20180404223839.GM2446@hungrycats.org>
References: <20180402054521.GC28769@hungrycats.org>
 <df74c8a6-b748-20c5-8bef-eb261b645b29@inwind.it>
 <7c76dae7-b38c-d514-4284-1cd093f5bcac@gmail.com>
 <20180402222250.GH2446@hungrycats.org>
 <20180403003102.GI2446@hungrycats.org>
 <242e2515-fad2-e98d-3e59-c0838362afdc@inwind.it>
 <20180403225742.GJ2446@hungrycats.org>
 <cfae662a-d64d-6fd8-9ca3-9892fc349747@inwind.it>
 <20180404060101.GK2446@hungrycats.org>
 <3c7e2da6-0328-5526-9a00-f480086a3935@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yaap9KN+GmBP785v"
In-Reply-To: <3c7e2da6-0328-5526-9a00-f480086a3935@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yaap9KN+GmBP785v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2018 at 11:31:33PM +0200, Goffredo Baroncelli wrote:
> On 04/04/2018 08:01 AM, Zygo Blaxell wrote:
> > On Wed, Apr 04, 2018 at 07:15:54AM +0200, Goffredo Baroncelli wrote:
> >> On 04/04/2018 12:57 AM, Zygo Blaxell wrote:
> [...]
> >> Before you pointed out that the non-contiguous block written has
> >> an impact on performance. I am replaying  that the switching from a
> >> different BG happens at the stripe-disk boundary, so in any case the
> >> block is physically interrupted and switched to another disk
> >=20
> > The difference is that the write is switched to a different local addre=
ss
> > on the disk.
> >=20
> > It's not "another" disk if it's a different BG.  Recall in this plan
> > there is a full-width BG that is on _every_ disk, which means every
> > small-width BG shares a disk with the full-width BG.  Every extent tail
> > write requires a seek on a minimum of two disks in the array for raid5,
> > three disks for raid6.  A tail that is strip-width minus one will hit
> > N - 1 disks twice in an N-disk array.
>=20
> Below I made a little simulation; my results telling me another thing:
>=20
> Current BTRFS (w/write hole)
>=20
> Supposing 5 disk raid 6 and stripe size=3D64kb*3=3D192kb (disk stripe=3D6=
4kb)
>=20
> Case A.1): extent size =3D 192kb:
> 5 writes of 64kb spread on 5 disks (3data + 2 parity)
>=20
> Case A.2.2): extent size =3D 256kb: (optimistic case: contiguous space av=
ailable)
> 5 writes of 64kb spread on 5 disks (3 data + 2 parity)
> 2 reads of 64 kb spread on 2 disks (two old data of the stripe) [**]
> 3 writes of 64 kb spread on 3 disks (data + 2 parity)
>=20
> Note that the two reads are contiguous to the 5 writes both in term of
> space and time. The three writes are contiguous only in terms of space,
> but not in terms of time, because these could happen only after the 2
> reads and the consequent parities computations. So we should consider
> that between these two events, some disk activities happen; this means
> seeks between the 2 reads and the 3 writes
>=20
>=20
> BTRFS with multiple BG (wo/write hole)
>=20
> Supposing 5 disk raid 6 and stripe size=3D64kb*3=3D192kb (disk stripe=3D6=
4kb)
>=20
> Case B.1): extent size =3D 192kb:
> 5 writes of 64kb spread on 5 disks
>=20
> Case B.2): extent size =3D 256kb:
> 5 writes of 64kb spread on 5 disks in BG#1
> 3 writes of 64 kb spread on 3 disks in BG#2 (which requires 3 seeks)
>=20
> So if I count correctly:
> - case B1 vs A1: these are equivalent
> - case B2 vs A2.1/A2.2:
> 	8 writes vs 8 writes
> 	3 seeks vs 3 seeks
> 	0 reads vs 2 reads
>=20
> So to me it seems that the cost of doing a RMW cycle is worse than
> seeking to another BG.

Well, RMW cycles are dangerous, so being slow as well is just a second
reason never to do them.

> Anyway I am reaching the conclusion, also thanks of this discussion,
> that this is not enough. Even if we had solve the problem of the
> "extent smaller than stripe" write, we still face gain this issue when
> part of the file is changed.
> In this case the file update breaks the old extent and will create a
> three extents: the first part, the new part, the last part. Until that
> everything is OK. However the "old" part of the file would be marked
> as free space. But using this part could require a RMW cycle....

You cannot use that free space within RAID stripes because it would
require RMW, and RMW causes write hole.  The space would have to be kept
unavailable until the rest of the RAID stripe was deleted.

OTOH, if you can solve that free space management problem, you don't
have to do anything else to solve write hole.  If you never RMW then
you never have the write hole in the first place.

> I am concluding that the only two reliable solution are=20
> a) variable stripe size (like ZFS does)=20
> or b) logging the RMW cycle of a stripe=20

Those are the only solutions that don't require a special process for
reclaiming unused space in RAID stripes.  If you have that, you have a
few more options; however, they all involve making a second copy of the
data at a later time (as opposed to option b, which makes a second
copy of the data during the original write).

a) also doesn't support nodatacow files (AFAIK ZFS doesn't have those)
and it would require defrag to get the inefficiently used space back.

b) is the best of the terrible options.  It minimizes the impact on the
rest of the filesystem since it can fix RMW inconsistency without having
to eliminate the RMW cases.  It doesn't require rewriting the allocator
nor does it require users to run defrag or balance periodically.

> [**] Does someone know if the checksum are checked during this read ?
> [...]
> =20
> BR
> G.Baroncelli
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--yaap9KN+GmBP785v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWsVT2QAKCRCB+YsaVrMb
nHoHAJ0eg6LLiaJitk2zJ7z76dLPf/JWcACfdaIox0oYeSE7P0G37UwPZSFy1Q8=
=txHU
-----END PGP SIGNATURE-----

--yaap9KN+GmBP785v--
