Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49924 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3R6z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 12:58:55 -0500
Date: Thu, 30 Jan 2014 17:58:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: lost with degraded RAID1
Message-ID: <20140130175831.GU3314@carfax.org.uk>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gh9b96O0vZdbsJLX"
In-Reply-To: <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gh9b96O0vZdbsJLX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2014 at 10:33:21AM -0700, Chris Murphy wrote:
>=20
> On Jan 29, 2014, at 12:16 PM, Johan Kr=F6ckel <johan.kroeckel@gmail.com> =
wrote:
>=20
> > My situation:
> >=20
> > Former btrfs-RAID1 on two luks encrypted partitions (bunkerA and bunker=
B).
> > Disk holding bunkerB died online.
> > Now I started rebalancing bunkerA to single,
>=20
>=20
> You're doing an online conversion of a degraded raid1 volume into single?=
 Does anyone know if this is expected or intended to work?

   I don't see why not. One suggested method of recovering RAID from a
degraded situation is to rebalance over just the remaining devices
(space permitting, of course).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Everything simple is false. Everything which is ---        =20
                          complex is unusable.                          =20

--gh9b96O0vZdbsJLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUuqSx1heFHXiqx3kAQKMzw//Vl5XJf2RGo8LxP1VRcVqk+Yp7+hr8vGu
T7H/hBoyEXXD1DZDx2L2gAg8fiw6U29qtHN5T7w/u7dwOVNCcO9Q1ZFmr84frEG3
lfKjkzUl78W1HkTUVlz4ZfHef44cuKqpJpfLIjasFId2oF55ypOiGAFDYwO0ig38
KN3hWvoFx1QyJBieLUngZdEZq1JJsy9PJ499NU/7Ar/50wZvdjlwQKRUoymkACmo
Fdso5cG9PWhnWjGp3FmC0cVX1UFQvA7N5wv7Y28F3Cnmy07JwsUj/D3xz5EKhNlU
FGmRt2S6T95Ygd0x9RMvhDiqfJu78j6CNKPZTjfwafS3D5fH95lb2zi73NxoN2Xc
fBM0EKmf4Q2C9/mXCSOeR/UDywSPVSHx5NIQ8YQ19YRn2Ncw/8zlrlwECFKY1X4/
O4jKk2PLfKlxGGZBHVsR+VEOZXvz3nOpGGKmToRljQt+wepQi0650sSaUH1dfskE
zjjAuNwGwSM71ByYApXqOVUqDaKsiubgLxnRREn+Ci6lm3PW8/oVWuOJIEia/fCU
K+0/n23X/a0sXxmgBioGamnAbrup0Fp0g7ZgxDvvVSYW6N69vsFgRPGmmGptHlqE
N4gwp1HugAodSbSLm1GJlosOiWhGnRzRW7N7ws0pe7kdBM8xsEyA2o/YcTpHMkiM
8dyepNnxS0Y=
=skR7
-----END PGP SIGNATURE-----

--gh9b96O0vZdbsJLX--
