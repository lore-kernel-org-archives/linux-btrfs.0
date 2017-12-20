Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55472 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751780AbdLTGLL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 01:11:11 -0500
Subject: Re: Cannot balance, ENOSPC errors 4.14.2 vanilla kernel
To: Adam Bahe <adambahe@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CACzgC9i6xUJTe6nbDP8pC+ZjViryLYfhMk+3du638cKnmjpsKw@mail.gmail.com>
 <CACzgC9hnC=s7cZruCRNJ0kUiU52w0FpRTkq7R0MtA71TURouoA@mail.gmail.com>
 <43ce8d2c-22cb-0b24-0735-c2c5177f0926@gmx.com>
 <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>
Date: Wed, 20 Dec 2017 14:11:01 +0800
MIME-Version: 1.0
In-Reply-To: <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WeKXHdOsSicJON6PX9lLlCcAa4lnft27j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WeKXHdOsSicJON6PX9lLlCcAa4lnft27j
Content-Type: multipart/mixed; boundary="eZiklYC1RHUGCvrmatEBnkCTbHgLKEcYR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Bahe <adambahe@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>
Subject: Re: Cannot balance, ENOSPC errors 4.14.2 vanilla kernel
References: <CACzgC9i6xUJTe6nbDP8pC+ZjViryLYfhMk+3du638cKnmjpsKw@mail.gmail.com>
 <CACzgC9hnC=s7cZruCRNJ0kUiU52w0FpRTkq7R0MtA71TURouoA@mail.gmail.com>
 <43ce8d2c-22cb-0b24-0735-c2c5177f0926@gmx.com>
 <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>
In-Reply-To: <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>

--eZiklYC1RHUGCvrmatEBnkCTbHgLKEcYR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 13:00, Adam Bahe wrote:
> I'm using raid10.

Pretty much the same.

Raid10 is RAID1 first then RAID0.

For your 20 disks (well, quite amazing) layout, btrfs will try to
allocate using all disks for RAID10.

Any unfortunately, devid 7, 9, 12, 13, 14, 15 are already full.

Normally btrfs should exclude them in chunk allocation, but I think
there is some small unaligned unallocated space making btrfs to choose
them for allocation.

And causing no new chunk could be allocated.

And considering the size of your fs, common method like adding temporary
small USB disk to allow convert doesn't work in your case.


You could try convert the profile from RAID10 to RAID1, which will
always use 2 disk to allocate space, so it would be OK to allocate new
chunks to start your convert.

And final suggestion, don't use any profile with stripe with so many
uneven disks.

Thanks,
Qu

>=20
> On Tue, Dec 19, 2017 at 10:51 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 10:51, Adam Bahe wrote:
>>> Forgot to add, I should have plenty of space:
>>>
>>> Label: 'nas'  uuid: 4fcd5725-b6c6-4d8a-9860-f2fc5474cbcb
>>>         Total devices 20 FS bytes used 26.69TiB
>>>         devid    1 size 3.64TiB used 3.28TiB path /dev/sdm
>>>         devid    2 size 3.64TiB used 3.28TiB path /dev/sde
>>>         devid    3 size 7.28TiB used 3.45TiB path /dev/sdt
>>>         devid    4 size 9.03TiB used 2.51TiB path /dev/sdo
>>>         devid    5 size 7.28TiB used 3.45TiB path /dev/sdi
>>>         devid    6 size 7.28TiB used 3.45TiB path /dev/sdd
>>>         devid    7 size 1.82TiB used 1.82TiB path /dev/sdp
>>>         devid    9 size 1.82TiB used 1.82TiB path /dev/sdw
>>>         devid   10 size 1.82TiB used 1.82TiB path /dev/sdk
>>>         devid   11 size 9.03TiB used 1.82TiB path /dev/sdy
>>>         devid   12 size 1.82TiB used 1.82TiB path /dev/sdg
>>>         devid   13 size 1.82TiB used 1.82TiB path /dev/sdl
>>>         devid   14 size 1.82TiB used 1.82TiB path /dev/sdr
>>>         devid   15 size 1.82TiB used 1.82TiB path /dev/sdf
>>>         devid   16 size 5.46TiB used 3.45TiB path /dev/sds
>>>         devid   17 size 9.10TiB used 3.45TiB path /dev/sdn
>>>         devid   18 size 9.10TiB used 3.45TiB path /dev/sdh
>>>         devid   19 size 9.10TiB used 3.45TiB path /dev/sdc
>>>         devid   20 size 9.10TiB used 3.45TiB path /dev/sdu
>>>         devid   21 size 3.64TiB used 2.19TiB path /dev/sdj
>>
>> Depends on your profile.
>>
>> If using RAID0/5/6, the extra unallocated space means nothing if the
>> smallest disk is used up.
>>
>> Thanks,
>> Qu
>>
>>>
>>> On Tue, Dec 19, 2017 at 8:47 PM, Adam Bahe <adambahe@gmail.com> wrote=
:
>>>> I have been having ENOSPC errors on any btrfs device delete, btrfs
>>>> balance, btrfs device add actions for awhile now. How do I fix this?=
 I
