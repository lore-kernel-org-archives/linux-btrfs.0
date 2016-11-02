Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58123 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbcKBJ3a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 05:29:30 -0400
Date: Wed, 2 Nov 2016 09:29:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian =?iso-8859-1?Q?V=F6lker?= <cvoelker@knebb.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Resizing BTRFS - raw partition
Message-ID: <20161102092926.GM16645@carfax.org.uk>
References: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
 <20161102091249.GL16645@carfax.org.uk>
 <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
In-Reply-To: <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2016 at 10:18:03AM +0100, Christian V=F6lker wrote:
> Hi Hugo,
>=20
> thanks for the quick reply. Regarding version- I prefer to use stable
> Linux versions....and I am not going to upgrade just btrfs outside of
> the verndors builds. So I am stuck happily with this version. And I run
> Linux since more than 10years, so I am really fine with it, I guess :D

   Well, btrfs-progs 0.19 was last released several years ago. If your
kernel is of the same kind of age, then you're going to be seeing a
whole load of really nasty data-corrupting or filesystem-breaking bugs
which have since been fixed. Basically, if something goes wrong with
your FS when you're running a kernel that old, the main rsponse you'll
get is, "well, that was silly of you, wasn't it?", and you'll have to
make a new filesystem and restore from your backups and hope it
doesn't happen again.

   I would currently recommend running a 4.4 kernel or later. If you
want a "stable" kernel version from a distribution, and want some kind
of support for it when it goes wrong, you're probably going to have to
pay someone (Red Hat or SuSE, most likely) to support your
configuraion.

   Hugo.

> And thanks again for your proposal. Yes, your command worked.
>=20
> I had to tell betrfs the devid!
>=20
> So this did NOT work:
>=20
>  btrfs fi resize  max /srv/share/
>=20
> Instead the following two commands worked:
>=20
>  btrfs fi resize  1:max /srv/share/
>  btrfs fi resize  2:max /srv/share/
>=20
> And now boths phydevices show the correct size.
>=20
> This sound really strange for me that I have to tell btrfs to resize
> just a single disk insteag of automatically resizing all disks...I bet
> next time I have it forgotten again :-(
>=20
>=20
> Greetings
>=20
>=20
> Christian
>=20
>=20
>=20

--=20
Hugo Mills             | In one respect at least, the Martians are a happy
hugo@... carfax.org.uk | people: they have no lawyers
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                       John Carter, A Princess of M=
ars

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYGbH2AAoJEFheFHXiqx3k95EQALY8R0f6dLEWuN4fWThfdHPv
Z7dBg7t4oRr0k+X5NwrpscNbPYrAetsZvmL8Tj9ypRZrX1o+ZwyjCBG7TTgIZghf
lG/xsH2+G4bfPbHKrhErYGh2yJYCkTN4SQw95zbTix6oVKQfKmRvEn0ElvIzKd1I
7by4yQa5qNIRg4IgBMDY73TH2eoVYo8uAWW9FP7zEUJKbm3R4R58m3UjL+PzEZSv
psSTAAnlbqCJkq2g/PIco6R7vLuUQdFMqi3uc1yVOQ6OngS20z1q+tc0zHAQUDmx
lB6JQKM3zKMgV4g75WtV/J0XDNnqB4PxZkSvFzEe3eC4/N1rs3F7vQSibxWNKtLj
4dJmx2o7wx1Ia6lRjJgh7rGsvou9HJO7se2rUcdcOHyBM+g7Alx8RvnYY6ZKOoLq
PXYXJcc4lkjgXi+bQ24vUsvZ+a7vqJr5cWPeD/SJ+9hAAnjsygvfQ/ha+whDaPmf
f9KETsPbnUmlUlMB+PVlDJ/+ul8AU5uqBb1m0u/GSpWKpqGPqxind16WoLD85Vuu
1oo1rTaUYOTQLkM1+AydHr64q0Xct1dk7oVj0s78dPRSaAcY1t/ssNTJJHpH4Yz6
2gexkz6u0wLC+9REH+SN2d+JyWugG4bfxiemuDnPvhF8D6UENLH9CuGD2lK90PHD
50a2BcO8d1Tk9+5FqvY0
=T43y
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
