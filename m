Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:38096 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509Ab3DBIFA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 04:05:00 -0400
Received: from natsu (unknown [IPv6:fd39::1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id C1109203D0
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 08:04:57 +0000 (UTC)
Date: Tue, 2 Apr 2013 14:04:52 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: <linux-btrfs@vger.kernel.org>
Subject: Still getting a lot of -28 (ENOSPC?) errors during balance
Message-ID: <20130402140452.2b71794f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xR2/yvBkO7wm8J/rTdejsjs"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/xR2/yvBkO7wm8J/rTdejsjs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

With kernel 3.7.10 patched with "Btrfs: limit the global reserve to 512mb".
(the problem was occuring also without this patch, but seemed to be even wo=
rse).

At the start of balance:

Data: total=3D31.85GB, used=3D9.96GB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D1.01GB, used=3D696.17MB

"btrfs balance start -musage=3D5 -dusage=3D5" is going on for about 50 minu=
tes

Current situation:

Balance on '/mnt/r1/' is running
1 out of about 2 chunks balanced (20 considered),  50% left

Data: total=3D30.85GB, used=3D10.04GB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D1.01GB, used=3D851.69MB

And a constant stream of these in dmesg:

[ 7614.756339] btrfs: block rsv returned -28
[ 7614.756341] ------------[ cut here ]------------
[ 7614.756370] WARNING: at fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_blo=
ck+0x351/0x360 [btrfs]()
[ 7614.756372] Hardware name: GA-880GM-UD2H
[ 7614.756374] Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd fscach=
e sunrpc bridge 8021q garp stp llc aoe it87 hwmon_vid snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcsp snd_pcm =
kvm_amd kvm snd_page_alloc snd_timer snd soundcore sp5100_tco serio_raw joy=
dev k10temp edac_core i2c_piix4 edac_mce_amd mac_hid shpchp wmi btrfs libcr=
c32c zlib_deflate raid1 raid456 async_raid6_recov async_memcpy async_pq asy=
nc_xor xor async_tx raid6_pq nbd sata_nv hid_generic usbhid usb_storage hid=
 microcode r8169 sata_mv
[ 7614.756411] Pid: 4708, comm: btrfs Tainted: G        W    3.7.10-rm3+ #38
[ 7614.756413] Call Trace:
[ 7614.756421]  [<ffffffff8105516f>] warn_slowpath_common+0x7f/0xc0
[ 7614.756425]  [<ffffffff810551ca>] warn_slowpath_null+0x1a/0x20
[ 7614.756440]  [<ffffffffa00f71c1>] btrfs_alloc_free_block+0x351/0x360 [bt=
rfs]
[ 7614.756453]  [<ffffffffa00e3d03>] ? __btrfs_cow_block+0x323/0x4f0 [btrfs]
[ 7614.756472]  [<ffffffffa01263ab>] ? read_extent_buffer+0xbb/0x110 [btrfs]
[ 7614.756485]  [<ffffffffa00e3b06>] __btrfs_cow_block+0x126/0x4f0 [btrfs]
[ 7614.756498]  [<ffffffffa00e4047>] btrfs_cow_block+0xf7/0x200 [btrfs]
[ 7614.756515]  [<ffffffffa014abb7>] do_relocation+0x467/0x530 [btrfs]
[ 7614.756528]  [<ffffffffa00ecdfa>] ? block_rsv_add_bytes+0x5a/0x80 [btrfs]
[ 7614.756545]  [<ffffffffa014e8dd>] relocate_tree_blocks+0x61d/0x650 [btrf=
s]
[ 7614.756562]  [<ffffffffa014f8d6>] relocate_block_group+0x446/0x6a0 [btrf=
s]
[ 7614.756579]  [<ffffffffa014fccd>] btrfs_relocate_block_group+0x19d/0x2d0=
 [btrfs]
[ 7614.756596]  [<ffffffffa0128685>] btrfs_relocate_chunk.isra.53+0x75/0x77=
0 [btrfs]
[ 7614.756613]  [<ffffffffa0138668>] ? btrfs_set_lock_blocking_rw+0xa8/0xf0=
 [btrfs]
[ 7614.756630]  [<ffffffffa011ffa1>] ? release_extent_buffer.isra.26+0x81/0=
xf0 [btrfs]
[ 7614.756647]  [<ffffffffa0125227>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 7614.756663]  [<ffffffffa012cdc7>] btrfs_balance+0x877/0xe00 [btrfs]
[ 7614.756680]  [<ffffffffa0132f9c>] btrfs_ioctl_balance+0x10c/0x430 [btrfs]
[ 7614.756684]  [<ffffffff8167e38e>] ? _raw_spin_lock+0xe/0x20
[ 7614.756702]  [<ffffffffa013739b>] btrfs_ioctl+0xf2b/0x1970 [btrfs]
[ 7614.756707]  [<ffffffff8114f7f9>] ? handle_mm_fault+0x249/0x310
[ 7614.756711]  [<ffffffff816822d4>] ? __do_page_fault+0x254/0x4e0
[ 7614.756714]  [<ffffffff811527d0>] ? __vma_link_rb+0x30/0x40
[ 7614.756718]  [<ffffffff8118f9b0>] do_vfs_ioctl+0x90/0x570
[ 7614.756723]  [<ffffffff8108793a>] ? finish_task_switch+0x4a/0xe0
[ 7614.756726]  [<ffffffff8118ff21>] sys_ioctl+0x91/0xb0
[ 7614.756730]  [<ffffffff81686b1d>] system_call_fastpath+0x1a/0x1f
[ 7614.756732] ---[ end trace 9fdf5720be6ec4cb ]---
[ 7614.756894] btrfs: block rsv returned -28
[ 7614.756895] ------------[ cut here ]------------
[ 7614.756910] WARNING: at fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_blo=
ck+0x351/0x360 [btrfs]()
[ 7614.756911] Hardware name: GA-880GM-UD2H
[ 7614.756912] Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd fscach=
e sunrpc bridge 8021q garp stp llc aoe it87 hwmon_vid snd_hda_codec_hdmi sn=
d_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcsp snd_pcm =
kvm_amd kvm snd_page_alloc snd_timer snd soundcore sp5100_tco serio_raw joy=
dev k10temp edac_core i2c_piix4 edac_mce_amd mac_hid shpchp wmi btrfs libcr=
c32c zlib_deflate raid1 raid456 async_raid6_recov async_memcpy async_pq asy=
nc_xor xor async_tx raid6_pq nbd sata_nv hid_generic usbhid usb_storage hid=
 microcode r8169 sata_mv
[ 7614.756945] Pid: 4708, comm: btrfs Tainted: G        W    3.7.10-rm3+ #38
[ 7614.756946] Call Trace:
[ 7614.756950]  [<ffffffff8105516f>] warn_slowpath_common+0x7f/0xc0
[ 7614.756953]  [<ffffffff810551ca>] warn_slowpath_null+0x1a/0x20
[ 7614.756967]  [<ffffffffa00f71c1>] btrfs_alloc_free_block+0x351/0x360 [bt=
rfs]
[ 7614.756983]  [<ffffffffa0147ad7>] ? add_delayed_tree_ref+0xd7/0x190 [btr=
fs]
[ 7614.757000]  [<ffffffffa014769e>] ? add_delayed_ref_head.isra.7+0xce/0x1=
60 [btrfs]
[ 7614.757017]  [<ffffffffa01482a5>] ? btrfs_add_delayed_tree_ref+0x115/0x1=
a0 [btrfs]
[ 7614.757030]  [<ffffffffa00e3b06>] __btrfs_cow_block+0x126/0x4f0 [btrfs]
[ 7614.757034]  [<ffffffff8112feba>] ? set_page_dirty+0x5a/0x70
[ 7614.757047]  [<ffffffffa00e4047>] btrfs_cow_block+0xf7/0x200 [btrfs]
[ 7614.757060]  [<ffffffffa00e8367>] btrfs_search_slot+0x3d7/0x8d0 [btrfs]
[ 7614.757075]  [<ffffffffa0107f64>] ? btrfs_record_root_in_trans+0x64/0x80=
 [btrfs]
[ 7614.757092]  [<ffffffffa014ab2e>] do_relocation+0x3de/0x530 [btrfs]
[ 7614.757105]  [<ffffffffa00ecdfa>] ? block_rsv_add_bytes+0x5a/0x80 [btrfs]
[ 7614.757122]  [<ffffffffa014e8dd>] relocate_tree_blocks+0x61d/0x650 [btrf=
s]
[ 7614.757139]  [<ffffffffa014f8d6>] relocate_block_group+0x446/0x6a0 [btrf=
s]
[ 7614.757155]  [<ffffffffa014fccd>] btrfs_relocate_block_group+0x19d/0x2d0=
 [btrfs]
[ 7614.757172]  [<ffffffffa0128685>] btrfs_relocate_chunk.isra.53+0x75/0x77=
0 [btrfs]
[ 7614.757189]  [<ffffffffa0138668>] ? btrfs_set_lock_blocking_rw+0xa8/0xf0=
 [btrfs]
[ 7614.757206]  [<ffffffffa011ffa1>] ? release_extent_buffer.isra.26+0x81/0=
xf0 [btrfs]
[ 7614.757222]  [<ffffffffa0125227>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 7614.757239]  [<ffffffffa012cdc7>] btrfs_balance+0x877/0xe00 [btrfs]
[ 7614.757256]  [<ffffffffa0132f9c>] btrfs_ioctl_balance+0x10c/0x430 [btrfs]
[ 7614.757260]  [<ffffffff8167e38e>] ? _raw_spin_lock+0xe/0x20
[ 7614.757276]  [<ffffffffa013739b>] btrfs_ioctl+0xf2b/0x1970 [btrfs]
[ 7614.757280]  [<ffffffff8114f7f9>] ? handle_mm_fault+0x249/0x310
[ 7614.757283]  [<ffffffff816822d4>] ? __do_page_fault+0x254/0x4e0
[ 7614.757287]  [<ffffffff811527d0>] ? __vma_link_rb+0x30/0x40
[ 7614.757290]  [<ffffffff8118f9b0>] do_vfs_ioctl+0x90/0x570
[ 7614.757294]  [<ffffffff8108793a>] ? finish_task_switch+0x4a/0xe0
[ 7614.757297]  [<ffffffff8118ff21>] sys_ioctl+0x91/0xb0
[ 7614.757300]  [<ffffffff81686b1d>] system_call_fastpath+0x1a/0x1f
[ 7614.757302] ---[ end trace 9fdf5720be6ec4cc ]---

--=20
With respect,
Roman

--Sig_/xR2/yvBkO7wm8J/rTdejsjs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFakSQACgkQTLKSvz+PZwj4bACeOJehaKs/o/Lv5j4Z371i4PHq
fm8AmwY8Uk2GsEbi4zD1nswKRiFcmVVw
=k6oY
-----END PGP SIGNATURE-----

--Sig_/xR2/yvBkO7wm8J/rTdejsjs--
