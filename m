Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59839 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaDWWlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:41:07 -0400
Date: Wed, 23 Apr 2014 23:41:01 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>,
        linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Message-ID: <20140423224101.GA2391@carfax.org.uk>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
 <20140423185413.GF26949@merlins.org>
 <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
 <20140423191546.GG26949@merlins.org>
 <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info>
 <20140423205819.GH26949@merlins.org>
 <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info>
 <20140423220312.GK26949@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <20140423220312.GK26949@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 03:03:12PM -0700, Marc MERLIN wrote:
> On Thu, Apr 24, 2014 at 12:54:57AM +0300, =D0=9F=D0=BB=D0=B0=D0=BC=D0=B5=
=D0=BD =D0=9F=D0=B5=D1=82=D1=80=D0=BE=D0=B2 wrote:
> > > It may help to look up what error -38 translates into for that mount =
error.
> >=20
> > My searches so far failed to return anything useful to solving this pro=
blem.
> =20
> Yeah, I searched before you :) this would require reading the kernel sour=
ce
> to track down -38.
> (not hard, I just didn't do it)(

#define ENOSYS          38      /* Function not implemented */

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---    =20
                     astronomy is about telescopes.                     =20

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1hBfVheFHXiqx3kAQJKfhAAtfhfV6xwBeyshWmArWHCf70/Jhahq1ix
8kg9ViTX1TeuvOs6qKJGqVvZ1V/xJvS/uc/gnsmPVL8+lLd/I9gB+Ga1AWntmCrR
SPqom5uLvbc7KzQR/kjOraOj989Sr6LVo02qf/8XTzWdxhVT0u3hIJx0Orc0eWlZ
8UTQZwFTKuj9IMCrXBNJyNPROmaRFTrkIgYSPN4E7mQtOY75q3fuf7VUGbcKBtMJ
m6Sf3zuJ3yC01plcznH/rmncPP/ih7pkpERGatb7Tt6K8zcmuBjzWz+I9DtzFPaU
JdWPE/y7hYuKbNRRMsPyu30/ZyvT11DQqlcAT//UMOx+es+BSVTC/cdDB+Zqf5l1
V9UiY0rc6kau/UCDsonBF8mXeEHjGtU9g1ismXXQyZIm5ksA8naB/hkYunnCHiFm
K+s3BokFrKgXj4HDbo1Tz9racD6vKu/gAcwHmyr44lUXX7LCZd/jM8z9VuS9yTvQ
v+Q3vuWK9tTvDw7avZ++g5dvaxOdJXM7cb1Uo6oZgh7CuYZOtp0DdUdwN6j4964V
gC9vGFMr9RWTIs/p1/XZkaTHyFzW2k/34fac7bs2AY4GCVXqJDyOZrANwkaBz2gJ
Ka/23V843LjLIGkrIQsB3O7IGkKQ5HhmUsIlG/3Tq5tB+tyUK4zUMcq/JSS11Aeg
Hdqy7faJays=
=rs4T
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
