Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:47433 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbeIDEuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Sep 2018 00:50:18 -0400
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: Etienne Champetier <champetier.etienne@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
Date: Tue, 4 Sep 2018 08:27:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bGtZ80arAbmVhxBsIc9EZnHZtPJstdPFD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bGtZ80arAbmVhxBsIc9EZnHZtPJstdPFD
Content-Type: multipart/mixed; boundary="9EJCeygPTYyIPvrfpt4HpdbZ4OFVZUyyB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Etienne Champetier <champetier.etienne@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
In-Reply-To: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>

--9EJCeygPTYyIPvrfpt4HpdbZ4OFVZUyyB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/3 =E4=B8=8B=E5=8D=8810:18, Etienne Champetier wrote:
> Hello btfrs hackers,
>=20
> I have a computer acting as backup server with BTRFS RAID1, and I
> would like to know the different options to rebuild this RAID
> (I saw this thread
> https://www.spinics.net/lists/linux-btrfs/msg68679.html but there was
> no raid 1)
>=20
> # uname -a
> Linux servmaison 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:00
> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>=20
> # btrfs --version
> btrfs-progs v4.4
>=20
> # dmesg
> ...
> [ 1955.581972] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=3D6020235362304,root=3D1, slot=3D63
> [ 1955.582299] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=3D6020235362304,root=3D1, slot=3D63

Please provide the following dump:

# btrfs inspect dump-tree -t root /dev/sda2
# btrfs inspect dump-tree -b 6020235362304 /dev/sda2

The first one is to inspect current root tree to find any corruption.
The second one is to show that corrupted tree block, and compare with
first output to make sure if it's already in the committed tree.

And the critical error message already shows what's causing the bug,
your root tree is corrupted, some keys are not in correct order.

All the following errors could be caused by this problem.

[snip]
>=20
> # btrfs fi show /
> Label: none  uuid: 4917db5e-fc20-4369-9556-83082a32d4cd
>     Total devices 2 FS bytes used 2.25TiB
>     devid    1 size 3.64TiB used 2.34TiB path /dev/sda2
>     devid    2 size 3.64TiB used 2.34TiB path /dev/sdb2
>=20
> # btrfs device stats /
> [/dev/sda2].write_io_errs   0
> [/dev/sda2].read_io_errs    0
> [/dev/sda2].flush_io_errs   0
> [/dev/sda2].corruption_errs 0
> [/dev/sda2].generation_errs 0
> [/dev/sdb2].write_io_errs   0
> [/dev/sdb2].read_io_errs    0
> [/dev/sdb2].flush_io_errs   0
> [/dev/sdb2].corruption_errs 0
> [/dev/sdb2].generation_errs 0
>=20
> device stats report no errors :(
>=20
> # btrfs fi df /
> Data, RAID1: total=3D2.32TiB, used=3D2.23TiB
> System, RAID1: total=3D96.00MiB, used=3D368.00KiB
> Metadata, RAID1: total=3D22.00GiB, used=3D19.12GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> # btrfs scrub status /
> scrub status for 4917db5e-fc20-4369-9556-83082a32d4cd
>     scrub started at Mon Sep  3 05:32:52 2018, interrupted after
> 00:27:35, not running
>     total bytes scrubbed: 514.05GiB with 0 errors
>=20
> I've already tried 2 times to run btrfs scrub (after reboot), but it
> stops before the end, with the previous dmesg error
>=20
> My question is what is the safest way to rebuild this BTRFS RAID1?

It depends on the inspect dump-tree output.

> I haven't tried "btrfs check --repair" yet

We need "btrfs check --readonly" output to verify if the bad key order
is the only problem.

If it's the only problem, "btrfs check --repair" indeed could fix it.

Thanks,
Qu

> (I can boot on a more up to date Linux live if it helps)
>=20
> Thanks
> Etienne
>=20


--9EJCeygPTYyIPvrfpt4HpdbZ4OFVZUyyB--

--bGtZ80arAbmVhxBsIc9EZnHZtPJstdPFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluN0XcACgkQwj2R86El
/qg9DAf+OnNUOpRJg5QiodHw75vEP5PvAaea8t3Y17TFGImwkN4FI1ZEnwA/J0bd
oDUIc2sLIR74S5QFD51p1pp9aGbXur5OZp2EZLn/33de//VzcG+SDf8v7ttycOZ8
fTOyT2yrDg/Y+kEfYWDjJVjR41FI82AP03n95FujrBz/K7dXEM1bmP/JzcQaOF2k
g8aX99d4K+dAMZy6PufkZjbIAXT1orCLhmwEac9POqW6ICTlUO6IaLZDBlie3YOr
bdErRcHCBxE7t2ISpczFi+lhWTU/Kmlv5QiZxoYO8XSdkCGKytBmFgWwz8L3O/ZM
CdbQCoWAAm1FfIHICBSJ7ZXApmDm6w==
=Flvh
-----END PGP SIGNATURE-----

--bGtZ80arAbmVhxBsIc9EZnHZtPJstdPFD--
