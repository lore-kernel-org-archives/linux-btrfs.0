Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx01.maketank.net ([144.76.146.236]:33646 "EHLO
        mx01.maketank.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732665AbeGKPvR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 11:51:17 -0400
Received: from localhost (milter01.int.lan [10.200.0.47])
        by mx01.maketank.net (Postfix) with ESMTP id 95856FF787
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 17:37:22 +0200 (CEST)
Received: from mx01.maketank.net ([10.200.0.41])
        by localhost (milter01.int.lan [10.200.0.47]) (amavisd-new, port 10021)
        with ESMTP id dmbknsEuoPC3 for <linux-btrfs@vger.kernel.org>;
        Wed, 11 Jul 2018 17:37:14 +0200 (CEST)
Received: from [192.168.2.126] (p54A4F4C5.dip0.t-ipconnect.de [84.164.244.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx01.maketank.net (Postfix) with ESMTPSA id A5AA8FF735
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jul 2018 17:37:04 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Udo Waechter <root@zoide.net>
Subject: Corrupted FS with "open_ctree failed" and "failed to recover balance:
 -5"
Message-ID: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
Date: Wed, 11 Jul 2018 17:37:00 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="cDUZUaVmfUnJD2aScP5O5OW8AkeCqnM5h"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cDUZUaVmfUnJD2aScP5O5OW8AkeCqnM5h
Content-Type: multipart/mixed; boundary="KXmu6ryAPPedPKnpyfisiCTlLSiIvk6Ml";
 protected-headers="v1"
From: Udo Waechter <root@zoide.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
Subject: Corrupted FS with "open_ctree failed" and "failed to recover balance:
 -5"

--KXmu6ryAPPedPKnpyfisiCTlLSiIvk6Ml
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I have a corrupted filesystem which I can't seem to recover.

The machine is:
Debian Linux, kernel 4.9 and btrfs-progs v4.13.3

I have a HDD RAID5 with LVM and the volume in question is a LVM volume.
On top of that I had a RAID1 SSD cache with lvm-cache.

Yesterday both! SSDs died within minutes. This lead to the corruped
filesystem that I have now.

I hope I followed the procedure correctly.

What I tried so far:
* "mount -o usebackuproot,ro " and "nospace_cache" "clear_cache" and all
permutations of these mount options

I'm getting:

[96926.830400] BTRFS info (device dm-2): trying to use backup root at
mount time
[96926.830406] BTRFS info (device dm-2): disk space caching is enabled
[96926.927978] BTRFS error (device dm-2): parent transid verify failed
on 321269628928 wanted 3276017 found 3275985
[96926.938619] BTRFS error (device dm-2): parent transid verify failed
on 321269628928 wanted 3276017 found 3275985
[96926.940705] BTRFS error (device dm-2): failed to recover balance: -5
[96926.985801] BTRFS error (device dm-2): open_ctree failed

The weird thing is that I can't really find information about the
"failed to recover balance: -5" error. - There was no rebalancing
running when during the crash.

* btrfs-find-root: https://pastebin.com/qkjnSUF7 - It bothers me that I
don't see any "good generations" as described here:
https://btrfs.wiki.kernel.org/index.php/Restore

* "btrfs rescue" - it starts, then goes to "looping on XYZ" then stops

* "btrfs rescue super-recover -v" gives:

All Devices:
	Device: id =3D 1, name =3D /dev/vg00/...
Before Recovering:
	[All good supers]:
		device name =3D /dev/vg00/...
		superblock bytenr =3D 65536

		device name =3D /dev/vg00/...
		superblock bytenr =3D 67108864

		device name =3D /dev/vg00/...
		superblock bytenr =3D 274877906944

	[All bad supers]:

All supers are valid, no need to recover


* Unfortunatly I did a "btrfs rescue zero-log" at some point :( - As it
turns out that might have been a bad idea


* Also, a "btrfs  check --init-extent-tree" - https://pastebin.com/jATDCF=
Zy

The volume contained qcow2 images for VMs. I need only one of those,
since one piece of important software decided to not do backups :(

Any help is highly appreciated.

Many thanks,
udo.


--KXmu6ryAPPedPKnpyfisiCTlLSiIvk6Ml--

--cDUZUaVmfUnJD2aScP5O5OW8AkeCqnM5h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEKvHlGi1zjN9ykHKEyMU4ySCz1VEFAltGJB8ACgkQyMU4ySCz
1VGFBQgAgMHkTiSwl3QqaDrnOrSf2yGUfFKRc1F7MTeXDFQ09hFnsH7nL+FnVChz
S3vzQK7ljqkOwL4l5AQFsGMamYY3j/3JEusUgRwaEsbjHjuSRTExhIuYn+5yY5ta
TRKCC1MJg6oDb6pkdVM51Sr3likMo/Ex7PnY1V98ObKd6gra1sKtnBLc5AGrIosf
rQs+OwU08G39JGG5XuEVOAG7XtkiGa9d+kUdt8e0OldD251VAu8dZdVid791TpFY
IQgRY50FnejDalS3gTyBTS0+WR7MWfI7JLvxqWn4b7ELWpeLjNIqluLA3GG9vTm3
uO4mLnF/3+Q1Wb+ZI9YQZJ2yspib1A==
=nnwQ
-----END PGP SIGNATURE-----

--cDUZUaVmfUnJD2aScP5O5OW8AkeCqnM5h--
