From: Sergei Trofimovich <slyich@gmail.com>
Subject: btrfs does not work on usermode linux
Date: Sun, 10 Apr 2011 13:37:10 +0300
Message-ID: <20110410133710.0ef34cb6@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iZ9vDpLOAaUGXyZL1sinvQ0"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/iZ9vDpLOAaUGXyZL1sinvQ0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

According to https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_with_G=
DB
UML did work once.

Now it corrupts data and triggers BUG_ON once you
start to use it. I tried both 2.6.38 and 2.6.39-rc2 (x86_64)
I need some help to track it down.

doing 'touch `seq 1 11`; rm 11' kills the kernel:

#run> mount -t btrfs /dev/ubda /mnt/btr/
[    2.220000] device fsid 754599771c9b69eb-66689f77c1542bb9 devid 1 transi=
d 7 /dev/ubda
#status: 0
#run> cd /mnt/btr/
#status: 0
touching files 1 .. 11
#run> touch 1 2 3 4 5 6 7 8 9 10 11
#status: 0
#run> ls
[    2.220000] btrfS: invalid dir item name len: 12594
[    2.220000] btrfS: invalid dir item name len: 0
[    2.220000] btrfS: invalid dir item name len: 0
11
#status: 0
Fasten your belts: removing file 11
#run> rm 11
[    2.220000] btrfs failed to delete reference to 11, inode 267 parent 256
[    2.220000] Kernel panic - not syncing: Kernel mode signal 4
[    2.220000] Call Trace:=20
[    2.220000] 6024b918:  [<601b2567>] panic+0xea/0x1dc
[    2.220000] 6024b9c8:  [<601b491e>] _raw_spin_unlock_irqrestore+0x18/0x1c
[    2.220000] 6024b9e8:  [<60017d00>] free_irqs+0x74/0xde
[    2.220000] 6024ba18:  [<60015faa>] relay_signal+0x38/0x79
[    2.220000] 6024ba28:  [<60013c8e>] sigio_handler+0x5a/0x60
[    2.220000] 6024ba48:  [<6001f224>] sig_handler_common+0x84/0x98
[    2.220000] 6024ba68:  [<6001f2d1>] real_alarm_handler+0x3c/0x3e
[    2.220000] 6024baf0:  [<600579f7>] get_page_from_freelist+0x129/0x478
[    2.220000] 6024bb78:  [<6001f36a>] sig_handler+0x30/0x3b
[    2.220000] 6024bb98:  [<6001f59c>] handle_signal+0x6d/0xa3
[    2.220000] 6024bbe8:  [<600203b0>] hard_handler+0x10/0x14
[    2.220000] 6024bca8:  [<600e04c3>] btrfs_unlink+0x77/0xef

=3D=3D

I've cooked whole root into small archive (3.1MB):
https://slyfox.ath.cx/btrfs/linux-2.6-um-x86_64-fs.tar.gz

You just need to start './run' to enter into UML root fs
and there to issue ./kill_btr to get fault above.

Archive contains minimal .config for kernel 2.6.39-rc2, statically linked
busybox binary and fresh image of btrfs.
It also has tiny script, which will help you to generate the same
rootfs if you are afraid to run suspicious binaries.

--=20

  Sergei

--Sig_/iZ9vDpLOAaUGXyZL1sinvQ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2hiFoACgkQcaHudmEf86rDkQCbBex54Xs4/aQB2cWr/gBb9vkf
YeIAn0v65V1f4sWVr7PDdaj7PXZcAh/r
=MKvA
-----END PGP SIGNATURE-----

--Sig_/iZ9vDpLOAaUGXyZL1sinvQ0--
