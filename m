Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753755AbeDWBYB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Apr 2018 21:24:01 -0400
Subject: Re: 4.17-rc1 FS went read-only during balance
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
References: <20180421175548.4b07dffc@demfloro.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
Date: Mon, 23 Apr 2018 09:23:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180421175548.4b07dffc@demfloro.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EV5fFjSdO5hCA8ZdNsRdfssXDGL9KnMXH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EV5fFjSdO5hCA8ZdNsRdfssXDGL9KnMXH
Content-Type: multipart/mixed; boundary="v3Uz7wgKZmbo2j7HQLuas2G2x1OcXnXNp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
Message-ID: <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
Subject: Re: 4.17-rc1 FS went read-only during balance
References: <20180421175548.4b07dffc@demfloro.ru>
In-Reply-To: <20180421175548.4b07dffc@demfloro.ru>

--v3Uz7wgKZmbo2j7HQLuas2G2x1OcXnXNp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8821=E6=97=A5 22:55, Dmitrii Tcvetkov wrote:
> TL;DR It seems as regression in 4.17, but I managed to find a
> workaround to make filesystem rw mountable again.
>=20
> Kernel built from tag v4.17-rc1
> btrfs-progs 4.16
>=20
> Tonight two my machines (PC (ECC RAM) and laptop(non-ECC RAM)) were
> doing usual weekly balance with this command via cron:
> btrfs balance start -musage=3D50 -dusage=3D50 <mountpoint>
> Both machines run same kernel version.=20
>=20
> On PC that caused root and "data" filesystems to go readonly. Root is o=
n
> an SSD with data single and metadata DUP, "data" filesystem is on 2 HDD=
s
> with RAID1 for data and metadata.
>=20
> On laptop only /home went ro, it's on NVMe SSD with data single and
> metadata DUP.=20
>=20
> Btrfs check of PC rootfs was without any errors in both modes, I did
> them once each before reboot on readonly filesystem with --force flag
> and then from live usb. Same output without any errors.
>=20
> After reboot kernel refused rw mount rootfs with the same error as
> during cron balance, ro mount was accepted, error during rw mount:
> BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=3D-117

117 means EUCLEAN, which could be caused by the newly introduced
first_key and level check.

Please apply this hotfix to fix it.
btrfs: Only check first key for committed tree blocks
(Which is included in latest pull request)

Also, please consider enable CONFIG_BTRFS_DEBUG to provide extra debug in=
fo.

Thanks,
Qu

> unknown BTRFS info (device dm-17): forced readonly BTRFS info (device
> dm-17): delayed_refs has NO entry BTRFS error (device dm-17): cleaner
> transaction attach returned -3
>=20
> mount rw with skip_balance parameter didn't help to mount.
>=20
> After that I mounted rw the rootfs with 4.16.2 kernel, mount was
> successful and kernel finished balance. After that the filesystem is
> mountable rw by 4.17-rc1 kernel without errors, btrfs check is clean
> too.
>=20
> Data filesystem behaves the same, rw mount on 4.17-rc1 kernel yields:
> [ 2321.370113] BTRFS: error (device dm-17) in merge_reloc_roots:2465:
> errno=3D-117 unknown [ 2321.370119] BTRFS warning (device dm-17): faile=
d
> to recover relocation: -30 [ 2321.370137] BTRFS info (device dm-17):
> delayed_refs has NO entry [ 2321.370155] BTRFS error (device dm-17):
> cleaner transaction attach returned -30 [ 2321.414219] BTRFS error
> (device dm-17): open_ctree failed
>=20
> Rw mount on 4.16.2 goes ok and after balance finishes the filesystem is=

> mountable by 4.17-rc1 again. I saved /home filesystem from laptop in
> unmountable by 4.17-rc1 state and can test patches and/or create
> btrfs-image if it's needed.
>=20


--v3Uz7wgKZmbo2j7HQLuas2G2x1OcXnXNp--

--EV5fFjSdO5hCA8ZdNsRdfssXDGL9KnMXH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrdNakACgkQwj2R86El
/qjPZAf/bP1FxEWWHwZl2vLGqTuUOPf0qJJGF24IoOfnFOc03WYS3By2WWjpSl9Y
s+xe7gvPO7mMyJb2WSk79aZtMP9HJ5W+FEHb/j90Mm/TrE13UF3MYC7ZuLJsl2hF
3mKdhDFoeR2dpx95mAIrozM64Qh90lsPNS83bAxyakUz1RJd0AC8HPNL6An+E4fD
QW18xwnKdEii8m/5xRAAF+zYdvjq5mb3/ECux+JIGrQpR/jgbWUIsjmelyoFS7LO
oUcMsJsYOFeRYFhggNTYSLdVKlb+sbHpyfVkOIgQQcnSk5VRXdQwr8ykVikxbS5F
OuQTTI85N0POw/3fj0kR1LSG7xXpgg==
=Udgc
-----END PGP SIGNATURE-----

--EV5fFjSdO5hCA8ZdNsRdfssXDGL9KnMXH--
