Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49199 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3ANSAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 13:00:42 -0500
Date: Mon, 14 Jan 2013 10:00:41 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Can moving data to a subvolume not take as long as a fully copy?
Message-ID: <20130114180041.GC23026@merlins.org>
References: <20130114173250.GA23026@merlins.org> <20130114174155.GA19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
In-Reply-To: <20130114174155.GA19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2013 at 05:41:55PM +0000, Hugo Mills wrote:
> On Mon, Jan 14, 2013 at 09:32:50AM -0800, Marc MERLIN wrote:
> > I made a mistake and copied data in the root of a new btrfs filesystem.
> > I created a subvolume, and used mv to put everything in there.
> > Something like:
> > cd /mnt
> > btrfs subvolume create dir
> > mv * dir
> >=20
> > Except it's been running for over a day now (ok, it's 5TB of data)
> >=20
> > Looks like mv is really copying all the data as if it were an entirely
> > different filesystem.
> >=20
> > Is there not a way to short circuit this and only update the metadata?
>=20
>    I guess the best way of doing this in this case is to teach mv to
> do cp --reflink=3Dalways then unlink the origin.
>=20
>    Clearly that won't work over mount boundaries (where a copy of the
> data is the best you're going to get), but that's not what you've got
> here.

Mmmh, this made me think:
It seems that I could have done cp --reflink without duplicating the data
and running out of space.
Then, I could have deleted the originals?

Is that correct?

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQCVAwUBUPRHyX4xUKZ2O+kBAQJ9CwP/QXfkpDNNVYLTRgyEI2D4zwWf56HLv32e
4Vy0dBc5G4lSmLZNi8iINyadqEZqCZg8i0H75/55/K7mtf5vWmwKg+6diUIKPUdS
scBhQCzOIbSvQpnkANzRD1tc8tEYLy4KoLhVlWskJhwVokq6j48on9Dhbr9ntuDT
UiojqnBEE/g=
=5SMy
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
