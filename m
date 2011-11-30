From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Resize command syntax wrong?
Date: Thu, 1 Dec 2011 01:15:47 +0600
Message-ID: <20111201011547.66633b20@natsu>
References: <4ED67A2E.9080809@cfl.rr.com>
	<ByrPr1UD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HPsQ/nw7u3iF_uOQyV5v6J/"; protocol="application/pgp-signature"
Cc: Hullen@t-online.de, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ByrPr1UD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/HPsQ/nw7u3iF_uOQyV5v6J/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 30 Nov 2011 19:59:00 +0100
"Helmut Hullen" <Hullen@t-online.de> wrote:

> > Currently the resize command is under filesystem, and takes a path to
> > the mounted filesystem.  This seems wrong to me.  Shouldn't it be
> > under device, and take a path to a device to resize?
>=20
> No - it's a filesystem operation.

Are you sure about that?

>=20
> p.e.
> You start with a system of 2 disks. They get filled nearly =20
> simultaneously.
> Then you add a 3rd disk (which is empty at that time). Now it's a good =20
> idea to run "balance" for equalizing the filling.

What if I need to replace an individual device with a smaller or a larger o=
ne?


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/HPsQ/nw7u3iF_uOQyV5v6J/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7WgOMACgkQTLKSvz+PZwiVbwCeLGXzaq7+10hXebNkVS6m2pxE
m14An1bVzBWuvrRnhIyVM5Xhggg2LEv+
=Ay19
-----END PGP SIGNATURE-----

--Sig_/HPsQ/nw7u3iF_uOQyV5v6J/--