>>>> need to be able to remove devices and balance my filesystem again.
>>>>
>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): relocating block=

>>>> group 190774812082176 flags system|raid10
>>>> [Tue Dec 19 15:25:26 2017] BTRFS: Transaction aborted (error -27)
>>>> [Tue Dec 19 15:25:26 2017] ------------[ cut here ]------------
>>>> [Tue Dec 19 15:25:26 2017] WARNING: CPU: 1 PID: 17036 at
>>>> fs/btrfs/extent-tree.c:10151
>>>> btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017] Modules linked in: dm_mod dax rpcrdma
>>>> ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi
>>>> ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm
>>>> ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core
>>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypa=
ss
>>>> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
>>>> crypto_simd glue_helper cryptd ext4 intel_cstate jbd2 intel_rapl_per=
f
>>>> mbcache iTCO_wdt iTCO_vendor_support ses mei_me lpc_ich pcspkr joyde=
v
>>>> input_leds i2c_i801 mfd_core mei enclosure ioatdma sg wmi shpchp
>>>> ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter nfsd
>>>> auth_rpcgss nfs_acl lockd grace sunrpc ip_tables btrfs xor raid6_pq
>>>> mlx4_en sd_mod crc32c_intel ast i2c_algo_bit mlx4_core drm_kms_helpe=
r
>>>> ata_generic syscopyarea
>>>> [Tue Dec 19 15:25:26 2017]  pata_acpi sysfillrect sysimgblt
>>>> fb_sys_fops ttm drm ata_piix ixgbe mdio ptp mpt3sas pps_core libata
>>>> raid_class dca scsi_transport_sas 8021q garp mrp
>>>> [Tue Dec 19 15:25:26 2017] CPU: 1 PID: 17036 Comm: btrfs Not tainted=

