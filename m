From: Chris Samuel <chris@csamuel.org>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Wed, 8 Feb 2012 17:32:39 +1100
Message-ID: <201202081732.42843.chris@csamuel.org>
References: <20120205184128.GC18806@localhost.localdomain> <20120207033945.GA5639@localhost.localdomain> <pan.2012.02.07.09.53.58@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1409453.YM6B11Xp6k";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.07.09.53.58@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1409453.YM6B11Xp6k
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 07 February 2012 20:53:59 Duncan wrote:

> Kernel 3.2.2 is relatively recent altho you could=20
> try the latest 3.3 rc or git kernel as well

Please keep in mind that work done in git does not appear to get=20
backported to the stable updates for releases (such as 3.2.x), in=20
other words you'll have the same btrfs code as in the first 3.2=20
release.

You will need to use RC's (or git) for the current btrfs kernel code.

> Particularly when it's used on top of a dmcrypt layer that btrfs was
> known to have issues with

I believe the issues between btrfs and dm-crypt have been sorted out=20
as of 3.2 (going on an earlier posting of Chris Masons).

Returning to the OP's case, I'm surprised that ext4 is able to get=20
anything back and I'd say that's a testament to its long development=20
life (ext->ext2->ext3->ext4) in comparison to btrfs. If that happened=20
on a system I was sysadmin'ing (and it has - losing an entire tray of=20
drives in a RAID array due to controller firmware bugs really spoils=20
your day) I'd be reaching for the backup tapes about now.

Best of luck!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1409453.YM6B11Xp6k
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATzIXB41yjaOTJg85AQJgFAgAuYYhkGXXEUdavTUCUDYoMIYqwAdaazpF
q4J1kSBV6I1a9lhAanxMdB+ZuKiyTemej23yl/u2Izgg/JGhJaMhLUmaJ93f3QZU
7CifJoFaOLH7MJb2TdigVCp1OPVHQ2QOyAl4vdIxUd8Gh0whvcPkwOZOZ7utnCjs
zehNllzc77vHS3zFvwXpRvrE7AMmXXYPr/kGwjiLBVDhnxUEBBa2syUiStKQpOfJ
z3znXGtBRNsHC9mcGPF6MccStdzqxXLOCUe5lmNOauEc/j/bjJIpv83KRVYa8+bZ
NWvwHMRXr10zuMHEIm3f6vlOuA9/NfU5dOkT0RQYAZdK8p6+IsLiXg==
=OsKA
-----END PGP SIGNATURE-----

--nextPart1409453.YM6B11Xp6k--
