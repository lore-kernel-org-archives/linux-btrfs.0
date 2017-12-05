Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52194 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753038AbdLEX52 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 18:57:28 -0500
Subject: Re: How exclusive in parent qgroup is computed?
To: Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <265a5a56-df01-ecad-8742-40749438c2e7@gmx.com>
Date: Wed, 6 Dec 2017 07:57:22 +0800
MIME-Version: 1.0
In-Reply-To: <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DIn7WogUdXS3x8ipBxrOuuPg8cAoKHTqe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DIn7WogUdXS3x8ipBxrOuuPg8cAoKHTqe
Content-Type: multipart/mixed; boundary="vmbDxogL9iLwMvsQDVivUsDQrnAw3hTxm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <265a5a56-df01-ecad-8742-40749438c2e7@gmx.com>
Subject: Re: How exclusive in parent qgroup is computed?
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>
In-Reply-To: <ceb66754-5369-eb32-0aa2-ec17cff18d3d@gmail.com>

--vmbDxogL9iLwMvsQDVivUsDQrnAw3hTxm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 02:47, Andrei Borzenkov wrote:
> 02.12.2017 03:27, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>> That's the difference between how sub show and quota works.
>>
>> For quota, it's per-root owner check.
>> Means even a file extent is shared between different inodes, if all
>> inodes are inside the same subvolume, it's counted as exclusive.
>> And if any of the file extent belongs to other subvolume, then it's
>> counted as shared.
>>
>=20
> Could you also explain how parent qgroup computes exclusive space? I.e.=

>=20
> 10:~ # mkfs -t btrfs -f /dev/sdb1
> btrfs-progs v4.13.3
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Performing full device TRIM /dev/sdb1 (1023.00MiB) ...
> Label:              (null)
> UUID:               b9b0643f-a248-4667-9e69-acf5baaef05b
> Node size:          16384
> Sector size:        4096
> Filesystem size:    1023.00MiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP              51.12MiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1  1023.00MiB  /dev/sdb1
>=20
> 10:~ # mount -t btrfs /dev/sdb1 /mnt
> 10:~ # cd /mnt
> 10:/mnt # btrfs quota enable .
> 10:/mnt # btrfs su cre sub1
> Create subvolume './sub1'
> 10:/mnt # dd if=3D/dev/urandom of=3Dsub1/file1 bs=3D1K count=3D1024
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00833739 s, 126 MB/s
> 10:/mnt # dd if=3D/dev/urandom of=3Dsub1/file2 bs=3D1K count=3D1024
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0179272 s, 58.5 MB/s
> 10:/mnt # btrfs subvolume snapshot sub1 sub2
> Create a snapshot of 'sub1' in './sub2'
> 10:/mnt # dd if=3D/dev/urandom of=3Dsub2/file2 bs=3D1K count=3D1024 con=
v=3Dnotrunc
> 1024+0 records in
> 1024+0 records out
> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0348762 s, 30.1 MB/s
> 10:/mnt # btrfs qgroup show --sync -p .
> qgroupid         rfer         excl parent
> --------         ----         ---- ------
> 0/5          16.00KiB     16.00KiB ---
> 0/256         2.02MiB      1.02MiB ---
> 0/257         2.02MiB      1.02MiB ---
>=20
> So far so good. This is expected, each subvolume has 1MiB shared and
> 1MiB exclusive.
>=20
> 10:/mnt # btrfs qgroup create 22/7 /mnt
> 10:/mnt # btrfs qgroup assign --rescan 0/256 22/7 /mnt
> Quota data changed, rescan scheduled
> 10:/mnt # btrfs quota rescan -s /mnt
> no rescan operation in progress
> 10:/mnt # btrfs qgroup assign --rescan 0/257 22/7 /mnt
> Quota data changed, rescan scheduled
> 10:/mnt # btrfs quota rescan -s /mnt
> no rescan operation in progress
> 10:/mnt # btrfs qgroup show --sync -p .
> qgroupid         rfer         excl parent
> --------         ----         ---- ------
> 0/5          16.00KiB     16.00KiB ---
> 0/256         2.02MiB      1.02MiB 22/7
> 0/257         2.02MiB      1.02MiB 22/7
> 22/7          3.03MiB      3.03MiB ---
> 10:/mnt #
>=20
> Oops. Total for 22/7 is correct (1MiB shared + 2 * 1MiB exclusive) but
> why all data is treated as exclusive here? It does not match your
> explanation ...


Why? The qgroup calculates it correctly without problem.

All extents in subvolume 256 and 257 belongs to qgroup 22/7.
the 1M shared data all belongs to qgroup 22/7 so it's counted as exclusiv=
e.

Not to mention the already exclusive extent from 0/256 and 0/257.


The name "exclusive" just means, all referencer(s) of one extent are all
in the qgroup.
So the explanation is still correct.


Please read btrfs-quota(8) 'SUBVOLUME QUOTA GROUPS' section for more
details.

Thanks,
Qu

>=20


--vmbDxogL9iLwMvsQDVivUsDQrnAw3hTxm--

--DIn7WogUdXS3x8ipBxrOuuPg8cAoKHTqe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlonMmIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qikQggAnf+dDU+bYD0Sz3jLPWLbkhuF
3dyEQQd3rh4ZV8SiDQA/RFOs0d8RwDkLMkSToaMrhUb//kepyUwqFf+7UMfV9Omw
kDvJ59mhRlpHMcjtw8Y7t8l7UoNi6Vg8lKVqqgFnvBQAFwr/2ru3z9njT3rmh7w1
GPp380zZ7ZTqt/FbdfU54RBmP50dKDWY8ceS5YJJHfHIxrGuHhy/XYyin2H6tgid
OFk4Tuk1GLSaWRPVFcnL5XwU/igMvxV/k9NlReRxadOWCSMo7QI9IzkgiCx7daKR
wFaD51IwrGfDTlqRqFJ2ocz6FqsceipCP1hYPv6MaoaZ3EYIQcjVHx2vsOerWA==
=yIte
-----END PGP SIGNATURE-----

--DIn7WogUdXS3x8ipBxrOuuPg8cAoKHTqe--
