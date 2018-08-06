Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52837 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbeHFIef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:34:35 -0400
Subject: Re: BUG: scheduling while atomic
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
 <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
 <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
Date: Mon, 6 Aug 2018 14:26:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TiwfZePhFCozHxC3RdAWiJOPR20kWUeHK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TiwfZePhFCozHxC3RdAWiJOPR20kWUeHK
Content-Type: multipart/mixed; boundary="XbSRfH8LIjGHMrHyj8L9HdoQqKhk4u6ER";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
Subject: Re: BUG: scheduling while atomic
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
 <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
 <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
In-Reply-To: <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>

--XbSRfH8LIjGHMrHyj8L9HdoQqKhk4u6ER
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8806=E6=97=A5 14:07, James Courtier-Dutton wrote=
:
>=20
>=20
> On Mon, 6 Aug 2018, 01:48 Qu Wenruo, <quwenruo.btrfs@gmx.com
> <mailto:quwenruo.btrfs@gmx.com>> wrote:
>=20
>=20
>=20
>     On 2018=E5=B9=B408=E6=9C=8805=E6=97=A5 22:09, James Courtier-Dutton=
 wrote:
>     > I am seeing a server halt and require a manual restart that I thi=
nk
>     > might be related to btrfs.
>     > I attach the kernel log from it, in the hope that someone will
>     > understand it better than me.
>     > Any clues?
>     >
>     > https://paste.fedoraproject.org/paste/xSblK1RKANiwhKHQj31Cdw
>     <https://paste.fedoraproject.org/paste/xSblK1RKANiwhKHQj31Cdw>
>=20
>     When checking the dmesg, we should check for the first backtrace ot=
her
>     than later backtraces, which are normally caused by the first probl=
em.
>=20
>     In your case, it's general protection happens at timerqueue_add(), =
which
>     is unrelated to btrfs at all.
>=20
>=20
> I forgot to mention. This log is via netconsole as nothing is seen in
> the local logs. As such it seems to jumble up the logs a bit.
> The first bad bit happens here:

Sorry, my fault.

Then it makes sense why a lot of messages looks interrupted.

>=20
> WARNING: CPU: 3 PID: 803 at
> /build/linux-hwe-SYRsgd/linux-hwe-4.15.0/fs/btrfs/extent_map.c:77
> free_extent_map+0x78/0x90 [btrfs]

Then it makes sense, as it's a WARN_ON() line, showing one extent map is
still used.

If it get freed, it will definitely cause some rbtree corruption.

>=20
> But the associated stack trace is not the immediately one below it. The=

> associated stack trace is:
> Jul 30 03:48:20 mum [453835.199561] RIP: 0010:frde_extent_map+0x78/0x90=

> [btrfs]
> Jul 30 03:48:20 mum [453835.199564] RSP: 0000:ffffb548417cb5d0 EFLAGS:
> 00010296
> Jul 30 03:48:20 mum [453835.199568] RAX: 0000000000000001 RBX:
> fffffffffffffffe RCX: ffff960c0aa20000
> Jul 30 03:48:20 mum [453835.199570] RDX: fffffffffffff000 RSI:
> 00000912e6968000 RDI: ffff960c0aa20000
> Jul 30 03:48:20 mum [453835.199572] RBP: ffffb548417cb5d8 R08:
> 0000000000000000 R09: 0000000000000000
> Jul 30 03:48:20 mum [453835.199572] R10: ffff960b584a2690 R11:
> 0000000000000000 R12: 0000000000000000
> Jul 30 03:48:20 mum [453835.199575] R13: 0000000000000000 R14:
> 00000912e6968000 R15: 0000000000001000
> Jul 30 03:48:20 mum [453835.199578] FS:=C2=A0 00007f1b4b92f700(0000)
> GS:ffff960c1fd80000(0000) knlGS:0000000000000000
> Jul 30 03:48:20 mum [453835.199579] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR=
0:
> 0000000080050033
> Jul 30 03:48:20 mum [453835.199582] CR2: 00007f1b4c96489f CR3:
> 0000000213d42000 CR4: 00000000000006e0
> Jul 30 03:48:20 mum [453835.199584] Call Trace:
> Jul 30 03:48:20 mum [453835.199607]=C2=A0 __do_readpage+0x2bb/0x850 [bt=
rfs]

