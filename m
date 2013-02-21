Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34338 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3BUQis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 11:38:48 -0500
Date: Thu, 21 Feb 2013 16:38:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
Message-ID: <20130221163844.GD14283@carfax.org.uk>
References: <51264146.3070504@petaramesh.org>
 <1361462073.18057.23.camel@cwalton-XPS-8300>
 <512644DA.3050409@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
In-Reply-To: <512644DA.3050409@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 05:01:30PM +0100, Sw=E2mi Petaramesh wrote:
> Le 21/02/2013 16:54, Calvin Walton a =E9crit :
> > You really should upgrade your kernel, however. 3.5.0 is rather old in
> > btrfs-years! Lots of fixes have gone into newer kernels.
>=20
> Hi Calvin,
>=20
> I expect Ubuntu 13.04 to come with kernel 3.7 in April. Having Ubuntu
> kernel upgrades every 6 months (and several machines), I try to stick as
> much as I can to my distro's kernel. I'm no developper myself and can
> hardly consider that the kernel that came with the latest distro 4
> months ago is actually _that_ old... So I'll live with it for 2 more
> months - unless I'm pretty sure that upgrading to some more recent
> kernel than the one that Ubuntu 13.04 will have would give me huge speed
> improvements or features I need much - (and I assume that being able to

   3.7 is quite a bit faster.

   Plus, if something does go wrong with your FS, and you're running
an older kernel, you'll get limited amounts of sympathy, because quite
a lot of the problems people encounter with older kernels have already
been fixed in newer ones.

   Finally, Ubuntu publish the latest kernels in a PPA[1], so there's
not really much excuse for not keeping up with them.

> defrag, with my snapshots, would be a good reason for me...)

   Hugo.

[1] http://kernel.ubuntu.com/~kernel-ppa/mainline/

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Nostalgia isn't what it used to be. ---              =20

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSZNlL9z9OVl50rAAQJjLQ//W5S9Wy8tGfy2Zdx5QL5xFFLdpjdaJzCu
OGO6W8xkTajopieVmQ4gwNsOWT24T5XntHuMZUDaEonpuqtbSf298+jIEG0qcdLD
m9upPGR/3IcWlmPFGbFTF9xVf831kX7hvtqKe5wFLD4qY81pLxVpAEPFozCTZZfj
p3j5EtBGdCQu921vfljajgPgzq/St/3Xekd8zmkIeRd1npDRBUSNmiakNwO8DL0b
JF7PK4roM4aMEhfXjg5YhATv5Nd+Qs5A2wLggiMfwWtVFfTdjfmxCck5wvKVBV7r
+pmsm7eDSGIVEiaMBTt0QWWIitbOmrV8fwJZIQA8r5BPa3fO4IwoY7WtDhETAnbY
mmJXi4Zrjec3EtfJZcX+9wxOXiLrO0d4WwfluHnKA/68pwPYpoQn9OaDpVFHvp5/
jxKKF2LE/K5fu1ksmxPtJuybZk1wmzszoO+J/5VZSSTaVttbsMjOwf0S+zWoL6h7
PFvuRTcU5kfSiQNLcbk/qMNSI3hVfnMpo1R28b+D+DerCyCi879o1Xek4s/L1Uj4
bov/4RAgH/KF+aVvBsrDbIxvXNCAMhnt5JqydDndPGgPUeP0tyPREYm2evKOPGGb
0l0CrYjCm8wGBXJx36VqnNeBoGs9imTIRjc3+HV5l2l6Iwf+BwJgg45OkdtNEnil
mbVi20G59J8=
=iwmR
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
