From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Thu, 21 Apr 2011 18:19:42 +0300
Message-ID: <20110421181942.509a7cd9@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
	<20110409000932.6154c7b5@sf>
	<20110409001920.089c4409@sf>
	<20110409005555.4b136f25@sf>
	<4DA29FC1.9050900@cn.fujitsu.com>
	<20110420005531.6d395333@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r/Zn0jM9/E/M=GHGA51YlTE"; protocol="application/pgp-signature"
Cc: liubo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110420005531.6d395333@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/r/Zn0jM9/E/M=GHGA51YlTE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Apr 2011 00:55:31 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> > Thanks a lot for testing, though.
> >=20
> > I guess something messed up your btrfs metadata, cause when btrfs_unlin=
k() wanted to remove A,
> > it found that A was just missing...

Yeah. Now I think I completely figured out what's going on:

My mixed partition was correct except it did'n have MIXED bit in superblock
(I mistakenly used LZO bit for that in btrfs-progs, as I took some old patc=
h from maillist).

Thus I had D+M marked (aka mixed) block groups, but from superblock's featu=
res
there was no way to figure out there is yet such groups. That's why your se=
cond patch
(looking correct) didn't help me. I've fallen to mixed =3D=3D 0 case.

> I think interesting the parts are (they were found by Arne before):
> [    0.040000] new update_space_info:=20
> [    0.040000] space_info has 0 free, is not full
> [    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, =
may_use=3D0, readonly=3D0
> [    0.040000] new update_space_info:=20
> [    0.040000] space_info has 0 free, is not full
> [    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, =
may_use=3D0, readonly=3D0
> [    0.040000] new update_space_info:=20
> [    0.040000] space_info has 0 free, is not full
> [    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, =
may_use=3D0, readonly=3D0

Talking with Arne I was convinced my breakage is not worth fixing in kernel.
After I've added MIXED bit to superblocks' features OOpses gone.

So, once again, please disregard my OOpses.

--=20

  Sergei

--Sig_/r/Zn0jM9/E/M=GHGA51YlTE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2wSxUACgkQcaHudmEf86pwoACfcSZC0GRWbu/M5cveZrgYd7zR
6pAAn3FDclNLiBziMZcLcOI8gCcG/qEP
=1O7Q
-----END PGP SIGNATURE-----

--Sig_/r/Zn0jM9/E/M=GHGA51YlTE--
