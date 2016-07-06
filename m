Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35273 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbcGFRfX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 13:35:23 -0400
Received: by mail-it0-f65.google.com with SMTP id g4so157198ith.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 10:35:17 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data loss in archivers)
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8A951BA7-8A45-4F1C-839F-42652F01939D"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <577d32c9.TRqyIACgL+Y5Fmyj%Joerg.Schilling@fokus.fraunhofer.de>
Date: Wed, 6 Jul 2016 11:35:13 -0600
Cc: antonio@gnu.org, ahferroin7@gmail.com, linux-btrfs@vger.kernel.org,
        bug-tar@gnu.org
Message-Id: <2881735B-5267-482C-9E0E-734118A523AB@dilger.ca>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com> <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca> <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de> <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com> <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de> <577D191F.90709@gnu.org> <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de> <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com> <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de> <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com> <577d32c9.TRqyIACgL+Y5Fmyj%Joerg.Schilling@fokus.fraunhofer.de>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_8A951BA7-8A45-4F1C-839F-42652F01939D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


> On Jul 6, 2016, at 10:33 AM, Joerg Schilling =
<Joerg.Schilling@fokus.fraunhofer.de> wrote:
>=20
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>=20
>> On 2016-07-06 11:22, Joerg Schilling wrote:
>>>=20
>>>=20
>>> You are mistaken.
>>>=20
>>> stat /proc/$$/as
>>>  File: `/proc/6518/as'
>>>  Size: 2793472         Blocks: 5456       IO Block: 512    regular =
file
>>> Device: 5440000h/88342528d      Inode: 7557        Links: 1
>>> Access: (0600/-rw-------)  Uid: (   xx/   joerg)   Gid: (  xx/      =
bs)
>>> Access: 2016-07-06 16:33:15.660224934 +0200
>>> Modify: 2016-07-06 16:33:15.660224934 +0200
>>> Change: 2016-07-06 16:33:15.660224934 +0200
>>>=20
>>> stat /proc/$$/auxv
>>>  File: `/proc/6518/auxv'
>>>  Size: 168             Blocks: 1          IO Block: 512    regular =
file
>>> Device: 5440000h/88342528d      Inode: 7568        Links: 1
>>> Access: (0400/-r--------)  Uid: (   xx/   joerg)   Gid: (  xx/      =
bs)
>>> Access: 2016-07-06 16:33:15.660224934 +0200
>>> Modify: 2016-07-06 16:33:15.660224934 +0200
>>> Change: 2016-07-06 16:33:15.660224934 +0200
>>>=20
>>> Any correct implementation of /proc returns the expected numbers in
>>> st_size as well as in st_blocks.
>>=20
>> Odd, because I get 0 for both values on all the files in /proc/self =
and
>> all the top level files on all kernels I tested prior to sending that
>=20
> I tested this with an official PROCFS-2 implementation that was =
written by
> the inventor of the PROC filesystem (Roger Faulkner) who as a sad news =
pased
> away last weekend.
>=20
> You may have done your tests on an inofficial procfs =
implementation....

So, what you are saying is that you don't care about star working =
properly
on Linux, because it has an "inofficial" procfs implementation, while =
Solaris
has an "official" implementation?

>>> Now you know why BTRFS is still an incomplete filesystem. In a few =
years
>>> when it turns 10, this may change. People who implement filesystems =
of
>>> course need to learn that they need to hide implementation details =
from
>>> the official user space interfaces.
>>=20
>> So in other words you think we should be lying about how much is
>> actually allocated on disk and thus violating the standard directly =
(and
>> yes, ext4 and everyone else who does this with delayed allocation =
_is_
>> strictly speaking violating the standard, because _nothing_ is =
allocated
>> yet)?
>=20
> If it returns 0, it would be lying or it would be wrong anyway as it =
did not
> check fpe available space.
>=20
> Also note that I mentioned already that the priciple availability of =
SEEK_HOLE
> does not help as there is e.g. NFS...

So, it's OK that NFS is not POSIX compliant in various ways, and star =
will
deal with it, but you aren't willing to fix a heuristic used by star for =
a
behaviour that is unspecified by POSIX but has caused users to lose data
when archiving from several modern filesystems?

That's fine, so long as GNU tar is fixed to use the safe fallback in =
such
cases (i.e. trying to archive data from files that are newly created, =
even
if they report st_blocks =3D=3D 0).

Cheers, Andreas






--Apple-Mail=_8A951BA7-8A45-4F1C-839F-42652F01939D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV31BUnKl2rkXzB/gAQiDdw//YfekKeE3/5XjUuZwqkHJalqamaFe5BoD
DSQvj1vE4nfhRQGtQNsYf4Uo9Lo8a5IEgX06ifBify70rUT26x8hVqUGISHbopLz
fp8o5nc4AQNK24YWkjMxbzJ9BZFjBRtMC0Dx8geyAFV/TI+LFNunrf0cJ3OrIbx0
D+L5NWNar0bdEWHgPfBBfOnX7lF52sO41ECvpc8uzabdEblgM/HnIgRlYRt0fxee
mJa7meMcF9sPxIo6HRFTGtH04hRI9g9QRxG4s6/j4GhGw32McDbh53w6PbSeWA6W
7zcm0s7DOQ48K+kY5qVAaKt4bXo7mHX5QKzxQXl2txRwc6h8dxAmcUgJLGGBcnrf
t1+yrGnrDfJcG7rNjowBNsGAIPT19Rll/GjKXyYxZBFrzNOxs+z5clu7P35NmBAI
wW0EkjGk/6gGm2nXBYJmX5+ljL6S36TCQyEmF4Ih/bZvSRBOgo4fNq+mAnip1l/P
42xgQD9pFLtq2gGd9/Y9blA9ozHcb0qGMdWiW2nj034xBZ2ogvhvtQPQuaclNTxG
WJZj8/jL5l9BB4ILzPY9zjRddeDIpF1+mrnicGaEvJi0IC3XWStzWKpv5X5NhEFN
WBiIAwbQxN3Y0pH3DBWAqV71KbVL+EbBlomiABXQzdy4pirU5+PLK/9vUz/d6cqN
LtPGGY1j2zs=
=PGog
-----END PGP SIGNATURE-----

--Apple-Mail=_8A951BA7-8A45-4F1C-839F-42652F01939D--
