Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50640 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753402AbeAOAsf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 19:48:35 -0500
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
Date: Mon, 15 Jan 2018 08:48:26 +0800
MIME-Version: 1.0
In-Reply-To: <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f05Et8slXFVUdqS0nR5IyTU33YuBa7kLC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f05Et8slXFVUdqS0nR5IyTU33YuBa7kLC
Content-Type: multipart/mixed; boundary="Eqndj8fVvWfJEDPn4mejQoKEl1hj8el45";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
 <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
 <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>
In-Reply-To: <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com>

--Eqndj8fVvWfJEDPn4mejQoKEl1hj8el45
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8815=E6=97=A5 04:17, Johannes Ernst wrote:
>> On Jan 13, 2018, at 18:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 09:36, Johannes Ernst wrote:
>>> Summary: frequent =E2=80=9Changs=E2=80=9D of the system with dmesg sa=
ying:
>>>
>>> task systemd:22229 blocked for more than 120 seconds.
>>> [ 2948.928653]       Tainted: G         C O    4.14.9-1-ARCH #1
>>> [ 2948.928658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
>>> [ 2948.928665] systemd         D    0 22229  22226 0x00000100
>>> [ 2948.928671] Call Trace:
>>> [ 2948.928684]  ? __schedule+0x290/0x890
>>> [ 2948.928690]  schedule+0x2f/0x90
>>> [ 2948.928744]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
>>> [ 2948.928752]  ? wait_woken+0x80/0x80
>>> [ 2948.928799]  find_parent_nodes+0x341/0xfd0 [btrfs]
>>> [ 2948.928827]  ? btrfs_search_slot+0x84c/0x9f0 [btrfs]
>>> [ 2948.928873]  ? btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
>>> [ 2948.928912]  btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
>>> [ 2948.928950]  btrfs_find_all_roots+0x45/0x60 [btrfs]
>>> [ 2948.928987]  btrfs_qgroup_trace_extent_post+0x30/0x60 [btrfs]
>>
>> You're using qgroup, and the timing is to find the old_roots of one
>> extent, which will only search commit roots.
>>
>> Normally this shouldn't cause any problem, especially for commit roots=
=2E
>>
>> Is there any special operation happening?
>=20
> Nope. It appears it happens right when systemd-nspawn begins to run and=
 I am not executing any other commands.
>=20
> I did not realize qgroups are involved =E2=80=A6 all I did is mkfs.btrf=
s and running systemd-nspawn :-) Perhaps the defaults should be qgroups o=
ff? (But I digress)
>=20
>>> That works well =E2=80=A6 but not for long. Often we don=E2=80=99t ma=
ke it through the test suite and the starting of new containers hangs. Ot=
her filesystem operations also hang. The above stacktrace, or something r=
ather similar shows up in dmesg (not in the journal, because that hangs, =
too!) This is repeated, but I don=E2=80=99t see any other relevant messag=
es. Only a reboot seems to allows to recover.
>>
>> So Qgroup is used to limit disk usage of each container?
>>
>> Maybe it's related to subvolume deletion?
>>
>> Anyway, if qgroup is not necessary, disabling qgroup should fix your
>> problem.
>>
>> Despite of that, did that really hangs?
>> Qgroup dramatically increase overhead to delete a subvolume or balance=

>> the fs.
>> Maybe it's just a little slow?
>=20
> I have waited for several hours and the system has not recovered (me wa=
lking away from the running tests, returning hours later).
>=20
> Update: so I executed "btrfs quota disable=E2=80=9D on all relevant fil=
e systems. (right?) Running tests again, this morning I=E2=80=99m getting=
:

So not a bug for quota. (At least I have less thing to worry about)

>=20
> INFO: task systemd-journal:20876 blocked for more than 120 seconds.
> [ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
> [ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> [ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
> [ 5037.962622] Call Trace:
> [ 5037.962635]  ? __schedule+0x290/0x890
> [ 5037.962640]  ? __slab_free+0x14e/0x300
> [ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
> [ 5037.962651]  schedule+0x2f/0x90
> [ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]

Still some tree write is blocking all incoming read.

BTW, did your tests include any send and relocation operations?

IIRC there is a bug that makes send and relocation (I'm not sure though)
will cause similar problem.

Thanks,
Qu

> [ 5037.962713]  ? wait_woken+0x80/0x80
> [ 5037.962739]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> [ 5037.962767]  btrfs_search_slot+0x703/0x9f0 [btrfs]
> [ 5037.962796]  btrfs_insert_empty_items+0x66/0xb0 [btrfs]
> [ 5037.962841]  btrfs_insert_orphan_item+0x66/0xa0 [btrfs]
> [ 5037.962880]  btrfs_orphan_add+0xa1/0x200 [btrfs]
> [ 5037.962919]  btrfs_setattr+0x123/0x3b0 [btrfs]
> [ 5037.962926]  notify_change+0x2fd/0x420
> [ 5037.962933]  do_truncate+0x75/0xc0
> [ 5037.962940]  do_sys_ftruncate.constprop.19+0xe7/0x100
> [ 5037.962947]  do_syscall_64+0x55/0x110
> [ 5037.962952]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 5037.962956] RIP: 0033:0x7fd9423697ba
> [ 5037.962958] RSP: 002b:00007fff1179cc18 EFLAGS: 00000206 ORIG_RAX: 00=
0000000000004d
> [ 5037.962962] RAX: ffffffffffffffda RBX: 000055bd48cbe9f0 RCX: 00007fd=
9423697ba
> [ 5037.962965] RDX: 000055bd48cbe660 RSI: 0000000000640000 RDI: 0000000=
00000000f
> [ 5037.962966] RBP: 00007fff1179cc50 R08: 000055bd48cbc62c R09: 000055b=
d48cbea6c
> [ 5037.962968] R10: 000055bd48cbe9f0 R11: 0000000000000206 R12: 00007ff=
f1179cc48
> [ 5037.962970] R13: 0000000000000003 R14: 000562b7234e71a9 R15: 000055b=
d47749ca0
>=20
> and doing a simple =E2=80=9Ctouch /build/tmp/foo=E2=80=9D never returns=
=2E 10+ hours have passed since the previous command was issued.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Eqndj8fVvWfJEDPn4mejQoKEl1hj8el45--

--f05Et8slXFVUdqS0nR5IyTU33YuBa7kLC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpb+loXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh0YAf/Qg2vLnxiXVja2KO3kwIW4DAl
ewT+qmob65JbfcKwO8YYgHC9zPc0Y8Wdn9GAAjxy6q/iP+NvbYWWBRX/1Axv0VEf
U1yIrW/j4DEMcdlQxKYS2jRzZqXbAK/ETdXfnlYbJgUbyCpRhzg+zjJt/SUkwNsn
ITxv67y8tiRTvuL2zcdMwIN07MJ2qNQIuLy6QP5SFG7h8r/Gp4GVCDobGVgO3BpL
AFs8A8SCEMajYiAbUWBHjn66iVV5eYZxDCtlewhn9spOEyLXMyE0sPgxC/JhFmfE
SDHPlA/u3ClS7axp//ldfXLUpAsosPpAFb6reor0ovM4oL/CQK8aHvJ74ybIUg==
=2KEt
-----END PGP SIGNATURE-----

--f05Et8slXFVUdqS0nR5IyTU33YuBa7kLC--
