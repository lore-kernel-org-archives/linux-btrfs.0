Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41255 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaDWWuV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:50:21 -0400
Date: Wed, 23 Apr 2014 15:50:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140423225018.GL26949@merlins.org>
References: <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org> <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info> <20140423220312.GK26949@merlins.org> <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info> <ECBC57F1-E3A0-4423-9248-6D7C72DDF09A@colorremedies.com> <20140423224303.GB2391@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <20140423224303.GB2391@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 11:43:03PM +0100, Hugo Mills wrote:
> On Wed, Apr 23, 2014 at 04:40:33PM -0600, Chris Murphy wrote:
> > The screen shot provided makes it clear that one of the following kerne=
l parameters is incorrect:
> >=20
> > > root=3D/dev/mapper/cryptroot
> >=20
> > > rootflags=3Dsubvol=3Droot
> >=20
> > So either the dmcrypt volume hasn't been opened, thus isn't available; =
or rootfs isn't on a subvolume named root found at the top level of the fil=
e system. So I'd say this isn't a btrfs problem, rather it's due to some ea=
rlier misconfiguration that's preventing rootfs from being mounted.
>=20
>    You'll need an initrd to run cryptsetup (or whatever) to collect a
> passphrase and decrypt the volume before you try to mount it. This
> sounds like a case for an initrd again.

I think you are confused, that's my config I pasted as an example.
He does not use dmcrypt in his example.

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBU1hDqn4xUKZ2O+kBAQKmAAP/Q2UU2OQ0LAZ4rFW/+hp64/muuCbWg3RZ
xaUnH5I23eHWgM/nmvhxauoPqcfX6SyuGy9aJ5RQxGavvnI279AjXGMyjtxbr2G2
zDqrEEo6crG81I8/OWZWl7w/6r8n5hS9DvOelvSg6UOg+cEOg8Vqd2QUVFVyM+XF
Z2ExdpIHt+0=
=W9rd
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