It's should be the only free_extent_map() call in __do_readpage() functio=
n.
However a first glance into this function shows nothing wrong, nor new
modification in this function.
(Maybe it's the get_extent() hook?)

Is there any reproducer? Or special workload?

And, have you tried "btrfs check --readonly <device>"? If there is any
error it would help a lot to locate the problem.

Thanks,
Qu

> Jul 30 03:48:20 mum [453835.199625]=C2=A0 ? free_root_pointers+0x70/0x7=
0 [btrfs]
> Jul 30 03:48:20 mum [453835.199645]=C2=A0 __extent_read_full_page+0xe1/=
0xf0
> [btrfs]
> Jul 30 03:48:20 mum [453835.199663]=C2=A0 ? free_root_pointers+0x70/0x7=
0 [btrfs]
> Jul 30 03:48:20 mum [453835.199683]=C2=A0
> read_extent_buffer_pages+0x291/0x2c0 [btrfs]
> Jul 30 03:48:20 mum [453835.199701]=C2=A0 ? free_root_pointers+0x70/0x7=
0 [btrfs]
> Jul 30 03:48:20 mum [453835.199718]=C2=A0
> btree_read_extent_buffer_pages+0x9d/0x100 [btrfs]
> Jul 30 03:48:20 mum [453835.199736]=C2=A0 read_tree_block+0x32/0x50 [bt=
rfs]
> Jul 30 03:48:20 mum [453835.199752]=C2=A0
> read_block_for_search.isra.31+0x135/0x2f0 [btrfs]
> Jul 30 03:48:20 mum [453835.199767]=C2=A0 btrfs_search_slot+0x3a1/0x9d0=
 [btrfs]
> Jul 30 03:48:20 mum [453835.199785]=C2=A0 btrfs_lookup_csum+0x52/0x150 =
[btrfs]
> Jul 30 03:48:20 mum [453835.199802]=C2=A0 __btrfs_lookup_bio_sums+0x315=
/0x6b0
> [btrfs]
> Jul 30 03:48:20 mum [453835.199820]=C2=A0 ? btrfs_bio_wq_end_io+0x28/0x=
70 [btrfs]
> Jul 30 03:48:20 mum [453835.199837]=C2=A0 btrfs_lookup_bio_sums+0x16/0x=
20 [btrfs]
> Jul 30 03:48:20 mum [453835.199856]=C2=A0 btrfs_submit_bio_hook+0xc3/0x=
180
> [btrfs]
> Jul 30 03:48:20 mum [453835.199877]=C2=A0 submit_one_bio+0x64/0x90 [btr=
fs]
> Jul 30 03:48:20 mum [453835.199897]=C2=A0 extent_readpages+0x181/0x280 =
[btrfs]
> Jul 30 03:48:20 mum [453835.199945]=C2=A0 __do_page_cache_readahead+0x1=
be/0x2c0
> Jul 30 03:48:20 mum [453835.199949]=C2=A0 filemap_fault+0x53e/0x750
> Jul 30 03:48:20 mum [453835.199952]=C2=A0 ? filemap_fault+0x53e/0x750
> Jul 30 03:48:20 mum [453835.199953]=C2=A0 ? filemap_map_pages+0x185/0x3=
f0
> Jul 30 03:48:20 mum [453835.199957]=C2=A0 __do_fault+0x24/0xf0
> Jul 30 03:48:20 mum [453835.199960]=C2=A0 __handle_mm_fault+0xd1b/0x11f=
0
> Jul 30 03:48:20 mum [453835.199963]=C2=A0 ? __check_object_size+0xfc/0x=
1a0
> Jul 30 03:48:20 mum [453835.199966]=C2=A0 handle_mm_fault+0xcc/0x1c0
> Jul 30 03:48:20 mum [453835.199971]=C2=A0 __do_page_fault+0x260/0x500
> Jul 30 03:48:20 mum [453835.199974]=C2=A0 do_page_fault+0x2e/0xf0
> Jul 30 03:48:20 mum [453835.199978]=C2=A0 ? page_fault+0x2f/0x50
> Jul 30 03:48:20 mum [453835.199981]=C2=A0 page_fatlt+0x45/0x50
> Jul 30 03:48:20 mum [453835.199984] RIP: 0033:0x7f1b4c96489f
> Jul 30 03:48:20 mum [453835.199986] RSP: 002b:00007f1b4b90e590 EFLAGS:
> 00010203
> Jul 30 03:48:20 mum [453835.199988] RAX: 00000000000000cf RBX:
> 0000000000000000 RCX: 00007f1b4df8151d
> Jul 30 03:48:20 mum [453835.199989] RDX: 00000000000000cf RSI:
> 00007f1b4b90eda0 RDI: 0000000000000000
> Jul 30 03:48:20 mum [453835.199991] RBP: 000000000096c2c0 R08:
> 0000000000000000 R09: 0000000004000001
> Jul 30 03:48:20 mum [453835.199994] R10: 0000000000000001 R11:
> 0000000000000000 R12: 00007f1b4b90eda0
> Jul 30 03:48:20 mum [453835.199997] R13: 0000000000001fa0 R14:
> 0000000000001f9f R15: 00007f1b4b90ee03
>=20
>=20
>=20


--XbSRfH8LIjGHMrHyj8L9HdoQqKhk4u6ER--

--TiwfZePhFCozHxC3RdAWiJOPR20kWUeHK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltn6jAACgkQwj2R86El
/qjMugf+OgyMGmD+8IroNhy87xvqNwF9HEbrCglm/EWbM54kkGKN8uAjLWVEdDfb
SFITDnhEUlbavG4gK6mSGeYsT9pKhVCjWZSaY/0Ma8bsBVOD/HIHRRNnBRkCUCiQ
Txh/RoEpyuxfR3t4k98Jx+Q85KJSqTJrpCrYgsL8A1o0MJKyqfq6FOLapogqEBex
EvKpu/izO23xgmzBLHgIV3IbshT6xcOoluh9x975089FPRLkJFet3H4VQeJ5Nxdp
zP9m1WqYjUB0myIXoeVRgKFK9n8rjqlUHC3w9UJEO2YnRLbQ2GZI2ERRK0MBKJUv
5Fcm08eiZBzm+v4FtHPQD4FPX/Y32Q==
=PdS3
-----END PGP SIGNATURE-----

--TiwfZePhFCozHxC3RdAWiJOPR20kWUeHK--
