From: Ravi Pinjala <pstatic@gmail.com>
Subject: btrfs crash
Date: Sun, 14 Nov 2010 09:31:35 -0800
Message-ID: <AANLkTikAPcS3aeUp14hDJY8RTh_HnSg6sSR1Eyj+RNzM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got the following crash on one of my Ceph nodes this morning. I
don't know how to reproduce it yet; I was just wondering if it was a
known issue. This is with the latest kernel for Ubuntu 10.10.

Nov 13 19:21:21 alpha kernel: [19432.396679] ------------[ cut here
]------------
Nov 13 19:21:22 alpha kernel: [19432.396732] WARNING: at
/build/buildd/linux-2.6.35/fs/btrfs/extent-tree.c:5322
btrfs_alloc_free_block+0x1e7/0x430 [btrfs]()
Nov 13 19:21:22 alpha kernel: [19432.396743] Hardware name:
Nov 13 19:21:22 alpha kernel: [19432.396749] Modules linked in: nfsd
exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
snd_hda_codec_realtek i915 snd_hda_intel drm_kms_helper snd_hda_codec
snd_hwdep drm ppdev snd_pcm parport_pc snd_timer intel_agp psmouse
i2c_algo_bit serio_raw led_class lp snd video soundcore agpgart output
snd_page_alloc parport btrfs r8169 floppy mii zlib_deflate crc32c
libcrc32c
Nov 13 19:21:22 alpha kernel: [19432.396839] Pid: 1007, comm: cosd Not
tainted 2.6.35-22-generic-pae #35-Ubuntu
Nov 13 19:21:22 alpha kernel: [19432.396848] Call Trace:
Nov 13 19:21:22 alpha kernel: [19432.396874]  [<c01527b2>]
warn_slowpath_common+0x72/0xa0
Nov 13 19:21:22 alpha kernel: [19432.396920]  [<f85515c7>] ?
btrfs_alloc_free_block+0x1e7/0x430 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.396965]  [<f85515c7>] ?
btrfs_alloc_free_block+0x1e7/0x430 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.396981]  [<c0152802>]
warn_slowpath_null+0x22/0x30
Nov 13 19:21:22 alpha kernel: [19432.397025]  [<f85515c7>]
btrfs_alloc_free_block+0x1e7/0x430 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397041]  [<c013a864>] ?
kmap_atomic+0x24/0x30
Nov 13 19:21:22 alpha kernel: [19432.397054]  [<c013a77c>] ?
kmap_atomic_prot+0x4c/0x110
Nov 13 19:21:22 alpha kernel: [19432.397064]  [<c013a814>] ?
kmap_atomic_prot+0xe4/0x110
Nov 13 19:21:22 alpha kernel: [19432.397106]  [<f853d46d>]
__btrfs_cow_block+0x14d/0x5e0 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397120]  [<c013a655>] ?
kunmap_atomic+0x55/0x70
Nov 13 19:21:22 alpha kernel: [19432.397163]  [<f853d9db>]
btrfs_cow_block+0xdb/0x1c0 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397210]  [<f8543221>]
btrfs_search_slot+0x2a1/0x530 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397261]  [<f85555db>]
btrfs_lookup_inode+0x3b/0xb0 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397311]  [<f8560364>]
btrfs_update_inode+0x54/0x100 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397360]  [<f856483d>]
btrfs_truncate+0x1cd/0x230 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397376]  [<c01eb4b0>] vmtruncate+0x30/0x40
Nov 13 19:21:22 alpha kernel: [19432.397423]  [<f8568d36>]
btrfs_setattr_size+0xc6/0x2d0 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397471]  [<f8568fc7>]
btrfs_setattr+0x87/0x90 [btrfs]
Nov 13 19:21:22 alpha kernel: [19432.397488]  [<c0238203>]
notify_change+0x143/0x2f0
Nov 13 19:21:22 alpha kernel: [19432.397501]  [<c022bd3b>] ? putname+0x2b/0x40
Nov 13 19:21:22 alpha kernel: [19432.397513]  [<c0221a42>] do_truncate+0x62/0x90
Nov 13 19:21:22 alpha kernel: [19432.397527]  [<c030dd9a>] ?
security_path_truncate+0x3a/0x50
Nov 13 19:21:22 alpha kernel: [19432.397540]  [<c0221d37>]
do_sys_truncate+0x137/0x140
Nov 13 19:21:22 alpha kernel: [19432.397553]  [<c0221d56>]
sys_truncate64+0x16/0x20
Nov 13 19:21:22 alpha kernel: [19432.397566]  [<c05f00f4>] syscall_call+0x7/0xb
Nov 13 19:21:22 alpha kernel: [19432.397577]  [<c05f0000>] ?
_lock_kernel+0x20/0x8a
Nov 13 19:21:22 alpha kernel: [19432.397586] ---[ end trace
e8ea54bc05860e29 ]---

