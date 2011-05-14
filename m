From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: data alignment for SSD: Stripe size or sector size given with -s?
Date: Sat, 14 May 2011 09:31:26 +0200
Message-ID: <201105140931.26389.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1350929.nJCX42tn2b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1350929.nJCX42tn2b
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

> [ANNOUNCE] Btrfs v0.9
> [...]
> * Stripe size parameter to mkfs.btrfs (-s size_in_bytes). Extents will
>  be aligned to the stripe size for performance.
> [...]
http://fixunix.com/kernel/258991-[announce]-btrfs-v0-9-a.html

versus

>        -s, --sectorsize size
>               Specify the sectorsize, the minimum block allocation.

(man mkfs.btrfs with btrfs-tools 0.19+20101101-1 debian package).

Which one applies? Or do both mention the same? My notion of a sector is=20
something different tough.

I wonder how to set a stripe size for alignment to erase blocks of an=20
Intel SSD 320. Or whether to set anything at all. I want to try to use GPT=
=20
with ThinkPad T520 UEFI BIOS.

I read from Chris that metadata is basically aligned at 2 MiB already with=
=20
mount option "ssd" which is default for non rotational media:

> Today, metadata allocations are 4k aligned but we do metadata
> allocations in cluster of 256k in size (2MB in size in mount -o ssd
> mode).  This results in larger metadata writes, and more contiguous
> metadata writes.  The larger writes give the SSD FTL a better chance of
> doing more optimal management of the flash.

(Re: SSDs and filesystem alignment... from 2009-02-23,
Message-Id: <1235398980.11205.5.camel@think.oraclecorp.com>)

But what about data alignment?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1350929.nJCX42tn2b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3OL84ACgkQmRvqrKWZhMfY3ACcDz0JIDvCADoYijtMVncbTLLT
yE8An0c+wHp6lBqAY8V2NxkFnE9VNPNw
=G6in
-----END PGP SIGNATURE-----

--nextPart1350929.nJCX42tn2b--
