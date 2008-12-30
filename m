From: Chris Samuel <chris@csamuel.org>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 21:45:22 +1100
Message-ID: <200812302145.25796.chris@csamuel.org>
References: <49597D06.1050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4672515.6hFZuPpCnm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49597D06.1050806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4672515.6hFZuPpCnm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 30 Dec 2008 12:44:38 pm Shen Feng wrote:

> I think the partition size is no correct since this is a raid-1 partition.
> The size should be half.

I've just run into this myself and so can confirm this issue on a btrfs=20
filesystem with 2 devices, where it is created by doing:

mkfs.btrfs -m raid1 /dev/sda10 /dev/sda11

modprobe btrfs

btrfsctl -a

mount /dev/sda10 /home

The df command shows it has twice the space I was expecting (61GB rather th=
an=20
30GB).  The btrfs-show command shows that it has two devices but doesn't=20
appear to contain any way to show the RAID level implemented.    I get the=
=20
same outcome if I mount /dev/sda11 instead of sda10.

Any ideas ?

Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart4672515.6hFZuPpCnm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVn7xY1yjaOTJg85AQJ0Twf7B6vku1tsdw6UR/BDHjY7tLEtK+vL3CRt
HruWUVvabt4K/wQMgGqsP2Av4sD+oLcJqJAP6Fn2P2yEpcxcyVESDH9MTIbi7qwe
6uczTGi3W4KCqbPaY+glz2HyI8xUG4i2NHff7tdeFFyuA0ljs/b7BfcW1uKE6W00
+Bb6Luo3u/ZRX7qobYkbqtJPGFofxe3OeFFcNPohDCqSqFHHJXubi0HqRCrQyhkS
uQV1X4AJ1cV9m7AkMZYPfv1sFdgkToZ1CJTiPMjJGvJf1gXHke39/jQuNRTOUlSN
pKb6ChbL4XuRp1/4RaKrL0JuZhixjNgf+0877CeVzJPO/KTiLOWlag==
=E0JQ
-----END PGP SIGNATURE-----

--nextPart4672515.6hFZuPpCnm--
