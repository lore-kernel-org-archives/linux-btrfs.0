From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 10:03:02 +0300
Message-ID: <20111217100302.6beffbcd@sf.vba.domain>
References: <201112161851.52011.Martin@lichtvoll.de>
	<4906354.Rn8tlOeHyD@venice>
	<201112162053.58332.Martin@lichtvoll.de>
	<201112162158.45819.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pixAVXDA0e2P0I5QcaLzvTu"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112162158.45819.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/pixAVXDA0e2P0I5QcaLzvTu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Dec 2011 21:58:45 +0100
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Nope. Doesn=C2=B4t seem to help much.
>=20
> How to turn it off, after turning it on?
>=20
> deepdance:~> LANG=3DC mount -o remount,datacow /=20
> mount: / not mounted already, or bad option

In debian you can disable syncing on per-process basis:
    http://packages.debian.org/sid/eatmydata

$ eatmydata apt-get install foo
$ eatmydata firefox
$ eatmydata liferea

makes things more bearable

HTH

--=20

  Sergei

--Sig_/pixAVXDA0e2P0I5QcaLzvTu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7sPq0ACgkQcaHudmEf86ryrwCdHSxouKw8aM853AaUGIUEr3Xq
lpwAn3a1W7ZFqFUuK0W3R50ffjOHuVmk
=dPTK
-----END PGP SIGNATURE-----

--Sig_/pixAVXDA0e2P0I5QcaLzvTu--
