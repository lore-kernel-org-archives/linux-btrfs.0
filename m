Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49182 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdKXBIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 20:08:10 -0500
Subject: Re: Issue in recovering and using the mirror superblock
To: koller@caramail.com, linux-btrfs@vger.kernel.org
References: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d5eca1f6-4f15-52d0-6bd7-56d90b7ded73@gmx.com>
Date: Fri, 24 Nov 2017 09:08:05 +0800
MIME-Version: 1.0
In-Reply-To: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UCPAaOTx6qlhKAa65BPfh5KrfxUhuQD6t"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UCPAaOTx6qlhKAa65BPfh5KrfxUhuQD6t
Content-Type: multipart/mixed; boundary="MUhDNFBPB3qSpl8sRPwOSre6NLA1v6Iws";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: koller@caramail.com, linux-btrfs@vger.kernel.org
Message-ID: <d5eca1f6-4f15-52d0-6bd7-56d90b7ded73@gmx.com>
Subject: Re: Issue in recovering and using the mirror superblock
References: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
In-Reply-To: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>

--MUhDNFBPB3qSpl8sRPwOSre6NLA1v6Iws
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 00:31, koller@caramail.com wrote:
> Hi,
>=20
> I am trying to recover from a mistake I made by overwriting the first G=
Bs of my Btrfs /home partition with a non-Btrfs filesystem.

Well, in most case, the chance of recovery is already very low.

The possibility mostly relies on your device extents layout.
If all new data write is overwriting device extents belong to data, then
you will have a high chance to recover.

However this always depends on the fs you're using.

AFAIK, normal traditional fs, like ext*/xfs will build all their block
groups/AGs at mkfs time, and they are not just writing data in the first
several GB, but a lot of small write across the whole disk, which makes
recovery even harder.

>=20
> I have already made a .dd image of the partition, and I am using it to =
try and find the mirror superblock, in particular the one at 256 GB.
>=20
> When I run the "btrfs restore" command I get an error message, maybe be=
cause the mirror superblock -- I am not sure about the reason.
>=20
> Using the dummy run option, from the command line I do
>=20
> btrfs restore -D -u 2 /run/media/user01/SamsungHD/sda2.dd /run/media/us=
er01/ToshibaHD/RecoveredData
>=20
> The message is get is:
>=20
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=3D20971520, have=3D709

Unfortunately, your chunk tree get corrupted, which is the most
important tree for btrfs.
It manages the mapping between btrfs logical address space to device offs=
et.

Without this tree, nothing can really be recovered.

If you're really sure about the overwrite range, you could use
btrfs-dump-super to verify your system chunk mapping (where chunk tree is=
).

I'd say it's in the overwrite range.

> ERROR: cannot read chunk root
> Could not open root, trying backup super
>=20
> With the -u 1 option (instead of -u 2) I get:
>=20
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=3D20971520, have=3D709
> ERROR: cannot read chunk root
> Could not open root, trying backup super
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
> checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
> bytenr mismatch, want=3D20971520, have=3D709
> ERROR: cannot read chunk root
> Could not open root, trying backup super
>=20
> I have reason to believe that the mirror superblock at 256 GB is intact=
 (I am assuming that only the initial sectors of the partition were overw=
ritten), so I do not understand why it is not being recovered. BTW, the s=
ize of the partition is above 300 GBs, so there is supposed to be a mirro=
r superblock at 256 GB.

Btrfs is complex, so complex that the bootstrap depends on several
trees, not only superblock.

To be more specific, btrfs bootstraps involves:

superblock (system chunk array) -> system chunk mapping -> chunk tree ->
metadata chunk mapping -> root tree -> fs tree.

Any corruption (without valid copy) in the chain will cause the mount
failure.
And in your case, system chunk mapping is good (since it's in
superblock) but your chunk tree is corrupted.

So no chance here.

Thanks,
Qu

>=20
> Can anyone help me?
>=20
> --------
>=20
> Here is the btrfs info:
>=20
> uname -a
> Linux adfa-workstation 4.9.63-1-MANJARO #1 SMP PREEMPT Sat Nov 18 14:12=
:41 UTC 2017 x86_64 GNU/Linux
>=20
> btrfs --version
> btrfs-progs v4.13
>=20
> Thanks
>=20
> Terry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--MUhDNFBPB3qSpl8sRPwOSre6NLA1v6Iws--

--UCPAaOTx6qlhKAa65BPfh5KrfxUhuQD6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloXcPUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjBOAf/VQv93tZrisDrAcB0bCjyzTzT
v7qzQdLQMOcnxneNrrUnfHcOfBytvSl/xHoFuMOUig9Om8TDH6k/jZgnw4bBdD/m
bYrVOD6jZYFdem3277XQ5oDHoFNEqe9y7bUvH4ZPDPhquOcxyggX4zDuq5NHYdxV
SpRRtCr8BKujb9Lu5bFf+d6WIVYjFsv6WB/fwy+aBsTAe/duiPzjTlO4CODA5KRA
FLVa/3bilVJD6JEkDa8OSIRFQaHZP+wlHijWJn60DYRnOLFJoFRfEaw2m1xpKb0V
0+5iXOA1Qj5P7hqWHtyvYV/DEH1bVLKrlEYZLN5hCYnhuAK+7Oi3cQ1BYri4Jg==
=Oa4W
-----END PGP SIGNATURE-----

--UCPAaOTx6qlhKAa65BPfh5KrfxUhuQD6t--
