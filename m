From: Timo Witte <timo.witte@googlemail.com>
Subject: Re: Set nodatacow per file?
Date: Mon, 13 Feb 2012 15:21:35 +0100
Message-ID: <4F391C6F.8040405@googlemail.com>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213141040.GG15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig105E83AFBB5E44BD79D49B1C"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213141040.GG15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig105E83AFBB5E44BD79D49B1C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The fileflags utility works great!
Thanks!

Am 13.02.2012 15:10, schrieb David Sterba:
> Hi,
>=20
> On Mon, Feb 13, 2012 at 04:40:03PM +0900, dima wrote:
>> Actually it is possible. Check out David's response to my question fro=
m=20
>> some time ago:
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/14227
>=20
> this was a quick aid, please see attached file for an updated tool to s=
et
> the file flags, now added 'z' for NOCOMPRESS flag, and supports chattr
> syntax plus all of the standard file flags.
>=20
> Setting and unsetting nocow is done like 'fileflags +C file' or -C for
> unseting. Without any + or - options it prints current state.
>=20
>=20
> david


--------------enig105E83AFBB5E44BD79D49B1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPORxzAAoJELFS+VMgnyVJZtYP+gI2OWzI7Se2bKqGgaWRmg9d
UoYqWzS4BZH8HOEjSdIr2BTsk6EnJefJDRUZfjpt1y9RM8ewD3aSfKH9uCwJlSpC
gTb/n6n2acEqM3DiIm7B/j1zQqX0FhgVQqXvWdw9yQ5w+nllbK1h+qmGIU/qSWTs
nBTyXUnh1SKjy2LO5GHkgZln+Umb6imvEhZ+USp8B9GrCMXL3OZwa1ONA7EXcmFh
riyNsq1TGGuW06KF6q6cEUUfuGPfI37t3DIbEHKC8Hm/4UDrBrENs+8YHvV6SmFT
q094v3tpLXWEyoeaArQ7qeeIuYC3/uQR9MJZ7I5ZzGbw2/BH1Kbwj3FjYjLtDeKR
rNnrFLSVvQTU0FUHj1lcJgt3InqSxwsVHwNjSRkMiybz2sDSuFcIKCZHUEAYn+1j
oROeoc1IPrMNYGzpjIE2ihKIfc5sPFML3TLNVND6Ie0M4jhuBvhlbbfRLIfCDqdq
OrtCCE+nCGyrUj4ZuUKHQiODvhfMoqUya5wqgIBvFAow0ko+cdL/sbbT5f+6mH/5
aDz2z8AZxbamcpu8u488XQbJWJVVjIxOrhRQFcC6E2YfpvNm/qVAgaiBYRERj14R
/3V63c6EoPduCgZVcWV1yGdPeqp2zTI0GK89bBTl2TpqWami7pAhRGaAf1DQETby
w8jPksoLpqDDamqJ2coU
=5Zbi
-----END PGP SIGNATURE-----

--------------enig105E83AFBB5E44BD79D49B1C--
