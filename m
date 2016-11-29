Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755996AbcK2QES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 11:04:18 -0500
Subject: Re: Qgroup accounting issue on kdave/for-next branch
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
References: <19009351.7ILlWBP2dy@localhost.localdomain>
 <b5b9c629-e84d-627c-7805-cc13d75e3f8d@suse.com>
Cc: quwenruo@cn.fujitsu.com
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <f7ab7eb8-e434-f168-79ee-bac4b1e960de@suse.com>
Date: Tue, 29 Nov 2016 11:01:54 -0500
MIME-Version: 1.0
In-Reply-To: <b5b9c629-e84d-627c-7805-cc13d75e3f8d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eVlPA0thaPTKtqanKSHg12LOwwgVOE9OF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eVlPA0thaPTKtqanKSHg12LOwwgVOE9OF
Content-Type: multipart/mixed; boundary="xetNtOBSFLpvAEFtacT14nnKILef7WBUk";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Message-ID: <f7ab7eb8-e434-f168-79ee-bac4b1e960de@suse.com>
Subject: Re: Qgroup accounting issue on kdave/for-next branch
References: <19009351.7ILlWBP2dy@localhost.localdomain>
 <b5b9c629-e84d-627c-7805-cc13d75e3f8d@suse.com>
In-Reply-To: <b5b9c629-e84d-627c-7805-cc13d75e3f8d@suse.com>

--xetNtOBSFLpvAEFtacT14nnKILef7WBUk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/29/16 10:56 AM, Jeff Mahoney wrote:
> On 11/29/16 1:36 AM, Chandan Rajendra wrote:
>> When executing btrfs/126 test on kdave/for-next branch on a ppc64 gues=
t, I
>> noticed the following call trace.
>>
>> [   77.335887] ------------[ cut here ]------------
>> [   77.336115] WARNING: CPU: 0 PID: 8325 at /root/repos/linux/fs/btrfs=
/qgroup.c:2443 .btrfs_qgroup_free_refroot+0x188/0x220
>> [   77.336303] Modules linked in:
>> [   77.336393] CPU: 0 PID: 8325 Comm: umount Not tainted 4.9.0-rc5-000=
62-g6b74e43 #22
>> [   77.336526] task: c00000062b8d4880 task.stack: c00000062b9a4000
>> [   77.336638] NIP: c0000000005cf018 LR: c0000000005ceff8 CTR: c000000=
0005390c0
>> [   77.336771] REGS: c00000062b9a7450 TRAP: 0700   Not tainted  (4.9.0=
-rc5-00062-g6b74e43)
>> [   77.336908] MSR: 800000000282b032
>> [   77.336960] <
>> [   77.337027] SF
>> [   77.337053] ,VEC
>> [   77.337087] ,VSX
>> [   77.337114] ,EE
>> [   77.337146] ,FP
>> [   77.337173] ,ME
>> [   77.337207] ,IR
>> [   77.337233] ,DR
>> [   77.337267] ,RI
>> [   77.337294] >
>> [   77.337330]   CR: 88000842  XER: 00000000
>> [   77.337392] CFAR: c0000000005c9b5c
>> [   77.337443] SOFTE: 1
>> [   77.337477]
>>                GPR00:
>> [   77.337517] c0000000005cefcc
>> [   77.337575] c00000062b9a76d0
>> [   77.337626] c000000001103a00
>> [   77.337714] c00000063e058d40
>> [   77.337765]
>>                GPR04:
>> [   77.337817] c00000062b9a7740
>> [   77.337868] 0000000000000008
>> [   77.337927] 000000000005f000
>> [   77.337978] 000000063eed0000
>> [   77.338037]
>>                GPR08:
>> [   77.338080] c00000062f9629c8
>> [   77.338138] 0000000000000001
>> [   77.338191] fffffffffffff000
>> [   77.338248] c00000063e058e80
>> [   77.338300]
>>                GPR12:
>> [   77.338384] 0000000000000000
>> [   77.338435] c00000000fe00000
>> [   77.338498] 0000000020000000
>> [   77.338548] 0000000000000000
>> [   77.338605]
>>                GPR16:
>> [   77.338645] 0000000000000008
>> [   77.338703] 000000004d5906fc
>> [   77.338754] 000000004d5a6c08
>> [   77.338811] 000000004d54b3d0
>> [   77.338866]
>>                GPR20:
>> [   77.338921] 000001000bcf8440
>> [   77.338972] 0000000000000000
>> [   77.339030] 0000000000000000
>> [   77.339080] c00000062523b078
>> [   77.339138]
>>                GPR24:
>> [   77.339178] c00000062523b080
>> [   77.339240] c000000000da2b58
>> [   77.339290] 0000000000000000
>> [   77.339347] c00000062e539600
>> [   77.339398]
>>                GPR28:
>> [   77.339485] 0000000000060000
>> [   77.339536] c00000062523b000
>> [   77.339594] c00000062e539600
>> [   77.339644] c00000062e539688
>>
>> [   77.339740] NIP [c0000000005cf018] .btrfs_qgroup_free_refroot+0x188=
/0x220
>> [   77.339852] LR [c0000000005ceff8] .btrfs_qgroup_free_refroot+0x168/=
0x220
>> [   77.339959] Call Trace:
>> [   77.339998] [c00000062b9a76d0] [c0000000005cefcc] .btrfs_qgroup_fre=
e_refroot+0x13c/0x220
>> [   77.340123]  (unreliable)
>> [   77.340193] [c00000062b9a7790] [c00000000054210c] .commit_fs_roots+=
0x19c/0x240
>> [   77.340355] [c00000062b9a78a0] [c0000000005451a0] .btrfs_commit_tra=
nsaction.part.5+0x480/0xbe0
>> [   77.340554] [c00000062b9a7970] [c000000000503bd4] .btrfs_sync_fs+0x=
74/0x1c0
>> [   77.340725] [c00000062b9a7a10] [c0000000002d6ce0] .sync_filesystem+=
0xd0/0x100
>> [   77.340891] [c00000062b9a7a90] [c000000000294f88] .generic_shutdown=
_super+0x38/0x1a0
>> [   77.341052] [c00000062b9a7b10] [c000000000295508] .kill_anon_super+=
0x18/0x30
>> [   77.342243] [c00000062b9a7b90] [c000000000503db8] .btrfs_kill_super=
+0x18/0xd0
>> [   77.342411] [c00000062b9a7c10] [c0000000002958c8] .deactivate_locke=
d_super+0x98/0xe0
>> [   77.342573] [c00000062b9a7c90] [c0000000002be114] .cleanup_mnt+0x54=
/0xa0
>> [   77.342723] [c00000062b9a7d10] [c0000000000d7e74] .task_work_run+0x=
124/0x180
>> [   77.342862] [c00000062b9a7db0] [c00000000001c354] .do_notify_resume=
+0xa4/0xb0
>> [   77.343030] [c00000062b9a7e30] [c00000000000c344] .ret_from_except_=
lite+0x70/0x74
>> [   77.343187] Instruction dump:
>> [   77.343276] 3b400000 e87d0c78 38810070 4bffab1d 60000000 2c230000 4=
182ff40 e8dfffc8
>> [   77.343522] eb630008 7d5c3010 7d294910 7d2900d0 <0b090000> 7fbc3040=
 41dd0070 f95fffc8
