Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:45853 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbdLESsH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 13:48:07 -0500
Received: by mail-lf0-f54.google.com with SMTP id f13so1437981lff.12
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 10:48:06 -0800 (PST)
Received: from [192.168.1.5] (ppp109-252-90-255.pppoe.spdop.ru. [109.252.90.255])
        by smtp.gmail.com with ESMTPSA id h28sm158409ljb.30.2017.12.05.10.48.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Dec 2017 10:48:04 -0800 (PST)
Subject: How exclusive in parent qgroup is computed? (was: Re: exclusive
 subvolume space missing)
To: linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>
Date: Tue, 5 Dec 2017 21:47:59 +0300
MIME-Version: 1.0
In-Reply-To: <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FshKqqH7g3lTnq89APJwCsuebg3J4knVT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FshKqqH7g3lTnq89APJwCsuebg3J4knVT
Content-Type: multipart/mixed; boundary="Of9OCUdILhPOhXqOprRCVIWqldQ2qiehO";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>
Subject: How exclusive in parent qgroup is computed? (was: Re: exclusive
 subvolume space missing)
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
In-Reply-To: <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>

--Of9OCUdILhPOhXqOprRCVIWqldQ2qiehO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

02.12.2017 03:27, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>=20
> That's the difference between how sub show and quota works.
>=20
> For quota, it's per-root owner check.
> Means even a file extent is shared between different inodes, if all
> inodes are inside the same subvolume, it's counted as exclusive.
> And if any of the file extent belongs to other subvolume, then it's
> counted as shared.
>=20

Could you also explain how parent qgroup computes exclusive space? I.e.

10:~ # mkfs -t btrfs -f /dev/sdb1
btrfs-progs v4.13.3
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM /dev/sdb1 (1023.00MiB) ...
Label:              (null)
UUID:               b9b0643f-a248-4667-9e69-acf5baaef05b
Node size:          16384
Sector size:        4096
Filesystem size:    1023.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              51.12MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1  1023.00MiB  /dev/sdb1

10:~ # mount -t btrfs /dev/sdb1 /mnt
10:~ # cd /mnt
10:/mnt # btrfs quota enable .
10:/mnt # btrfs su cre sub1
Create subvolume './sub1'
10:/mnt # dd if=3D/dev/urandom of=3Dsub1/file1 bs=3D1K count=3D1024
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00833739 s, 126 MB/s
10:/mnt # dd if=3D/dev/urandom of=3Dsub1/file2 bs=3D1K count=3D1024
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0179272 s, 58.5 MB/s
10:/mnt # btrfs subvolume snapshot sub1 sub2
Create a snapshot of 'sub1' in './sub2'
10:/mnt # dd if=3D/dev/urandom of=3Dsub2/file2 bs=3D1K count=3D1024 conv=3D=
notrunc
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0348762 s, 30.1 MB/s
10:/mnt # btrfs qgroup show --sync -p .
qgroupid         rfer         excl parent
--------         ----         ---- ------
0/5          16.00KiB     16.00KiB ---
0/256         2.02MiB      1.02MiB ---
0/257         2.02MiB      1.02MiB ---

So far so good. This is expected, each subvolume has 1MiB shared and
1MiB exclusive.

10:/mnt # btrfs qgroup create 22/7 /mnt
10:/mnt # btrfs qgroup assign --rescan 0/256 22/7 /mnt
Quota data changed, rescan scheduled
10:/mnt # btrfs quota rescan -s /mnt
no rescan operation in progress
10:/mnt # btrfs qgroup assign --rescan 0/257 22/7 /mnt
Quota data changed, rescan scheduled
10:/mnt # btrfs quota rescan -s /mnt
no rescan operation in progress
10:/mnt # btrfs qgroup show --sync -p .
qgroupid         rfer         excl parent
--------         ----         ---- ------
0/5          16.00KiB     16.00KiB ---
0/256         2.02MiB      1.02MiB 22/7
0/257         2.02MiB      1.02MiB 22/7
22/7          3.03MiB      3.03MiB ---
10:/mnt #

Oops. Total for 22/7 is correct (1MiB shared + 2 * 1MiB exclusive) but
why all data is treated as exclusive here? It does not match your
explanation ...


--Of9OCUdILhPOhXqOprRCVIWqldQ2qiehO--

--FshKqqH7g3lTnq89APJwCsuebg3J4knVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlom6d8ACgkQR6LMutpd94xY/gCfdB7BNXOxQuMTE/Sy2JCI82Nj
U08Ani8toAY7fmelqcDCnNU3vD56Q22P
=P/YV
-----END PGP SIGNATURE-----

--FshKqqH7g3lTnq89APJwCsuebg3J4knVT--
