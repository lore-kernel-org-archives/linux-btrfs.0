Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40883 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KJQJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 11:09:29 -0500
Date: Sun, 10 Nov 2013 16:09:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs might be gradually slowing the boot process
Message-ID: <20131110160927.GB4315@carfax.org.uk>
References: <527d2ee689e077.81319728@wp.pl>
 <72h1la-adf.ln1@hurikhan77.spdns.de>
 <04B39B7F-24A2-42E0-8C4A-31D710A844E6@colorremedies.com>
 <rin4la-odl.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
In-Reply-To: <rin4la-odl.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2013 at 05:07:23PM +0100, Kai Krakow wrote:
> Hi!
>=20
> > What's leafsize was used when making the file system? The default is now
> > (as of yesterday) 16KB to avoid metadata fragmentation.
>=20
> Since my btrfs is about 2 years old I suppose I'm still using 4kB leafsiz=
e.=20
> Is there a way to change it without recreating the whole filesystem from=
=20
> scratch?

   No, it's one of the few options that's not changable after mkfs.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the premi=E8re,  is the ---    =
=20
                  last-ever performance the derri=E8re?                  =
=20

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUn+vt1heFHXiqx3kAQIbZRAApg1QSG6rPjNG2gN1mc6wsgyIyMawLP0z
+i61DYqh3MOL5iBpJUMqCLz92w0i7D+zwqoAZHoqkrSjxx6k00rvAXaKEWpivsf4
kdpx0NJxZRz0kAb5Nfwj/aAn6tRMpzBSGRyPqOxY49c/76uD9J24EzRtBojLQ+kt
ZhmC4qdduV6fq3+1IG6DxeLvlhFmKVXAxhxsdVIRHItugcb+axI6ZdrwNzr4+AzD
QHXF4qAgjXn+GmiBRY+QMeQSTTBihyz+075lmaFG6V8zkZTvOMxeqkxcWyufanr2
kVvLAAWJbMkD80updAG/lBqMcoME0t9mEskQkPNhcJNFN/D6BEy4h5kVpcxhVTr7
51uVJqOxK1w0ywJ0avATnW/fpCpsGZp1HPH6D0rSgaa/bW3C1JPbAf3O1cRTL4AF
Hswdh4wCf6cvqGMxfC8saWg8H1AYwiYvxfm3J6VhlVj8prmazBzW+HQueiaNd0KM
xaAZyLnSpgY8I1yGqtLtgv+ra5Wy2d1mTKC/cKlnfAfcP/YMokHW0z15aHvzl3kr
afkfFf1J2qRYvBh6Sx4fGTasdUmQVTs+uD/VLH0KdFa4jlk/kP8Iq8YlPh8RIPlj
cfhcGDNbmE8JWRliWgdIzzKBc1SvUxicEyLWacNRTkttdxnt9o8nPPdosIkRB1Zs
maHLY63UzfE=
=70Z0
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
