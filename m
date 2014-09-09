Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:52535 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaIIWUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 18:20:38 -0400
Date: Wed, 10 Sep 2014 04:11:25 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Clemens Eisserer <linuxhippy@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC on mostly empty file system
Message-ID: <20140910041125.3fb1ac80@natsu>
In-Reply-To: <20140909215725.GE5783@carfax.org.uk>
References: <3150960.nnNb4J6vhp@wuerfel>
	<4255785.FLXNWijYCD@wuerfel>
	<CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
	<10095560.XRujO0W0CE@wuerfel>
	<20140909215725.GE5783@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EdAdAtHjr=fd3MRGoCk_87e"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/EdAdAtHjr=fd3MRGoCk_87e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Sep 2014 22:57:25 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Tue, Sep 09, 2014 at 11:49:10PM +0200, Arnd Bergmann wrote:
> > Ok, now I'm in the bad state again (after running a 'make allmodconfig'
> > kernel build:
> >=20
> > Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
> >         Total devices 1 FS bytes used 8.79GB
> >         devid    1 size 67.14GB used 67.14GB path /dev/sdc6
>=20
>    All the space on the FS has been allocated to some purpose or other.
>=20
> > Data: total=3D65.11GB, used=3D7.99GB
>=20
>    Here, you have 65 GiB allocated to data, but only 8 GiB of that
> used. The FS won't automatically free up any of that (yet -- it's one
> of the project ideas).

If you find yourself constantly running into this situation, rather than
incorporating periodical btrfs 'balances' into your scripts, you could cons=
ider
going with the "mixed" allocation mode of the FS, using the -M option of mk=
fs.

Seeing as this is not the largest-sized partition in the world in the first
place, the mixed mode would allow for a more efficient and flexible space
allocation on it; at the cost of some performance penalty (you could compare
your compilation times, but I don't think it's too significant).

--=20
With respect,
Roman

--Sig_/EdAdAtHjr=fd3MRGoCk_87e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlQPew0ACgkQTLKSvz+PZwg9OQCeP8GQRHUj7BxRHA5oY8J5d2yX
iu0AnjpbkukAnR12ZM6gMU+Srr3+QRy4
=DTKw
-----END PGP SIGNATURE-----

--Sig_/EdAdAtHjr=fd3MRGoCk_87e--
