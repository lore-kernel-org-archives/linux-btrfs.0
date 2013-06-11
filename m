Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sawicz.net ([195.54.47.121]:54391 "EHLO sawicz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3FKSvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 14:51:01 -0400
Received: from sawicz.net (serwer.sawicz.net [195.54.47.121])
	by sawicz.net (Postfix) with ESMTP id C057A304B848
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:50:55 +0200 (CEST)
Received: from [10.2.0.15] (89-70-82-159.dynamic.chello.pl [89.70.82.159])
	by sawicz.net (Postfix) with ESMTPSA id A096C304BC5A
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 20:50:55 +0200 (CEST)
Message-ID: <51B7718E.6080000@sawicz.net>
Date: Tue, 11 Jun 2013 20:50:54 +0200
From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-transacti:1014 blocked for more than 120 seconds.
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD154E2FB9DFD22E997DF98B2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD154E2FB9DFD22E997DF98B2
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




--------------enigD154E2FB9DFD22E997DF98B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRt3GOAAoJEGnv7NPGHSZF6/AQAJCKOwhKjJdojkdJb146Co6K
JB//yqpYCC2u7vIpMxa+NB42Kv408hz8b2IQ5DNW71JdiMqFnwEqN7I3HUt/Z5KJ
t22eZYwfza/bTUHZNX0QZmlbsOisT6x7Qxa2SYwVLBoE8Yy2IHesniJGLo7XqKrR
D/7FYN9wTr3mqkJygvkR80rncvlWOSaONwaX0PnsCbwRG6z+NhNSjDWJqNxJoj2W
aiSHf6/q5NI59ejUTOeJlIs8/xXi1TnAzIquL1azF/V/J88GLwNQCTRWPYZ48gsy
zdnEBgfc0xy7yOBjUrLZw4dYSadFoSpJwZChIlNEV8NF2DqTywgIBwUi4SSRzeZu
ue3E+8bidxDqCotaLVdDQvd8e2mPmDeu8VIpwETTxQfa766R7bmTNWkUxK9VsEPZ
BtvFX3qzyJsSY72L0ERHTvkmyPen2rFM7mldNp9TSbGxHMHwV8YZy6hiiWXLZLl0
azxPeuHmF6k4+5cucnJd6xj+eR+Idjsiv/pMh29SMxlqaPHwZQLkiCx2ac6Cx9BE
TSmExkHYArLmsOxhVL0xMkXvTo+V5DaS31udt7aguii3SaPfcTI8upNjPFyTng6U
jUoxCbMtFtI9Gx8jFxqnwrnbxdESkY+xFR6zVmNmzsoQjSmiKCK6LsSn0vgt2YtU
dj8Gjb3KV1s46LtSQn14
=2v98
-----END PGP SIGNATURE-----

--------------enigD154E2FB9DFD22E997DF98B2--
