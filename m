Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52827 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751081AbeEAI5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 04:57:24 -0400
Subject: Re: stack trace during scrub
To: Jan Fajerski <jfajerski@suse.com>, linux-btrfs@vger.kernel.org
References: <20180501084709.cfu2mqayubq36er7@jf_suse_laptop>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a9f36c66-0e35-1c01-f8ff-e65807a1aba5@gmx.com>
Date: Tue, 1 May 2018 16:57:08 +0800
MIME-Version: 1.0
In-Reply-To: <20180501084709.cfu2mqayubq36er7@jf_suse_laptop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aPCU2gTJb098Ofi2cYVolL64TcCFVxFbA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aPCU2gTJb098Ofi2cYVolL64TcCFVxFbA
Content-Type: multipart/mixed; boundary="jG7nVzcQJ7gkt8Ydkak2JuucviK9x0mGt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jan Fajerski <jfajerski@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a9f36c66-0e35-1c01-f8ff-e65807a1aba5@gmx.com>
Subject: Re: stack trace during scrub
References: <20180501084709.cfu2mqayubq36er7@jf_suse_laptop>
In-Reply-To: <20180501084709.cfu2mqayubq36er7@jf_suse_laptop>

--jG7nVzcQJ7gkt8Ydkak2JuucviK9x0mGt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8801=E6=97=A5 16:47, Jan Fajerski wrote:
> The system has multiple btrfs filesystems (RAID1 and single device).
> During last nights scrub the kernel logged the following stack trace
> about 1.5h into the scrub:
>=20
> May 01 03:29:27 apollo kernel: ------------[ cut here ]------------
> May 01 03:29:27 apollo kernel: WARNING: CPU: 1 PID: 24395 at
> /build/linux-3RM5ap/linux-4.14.13/fs/btrfs/ctree.h:1564 btrfs_update_de=
vi

This just means your device size is not aligned to sector size (4K).

Either use "btrfs rescue fix-device-size <device>" to do an offline fix,
Or just resize all devices by -4K and kernel will handle it pretty well.

Thanks,
Qu



> May 01 03:29:27 apollo kernel: Modules linked in: ufs qnx4 hfsplus hfs
> minix ntfs vfat msdos fat jfs xfs dm_mod ext4 crc16 mbcache jbd
> May 01 03:29:27 apollo kernel:=C2=A0 sg battery rc_core ipmi_msghandler=

> tpm_crb video shpchp button acpi_pad sunrpc coretemp ip_tables x_ta
> May 01 03:29:27 apollo kernel: CPU: 1 PID: 24395 Comm: btrfs Not tainte=
d
> 4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
> May 01 03:29:27 apollo kernel: Hardware name: To Be Filled By O.E.M. To=

