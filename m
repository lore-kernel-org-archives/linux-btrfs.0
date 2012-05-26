Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:35765 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2EZSyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 14:54:41 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q4QIMJiQ011113
	for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 21:22:19 +0300
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 25685-1330 for <linux-btrfs@vger.kernel.org>;
 Sat, 26 May 2012 21:22:18 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q4QIMDik011108
	for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 21:22:13 +0300
Date: Sat, 26 May 2012 21:22:12 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: Will big metadata blocks fix # of hardlinks?
Message-ID: <20120526182211.GA16059@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

I see that Linux 3.4 supports bigger metadata blocks for btrfs.

Will using them allow a bigger number of hardlinks on a single file
(i.e. the bug that has bitten at least git users on Debian[1,2], and
BackupPC[3])? As far as I understand correctly, the problem has been
that the hard links are stored in the same metadata block with some
other metadata, so the size of the block is an inherent limitation?

If so, I think it would be worth for me to try Btrfs again :)

	Sami


[1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/13603
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642603
[3] https://bugzilla.kernel.org/show_bug.cgi?id=15762

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPwR9TAAoJEKLT589SE0a04ywP/3ixetAAHqBwACzHMDNdzx7G
yKPzsxZaeSWtU7zDxBx0yQ4vLv3Xtg9//vWB1lRGhxDCE8zZZUJX2DuD0i9RMsKA
K2QAKZO55eZPbJhcsQ5hWHFYQ/B2wnQY8TLZJuPEExg/dkkjiIBBJJOekuIBFJFu
k44A0k+1P2pfSDpAmkgsvQQKo10CAobX9rKdRP4XLiXsrwHS1rJI/Ovf4VSGfSOb
7l2APwYRAOtOcYhGExd4c4ZTOcltmmji3yrUgCwkDla94vvwRAL3E4R6LDL7dq+v
YJe8CKEBseh6tYWRttTDewxfmsl5QSGQFbPZcGoAwYP8eUgFgEwlm+qWTr9qUNFk
aCcsK6kkborznl0KT+TWoYvyqoYrms1nf+HGRtjUqBW+ZLjDxAd1BYTZod/iKz/N
vAp4Q4zYkPpQlL9H0PoTGYTHFBZNQZ01BnmkUNWrZ4ZO5wnTTCP2Z7/fDJaVjwTS
45LLp0ctGW3s4G4pFwb13jkJhWjqhVmqDYsWT8LIncu1otBF4OZmIKW+w84fzllD
vdvoT+mYF9f5OnmFa17tJGUG0tEL55lF1ZoCyUb57cHJJFk338Pix3JH7lPguJ2T
WmZ6TDwhOhZDKIO105qIuy2gkIfSxtchMfscnCXHwHU3Wb2BpWyPjQGmnaqjy7n5
+NTablW1ng+acFQAnIMn
=g9pN
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