>> [   77.343771] ---[ end trace 8130fb71377d4ff8 ]---
>> [   77.343857] BTRFS warning (device loop1): qgroup 5 reserved space u=
nderflow, have: 389120, to free: 393216
>> [   77.735193] BTRFS info (device loop1): disabling disk space caching=

>> [   77.736629] BTRFS info (device loop1): has skinny extents
>>
>>
>> The above call trace happens because of the following:
>>
>>  |--------------------------------+-----------------------------------=
|
>>  | Task A                         | Task B                            =
|
>>  |--------------------------------+-----------------------------------=
|
>>  | Write 4k bytes to a file       |                                   =
|
>>  | at offset range [0, 4095]      |                                   =
|
>>  | - __btrfs_buffered_write       |                                   =
|
>>  | -- btrfs_check_data_free_space |                                   =
|
>>  | --- Set EXTENT_QGROUP_RESERVED |                                   =
|
>>  |     bit for range [0, 64k-1]   |                                   =
|
>>  | -- Copy 4k data from userspace |                                   =
|
>>  |    to page cache               |                                   =
|
>>  |                                | Write 4k bytes to the file        =
|
>>  |                                | at offset range [4096, 8191]      =
|
>>  |                                | - __btrfs_buffered_write          =
|
>>  |                                | -- btrfs_check_data_free_space    =
|
>>  |                                | --- Since EXTENT_QGROUP_RESERVED  =
|
>>  |                                | is already set we don't           =
|
>>  |                                | reserve qgroup space              =
|
>>  |                                | -- Assume the call to             =
|
>>  |                                | btrfs_delalloc_reserve_metadata() =
|
>>  |                                | fails                             =
|
>>  |                                | -- btrfs_free_reserved_data_space =
|
>>  |                                | --- Clear EXTENT_QGROUP_RESERVED  =
|
>>  |                                |     file range [4096, 8191]       =
|
>>  |--------------------------------+-----------------------------------=
|
>>
>> On x86_64, It has been almost impossible to get the call to
>> btrfs_delalloc_reserve_metadata() in __btrfs_buffered_write() to fail.=
 Hence I
