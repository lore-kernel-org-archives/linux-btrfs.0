Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43080 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbJ0RJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 13:09:05 -0400
Date: Tue, 27 Oct 2015 17:09:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-balance causes system-freeze on full disk
Message-ID: <20151027170904.GK11331@carfax.org.uk>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
 <CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
 <40k4gc-scp.ln1@aldebaran.xundeenergie.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XjbSsFHOHxvQpKib"
In-Reply-To: <40k4gc-scp.ln1@aldebaran.xundeenergie.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XjbSsFHOHxvQpKib
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2015 at 05:05:55PM +0100, Jakob Sch=C3=BCrz wrote:
> Found a new habit...
>=20
> I have a lot Snapshots on my drive. (Take every 10 Min a new one, every
> houry one, every day one, every system-update, every plugin after
> external HD...)
>=20
> If there are to much snapshots (didn't find out the count how much
> exactly) balancing fails with a system-freeze.
> if i delete some of my snapshots, balancing is working...

   The whole machine comes to a halt, or just the balancing? If you
have lots of snapshots, balance can take *insane* amounts of time --
my big storage array, for example, takes about 60 seconds to balance a
data block group, and something like 4+ hours to balance some of the
metadata block groups. While it's "stuck" like that, it is actually
making progress, but it doesn't look like it.

   Hugo.

> Maybe this is a hint for bugfixing!!
>=20
> Do you think?
>=20
> greez
>=20
> Jakob
>=20
> Am 2015-10-21 um 22:51 schrieb Kyle Manna:
> > I had a number of similar btrfs balance crashes in the past few days,
> > but the disk wasn't full.  You should try tailing the system logs from
> > a remote machine when it happens. You'll likely see some bug info
> > before the system dies and becomes unusable.
> >=20
> > The issue I encountered is described @
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D105681
> > =E1=90=A7
> >=20
> > On Wed, Oct 21, 2015 at 12:38 PM, Jakob Sch=C3=BCrz
> > <wertstoffe@nurfuerspam.de> wrote:
> >> Hi there!
> >>
> >> Is it possible, what i've recognized now. My system (debian) runs on
> >> btrfs, and i have a lot of snapshots on my hard-disk.
> >> Since some days my system freezes totally. I recognized, it always
> >> happens during btrfs-balance.
> >>
> >> So i deleted some of the old snapshots and tried another balance-run.
> >> Nothing happened... No system-freeze.
> >>
> >> System-freeze means: No Keyboard-action. The Mouse is frozen, the scre=
en
> >> is frozen, no magic-sysreq, no ssh-login.
> >>
> >> Can btrfs cause such a freeze??
> >>
> >> greez
> >>
> >> jakob

--=20
Hugo Mills             | Darkling's First Law of Filesystems:
hugo@... carfax.org.uk | The user hates their data
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--XjbSsFHOHxvQpKib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWL6+wAAoJEFheFHXiqx3kb+YQAKvUO7rRcwxdvyNgnm2oDrCF
x00XATwchLgMU791vJb4YEiwEJR5I4GiAQ7XzgtymQwrduT36rXrl8eT300hhmXJ
icSsN80iEFRQXvKs4ZV4gCocR0IDFMCTvuxoqznkryXNtYLxQUeOPxFuUHKQZ/zm
mzfLoZC9ykm2r2QnYobYakm/23P+NWn3OnysrucVmx/3vjl3SNaqTOPVdZpNHxrp
PwlAAmU4WnoMvp6c4N0JlhM/jAaBA8w0A129YH2efw+rwg50+oGX/CXo7L+WPOKW
r3Z9iHGtgJaWzEQPx0vIzytHI4aSiYTRTuM9iHchwxdkMQmn6cl5YlTgKCxQqblJ
Q/bC7mTLaoBJFD2q+RhHuJk6jZsHSN41z/jnm86gy1xs2cNge1CJsBQIcTRAIY9I
A9cIIjoGdZXEXds2sCdqbI0T46r4pk29SGsV1yMlqn1JEavmW4XP2cFQjESHpVtW
pdaGDgotwqNevU18OmubXbh/8kYjAMDkajsKYI1FtPHwPlfVkn5d7cztSY+NHLdQ
JAh5VMI+IGLdvh2qFK0IzXpQhGzEd8bukR0g7VdFUNHm7Pvk6jaRPQNSSP1k106O
0QyYTpk8Nx9btbag3x/SKcfCb/OQYheQe5uZT3E/fOI/fupsl5gTQBEeri7Cv1O0
aS+9Zp5OeABhzJgv87yg
=sTx9
-----END PGP SIGNATURE-----

--XjbSsFHOHxvQpKib--
