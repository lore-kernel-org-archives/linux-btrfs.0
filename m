Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.maketank.net ([144.76.88.81]:39810 "EHLO mx02.maketank.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbeGPIsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 04:48:42 -0400
Received: from localhost (milter01.int.lan [10.200.0.47])
        by mx02.maketank.net (Postfix) with ESMTP id D4056FF499
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 10:16:18 +0200 (CEST)
Received: from mx02.maketank.net ([10.200.0.43])
        by localhost (milter01.int.lan [10.200.0.47]) (amavisd-new, port 10022)
        with ESMTP id vvlEziQMAaEz for <linux-btrfs@vger.kernel.org>;
        Mon, 16 Jul 2018 10:16:02 +0200 (CEST)
Received: from [192.168.2.126] (p2E505F30.dip0.t-ipconnect.de [46.80.95.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx02.maketank.net (Postfix) with ESMTPSA id 91AF9FF085
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 10:16:01 +0200 (CEST)
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
From: Udo Waechter <root@zoide.net>
To: linux-btrfs@vger.kernel.org
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
Message-ID: <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
Date: Mon, 16 Jul 2018 10:15:51 +0200
MIME-Version: 1.0
In-Reply-To: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="N10dRbht97XzSdR9gYL4Qcepg70wvPWSD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N10dRbht97XzSdR9gYL4Qcepg70wvPWSD
Content-Type: multipart/mixed; boundary="IH81TPyrLdbboMOVA9pshwosKLwwOBxLd";
 protected-headers="v1"
From: Udo Waechter <root@zoide.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <d45fac2d-fe1b-07d6-4d12-187e55a58d87@zoide.net>
Subject: Re: Corrupted FS with "open_ctree failed" and "failed to recover
 balance: -5"
References: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>
In-Reply-To: <db79af86-4346-84c2-940d-b988e91c2652@zoide.net>

--IH81TPyrLdbboMOVA9pshwosKLwwOBxLd
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hello,

noone any ideas? Do you need more information?

Cheers,
udo.

On 11/07/18 17:37, Udo Waechter wrote:
> Hello everyone,
>=20
> I have a corrupted filesystem which I can't seem to recover.
>=20
> The machine is:
> Debian Linux, kernel 4.9 and btrfs-progs v4.13.3
>=20
> I have a HDD RAID5 with LVM and the volume in question is a LVM volume.=

> On top of that I had a RAID1 SSD cache with lvm-cache.
>=20
> Yesterday both! SSDs died within minutes. This lead to the corruped
> filesystem that I have now.
>=20
> I hope I followed the procedure correctly.
>=20
> What I tried so far:
> * "mount -o usebackuproot,ro " and "nospace_cache" "clear_cache" and al=
l
> permutations of these mount options
>=20
> I'm getting:
>=20
> [96926.830400] BTRFS info (device dm-2): trying to use backup root at
> mount time
> [96926.830406] BTRFS info (device dm-2): disk space caching is enabled
> [96926.927978] BTRFS error (device dm-2): parent transid verify failed
> on 321269628928 wanted 3276017 found 3275985
> [96926.938619] BTRFS error (device dm-2): parent transid verify failed
> on 321269628928 wanted 3276017 found 3275985
> [96926.940705] BTRFS error (device dm-2): failed to recover balance: -5=

> [96926.985801] BTRFS error (device dm-2): open_ctree failed
>=20
> The weird thing is that I can't really find information about the
> "failed to recover balance: -5" error. - There was no rebalancing
> running when during the crash.
>=20
> * btrfs-find-root: https://pastebin.com/qkjnSUF7 - It bothers me that I=

> don't see any "good generations" as described here:
> https://btrfs.wiki.kernel.org/index.php/Restore
>=20
> * "btrfs rescue" - it starts, then goes to "looping on XYZ" then stops
>=20
> * "btrfs rescue super-recover -v" gives:
>=20
> All Devices:
> 	Device: id =3D 1, name =3D /dev/vg00/...
> Before Recovering:
> 	[All good supers]:
> 		device name =3D /dev/vg00/...
> 		superblock bytenr =3D 65536
>=20
> 		device name =3D /dev/vg00/...
> 		superblock bytenr =3D 67108864
>=20
> 		device name =3D /dev/vg00/...
> 		superblock bytenr =3D 274877906944
>=20
> 	[All bad supers]:
>=20
> All supers are valid, no need to recover
>=20
>=20
> * Unfortunatly I did a "btrfs rescue zero-log" at some point :( - As it=

> turns out that might have been a bad idea
>=20
>=20
> * Also, a "btrfs  check --init-extent-tree" - https://pastebin.com/jATD=
CFZy
>=20
> The volume contained qcow2 images for VMs. I need only one of those,
> since one piece of important software decided to not do backups :(
>=20
> Any help is highly appreciated.
>=20
> Many thanks,
> udo.
>=20


--IH81TPyrLdbboMOVA9pshwosKLwwOBxLd--

--N10dRbht97XzSdR9gYL4Qcepg70wvPWSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEKvHlGi1zjN9ykHKEyMU4ySCz1VEFAltMVDoACgkQyMU4ySCz
1VHF3AgAssc7iQ1QDpPmisJqDb8STo3byjSsnHXpIUnhh59KF2ErA2ICNZCZ77Yg
3LkjcQXdurUmxqN5NANrKXT1ThX92Rkr5KRCopT9OkoMGfIbjm9Ba3b4fzSzh+wc
QO5NRzl6Qvkt/YB9xZ5dD4T6SZuoCjBRKWaJDAByx3VxEkhR5/N590S5nYAFUDUw
yAN2+na4oqRLLJvwroy63uZYs15zej+utpVlQCOBHAkdCM9Mz3jvyIUyx5x8YiDR
FonGQJEV/n6/juzFzPXf3xpHyXU7fRhEVsBSq5PcaYrpwKZj1k2/fWk6Zu9sVHWZ
S6DBx2rOlSkdb70OYXlGvClKxl/PsQ==
=ZWMA
-----END PGP SIGNATURE-----

--N10dRbht97XzSdR9gYL4Qcepg70wvPWSD--
