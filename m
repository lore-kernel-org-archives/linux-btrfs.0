Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:53733 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3IBP2t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 11:28:49 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so4643091obb.37
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Sep 2013 08:28:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Sep 2013 23:28:48 +0800
Message-ID: <CAMVG2ss8PZbjBfHU+hn-dL4TTcGPOyR6jY1bsA08bEBgRoK6mA@mail.gmail.com>
Subject: btrfs_join_transaction bug...
From: Daniel J Blueman <daniel@quora.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running my btrfs exerciser [1] for ~5 mins on 3.11-rc7, I hit a
BUG_ON in merge_reloc_roots that asserts btrfs_join_transaction
doesn't generate an error [2].

Is this a valid failure when the filesystem went read-only due to out of space?

It can also reproduce a livelock between a 'btrfs filesystem balance'
and btrfs-transaction kthread.

Thanks,
  Daniel

--- [1]

1. boot your box with ramdisk_size set to a fifth of your box's
memory, eg ramdisk_size=1572864 for an 8GB box, if rd is compiled into
the kernel
2. install fio
3. fetch http://quora.org/2013/workload (for fio)
4. make sure /dev/ram{0-3} don't have any important data
5. run http://quora.org/2013/btrfsatron

--- [2]

$ sudo btrfs filesystem balance /tmp/btrfsathon
ERROR: defrag failed on /tmp/btrfsathon - Read-only file system
total 1 failures
ERROR: error during balancing '/tmp/btrfsathon' - Read-only file system
There may be more info in syslog - try dmesg | tail

$ dmesg
...
WARNING: CPU: 5 PID: 22243 at /home/apw/COD/linux/fs/btrfs/super.c:253
__btrfs_abort_transaction+0x135/0x140 [btrfs]()
btrfs: Transaction aborted (error -28)
Modules linked in: dm_crypt snd_hda_codec_hdmi ipt_REJECT xt_limit
xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp
nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables
arc4 b43 joydev mac80211 snd_hda_codec_cirrus rfcomm bnep cfg80211
snd_hda_intel snd_hda_codec ssb uvcvideo ax88179_178a usbnet snd_hwdep
applesmc videobuf2_vmalloc mii snd_pcm btusb videobuf2_memops
videobuf2_core input_polldev bluetooth snd_page_alloc videodev nfsd
snd_seq_midi snd_seq_midi_event auth_rpcgss snd_rawmidi bcm5974
nfs_acl snd_seq nfs snd_seq_device lockd snd_timer binfmt_misc bcma
mei_me lpc_ich sunrpc snd mei soundcore fscache apple_gmux mac_hid
apple_bl nls_iso8859_1 lp parport btrfs xor zlib_deflate raid6_pq
libcrc32c microcode hid_generic hid_apple usbhid hid nouveau i915
mxm_wmi wmi ttm i2c_algo_bit ahci drm_kms_helper libahci drm video
CPU: 5 PID: 22243 Comm: btrfs Not tainted 3.11.0-031100rc7-generic #201308252135
Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B02.1208081132 08/08/2012
 00000000000000fd ffff8801c766d6c8 ffffffff81720d7a 0000000000000007
 ffff8801c766d718 ffff8801c766d708 ffffffff8106534c 0000000000000033
 ffff8801f2793800 ffff8802181d6780 00000000ffffffe4 000000000000163d
