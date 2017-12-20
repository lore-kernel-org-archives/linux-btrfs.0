Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54357 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbdLTGUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 01:20:38 -0500
Subject: Re: Cannot balance, ENOSPC errors 4.14.2 vanilla kernel
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Bahe <adambahe@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CACzgC9i6xUJTe6nbDP8pC+ZjViryLYfhMk+3du638cKnmjpsKw@mail.gmail.com>
 <CACzgC9hnC=s7cZruCRNJ0kUiU52w0FpRTkq7R0MtA71TURouoA@mail.gmail.com>
 <43ce8d2c-22cb-0b24-0735-c2c5177f0926@gmx.com>
 <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>
 <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>
Message-ID: <fdf7104f-1072-cb6c-e544-d2872350993d@gmx.com>
Date: Wed, 20 Dec 2017 14:20:32 +0800
MIME-Version: 1.0
In-Reply-To: <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CQtLsMaEj4kApMvvFggiYU1Le9oUxmZRv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CQtLsMaEj4kApMvvFggiYU1Le9oUxmZRv
Content-Type: multipart/mixed; boundary="zox0soh7SfRUHh1qyKhfNQq315Gme8Kv2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Bahe <adambahe@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <fdf7104f-1072-cb6c-e544-d2872350993d@gmx.com>
Subject: Re: Cannot balance, ENOSPC errors 4.14.2 vanilla kernel
References: <CACzgC9i6xUJTe6nbDP8pC+ZjViryLYfhMk+3du638cKnmjpsKw@mail.gmail.com>
 <CACzgC9hnC=s7cZruCRNJ0kUiU52w0FpRTkq7R0MtA71TURouoA@mail.gmail.com>
 <43ce8d2c-22cb-0b24-0735-c2c5177f0926@gmx.com>
 <CACzgC9i=8AX1N7LjnkBmes4e3gu15OvyuvmV-GxuHKiEEFJ36g@mail.gmail.com>
 <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>
In-Reply-To: <5ad0ede6-72c5-f9a0-1ad4-95e0d17ebd7d@gmx.com>

--zox0soh7SfRUHh1qyKhfNQq315Gme8Kv2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Also, if you're OK to compile kernel, would you please try the following
diff to help us to further enhance btrfs chunk allocator?

The chunk allocator itself is designed to handle your case, so it should
pick up the remaining devices and allocate new RAID10 chunk with the
unallocated space.

But the truth is not the case.
I'm wondering if it's the devs_increment and substripes calculation
causing the problem.

If you could help testing btrfs with the diff applied, dmesg would
contain extra info when you try to do device remove.

Thanks,
Qu

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49810b70afd3..851ff13f5c29 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4732,6 +4732,8 @@ static int __btrfs_alloc_chunk(struct
btrfs_trans_handle *trans,

        if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
                ret =3D -ENOSPC;
+               pr_info("ndevs=3D%d dev_increment=3D%d sub_stripes=3D%d
devs_min=3D%d\n",
+                       ndevs, devs_increment, sub_stripes, devs_min);
                goto error;
        }


