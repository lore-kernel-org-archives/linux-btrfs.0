From: Chris Samuel <chris@csamuel.org>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Thu, 16 Feb 2012 17:33:19 +1100
Message-ID: <201202161733.25977.chris@csamuel.org>
References: <20120130003754.GD4380@merlins.org> <4F384FAA.5060506@redhat.com> <20120213001400.GD31989@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7647969.PCMSWHBhsn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213001400.GD31989@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7647969.PCMSWHBhsn
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday 13 February 2012 11:14:00 Marc MERLIN wrote:

> I knew that it created some security problems but I had not yet
> found the page you just gave, which effectively states that TRIM
> isn't actually that big a win on recent SSDs (I thought it was
> actually pretty important to use it on them until now).

In addition TRIM has always been problematic for SATA SSD's as it was=20
initially specified as a non-queueable command:

https://lwn.net/Articles/347511/

However, it appears that a queueable TRIM command has been introduced=20
for SATA 3.1:

http://techreport.com/discussions.x/21311

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart7647969.PCMSWHBhsn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATzyjL41yjaOTJg85AQJ0zAgAt0kTs6b/fHkyx0x6ZUOrIIWnU8XXpxsU
6xx/hEuuBlW6BbbUH1AniHV1CmZ+Qhow7b0DhPsj8sroB+kVjczQcdlxJVcqNtXq
gBeB46xiaOAxlC5wYi90MEhW+gqvP7IVYutsmx546haD0S9NGVPZxttm92Dhm81p
PZoCGgkG/+4TVQ4HhJFPntcghU9SXhzadB0o4QGzFH3K+s7nNahXdJ4cyGD6zZtg
PlL1wQHtQQXdnLA+rxSn1+6q4qJcNB+8v0H1h2QrDIjVwuEDSPZjuRbc9WHX58qG
xMy0q+CkrRsksxaEZPC9RC2VXwc3hszj9tyiV2GLvsYfigerEt1ClQ==
=aTav
-----END PGP SIGNATURE-----

--nextPart7647969.PCMSWHBhsn--
