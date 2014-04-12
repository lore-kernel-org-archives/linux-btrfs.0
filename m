Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42425 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaDLNRP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 09:17:15 -0400
Date: Sat, 12 Apr 2014 06:17:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Message-ID: <20140412131710.GR7322@merlins.org>
References: <2692878.dRG1K49eOP@fnix> <20140404150906.GR7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
In-Reply-To: <20140404150906.GR7442@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 04, 2014 at 04:09:06PM +0100, Hugo Mills wrote:
> > - Generally speaking, does LZO compression improve or degrade performan=
ce ?=20
> > I'm not able to figure it out clearly.
>=20
>    Yes, it improves or degrades performance. :)
>=20
>    It'll depend entirely on what you're doing with it. If you're
> storing lots of zeroes (Phoronix, I'm looking at you), then you'll get
> huge speedups. If you're storing video data, you'll get a (very)
> slight performance drop as it scompresses the first few blocks of the
> file and then gives up. I suspect that in general, the performance
> differences won't be noticable unless you have highly compressible
> large files, but if you _really_ care about it, benchmark it(*).
>=20
>    Hugo.
>=20
> (*) If you don't want to go through the effort of benchmarking, you
> don't care enough about it, and should just pick something at random.

Speaking of this bit, I once tried to use zlib instead of lzo, and somehow
it felt that my laptop on SSD booted noticeably slower after that, which
felt weird since decompression speed should be about the same.

Has anyone else noticed anything like this?

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBU0k81n4xUKZ2O+kBAQKOmgP6Au1yFIFmzEuC0nRKe4rtzIJfZgxgVbpY
DZyNlV8u0fhZa3vimfdgyhSyU5kV2HhMI8Er6v4JXkJeODDp+2dCyNax0xeAIZ+S
glz7lGrxgSwAS4M6TMssBDaHv3gTUs5rmE6+nyTz/R6bFyiGnpTegYXO2w71I+Yp
GVxTyK1D7Lo=
=jizS
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
