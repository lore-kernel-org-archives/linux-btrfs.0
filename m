Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46895 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbCXXOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 19:14:37 -0400
Date: Tue, 24 Mar 2015 23:14:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Kline, Matthew" <matthew.kline@flukenetworks.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance fails with no space errors (despite having plenty)
Message-ID: <20150324231435.GN31762@carfax.org.uk>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
 <20150325040321.361abf2f@natsu>
 <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSZb4FHl1C2xfsUy"
In-Reply-To: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hSZb4FHl1C2xfsUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2015 at 11:09:47PM +0000, Kline, Matthew wrote:
> > Post your "btrfs fi df" for the filesystem.
> >
> > In my experience it looks like the conversion may designate large porti=
ons of data as "metadata" for whatever reason.
> >
> > A way to clean this up is to run
> >
> >  btrfs fi balance start -musage=3D5 -dusage=3D5 /path
> >
> > try repeating this again and again increasing the value gradually from =
5 to
> > 50-70 in steps of 5 or 10.
>=20
> Data, single: total=3D44.00GiB, used=3D43.37GiB
> System, single: total=3D32.00MiB, used=3D12.00KiB
> Metadata, single: total=3D2.00GiB, used=3D876.84MiB
> GlobalReserve, single: total=3D296.00MiB, used=3D0.00B
>=20
> Total partition size is 322 GB, as given by `parted -l` (I misspoke in th=
e last email - the drive is only 14% full)

   Yeah, this smells like the known bug that's been on josef's hitlist
for months now. He keeps getting side-tracked by data-corruption bugs,
so it's not been fixed yet, unfortunately. The only known solution to
date is, as you've found, remaking the FS from scratch and restoring
=66rom backups.

   Sorry to be the bearer of bad news.

   Hugo.

--=20
Hugo Mills             | Geek, n.:
hugo@... carfax.org.uk | Circus sideshow performer specialising in the eati=
ng
http://carfax.org.uk/  | of live animals.
PGP: 65E74AC0          |                                                   =
OED

--hSZb4FHl1C2xfsUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVEe/bAAoJEFheFHXiqx3kLvYQALc2zj8MynGDOl6ef7jHS2UY
PaJtCEezUZ1TsrmYBG8qWo2DtNPMqP2aY+8gy0v4H/STMEqLyLo54z1mIu2N3L5l
Kn7A9pUpX5Bd1KpE1KJFw77GAW37/m3azzBicPoqwNc5ZndlHOU7Z+fp/7FuQk15
1UkN43/gRHcYaKFK9y97oxdINVW4H0E2jL7yimgVAKZFbDk0gGe1HlQcqPYSX4vj
8qD6HWvJv0QzBb3eXHiMvCbquPJcqPHqsStA+LsbcdDPoK79pnsBfC+wvoPjJll1
0C8TWeeg5uRbId29dhz1pf5hKHWw/dBhOP0qF+cMX/JgHWnHFoL3IrfOqAQFNOIp
gnrwdksq6Mkodlj5dum4dg4WinAelFDSE+gDio8ZEuIHMh5VbTcfCG9MFybs+eMA
UVnvn/3mFbAUtZ4hhl9Y6hjTIBi2b89Rj6d0+xbVM/BvAH0avekIw2plJ/7CdXjO
Cki7J6bsZCHN1fcRL26+WBaRWY3uAk3J0WRUG3wsNsQ3TjfM+b2nfiMopjJ/bWMc
Sv4UAIDzEy++rGZszHlKEIWck0axGm+JeS6BsJfbi+hDNN8ifjYA/T30hLv8EMQG
88UluWUChQKV8qLglqa7r0KHC6kf0ISwV/cfHj5G92UqnH2Zgff56ilfU3p1MYCc
QW5iTEw2T9KVOOWKTKl3
=SG4b
-----END PGP SIGNATURE-----

--hSZb4FHl1C2xfsUy--
