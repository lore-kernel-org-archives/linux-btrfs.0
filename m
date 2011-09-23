From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] btrfs/extent_map.c: quiet sparse noise
Date: Fri, 23 Sep 2011 14:58:37 -0400
Message-ID: <25617.1316804317@turing-police.cc.vt.edu>
References: <201109221845.56204.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316804317_4577P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 22 Sep 2011 18:45:56 PDT."
             <201109221845.56204.hartleys@visionengravers.com>
List-ID: <linux-btrfs.vger.kernel.org>

--==_Exmh_1316804317_4577P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Sep 2011 18:45:56 PDT, H Hartley Sweeten said:
> Quiet the sparse noise:
> 
> warning: symbol '__lookup_extent_mapping' was not declared. Should it be static?

Patch itself is correct, changelog is bad.  You're not quieting sparse noise,
you're making a declaration static because it doesn't need external visibility.

--==_Exmh_1316804317_4577P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfNbdcC3lWbTT17ARAvynAKCqgZ+D+5TdpgvcXB8jfkcAvQkUyACffzq4
4GLdG6v+VgGVHHKUQiSUcno=
=Vijq
-----END PGP SIGNATURE-----

--==_Exmh_1316804317_4577P--
