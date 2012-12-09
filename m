Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55544 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab2LILi2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 06:38:28 -0500
Date: Sun, 9 Dec 2012 11:38:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, getting darn slower everyday
Message-ID: <20121209113824.GE14469@carfax.org.uk>
References: <50714AC8.4010100@petaramesh.org>
 <201210071259.05801.Martin@lichtvoll.de>
 <50718C44.2080701@petaramesh.org>
 <201210071648.54027.Martin@lichtvoll.de>
 <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr>
 <20121209164125.1bd91f23@natsu>
 <50C4740E.1060906@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
In-Reply-To: <50C4740E.1060906@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 09, 2012 at 12:20:46PM +0100, Sw=E2mi Petaramesh wrote:
> Le 09/12/2012 11:41, Roman Mamedov a =E9crit :
> > CoW filesystem incurs fragmentation by its nature, not specifically sna=
pshots.
> > Even without snapshots, rewriting portions of existing files will write=
 the
> > new blocks not over the original ones, but elsewhere, thus increasing
> > fragmentation.
>=20
> Is it to expect that somewhere in the future, BTRFS will be able to
> defragment itself without duplicating snapshot data ?

   In the presence of snapshots that are modified, no, it's impossible
to fully defrag all the files.

   Consider a file, AAABBBCCC, which is snapshotted, and then the
middle third is rewritten, so the snapshot shows AAAZZZCCC. You now
have two files which share their first and last sections, but the
centre section is different. One or other of those files *must* be
fragmented -- you can't eliminate fragmentation here.

   If you mean, will there be a defrag that does as well as it can
despite the limitation above, and which doesn't split snapshots into
separate copies, then yes -- there's already patches out for that, but
they've had a couple of problems.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---              =20

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUMR4ML9z9OVl50rAAQJz3xAAlxNh4TydDKDcF54xboohcTF6gODcxquT
HWvqSgc2yMziAzUdyDgAxU4hT+T+XbD7zRGgebS0B99/O4uopB0FY2mUKLEaAo95
kCTBvZ6Hh1e2HVKOY+z29zz2PrfpL88vJFPvD7G4in9JryBw6+U8LDNuScXRFhEZ
dosM4KUDmifZrHflxBFXjXZ7NVwJFbK7gWZ2/6SVmhcuLDO72iBmeBydLqMZQ98e
9ixLHji0UQirwu0w45k1ddMk7PWlINrpdclVyLoBnOtJFCkCTO/hqZqoUN0hCq+L
gGIMeUkTRcc8Iw/ZpAQND2MHvawsveUqYhffsIIQeztW0PBfzZrCiOzcTTXeMHHp
fY2vnk/gSpVJEZ1ArLTsg0BOWYvNbWFy5hVEsk/2eE77dFjNjvZ2faf1oRZBqVbf
I8CdRAgQQMCfk3oiWrSGA+F/5D7HYo/BrTIJf+YXZwpL/nSfdjTFAUPkKdovHrOE
rMTbBiCezqXB9tKsAS2OVo7LOa6S6Rhg9XHp86eO/t0OrFIMwU58vBqwi+AVHUCC
Ik6DKFV9OPbi+EaRQaexT07V72e+amrzWeB58Dcy+WnjrMPYI6JcDlMyVkMjWZIj
NzSwSM9jFzPrI0//yaaYkZbeNobYv3kNPGGH6bfuvYEc3bTlrG9S8pv09+YCYZvi
lEb8IFUqjo8=
=BNYw
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
