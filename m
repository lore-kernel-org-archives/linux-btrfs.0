From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs filesystem df not working
Date: Sun, 17 Oct 2010 10:13:49 +1100
Message-ID: <201010171013.54097.chris@csamuel.org>
References: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com> <20101014164230.GX22691@think> <AANLkTinaO7p-yc=eiTOt+wLSVJuJAH3oyG0sKYxJ366y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart29941785.4rDogpAAVU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinaO7p-yc=eiTOt+wLSVJuJAH3oyG0sKYxJ366y@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart29941785.4rDogpAAVU
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, 17 Oct 2010 12:46:14 am Leonidas Spyropoulos wrote:

> Sorry, I don't understand what "backport the changes" means?

Chris means that you can take the changes that have gone into
the btrfs code since 2.6.32 and try and port them back to the
old 2.6.32 kernel code.  It's a non-trivial task.

Luckily for you Mitch Harder posted a message called "Backporting
Recent Btrfs Patches to 2.6.32" yesterday where he described his
attempts to do just that, he has a git repository for the resulting
kernel here:

http://gitweb.sabayon.org/?p=3Dlinux/kernel/btrfs-backport.git;a=3Dsummary

You can find Mitch's original message here:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/7102

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart29941785.4rDogpAAVU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATLoxro1yjaOTJg85AQLxxQgArAo5U6KlmpxMSV8cN+FO6a06czA4TvpT
1K+MJ4dl/z+Mx6i8tJZnQ1nwT4lYDMFXxCfEcUAcjMnfggmjb/RFLoKS8Yrb1GpF
kDQe7dbh/HD9xRtjxyHu2SwOuz+oF9qcnOdIe2qqvmY+95VV7Tnfg4cz4f/wr77w
vKqqzS52RXGG8pQzi1LdX/oEOOysQ6HNTFQ+NfNOqj50pbrkOxYCK1Dtna9Wml8H
+NZHgDtupbQ/hYWCVAsCFP2OK13fD+cTIxTc3RMc6LwTZ4vYGQPx+2SHoTRNVsCp
MpVVd09AxntLw5XNmfjgJ0xn/Fj1BzihzS4kzqAA86bjKQktT0s+Zg==
=M1Di
-----END PGP SIGNATURE-----

--nextPart29941785.4rDogpAAVU--
