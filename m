Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40243 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3C2NLJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:11:09 -0400
Date: Fri, 29 Mar 2013 13:11:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Harald Glatt <mail@hachre.de>
Cc: Josef Bacik <jbacik@fusionio.com>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
Message-ID: <20130329131103.GA16159@carfax.org.uk>
References: <515563D7.3020706@petaramesh.org>
 <20130329125832.GB1876@localhost.localdomain>
 <CAFWF=akTNuVDSbPzb9aPeMkL2uf6zKAKm6C=VFrMNVKRznQqcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
In-Reply-To: <CAFWF=akTNuVDSbPzb9aPeMkL2uf6zKAKm6C=VFrMNVKRznQqcg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 29, 2013 at 02:06:39PM +0100, Harald Glatt wrote:
> On that note, is btrfs doing automatic background scrubs of its own or
> do I have to use crontab to schedule scrubs?

   If you want a full-disk scrub, you'll need to schedule it yourself
with cron (I run mine once a month). However, if a problem is detected
during normal operation -- e.g. you read a piece of data and it's got
bad checksums -- then the FS will fix it if it can, in the same way
that it would with a scrub.

   Hugo.

> Thanks!
>=20
> On Fri, Mar 29, 2013 at 1:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > On Fri, Mar 29, 2013 at 03:50:15AM -0600, Sw=C4=81mi Petaramesh wrote:
> >> Hi there,
> >>
> >> I've started "btrfs scrub start /" on one of my machines (Kernel
> >> 3.8.0-15 Ubuntu AMD64), which typically "behaves well" so I wasn't
> >> suspected any disk issue.
> >>
> >> After having ran for only 165 seconds, "scrub status" shows it pretends
> >> having found and corrected 22926 CSUM errors ??!?!?!?!!???
> >>
> >> This is a rather new HDD, in perfect shape (SMART all OK, never
> >> reallocated a single sector, less than 200 hours total runtime...)
> >>
> >> WTF ?!?
> >>
> >> I've cancelled scrub for now, until I get further understanding of what
> >> can be happening...
> >>
> >
> > So this is probably because of the extent tree corruption you had, it's=
 just
> > cleaning things up and you should be fine once it finishes.  Thanks,
> >
> > Josef

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---     =20
                     headline (possibly apocryphal)                     =20

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUVWS5lheFHXiqx3kAQKBMhAAubMRGgmzxBVjm2ViGMsAgG48tGuaw2iH
Z6PMAMERQScrZquyIFFIp+j+VWAiys9BlKupYJygDGLJJ1PMv6F5uN8QO/rRcxzi
teSSkQBMrEB2snDhz6kAC/x17dMl9BorrYkwIh3bQnqyopoeSVX2oXbO7t1rF/ae
CSP/Nx+5Dxg4OrZsaOQtmBL2TDSv6eIGO6yDA/0Yxu5+CmoqfVfpR+BLNfFkSGmf
a6mNI8DQTT25Hs+izhVg6Gd96l3Zm0Y1fUeKyDA7AtuTZ8rF2o5W1hEBDo/g56wS
Ar+IHoEX/K8DJsDf2JS+4SKlbx7eh/cpeT6GVloohK5UIzbavnW/Q6xmJR7Y9dEa
8g2DGFtD+DiCpmdI1YdQu3Y9SSpOgkszljYg4XgNQyRnc4eoqwXvZBvT8TvRrB0v
KonWkHQP/XRXSFLPU8XCO6qlhpINpbcHzAk35P/th2wdafGq0hdqzKp9eTKAR+yG
0yFEk/rom7gjRkn8QsMbPxV4PyCjxRg16FA2dfJtES05I1Nxj/0rzhtRjAhd+7cB
QWDzP2gc+pdRAI81dEUVejQjgULov0CwcPT6a6Ds6VG2R8NEMiq/yO2XIMIDVgUp
L75bGXx99q+1Vver7cGt1AbTnFqcMcDh2YqSx7kuxiksUa0KGNSlhJWVN41eexaG
bATqzZpYms0=
=Mq1D
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
