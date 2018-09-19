Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58811 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbeISTdB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 15:33:01 -0400
Subject: Re: cannot mount btrfs as root
To: "Zbigniew 'zibi' Jarosik" <zibi@nora.pl>, linux-btrfs@vger.kernel.org
References: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <53806b04-c239-cb23-1d8a-e84d7453950a@gmx.com>
Date: Wed, 19 Sep 2018 21:54:45 +0800
MIME-Version: 1.0
In-Reply-To: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UMnoOpkyPVpa5fKiIkEIpF0pyADCnAFWn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UMnoOpkyPVpa5fKiIkEIpF0pyADCnAFWn
Content-Type: multipart/mixed; boundary="SEopurdSOTQxvBnDHIFuPqm11RX1VNSGk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zbigniew 'zibi' Jarosik <zibi@nora.pl>, linux-btrfs@vger.kernel.org
Message-ID: <53806b04-c239-cb23-1d8a-e84d7453950a@gmx.com>
Subject: Re: cannot mount btrfs as root
References: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>
In-Reply-To: <CAOc3t=v+ZTN7wZRSZO0afx5BVJYzrorD3HWoWkeJyUoUZ2KoTg@mail.gmail.com>

--SEopurdSOTQxvBnDHIFuPqm11RX1VNSGk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/19 =E4=B8=8B=E5=8D=889:19, Zbigniew 'zibi' Jarosik wrote:
> Hi!
>=20
> I can't mount my RAID1 set as rootfs, but as normal mount to running
> system works normally. It was working normal, than some day it died.
>=20
> When booted to rootfs as
> root=3DUUID=3D98c94774-d93a-400e-a275-58cc3ac2a58a rootflags=3Dsubvol=3D=
@root
> i got:
>=20
> BTRFS error (device bcache2): devid 5 uuid
> dd09f810-717e-4f2f-97ab-26469d5adca5 is missing
> BTRFS error (device bcache2): failed to read the system array: -2

One of your device is missing, thus read_one_dev() refuse to continue
and return -ENOENT (-2).

Does the iniramfs do a "btrfs dev scan" to make populate btrfs devices
lists?

> BTRFS error (device bcache2): open_ctree failed
> mount: mounting /dev/bcache2 on /root failed: Invalid argument
>=20
> and (initramfs) prompt.
>=20
> Bcache devices are registered and populated in /dev.
>=20
> When I boot exacly the same kernel and initrd, but rootfs is on
> pendrive ( root=3D/dev/sda2 ) than mount dataset to subdir ( mount UUID=
=3D
> 98c94774-d93a-400e-a275-58cc3ac2a58a  /data ) - works flawlessly.
>=20
> Thanks in advance for any ideas.
>=20
> Some system info:
>=20
> /dev/sdb1: UUID=3D"780cc211-2408-4594-83df-379ee23d6ed8" TYPE=3D"bcache=
"
> PARTLABEL=3D"Linux filesystem"
> PARTUUID=3D"ef83f1b4-b55c-4deb-8037-69ff16909222"
> /dev/sdc1: UUID=3D"80a1b115-8a1f-41f7-b65b-dd4fdaf400f1" TYPE=3D"bcache=
"
> PARTLABEL=3D"Linux filesystem"
> PARTUUID=3D"1f920d16-af68-440b-891c-5ff61c3057ca"
> /dev/sdd1: UUID=3D"a40e80dc-f7e2-4a9c-9bfe-81489a1261ca" TYPE=3D"bcache=
"
> PARTLABEL=3D"Linux filesystem"
> PARTUUID=3D"4b68c314-f029-402a-b332-b0b9109ad51d"
> /dev/bcache0: UUID=3D"98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB=3D"dd09f810-717e-4f2f-97ab-26469d5adca5" TYPE=3D"btrfs"

The devices is indeed here, so it's not a missing device, but looks like
at mount time, btrfs hasn't fully scanned all devices.

You could refer to your distribution manual to figure out how to make
btrfs scan work before mounting the rootfs.

Thanks,
Qu

> /dev/bcache1: UUID=3D"98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB=3D"8469962d-f9ee-4b5f-b4d5-4a62190c0d8f" TYPE=3D"btrfs"
> /dev/bcache2: UUID=3D"98c94774-d93a-400e-a275-58cc3ac2a58a"
> UUID_SUB=3D"516f2bd1-3fcc-42fd-87ad-5d5fa2f84b5f" TYPE=3D"btrfs"
>=20
> Linux hp1 4.17.11-ldkb #2 SMP Thu Aug 2 09:24:58 CEST 2018 x86_64 GNU/L=
inux
> btrfs-progs v4.7.3
> Label: none  uuid: 98c94774-d93a-400e-a275-58cc3ac2a58a
>         Total devices 3 FS bytes used 3.21TiB
>         devid    3 size 2.73TiB used 2.07TiB path /dev/bcache2
>         devid    4 size 2.73TiB used 2.18TiB path /dev/bcache1
>         devid    5 size 2.73TiB used 2.18TiB path /dev/bcache0
> Data, RAID1: total=3D3.20TiB, used=3D3.20TiB
> System, RAID1: total=3D32.00MiB, used=3D480.00KiB
> Metadata, RAID1: total=3D12.00GiB, used=3D10.81GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
>=20


--SEopurdSOTQxvBnDHIFuPqm11RX1VNSGk--

--UMnoOpkyPVpa5fKiIkEIpF0pyADCnAFWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluiVSUACgkQwj2R86El
/qggqgf+J7b4xiDPvQ+WM4rM0vX9GA4aVDCSUsQrfq7AUdmLWpK3ujveTkcDk+9L
8kVvwxN3ZpLdNg3nYCZuRgVbI8uRoML1aeSXc59zNsteBYlRCm7wK9rNOUMYXSYB
EC8M+FfRLl5hKQB4kqU9Hwbjef/oDt/f3sSx2FZpujREAXBi9Uv+qApD1x7MwMTh
M0Mq1yEAK10H/uT+/oiIfiDLkYPZSxw1VUivZ+dHdHyQfRPTfvZv4CIKWlYuKWg+
fZ8zz1xhCYeCD1S3Io48jTteHxQMQ2Bqh8k9nOm0kzkSqHyHUI8NxcMYG15w27Ns
0JkAdbgKgxzXaqvVF9qiIaFDmyVe+A==
=T4Sq
-----END PGP SIGNATURE-----

--UMnoOpkyPVpa5fKiIkEIpF0pyADCnAFWn--
