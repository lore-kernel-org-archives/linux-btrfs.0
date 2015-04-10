Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moh2-ve3.go2.pl ([193.17.41.208]:36646 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbDJWLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Apr 2015 18:11:08 -0400
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 4362B958022
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 00:10:59 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 00:10:59 +0200 (CEST)
Date: Sat, 11 Apr 2015 00:10:49 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: btrfs balance {,meta}data to raid5 not working?
Message-ID: <20150410221049.GE9470@wloczykij>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eu8nj/18vubUeVCi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eu8nj/18vubUeVCi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I tried today to balance two drive btrfs raid1 to two drive btrfs raid5
without luck:

~ # btrfs balance start -dconvert=3Draid5 -mconvert=3Draid5 /mnt/cdrom/
ERROR: error during balancing '/mnt/cdrom/' - Invalid argument
There may be more info in syslog - try dmesg | tail
~ # btrfs balance start -mconvert=3Draid5 /mnt/cdrom/
ERROR: error during balancing '/mnt/cdrom/' - Invalid argument
There may be more info in syslog - try dmesg | tail
~ # btrfs balance start -dconvert=3Draid5 /mnt/cdrom/
ERROR: error during balancing '/mnt/cdrom/' - Invalid argument
There may be more info in syslog - try dmesg | tail
~ # dmesg | tail -3
[57073.050249] BTRFS error (device sdd): unable to start balance with
target data profile 128
[57079.674386] BTRFS error (device sdd): unable to start balance with
target metadata profile 128
[57082.754136] BTRFS error (device sdd): unable to start balance with
target data profile 128

Linux 3.19.3
btrfs-progs v3.19.1


Piotr Szymaniak.
--=20
Nie wierze,  zeby wyslali cie tam, nie w tym kraju, gdzie zabojcom daje
sie  po lapie i po dwoch latach ogladania kolorowej telewizji w wiezie-
niu znow wypuszcza na ulice, zeby mogli zabijac.
  -- Stephen King, "Apt Pupil"

--eu8nj/18vubUeVCi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVKEppAAoJEEMpAov1cw9l1KAP/Ry8nWArBqEk9bhr5Ojok7P/
G9cE9vmpMOkyUb/NiBT9XEI6aPVXXy0NJsKWgLv+rK5XcFOW5aarkYw7zq+jU+lM
zKR/tgMHfFI2AodSDWcoH9DrhFiZOxofbTM5xodPsOzXjezz9KqOev7qBCrayvCb
WGOBZG/+YVlQV1+U3KoFaSmvpyiy2KRaSSFBCVL3wwJzPoQezZ8TuQfZSqQ/UimX
lUA5kaQN7BAdsh8JCiVmLA7SbGXroHLlJudvPCOLJk4XDrwaaMWqpMyqsW9HtC6U
7QMvNyZDKvL/VoZF80+FVmJ5aKq1ECbhCWGP6S6LcsNbNvSi4pIln3KJUTGe7fjF
eTC2rRzYTf0H/KbAuwwPb6OJkWM6dJIRY8iSEhTVKJj5Bvl/Zbbyu37HuERyPbRy
bbf09SMrIGf4WGe5W6QAdIj+cpDdzO7aw8vUric5X0ppVARk8T8jxNiyO+UOC/p2
mxJVgb9VuSxZsH8ixQW8B8c6wX0AHvPyeZnoS8fU+PN4kTluW+ZXeBcLhFSthqV2
RgqNa5yo14Dg3ADc62VZxA2nhZZkJvAkk4liPvB+CGfqomccev9AaMVn8J7Algbm
q2QS/GotfU6bgvMQQz8nnWuIX5yTcvNf724ONlVn1Fgzg8cwnw8j8vXHrR0oEfvv
P/1xWzK/Z7983vaq0izz
=O21X
-----END PGP SIGNATURE-----

--eu8nj/18vubUeVCi--
