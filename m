Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59560 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAULnJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 06:43:09 -0500
Received: from [141.2.9.4] ([141.2.9.4]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPSA (Nemesis) id 0LzFLh-1Xilzf45jN-014TM1 for
 <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2015 12:43:07 +0100
Message-ID: <54BF90C5.8060100@spth.de>
Date: Wed, 21 Jan 2015 12:43:01 +0100
From: Philipp Klaus Krause <pkk@spth.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS critical (device dm-2): invalid dir item name len: 77
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G1n51Ia0JavIkVEmc9fMHcP2qrQtQ66bu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G1n51Ia0JavIkVEmc9fMHcP2qrQtQ66bu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I've been using btrfs on a Debian GNU/Linux system. After about 9
months, I encountered my first filesystem issue. It first appeared while
doing an rm -rf, which resulted in a

rm: cannot remove [=E2=80=A6]: Directory not empty

a du -s on the directory gives an

BTRFS critical (device dm-2): invalid dir item name len: 77

I can mv directory around (which is good so it doesn't get in my way any
more), but can't rm it.

How can I get id of it?

Philipp


--G1n51Ia0JavIkVEmc9fMHcP2qrQtQ66bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlS/kMkACgkQbtUV+xsoLpq+5ACgxthXKjw1M4hDv+CbbvNbNakA
21EAoJH7FryLVeQ+Q/tqi4D6L0N2pJab
=WIbU
-----END PGP SIGNATURE-----

--G1n51Ia0JavIkVEmc9fMHcP2qrQtQ66bu--
