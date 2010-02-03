From: paran@lysator.liu.se (=?utf-8?Q?P=C3=A4r?= Andersson)
Subject: btrfs-vol -b endless loop
Date: Wed, 03 Feb 2010 23:25:12 +0100
Message-ID: <87636ej6t3.fsf@nsc.liu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I have a 11G btrfs file system where "btrfs-vol -b" get stuck in a
loop. The "found 7 extents" messages and heavy disk io continues until I
reboot:

[26223.544037] btrfs: relocating block group 42079027200 flags 36
[26228.082740] btrfs: found 2457 extents
[26228.104515] btrfs: relocating block group 41407938560 flags 1
[26228.423981] btrfs: found 124 extents
[26229.514583] btrfs: found 124 extents
[26229.544160] btrfs: found 7 extents
[26229.812494] btrfs: found 7 extents
[26230.453720] btrfs: found 7 extents
[26230.733233] btrfs: found 7 extents
[26231.383321] btrfs: found 7 extents
[26231.652815] btrfs: found 7 extents
...

The error is repeatable. btrfsck does not report any errors:

root@faran:~# btrfsck /dev/sda5
found 9035055104 bytes used err is 0
total csum bytes: 8293152
total tree bytes: 542867456
total fs tree bytes: 503087104
btree space waste bytes: 108089491
file data blocks allocated: 8492187648
 referenced 10314125312
Btrfs Btrfs v0.19

The kernel is Linus' master from two days ago, and seems to have all the
latest btrfs code merged.

Regards,
P=C3=A4r Andersson

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktp98gACgkQyi5LJcueYEv2WwCeOKI47FazoecQSPJA6lrwBm7b
Xs8An1kiPmmR2kvTqjbamleUK4MMas2B
=Z72Y
-----END PGP SIGNATURE-----
--=-=-=--
