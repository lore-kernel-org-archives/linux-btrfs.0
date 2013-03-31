Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:34207 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab3CaWgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 18:36:10 -0400
Received: from natsu (unknown [IPv6:fd39::1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 05435220BE
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 22:36:07 +0000 (UTC)
Date: Mon, 1 Apr 2013 04:36:05 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already
 exists
Message-ID: <20130401043605.2eb250a7@natsu>
In-Reply-To: <20130401041540.4b8a4ab3@natsu>
References: <20130401041540.4b8a4ab3@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oLG/OXBmxQekKawF6aBPKWg"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/oLG/OXBmxQekKawF6aBPKWg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

After a reboot the filesystem now does not mount at all, with similar messa=
ges.

[   66.874267] Btrfs loaded
[   66.876222] device label p2 devid 1 transid 22985 /dev/sda2
[   66.878175] btrfs: use lzo compression
[   66.878185] btrfs: disk space caching is enabled
[   79.112680] ------------[ cut here ]------------
[   79.112713] WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0=
xdf/0x100 [btrfs]()
[   79.112717] Hardware name: KS
[   79.112721] btrfs: Transaction aborted
[   79.112724] Modules linked in: btrfs(F) zlib_deflate(F) libcrc32c(F) nf_=
conntrack_ipv6(F) nf_defrag_ipv6(F) ip6t_REJECT(F) ip6table_filter(F) ip6_t=
ables(F) ipt_REJECT(F) xt_tcpudp(F) xt_state(F) xt_limit(F) iptable_nat(F) =
nf_conntrack_ipv4(F) nf_defrag_ipv4(F) nf_nat_ipv4(F) nf_nat(F) nf_conntrac=
k(F) iptable_filter(F) ip_tables(F) x_tables(F) w83627ehf(F) hwmon_vid(F) c=
oretemp(F) gpio_ich(F) i915(F) snd_pcm(F) snd_timer(F) tpm_tis(F) drm_kms_h=
elper(F) microcode(F) snd(F) soundcore(F) drm(F) snd_page_alloc(F) psmouse(=
F) pcspkr(F) r8169(F) mac_hid(F) i2c_algo_bit(F) i2c_i801(F) serio_raw(F) l=
pc_ich(F) video(F)
[   79.112793] Pid: 1037, comm: mount Tainted: GF            3.8.5-gnu #1
[   79.112796] Call Trace:
[   79.112810]  [<ffffffff81058bef>] warn_slowpath_common+0x7f/0xc0
[   79.112818]  [<ffffffff81058ce6>] warn_slowpath_fmt+0x46/0x50
[   79.112848]  [<ffffffffa028db37>] ? free_extent_buffer+0x37/0x90 [btrfs]
[   79.112870]  [<ffffffffa024701f>] __btrfs_abort_transaction+0xdf/0x100 [=
btrfs]
[   79.112893]  [<ffffffffa0253d8c>] ? insert_tree_block_ref+0x4c/0x70 [btr=
fs]
[   79.112916]  [<ffffffffa0256908>] __btrfs_inc_extent_ref+0x1b8/0x200 [bt=
rfs]
[   79.112947]  [<ffffffffa02b20d9>] ? btrfs_merge_delayed_refs+0x289/0x300=
 [btrfs]
[   79.112971]  [<ffffffffa025c87e>] run_clustered_refs+0x9ce/0xae0 [btrfs]
[   79.112994]  [<ffffffffa024a8bd>] ? btrfs_put_tree_mod_seq+0x10d/0x150 [=
btrfs]
[   79.113018]  [<ffffffffa02602c0>] btrfs_run_delayed_refs+0xd0/0x2f0 [btr=
fs]
[   79.113045]  [<ffffffffa0270987>] __btrfs_end_transaction+0xf7/0x410 [bt=
rfs]
[   79.113072]  [<ffffffffa0270cd3>] btrfs_end_transaction_throttle+0x13/0x=
20 [btrfs]
[   79.113102]  [<ffffffffa02b8f34>] merge_reloc_root+0x274/0x500 [btrfs]
[   79.113125]  [<ffffffffa024a32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   79.113155]  [<ffffffffa02b92d8>] merge_reloc_roots+0x118/0x150 [btrfs]
[   79.113186]  [<ffffffffa02ba22b>] btrfs_recover_relocation+0x3ab/0x400 [=
btrfs]
[   79.113212]  [<ffffffffa026e472>] open_ctree+0x1c52/0x1d70 [btrfs]
[   79.113235]  [<ffffffffa0246bbb>] btrfs_mount+0x57b/0x670 [btrfs]
[   79.113245]  [<ffffffff8119aa53>] mount_fs+0x43/0x1b0
[   79.113252]  [<ffffffff811b5226>] vfs_kern_mount+0x76/0x120
[   79.113260]  [<ffffffff811b748d>] do_mount+0x1fd/0xa40
[   79.113267]  [<ffffffff811b70fa>] ? copy_mount_options+0x3a/0x180
[   79.113274]  [<ffffffff811b7d60>] sys_mount+0x90/0xe0
[   79.113283]  [<ffffffff816dbe1d>] system_call_fastpath+0x1a/0x1f
[   79.113288] ---[ end trace abe4f5e37903fe08 ]---
[   79.113294] BTRFS error (device sda2) in __btrfs_inc_extent_ref:1935: Ob=
ject already exists
[   79.115793] ------------[ cut here ]------------
[   79.116014] Kernel BUG at ffffffffa02b8dbe [verbose debug info unavailab=
le]
[   79.116014] invalid opcode: 0000 [#1] SMP=20
[   79.116014] Modules linked in: btrfs(F) zlib_deflate(F) libcrc32c(F) nf_=
conntrack_ipv6(F) nf_defrag_ipv6(F) ip6t_REJECT(F) ip6table_filter(F) ip6_t=
ables(F) ipt_REJECT(F) xt_tcpudp(F) xt_state(F) xt_limit(F) iptable_nat(F) =
nf_conntrack_ipv4(F) nf_defrag_ipv4(F) nf_nat_ipv4(F) nf_nat(F) nf_conntrac=
k(F) iptable_filter(F) ip_tables(F) x_tables(F) w83627ehf(F) hwmon_vid(F) c=
oretemp(F) gpio_ich(F) i915(F) snd_pcm(F) snd_timer(F) tpm_tis(F) drm_kms_h=
elper(F) microcode(F) snd(F) soundcore(F) drm(F) snd_page_alloc(F) psmouse(=
F) pcspkr(F) r8169(F) mac_hid(F) i2c_algo_bit(F) i2c_i801(F) serio_raw(F) l=
pc_ich(F) video(F)
[   79.116014] CPU 1=20
[   79.116014] Pid: 1037, comm: mount Tainted: GF       W    3.8.5-gnu #1 O=
VH KS/D425KT
[   79.116014] RIP: 0010:[<ffffffffa02b8dbe>]  [<ffffffffa02b8dbe>] merge_r=
eloc_root+0xfe/0x500 [btrfs]
[   79.116014] RSP: 0018:ffff88011eef1a08  EFLAGS: 00010202
[   79.116014] RAX: ffffffffffffffef RBX: ffff8801204e6ea0 RCX: 00000000000=
00064
[   79.116014] RDX: 0000000000000063 RSI: ffff8801205ba980 RDI: 00000000000=
1bdc0
[   79.116014] RBP: ffff88011eef1ac8 R08: ffffea0004816e80 R09: 00000000000=
00000
[   79.116014] R10: 0000000000000000 R11: ffffffff81850668 R12: ffff88011ff=
24800
[   79.116014] R13: ffffffffffffffef R14: ffff88012765f800 R15: ffff880127c=
bf000
[   79.116014] FS:  00007f0025e1c7e0(0000) GS:ffff88012fc80000(0000) knlGS:=
0000000000000000
[   79.116014] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   79.116014] CR2: ffffffffff600400 CR3: 000000011edf9000 CR4: 00000000000=
007e0
[   79.116014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   79.116014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[   79.116014] Process mount (pid: 1037, threadinfo ffff88011eef0000, task =
ffff880129311740)
[   79.116014] Stack:
[   79.116014]  ffff880100000002 ffffffffa024a32a ffff88012765f000 00000000=
00000000
[   79.116014]  000000021eef1ac8 0000e00000000001 ffff88011eef1a48 000774ff=
81350f5b
[   79.116014]  00006c0000000000 080d000000000068 006c000000000000 74000000=
003cba70
[   79.116014] Call Trace:
[   79.116014]  [<ffffffffa024a32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   79.116014]  [<ffffffffa02b92d8>] merge_reloc_roots+0x118/0x150 [btrfs]
[   79.116014]  [<ffffffffa02ba22b>] btrfs_recover_relocation+0x3ab/0x400 [=
btrfs]
[   79.116014]  [<ffffffffa026e472>] open_ctree+0x1c52/0x1d70 [btrfs]
[   79.116014]  [<ffffffffa0246bbb>] btrfs_mount+0x57b/0x670 [btrfs]
[   79.116014]  [<ffffffff8119aa53>] mount_fs+0x43/0x1b0
[   79.116014]  [<ffffffff811b5226>] vfs_kern_mount+0x76/0x120
[   79.116014]  [<ffffffff811b748d>] do_mount+0x1fd/0xa40
[   79.116014]  [<ffffffff811b70fa>] ? copy_mount_options+0x3a/0x180
[   79.116014]  [<ffffffff811b7d60>] sys_mount+0x90/0xe0
[   79.116014]  [<ffffffff816dbe1d>] system_call_fastpath+0x1a/0x1f
[   79.116014] Code: 00 00 4c 89 f7 49 89 45 40 49 8b 74 24 18 e8 6a 1d fa =
ff 85 c0 74 16 83 f8 f5 75 0f 4c 89 f6 4c 89 ef e8 b6 6f fb ff 85 c0 74 b2 =
<0f> 0b 8b 45 cc 48 8d 55 cc 48 89 de 4c 89 ff 89 85 64 ff ff ff=20
[   79.116014] RIP  [<ffffffffa02b8dbe>] merge_reloc_root+0xfe/0x500 [btrfs]
[   79.116014]  RSP <ffff88011eef1a08>
[   79.264721] ---[ end trace abe4f5e37903fe09 ]---

--=20
With respect,
Roman

--Sig_/oLG/OXBmxQekKawF6aBPKWg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFYulUACgkQTLKSvz+PZwhFKQCdEyBFk8BNBb5WvHAMkV/QA29q
m04AniBrThXP30zKfUMdSCrEn4NwK2/R
=XYE6
-----END PGP SIGNATURE-----

--Sig_/oLG/OXBmxQekKawF6aBPKWg--
