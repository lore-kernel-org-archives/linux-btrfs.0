Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:42523 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752480AbeCFCHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 21:07:16 -0500
Subject: Re: ERROR: unsupported checksum algorithm 35355
To: Ken Swenson <flat@imo.uto.moe>, linux-btrfs@vger.kernel.org
References: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8baab099-5779-396b-354a-5f1dfc68f915@gmx.com>
Date: Tue, 6 Mar 2018 10:07:07 +0800
MIME-Version: 1.0
In-Reply-To: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s1rOTxfw4w9pY2l0YIuRtnEEf3vyPv98r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s1rOTxfw4w9pY2l0YIuRtnEEf3vyPv98r
Content-Type: multipart/mixed; boundary="R66nuDRn6bgwimBiPGYuIyfQdGtJrfW4S";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ken Swenson <flat@imo.uto.moe>, linux-btrfs@vger.kernel.org
Message-ID: <8baab099-5779-396b-354a-5f1dfc68f915@gmx.com>
Subject: Re: ERROR: unsupported checksum algorithm 35355
References: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>
In-Reply-To: <1b11c57b-ee9f-b94a-3d79-bbacf01ba3bf@imo.uto.moe>

--R66nuDRn6bgwimBiPGYuIyfQdGtJrfW4S
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8806=E6=97=A5 09:51, Ken Swenson wrote:
> Hello,
> =C2=A0
> Somehow it appears the csum_type on my btrfs file system got corrupted.=

> I cannot mount the system in recovery or read only. btrfs check just
> returns "ERROR: unsupported checksum algorithm 35355" as well as btrfs
> recover. The only command I was able to successfully run was btrfs
> inspect-internal dump-super, which I've pasted the output at the end of=

> this message.
>=20
> Requested information from the wiki:
> Linux 4.15.7-1-ARCH #1 SMP PREEMPT Wed Feb 28 19:01:57 UTC 2018 x86_64
> GNU/Linux
> btrfs-progs v4.15.1
> btrfs fi show: ERROR: unsupported checksum algorithm 35355 ERROR: canno=
t
> scan /dev/mapper/x: Input/output error
>=20
> dmesg:
> [ 11.232399] Btrfs loaded, crc32c=3Dcrc32c-intel
> [ 11.233229] BTRFS: device fsid 513f07e1-08be-4d94-a55c-11c6251f6c2f
> devid 1 transid 7777 /dev/dm-2
> [ 488.372891] BTRFS error (device dm-2): unsupported checksum algorithm=

> 35355
> [ 488.372894] BTRFS error (device dm-2): superblock checksum mismatch
> [ 488.384902] BTRFS error (device dm-2): open_ctree failed
>=20
> Is there anything I can do to recovery from this or am I out of luck? T=
o
> give some background the disk was working fine until I upgraded to
> Kernel 4.15.7 and rebooted.
>=20
> superblock: bytenr=3D65536, device=3D/dev/mapper/x
> ---------------------------------------------------------
> csum_type=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 35355 (INVALID)

This is obviously corrupted.

Btrfs only supports csum_type 0 (CRC32) yet.

And the value seems to be some garbage.

> csum_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 32

So is the csum size.

> csum=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0
> 0xf0dbeddd00000000000000000000000000000000000000000000000000000000 [mat=
ch]

Surprised to see the csum even matched.

> bytenr=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 65536
> flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ( WRITTEN )
> magic=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 _BHRfS_M =
[match]
> fsid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 513f07e1-0=
8be-4d94-a55c-11c6251f6c2f
> label=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0
> generation=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 7777
> root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 186466304
> sys_array_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 129
> chunk_root_generation=C2=A0=C2=A0=C2=A0 7450
> root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> chunk_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 21004288
> chunk_root_level=C2=A0=C2=A0=C2=A0 1
> log_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> log_root_transid=C2=A0=C2=A0=C2=A0 0
> log_root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> total_bytes=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 5000947523584
> bytes_used=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 420849201152
> sectorsize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096
> nodesize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 16384
> leafsize (deprecated)=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 16384
> stripesize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096
> root_dir=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 6
> num_devices=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> compat_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x0
> compat_ro_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x0
> incompat_flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x176d200000000169
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ( MIXED_BACKRE=
F |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 COMPRES=
S_LZO |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 BIG_MET=
ADATA |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 EXTENDE=
D_IREF |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 SKINNY_=
METADATA |
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 unknown=
 flag: 0x176d200000000000 )

And unknown flags also exists.

And according to later output, all backup super blocks have the same
corruption while csum still matches.

I'm wondering if the memory is corrupted.

It's possible to manually modify the superblock to a valid status.
As all the corruption is obvious, but I'm not 100% sure if there is
other corruption.

Please provide the binary superblock dump by:

dd if=3D<device> bs=3D1 count=3D4K skip=3D64K of=3Dsuper_copy

Thanks,
Qu

