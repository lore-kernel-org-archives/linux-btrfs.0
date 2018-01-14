Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64314 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754654AbeANC1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Jan 2018 21:27:47 -0500
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
Date: Sun, 14 Jan 2018 10:27:40 +0800
MIME-Version: 1.0
In-Reply-To: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l4ROQoR7E5aVR5qI5h6EFEiQ0kOzDDo4t"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l4ROQoR7E5aVR5qI5h6EFEiQ0kOzDDo4t
Content-Type: multipart/mixed; boundary="Th8SOFUquZc7TYu6WRHOP0MLA7o3fxXOg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Ernst <johannes.ernst@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com>
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>
In-Reply-To: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com>

--Th8SOFUquZc7TYu6WRHOP0MLA7o3fxXOg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8814=E6=97=A5 09:36, Johannes Ernst wrote:
> Summary: frequent =E2=80=9Changs=E2=80=9D of the system with dmesg sayi=
ng:
>=20
> task systemd:22229 blocked for more than 120 seconds.
> [ 2948.928653]       Tainted: G         C O    4.14.9-1-ARCH #1
> [ 2948.928658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> [ 2948.928665] systemd         D    0 22229  22226 0x00000100
> [ 2948.928671] Call Trace:
> [ 2948.928684]  ? __schedule+0x290/0x890
> [ 2948.928690]  schedule+0x2f/0x90
> [ 2948.928744]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
> [ 2948.928752]  ? wait_woken+0x80/0x80
> [ 2948.928799]  find_parent_nodes+0x341/0xfd0 [btrfs]
> [ 2948.928827]  ? btrfs_search_slot+0x84c/0x9f0 [btrfs]
> [ 2948.928873]  ? btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
> [ 2948.928912]  btrfs_find_all_roots_safe+0x9e/0x110 [btrfs]
> [ 2948.928950]  btrfs_find_all_roots+0x45/0x60 [btrfs]
> [ 2948.928987]  btrfs_qgroup_trace_extent_post+0x30/0x60 [btrfs]

You're using qgroup, and the timing is to find the old_roots of one
extent, which will only search commit roots.

Normally this shouldn't cause any problem, especially for commit roots.

Is there any special operation happening?

> [ 2948.929026]  btrfs_add_delayed_tree_ref+0x1db/0x200 [btrfs]
> [ 2948.929055]  btrfs_inc_extent_ref+0xa6/0xe0 [btrfs]
> [ 2948.929084]  __btrfs_mod_ref+0x144/0x230 [btrfs]
> [ 2948.929110]  ? add_pinned_bytes+0x40/0x40 [btrfs]
> [ 2948.929136]  update_ref_for_cow+0xd2/0x320 [btrfs]
> [ 2948.929161]  __btrfs_cow_block+0x1f9/0x5b0 [btrfs]
> [ 2948.929187]  btrfs_cow_block+0xca/0x1c0 [btrfs]
> [ 2948.929212]  btrfs_search_slot+0x321/0x9f0 [btrfs]
> [ 2948.929239]  btrfs_insert_empty_items+0x66/0xb0 [btrfs]
> [ 2948.929271]  insert_with_overflow+0x44/0x110 [btrfs]
> [ 2948.929303]  btrfs_insert_dir_item+0xcd/0x280 [btrfs]
> [ 2948.929342]  btrfs_add_link+0xe8/0x430 [btrfs]
> [ 2948.929349]  ? getnstimeofday64+0xa/0x20
> [ 2948.929384]  btrfs_mkdir+0x1d3/0x210 [btrfs]
> [ 2948.929392]  vfs_mkdir+0xd7/0x140
> [ 2948.929397]  SyS_mkdir+0x7a/0xf0
> [ 2948.929404]  do_syscall_64+0x55/0x110
> [ 2948.929409]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 2948.929413] RIP: 0033:0x7f8735697687
> [ 2948.929415] RSP: 002b:00007ffc8e72d028 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000053
> [ 2948.929419] RAX: ffffffffffffffda RBX: 000000000003a2f8 RCX: 00007f8=
735697687
> [ 2948.929421] RDX: 0000000000000156 RSI: 00000000000001c0 RDI: 0000561=
976693a80
> [ 2948.929423] RBP: 0000000000000001 R08: 000056197666b880 R09: 0000561=
974c0f734
> [ 2948.929425] R10: 00007ffc8e72d030 R11: 0000000000000246 R12: 0000561=
976693a80
> [ 2948.929427] R13: 0000561976693ad3 R14: 00007f8735732f80 R15: 8421084=
210842109
>=20
>=20
> Detail:
>=20
> I build a Linux distro called UBOS [1]. For testing purposes, we boot U=
BOS in a systemd-nspawn container, do some automated tests, and poweroff =
the container. A few dozen of those tests can happen in rapid succession =
(but not in parallel).=20
>=20
> We run systemd-nspawn with the =E2=80=94ephemeral flag in some director=
y on a btrfs filesystem, which causes systemd to allocate a temporary sub=
volume that goes away again when the container quits, leaving the filesys=
tem unchanged (this is very handy for testing purposes).
>=20
> That works well =E2=80=A6 but not for long. Often we don=E2=80=99t make=
 it through the test suite and the starting of new containers hangs. Othe=
