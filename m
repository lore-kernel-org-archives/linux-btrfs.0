From: cwillu <cwillu@cwillu.com>
Subject: kernel BUG at /home/kernel-ppa/COD/linux/fs/btrfs/extent-tree.c:5502!
Date: Fri, 29 Jul 2011 10:50:06 -0600
Message-ID: <CAE5mzvivm=0-=_r5ZbZ71T=_bZ=vfB-EbqbT-WwK8mSg7M-=_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Vanilla 3.0, mounted with compress=3Dlzo, on a 40gb intel ssd.
Triggered while poking around with getting chromium windows to appear
where I wanted them (i.e., no heavy load).

[ 1222.266376] ------------[ cut here ]------------
[ 1222.266415] kernel BUG at
/home/kernel-ppa/COD/linux/fs/btrfs/extent-tree.c:5502!
[ 1222.266439] invalid opcode: 0000 [#1] SMP
[ 1222.266461] Modules linked in: ppdev lp parport snd_hda_codec_hdmi
arc4 nouveau ath9k snd_hda_codec_realtek mac80211 ath9k_common
ath9k_hw ttm snd_hda_intel drm_kms_helper snd_hda_codec ath drm
snd_hwdep cfg80211 snd_pcm snd_timer i2c_algo_bit mxm_wmi snd psmouse
wmi soundcore snd_page_alloc serio_raw video usbhid hid r8169 btrfs
zlib_deflate libcrc32c
[ 1222.266680]
[ 1222.266692] Pid: 211, comm: btrfs-transacti Not tainted
3.0.0-0300-generic #201107220917 To Be Filled By O.E.M. To Be Filled
By O.E.M./To be filled by O.E.M.
[ 1222.266740] EIP: 0060:[<f80ffd4d>] EFLAGS: 00010282 CPU: 3
[ 1222.266787] EIP is at alloc_reserved_tree_block+0x1cd/0x1e0 [btrfs]
[ 1222.266808] EAX: ffffffef EBX: f52d8000 ECX: f56bdd90 EDX: 00000002
[ 1222.266828] ESI: f56bdd90 EDI: 00000000 EBP: f53c7e18 ESP: f53c7de8
[ 1222.266848] =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1222.266868] Process btrfs-transacti (pid: 211, ti=3Df53c6000
task=3Df52eb2c0 task.ti=3Df53c6000)
[ 1222.266890] Stack:
[ 1222.266900] =C2=A0f53c7e6b f53c7e08 00000001 00000000 00000001 f7030=
000
f56ca5d0 00000ad3
[ 1222.266952] =C2=A000000033 f221fa40 00000000 00000000 f53c7e88 f8100=
a43
00000000 00000000
[ 1222.267008] =C2=A000000002 00000000 00000000 00000000 f4991620 00000=
001
f53c7e6b 00000000
[ 1222.267059] Call Trace:
[ 1222.267101] =C2=A0[<f8100a43>] run_delayed_tree_ref+0x183/0x200 [btr=
fs]
[ 1222.267150] =C2=A0[<f8100d24>] run_one_delayed_ref+0x54/0xf0 [btrfs]
[ 1222.267177] =C2=A0[<c1280494>] ? rb_erase+0xb4/0x120
[ 1222.267221] =C2=A0[<f8100e5c>] run_clustered_refs+0x9c/0x1e0 [btrfs]
[ 1222.267268] =C2=A0[<f810104a>] btrfs_run_delayed_refs+0xaa/0x1d0 [bt=
rfs]
[ 1222.267319] =C2=A0[<f810e9d9>] btrfs_commit_transaction+0x69/0x6e0 [=
btrfs]
[ 1222.267369] =C2=A0[<f810e408>] ? join_transaction+0x58/0x230 [btrfs]
[ 1222.267419] =C2=A0[<f810f363>] ? start_transaction+0x83/0x220 [btrfs=
]
[ 1222.267444] =C2=A0[<c1067940>] ? wake_up_bit+0x30/0x30
[ 1222.267489] =C2=A0[<f81092a5>] transaction_kthread+0x205/0x220 [btrf=
s]
[ 1222.267513] =C2=A0[<c103ba0e>] ? complete+0x4e/0x60
[ 1222.267558] =C2=A0[<f81090a0>] ? clean_tree_block+0x100/0x100 [btrfs=
]
[ 1222.267581] =C2=A0[<c1067425>] kthread+0x75/0x80
[ 1222.267600] =C2=A0[<c10673b0>] ? kthread_bind+0x80/0x80
[ 1222.267621] =C2=A0[<c153603e>] kernel_thread_helper+0x6/0x10
[ 1222.267638] Code: 24 0c 89 54 24 10 8b 01 8b 51 04 c7 04 24 a0 29
16 f8 89 44 24 04 89 54 24 08 e8 2f ad f4 c8 0f 0b eb fe 0f 0b eb fe
0f 0b eb fe <0f> 0b eb fe eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90
55 89
[ 1222.267933] EIP: [<f80ffd4d>] alloc_reserved_tree_block+0x1cd/0x1e0
[btrfs] SS:ESP 0068:f53c7de8
[ 1222.290918] ---[ end trace f71b0c3e4e57a853 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
