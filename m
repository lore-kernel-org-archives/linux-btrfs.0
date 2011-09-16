From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Fri, 16 Sep 2011 08:21:24 +0200
Message-ID: <1316154091.28427.3.camel@picard>
References: <4E64D3D5.7020407@petaramesh.org> <15663472.1RTxtZJx8a@tethys>
	 <CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
	 <1411501.d4mgBNBG2i@tethys> <4E7253F4.9020005@gmail.com>
	 <CAG1y0sdv=GwgRAd1suTGhzVB=A1dUsZ=fjiE67QsuGQCCQwSjw@mail.gmail.com>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-rzrPWvvP43UiHSOBZ5ZC"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdv=GwgRAd1suTGhzVB=A1dUsZ=fjiE67QsuGQCCQwSjw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-rzrPWvvP43UiHSOBZ5ZC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-16 at 05:16 +0700, Fajar A. Nugraha wrote:
> On Fri, Sep 16, 2011 at 2:37 AM, Felix Blanke <felixblanke@gmail.com> wro=
te:
> > I'm using btrfs since one year now and it's quite fast. I don't feel an=
y
> > differences to other filesystems. Never tried a benchmark but for my da=
ily
> > work it's nice.
>=20
> Your workload must be light :)
>=20

I recently repeatedly rsync whole partitions (>30GB) without ill
effects. (ok - first sync took whole 1s).

> >
> > The advantage to ext4 for me is the build in raid1 and the snapshots. I=
'm
> > using the snapshot feature for my local backups. I like it because it's
> > really easy and uses very few storage. A simple "Snapshot -> Rsync to a
> > different disk -> Snapshot" script is the perfect local backup method.
> >
>=20
> you've never used zfs have you :)
>=20
> For that purpose, think "same feature as btrfs snapshot + rsync" but
> without needing rsync. This can be very useful as the process of rsync
> determining what data to transfer can be quite CPU/disk intensive.

Now I'm curious - how do zsf get data off the partition without rsync?

Regards

--=-rzrPWvvP43UiHSOBZ5ZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOcurrAAoJEJIdee2Vr4aPQM0P/2/myAX0lYpdyIo+EGLZgBaJ
4/W8b30DroGez3Yu7t4vP5egIHweVlHSwpEGBKnIRYUacAwEUSORHiRiJaWTpUxs
JMfxE8DRo4rR4wM3v7IO7Xwocpf1kOujXW4wzTcRmRTaI4NDKBdR9RLp/k0esarL
h+GT7dVqhBrCSH8HUETEeZpIJw+JpWXaSjpVs8jzXpsHDxRFS73tUHaYotBOEjCI
ydeBBMHDG8DzoXZLOkhAQ7SEmOtRrS4wW3hKW1bPtwJRWJfHY+gTPAXSXSNOphVV
qkOszdUMjq/AHoFoK/hpagt3GnzMAPkk+A/32xos92P5R4+52jZYEobhxheariZ8
275+8rOig44lsHyqdKIkpYGuoyjUWN3F2CBzPdNSQ3+93YkQK+2fw6aAzOerrTO4
4Y+CKHR5+HTS7xWeGvXQw3q9OvO4khYLekkIKBUVpinW6wvunQJCnrRj01ultubK
ci/zwe4o8nlYoItlu5DZToytf00jSas4izIzE8IM6elHkNt4p//ozPUyuYllFqW+
vIq6ov/EFRYDNsrlxpBaDvN0VWk9s7rpaRSmAUae6Wbou6BdD5GORaCeTOh1Ki9x
mTj6PtaMLCL2nl+A5M2foVRzbiycLGQPtdGZK0wH+Rcftrwm8o/azKwFlqR6PHD3
ME3jz8iZDVpGJHd9fNi1
=3FkX
-----END PGP SIGNATURE-----

--=-rzrPWvvP43UiHSOBZ5ZC--


