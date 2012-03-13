From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs oops (autodefrag related?)
Date: Tue, 13 Mar 2012 12:34:09 +1100
Message-ID: <201203131234.12189.chris@csamuel.org>
References: <4F5E4F66.2030701@redhat.com> <20120313000435.GH29393@shiny> <201203131113.32951.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1653929.e8RjbyHaAn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203131113.32951.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1653929.e8RjbyHaAn
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

=46orgot citations, sorry!

On Tuesday 13 March 2012 11:13:28 Chris Samuel wrote:

> Note though that some people are reporting regressions with
> premature  ENOSPC in 3.3-rc7, to quote:
>
> # - bisected down to 5500cdb (Btrfs: increase the global block
> # reserve estimates). After reverting this one Linus master works
> # for me again.

is from https://lkml.org/lkml/2012/3/9/624

> Though after reversion they hit ENOSPC much later (but still=20
> prematurely).

is from https://lkml.org/lkml/2012/3/12/231

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1653929.e8RjbyHaAn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT16kEY1yjaOTJg85AQJE9wgAtKP0XM1ldFlVe42o79sKEKuWPOggc0um
9NfF8z6XuGjrifh3erG0U4htJWHF54aRjVSHKe7uZR+qTZnRD4ocIeu1Sg/5o9s3
h0SRhusQe2l8CvrgrsO6FGAUMWDyAft7WNAi6jhPSdYVsYN3RK2/ByGz0rfBvqSq
AlsaFEmlHvECrq0zOMVejNAEobsOZIpv8mpnGevW90ALzUPlaxiAyxA12aex0hmJ
Dk9lVQOrzXIE4SDATL1kebJ2xTe3ef1ki5Gn4Ipizm0dzoi12cL1nNIQzmQ4Em77
UGc6RR0zsA10mg0hut3M2yxRsbFC2cOO8LbAU9mzIPb9u1Vh7t6vHg==
=Cr+z
-----END PGP SIGNATURE-----

--nextPart1653929.e8RjbyHaAn--
