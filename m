Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59804 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1PAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 10:00:47 -0500
Date: Thu, 28 Feb 2013 15:00:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Does defragmenting even work
Message-ID: <20130228150044.GN14283@carfax.org.uk>
References: <512F6B30.1060409@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iKKZt69u2Wx/rspf"
In-Reply-To: <512F6B30.1060409@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--iKKZt69u2Wx/rspf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 28, 2013 at 03:35:28PM +0100, Sw=E2mi Petaramesh wrote:
> BTW...
>=20
> I'm not even sure that "btrfs filesystem defrag <somefile>" actually
> does anything...
>=20
> If I run "filefrag <somefile>" afterwards, it typically shows the same
> number of fragments that it did prior to running defrag...
>=20
> I'm not sure about how it actually works and what I should expect...

   If you have a compressed file, each compression block (128k of
compressed data, if I remember rightly) will show up as a separate
fragment, even if it's contiguous with the others -- it's an artefact
of the way that fiemap/filefrag calculates fragments, and the way that
btrfs reports compressed files.

   Also, on a full filesystem, complete defragmentation may not be
completely possible.

   Similarly, very large files may not be easy or possible to
defragment fully -- a 2GB file with four fragments isn't exactly a
problem, for example.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'm all for giving people enough rope to shoot themselves in ---  =20
                       the foot -- Andreas Dilger                       =20

--iKKZt69u2Wx/rspf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUS9xHL9z9OVl50rAAQKdJg//d5bOfxrpyA8Y8AyDFbWc24xo2t2mcEVA
nhYpmCnR3I168Cu5zCJfs68rafxJIUU1dkFREP5q0gvtPp+C7j/Qgl5byCnSaAt7
Rxl9BEBx1tJ7fj2gKkEajE+RAGKZAUgo9d9M3UBF+Mj/ClTG8tRpYES8LiRrRbkz
tEG63EVJrL5WbsSQ2Wt7l1vjNQxWTerMFdcaXQODyoUNCn1x5vGUuFNakwLY6Kzp
pg+oqykL/AI5F4qsk6uBR+HjMfdGBzubxqonj+SIUtSkaDP7m/PI8JDTjjmOGVY9
5U9Phbz8cbgyAx2XQhqFYgsCKBSw0rNE7UB/BtyJVYHC0XaJaagfrcshUB0DeL4T
XDhBM4BMdsXceuxYgmXRs7ibTiQoG85DKEi1Cx61TGg5n2ywdIRWeSrrW1VZWgIk
j+r6z2sEy5p61SQByevwKMWH7XYVdG06p6GeURkRoNg1Rtf6GtiCN9aVM6tLSwzM
Q8O2mDQuNyhgQ8caoeL/5xNSxeJXPI+lVNcMn4D0OAX2DhRss8BlwNW0UMZvI3wG
JFSwseNJF/yKRXuYzb5Tl5UzfjZIIJ0G0J/WN73UaPkbm+o0SkjFI+NXwfwis/lz
xozh61xN3tCw7FXSl50V8ZYyki8jBRooZLpM9FETpFmnQS/VZ4Qmge2U8WOvzY5K
+aP3hdIiS2c=
=ZwY5
-----END PGP SIGNATURE-----

--iKKZt69u2Wx/rspf--
