From: Chris Samuel <chris@csamuel.org>
Subject: Re: bcp command not installed by Makefile
Date: Wed, 16 Jun 2010 17:02:28 +1000
Message-ID: <201006161702.31994.chris@csamuel.org>
References: <AANLkTimRn1NJsivc6HD8W5K3QKQoPdmvfK54o6TOY37c@mail.gmail.com> <201006111412.07560.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1826178.M0mNyO20uo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006111412.07560.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1826178.M0mNyO20uo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jun 2010 10:12:07 pm Hubert Kario wrote:

> Does 'bcp' can do anything additional that the 'cp --reflink=3Dalways'?

No, but would be handy for systems where that's not present as an
option for cp (such as the current Ubuntu 10.04 release).

Just noticed that bcp isn't present in the btrfs-tools package in
that release either:

$ apt-cache policy btrfs-tools
btrfs-tools:
  Installed: 0.19-8
  Candidate: 0.19-8
  Version table:
 *** 0.19-8 0
        500 http://mirror.linux.org.au/ubuntu/ lucid/universe Packages
        500 http://mirrors.uwa.edu.au/ubuntu/ lucid/universe Packages
        100 /var/lib/dpkg/status

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1826178.M0mNyO20uo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATBh3BI1yjaOTJg85AQIpTAgAxNvTrMrcSbFMllLUHmWCR7fHhZcDVA+7
zuMrWNpKaEhoxDERr+PwHY6SGUkBl1lH/mm9+5TjhUBRAorxctYemTnClr9VLWio
jnWR5keudKH+jDcwvX377VAm15znXm4p+4XmZkdWVutzGUMLAWIN1LmmV1n1UoI0
2crXt4baNlLUBtV/DgaEWD2UQr0AGajtxCRKlN0mBFXIRlvF4FSJTf8nC1bRwwjX
Kq2Urg5rdTgYa0YV01z0BK9lqBicZqxcLTz3VZa+5Y9xkBptxFRkshG3048a7/0Z
3YM+fTjtgkCuznHM14kVE2clKRmE9E/T9hxcVvEQSnN+2VcnuP1mFw==
=GDIf
-----END PGP SIGNATURE-----

--nextPart1826178.M0mNyO20uo--
