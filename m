From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: Integration branch pushed out to btrfs-unstable
Date: Wed, 25 May 2011 21:44:18 +0300
Message-ID: <20110525214418.225ec273@sf>
References: <1306179381-sup-443@shiny>
	<4DDCF79F.80405@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ua7w2zO+RAP+9Y2vZS5dkAR"; protocol="application/pgp-signature"
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDCF79F.80405@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Ua7w2zO+RAP+9Y2vZS5dkAR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> The commit
>=20
> commit c4f675cd40d955d539180506c09515c90169b15b
> Author: Sergei Trofimovich <slyfox@gentoo.org>
> Date:   Fri May 20 20:20:30 2011 +0000
>=20
>     btrfs: don't spin in shrink_delalloc if there is nothing to free
>=20
> gives me very early ENOSPC in my tests on a small volume (7GB).

What king of test is that? I'd like to reproduce it.
Does it do a lot of parallel I/O?

May I ask you to try to reproduce the problem with this sole patch
on top of linus master?

--=20

  Sergei

--Sig_/Ua7w2zO+RAP+9Y2vZS5dkAR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3dTgcACgkQcaHudmEf86qAUQCfbywDa0ayGwmueAkNbDylD2tL
6+UAnR02tYsOaVshbxnE0vSwLMjYuvqD
=ML5O
-----END PGP SIGNATURE-----

--Sig_/Ua7w2zO+RAP+9Y2vZS5dkAR--
