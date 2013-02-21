Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33321 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3BUPBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:01:23 -0500
Date: Thu, 21 Feb 2013 15:01:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS fails defragging
Message-ID: <20130221150120.GC14283@carfax.org.uk>
References: <51263363.9020203@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
In-Reply-To: <51263363.9020203@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 03:46:59PM +0100, Sw=E2mi Petaramesh wrote:
> Hi folks,
>=20
> I'm using Ubuntu 12.10 Quantal with
> # uname -r
> 3.5.0-24-generic
>=20
> And it seems I cannot defrag :
>=20
> # filefrag /boot/initrd.img-3.5.0-24-generic
> /boot/initrd.img-3.5.0-24-generic: 3 extents found
>=20
> # btrfs filesystem defrag /boot/initrd.img-3.5.0-24-generic
> # echo $?
> 20

   That's a success. The return code for defrag is broken, and for
some reason returns 20 on success.

> # filefrag /boot/initrd.img-3.5.0-24-generic
> /boot/initrd.img-3.5.0-24-generic: 3 extents found

   This is pretty good. You can't guarantee that any given file will
be defragmented completely. I think if the file is large (bigger than
a block group), then it'll be split across the block group boundaries.

   I'd say 3 fragments is pretty good, unless it's a couple of KiB in
size...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---     =20

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSY2wL9z9OVl50rAAQLEzw//TJGVQa2pBazD4V4gLLWKgtkCogildeSi
zq2MswiIaOuKxnTsr5tFKdRVpBbCepL2eaD+SCCg4v9FxbIj+cPoafFgqGme8WH3
6vMS0+hx/qeIFyHCRl6G4Ghmt7Y5BDNN6nHYn7OTY3C/srhLItWbhLewu4CTz0le
Ff/T8PHThRLVFVs/lHtmTGxwpSaOuzzX8UNXCby8JNpa94IBSTtjUl9x174J10Vh
DrDTE18QUwdSdxz3dWZAS2fyz9qN1w+F1XO0shE/tvseenmOMCavTgoeKho/IGrI
KTa0PsfrC8A1y3OZusk0BDMKn/VtBxr/lY1gRcveEr3iDdfps50HmHK5rvphmUO5
YyuMJ+JUQxX4oSWw9lAYCwhhBlgAPvWwfAa0+BfRRhVuqu7m3jEJYDz0nT/vlzyr
YU2bybCRuclFt6BlaIScerBkwrfgVOo97tdquXK2rHfVFI7GO+uXUhmYDSQRc9dS
YBVSWYBPCebltMlhXDA4aZLrpREIgn9GUuARmQgURcb0pHrC5tELb1tiaZC9Pt5d
1yWQcNuzUgiuorc2h8USxyspQspeqcq1nF1bYNTbJPaYcSpAudDqUAMRY7D5yb1k
65xT21CT9yU/QKMj8FZd4zNQLj+xrG9dVyNzrhNf/jejhZMNX8VuBq4PQoArPMdw
o5StwS70DP8=
=PmdY
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
