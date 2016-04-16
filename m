Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from za3k.com ([71.19.156.60]:42068 "EHLO za3k.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbcDPUSI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Apr 2016 16:18:08 -0400
Received: from [IPv6:2601:644:400:c6f5:5869:1674:cf76:cd09] (unknown [IPv6:2601:644:400:c6f5:5869:1674:cf76:cd09])
	by za3k.com (Postfix) with ESMTPSA id EE8DC18C13A
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Apr 2016 20:08:28 +0000 (UTC)
From: Zachary Vance <za3k@za3k.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-send -c fails: reproduction case
Message-ID: <57129BB1.8020802@za3k.com>
Date: Sat, 16 Apr 2016 13:08:17 -0700
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aRvg4A3fKQNH0Fjjw34nQT8je7cCvhftB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aRvg4A3fKQNH0Fjjw34nQT8je7cCvhftB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Reproduction case after running into the same problem as Paride Legovini:=
 http://article.gmane.org/gmane.comp.file-systems.btrfs/48706/match=3Dsen=
d

To recap, the basic problem is that you can get into a state where "btrfs=
-send -c" fails for a subvolume, with "ERROR: parent determination failed=
 for 9622".

I'm pretty sure this isn't the intended behavior, and it's certainly prev=
enting me from copying my backups right now. If someone could confirm on =
a **completely** fresh system I'd appreciate it.

[root@burn ~]# sudo btrfs sub create m
Create subvolume './m'
[root@burn ~]# sudo btrfs sub create m/a
Create subvolume 'm/a'
[root@burn ~]# sudo btrfs sub create m/b
Create subvolume 'm/b'
[root@burn ~]# sudo btrfs sub snapshot m/a -r a
Create a readonly snapshot of 'm/a' in './a'
[root@burn ~]# sudo btrfs sub snapshot m/b -r b
Create a readonly snapshot of 'm/b' in './b'
[root@burn ~]# sudo btrfs sub delete m/a
Delete subvolume (no-commit): '/root/m/a'
[root@burn ~]# sudo btrfs sub delete m/b
Delete subvolume (no-commit): '/root/m/b'
[root@burn ~]# sudo btrfs sub delete m
Delete subvolume (no-commit): '/root/m'
[root@burn ~]# sudo btrfs send -c a b >/dev/null
At subvol b
ERROR: parent determination failed for 9622

[root@burn ~]# sudo btrfs subvolume show a
/root/a
        Name:                   a
        UUID:                   c86cbbb0-9dea-cf43-809d-637c57dc7e65
        Parent UUID:            bbad9a60-b418-3b46-93f5-84b8ac62adf6
        Received UUID:          -
        Creation time:          2016-02-19 08:31:47 -0800
        Subvolume ID:           9622
        Generation:             18121
        Gen at creation:        18121
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):

[root@burn ~]# sudo btrfs subvolume show b
/root/b
        Name:                   b
        UUID:                   bb9256c1-4fb4-ee4e-b072-0ee570521d06
        Parent UUID:            c5890f1a-94f0-ac48-a69d-656f8e0b7fc6
        Received UUID:          -
        Creation time:          2016-02-19 08:31:49 -0800
        Subvolume ID:           9623
        Generation:             18122
        Gen at creation:        18122
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):

[root@burn ~]# btrfs --version
btrfs-progs v4.4.1

[root@burn ~]# uname -a
Linux burn 4.5.0-1-ARCH #1 SMP PREEMPT Tue Mar 15 09:41:03 CET 2016 x86_6=
4 GNU/Linux

---
Zachary Vance


--aRvg4A3fKQNH0Fjjw34nQT8je7cCvhftB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXEpu4AAoJEH2iwWQVlLJ/SHEQAJo0UQnUSSB7AqpEy5sHU6fj
L/qrFrTVhfE9hymZUnuiSM4fnjntqBoHUmeX5xmGJ+th3Omno3NV1ljqAUcFfV0h
EIfSrItObk6BxaPzcSDbXSsa69p6S08qdL1IYM9ZAGxasaWKK5ZQ7arPNZT3xRAN
M7vJ5Xf84+VG9JEOX9mo97iFakDfTL2CU44ecc/mBOtnTyZTE/A/d7PwDvYHo/sr
+pF4PDsI2xwApy+FxIB4rV5LgSSAnu7JGHbzSWsrfRwCANkMQw13HBxhPuvgr2yn
lt0hkbToJQUEuEP5lxn4A6MTFHiElJYkCTN+wQFShAXIH6DR5+EHasaK/pmRf6ez
q7luS7HiUiFuF9r2h1B/i56NVTsBbD6GcKYbKo8JRFfBQC8017zvYPyKdDVcbqsD
VZZVQuPEvuFUwiv81tZRhowsCJlDttOhLOxhzO8Yk1cybDqnYh5wjvdJdgk2Cc/F
oM7x/LJWxed083iHO1XoxD4W/BGzpjbyFdqbXksYrUadVV3eLFpvn0ZJjiRyVVEp
i+vlVEw9HMfobzE0kL6kjW2PrbC6Gafa8LySDN5pg+ikrn4FI8x8TT7AQfOlhV3E
TKft7SjgyXvf5qlLyH0cGekQrWFJb3ZQfzwu7T051rONNCpMkXzoEgRfH9Pi1Nq+
chDlfMgULcJ3TL2M2DzS
=vWiR
-----END PGP SIGNATURE-----

--aRvg4A3fKQNH0Fjjw34nQT8je7cCvhftB--
