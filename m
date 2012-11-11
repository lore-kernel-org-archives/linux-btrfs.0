Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52304 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2KKPUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Nov 2012 10:20:09 -0500
Date: Sun, 11 Nov 2012 15:20:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cache problem
Message-ID: <20121111152006.GA5604@carfax.org.uk>
References: <509ED1D6.8010903@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <509ED1D6.8010903@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2012 at 11:14:46PM +0100, Sw=C3=A2mi Petaramesh wrote:
> Hi,
>=20
> My BTRFS is mounted with space_cache,inode_cache , and I now get at boot
> time the following message :
>=20
> =E2=80=9Cbtrfs: free space inode generation (0) did not match free space =
cache
> generation (189086)=E2=80=9D
>=20
> Starting once with "clear_cache" doesn't seem to be able to fix the
> issue... Any clue ?

   You only need to mount with space_cache once, and after that it's
"sticky". What's probably happening is that you're mounting with
space_cache, which rebuilds the cache. Then, if you reboot before it's
finished rebuilding the cache, the cache isn't complete, and (I think)
it causes the above message -- which is harmless. The same applies to
the inode cache options.

   Try mounting with clear_cache *once*, then remounting with
space_cache,inode_cache *once*, and waiting for it to finish
rebuilding the cache. Finally, remove all mention of the caches from
your fstab and kernel command line before you next mount the FS.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Great oxymorons of the world, no. 8: The Latest ---        =20
                          In Proven Technology                          =20

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJ/CJr9z9OVl50rAAQLUnQ//afCCpUErlugb9u1FgyFeT6alKTNE1kkS
U2z5xxexrpT6YR6YDiiVbvTBwR/c/Vr78alW3NiVfJ9GER8knObnmwZYChYOu3Mn
YFRbHq/qbU+F0nvWbGgp6UmNzjk5UF/rm/6xkwOE0bWJIM35QgNct2RP5Yj6esd7
LgPICqsZ/8sLxU8SlbDo9g2fF6Mu7ZNwsCYWg593Ab95M0lAZLu5Z6+ARUY2CDi6
1K4GTRbqqaE2pT8eKB2waHKjfEyOkyb/oTuC181qR2ZCW94WHMnzwBZDNeHL9vvs
3DsbBGzQF1/4firSfY2U0yMo2WJ0hT+CmGnOKxa8Y+tc8CmkT2xh12BifxxxPRqz
h9+QdD5KhSJXsRpjYiF3i+O0RXL84Rfso1XmA4qU2aGbIJQxyV8Gzv72IZCYxyys
1Vbz1srRYC6m48aXPoNuhxijtwPGFxaDxL/LSzEqFSUUl8jJ0iyNpk+LjqN75uUe
ZZdh9uB3qZkIQuWd+kt8WUT95PqlSoW8MAb5SP7j8y/1184fpe38l1Ukf7MDacat
vhp1VGGhx1d2nOH8fPrsKvA6Ia7JJsl7Aoqx+xbIaSgqXgcw9zjIjTRxNohsGcPj
sf9CsmJ+eP3fEoAPwnN6WRP1ojjTKIQJE0hiX6VDZcoiayU8ZUsJVp/wPvIdNEzY
PTnjABaU+sY=
=Mc/6
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
