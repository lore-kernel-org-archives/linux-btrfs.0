Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34136 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbbBIWrm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 17:47:42 -0500
Date: Mon, 9 Feb 2015 22:47:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid5 with mixed disks
Message-ID: <20150209224740.GK28427@carfax.org.uk>
References: <CAGfcS_=Jz8Ktz3VMwkeKTZyAd5=8r+_YnkhDsVad9yGmpfkyAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M2Pxvdb9QxnGd/3e"
In-Reply-To: <CAGfcS_=Jz8Ktz3VMwkeKTZyAd5=8r+_YnkhDsVad9yGmpfkyAg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--M2Pxvdb9QxnGd/3e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 09, 2015 at 05:24:42PM -0500, Rich Freeman wrote:
> How does btrfs raid5 handle mixed-size disks?  The docs weren't
> terribly clear on this.
>=20
> Suppose I have 4x3TB and 1x1TB disks.  Using conventional lvm+mdadm in
> raid5 mode I'd expect to be able to fit about 10TB of space on those
> (2TB striped across 4 disks plus 1TB striped across 5 disks after
> partitioning).  How much would btrfs be able to store in the same
> configuration?  I did see something about being able to use fixed-size
> stripes, and I'm not sure if this helps.  If it does, are there any
> penalties, especially with future expansion of the array?
>=20
> With raid1 mode btrfrs is reasonably smart about mixed disk sizes, and
> you usually end up with half of the total space available.

   http://carfax.org.uk/btrfs-usage/ may be useful here.

   Hugo.

--=20
Hugo Mills             | "It was half way to Rivendell when the drugs began
hugo@... carfax.org.uk | to take hold"
http://carfax.org.uk/  |                                      Hunter S Tolk=
ien
PGP: 65E74AC0          |                        Fear and Loathing in Barad =
D=FBr

--M2Pxvdb9QxnGd/3e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU2TkMAAoJEFheFHXiqx3kPhEQAKxVswBKWARGHoqZSteVRSGg
Up95pvrQBBYuIctFK7i3yes9ucK6LbskGMGB8pUpfHpZduS3r437B236Zhoc5Lip
S1zHaqeveJXowtJz6Y0UjwTL/lStDLK1v9/yUWLaN3A7Ljc8vrE/7vlfibGt5SBP
5iFx4OGrvk3Zv4yt6yIb6Lx1fprzQ4ji48QkF7wM64HyQvQxX9C0fT1BINBketCa
mld8l+joHgYOXq2RauyvoWYtZax6/8PBS+2uBe9VRT5MJEEkNnZRX20EeaKmy00/
qCEBwc5+YMfYVWIEIZZu1UrRndvKJh3cAHl+fJygdVNGigEvUz9hFbBzqdoUD73B
OqZNdXi43U4NS2mKhXsGfo01CkpMbIf0ql/pyHGJE/QSz7co4h+ML7OUUWqPuPN2
JAF3hrYYURy/EyCQXa77thaCagbUiDEvA2op5+1ygbCFURA7oz/06yVy5ptntinV
X0ALklempf7932nWgHGrST59soKEoNb6vvljAAVpDFZJssowWg84wGi59MMhljHm
vqaZ1QdZIs38jWdsL6L4LU9U8//0LVqaljaZg5EM+e//EBas5kD9GQvyK10q5FDo
uevxq9NTOHRer3ESUUbTlziqbJwQrqegg+E3+D9OT9Uio35UAgnt7589fHDUANE7
tgAYLSUkpbmIH+6SlPTy
=zn2/
-----END PGP SIGNATURE-----

--M2Pxvdb9QxnGd/3e--
