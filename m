Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58862 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCWXL5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 19:11:57 -0400
Date: Sun, 23 Mar 2014 16:11:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Any use for mkfs.btrfs -d raid5 -m raid1 ?
Message-ID: <20140323231156.GD18293@merlins.org>
References: <20140323224435.GC18293@merlins.org> <20140323225229.GJ25400@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
In-Reply-To: <20140323225229.GJ25400@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 23, 2014 at 10:52:29PM +0000, Hugo Mills wrote:
> On Sun, Mar 23, 2014 at 03:44:35PM -0700, Marc MERLIN wrote:
> > If I lose 2 drives on a raid5, -m raid1 should ensure I haven't lost my
> > metadate.
> > From there, would I indeed have small files that would be stored entire=
ly on
> > some of the drives that didn't go missing, and therefore I could recover
> > some data with 2 missing drives?
>=20
>    btrfs's RAID-1 is two copies only, so you may well have lost some
> of your metadata. n-copies RAID-1 is coming Real Soon Now=E2=84=A2 (Chris=
 has
> it on his todo list, along with fixing all the parity RAID stuff).

Oh, right, I forgot about that. Then I'm not coming up with many good
reasons why raid1 metadata with raid5 data would be useful.
Actually raid5 metadata should be faster since it's striped on more drives.

I'll update the doc I just posted, thanks.

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBUy9qPH4xUKZ2O+kBAQKxfwQA4cFEj89QGE9nIw3UYnle2ADSfNYjWEhG
2baslhJhZJtKyGkgvrzzrNX5h2M6Yb2TQO/8B6QXuZFG6J0gsPFuEAA993oKXgnG
Ocn8Y2UAw9jRPy6mcdMU2oWtMRYDfYahxNrrUQS1BSokWJp/xBGtSGiKLniVVd0n
yPb9WyZHvbk=
=PmNa
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