...followed by...

[19432.397661] ------------[ cut here ]------------
[19432.397792] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/inode.c:6182!
[19432.397977] invalid opcode: 0000 [#1] SMP
[19432.398096] last sysfs file: /sys/module/nfsd/initstate
[19432.398227] Modules linked in: nfsd exportfs nfs lockd fscache
nfs_acl auth_rpcgss sunrpc snd_hda_codec_realtek i915 snd_hda_intel
drm_kms_helper snd_hda_codec snd_hwdep drm ppdev snd_pcm parport_pc
snd_timer intel_agp psmouse i2c_algo_bit serio_raw led_class lp snd
video soundcore agpgart output snd_page_alloc parport btrfs r8169
floppy mii zlib_deflate crc32c libcrc32c
[19432.399458]
[19432.399509] Pid: 1007, comm: cosd Tainted: G        W
2.6.35-22-generic-pae #35-Ubuntu LakePort/
[19432.399746] EIP: 0060:[<f8564893>] EFLAGS: 00010286 CPU: 0
[19432.399937] EIP is at btrfs_truncate+0x223/0x230 [btrfs]
[19432.400018] EAX: ffffffe4 EBX: f60ac270 ECX: 00000000 EDX: 00000000
[19432.400018] ESI: f6612800 EDI: f0f40af4 EBP: f65b5eac ESP: f65b5e8c
[19432.400018]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[19432.400018] Process cosd (pid: 1007, ti=f65b4000 task=f64c32c0
task.ti=f65b4000)
[19432.400018] Stack:
[19432.400018]  00000000 00000000 0000006c f0f409e0 00000000 f0f40af4
00000000 f60ac270
[19432.400018] <0> f65b5ebc c01eb4b0 f0f40af4 f65b5f38 f65b5ee4
f8568d36 f6d77000 00000000
[19432.400018] <0> f0f409e0 00000000 f6612800 f65b5f38 00000000
f0f40af4 f65b5ef8 f8568fc7
[19432.400018] Call Trace:
[19432.400018]  [<c01eb4b0>] ? vmtruncate+0x30/0x40
[19432.400018]  [<f8568d36>] ? btrfs_setattr_size+0xc6/0x2d0 [btrfs]
[19432.400018]  [<f8568fc7>] ? btrfs_setattr+0x87/0x90 [btrfs]
[19432.400018]  [<c0238203>] ? notify_change+0x143/0x2f0
[19432.400018]  [<c022bd3b>] ? putname+0x2b/0x40
[19432.400018]  [<c0221a42>] ? do_truncate+0x62/0x90
[19432.400018]  [<c030dd9a>] ? security_path_truncate+0x3a/0x50
[19432.400018]  [<c0221d37>] ? do_sys_truncate+0x137/0x140
[19432.400018]  [<c0221d56>] ? sys_truncate64+0x16/0x20
[19432.400018]  [<c05f00f4>] ? syscall_call+0x7/0xb
[19432.400018]  [<c05f0000>] ? _lock_kernel+0x20/0x8a
[19432.400018] Code: ae ff ff 85 c0 74 c3 0f 0b eb fe 89 f9 89 f2 89
d8 e8 b2 4a 01 00 e9 cf fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe
0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 90 55 89 e5 57 56 53
83 ec
[19432.400018] EIP: [<f8564893>] btrfs_truncate+0x223/0x230 [btrfs]
SS:ESP 0068:f65b5e8c
[19432.418489] ---[ end trace e8ea54bc05860e2a ]---

--Ravi
