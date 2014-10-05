Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:56504 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaJENM6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Oct 2014 09:12:58 -0400
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by rin.romanrm.net (Postfix) with ESMTPS id AD52B5FAC5
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Oct 2014 13:12:55 +0000 (UTC)
Date: Sun, 5 Oct 2014 19:12:54 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Empty directory can't be removed, "not empty"
Message-ID: <20141005191254.46cb7e7f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7dM1.LxUci3Tdjr7w8J=wAA"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/7dM1.LxUci3Tdjr7w8J=wAA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

After an improper shutdown (power loss), I got one of these again:

# ls -la junk/
total 0
drwx------ 1 rm   rm   4152 Oct  5 18:44 .
drwxr-xr-x 1 root root   72 Oct  5 19:10 ..

# rm -rvf junk/
rm: cannot remove `junk': Directory not empty

The kernel version is 3.4.18.
If this helps, initially it was a Chromium browser profile directory; and it
had nodatacow files in it (chattr +C).
How to actually remove this directory now?

--=20
With respect,
Roman

--Sig_/7dM1.LxUci3Tdjr7w8J=wAA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlQxQ9YACgkQTLKSvz+PZwjTLwCggZ+QM8AyMTFZgzVV3+uhKy4S
f8gAoJEk1ObNyKTZuX90qLxNUFSlNZTI
=ivmc
-----END PGP SIGNATURE-----

--Sig_/7dM1.LxUci3Tdjr7w8J=wAA--
