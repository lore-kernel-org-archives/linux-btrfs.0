Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp5.abo.fi ([130.232.213.120]:50086 "EHLO smtp5.abo.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751780AbdGBS2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Jul 2017 14:28:43 -0400
Received: from goopy.abo.fi (goopy.abo.fi [130.232.212.89])
        by smtp5.abo.fi (Postfix) with ESMTP id C2C5D80297
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Jul 2017 21:21:47 +0300 (EEST)
Received: from smtp5.abo.fi ([130.232.213.120])
        by goopy.abo.fi (goopy.abo.fi [130.232.212.89]) (amavisd-new, port 10024)
        with ESMTP id pnh7CQNBau-R for <linux-btrfs@vger.kernel.org>;
        Sun,  2 Jul 2017 21:21:47 +0300 (EEST)
Received: from smtp.abo.fi (cavatelli.abo.fi [130.232.213.240])
        by smtp5.abo.fi (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Jul 2017 21:21:47 +0300 (EEST)
Received: from wdesk.local (82-128-227-225.bb.dnainternet.fi [82.128.227.225])
        (Authenticated sender: wlund)
        by smtpauth.abo.fi (Postfix) with ESMTPSA id 81E5E1C0
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Jul 2017 21:21:47 +0300 (EEST)
Date: Sun, 2 Jul 2017 21:21:33 +0300
From: Wictor Lund <wlund@abo.fi>
To: linux-btrfs@vger.kernel.org
Subject: Unable to mount filesystem
Message-ID: <20170702212133.59ddb448@wdesk.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1mPONz=hiOiertkguKe8=0N"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/1mPONz=hiOiertkguKe8=0N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi!
=C2=A0
I cannot mount my filesystem anymore. The problem started with it going
into read-only mode after the filesystem accidentally became full. At
some point the system crashed and after that I got this error. Is it
possible to recover the filesystem or at least recover some data from
it?

Here is some information from the system:
=C2=A0
$ uname -a
Linux localhost.localdomain 4.8.6-300.fc25.x86_64 #1 SMP Tue Nov 1 12:36:38=
 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
=C2=A0
$ btrfs --version
btrfs-progs v4.6.1
=C2=A0
$ sudo mount /dev/sda4 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sda4,
=C2=A0=C2=A0 missing codepage or helper program, or other error
=C2=A0
=C2=A0=C2=A0 In some cases useful info is found in syslog - try
=C2=A0=C2=A0 dmesg | tail or so.
=C2=A0
$ sudo btrfs fi show
Label: 'fedora' =C2=A0uuid: 3ddc9cf1-ff3f-4081-900a-4f732838c31b
=C2=A0=C2=A0=C2=A0Total devices 1 FS bytes used 208.67GiB
=C2=A0=C2=A0=C2=A0devid 1 size 230.04GiB used 212.06GiB path /dev/sda4
=C2=A0
$ dmesg | grep -i btrfs
[ 5.747551] Btrfs loaded, crc32c=3Dcrc32c-intel
[ 5.748632] BTRFS: device label fedora devid 1 transid 649633 /dev/sda4
[ =C2=A0=C2=A048.663727] BTRFS info (device sda4): disk space caching is en=
abled
[ =C2=A0=C2=A048.665184] BTRFS error (device sda4): bad tree block start 0 =
1234052513792
[ =C2=A0=C2=A048.665194] BTRFS warning (device sda4): failed to read tree r=
oot
[ =C2=A0=C2=A048.680625] BTRFS: open_ctree failed
=C2=A0
$ sudo btrfs check /dev/sda4
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=3D1234052513792, have=3D0
Couldn't read tree root
Couldn't open file system

$ sudo btrfs restore -l /dev/sda4
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=3D1234052513792, have=3D0
Couldn't read tree root
Could not open root, trying backup super
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=3D1234052513792, have=3D0
Couldn't read tree root
Could not open root, trying backup super
Superblock bytenr is larger than device size
Could not open root, trying backup super

--
Wictor Lund

--Sig_/1mPONz=hiOiertkguKe8=0N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signatur

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZWTmtAAoJEEuVlb5b0JxKajMQALWwaGmDcAA4Y6LIqL8lzq5N
gmBMfUC4DNCE88t8hSavbjIZjMmWYmvsr5uKRoBjZjHj+GMAjFGuIKA1hqWf+2Co
jLMGcZLirtIaKW2MVspiwREVXzCr0a35hhUMWtGSBzyyngvVMfSy7WtVMzZJkWo6
2/3akc01/qMw6w5b7ByxrmP/VOalksLfEJCkTaRwaR8ghd5rU1+1/kWwAfaPFiYv
9TQhzPgBydRvow4pqbgjl/uigTonzT3M9CBuvR/T5L4/u6iXR7livFTICPw3AwIn
z4XoCJNxRbNmwkQN14IvpPbuEd60UhL25g/UhV64l2v3si/vzUVqdNsn9Hyxl4iW
NgbRVszX8nx+SDcyic0dpRg9QM0ISOTScIZrfPhETK03ZDfrm2Y8KEiLNoxGCvAw
/+jvkwgNY6wxAjH0JlTPqteNBYWbidyuM7hpqB25lb1k6RPNeWsXC4PIa1/oWghl
F/2NzgH2l47C3ds/4WloI9IHDZcwh6qDiUqSP5i5aarqfsVhawv27IFk1CjjuyUo
ZRiE9IJlzNIrMRW6G2078fNDO3t7ddw2RV0mAMnm/xFmcPHCaGqaiN2rbtfp9EVj
saMk0bvGzbvSDUVLtXbTQqvRJscSpm+L/rNaH8D/ytxJ8uOMN36G8bYjMZJq/ti/
O71nZ6kFpN+Is0TgD+Ew
=DngF
-----END PGP SIGNATURE-----

--Sig_/1mPONz=hiOiertkguKe8=0N--
