Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58176 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992461AbcB1AWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 19:22:49 -0500
Date: Sun, 28 Feb 2016 00:22:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160228002245.GH14504@carfax.org.uk>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <1595760.q3He7oiP70@merkaba>
 <20160228000829.GT26042@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
In-Reply-To: <20160228000829.GT26042@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 28, 2016 at 01:08:29AM +0100, Marc Haber wrote:
> On Sun, Feb 28, 2016 at 12:15:21AM +0100, Martin Steigerwald wrote:
> > On Samstag, 27. Februar 2016 22:14:50 CET Marc Haber wrote:
> > > I have again the issue of no space left on device while rebalancing
> > > (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
> > >=20
> > > mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> > > ERROR: error during balancing '/mnt/fanbtr': No space left on device
> > > mh@fan:~$ sudo btrfs fi show /mnt/fanbtr
> > > mh@fan:~$ sudo btrfs fi show -m
> > > Label: 'fanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
> > >         Total devices 1 FS bytes used 116.49GiB
> > >         devid    1 size 417.19GiB used 177.06GiB path /dev/mapper/fan=
btr
> >=20
> > Hmmm, thats still a ton of space to allocate chunks from.
> >=20
> > > mh@fan:~$ sudo btrfs fi df /mnt/fanbtr
> > > Data, single: total=3D113.00GiB, used=3D112.77GiB
> > > System, DUP: total=3D32.00MiB, used=3D48.00KiB
> > > Metadata, DUP: total=3D32.00GiB, used=3D3.72GiB
> > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > > mh@fan:~$
> > >=20
> > > The filesystem was recently resized from 300 GB to 420 GB.
> > >=20
> > > Why does btrfs fi show /mnt/fanbtr not give any output? Wy does btrfs
> > > fi df /mnt/fanbtr say that my data space is only 113 GiB large?
> >=20
> > Cause it is.
> >=20
> > The "used" in "devid 1" line is btrfs fi sh is "data + 2x system + 2x m=
etadata=20
> > =3D 113 GiB + 2 * 32 GiB + 2 * 32 MiB, i.e. what amount of the size of =
the=20
> > device is allocated for chunks.
> >=20
> > The value one line above is what is allocated inside the chunks.
> >=20
> > I.e. the line in "devid 1" is "total" of btrfs fi df summed up, and the=
 line=20
> > above is "used" in btrfs fi df summed up. And=E2=80=A6 with more device=
s you have more=20
> > fun.
>=20
> Why wouldn't btrfs allocate more data chunks from the ample free space?

   It's a bug. It's been around for years (literally), but nobody's
tracked it down and fixed it yet.

   Hugo.

--=20
Hugo Mills             | We believe in free will because we have no choice.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW0j3VAAoJEFheFHXiqx3k1EwP/Ra9yR+7fwoBHoWbaz3MF8mJ
f9J3nsm7dXLB8oiqBrXuaTr3MglIstDQ58x5Ztp1MWACrIGOoG8Qw0TqVSIa0YtC
fEYPWhBXDXb39GE81JUWXzP/FngkoftgrWPcsMGiBJg9dn3ViDQw+voHfrtkl9K4
2aq7Htye1CKI6XMFm+OfZ2Z/IG7cowQv9A9KG5TDkcdfGYjEDylJh3rLI/Qa1RIl
wTY6DgB6NlXAFIqfD9m6x+gTgdBaV7fwNJDAwIiGKlTEaKgEfet0yho62gYxuvNi
WVmSLiBBH6AUOAGme7lImrYYQPOg0HNoU+rzYeO2vme+kz+66pIDgOHOJAxXl8Mz
ewjMc+1Ft9Ko803KNr1P5tS4Trqj3SfgMU3/Jv6+vHGtFq1V7h8xgryLfeGyKEzO
AeTcHEvVUPqYtYlY7ooSj/mNBCHqi9ur1WRi/ff9i2pBpTRF8i1PvVwLLIwVht5s
uCjU+HIovJY4/m+0KEpuhVrY70gqkxZWnMB1MBRyvl5YvaXtz4rUdjQfIvcRx8s9
tzPxKOhanDLAM2T7ylyzeVWJxMQlo7PVGaS26mj6jRJ9VzF1AUNjMREyZZzTiVvu
mMBjAEKh6VsKfkIFLIhXncA6EMGuSMJS7fOXqmk7YE9+qosd/cf4P6e+qbG/467a
JQuN477w+o9+6qz3bqqA
=3QJb
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
