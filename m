Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42078 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaICHdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 03:33:11 -0400
Date: Wed, 3 Sep 2014 08:33:05 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs-3.16: fs metadata is both single and dup?
Message-ID: <20140903073305.GH18897@carfax.org.uk>
References: <pan.2014.09.02.12.05.33@googlemail.com>
 <20140902121349.GF18897@carfax.org.uk>
 <pan$5f385$eac97af1$e9cf0e10$15446dc8@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
In-Reply-To: <pan$5f385$eac97af1$e9cf0e10$15446dc8@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 04:53:39AM +0000, Duncan wrote:
> Hugo Mills posted on Tue, 02 Sep 2014 13:13:49 +0100 as excerpted:
>=20
> > On Tue, Sep 02, 2014 at 12:05:33PM +0000, Holger Hoffst=E4tte wrote:
> >> So where does the confusing initial display come from? [I] don't
> >> remember ever seeing this with btrfs-progs-3.14.2.
> >=20
> >    Your memory is faulty, I'm afraid. It's always done that -- at
> > least since I started using btrfs, several years ago.
> >=20
> >    I believe it comes from mkfs creating a trivial basic filesystem
> > (with the single profiles), and then setting enough flags on it that the
> > kernel can bootstrap it with the desired chunks in it -- but I may be
> > wrong about that.
>=20
> Agreed.  It's an artifact of the mkfs.btrfs process and a btrfs fi df on=
=20
> a new filesystem always seems to have those extra unused single profile=
=20
> lines.
>=20
> I got so the first thing I'd do on first mount was a balance -- before=20
> there was anything actually on the filesystem so it was real fast -- to=
=20
> get rid of those null entries.

   Interesting. Last time I tried that (balance without any contents),
the balance removed *all* the chunks, and then the FS forgot about
what configuration it should have and reverted to RAID-1/single. I
usually recommend writing at least one 4k+ file to the FS first, if
it's bothering someone so much that they can't let it go.

   Hugo.

> Actually, I had already created a little mkfs.btrfs helper script that=20
> sets options I normally want, etc, and after doing the mkfs and balance=
=20
> drill a few times, I setup the script such that if at the appropriate=20
> prompt I give it a mountpoint to point balance at, it'll mount the=20
> filesystem and immediately run a balance, thus automating things and=20
> making the balance part of the same scripted process that does the=20
> mkfs.btrfs in the first place.
>=20
> IOW, those null-entry lines bother me too... enough that even tho I know=
=20
> what they are I arranged things so they're automatically and immediately=
=20
> eliminated and I don't have to see 'em! =3D:^)
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Never underestimate the bandwidth of a Volvo filled ---      =20
                           with backup tapes.                           =20

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVAbEMFheFHXiqx3kAQIM/Q/9GzYpLICW08J0JU2WRS8CK5Z2u88z6n+h
VyF1hgclqRcwNJB+N+iMK0A9Z/ouNm902zprrKokvLNGu5uraOSGFpCjmVu/XOFm
MBGhVP4XvRwQgJ0ZgKGEKsQiayex+ISNLsmeHjM7uA4qZfjbgfIO9GQOKs3I+E+a
cemxwjQigjpn/SJsnbK/5OyL/nx4hgzuivrVc2911KwozANaQpXu1XQBLnBAai+A
oPhbpci6xUJwGZOz8I9lOZaLMyQ9yWADczqO+J5lLgz1oo2uA8w+VKx9zOC1y0He
nIArJ4WpATsZRdtZ6oM0A7zw4I3cUHT5/yLkKScloVRGrg8YWsFBwYUSR2yXc48v
A6Yp0Jv9naeQ5RFEFEx8juXSvuzsYCnugsCSyXfLJ50Bne3NyoKfOaJAhu3UrKN5
q3GzhkmbeOy9SEDH22hg9KmeINtsB668ITh6TyyhJmWfEmt8+jDj4aI/5R/GVzzc
XhoeaSOHqyqy8qp45cqePz2RJ4OW5078xYzm/lJC0PeHtieBo9DJQoikPw+nZhnf
t9zhJ/zkwTJH7Mod0FfCPsK6kJxvbV1ayW148CAi9vpp0aMIXXo11tYZR9SbG3f/
DNFlfCuqYe32FPqhuQv1JBk/O0FzEa120p4Ze9j0GOShKhdkzQd/tvGknNH/BO7F
M3XGuzvbhZw=
=CMuk
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
