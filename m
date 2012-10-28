Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47050 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2J1Njs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 09:39:48 -0400
Date: Sun, 28 Oct 2012 13:39:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Ronnie Collinson <notthinking@gmail.com>,
        Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Subject: Re: How does btrfs behave on checksum mismatch?
Message-ID: <20121028133943.GD5042@carfax.org.uk>
References: <20121027215645.GU2381@yeono.kjorling.se>
 <201210281423.51427.Martin@lichtvoll.de>
 <20121028132639.GC5042@carfax.org.uk>
 <201210281436.24540.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
In-Reply-To: <201210281436.24540.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 28, 2012 at 02:36:24PM +0100, Martin Steigerwald wrote:
> Am Sonntag, 28. Oktober 2012 schrieb Hugo Mills:
> > On Sun, Oct 28, 2012 at 02:23:51PM +0100, Martin Steigerwald wrote:
> > > Am Sonntag, 28. Oktober 2012 schrieb Ronnie Collinson:
> > > > In a raid1 situation, it will also rewrite the effected data, on
> > > > the drive that failed the checksum
> > >=20
> > > Will it do so without an explicit scrub?
> >=20
> >    If a failed checksum is detected, yes.
> >=20
> >    If there's a bad block, and the FS happens to read the good copy
> > first, it won't fix it, because it hasn't tried reading the bad copy
> > yet.
>=20
> Ah, okay. I think I read some while ago in a case of bad checksum detecte=
d=20
> it won=B4t repair automatically. Has this been changed?

   It was changed some time ago -- the kernel release after scrub went
in, IIRC.

> Anyway, a regular scrub still makes sense, as BTRFS only reads files that=
=20
> applications demand and BTRFS may read from a good copy as you pointed=20
> out.

   Indeed. I have a cron job in /etc/cron.monthy for my main FS to do
just that.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---         =20
                         darkness bind(2) them.                         =20

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUI01nr9z9OVl50rAAQLq7BAAjMDLDzZ21r0myZlv6mFMLdhYKWMdTxgP
77i2vwEuYI9g8pTeAW32cenUQSXKJH3w1yfhkC4rwnobjDR51/oFuCbqG0c1KMf3
PrVJaUm7wXdVh2fW+esXKAio0tAp6iUzelW7PeXhAj/STspfocXMTuVTi8q5yT2l
hm9aXRt7xBmYNakPuYK9VC8PbsdFqJ6S7vMPB3fwC9IT3TtiwZAT8EHxTutorSkr
lHub4kGqPMqtHjsfbPwZIGrXNG5A8jzKYNQsit6WXl8MYXGFtiks7jW/A1X22KSH
l5S2rMUp/1btsFimFr5dKpPSFY3rZkAYrzq4z/HzssUbqVmMI27KBscWdFu8YAkU
vbGvHCuioOIxgcHr2Ah2Yh4BmrKgSYXTrdFCBekByI5BmMEkh/92HppBm3LY8oPT
Eqt8L35ABRvnZYVi34ENzQckrr6rB2CflLfoU/PCjNVdSvUXyZgZ02uIoVwMdk1r
c9adalZASYf9L88YoR3KIt//Qe1GKE4jdR4HF1LasWbmSQyCc+K6LyHoNnGMOAqZ
AwiSYafJezQXBcIEuYMYcbkAtYtl9iet365auFrK06tPCAA3UAxxVcyNYDWOw3rC
C84H2PA8AXfWeA9+gFAAch7rv15l/5lu+Wy0JOlZa7LmPsE2pgpT86pJ0S+1ZR0r
zZKAgWXQroI=
=VJrd
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
