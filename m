Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56132 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaGQIm4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 04:42:56 -0400
Date: Thu, 17 Jul 2014 09:42:54 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df shows "unknown" ?
Message-ID: <20140717084254.GH4834@carfax.org.uk>
References: <2344973.5NRcZetHsX@vajra>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
In-Reply-To: <2344973.5NRcZetHsX@vajra>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 10:02:01AM +0200, Sw=E2mi Petaramesh wrote:
> Hi there,
>=20
> Since a few days, I have noticed that "btrfs fi df /" displays an entry a=
bout=20
> "unknown" used space, and I can see this on several Fedora machines, so i=
t is=20
> not an issue related to a given system...
>=20
> Does anybody know what these "unknown" data are ?

   It's the block reserve, which used to be part of metadata, but is
now split out to its own type. An updated userspace should be able to
show it properly.

   Hugo.

> i.e:
>=20
> # btrfs fi df /
> Data, single: total=3D106.00GiB, used=3D88.28GiB
> System, DUP: total=3D32.00MiB, used=3D24.00KiB
> Metadata, DUP: total=3D1.00GiB, used=3D520.36MiB
> unknown, single: total=3D176.00MiB, used=3D0.00
>=20
> # btrfs --version
> Btrfs v3.14.2
>=20
> # uname -r
> 3.15.5-200.fc20.x86_64
>=20
> TIA, kind regards.
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---     =20

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU8eMjlheFHXiqx3kAQJiSRAAromuZDERDJ1h3fls0trTu7R01cFxR5z0
wf21F22qt5zurfg0QpgRW674OrrWUL4NaDe47yM6+WpD/YFJPYRe5QGoGWE1cuqQ
KqnroEuIb8UzeQlLIEvsUtzXQRBRXQM3jYArjeye54vmky7Exj5lj4jWNz6U/cU7
7H4rS/uZX03CSiQc+t25esHUzMtbi0jTKGMv+kXEeFwtC7c8DuKjdeBLt3lKzXbR
SQhPXXxhcWiRrVlAxtHdj/wraq4jwsh9QbToFzY9IE0lvG+PVMCNM4jrK7LymmaB
sVkbQkXMNZrAum4XOC+1C5VxgXO5HXCmVqDYJfLFwJeHK9uspkY/XxgqIrxGRpQt
LluFLh0QTSyI06Gf1QfxeisL1McIYazjBciXsr+v0GNgNd//NNy2y/+JUV3lUnZa
sZBFfO6Im4yhaZ7FG1T88BZKMx9IakH+FftlqxCN3MrOvW40gKXkGOXuMoreUQ32
EeCtT1sjg3sCjVxn+pAY6Y/VS1eK2xdoX9BdnqjexKFH7KyAgnNsSkSKjOGL5Gwn
zpGhcCHO3HiMLiRFyqKOEFItDDWC786OcNGDzuj1EMgvKnT8yJBTEhXz53gy1QXf
jIJ/7cpKUxWwy3wGKcKQ5mhngsBHuDlrc+358UjsVihbisWMZ7U1f7oI2W7X6vDC
dMpR6s+AKPo=
=pJNm
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
