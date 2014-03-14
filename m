Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44961 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaCNCMD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 22:12:03 -0400
Date: Thu, 13 Mar 2014 19:11:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Message-ID: <20140314021159.GQ18959@merlins.org>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <3438733.p6vCjojJlH@merkaba> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
In-Reply-To: <20140309113350.GH6318@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
> discard is, except on the very latest hardware, a synchronous command
> (it's a limitation of the SATA standard), and therefore results in
> very very poor performance.

Interesting. How do I know if a given SSD will hang on discard?
Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)

Thanks
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBUyJlb34xUKZ2O+kBAQKPbgQAusAYg8v1FXtgWhWmeKMUnpdLpSNxf6pv
bU5ucrZQLzx7MPoeKYgdTL4ilZLhiI96zXwTjfo6004FJrA3Qy0CZfmo6iygS7n3
tjg/nD4X2Yk1wmD/3GF65a6MNLotCS1NNPl9g9KCQY3sra0j5z32yfNLQZQ506QM
m3p8TPll/As=
=Gumt
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
