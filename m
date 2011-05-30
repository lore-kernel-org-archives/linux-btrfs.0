From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warninga in Linus' tree
Date: Mon, 30 May 2011 11:36:53 +1000
Message-ID: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used

I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
difference.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN4vS1AAoJEDMEi1NhKgbsj4cH/3Yhe1Yj2R3f9JVd+hvJOP+P
Uddnm7QkcbUOOJfUOZPI2gZJWX0ph3sjNLOkyZk4l3hmxiu/yaSKKE4brC2ZldyE
1uHUhGz43HsUc6HtOKF1j/K3cG9F3bigvt6zLKlwEY6OWGV6dGIs+RCf8WGt1wbQ
PUB7mdS3mh5nKHW3fI+H4saNJ71H/enzUhRJ2ZLsWYCqyri1gQZkMcxUpCangoHj
+0D2MbegjpFq2F9HHsWoHn9Q4DNFKxHPGZBlH2E+QhfGZCnJ48BpzGd7pCDu54nW
EFhvgf+cRjOVuzDOMNPB+ijifIylzwn6blWAIKwAiWLPgnzNTjK5SmFM9WaSszs=
=luuw
-----END PGP SIGNATURE-----

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII--
