Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36197 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbEPKur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 May 2015 06:50:47 -0400
Received: by pabts4 with SMTP id ts4so61217539pab.3
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2015 03:50:47 -0700 (PDT)
Received: from localhost ([2402:f000:1:1501:200:5efe:a66f:4120])
        by mx.google.com with ESMTPSA id i13sm4398187pbq.79.2015.05.16.03.50.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2015 03:50:45 -0700 (PDT)
Date: Sat, 16 May 2015 18:50:42 +0800
From: Justin Wong <i@bigeagle.me>
To: linux-btrfs@vger.kernel.org
Subject: Very slow writing and low I/O throuput
Message-ID: <20150516105042.GA6088@BigEagle-desktop.tuna.tsinghua.edu.cn>
Reply-To: i@bigeagle.me
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi there,

I'm a maintainer of a linux mirror site, and we use btrfs snapshots provide=
 better service. The
workflow of our mirror job is :
1. create a working snapshot of current mirror
2. rsync from upstream to the working snapshot
3. after rsync done, remove the original subvolume and mv working snapshot =
to production subvolume

Everything was fine until several days ago, every `btrfs subvolume snapshot=
` command takes more than
1 minute to finish, and during this 1 minitue, every write to the disk is e=
xtremly slow (< 1MB/s).

Also, when the disk is totally idel, if I tried to  `dd if=3D/dev/zero of=
=3Dtest bs=3D1M count=3D100 conv=3Dfdatasync`,
this `dd` just hangs, and iostat told me the disk is reading at speed of ~5=
MB/s, not a bit was
writtien to the disk.

Smartctl showed the disk is fine, and btrfs device stat reports no error. T=
his server is a KVM
virtual machine and btrfs is on two 4T qcow2 images, with virtio cache=3Dno=
ne and io=3Dnative.

Uname -a is
Linux debian-opensource 3.16.0-0.bpo.4-amd64 #1 SMP Debian 3.16.7-ckt9-3~de=
b8u1~bpo70+1 (2015-04-27) x86_64 GNU/Linux

Btrfs fi show is
Label: none  uuid: 179cb1ff-fe45-4e02-996a-a9ad02f766b9
Total devices 2 FS bytes used 5.46TiB
devid    1 size 4.00TiB used 3.08TiB path /dev/vdb
devid    2 size 4.00TiB used 2.41TiB path /dev/vdc

Btrfs v3.14.1

SysRq+w reports: http://pastebin.com/ZRPwZiUQ

Mount Options: (rw,noatime,space_cache,autodefrag)

No dmesg errors.

So I wanna know:
1. Why is it slow?
2. Is it bad to use btrfs inside KVM with qcow2?
3. Everything was fast before, can I somehow "reset" the filesystem without=
 losing data?


Cheers,
--=20
Justin Wong

Blog: https://bigeagle.me/
Fingerprint: 15CC 6A61 738B 1599 0095  E256 CB67 DA7A 865B AC3A

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVVyD6AAoJEMtn2nqGW6w6fysP/iJmekg+2tPgWsZm1Cbvf/I7
to9NFr+k4GcZepUQ37Rgnhgw27N/BhpI4acVelwQuz9vrbccPCP/f7Jq5YhVbrpi
p10KB+1P2Q+/GNpbQZTBzIUikOO2zGALGAZrz5J23vHjHaYIyszJIVx7ZWLiVmpa
unZGSUEQ1AuV9BM8GIj46KFmmnjlFoTCJWmTQ3RDHYDOP/mUkiAESZV1JoIjOBow
5Lk/HaPwvDl3nJIEZrW+fK546WPX0KyLRqPPj0grOoskBIwaSouz2Kyn2+5oZutk
bnoBNyEiPKv4hLGEwJOdRr4R3NCQ9v+fJqzmqJbSHXNMDpe72MoO2g6Hz6WsjbNq
+jVkyxf0ZkptLc2sKdP+zvab9S2/Qz682EombsLz0aAtL5EMmuaKENaMnD5F9Fq2
nXjnTqYcC4Z+VzejKzQsbflGIT2vnFOrXMGrmHinF31XSgcG7e6hoWa9Ioj825sb
y1dfeZBXq0eulm0ML5fQQabPisaEAQ8sTbfVRksp17DhiGXoh/5GZie43tGT3c3e
D+rZmWzTr1djnkjLyFo8H+AKC4a9vxoYd4TP2uUrS5bITyD5KpEn1eC455XCshJ1
zNu0uibiIa0WVpMB9eCs4KkBuKdQlvEw9BEG4iRPKfamSTppEE1OQzq+YEzXILMO
NCL3Qg5TLABg8vs0UGC8
=uInR
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
