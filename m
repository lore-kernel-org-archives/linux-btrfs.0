Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39593 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab2J0WiO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 18:38:14 -0400
Date: Sat, 27 Oct 2012 23:38:12 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121027223812.GB5042@carfax.org.uk>
References: <50899151.1070503@inwind.it>
 <201210271843.40540.Martin@lichtvoll.de>
 <20121027195513.GS2381@yeono.kjorling.se>
 <201210280030.45190.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
In-Reply-To: <201210280030.45190.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 28, 2012 at 12:30:44AM +0200, Martin Steigerwald wrote:
> Am Samstag, 27. Oktober 2012 schrieb Michael Kj=C3=B6rling:
> > On 27 Oct 2012 18:43 +0200, from Martin@lichtvoll.de (Martin=20
> Steigerwald):
> > > Possibly this could be done tabular as well, like:
> > >=20
> > >                         vdb           vdc             vdd
> > >
> > > Data, RAID 0  307,25MB        307,25MB        307,25MB
> > > =E2=80=A6
> > > System,RAID1  -               8MB             8MB
> > > =E2=80=A6
> > > Unused                2,23GB  2,69GB  2,24GB
> > >
> > >=20
> > >
> > > I like this. But what if the filesystem has 100 disks?
> >=20
> > Maybe I'm just not familiar enough with btrfs yet to punch an
> > immediate hole in the idea, but how about pivoting that table? Columns
> > for data values ("data, raid 0", "system, raid 1", "unused", ...) and
> > rows for the underlying devices? Something like this, copying the
> > numbers from your example. And I'm using colon here rather than comma,
> > because I believe that it better captures the intent.
> >=20
> >            Data: RAID 0   System: RAID 1   Unused
> > /dev/vdb     307.25 MB                -        2.23 GB
> > /dev/vdc     307.25 MB             8 MB        2.69 GB
> > /dev/vdd     307.25 MB             8 MB        2.24 GB
> >            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > TOTAL        921.75 MB            16 MB        7.16 GB
>=20
> Hmmm, good idea. I like it this way around.
>=20
> It would scale better with the number of drives and there is a good way t=
o=20
> place the totals.
>=20
> I wonder about how to possibly include the used part of each tree. With=
=20
> mostly 5 columns it might be doable.

   Note that this could get arbitrarily wide in the presence of the
(planned) per-object replication config. Otherwise, it works. The
width is probably likely to grow more slowly than the length, though,
so this way round is probably the better option. IMO. Eggshell blue is
good enough. :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Some days,  it's just not worth gnawing through the straps. ---  =20

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIxiVL9z9OVl50rAAQKR/hAAo5ahMNRLEIM0qSXRwWJa0Wr/azwc6zsI
/koKudDUCNoH2FP98Qa9wccTNI9k69r5kmIV3pOcLA2haL26zbaY3UzKrekiM/a7
/Q+KXtVIQnvw+2l9+jR+0j6m9gn7W/5CmPRLAfNLJLW6PW3iuezp5EmDEqIqpzy5
08zj3ko4MZiZCyfIT2TpW7j2+MHjVLCXfGtcjEUaJmzg+vVz1riR8z13Zg4aBggs
CXkc4U0u2XJs4jMKCBJWL9upjw0rHhPh9DNbUkorB0RUwn2fdn/vWNPi0gG8Wemb
3WfriJCXbLJBDKo+hNRGS+mecsmoeUFU3NOl9wZXQxOrx1hbo67Pi5L19BHRzbfZ
OrmAyxk7IlpCbiFFm9kTDI2lHuc1IhIBT3U6WxfIp0Pk5IqUeH4cffdPorEFNkj6
+1BE9pLQnIqlGsEf1qaPmzTlMhAbgCUrUyleWNf/C0j+HKLEq5Q7uwNTeg0TVrs6
lAExXRN8/4OYplWvnVIuGtnKuKwPx2NDQP34Cck7849m+++EClgkYVzctxoj1NLz
v+ji8IXMcmG7IrnZ+wAaKrg5/1D2mcM124KABJI+WvD5BMnziJdxS9lN6CELSTiJ
QnCSvruznQPk2sLy5P0OLDQ5lydTnDhwfux/JZxiDqyPJzukXQ/+CiJ7teylxeC3
G7hYyAwlSdA=
=/4eM
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