>> have the following change in __btrfs_buffered_write() ...
>=20
> Setting a qgroup limit makes it fail pretty reliably.  That's exactly
> the test case I used when tracking down problem described in "[PATCH]
> btrfs: Ensure proper sector alignment for btrfs_free_reserved_data_spac=
e"
>=20
> I think this is also the same issue described there -- write_bytes can
> be anything, but reserve_bytes is sector-aligned.

Actually, nevermind.  This is related, but not the same thing.  As you
mention later, having overlapping writes where the qgroup bits are
already set in one will cause problems.  The patch in the above post
ensures that we're releasing the correct number of bytes reserved in the
same call, but doesn't handle the case that the range was already set.

-Jeff

>> if (pos !=3D 2048)
>>    ret =3D btrfs_delalloc_reserve_metadata(inode, reserve_bytes);     =
                                                                         =
                                 =20
>> else                                                                  =
                                                                         =
                                    =20
>>    ret =3D 1;                                                         =
                                                                         =
                                 =20
>> if (ret) {                                                            =
                                                                         =
                                    =20
>>    if (!only_release_metadata)                                        =
                                                                         =
                               =20
>>         btrfs_free_reserved_data_space(inode, pos,                    =
                                                                         =
                            =20
>>                                        write_bytes);                  =
                                                                         =
                            =20
>>    else
>>         btrfs_end_write_no_snapshoting(root);
>>    break;                                                             =
                                                                         =
                               =20
>> }=20
>>
>>
>> With the above change and by using max_inline=3D0 mount option, the fo=
llowing
>> command line will reproduce the call trace on an x86_64 machine,
>> $ xfs_io -f -c 'pwrite -b 2048 0 8192' -c sync /mnt/file-0.bin
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--xetNtOBSFLpvAEFtacT14nnKILef7WBUk--

--eVlPA0thaPTKtqanKSHg12LOwwgVOE9OF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYPaZyAAoJEB57S2MheeWyAdoP/is174tarpWOfn1zVRLRPkso
IuP83ctl2ai6y6kONMMeJxgIcBpQ5uSWIc/GFsq0eVDOjiUWTtiiFUr04kiPzqYV
j678VHzkddSxvJkXgXf2seapFv/bLZrCfVuRTuaT+zlqN2zzqRyPwwW/RPDoJSpM
Nvq1F372wgPAqMVOjOBaQ8eF7flHjskKdSXtBrR/QUp8n8ARcoL4nQTK1Y3ku4Ts
2g8DPZGji527D9nbghPDPadIOgm8/dtQeF9yEIgusgdVJb7kxD63BCZdzbKKzStx
TAtthVQwn5zGa7WD9LoAyETgVr3AMBMf6+6UWihs9GxgIT+gn3mPno9QoFviNsju
k2RvH490Mo0GAgVhw21AmRmhPDW12sk0u10QhfR4XmFhtkKlMc/BotVyBkEZCwyC
tYuFwx+XSOLUewKO1d6VbSjB99cqATlHgnzn3QcwIf7TtqAUDCJ6VSWnUW/k50Pv
BctsRWUL6BBaOgWCRvRWnrhXkYBqd8EldODcGbwhNmuqmCANV0714trJToWi3ZzB
nRmBnm10khTfjO3rZNg+kJs6Sm+EFIHAKE13ghl8eRJjEcL5aObYVaIzi1L7yY6R
ebVMpJiI9wqszavly3Zzxw0feIseNQG0n8GZc6ZhM4r9zLPhqFIKtG18EXZMAb9C
k/gKZ9WhHf6MEpxQ0Ou0
=IcX0
-----END PGP SIGNATURE-----

--eVlPA0thaPTKtqanKSHg12LOwwgVOE9OF--
