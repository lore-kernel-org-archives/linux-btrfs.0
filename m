Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58453 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3EIMsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 08:48:30 -0400
Date: Thu, 9 May 2013 13:48:27 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: syslog message repeated 3x
Message-ID: <20130509124827.GD26072@carfax.org.uk>
References: <518B6BC1.8020504@gmx.de>
 <BF628B33-2657-4A04-B9D6-18BA462F819D@gmail.com>
 <518B9A4C.8070409@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
In-Reply-To: <518B9A4C.8070409@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2013 at 02:45:00PM +0200, Toralf F=F6rster wrote:
> On 05/09/2013 01:47 PM, Wang Shilong wrote:
> > Anyway, i use the latest btrfs-progs.
>=20
> well, under Gentoo I used sys-fs/btrfs-progs-9999 which points always to =
the latest git version :
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>=20
> My host kernel is stable 3.9.1
>=20
> The mount command still gives :
>=20
> 2013-05-09T14:43:35.604+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-=
b426-00f1739e4d3d devid 1 transid 8 /dev/loop1
> 2013-05-09T14:43:35.604+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-=
b426-00f1739e4d3d devid 1 transid 8 /dev/loop1
> 2013-05-09T14:43:35.608+02:00 n22 kernel: btrfs: disk space caching is en=
abled
> 2013-05-09T14:43:35.660+02:00 n22 kernel: device fsid 20a30a6b-a82f-429f-=
b426-00f1739e4d3d devid 1 transid 8 /dev/loop1

   I guess the main question is... why is this a problem for you?

   The message is informational and doesn't indicate any kind of issue
with the FS. I'd just ignore it/them.

   (Also, are you running btrfs dev scan beforehand or not? It'd be
interesting to see the difference in your logs -- particularly with
timestamps -- when you do that.)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---    =20

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUYubG1heFHXiqx3kAQJkog/+OBmUU1zNuEAmghWLpb70QGlK7AhAZWMP
uxvuJXHmCmRtEDbvpH+Wa4TLmjMRy0V366OAnftnLcG8RHksF3o0Vpi67cr2Yb4U
N/9b3w8ClU5ebHX4zRu0bXAA6JWXK7seL1R2W+IKwlpQ52zL5mmDOGGR2Z/DV5k6
fvnR0BrSxoV/QVEdYAlPXANtLPfVoL4FQUhFQSYrxkdMPmGxr3b6kqmGonLxthPH
Adb1wGIHLLuJ/5Fu8Sq2QJXGwJlw7rPoGPuDqHkOYbbRp5HCKjmByb0IpcYlpT4U
T4G8we1l1uL4GQNY6OsxWTrb0o8BR/reBhsuy53H887CeQ6XDPvvTN/CmZlhFvtU
ovaXY0zKdgN6GtkrVpkM0oUAGxTgd7I3a4MRRABp4jlbmd3WlMuzpic0qs0GWUuO
W0xPl8ShZaJ4sNKvzKvm2d3Rvfbyqm9ebYqPHxRFSV8889gpSPkWhI6XtN0WmN5d
5HTG9LczPWXFd8zJuQUPM+VkviW4E/3wDhLPqdEKINadc2Fy00Zys5sNic15H7nd
bp2neewiKLsSXlPRZ1LdlGX+3Z4jiEP8FGuhfiDXkccAaAeNAe5xW4x73P2tY574
HaycIbLeKcuZOlKIb1uJCjXKyQoUfH3+jV+2hD4fcrTWrv1dF8RGQm1dqT6QrSp2
/tmxfIUHll0=
=0Ob+
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
