From: Chris Samuel <chris@csamuel.org>
Subject: Re: An issue when mounting the dd-copied partition and the original one together
Date: Fri, 20 Apr 2012 17:20:42 +1000
Message-ID: <201204201720.44788.chris@csamuel.org>
References: <CAOLNCyrvxNi-wKYdPaUX9Qvpzi7RhVjDgmig-Mr1_M5HmXza2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6485503.D8KcOqG4D4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAOLNCyrvxNi-wKYdPaUX9Qvpzi7RhVjDgmig-Mr1_M5HmXza2Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart6485503.D8KcOqG4D4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 20 April 2012 16:49:48 Tydus Ken wrote:

> I guess there's something wrong with btrfs in how to deal with two
> partition with same UUID or something else, but I'm not sure.

I don't believe that btrfs can cope with partitions with the same UID. =20
A pointer here from Auke in July 2011:

http://marc.info/?l=3Dlinux-btrfs&m=3D131161949201880&w=3D2

# Resetting the UUID on btrfs isn't a quick-and-easy thing - you
# have to walk the entire tree and change every object. We've got
# a bad-hack in meego that uses btrfs-debug-tree and changes the
# UUID while it runs the entire tree, but it's ugly as hell.
#
# You shouldn't clone btrfs really, just make a new filesystem.

That hack is for an unmounted filesystem, but I don't believe it's=20
been shared on this list.

Jan Schmidt was working on a "btrfs send" type command to help with=20
this, but I've not heard anything recently (last December he posted=20
that he was distracted by the backref-walking code which was a=20
necessary precursor for the send/receive code).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart6485503.D8KcOqG4D4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT5EOSo1yjaOTJg85AQKthAgAmsLS17/dWXeMa7MADvC+ji0Yh/2hycyf
QYyUcNEjnPAhoyedOsE5IWVL8Fq5KP88ZVHoYX1w9cIk/hJv1rh6rRPYFejiajlH
NlH1bE2CMlqlelwkLTqjfNdfAKHtFfUXLJzaNyoZMV3R27prah9mMKE7hDPu3cTq
fUwDLiRc5TZn+3Omq5zYvhvq/Tx4xJP2zzrL6KVb084hniRF0QP9EtiR5W93EsHv
VLvtNxLo2WSZUM8vwOgJyj4wj3Bav7DdZWiAKWqYnOH5c1lVCVzoppxTvwzmHPNl
APG23MeyekvGw4w3a1ept/3WdZ2Erwv2hGyrrBfU2vXovret7jAV5w==
=pPQI
-----END PGP SIGNATURE-----

--nextPart6485503.D8KcOqG4D4--
