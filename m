Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34150 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaDKRXu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:23:50 -0400
Date: Fri, 11 Apr 2014 10:23:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Samuel <chris@csamuel.org>, Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Message-ID: <20140411172346.GK7322@merlins.org>
References: <20140325164142.GN12833@merlins.org> <2708828.vpfalmJ0Wi@quad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
In-Reply-To: <2708828.vpfalmJ0Wi@quad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2014 at 12:15:14AM +1000, Chris Samuel wrote:
> On Tue, 25 Mar 2014 09:41:42 AM Marc MERLIN wrote:
>=20
> > 4 hours to stat 700K files. That's bad...
> > Even 11mn to restat them just to count them looks bad too.
>=20
> One way to get an idea of where that's happening is to run the command wi=
th=20
> "strace -c" to build up a table of times spent in each system call, usecs=
 per=20
> call (average) and number of calls.

If the devs can use this, I can provide this.

For now, the FS got even worse than that, it just hangs btrfs cleaner
processes without me doing anything, so I think they got enough data on what
is going wrong with it, although I'm not sure if it's fixed in 3.15 or not.

I'm waiting just a bit longer before destroying and rebuilding this
filesystem, hence my other questions on how to it better for next time on
the block level side.

Is anyone else using btrfs on top of dmcrypt and software raid 5?

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBU0glIn4xUKZ2O+kBAQLvSAP8DhlijxenlhUy1W64mU8rSgU50V1t0cus
49CfLvZZnE8NjK/UGERAhuWu/5DQzf5K3fvAMWA8f2a3yHZqIhyYqfIfh4lHx+2G
BxbVrVcQVieDtjf61bTpfR4timuYzMXpv0w5lg0zBMkTgwEtZDS5K4qhIciNG64u
0BNix2qaGU0=
=gO52
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