On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 14:11, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 13:00, Adam Bahe wrote:
>> I'm using raid10.
>=20
> Pretty much the same.
>=20
> Raid10 is RAID1 first then RAID0.
>=20
> For your 20 disks (well, quite amazing) layout, btrfs will try to
> allocate using all disks for RAID10.
>=20
> Any unfortunately, devid 7, 9, 12, 13, 14, 15 are already full.
>=20
> Normally btrfs should exclude them in chunk allocation, but I think
> there is some small unaligned unallocated space making btrfs to choose
> them for allocation.
>=20
> And causing no new chunk could be allocated.
>=20
> And considering the size of your fs, common method like adding temporar=
y
> small USB disk to allow convert doesn't work in your case.
>=20
>=20
> You could try convert the profile from RAID10 to RAID1, which will
> always use 2 disk to allocate space, so it would be OK to allocate new
> chunks to start your convert.
>=20
> And final suggestion, don't use any profile with stripe with so many
> uneven disks.
>=20
> Thanks,
> Qu
>=20
>>
>> On Tue, Dec 19, 2017 at 10:51 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>
>>>
>>> On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 10:51, Adam Bahe wrote:
>>>> Forgot to add, I should have plenty of space:
>>>>
>>>> Label: 'nas'  uuid: 4fcd5725-b6c6-4d8a-9860-f2fc5474cbcb
>>>>         Total devices 20 FS bytes used 26.69TiB
>>>>         devid    1 size 3.64TiB used 3.28TiB path /dev/sdm
>>>>         devid    2 size 3.64TiB used 3.28TiB path /dev/sde
>>>>         devid    3 size 7.28TiB used 3.45TiB path /dev/sdt
>>>>         devid    4 size 9.03TiB used 2.51TiB path /dev/sdo
>>>>         devid    5 size 7.28TiB used 3.45TiB path /dev/sdi
>>>>         devid    6 size 7.28TiB used 3.45TiB path /dev/sdd
>>>>         devid    7 size 1.82TiB used 1.82TiB path /dev/sdp
>>>>         devid    9 size 1.82TiB used 1.82TiB path /dev/sdw
>>>>         devid   10 size 1.82TiB used 1.82TiB path /dev/sdk
>>>>         devid   11 size 9.03TiB used 1.82TiB path /dev/sdy
>>>>         devid   12 size 1.82TiB used 1.82TiB path /dev/sdg
>>>>         devid   13 size 1.82TiB used 1.82TiB path /dev/sdl
>>>>         devid   14 size 1.82TiB used 1.82TiB path /dev/sdr
>>>>         devid   15 size 1.82TiB used 1.82TiB path /dev/sdf
>>>>         devid   16 size 5.46TiB used 3.45TiB path /dev/sds
>>>>         devid   17 size 9.10TiB used 3.45TiB path /dev/sdn
>>>>         devid   18 size 9.10TiB used 3.45TiB path /dev/sdh
>>>>         devid   19 size 9.10TiB used 3.45TiB path /dev/sdc
>>>>         devid   20 size 9.10TiB used 3.45TiB path /dev/sdu
>>>>         devid   21 size 3.64TiB used 2.19TiB path /dev/sdj
>>>
>>> Depends on your profile.
>>>
>>> If using RAID0/5/6, the extra unallocated space means nothing if the
>>> smallest disk is used up.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> On Tue, Dec 19, 2017 at 8:47 PM, Adam Bahe <adambahe@gmail.com> wrot=
e:
>>>>> I have been having ENOSPC errors on any btrfs device delete, btrfs
>>>>> balance, btrfs device add actions for awhile now. How do I fix this=
? I
>>>>> need to be able to remove devices and balance my filesystem again.
>>>>>
>>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): relocating bloc=
k
>>>>> group 190774812082176 flags system|raid10
>>>>> [Tue Dec 19 15:25:26 2017] BTRFS: Transaction aborted (error -27)
>>>>> [Tue Dec 19 15:25:26 2017] ------------[ cut here ]------------
>>>>> [Tue Dec 19 15:25:26 2017] WARNING: CPU: 1 PID: 17036 at
>>>>> fs/btrfs/extent-tree.c:10151
>>>>> btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017] Modules linked in: dm_mod dax rpcrdma
>>>>> ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi
>>>>> ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm=

>>>>> ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core
>>>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbyp=
ass
>>>>> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
>>>>> crypto_simd glue_helper cryptd ext4 intel_cstate jbd2 intel_rapl_pe=
rf
>>>>> mbcache iTCO_wdt iTCO_vendor_support ses mei_me lpc_ich pcspkr joyd=
ev
>>>>> input_leds i2c_i801 mfd_core mei enclosure ioatdma sg wmi shpchp
>>>>> ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter nfsd=

>>>>> auth_rpcgss nfs_acl lockd grace sunrpc ip_tables btrfs xor raid6_pq=

