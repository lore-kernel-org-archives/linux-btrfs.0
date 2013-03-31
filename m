Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:60897 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab3CaWPo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 18:15:44 -0400
Received: from natsu (unknown [IPv6:fd39::1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 25F0A20391
	for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 22:15:43 +0000 (UTC)
Date: Mon, 1 Apr 2013 04:15:40 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
Message-ID: <20130401041540.4b8a4ab3@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2VarLmX57t.nokie_wrFUNj"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/2VarLmX57t.nokie_wrFUNj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Trying to balance a 2TB filesystem on the 3.8.5 kernel:

Label: 'p2'  uuid: 01f6cc8b-d305-40e1-bac8-8fdd548f611e
	Total devices 1 FS bytes used 1.32TB
	devid    1 size 1.80TB used 1.37TB path /dev/sda2

System: total=3D4.00MB, used=3D156.00KB
Data+Metadata: total=3D1.37TB, used=3D1.32TB

I am getting a Segmentation fault in 'btrfs' utility, and following in dmes=
g.
What is the problem here?

[12259.667681] btrfs: relocating block group 246973202432 flags 5
[12274.481651] btrfs: found 80 extents
[12284.273736] btrfs: found 1 extents
[12290.803209] btrfs: relocating block group 245899460608 flags 5
[12298.070756] btrfs: found 48 extents
[12304.272924] btrfs: relocating block group 244825718784 flags 5
[12318.361116] btrfs: found 511 extents
[12327.932489] btrfs: found 6 extents
[12335.071480] btrfs: relocating block group 243751976960 flags 5
[12346.588372] btrfs: found 221 extents
[12357.535910] btrfs: found 2 extents
[12363.295088] btrfs: relocating block group 242678235136 flags 5
[12377.999629] btrfs: found 67 extents
[12389.909611] btrfs: found 8 extents
[12397.101725] btrfs: relocating block group 241604493312 flags 5
[12411.303919] btrfs: found 94 extents
[12418.516308] btrfs: relocating block group 240530751488 flags 5
[12432.028091] btrfs: found 176 extents
[12439.785920] btrfs: relocating block group 239457009664 flags 5
[12451.489826] ------------[ cut here ]------------
[12451.489873] WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0=
xdf/0x100 [btrfs]()
[12451.489880] Hardware name: KS
[12451.489885] btrfs: Transaction aborted
[12451.489890] Modules linked in: nf_conntrack_ipv6(F) nf_defrag_ipv6(F) ip=
6t_REJECT(F) ip6table_filter(F) ip6_tables(F) ipt_REJECT(F) xt_tcpudp(F) xt=
_state(F) xt_limit(F) iptable_nat(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F)=
 nf_nat_ipv4(F) nf_nat(F) nf_conntrack(F) iptable_filter(F) ip_tables(F) x_=
tables(F) btrfs(F) zlib_deflate(F) libcrc32c(F) w83627ehf(F) hwmon_vid(F) c=
oretemp(F) gpio_ich(F) snd_pcm(F) i915(F) snd_timer(F) snd(F) soundcore(F) =
snd_page_alloc(F) microcode(F) psmouse(F) tpm_tis(F) drm_kms_helper(F) pcsp=
kr(F) serio_raw(F) drm(F) lpc_ich(F) i2c_i801(F) r8169(F) i2c_algo_bit(F) m=
ac_hid(F) video(F)
[12451.489981] Pid: 1053, comm: btrfs Tainted: GF            3.8.5-gnu #1
[12451.489987] Call Trace:
[12451.490006]  [<ffffffff81058bef>] warn_slowpath_common+0x7f/0xc0
[12451.490020]  [<ffffffff81058ce6>] warn_slowpath_fmt+0x46/0x50
[12451.490064]  [<ffffffffa0220b37>] ? free_extent_buffer+0x37/0x90 [btrfs]
[12451.490098]  [<ffffffffa01da01f>] __btrfs_abort_transaction+0xdf/0x100 [=
btrfs]
[12451.490204]  [<ffffffffa01e6d8c>] ? insert_tree_block_ref+0x4c/0x70 [btr=
fs]
[12451.490295]  [<ffffffffa01e9908>] __btrfs_inc_extent_ref+0x1b8/0x200 [bt=
rfs]
[12451.490337]  [<ffffffffa02450d9>] ? btrfs_merge_delayed_refs+0x289/0x300=
 [btrfs]
[12451.490408]  [<ffffffffa01ef87e>] run_clustered_refs+0x9ce/0xae0 [btrfs]
[12451.490438]  [<ffffffffa01dd8bd>] ? btrfs_put_tree_mod_seq+0x10d/0x150 [=
btrfs]
[12451.490470]  [<ffffffffa01f32c0>] btrfs_run_delayed_refs+0xd0/0x2f0 [btr=
fs]
[12451.490504]  [<ffffffffa0203987>] __btrfs_end_transaction+0xf7/0x410 [bt=
rfs]
[12451.490538]  [<ffffffffa0203cd3>] btrfs_end_transaction_throttle+0x13/0x=
20 [btrfs]
[12451.490576]  [<ffffffffa024bf34>] merge_reloc_root+0x274/0x500 [btrfs]
[12451.490606]  [<ffffffffa01dd32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[12451.490698]  [<ffffffffa024c2d8>] merge_reloc_roots+0x118/0x150 [btrfs]
[12451.490741]  [<ffffffffa024c91b>] relocate_block_group+0x3db/0x640 [btrf=
s]
[12451.490784]  [<ffffffffa024cd45>] btrfs_relocate_block_group+0x1c5/0x300=
 [btrfs]
[12451.490825]  [<ffffffffa02250b5>] btrfs_relocate_chunk.isra.54+0x75/0x73=
0 [btrfs]
[12451.490864]  [<ffffffffa021b5e1>] ? release_extent_buffer.isra.26+0x81/0=
xf0 [btrfs]
[12451.490904]  [<ffffffffa0220b37>] ? free_extent_buffer+0x37/0x90 [btrfs]
[12451.490945]  [<ffffffffa02294d7>] btrfs_balance+0x8e7/0xe00 [btrfs]
[12451.490988]  [<ffffffffa023135f>] btrfs_ioctl_balance+0x22f/0x570 [btrfs]
[12451.491030]  [<ffffffffa0233cb0>] btrfs_ioctl+0xee0/0x1b70 [btrfs]
[12451.491045]  [<ffffffff811a66a3>] ? user_path_at_empty+0x63/0xa0
[12451.491058]  [<ffffffff816d74a0>] ? __do_page_fault+0x240/0x540
[12451.491157]  [<ffffffff811a87d8>] do_vfs_ioctl+0x98/0x550
[12451.491182]  [<ffffffff81162173>] ? do_brk+0x1b3/0x330
[12451.491191]  [<ffffffff811a8d21>] sys_ioctl+0x91/0xb0
[12451.491201]  [<ffffffff816dbe1d>] system_call_fastpath+0x1a/0x1f
[12451.491208] ---[ end trace a10e7cae6b920c78 ]---
[12451.491217] BTRFS error (device sda2) in __btrfs_inc_extent_ref:1935: Ob=
ject already exists
[12451.494408] btrfs is forced readonly
[12451.495143] ------------[ cut here ]------------
[12451.498178] Kernel BUG at ffffffffa024bdbe [verbose debug info unavailab=
le]
[12451.498178] invalid opcode: 0000 [#1] SMP=20
[12451.498178] Modules linked in: nf_conntrack_ipv6(F) nf_defrag_ipv6(F) ip=
6t_REJECT(F) ip6table_filter(F) ip6_tables(F) ipt_REJECT(F) xt_tcpudp(F) xt=
_state(F) xt_limit(F) iptable_nat(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F)=
 nf_nat_ipv4(F) nf_nat(F) nf_conntrack(F) iptable_filter(F) ip_tables(F) x_=
tables(F) btrfs(F) zlib_deflate(F) libcrc32c(F) w83627ehf(F) hwmon_vid(F) c=
oretemp(F) gpio_ich(F) snd_pcm(F) i915(F) snd_timer(F) snd(F) soundcore(F) =
snd_page_alloc(F) microcode(F) psmouse(F) tpm_tis(F) drm_kms_helper(F) pcsp=
kr(F) serio_raw(F) drm(F) lpc_ich(F) i2c_i801(F) r8169(F) i2c_algo_bit(F) m=
ac_hid(F) video(F)
[12451.498178] CPU 0=20
[12451.498178] Pid: 1053, comm: btrfs Tainted: GF       W    3.8.5-gnu #1 O=
VH KS/D425KT
[12451.498178] RIP: 0010:[<ffffffffa024bdbe>]  [<ffffffffa024bdbe>] merge_r=
eloc_root+0xfe/0x500 [btrfs]
[12451.498178] RSP: 0018:ffff88011c9bb998  EFLAGS: 00010206
[12451.498178] RAX: ffffffffffffffe2 RBX: ffff880114c24cf0 RCX: 00000000000=
00002
[12451.498178] RDX: 0000000000000000 RSI: ffff88012976e000 RDI: ffff88011a9=
87800
[12451.498178] RBP: ffff88011c9bba58 R08: ffffea00047430c0 R09: 00000000000=
00000
[12451.498178] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011a0=
66000
[12451.498178] R13: ffffffffffffffe2 R14: ffff88011a987800 R15: ffff880119a=
de800
[12451.498178] FS:  00007f116b017760(0000) GS:ffff88012fc00000(0000) knlGS:=
0000000000000000
[12451.498178] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12451.498178] CR2: ffffffffff600400 CR3: 0000000119fed000 CR4: 00000000000=
007f0
[12451.498178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[12451.498178] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[12451.498178] Process btrfs (pid: 1053, threadinfo ffff88011c9ba000, task =
ffff880128231740)
[12451.498178] Stack:
[12451.498178]  ffff880100000002 ffffffffa01dd32a ffff880119ade000 00000000=
00000000
[12451.498178]  000000021c9bba58 0000e00000000001 ffff88011c9bb9d8 000774ff=
81350f5b
[12451.498178]  00006c0000000000 080d000000000068 006c000000000000 74000000=
003cba70
[12451.498178] Call Trace:
[12451.498178]  [<ffffffffa01dd32a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[12451.498178]  [<ffffffffa024c2d8>] merge_reloc_roots+0x118/0x150 [btrfs]
[12451.498178]  [<ffffffffa024c91b>] relocate_block_group+0x3db/0x640 [btrf=
s]
[12451.498178]  [<ffffffffa024cd45>] btrfs_relocate_block_group+0x1c5/0x300=
 [btrfs]
[12451.498178]  [<ffffffffa02250b5>] btrfs_relocate_chunk.isra.54+0x75/0x73=
0 [btrfs]
[12451.498178]  [<ffffffffa021b5e1>] ? release_extent_buffer.isra.26+0x81/0=
xf0 [btrfs]
[12451.498178]  [<ffffffffa0220b37>] ? free_extent_buffer+0x37/0x90 [btrfs]
[12451.498178]  [<ffffffffa02294d7>] btrfs_balance+0x8e7/0xe00 [btrfs]
[12451.498178]  [<ffffffffa023135f>] btrfs_ioctl_balance+0x22f/0x570 [btrfs]
[12451.498178]  [<ffffffffa0233cb0>] btrfs_ioctl+0xee0/0x1b70 [btrfs]
[12451.498178]  [<ffffffff811a66a3>] ? user_path_at_empty+0x63/0xa0
[12451.498178]  [<ffffffff816d74a0>] ? __do_page_fault+0x240/0x540
[12451.498178]  [<ffffffff811a87d8>] do_vfs_ioctl+0x98/0x550
[12451.498178]  [<ffffffff81162173>] ? do_brk+0x1b3/0x330
[12451.498178]  [<ffffffff811a8d21>] sys_ioctl+0x91/0xb0
[12451.498178]  [<ffffffff816dbe1d>] system_call_fastpath+0x1a/0x1f
[12451.498178] Code: 00 00 4c 89 f7 49 89 45 40 49 8b 74 24 18 e8 6a 1d fa =
ff 85 c0 74 16 83 f8 f5 75 0f 4c 89 f6 4c 89 ef e8 b6 6f fb ff 85 c0 74 b2 =
<0f> 0b 8b 45 cc 48 8d 55 cc 48 89 de 4c 89 ff 89 85 64 ff ff ff=20
[12451.498178] RIP  [<ffffffffa024bdbe>] merge_reloc_root+0xfe/0x500 [btrfs]
[12451.498178]  RSP <ffff88011c9bb998>
[12451.740494] ---[ end trace a10e7cae6b920c79 ]---

--=20
With respect,
Roman

--Sig_/2VarLmX57t.nokie_wrFUNj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFYtYwACgkQTLKSvz+PZwh+lQCePOqSh4uiQPq/nQZlrUl6m7fO
x/8AnRfGy20OgCoDfBTAYNkZAwXEtHKh
=ZpRh
-----END PGP SIGNATURE-----

--Sig_/2VarLmX57t.nokie_wrFUNj--
