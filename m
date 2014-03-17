Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mehl.schokokeks.org ([46.4.40.247]:59228 "EHLO
	mehl.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaCQGC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 02:02:58 -0400
Date: Mon, 17 Mar 2014 06:57:54 +0100
From: Florian Bruhin <me@the-compiler.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS critical / kernel BUG / high load
Message-ID: <20140317055754.GA21978@lupin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-26416-1395035876-0001-2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-26416-1395035876-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

on one of my servers running btrfs, I noticed a very high load of
26/26/26. After investigating further, this happened in my logs about
5 minutes before the monitoring alerted me because of the load:

    ------------[ cut here ]------------
    WARNING: CPU: 2 PID: 3046 at fs/btrfs/ctree.c:1321 btrfs_search_old_slo=
t+0x7c4/0x900 [btrfs]()
    Modules linked in: w83627ehf hwmon_vid intel_rapl x86_pkg_temp_thermal =
intel_powerclamp coretemp kvm_intel kvm btrfs i915 crct10dif_pclmul crct10d=
if_common crc32_pclmul video intel_agp raid6_pq li
    CPU: 2 PID: 3046 Comm: deluged Not tainted 3.13.6-1-ARCH #1
    Hardware name:                  /DH67BL, BIOS BLH6710H.86A.0160.2012.12=
04.1156 12/04/2012
     0000000000000009 ffff8800d2ecd9f0 ffffffff81513274 0000000000000000
     ffff8800d2ecda28 ffffffff81061a3d ffff880000000000 0000160000000000
     ffff88010c5b3400 ffff88011d63c460 ffff88010babf360 ffff8800d2ecda38
    Call Trace:
     [<ffffffff81513274>] dump_stack+0x4d/0x6f
     [<ffffffff81061a3d>] warn_slowpath_common+0x7d/0xa0
     [<ffffffff81061b1a>] warn_slowpath_null+0x1a/0x20
     [<ffffffffa05bfc74>] btrfs_search_old_slot+0x7c4/0x900 [btrfs]
     [<ffffffffa06375f7>] __resolve_indirect_refs+0x117/0x650 [btrfs]
     [<ffffffffa05fa07b>] ? release_extent_buffer+0x2b/0xd0 [btrfs]
     [<ffffffffa06383d6>] ? __add_missing_keys.isra.10+0x76/0x140 [btrfs]
     [<ffffffffa0638b1d>] find_parent_nodes+0x34d/0x6e0 [btrfs]
     [<ffffffffa0638f69>] btrfs_find_all_roots+0x99/0x100 [btrfs]
     [<ffffffffa05f90e0>] ? set_state_bits+0x80/0x80 [btrfs]
     [<ffffffffa06398ed>] iterate_extent_inodes+0x14d/0x320 [btrfs]
     [<ffffffffa05f90e0>] ? set_state_bits+0x80/0x80 [btrfs]
     [<ffffffffa0639b47>] iterate_inodes_from_logical+0x87/0xa0 [btrfs]
     [<ffffffffa0600a02>] extent_fiemap+0x282/0x5a0 [btrfs]
     [<ffffffffa05e5c10>] ? btrfs_get_extent+0x9a0/0x9a0 [btrfs]
     [<ffffffff81142000>] ? dirty_ratio_handler+0x10/0x50
     [<ffffffffa05e4cf5>] btrfs_fiemap+0x45/0x50 [btrfs]
     [<ffffffff811b5ef4>] do_vfs_ioctl+0x154/0x4c0
     [<ffffffff811b62e1>] SyS_ioctl+0x81/0xa0
     [<ffffffff815216ad>] system_call_fastpath+0x1a/0x1f
    ---[ end trace 62dcb7572bce3542 ]---
    BTRFS critical (device sda3): unable to find logical 20461224206336 len=
 4096
    ------------[ cut here ]------------
    kernel BUG at fs/btrfs/inode.c:1593!
    invalid opcode: 0000 [#1] PREEMPT SMP=20
    Modules linked in: w83627ehf hwmon_vid intel_rapl x86_pkg_temp_thermal =
intel_powerclamp coretemp kvm_intel kvm btrfs i915 crct10dif_pclmul crct10d=
if_common crc32_pclmul video intel_agp raid6_pq li
    CPU: 2 PID: 3046 Comm: deluged Tainted: G        W    3.13.6-1-ARCH #1
    Hardware name:                  /DH67BL, BIOS BLH6710H.86A.0160.2012.12=
04.1156 12/04/2012
    task: ffff88021205f500 ti: ffff8800d2ecc000 task.ti: ffff8800d2ecc000
    RIP: 0010:[<ffffffffa05e4828>]  [<ffffffffa05e4828>] btrfs_merge_bio_ho=
ok+0x78/0x80 [btrfs]
    RSP: 0018:ffff8800d2ecd6c8  EFLAGS: 00010282
    RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000006
    RDX: 0000000000000007 RSI: 0000000000000046 RDI: 0000000000000246
    RBP: ffff8800d2ecd6e0 R08: 0000000000000000 R09: 0000000000000414
    R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
    R13: 000000094e000018 R14: ffff880115aecba8 R15: ffff8802126b0040
    FS:  00007f60528ae700(0000) GS:ffff88021f300000(0000) knlGS:00000000000=
00000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f5e3258bd18 CR3: 0000000212996000 CR4: 00000000000407e0
    Stack:
     0000000000001000 ffff8800d2ecd8f0 0000000000001000 ffff8800d2ecd730
     ffffffffa05fc5c9 0000002000000000 0000000000000000 ffffea0004499400
     000000094e000018 0000000000000000 0000000000000000 0000000000001000
    Call Trace:
     [<ffffffffa05fc5c9>] submit_extent_page.isra.37+0x149/0x1d0 [btrfs]
     [<ffffffffa05fc877>] __do_readpage+0x227/0x760 [btrfs]
     [<ffffffffa05fdfa0>] ? repair_eb_io_failure+0xd0/0xd0 [btrfs]
     [<ffffffffa05d8370>] ? free_root_pointers+0x60/0x60 [btrfs]
     [<ffffffffa05fce75>] __extent_read_full_page+0xc5/0xe0 [btrfs]
     [<ffffffffa05d8370>] ? free_root_pointers+0x60/0x60 [btrfs]
     [<ffffffffa05d8370>] ? free_root_pointers+0x60/0x60 [btrfs]
     [<ffffffffa0600593>] read_extent_buffer_pages+0x223/0x300 [btrfs]
     [<ffffffffa05d8370>] ? free_root_pointers+0x60/0x60 [btrfs]
     [<ffffffffa05d9fc3>] btree_read_extent_buffer_pages.constprop.52+0xb3/=
0x120 [btrfs]
     [<ffffffffa05da5c6>] read_tree_block+0x46/0x80 [btrfs]
     [<ffffffffa05bcda8>] read_block_for_search.isra.32+0x148/0x380 [btrfs]
     [<ffffffff81061a4f>] ? warn_slowpath_common+0x8f/0xa0
     [<ffffffffa05bf777>] btrfs_search_old_slot+0x2c7/0x900 [btrfs]
     [<ffffffffa06375f7>] __resolve_indirect_refs+0x117/0x650 [btrfs]
     [<ffffffffa05fa07b>] ? release_extent_buffer+0x2b/0xd0 [btrfs]
     [<ffffffffa06383d6>] ? __add_missing_keys.isra.10+0x76/0x140 [btrfs]
     [<ffffffffa0638b1d>] find_parent_nodes+0x34d/0x6e0 [btrfs]
     [<ffffffffa0638f69>] btrfs_find_all_roots+0x99/0x100 [btrfs]
     [<ffffffffa05f90e0>] ? set_state_bits+0x80/0x80 [btrfs]
     [<ffffffffa06398ed>] iterate_extent_inodes+0x14d/0x320 [btrfs]
     [<ffffffffa05f90e0>] ? set_state_bits+0x80/0x80 [btrfs]
     [<ffffffffa0639b47>] iterate_inodes_from_logical+0x87/0xa0 [btrfs]
     [<ffffffffa0600a02>] extent_fiemap+0x282/0x5a0 [btrfs]
     [<ffffffffa05e5c10>] ? btrfs_get_extent+0x9a0/0x9a0 [btrfs]
     [<ffffffff81142000>] ? dirty_ratio_handler+0x10/0x50
     [<ffffffffa05e4cf5>] btrfs_fiemap+0x45/0x50 [btrfs]
     [<ffffffff811b5ef4>] do_vfs_ioctl+0x154/0x4c0
     [<ffffffff811b62e1>] SyS_ioctl+0x81/0xa0
     [<ffffffff815216ad>] system_call_fastpath+0x1a/0x1f
    Code: c9 45 31 c0 89 fe 48 89 c7 4c 89 65 e8 e8 f1 3f 02 00 85 c0 78 15=
 4c 01 e3 31 c0 48 3b 5d e8 0f 97 c0 48 83 c4 08 5b 41 5c 5d c3 <0f> 0b 66 =
0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 57 49
    RIP  [<ffffffffa05e4828>] btrfs_merge_bio_hook+0x78/0x80 [btrfs]
     RSP <ffff8800d2ecd6c8>
    ---[ end trace 62dcb7572bce3543 ]---

So basically after that happened, my load stayed high, so probably
something went berzerk.

After a reboot everything seems to work nice again, except I get some
of these errors in my logs:

    BTRFS error (device sda3): block group 2346155245568 has wrong amount o=
f free space
    BTRFS error (device sda3): failed to load free space cache for block gr=
oup 2346155245568

I'm running on an Archlinux on kernel 3.13.6.

Is this a bug? What should I do now? I'm currently running a scrub to
see if everything is fine.

If you need anything else to help, please let me know. Also please Cc
me on replies as I'm not subscribed to the list. Thanks!

Florian

--=20
() ascii ribbon campaign - stop html mail    www.asciiribbon.org
/\ www.the-compiler.org  | I love long mails http://email.is-not-s.ms/
It is now pitch dark. If you proceed, you will likely fall into a pit.=20

--=_mehl.schokokeks.org-26416-1395035876-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJo7iAAoJEJFusMj9VaByWngP/iIZhxwuJ8cpDzAUFTJVMEvh
NwfgPLMzYHs82BzrQNn49YlMaTq8ompVxODXVwMJe9HKYxNeFOB7j2TFEKKg9cvK
9+o+E5vWGi2nlAk62bcBP4NLzy/c5k9gdPtQ0gvz5w/jgp2bL685Fb8xblsNnjjR
Njmsr0ab3QirYhXSDLpSNWWszdaNK8O0T2hppBUvt6RLQoqjmyA5uco3QlpkTvtf
DAB8ZfJQLhyXUzlfhjNbE2DdYJjOIg4zcOZ/T26M1q4GgoaW4Xo2KwfJnpv1aZqr
qc/qkBcdZewDFm5x7R3BIySBm+VgdZzE+kvhsjDa34zR0OM2VKepx3e4st5UIX+W
oo92WIMFTx9dR3WaI9P/IIHhK3hFfj3LJioVpYTVm1Lay5kXcVnHNjq1fk7IAbDT
xdkvhoz/rdwsRXYMX+kmJ0PxXzUYlVermutBIrfoz+8iplXrSmeKBc003QxeSh2r
eWYS5B3oo1b711czYkMy+mZgeRdyiDgX5qZABSdHu/QjN9KUjwla3h7/FuvTkwOd
wNvWtN5kGBiBTwFgYhYkKvthTBygJTJSzRyQLajBBIzRrsGnrYXmJ7Q5pXGK0jCS
1udinyG6QrSs5cr0izZOtZc0JYKI3fVgGTHz7oUr7yCPo/aGo3FzQZL/4btB8QG0
KQrtYvyYeC348lofpbxM
=nM3z
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-26416-1395035876-0001-2--