>>>>> mlx4_en sd_mod crc32c_intel ast i2c_algo_bit mlx4_core drm_kms_help=
er
>>>>> ata_generic syscopyarea
>>>>> [Tue Dec 19 15:25:26 2017]  pata_acpi sysfillrect sysimgblt
>>>>> fb_sys_fops ttm drm ata_piix ixgbe mdio ptp mpt3sas pps_core libata=

>>>>> raid_class dca scsi_transport_sas 8021q garp mrp
>>>>> [Tue Dec 19 15:25:26 2017] CPU: 1 PID: 17036 Comm: btrfs Not tainte=
d
>>>>> 4.14.2-1.x86_64 #1
>>>>> [Tue Dec 19 15:25:26 2017] Hardware name: Supermicro Super
>>>>> Server/X10DRi-T4+, BIOS 2.0 12/17/2015
>>>>> [Tue Dec 19 15:25:26 2017] task: ffff8804620416c0 task.stack: ffffc=
90026f64000
>>>>> [Tue Dec 19 15:25:26 2017] RIP:
>>>>> 0010:btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017] RSP: 0018:ffffc90026f679e8 EFLAGS: 00010=
246
>>>>> [Tue Dec 19 15:25:26 2017] RAX: 0000000000000026 RBX: 00000000fffff=
fe5
>>>>> RCX: 0000000000000000
>>>>> [Tue Dec 19 15:25:26 2017] RDX: 0000000000000000 RSI: ffff88046f84e=
108
>>>>> RDI: ffff88046f84e108
>>>>> [Tue Dec 19 15:25:26 2017] RBP: ffffc90026f67a68 R08: 0000000000000=
000
>>>>> R09: 0000000000003611
>>>>> [Tue Dec 19 15:25:26 2017] R10: 0000000000000004 R11: 0000000000003=
610
>>>>> R12: ffff8804679c38e8
>>>>> [Tue Dec 19 15:25:26 2017] R13: ffff880108578000 R14: ffff8804679c3=
828
>>>>> R15: ffff880108578128
>>>>> [Tue Dec 19 15:25:26 2017] FS:  00007f46ad2e48c0(0000)
>>>>> GS:ffff88046f840000(0000) knlGS:0000000000000000
>>>>> [Tue Dec 19 15:25:26 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
>>>>> [Tue Dec 19 15:25:26 2017] CR2: 00007f2daae8a000 CR3: 000000048be96=
000
>>>>> CR4: 00000000001406e0
>>>>> [Tue Dec 19 15:25:26 2017] DR0: 0000000000000000 DR1: 0000000000000=
000
>>>>> DR2: 0000000000000000
>>>>> [Tue Dec 19 15:25:26 2017] DR3: 0000000000000000 DR6: 00000000fffe0=
ff0
>>>>> DR7: 0000000000000400
>>>>> [Tue Dec 19 15:25:26 2017] Call Trace:
>>>>> [Tue Dec 19 15:25:26 2017]  do_chunk_alloc+0x278/0x2f0 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_force_chunk_alloc+0x30/0x40 [btrf=
s]
>>>>> [Tue Dec 19 15:25:26 2017]  relocate_block_group+0xd2/0x610 [btrfs]=

>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_relocate_block_group+0x187/0x240 =
[btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_relocate_chunk+0x3b/0xc0 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  __btrfs_balance+0x854/0xc20 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_balance+0x2f4/0x670 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_ioctl_balance+0x439/0x560 [btrfs]=

>>>>> [Tue Dec 19 15:25:26 2017]  btrfs_ioctl+0xf03/0x20f0 [btrfs]
>>>>> [Tue Dec 19 15:25:26 2017]  ? tty_write_unlock+0x31/0x40
>>>>> [Tue Dec 19 15:25:26 2017]  ? tty_ldisc_deref+0x16/0x20
>>>>> [Tue Dec 19 15:25:26 2017]  ? tty_write+0x1e4/0x2c0
>>>>> [Tue Dec 19 15:25:26 2017]  ? process_echoes+0x70/0x70
>>>>> [Tue Dec 19 15:25:26 2017]  ? __vfs_write+0x37/0x140
>>>>> [Tue Dec 19 15:25:26 2017]  do_vfs_ioctl+0xa7/0x5f0
>>>>> [Tue Dec 19 15:25:26 2017]  ? getnstimeofday64+0xe/0x20
>>>>> [Tue Dec 19 15:25:26 2017]  ? __audit_syscall_entry+0xb3/0xf0
>>>>> [Tue Dec 19 15:25:26 2017]  ? syscall_trace_enter+0x1d0/0x2b0
>>>>> [Tue Dec 19 15:25:26 2017]  SyS_ioctl+0x79/0x90
>>>>> [Tue Dec 19 15:25:26 2017]  do_syscall_64+0x67/0x150
>>>>> [Tue Dec 19 15:25:26 2017]  entry_SYSCALL64_slow_path+0x25/0x25
>>>>> [Tue Dec 19 15:25:26 2017] RIP: 0033:0x7f46ac36b537
>>>>> [Tue Dec 19 15:25:26 2017] RSP: 002b:00007ffcceffa448 EFLAGS: 00000=
206
>>>>> ORIG_RAX: 0000000000000010
>>>>> [Tue Dec 19 15:25:26 2017] RAX: ffffffffffffffda RBX: 0000000000000=
003
>>>>> RCX: 00007f46ac36b537
>>>>> [Tue Dec 19 15:25:26 2017] RDX: 00007ffcceffa4e0 RSI: 00000000c4009=
420
>>>>> RDI: 0000000000000003
>>>>> [Tue Dec 19 15:25:26 2017] RBP: 00007ffcceffa4e0 R08: 00007f46ac639=
a00
>>>>> R09: 00007ffcceffa1c0
>>>>> [Tue Dec 19 15:25:26 2017] R10: 00007ffcceffa1d0 R11: 0000000000000=
206
>>>>> R12: 00007f46ac638870
>>>>> [Tue Dec 19 15:25:26 2017] R13: 00007ffcceffc893 R14: 0000000000000=
000
>>>>> R15: 0000000000000000
>>>>> [Tue Dec 19 15:25:26 2017] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 4=
8
>>>>> c7 c6 a8 55 57 a0 31 c0 e8 52 50 fe ff eb 9b 89 de 48 c7 c7 78 55 5=
7
>>>>> a0 31 c0 e8 be 8a cd e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00=
 00
>>>>> 00 0f 1f 44 00 00
>>>>> [Tue Dec 19 15:25:26 2017] ---[ end trace 7b033857aa29250b ]---
>>>>> [Tue Dec 19 15:25:26 2017] BTRFS: error (device sdc) in
>>>>> btrfs_create_pending_block_groups:10151: errno=3D-27 unknown
>>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): forced readonly=

>>>>> [Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): 3388 enospc err=
ors
>>>>> during balance
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--zox0soh7SfRUHh1qyKhfNQq315Gme8Kv2--

--CQtLsMaEj4kApMvvFggiYU1Le9oUxmZRv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo6ATAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi8OAgAoHizOH76aB5nAWFIyk3cOXTN
DF3KlKE11iQJ1ywHxT118g8sYpU0nl85hLVeOO1BF5oPpnlAibvUpt5GjYdNMUQL
8ZBdaLB3uXuWSrfK3ShaC3y2uZPGdC/FBt1PoQKeZocz/by269BWP50/7MEDngBO
+9CNuc+QuICS5L79ap6vP1/427FhAexagM96BZfr+0XdoBXw71NJvCB9rwxhS1JD
qC1RE5frj4LRstBj5VByU8ujse6U+Hftpq0Bqv2NNmqpFKq5XqNc/zFll0xPAYCN
825gCQQzzQ2E1250iP/ux6VvIybhzVsk019ypeHhbbg5kS3PqO/aXeKkvNPx0A==
=pD9p
-----END PGP SIGNATURE-----

--CQtLsMaEj4kApMvvFggiYU1Le9oUxmZRv--