r filesystem operations also hang. The above stacktrace, or something rat=
her similar shows up in dmesg (not in the journal, because that hangs, to=
o!) This is repeated, but I don=E2=80=99t see any other relevant messages=
=2E Only a reboot seems to allows to recover.

So Qgroup is used to limit disk usage of each container?

Maybe it's related to subvolume deletion?

Anyway, if qgroup is not necessary, disabling qgroup should fix your
problem.

Despite of that, did that really hangs?
Qgroup dramatically increase overhead to delete a subvolume or balance
the fs.
Maybe it's just a little slow?

Thanks,
Qu

>=20
> This happens on two-disk RAID1 as well as one-disk systems, and it happ=
ens on x86_64, armv6, armv7 and aarch64. So it does not seem to have anyt=
hing to do with any particular disk or filesystem. The disks have plenty =
of space. aIt has been the same behavior for some time, so it=E2=80=99s n=
ot a recent problem. UBOS is a derivative of Arch, so it=E2=80=99s fairly=
 current in terms of code. Current kernel versions are 4.14.x on all plat=
forms.
>=20
> Any idea what this might be or how to debug this?=20
>=20
> Thanks,
>=20
>=20
>=20
> Johannes.
>=20
>=20
> [1] https://ubos.net/
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Th8SOFUquZc7TYu6WRHOP0MLA7o3fxXOg--

--l4ROQoR7E5aVR5qI5h6EFEiQ0kOzDDo4t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpawBwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj76wf+OxR2OxH+ibY98i0TZFww1bZO
NV8yVQReC7D31ZoATkC0AJ1hH8nnL6+Mqme/DJ4rFS2HtkYZiWpL+Ei3F9f3lZmQ
qtNlsh2C11PoD/QmQ3/oLP53s3Wv68yxlNMLuAIPp/9yTcY10b1IiteJnIuKfZ+K
czQFllu6MkYdCuvxg2E2gLGTX7EUwcp6xF4RliTaE4+yntlWEt1nybURZSsaIJAk
e4oX/7jvrgdJmPZx2c+yBfocLRAfyh9rT7mc66YKirYnn7edyzNJdjQ6xFQJgvm6
A5Rt5NoVcPwAn2yGeS4uSP6sw3HCiISdhfZZcYuqNXy9042kHJ6nvPDyVJNnRQ==
=1JkN
-----END PGP SIGNATURE-----

--l4ROQoR7E5aVR5qI5h6EFEiQ0kOzDDo4t--