Call Trace:
 [<ffffffff81720d7a>] dump_stack+0x46/0x58
 [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81065436>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa02c8290>] ? lookup_extent_backref+0x60/0xf0 [btrfs]
 [<ffffffffa02b8cd5>] __btrfs_abort_transaction+0x135/0x140 [btrfs]
 [<ffffffffa02caca5>] __btrfs_free_extent+0x1e5/0x990 [btrfs]
 [<ffffffffa02cb59c>] run_delayed_tree_ref+0x14c/0x1c0 [btrfs]
 [<ffffffffa02cf84e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
 [<ffffffffa02cf999>] run_clustered_refs+0x139/0x530 [btrfs]
 [<ffffffffa02d3570>] btrfs_run_delayed_refs+0x100/0x5a0 [btrfs]
 [<ffffffffa02e34fe>] btrfs_commit_transaction+0xbe/0x9e0 [btrfs]
 [<ffffffff8172c44e>] ? _raw_spin_lock+0xe/0x20
 [<ffffffffa02ce24f>] ? btrfs_block_rsv_check+0x6f/0x90 [btrfs]
 [<ffffffffa02e41c0>] __btrfs_end_transaction+0x350/0x390 [btrfs]
 [<ffffffffa02e4233>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
 [<ffffffffa0330fc4>] relocate_block_group+0x434/0x570 [btrfs]
 [<ffffffffa03312b7>] btrfs_relocate_block_group+0x1b7/0x2f0 [btrfs]
 [<ffffffffa03093b6>] btrfs_relocate_chunk.isra.62+0x56/0x3e0 [btrfs]
 [<ffffffffa03080c9>] ? should_balance_chunk.isra.66+0x49/0x2f0 [btrfs]
 [<ffffffffa030cda2>] __btrfs_balance+0x312/0x3f0 [btrfs]
 [<ffffffffa030d1ba>] btrfs_balance+0x33a/0x5d0 [btrfs]
 [<ffffffffa03162af>] btrfs_ioctl_balance+0x22f/0x550 [btrfs]
 [<ffffffffa0317f09>] btrfs_ioctl+0x4f9/0xa90 [btrfs]
 [<ffffffff8109caf6>] ? account_user_time+0xa6/0xc0
 [<ffffffff8109d134>] ? vtime_account_user+0x74/0x90
 [<ffffffff811c471c>] do_vfs_ioctl+0x7c/0x2f0
 [<ffffffff810210a9>] ? syscall_trace_enter+0x29/0x270
 [<ffffffff811c4a21>] SyS_ioctl+0x91/0xb0
 [<ffffffff81735aaf>] tracesys+0xe1/0xe6
---[ end trace 552316f62b37bc3a ]---
BTRFS error (device ram1) in __btrfs_free_extent:5693: errno=-28 No space left
BTRFS info (device ram1): forced readonly
BTRFS debug (device ram1): run_one_delayed_ref returned -28
BTRFS error (device ram1) in btrfs_run_delayed_refs:2677: errno=-28 No
space left
------------[ cut here ]------------
Kernel BUG at ffffffffa0330b83 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
Modules linked in: dm_crypt snd_hda_codec_hdmi ipt_REJECT xt_limit
xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp
nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables
arc4 b43 joydev mac80211 snd_hda_codec_cirrus rfcomm bnep cfg80211
snd_hda_intel snd_hda_codec ssb uvcvideo ax88179_178a usbnet snd_hwdep
applesmc videobuf2_vmalloc mii snd_pcm btusb videobuf2_memops
videobuf2_core input_polldev bluetooth snd_page_alloc videodev nfsd
snd_seq_midi snd_seq_midi_event auth_rpcgss snd_rawmidi bcm5974
nfs_acl snd_seq nfs snd_seq_device lockd snd_timer binfmt_misc bcma
mei_me lpc_ich sunrpc snd mei soundcore fscache apple_gmux mac_hid
apple_bl nls_iso8859_1 lp parport btrfs xor zlib_deflate raid6_pq
libcrc32c microcode hid_generic hid_apple usbhid hid nouveau i915
mxm_wmi wmi ttm i2c_algo_bit ahci drm_kms_helper libahci drm video
CPU: 5 PID: 22243 Comm: btrfs Tainted: G        W
3.11.0-031100rc7-generic #201308252135
Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B02.1208081132 08/08/2012
task: ffff880261685dc0 ti: ffff8801c766c000 task.ti: ffff8801c766c000
RIP: 0010:[<ffffffffa0330b83>]  [<ffffffffa0330b83>]
merge_reloc_roots+0x273/0x280 [btrfs]
RSP: 0018:ffff8801c766db18  EFLAGS: 00010286
RAX: ffff8801c766db48 RBX: 00000000ffffffe2 RCX: 00000000ffffffe2
RDX: 0000000000000941 RSI: 0000000000000000 RDI: ffff880262f52000
RBP: ffff8801c766db88 R08: 0000000000000000 R09: ffffea000894d5c0
R10: ffffffffa02bc74a R11: 0000000000017960 R12: ffff880212c33800
R13: ffff880212c30c58 R14: ffff8801f2793800 R15: ffff880212c30800
FS:  00007f870b70b780(0000) GS:ffff88026f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ad76dd050 CR3: 000000024e02c000 CR4: 00000000001407e0
Stack:
 ffff8801c766db28 ffff880212c33d90 0000000000000000 000000000000008c
 0000000000000005 ffff8801c766db48 ffff8801c766db48 ffff8801c766db48
 ffff88021fca6480 ffff880212c33800 ffff88021fca6480 00000000ffffffe2
Call Trace:
 [<ffffffffa0330e4b>] relocate_block_group+0x2bb/0x570 [btrfs]
 [<ffffffffa03312b7>] btrfs_relocate_block_group+0x1b7/0x2f0 [btrfs]
 [<ffffffffa03093b6>] btrfs_relocate_chunk.isra.62+0x56/0x3e0 [btrfs]
 [<ffffffffa03080c9>] ? should_balance_chunk.isra.66+0x49/0x2f0 [btrfs]
 [<ffffffffa030cda2>] __btrfs_balance+0x312/0x3f0 [btrfs]
 [<ffffffffa030d1ba>] btrfs_balance+0x33a/0x5d0 [btrfs]
 [<ffffffffa03162af>] btrfs_ioctl_balance+0x22f/0x550 [btrfs]
 [<ffffffffa0317f09>] btrfs_ioctl+0x4f9/0xa90 [btrfs]
 [<ffffffff8109caf6>] ? account_user_time+0xa6/0xc0
 [<ffffffff8109d134>] ? vtime_account_user+0x74/0x90
 [<ffffffff811c471c>] do_vfs_ioctl+0x7c/0x2f0
 [<ffffffff810210a9>] ? syscall_trace_enter+0x29/0x270
 [<ffffffff811c4a21>] SyS_ioctl+0x91/0xb0
 [<ffffffff81735aaf>] tracesys+0xe1/0xe6
Code: b8 48 39 45 c0 74 b5 48 8d 7d c0 e8 18 a8 ff ff eb aa 48 8b 45
c8 48 8d 55 c0 4c 89 6d c8 49 89 55 00 49 89 45 08 4c 89 28 eb b3 <0f>
0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
RIP  [<ffffffffa0330b83>] merge_reloc_roots+0x273/0x280 [btrfs]
 RSP <ffff8801c766db18>------------[ cut here ]------------
WARNING: CPU: 5 PID: 22243 at /home/apw/COD/linux/fs/btrfs/super.c:253
__btrfs_abort_transaction+0x135/0x140 [btrfs]()
btrfs: Transaction aborted (error -28)
Modules linked in: dm_crypt snd_hda_codec_hdmi ipt_REJECT xt_limit
xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp
nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables
arc4 b43 joydev mac80211 snd_hda_codec_cirrus rfcomm bnep cfg80211
snd_hda_intel snd_hda_codec ssb uvcvideo ax88179_178a usbnet snd_hwdep
applesmc videobuf2_vmalloc mii snd_pcm btusb videobuf2_memops
videobuf2_core input_polldev bluetooth snd_page_alloc videodev nfsd
snd_seq_midi snd_seq_midi_event auth_rpcgss snd_rawmidi bcm5974
nfs_acl snd_seq nfs snd_seq_device lockd snd_timer binfmt_misc bcma
mei_me lpc_ich sunrpc snd mei soundcore fscache apple_gmux mac_hid
apple_bl nls_iso8859_1 lp parport btrfs xor zlib_deflate raid6_pq
libcrc32c microcode hid_generic hid_apple usbhid hid nouveau i915
mxm_wmi wmi ttm i2c_algo_bit ahci drm_kms_helper libahci drm video
CPU: 5 PID: 22243 Comm: btrfs Not tainted 3.11.0-031100rc7-generic #201308252135
Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B02.1208081132 08/08/2012
 00000000000000fd ffff8801c766d6c8 ffffffff81720d7a 0000000000000007
 ffff8801c766d718 ffff8801c766d708 ffffffff8106534c 0000000000000033
 ffff8801f2793800 ffff8802181d6780 00000000ffffffe4 000000000000163d
Call Trace:
 [<ffffffff81720d7a>] dump_stack+0x46/0x58
 [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81065436>] warn_slowpath_fmt+0x46/0x50
 [<ffffffffa02c8290>] ? lookup_extent_backref+0x60/0xf0 [btrfs]
 [<ffffffffa02b8cd5>] __btrfs_abort_transaction+0x135/0x140 [btrfs]
 [<ffffffffa02caca5>] __btrfs_free_extent+0x1e5/0x990 [btrfs]
 [<ffffffffa02cb59c>] run_delayed_tree_ref+0x14c/0x1c0 [btrfs]
 [<ffffffffa02cf84e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
 [<ffffffffa02cf999>] run_clustered_refs+0x139/0x530 [btrfs]
 [<ffffffffa02d3570>] btrfs_run_delayed_refs+0x100/0x5a0 [btrfs]
 [<ffffffffa02e34fe>] btrfs_commit_transaction+0xbe/0x9e0 [btrfs]
 [<ffffffff8172c44e>] ? _raw_spin_lock+0xe/0x20
 [<ffffffffa02ce24f>] ? btrfs_block_rsv_check+0x6f/0x90 [btrfs]
 [<ffffffffa02e41c0>] __btrfs_end_transaction+0x350/0x390 [btrfs]
 [<ffffffffa02e4233>] btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
 [<ffffffffa0330fc4>] relocate_block_group+0x434/0x570 [btrfs]
 [<ffffffffa03312b7>] btrfs_relocate_block_group+0x1b7/0x2f0 [btrfs]
 [<ffffffffa03093b6>] btrfs_relocate_chunk.isra.62+0x56/0x3e0 [btrfs]
 [<ffffffffa03080c9>] ? should_balance_chunk.isra.66+0x49/0x2f0 [btrfs]
 [<ffffffffa030cda2>] __btrfs_balance+0x312/0x3f0 [btrfs]
 [<ffffffffa030d1ba>] btrfs_balance+0x33a/0x5d0 [btrfs]
 [<ffffffffa03162af>] btrfs_ioctl_balance+0x22f/0x550 [btrfs]
 [<ffffffffa0317f09>] btrfs_ioctl+0x4f9/0xa90 [btrfs]
 [<ffffffff8109caf6>] ? account_user_time+0xa6/0xc0
 [<ffffffff8109d134>] ? vtime_account_user+0x74/0x90
 [<ffffffff811c471c>] do_vfs_ioctl+0x7c/0x2f0
 [<ffffffff810210a9>] ? syscall_trace_enter+0x29/0x270
 [<ffffffff811c4a21>] SyS_ioctl+0x91/0xb0
 [<ffffffff81735aaf>] tracesys+0xe1/0xe6
---[ end trace 552316f62b37bc3a ]---
BTRFS error (device ram1) in __btrfs_free_extent:5693: errno=-28 No space left
BTRFS info (device ram1): forced readonly
BTRFS debug (device ram1): run_one_delayed_ref returned -28
BTRFS error (device ram1) in btrfs_run_delayed_refs:2677: errno=-28 No
space left
------------[ cut here ]------------
Kernel BUG at ffffffffa0330b83 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
Modules linked in: dm_crypt snd_hda_codec_hdmi ipt_REJECT xt_limit
xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp
nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables
arc4 b43 joydev mac80211 snd_hda_codec_cirrus rfcomm bnep cfg80211
snd_hda_intel snd_hda_codec ssb uvcvideo ax88179_178a usbnet snd_hwdep
applesmc videobuf2_vmalloc mii snd_pcm btusb videobuf2_memops
videobuf2_core input_polldev bluetooth snd_page_alloc videodev nfsd
snd_seq_midi snd_seq_midi_event auth_rpcgss snd_rawmidi bcm5974
nfs_acl snd_seq nfs snd_seq_device lockd snd_timer binfmt_misc bcma
mei_me lpc_ich sunrpc snd mei soundcore fscache apple_gmux mac_hid
apple_bl nls_iso8859_1 lp parport btrfs xor zlib_deflate raid6_pq
libcrc32c microcode hid_generic hid_apple usbhid hid nouveau i915
mxm_wmi wmi ttm i2c_algo_bit ahci drm_kms_helper libahci drm video
CPU: 5 PID: 22243 Comm: btrfs Tainted: G        W
3.11.0-031100rc7-generic #201308252135
Hardware name: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B02.1208081132 08/08/2012
task: ffff880261685dc0 ti: ffff8801c766c000 task.ti: ffff8801c766c000
RIP: 0010:[<ffffffffa0330b83>]  [<ffffffffa0330b83>]
merge_reloc_roots+0x273/0x280 [btrfs]
RSP: 0018:ffff8801c766db18  EFLAGS: 00010286
RAX: ffff8801c766db48 RBX: 00000000ffffffe2 RCX: 00000000ffffffe2
RDX: 0000000000000941 RSI: 0000000000000000 RDI: ffff880262f52000
RBP: ffff8801c766db88 R08: 0000000000000000 R09: ffffea000894d5c0
R10: ffffffffa02bc74a R11: 0000000000017960 R12: ffff880212c33800
R13: ffff880212c30c58 R14: ffff8801f2793800 R15: ffff880212c30800
FS:  00007f870b70b780(0000) GS:ffff88026f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ad76dd050 CR3: 000000024e02c000 CR4: 00000000001407e0
Stack:
 ffff8801c766db28 ffff880212c33d90 0000000000000000 000000000000008c
 0000000000000005 ffff8801c766db48 ffff8801c766db48 ffff8801c766db48
 ffff88021fca6480 ffff880212c33800 ffff88021fca6480 00000000ffffffe2
Call Trace:
 [<ffffffffa0330e4b>] relocate_block_group+0x2bb/0x570 [btrfs]
 [<ffffffffa03312b7>] btrfs_relocate_block_group+0x1b7/0x2f0 [btrfs]
 [<ffffffffa03093b6>] btrfs_relocate_chunk.isra.62+0x56/0x3e0 [btrfs]
 [<ffffffffa03080c9>] ? should_balance_chunk.isra.66+0x49/0x2f0 [btrfs]
 [<ffffffffa030cda2>] __btrfs_balance+0x312/0x3f0 [btrfs]
 [<ffffffffa030d1ba>] btrfs_balance+0x33a/0x5d0 [btrfs]
 [<ffffffffa03162af>] btrfs_ioctl_balance+0x22f/0x550 [btrfs]
 [<ffffffffa0317f09>] btrfs_ioctl+0x4f9/0xa90 [btrfs]
 [<ffffffff8109caf6>] ? account_user_time+0xa6/0xc0
 [<ffffffff8109d134>] ? vtime_account_user+0x74/0x90
 [<ffffffff811c471c>] do_vfs_ioctl+0x7c/0x2f0
 [<ffffffff810210a9>] ? syscall_trace_enter+0x29/0x270
 [<ffffffff811c4a21>] SyS_ioctl+0x91/0xb0
 [<ffffffff81735aaf>] tracesys+0xe1/0xe6
Code: b8 48 39 45 c0 74 b5 48 8d 7d c0 e8 18 a8 ff ff eb aa 48 8b 45
c8 48 8d 55 c0 4c 89 6d c8 49 89 55 00 49 89 45 08 4c 89 28 eb b3 <0f>
0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
RIP  [<ffffffffa0330b83>] merge_reloc_roots+0x273/0x280 [btrfs]
 RSP <ffff8801c766db18>
-- 
Daniel J Blueman
