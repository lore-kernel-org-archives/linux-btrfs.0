Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38201 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FFQ0s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 12:26:48 -0400
Date: Wed, 6 Jun 2012 17:26:45 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: New btrfs-progs integration branch
Message-ID: <20120606162645.GQ15986@carfax.org.uk>
References: <20120606160454.GP15986@carfax.org.uk>
 <CAMmnG49CXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v+Mbu5iuT/5Blw/K"
In-Reply-To: <CAMmnG49CXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--v+Mbu5iuT/5Blw/K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 06, 2012 at 06:18:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 06.06.12:
> 
> >> git checkout integration-20120605
> 
> [...]
> >    Can you compare your Makefile with the one at [1] -- in particular
> > the progs variable at line 21-23, the "all" target on line 37, and
> > the "btrfs-convert" target on line 97. There definitely should not be
> > a plain "convert" target in there, but that seems to be what your
> > system was failing on.
> 
> Makefile with 3888 Bytes.
> 
> "md5sum Makefile" shows
> 
> (my file)
> deef961e3ecd560ad8710cf0b58f5570  Makefile
> 
> (the file from your link)
> deef961e3ecd560ad8710cf0b58f5570  Makefile
> 
> The problem is somewhere on another place ...

   OK, can you send through the complete output of:

$ make clean
$ gcc --version
$ make --version
$ make
$ for f in .*.d; do echo == $d; cat $d; done

   My guess is that the dependency generation is going wrong somewhere.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- There's many a slip 'twixt wicket-keeper and gully. ---       

--v+Mbu5iuT/5Blw/K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz4TFIKyzvlFcI40RAi86AKDUQ1uCVxoM+2v4U9cCO1W8178C0QCgmS5t
e5Gz6bSd4JpqTl1XGjYN2Ow=
=pu/X
-----END PGP SIGNATURE-----

--v+Mbu5iuT/5Blw/K--