>>>> 4.14.2-1.x86_64 #1
>>>> [Tue Dec 19 15:25:26 2017] Hardware name: Supermicro Super
>>>> Server/X10DRi-T4+, BIOS 2.0 12/17/2015
>>>> [Tue Dec 19 15:25:26 2017] task: ffff8804620416c0 task.stack: ffffc9=
0026f64000
>>>> [Tue Dec 19 15:25:26 2017] RIP:
>>>> 0010:btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017] RSP: 0018:ffffc90026f679e8 EFLAGS: 000102=
46
>>>> [Tue Dec 19 15:25:26 2017] RAX: 0000000000000026 RBX: 00000000ffffff=
e5
>>>> RCX: 0000000000000000
>>>> [Tue Dec 19 15:25:26 2017] RDX: 0000000000000000 RSI: ffff88046f84e1=
08
>>>> RDI: ffff88046f84e108
>>>> [Tue Dec 19 15:25:26 2017] RBP: ffffc90026f67a68 R08: 00000000000000=
00
>>>> R09: 0000000000003611
>>>> [Tue Dec 19 15:25:26 2017] R10: 0000000000000004 R11: 00000000000036=
10
>>>> R12: ffff8804679c38e8
>>>> [Tue Dec 19 15:25:26 2017] R13: ffff880108578000 R14: ffff8804679c38=
28
>>>> R15: ffff880108578128
>>>> [Tue Dec 19 15:25:26 2017] FS:  00007f46ad2e48c0(0000)
>>>> GS:ffff88046f840000(0000) knlGS:0000000000000000
>>>> [Tue Dec 19 15:25:26 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
>>>> [Tue Dec 19 15:25:26 2017] CR2: 00007f2daae8a000 CR3: 000000048be960=
00
>>>> CR4: 00000000001406e0
>>>> [Tue Dec 19 15:25:26 2017] DR0: 0000000000000000 DR1: 00000000000000=
00
>>>> DR2: 0000000000000000
>>>> [Tue Dec 19 15:25:26 2017] DR3: 0000000000000000 DR6: 00000000fffe0f=
f0
>>>> DR7: 0000000000000400
>>>> [Tue Dec 19 15:25:26 2017] Call Trace:
>>>> [Tue Dec 19 15:25:26 2017]  do_chunk_alloc+0x278/0x2f0 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_force_chunk_alloc+0x30/0x40 [btrfs=
]
>>>> [Tue Dec 19 15:25:26 2017]  relocate_block_group+0xd2/0x610 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_relocate_block_group+0x187/0x240 [=
btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_relocate_chunk+0x3b/0xc0 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  __btrfs_balance+0x854/0xc20 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_balance+0x2f4/0x670 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_ioctl_balance+0x439/0x560 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  btrfs_ioctl+0xf03/0x20f0 [btrfs]
>>>> [Tue Dec 19 15:25:26 2017]  ? tty_write_unlock+0x31/0x40
>>>> [Tue Dec 19 15:25:26 2017]  ? tty_ldisc_deref+0x16/0x20
>>>> [Tue Dec 19 15:25:26 2017]  ? tty_write+0x1e4/0x2c0
>>>> [Tue Dec 19 15:25:26 2017]  ? process_echoes+0x70/0x70
>>>> [Tue Dec 19 15:25:26 2017]  ? __vfs_write+0x37/0x140
>>>> [Tue Dec 19 15:25:26 2017]  do_vfs_ioctl+0xa7/0x5f0
>>>> [Tue Dec 19 15:25:26 2017]  ? getnstimeofday64+0xe/0x20
>>>> [Tue Dec 19 15:25:26 2017]  ? __audit_syscall_entry+0xb3/0xf0
>>>> [Tue Dec 19 15:25:26 2017]  ? syscall_trace_enter+0x1d0/0x2b0
>>>> [Tue Dec 19 15:25:26 2017]  SyS_ioctl+0x79/0x90
>>>> [Tue Dec 19 15:25:26 2017]  do_syscall_64+0x67/0x150
>>>> [Tue Dec 19 15:25:26 2017]  entry_SYSCALL64_slow_path+0x25/0x25
>>>> [Tue Dec 19 15:25:26 2017] RIP: 0033:0x7f46ac36b537
>>>> [Tue Dec 19 15:25:26 2017] RSP: 002b:00007ffcceffa448 EFLAGS: 000002=
06
>>>> ORIG_RAX: 0000000000000010
>>>> [Tue Dec 19 15:25:26 2017] RAX: ffffffffffffffda RBX: 00000000000000=
03
>>>> RCX: 00007f46ac36b537
>>>> [Tue Dec 19 15:25:26 2017] RDX: 00007ffcceffa4e0 RSI: 00000000c40094=
20
>>>> RDI: 0000000000000003
>>>> [Tue Dec 19 15:25:26 2017] RBP: 00007ffcceffa4e0 R08: 00007f46ac639a=
00
>>>> R09: 00007ffcceffa1c0
>>>> [Tue Dec 19 15:25:26 2017] R10: 00007ffcceffa1d0 R11: 00000000000002=
06
>>>> R12: 00007f46ac638870
>>>> [Tue Dec 19 15:25:26 2017] R13: 00007ffcceffc893 R14: 00000000000000=
00
>>>> R15: 0000000000000000
>>>> [Tue Dec 19 15:25:26 2017] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48=

>>>> c7 c6 a8 55 57 a0 31 c0 e8 52 50 fe ff eb 9b 89 de 48 c7 c7 78 55 57=

>>>> a0 31 c0 e8 be 8a cd e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 =
00
>>>> 00 0f 1f 44 00 00
>>>> [Tue Dec 19 15:25:26 2017] ---[ end trace 7b033857aa29250b ]---
>>>> [Tue Dec 19 15:25:26 2017] BTRFS: error (device sdc) in
>>>> btrfs_create_pending_block_groups:10151: errno=3D-27 unknown
>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): forced readonly
>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): 3388 enospc erro=
rs
>>>> during balance
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--eZiklYC1RHUGCvrmatEBnkCTbHgLKEcYR--

--WeKXHdOsSicJON6PX9lLlCcAa4lnft27j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo5/vUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgzNwf5AaL+pWDZbDCekcZU3ed5EgFw
3+hV4fweRPpjs4vnVb0XWSdNguBSZRXuhznhHaLXGfQtP788Jx3mwUPHOlGNO8H4
KXPP54YMNyCEgZ45CWnz3l0yvBpoYFpqtiHT4lBAmdakYnWAKrPKjohH99p+xRsF
jitgHwPL7KMGUMbvg8qaCusD4K538qrFyUnNduI4RaO4hq5BdoxH15NV2bVtiiU1
c3BD01tAREQkSzEpm99lcISb3SQx/NVgr40FoF8ggIbH/nI2WaL1pmRkYt+s/7dG
9YKgha5uS9m7EVLWKwWtAwx+cnW+bFcw75Y+Mhd0Lq84PHhSt2WsnTqUhfJxkg==
=1c+w
-----END PGP SIGNATURE-----

--WeKXHdOsSicJON6PX9lLlCcAa4lnft27j--
