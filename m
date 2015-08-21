Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38723 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbHUJpO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 05:45:14 -0400
Date: Fri, 21 Aug 2015 09:45:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Message-ID: <20150821094509.GB20571@carfax.org.uk>
References: <2017000.AEG9PyVY17@zafu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
In-Reply-To: <2017000.AEG9PyVY17@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2015 at 10:19:54AM +0200, Sw=C3=A2mi Petaramesh wrote:
> Hello,
>=20
> BTRFS refuses to remove an empty dir and pretends it is not empty (and th=
ere=20
> is no BTRFS subvolume involved in there...)
>=20
> # uname -r
> 4.1.5-1-ARCH
>=20
>=20
> # ls -alnR .dropbox-old/
> .dropbox-old/:
> total 0
> drwx------ 1 1000 1000   18 21 ao=C3=BBt  09:59 .
> drwxr-x--- 1 1000 1000 2624 21 ao=C3=BBt  10:09 ..
> drwx------ 1 1000 1000  416 21 ao=C3=BBt  09:59 instance1
>=20
> .dropbox-old/instance1:
> total 0
> drwx------ 1 1000 1000 416 21 ao=C3=BBt  09:59 .
> drwx------ 1 1000 1000  18 21 ao=C3=BBt  09:59 ..
>=20
>=20
> # rm -rf .dropbox-old
> rm: cannot remove =E2=80=98.dropbox-old/instance1=E2=80=99: Directory not=
 empty
>=20
> # ls -alnR .dropbox-old/instance1/
> .dropbox-old/instance1/:
> total 0
> drwx------ 1 1000 1000 416 21 ao=C3=BBt  09:59 .
> drwx------ 1 1000 1000  18 21 ao=C3=BBt  09:59 ..
>=20
> # rm -rf .dropbox-old/instance1/
> rm: cannot remove =E2=80=98.dropbox-old/instance1/=E2=80=99: Directory no=
t empty
>=20
>=20
> How could this be fixed ?

   There was a bug long ago that produced subdirectories like
that. btrfs check should be able to deal with them.

   Hugo.

--=20
Hugo Mills             | "What's so bad about being drunk?"
hugo@... carfax.org.uk | "You ask a glass of water"
http://carfax.org.uk/  |                                         Arthur & F=
ord
PGP: E2AB1DE4          |                 The Hitch-Hiker's Guide to the Gal=
axy

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV1vMkAAoJEFheFHXiqx3kz5oQAJI7Nxyojd4RHh9MrU94EZMn
7uzyRfUjljeP1ijsa8H6W1DoYD08yIOiw7ALtj7Xo/w3RESG0wmwWBXH39XAoMyb
qCPY+yZ6k32UTqecq4Xe8o2et7HZey4Jzill9b3g/fsLOC7YCkiHuUobKHHHpYIL
hIpajE+Fl2bZg9Bckl19rR7CNwH4w6aw31B/ESs1HPBm+aEnKhzmeEknqcO+Nwub
vgd2e5clilVT5WBryc8cAtpGLiY2+Hg4nJm1h/svRiJgr8dotSN38WgNAvp4x4bQ
3vDa+lXHZ97YQHmVpTGiuJf6n5D2+gfdG6+9zvk5nIEGcQVVSgR4voMtaChDvoUH
L1Z16v8+j5Gq51scezZqeR/LBbcdeTjRFQceDWWAqnkXGyeZ8od55IqRQ2xxDppl
fainDZanzx9P6VPSVRcaqQhEE8MpAsszr+kSx4EwtHndOyyqscQqLYiAFYDXbmFp
TdIz3V0iijuGrWSB5wYeekfrJpjCE0cCTYc80ar6Mf2hVJHhSN6i7MoTw9T2s7B7
E7bOR1/xfGJLgkfr6OKvMQWnMLxdYrH93PhJaKbhk50P1roOS/9eBk3PR7coS3Ni
ePKsiQ057WTjRl0539FqRJeRoHBwuxwk3UNHLFR3eU10U0ICkQ0DMg7vW8SFNIRT
gAMIOSVjBl2MP5ofyKVz
=MbNx
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
