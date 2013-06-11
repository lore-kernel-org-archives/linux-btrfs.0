Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sawicz.net ([195.54.47.121]:54555 "EHLO sawicz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab3FKTOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 15:14:05 -0400
Received: from sawicz.net (serwer.sawicz.net [195.54.47.121])
	by sawicz.net (Postfix) with ESMTP id 5D3DF304B846
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:42:57 +0200 (CEST)
Received: from [10.2.0.15] (89-70-82-159.dynamic.chello.pl [89.70.82.159])
	by sawicz.net (Postfix) with ESMTPSA id 25C96304BC5A
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:42:57 +0200 (CEST)
Message-ID: <51B76FB2.70504@sawicz.net>
Date: Tue, 11 Jun 2013 20:42:58 +0200
From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-transacti:1014 blocked for more than 120 seconds.
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0DF15FB6D8B5FA112F7E39AB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0DF15FB6D8B5FA112F7E39AB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hey,

I've a 2x4TB RAID1 setup with btrfs on kernel 3.8.0. Under high I/O load
(BackupPC dump or writing a large file over gigabit) I get messages in
syslog such as the one mentioned in the subject.

The full non-logcheck-ignored log is under [1].

A BackupPC dump between the same exact machines onto a 2TB ext4 volume
take 90 minutes on average, the process on the btrfs volume took 465
minutes... BackupPC uses hard links for unchanged files between backups,
if that's relevant.

When copying a large file over gigabit, I'm getting around 50MB/s burst
speed for about 30s, followed by a minute of 0B/s when btrfs-submit and
btrfs-transaction are at 99% IO in iotop but minimal READ/WRITE.

Is there anything I can do to relieve that? If more details can help,
I'll gladly provide them.


[1] http://pastebin.ubuntu.com/5755800/

Thanks,
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>


--------------enig0DF15FB6D8B5FA112F7E39AB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRt2+1AAoJEGnv7NPGHSZFFboQAIeu8Qq8tEpb2FCa3FdHLYrM
wimlDqFKzd9iYwEeqRQHYbPOJdyHEEIupy31PrldVRtOz74IWVdJwYQzwhwwoI+B
QaVtj7zuQ9LlfjRvaU9ZwZa/0xTaUV1yL1BVhab1/ZvQlDMa6BhCEwyEwzk9BzPS
BrVcE0mIoc0V3Psm2Mxf279//NHgXpfoZa9OiuG2ZaHxmgOKcB70VxcVRq0y3gY/
7WJYAAidfXUuusl9KBC4vzfHk9RDwuQf+srqB0osVd7scl7H+yW9tiP3r06csbJC
rCnm25eWw4TkgTzi5BUOa/V28qB1l9Xb9CDSghV2dINAPQNOZn8zPxLDw+DQBcQo
FRJi29AQXYQGiwxEGeQ4AfRhiH1y/V/zooC3+sRYd1AxTqUbTPBrGOrDKJcC6Psf
tFeAod3BmmF1Ebqk7/JW9xFHv95FyME3dudeA5ctmHyNsiZGPnQik1qnzQa54rl6
TmVWaPqJjyztaxfhI63gcxyc4Do10xkyAhCJvsOpKy7KF2nqfx8obO3o0sfyBebR
OQtSGMwqqLP2Nh+zUDQX1Dd9h7Qz9A1iEfwLYPyOQ1Lo5s/balStUDfeAZcGIC4t
WYzOI/lRpt4JeRjOhDl+DbxhEmxtrf9h6f0neMMyXaaFs4yJ7YDJg4h4AfZj9Nsi
/zczZCjH5kpsbfuOwtcG
=9D28
-----END PGP SIGNATURE-----

--------------enig0DF15FB6D8B5FA112F7E39AB--
