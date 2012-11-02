Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60240 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2KBWGI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 18:06:08 -0400
Date: Fri, 2 Nov 2012 22:06:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gabriel <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Message-ID: <20121102220604.GC28864@carfax.org.uk>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
 <201211021218.29778.Martin@lichtvoll.de>
 <5093B658.3000007@gmail.com>
 <k715i0$7go$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
In-Reply-To: <k715i0$7go$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2012 at 07:05:37PM +0000, Gabriel wrote:
> On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
> > On 2012-11-02 12:18, Martin Steigerwald wrote:
> >> Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
> >> in total. I understand the logic behind this, but this could be a bit
> >> confusing.
> >>=20
> >> But it makes sense: Showing real allocation on device level makes
> >> sense,
> >> cause thats what really allocated on disk. Total makes some sense,
> >> cause thats what is being used from the tree by BTRFS.
> >=20
> > Yes, me too. At the first I was confused when you noticed this
> > discrepancy. So I have to admit that it is not so obvious to understand.
> > However we didn't find any way to make it more clear...
> >=20
> >> It still looks confusing at first=E2=80=A6
> > We could use "Chunk(s) capacity" instead of total/size ? I would like an
> > opinion from a "english people" point of view..
>=20
> This is easy to fix, here's a mockup:
>=20
> Metadata,DUP: Size: 1.75GB =C3=972, Used: 627.84MB =C3=972
>    /dev/dm-0        3.50GB

   I've not considered the full semantics of all this yet -- I'll try
to do that tomorrow. However, I note that the "=C3=972" here could become
non-integer with the RAID-5/6 code (which is due Real Soon Now). In
the first RAID-5/6 code drop, it won't even be simple to calculate
where there are different-sized devices in the filesystem. Putting an
exact figure on that number is potentially going to be awkward. I
think we're going to need kernel help for working out what that number
should be, in the general case.

   Again, I'm raising minor points based on future capabilities, but I
feel it's worth considering them at this stage, even if the correct
answer is "yes, we'll do this now, and deal with any other problems
later".

   Hugo.

>            Data   Metadata Metadata    System System             =20
>            Single Single   DUP         Single DUP         Unallocated
>                                                               =20
> /dev/dm-16 1.31TB   8.00MB  56.00GB    4.00MB  16.00MB           0.00
>            =3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Total      1.31TB   8.00MB  28.00GB =C3=972 4.00MB   8.00MB =C3=972      =
  0.00
> Used       1.31TB     0.00   5.65GB =C3=972   0.00 152.00KB =C3=972      =
     =20
>=20
> Also, I don't know if you could use libblkid, but it finds more=20
> descriptive names than dm-NN (thanks to some smart sorting logic).
>=20
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, --- =20
                and a natural deficiency in moral fibre.                =20

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJRDzL9z9OVl50rAAQL7cg//Y0Y3yR5Swu6VUoFl6R7AxrfHk9M38XAe
L/Filb8fJ4TRKGIqCBn7Yvxs7hOwtfcCQidB9MxZjetBZO1O2rJALJLcOalYa/6Z
Ix3IGDcKVUSampgqsek58GN2qa4H9wnaiD1X6NxLJzVCb/ZnkBss0MRkzANWRW5L
w5haQcYp+Dg9OgEWd2G+jvIpKLgpsRiRx4EzXYSQFb0LG7ueQ2Ke7cJDR2JqycHr
TsH/BcFrwYj3WcPD6l6iWn8giwB5ZUtSeX/fZxxHxpFqSajJz/lf40AUxLYX4bag
ADmScXAaM6IqX/C24KUmZ6sM2mko8UH3ICBWdYjE4V6VVtNZlM1F+mwAEsyUCUuN
a1FHrsf1AtRSjFUxSNxyWrWFooErl0ds1ivv0dUHt/U+Bye5zrMDnGx1u5G/aJk1
rjiwgh+v6Umj4l9n9MJEQnz8bia69aAAfm5S9bJcPkFPe2i1mdoeBo0zI8Ies+KJ
4AY5pm4z/+GdjlURLphPf4VJakCKOvD7eMS/1BSre1UHTtMUAoWIrmiqQ9r3N/Km
aRD4OUJW7FKMXlpDjLcqv+geI3nzriyx9h/lPV+gvf2kdv7PoEku39AhsFGWSx9J
JBG9WKoSPa+mD3mqNmGPnJD09FprJj0hmR6iuYUjY9eZcGeGuljL9WZ9fDHblXSg
9BmftRd8yYw=
=2bU1
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
