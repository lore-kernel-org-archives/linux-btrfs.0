Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dehost.average.org ([88.198.2.197]:59278 "EHLO
	dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbcGBKAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 06:00:06 -0400
Received: from [IPv6:2001:470:1f09:520:a60:6eff:fe69:494] (unknown [IPv6:2001:470:1f09:520:a60:6eff:fe69:494])
	by dehost.average.org (Postfix) with ESMTPSA id 46F1B18462A4
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jul 2016 12:50:11 +0300 (MSK)
To: linux-btrfs@vger.kernel.org
From: Eugene Crosser <crosser@average.org>
Subject: btrfs ops hang indefinitely (process in D state)
Message-ID: <57778E41.1010000@average.org>
Date: Sat, 2 Jul 2016 12:49:53 +0300
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IV0fl32WcAWpds9nDvNlQRpRBv0I60O65"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IV0fl32WcAWpds9nDvNlQRpRBv0I60O65
Content-Type: multipart/mixed; boundary="GtjhmtSIV1gJAEiBooNMPq58xVqcL8TSn"
From: Eugene Crosser <crosser@average.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <57778E41.1010000@average.org>
Subject: btrfs ops hang indefinitely (process in D state)

--GtjhmtSIV1gJAEiBooNMPq58xVqcL8TSn
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: quoted-printable

Hello,

This may be the same problem as "btrfs lockup".

I have two systems using btrfs for several years. One is my home desktop,=
 it has
root+home ext4 fs on a PCI SSD, and "big stuff" on a btrfs using two hard=
 disks
in RAID1 configuration:

root@pccross:/export# uname -a
Linux pccross 4.7.0-rc2-custom #2 SMP Sat Jun 11 01:13:59 MSK 2016 x86_64=
 x86_64
x86_64 GNU/Linux # -- Was earlier 4.x version when the problem happened
root@pccross:/export# btrfs --version
btrfs-progs v4.4
root@pccross:/export# btrfs fi show
Label: 'export'  uuid: c94c3ef6-394e-4441-8992-d7033332bdff
	Total devices 2 FS bytes used 1.26TiB
	devid    1 size 3.64TiB used 1.26TiB path /dev/sda
	devid    2 size 3.64TiB used 1.26TiB path /dev/sdb

root@pccross:/export# btrfs fi df /export
Data, RAID1: total=3D1.26TiB, used=3D1.25TiB
System, RAID1: total=3D32.00MiB, used=3D208.00KiB
Metadata, RAID1: total=3D5.00GiB, used=3D3.82GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

A month ago, I moved a directory containing a few Gb from home (ext4) to =
btrfs
with `mv` command. The command took some minutes and eventually finished =
without
error. After some hours, a cron job that uses files on btrfs did not run.=
 I
logged in to investigate and realized that its process was in 'D' state, =
and any
command that I tried that would use btrfs (ls, ...) would enter 'D' state=
 and
stay there indefinitely. There was nothing interesting (that I remember) =
in
dmesg. Reboot did not help and indeed could not complete because some of =
startup
jobs use files on btfs, and they hang.

I rebooted without mounting btrfs and ran `btrfsck`. It found and fixed s=
ome
inconsistencies (no log, sorry), and I could mount, and since then everyt=
hing
works, except the directory that I moved disappeared altogether (I had a =
backup
so could restore it). No debugging material left so this is just for back=
ground.

=3D=3D=3D=3D=3D
Enter the second system. It is a rented physical server in a datacenter w=
ith two
hard disks, joined into a single root btrfs (/dev/sd[ab]1 are swap partit=
ions):

root@dehost:~# uname -a
Linux dehost 3.13.0-91-generic #138-Ubuntu SMP Fri Jun 24 17:00:34 UTC 20=
16
x86_64 x86_64 x86_64 GNU/Linux
root@dehost:~# btrfs --version
Btrfs v3.12
root@dehost:~# btrfs fi show
Label: none  uuid: 67a2708c-f039-4783-a699-6f6be0dac318
	Total devices 2 FS bytes used 442.58GiB
	devid    1 size 2.72TiB used 444.04GiB path /dev/sda2
	devid    2 size 2.72TiB used 444.03GiB path /dev/sdb2

Btrfs v3.12
root@dehost:~# btrfs fi df /
Data, RAID1: total=3D440.00GiB, used=3D439.51GiB
System, RAID1: total=3D32.00MiB, used=3D72.00KiB
System, single: total=3D4.00MiB, used=3D0.00
Metadata, RAID1: total=3D4.00GiB, used=3D3.07GiB

A week ago, the system started to become unresponsive every day. Kernel w=
orks
(responds to ping) but no processes can start. Looking at the logs after =
reboot
I noticed that activity stops some time after the start of backup cron jo=
b that
covers a set of directories (/etc, /home, /var/mail and some more.). I di=
sabled
the backup job and since then, several days, it did not hang.

=3D=3D=3D=3D=3D
My question to the developers: what can I do to (1) recover the filesyste=
m while
it is mounted (I can use recovery netboot system and run `btrfs check` as=
 the
last resort), and (2) provide any useful debugging information to the dev=
elopers?

Thank you,

Eugene


--GtjhmtSIV1gJAEiBooNMPq58xVqcL8TSn--

--IV0fl32WcAWpds9nDvNlQRpRBv0I60O65
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXd45OAAoJEHykB8ORnUWMHdYH+wdijZdpVmBPITgSMmi269vF
zr+T9u115mm7vWtY4DrbOO4TxdkadqPOi3lYoiTn0jg2X6QgpMli+2y65SG+YBDi
xuiYRHce2qmL6kQl0smkS9zIwfNURPQFaeIv3L36gNoxrvvUB/NC2PuOIuViv4bX
YrPqVprsad7noLTs+mbaeFO55I5BvMnWWlCfgep/OQvleASWHTE0Ott1uxRU27lt
ngJojc7yHdQAv56Pt5OcAEf7Jc0JWrJeFtyPoaOQNp9VWyC71HtUg2EM2mcEP67e
WzeH1Qjs97B500EV5mLsKrq+WGtOMqCkjRri0matPc3OKxZxiewD/AOWWiEP7As=
=Pii1
-----END PGP SIGNATURE-----

--IV0fl32WcAWpds9nDvNlQRpRBv0I60O65--
