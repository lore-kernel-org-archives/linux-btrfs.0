From: Chris Samuel <chris@csamuel.org>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 22:14:30 +1100
Message-ID: <200812302214.32650.chris@csamuel.org>
References: <49597D06.1050806@cn.fujitsu.com> <200812302145.25796.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1916031.G8LYfWFAj7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812302145.25796.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1916031.G8LYfWFAj7
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 30 Dec 2008 9:45:22 pm Chris Samuel wrote:

> mkfs.btrfs -m raid1 /dev/sda10 /dev/sda11

Even doing what appears to be the correct method of:

mkfs.btrfs -d raid1 -m raid1 /dev/sda10 /dev/sda11

doesn't give any love, mkfs.btrfs still tells me the filesystem will be 60G=
B=20
(and the kernel agrees when it is mounted).

But mkfs.btrfs does correctly set data_profile to include=20
BTRFS_BLOCK_GROUP_RAID1 and does indeed call create_one_raid_group() with=20
BTRFS_BLOCK_GROUP_DATA in create_raid_groups() in mkfs.c.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart1916031.G8LYfWFAj7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVoCmI1yjaOTJg85AQKC+gf/ba29oclGULE3VHsZFm8hoyxDO/ARYqYE
5lrAgTlT1KlHGm59jOuQA13ZfsyuaSYFzzkqMLF2ClTbMr4ewfcaUbcEoRiKfEfO
Qu9YCynngPaBBY8XrA8KyurksBGdsrdxeKBx9W5tcys4fUg7gzvxq9BzlFsMzlFR
QyPZCrDZJXqSNEVFA57tFfak0IcDjP+Gg7qfrWKSg4GbRQs9NmYF7BBFT3sBsAjq
XnjnkjXZEu4/+UPZHYWfiJgbFmKStSVUfWjHR4hSH2aOXzp+c3Y9KEMW49694jVD
EtGeHjWN8t3W+10CAbJuIOR0wxTwfqt2JRlX5AhOiPVz4gyHQQWSiw==
=GaGK
-----END PGP SIGNATURE-----

--nextPart1916031.G8LYfWFAj7--
