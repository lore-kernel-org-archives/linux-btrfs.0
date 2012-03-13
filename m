From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs oops (autodefrag related?)
Date: Tue, 13 Mar 2012 11:13:28 +1100
Message-ID: <201203131113.32951.chris@csamuel.org>
References: <4F5E4F66.2030701@redhat.com> <20120313000435.GH29393@shiny>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1804657.7uh3MG6omF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120313000435.GH29393@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1804657.7uh3MG6omF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 13 March 2012 11:04:35 Chris Mason wrote:

> This one was fixed in the 3.3 series.  You can pull from my
> for-linus repo for a commit against 3.2.

Note though that some people are reporting regressions with premature=20
ENOSPC in 3.3-rc7, to quote:

# - bisected down to 5500cdb (Btrfs: increase the global block
# reserve estimates). After reverting this one Linus master works
# for me again.

Though after reversion they hit ENOSPC much later (but still=20
prematurely).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1804657.7uh3MG6omF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT16RKY1yjaOTJg85AQJ1rwf/SGh+gwy/XCHRime+LhMaeAMHhd1pN0AP
q8BJEMM+Tzx+GZYuIwNzTAZR+KOXg/D8xgJg092AMF4kIxn/mz967UJLIjDoH40N
ai2ADfqI0xAY1H4Gu3jkPR7gbAYAKDhYBza/wGgrYU4to1m5epH44mq4fou3hHZZ
HKsIaMGqzlVHwd1ndaolcJ3OynJVCqxAEsxLYKp43eTxCtwpOrlDFLOdNpV5cZwC
BXIX8eBIGIb/4gnGSqtRHOetR40Q5hVi4HRlYrkIwOT91VZfpiLqtd4Ued1pXAc1
5xRNdIik3b2yKS5lHKBuaCpDNvRr8LLVescEC0akInYsrW1wqV29MA==
=mWp7
-----END PGP SIGNATURE-----

--nextPart1804657.7uh3MG6omF--
