Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57498 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3KMPZc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:25:32 -0500
Date: Wed, 13 Nov 2013 15:25:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: invalid opcode: 0000 [#1] SMP
Message-ID: <20131113152530.GK4315@carfax.org.uk>
References: <1384242552.7516.9.camel@hsew-frn.HIPERSCAN>
 <pan$d06e7$206fd374$423b51c3$17212f9e@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN0A5YokcrYPGsSB"
In-Reply-To: <pan$d06e7$206fd374$423b51c3$17212f9e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cN0A5YokcrYPGsSB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2013 at 03:03:37PM +0000, Duncan wrote:
> Franziska N=E4pelt posted on Tue, 12 Nov 2013 08:49:12 +0100 as excerpted:
>=20
> > we are using a btrfs RAID 1 with four 2TB hard drives (WD Caviar green)
> > on a Debian 7.2 with Kernel 3.11.6
> >=20
> > Now we had an 'invalid opcode: 0000 [#1] SMP' when a sector fails in
> > messages log.
> > After that, access over smb and nfs wasn't possible.
> > A restart solved the problem of inaccesibility.
>=20
>=20
> A couple notes from a fellow btrfs-using sysadmin...
>=20
> 1) invalid opcode 0000:
>=20
> As I understand it, this is relatively generic and doesn't define the=20
> error by itself.  The 0000 opcode can be viewed as a zero-dereference of=
=20
> sorts, it's indication of a bug happening earlier, such that an expected=
=20
> valid opcode ends up being zero.  The error itself will be earlier --=20
> this is just where it ends up being trapped.

   I believe it's actually (one of?) the methods used to generate BUG
or BUG_ON.

> As to what that error is in this case...
>=20
> 2) btrfs raid1:
>=20
> Unlike, for example, md/raid1, btrfs raid1 is not at this point run-time=
=20
> tolerant of device failure.  At this point, a btrfs raid1 device failure=
=20
> seems to make the entire system basically unusable and require a reboot,=
=20
> after which device/data recovery (for example, mount degraded, add a=20
> replacement device, rebalance, and delete the failed one, or if it was a=
=20
> temporary dropout, simply btrfs scrub to find and fix the checksum=20
> mismatches from the valid copy) can be initiated, if necessary.

   My experience is that the reboot isn't required, although remount
rw may be, followed possibly by reinserting the device and definitely
running scrub. YMMV, though.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---      =20

--cN0A5YokcrYPGsSB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoOZ6VheFHXiqx3kAQKTrxAAp/KTtXPsntvk5hFkiGuk4fA3XNCbMunX
/7mZlt3MnKaPre7mqoD/quRZc56Iuagml3vHgHxw0yBwbrq+gipIsZa7M4Aw4FOS
e8x9t/AcNNDMC3InqXgVllNu9bwQMqxez3FdNUxjDfzfOguGw6iuwmxFalF5yEc/
fGDHzhhhOxkgDRheydjJq/QCCzje3/5sf6Y0JrZl4Ilp8EW7kVvnJbnqH5PA9/ZV
vNEj29Xn8qPsYm7yAsZqIeRGQLQqOzpb2qk6diwFUyvgJsGCx2nHGWaXBgTBWpQ9
SAGSB0e6nu3bbD5ogyWe0u9LlSZduEPGfIHX8xZcIqpOWsA0csLkAF0rdzo2yVXY
XqSbh+6M0M8iRqLKfBJB49z/xnhRfAEIiOx6lh6RUPVgjdpJjhuKPyuPTIRjrA3g
g4FLMwbf4qeFAK493O5La0fyB9CiaMRGvZ2nWtfQrR+7gGDJNm+lYxcxf95QyNKH
X80KxZc/Whgj/XQOlqE+SbxcDJgmR1bkTMlxz1FPPabpfRLvf4dlSNbyQ0RF4G50
BHsLcBcgKNVbKu/T7Ij4ac8ldG5g6Fp39JyBkgxCQttk+Vt1j8o9svNeHRib7Nnu
rfamJ7XliYrP0k6PzUUnzB0wcCA9F28VcqT1E+VNmYyzOGRGqBnQSjA88e6BdwJK
x2b4/fR+mhk=
=+SHW
-----END PGP SIGNATURE-----

--cN0A5YokcrYPGsSB--
