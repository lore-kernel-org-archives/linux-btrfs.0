From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Wed, 13 Apr 2011 23:12:18 +0300
Message-ID: <20110413231218.1603fc65@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
	<20110410230622.09e965ae@sf>
	<20110410232403.617c3b7f@sf>
	<20110410235846.135e801e@sf>
	<4DA32055.2030104@redhat.com>
	<20110411224452.4a5149da@sf>
	<4DA35B98.3010800@redhat.com>
	<20110413002333.3d78d4d1@sf>
	<1302694333-sup-4155@think>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/om6t+X._cpWFp5q2vdPDkA1"; protocol="application/pgp-signature"
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	cwillu <cwillu@cwillu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302694333-sup-4155@think>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/om6t+X._cpWFp5q2vdPDkA1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Apr 2011 07:32:59 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> This is in the master branch now, please give it another test.  Thanks a
> lot for bisecting down and patching!

Tested on btrfs-unstable/master. Works correctly. Reverting
3387206f26e1b48703e810175b98611a4fd8e8ea (to make sure)
on top of master returns panic.

Thank you!

--=20

  Sergei

--Sig_/om6t+X._cpWFp5q2vdPDkA1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2mA6sACgkQcaHudmEf86ooyQCeNp0xGsW7UQcrsviVaD/rn+6j
i9cAnjBfJ04UqwTB250QeWzlXKCbibKP
=2Azt
-----END PGP SIGNATURE-----

--Sig_/om6t+X._cpWFp5q2vdPDkA1--