> cache_generation=C2=A0=C2=A0=C2=A0 7777
> uuid_tree_generation=C2=A0=C2=A0=C2=A0 7777
> dev_item.uuid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 880c692f-5270-4c7a-9=
08d-8b3956fb3790
> dev_item.fsid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 513f07e1-08be-4d94-a=
55c-11c6251f6c2f [match]
> dev_item.type=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> dev_item.total_bytes=C2=A0=C2=A0=C2=A0 5000947523584
> dev_item.bytes_used=C2=A0=C2=A0=C2=A0 457439182848
> dev_item.io_align=C2=A0=C2=A0=C2=A0 4096
> dev_item.io_width=C2=A0=C2=A0=C2=A0 4096
> dev_item.sector_size=C2=A0=C2=A0=C2=A0 4096
> dev_item.devid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> dev_item.dev_group=C2=A0=C2=A0=C2=A0 0
> dev_item.seek_speed=C2=A0=C2=A0=C2=A0 0
> dev_item.bandwidth=C2=A0=C2=A0=C2=A0 0
> dev_item.generation=C2=A0=C2=A0=C2=A0 0
> sys_chunk_array[2048]:
> =C2=A0=C2=A0=C2=A0 item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 length 8388608 owner 2 stripe_len=
 65536 type SYSTEM|DUP
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 io_align 65536 io_width 65536 sec=
tor_size 4096
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 num_stripes 2 sub_stripes 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 stripe 0 devid=
 1 offset 20971520
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev_uuid 880c6=
92f-5270-4c7a-908d-8b3956fb3790
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 stripe 1 devid=
 1 offset 29360128
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev_uuid 880c6=
92f-5270-4c7a-908d-8b3956fb3790
> backup_roots[4]:
> =C2=A0=C2=A0=C2=A0 backup 0:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 181174272=C2=A0=C2=A0=C2=A0 gen: 7774=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 21004288=C2=A0=C2=A0=C2=A0 gen: 7450=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 181190656=C2=A0=C2=A0=C2=A0 gen: 7774=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 809828352=C2=A0=C2=A0=C2=A0 gen: 6404=C2=A0=C2=A0=C2=A0=
 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 93585408=C2=A0=C2=A0=C2=A0 gen: 7631=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 181862400=C2=A0=C2=A0=C2=A0 gen: 7774=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 5000947523584
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 420849201152
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 1:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 183828480=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 21004288=C2=A0=C2=A0=C2=A0 gen: 7450=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 183320576=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 809828352=C2=A0=C2=A0=C2=A0 gen: 6404=C2=A0=C2=A0=C2=A0=
 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 183975936=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 185761792=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 5000947523584
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 420849201152
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 2:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 186810368=C2=A0=C2=A0=C2=A0 gen: 7776=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 21004288=C2=A0=C2=A0=C2=A0 gen: 7450=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 186613760=C2=A0=C2=A0=C2=A0 gen: 7776=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 809828352=C2=A0=C2=A0=C2=A0 gen: 6404=C2=A0=C2=A0=C2=A0=
 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 183975936=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 187056128=C2=A0=C2=A0=C2=A0 gen: 7776=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 5000947523584
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 420849201152
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
> =C2=A0=C2=A0=C2=A0 backup 3:
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=
 186466304=C2=A0=C2=A0=C2=A0 gen: 7777=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_chunk_root:=C2=A0=C2=A0=C2=
=A0 21004288=C2=A0=C2=A0=C2=A0 gen: 7450=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_extent_root:=C2=A0=C2=A0=C2=
=A0 187908096=C2=A0=C2=A0=C2=A0 gen: 7777=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_fs_root:=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 809828352=C2=A0=C2=A0=C2=A0 gen: 6404=C2=A0=C2=A0=C2=A0=
 level: 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_dev_root:=C2=A0=C2=A0=C2=A0=
 183975936=C2=A0=C2=A0=C2=A0 gen: 7775=C2=A0=C2=A0=C2=A0 level: 1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_csum_root:=C2=A0=C2=A0=C2=A0=
 188071936=C2=A0=C2=A0=C2=A0 gen: 7777=C2=A0=C2=A0=C2=A0 level: 2
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_total_bytes:=C2=A0=C2=A0=C2=
=A0 5000947523584
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_bytes_used:=C2=A0=C2=A0=C2=
=A0 420849201152
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 backup_num_devices:=C2=A0=C2=A0=C2=
=A0 1
>=20
>=20


--R66nuDRn6bgwimBiPGYuIyfQdGtJrfW4S--

--s1rOTxfw4w9pY2l0YIuRtnEEf3vyPv98r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqd98sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjFhgf/Zx5p0CAqERuMk2dV2cu838aR
5LOwdYek9BpgzX13E/IeP3ugHuAFu0VM3K4oYUMy0rfg5I2SU3qzPh5DfDRb5Kf2
upS3oQQBnq1lm0Upv/G5BRbREbWAoHgU76bYu0n7Q5tOimP6h69ERPqUkiJzPbcL
Hx2dmtKm+XycR1e/XxGNryG8j/juAzqAGzW9G3v7GFJKeLrUKMq0bwPhDOb5iXjp
rXZT8+uly9a2GYiEG/6xuUjTFipyh28Zsz2a9VZ4QG/tZYbPSRTZCWcu69loe2ZU
pNWLrxEUiCkY4PjADj6c2qRzf1sZaVFyC/nMfgrt/nJObbP64eLB0bUzDtlgSA==
=slV2
-----END PGP SIGNATURE-----

--s1rOTxfw4w9pY2l0YIuRtnEEf3vyPv98r--
