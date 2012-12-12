Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45060 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2LLXwC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 18:52:02 -0500
Date: Wed, 12 Dec 2012 23:51:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Cc: Zach Brown <zab@zabbo.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: no activity in kernel.org btrfs-progs git repo?
Message-ID: <20121212235158.GE19051@carfax.org.uk>
References: <20121212224214.GA9195@lenny.home.zabbo.net>
 <20121212225157.GD19051@carfax.org.uk>
 <CADqQcK7OGPbj2CYwSwrk+1-GLfTJ1YYxh8eaDH3_1y+k_u1=2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
In-Reply-To: <CADqQcK7OGPbj2CYwSwrk+1-GLfTJ1YYxh8eaDH3_1y+k_u1=2A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 04:50:54AM +0530, Nirbheek Chauhan wrote:
> On Thu, Dec 13, 2012 at 4:21 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >    Two things:
> >
> > 1) That tree is generally only ever updated for pull requests to Linus
> >    during the merge window. Would that it were otherwise, but I
> >    suspect that...
> >
> > 2) ... you may want to know about josef's btrfs-next tree:
> >
> > https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Integ=
ration_repository_.28btrfs-next.29
> >
> >    It's regarded as fairly unstable, so only run it on systems for
> > testing purposes (or if josef tells you it's OK and will fix one of
> > your problems).
> >
>=20
> I think Zach was asking about the userspace tools, not the kernel
> module. That link points to the kernel module integration branches,
> and the link above that on the wiki page about btrfs-progs integration
> hasn't had commits in the last 6 months, AFAICT.
>=20
> I've been concerned about the status btrfs-progs maintenance myself.
> I've seen quite a few obvious bugs about btrfs-progs on this list in
> the past months=E2=80=94most of them with patches. However, I don't see t=
hem
> enter any upstream git repositories.

   D'oh. It's been a long day... Must learn to read more carefully.
Sorry.

   I've been a combination of ill and busy (mostly busy) for the last
umpteen months, which is why the integration repo hasn't been updated.
The main -progs repo doesn't get a whole lot of love, even when I've
managed to do an integration run and hold it together for long enough
for Chris to pick it up. Patches do eventually get in, but it's
usually on a 6+-month cycle.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- IMPROVE YOUR ORGANISMS!!  -- Subject line of spam email ---    =20

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUMkYnb9z9OVl50rAAQLLaQ/+NBf3izXMzVfb+JpNGNmjDToTb/G8Ji9C
6L8l79vpWKlRt1d9coOhh7H58BeSL7gzTNWdkDvI/Z/q2Xg5QRybcnIj92Es6MXQ
kYWOgj2sxhZNMX7uLoL8eDlSkkBHYnRJwFcGNFParAfbgG9gQZg10TBAKjrYXgmw
pgW0nSU9u4wdXazbTTzicL2ynGrEOhDbz+v1AzFH4J4II7FC01ua8+XG1N4mkNx9
uJT8YncLfWR37o4QJ8UxJaJ7UEOIlTOD0RyMyzbnw20EBCI5pteqjn5VZPrLPbrA
F6dKkioFDqcGna0c1cssmil7yhFrQJ5x0IoPZ0ENXr3/Vop6HcC7gRJQbUefqYOT
8I984cxdHCsbSFONw6LUhgKcQmtqTJgYWWBpcwDbcVn6aDluL6uiIPJe/Wh+yieX
LuCXMALS7KALrRHBCoLjpeXSqa6Eg8jHpwDjiVDJ8Eb/ithPC0oMwjmX2Ht88pks
DYSbHBNAn6HU43lNjTx0VVfKa3ljvUMBmw4NbR83l6M9LzPwxUAYvhrL1w1vtjnN
y3fVr6lJQMWOrqYn4zD0Lw+lpF8KA//JdHfHNoO2AuyCUbt1xf8N3f44W2/gDIuV
OccH8/8nqSqFHrLlMcgoFsY3avONsGTpEtq8N1EJlNSwhstv+LL7WPZ202/ApzF0
Q0kezBj9n68=
=M9Sv
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
