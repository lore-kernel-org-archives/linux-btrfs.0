From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: btrfs does not work on usermode linux
Date: Sun, 10 Apr 2011 18:42:49 +0300
Message-ID: <20110410184249.483d8d67@sf>
References: <20110410133710.0ef34cb6@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3fYpUIwyrmYf.KD0FRj+ZK6"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110410133710.0ef34cb6@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3fYpUIwyrmYf.KD0FRj+ZK6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Apr 2011 13:37:10 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> According to https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_with=
_GDB
> UML did work once.
>=20
> Now it corrupts data and triggers BUG_ON once you
> start to use it. I tried both 2.6.38 and 2.6.39-rc2 (x86_64)
> I need some help to track it down.
>=20
> doing 'touch `seq 1 11`; rm 11' kills the kernel:

2.6.36 works 2.6.37 doesn't. bsecting

--=20

  Sergei

--Sig_/3fYpUIwyrmYf.KD0FRj+ZK6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2hz/8ACgkQcaHudmEf86peTQCfQ3aEcU5uI2/dHTtlEUD3PVoY
fiEAnij2Grf7LF40P+MGmvZi6/X3L49V
=Wqau
-----END PGP SIGNATURE-----

--Sig_/3fYpUIwyrmYf.KD0FRj+ZK6--
