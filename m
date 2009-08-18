From: Chris Samuel <chris@csamuel.org>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Tue, 18 Aug 2009 12:40:54 +1000
Message-ID: <200908181240.58480.chris@csamuel.org>
References: <4A89C1DA.6040601@rtr.ca> <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com> <4A8A0B76.1030800@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4290869.zOl6FmAl19";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A8A0B76.1030800@rtr.ca>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4290869.zOl6FmAl19
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Aug 2009 12:01:26 pm Mark Lord wrote:

> But really, it should be using DM/LVM when there are multiple devices.

Chris Mason addressed a number of these points in this January 2008 comment=
 on=20
LWN - http://lwn.net/Articles/265533/ - especially:

# This is something LVM cannot provide because it cannot maintain
# consistent checksums for the FS.

and

# When multiple devices are present, Btrfs will want to know it is
# mirroring on different physical spindles.  This is a challenge
# with LVM since the locations of physical extents can change without
# the FS knowing about it.  Even if there were hooks so the FS could
# know the current extent mappings, it would end up duplicating a copy
# of the mappings internally.

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart4290869.zOl6FmAl19
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUASooUto1yjaOTJg85AQInfwgAhSDCQvIl8Demk6sBzDHsTRyWLbNh6Z+c
v+U9E5r8fBPGfJiQDH2h5JwzRsqnT6uYZHNhfN/ProtvfwnyzOBqlx8rJRwhBGcn
n+r2RR5hwDZjRUrghkj+NEgrt3fiEICR7NqQNnAsizlHMxkPq5aTV/2Vg6aogdFa
taw71PmWiy66I79mPl8tvP1K2RYpQClysP0I3YmPnT3Kc3jXZMp0apHUwPt5TFpR
RoP1DGxRmKBKol3gOlkuPR/bK21C8HEnJCvZj/OyxXNlp/7y0NxgonNORFIuFyTQ
MseJao5gF03+GtfIumFa2jF0Llj41fS8U2ysHjFc+biPxEEfLUf5RQ==
=k1gh
-----END PGP SIGNATURE-----

--nextPart4290869.zOl6FmAl19--
