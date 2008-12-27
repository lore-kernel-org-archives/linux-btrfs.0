From: Chris Samuel <chris@csamuel.org>
Subject: Re: multiple device usage
Date: Sat, 27 Dec 2008 17:45:42 +1100
Message-ID: <200812271745.45860.chris@csamuel.org>
References: <556243856@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart175776876.kpia2mOGLf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <556243856@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart175776876.kpia2mOGLf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 27 Dec 2008 10:15:18 am devzero@web.de wrote:

> http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

I'll add two questions that're not answered by the Wiki too.. :-)

1) If you add a second disk to an existing btrfs filesystem, can you get it=
 to=20
set it up as a RAID-1 arrangement rather than just rebalancing the metadata=
=20
and then striping ?

2) With the concerns that people have about SSD reliability (hi Val :-) !)=
=20
would it make sense to set up two equal sized partitions on the SSD and use=
=20
RAID-1 across them, or can you tell btrfs to keep multiple copies of the da=
ta,=20
a la ZFS ?

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart175776876.kpia2mOGLf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVXPGY1yjaOTJg85AQJ7sggAuI6CljDov1H/ZCzzkDd+2zbD9jwq0Iqj
JwsrZf2iWg9eI2SxHRa9wvx7EnOi0dOxy+F9hMTumRu7r4OFA7sxgXDYNHDfHe4v
LTfqEeSs0KRTURoTdWc0SnHDHJhOyoVH5cQK1Ou8/F//Bsl1jhX5AdlOsPl50gwM
yRA47u/z7xCzQSTz3cqRdAr14M0BaSIgYUt5YRoQaoMerV2bElCOORVOwLXPSYu4
2LlAun9oiprRBQxbEpRRqpmSqIQWJ+2hCeb0D49xz6Zf/JxUznNJ6j6dMVryA+zQ
AI1SDGJ0tT457+iARvFBj2QNfe7VmgREUoJHO8AEcKsgPHFPKKubTw==
=Q+8G
-----END PGP SIGNATURE-----

--nextPart175776876.kpia2mOGLf--