> Be Filled By O.E.M./E3C224D4I-14S, BIOS P3.20 05/29/2015
> May 01 03:29:27 apollo kernel: task: ffff9330eacad1c0 task.stack:
> ffffa55acc6ec000
> May 01 03:29:27 apollo kernel: RIP: 0010:btrfs_update_device+0x1b2/0x1c=
0
> [btrfs]
> May 01 03:29:27 apollo kernel: RSP: 0018:ffffa55acc6efa18 EFLAGS: 00010=
206
> May 01 03:29:27 apollo kernel: RAX: 0000000000000fff RBX:
> ffff932f75fdc2a0 RCX: 000002baa1371e00
> May 01 03:29:27 apollo kernel: RDX: 0000000000001000 RSI:
> 0000000000003efa RDI: ffff93303754d7a8
> May 01 03:29:27 apollo kernel: RBP: ffff93310f0bc000 R08:
> ffffa55acc6ef9c8 R09: ffffa55acc6ef9d0
> May 01 03:29:27 apollo kernel: R10: 0000000000000003 R11:
> 0000000000003000 R12: 0000000000000000
> May 01 03:29:27 apollo kernel: R13: 0000000000003eda R14:
> ffff93303754d7a8 R15: 00000000fffffff4
> May 01 03:29:27 apollo kernel: FS:=C2=A0 00007f89d4c37700(0000)
> GS:ffff93311fd00000(0000) knlGS:0000000000000000
> May 01 03:29:27 apollo kernel: CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 01 03:29:27 apollo kernel: CR2: 00007f23b69ed0a0 CR3:
> 0000000190c76002 CR4: 00000000000606e0
> May 01 03:29:27 apollo kernel: Call Trace:
> May 01 03:29:27 apollo kernel:=C2=A0 btrfs_finish_chunk_alloc+0x122/0x4=
a0
> [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 ? btrfs_insert_item+0x7e/0xf0 [btr=
fs]
> May 01 03:29:27 apollo kernel:=C2=A0
> btrfs_create_pending_block_groups+0x144/0x250 [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 __btrfs_end_transaction+0x8e/0x2e0=
 [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 btrfs_inc_block_group_ro+0xcd/0x16=
0 [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 scrub_enumerate_chunks+0x1f7/0x620=
 [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 ? remove_wait_queue+0x60/0x60
> May 01 03:29:27 apollo kernel:=C2=A0 btrfs_scrub_dev+0x227/0x560 [btrfs=
]
> May 01 03:29:27 apollo kernel:=C2=A0 ? __check_object_size+0xb3/0x190
> May 01 03:29:27 apollo kernel:=C2=A0 btrfs_ioctl+0x134e/0x24e0 [btrfs]
> May 01 03:29:27 apollo kernel:=C2=A0 ? kmem_cache_alloc_node+0x13b/0x5a=
0
> May 01 03:29:27 apollo kernel:=C2=A0 ? do_vfs_ioctl+0x9f/0x600
> May 01 03:29:27 apollo kernel:=C2=A0 do_vfs_ioctl+0x9f/0x600
> May 01 03:29:27 apollo kernel:=C2=A0 ? get_task_io_context+0x43/0x80
> May 01 03:29:27 apollo kernel:=C2=A0 SyS_ioctl+0x74/0x80
> May 01 03:29:27 apollo kernel:=C2=A0 system_call_fast_compare_end+0xc/0=
x6f
> May 01 03:29:27 apollo kernel: RIP: 0033:0x7f89d6d1cdd7
> May 01 03:29:27 apollo kernel: RSP: 002b:00007f89d4c36d58 EFLAGS: 00000=
246
> May 01 03:29:27 apollo kernel: Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4=
c
> 89 ee e8 26 24 ff ff 4c 89 f7 e8 de f7 fc ff e9 de fe ff ff 4
> May 01 03:29:27 apollo kernel: ---[ end trace 502b81f0556393a0 ]---
> May 01 03:29:27 apollo kernel: ------------[ cut here ]------------
>=20
> Everything seems to function normally, the scrub finished seemingly fin=
e
> and no scrub errors where logged.
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--jG7nVzcQJ7gkt8Ydkak2JuucviK9x0mGt--

--aPCU2gTJb098Ofi2cYVolL64TcCFVxFbA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlroK+UACgkQwj2R86El
/qjg7AgAn1YKPAH1mfovxW9i5YDRpHl3MeXzJdW89+uGlUZ8ftLxJuYGsOabPHGj
N74MNiaw/kInMdzo6cdgQAUfvbwliYcCwoqBIYWu/SKx/lZdNac7gWCxlIkVxtk+
746RKudzVHRBVh/Z4lD5FSbDjS7GiHexIXNgMmNqJ/C81h1HZdos6K9JpeZtcz2J
EYkZ+zrXL6ul2pj9Orxqlr5jFK55rMkIP9gYqZc27fNsU9qWjz2sl+FMQRfbrhxF
jtZ6f6Ckq8H8cPJduQBVz4+Oq5NPdgwcITZB7UVA70ZnCioF+OR+gSmr0qVx9L4w
o2sH3BzLN/N/m4LHFogFVo5pRRH6rg==
=ywuC
-----END PGP SIGNATURE-----

--aPCU2gTJb098Ofi2cYVolL64TcCFVxFbA--
