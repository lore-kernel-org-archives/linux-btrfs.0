From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: WARNING: at fs/btrfs/extent-tree.c:4754 followed by BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Wed, 07 Dec 2011 21:40:02 +0100
Message-ID: <vhv4r8-hb5.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs!

Recently I upgraded to 3.2.0-rc4 due to instabilities with my btrfs 
filesystem in 3.1.1. While with 3.1.1 my system completely froze, with 
3.2.0-rc4 it stays at least somehow usable (for some strange reason my xorg 
screen turns black as soon as this happens, only ssh is working then).

Scrubbing reports 1 uncorrectable error. I have this error since my system 
froze due to some xorg graphic driver instability (was trying out SNA 
acceleration for sandybridge).

The problematic file seems to be in /usr/portage but scrubbing doesn't tell 
me the filename (I was under the impression 3.2.x adds a patch which should 
report filenames). Everytime I run "emerge" (it is a gentoo system) my 
screen goes black after a few seconds and I can only revert to using ssh.

Problem is: As soon as this happens, some filesystem accesses block the 
process in disk state, it cannot be killed. This initiates some feedback 
loop: From now on any other process trying to access the FS freezes. I can 
only reisub now. It seems to be fine if data comes from cache instead from 
disk.

Any chance to fix the filesystem or make the kernel not getting stuck? I'd 
hate to recreate the fs from scratch again.

Using Linus' tree from git, tagged v3.2-rc4.

Here's my dmesg output:

[172816.292951] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[172816.292957] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[172816.292960] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[172816.292963] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[172816.292965] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[172816.292967] ------------[ cut here ]------------
[172816.292972] WARNING: at fs/btrfs/extent-tree.c:4754 
__btrfs_free_extent+0x290/0x5c7()
[172816.292974] Hardware name: To Be Filled By O.E.M.
[172816.292975] Modules linked in: zram(C) af_packet fuse snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 
nls_cp437 vfat fat reiserfs loop nfs tcp_cubic lockd auth_rpcgss nfs_acl 
sunrpc sg snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device 
gspca_sonixj gspca_main videodev usb_storage v4l2_compat_ioctl32 uas usbhid 
hid pcspkr evdev i2c_i801 unix [last unloaded: microcode]
[172816.293004] Pid: 6193, comm: btrfs-delayed-m Tainted: G         C   
3.2.0-rc4 #2
[172816.293005] Call Trace:
[172816.293010]  [<ffffffff8103327e>] ? warn_slowpath_common+0x78/0x8c
[172816.293012]  [<ffffffff8111ea5b>] ? __btrfs_free_extent+0x290/0x5c7
[172816.293014]  [<ffffffff810b2490>] ? __slab_free+0xd1/0x236
[172816.293016]  [<ffffffff81121d68>] ? run_clustered_refs+0x66c/0x6b8
[172816.293018]  [<ffffffff81121e7d>] ? btrfs_run_delayed_refs+0xc9/0x173
[172816.293021]  [<ffffffff8112faf0>] ? __btrfs_end_transaction+0x90/0x1dd
[172816.293024]  [<ffffffff810273b0>] ? should_resched+0x5/0x24
[172816.293027]  [<ffffffff81166981>] ? 
btrfs_async_run_delayed_node_done+0x16c/0x1ca
[172816.293029]  [<ffffffff8114f20f>] ? worker_loop+0x170/0x46d
[172816.293031]  [<ffffffff8114f09f>] ? btrfs_queue_worker+0x25b/0x25b
[172816.293033]  [<ffffffff8114f09f>] ? btrfs_queue_worker+0x25b/0x25b
[172816.293036]  [<ffffffff8104883b>] ? kthread+0x7a/0x82
[172816.293040]  [<ffffffff81415af4>] ? kernel_thread_helper+0x4/0x10
[172816.293042]  [<ffffffff810487c1>] ? kthread_worker_fn+0x135/0x135
[172816.293043]  [<ffffffff81415af0>] ? gs_change+0xb/0xb
[172816.293045] ---[ end trace 095cf6945c90cf63 ]---
[172816.293046] btrfs unable to find ref byte nr 1871181426688 parent 0 root 
2  owner 0 offset 0
[172816.293050] BUG: unable to handle kernel NULL pointer dereference at           
(null)
[172816.293054] IP: [<ffffffff81148998>] map_private_extent_buffer+0x9/0xde
[172816.293057] PGD 0 
[172816.293058] Oops: 0000 [#1] SMP 
[172816.293060] CPU 1 
[172816.293061] Modules linked in: zram(C) af_packet fuse snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss nls_iso8859_15 
nls_cp437 vfat fat reiserfs loop nfs tcp_cubic lockd auth_rpcgss nfs_acl 
sunrpc sg snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device 
gspca_sonixj gspca_main videodev usb_storage v4l2_compat_ioctl32 uas usbhid 
hid pcspkr evdev i2c_i801 unix [last unloaded: microcode]
[172816.293078] 
[172816.293079] Pid: 6193, comm: btrfs-delayed-m Tainted: G        WC   
3.2.0-rc4 #2 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
[172816.293083] RIP: 0010:[<ffffffff81148998>]  [<ffffffff81148998>] 
map_private_extent_buffer+0x9/0xde
[172816.293086] RSP: 0018:ffff8801bb847b00  EFLAGS: 00010286
[172816.293088] RAX: 0000000000000067 RBX: ffff8801bb847b40 RCX: 
ffff8801bb847b40
[172816.293090] RDX: 0000000000000004 RSI: 000000000000007a RDI: 
0000000000000000
[172816.293092] RBP: 0000000000000065 R08: ffff8801bb847b38 R09: 
ffff8801bb847b30
[172816.293103] R10: 0000000000000000 R11: 0000000000000009 R12: 
000000000000007a
[172816.293105] R13: 0000000000000000 R14: ffff8802350d0000 R15: 
0000000000000000
[172816.293107] FS:  0000000000000000(0000) GS:ffff88023fa80000(0000) 
knlGS:0000000000000000
[172816.293109] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[172816.293111] CR2: 0000000000000000 CR3: 0000000001805000 CR4: 
00000000000406e0
[172816.293113] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[172816.293115] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[172816.293117] Process btrfs-delayed-m (pid: 6193, threadinfo 
ffff8801bb846000, task ffff8801c73e12f0)
[172816.293119] Stack:
[172816.293120]  0000000000000000 ffffffff814125e0 0000000000000030 
0000000000000000
[172816.293123]  0000000000000065 ffffffff81140b49 0000000000000009 
000001b3ab1ab000
[172816.293126]  0000000000000000 0000000000000002 ffff880233cbb360 
00000000fffffffb
[172816.293129] Call Trace:
[172816.293140]  [<ffffffff814125e0>] ? printk+0x40/0x48
[172816.293153]  [<ffffffff81140b49>] ? btrfs_item_size+0x2c/0x62
[172816.293155]  [<ffffffff8111ea9b>] ? __btrfs_free_extent+0x2d0/0x5c7
[172816.293158]  [<ffffffff810b2490>] ? __slab_free+0xd1/0x236
[172816.293160]  [<ffffffff81121d68>] ? run_clustered_refs+0x66c/0x6b8
[172816.293162]  [<ffffffff81121e7d>] ? btrfs_run_delayed_refs+0xc9/0x173
[172816.293165]  [<ffffffff8112faf0>] ? __btrfs_end_transaction+0x90/0x1dd
[172816.293167]  [<ffffffff810273b0>] ? should_resched+0x5/0x24
[172816.293170]  [<ffffffff81166981>] ? 
btrfs_async_run_delayed_node_done+0x16c/0x1ca
[172816.293172]  [<ffffffff8114f20f>] ? worker_loop+0x170/0x46d
[172816.293175]  [<ffffffff8114f09f>] ? btrfs_queue_worker+0x25b/0x25b
[172816.293177]  [<ffffffff8114f09f>] ? btrfs_queue_worker+0x25b/0x25b
[172816.293179]  [<ffffffff8104883b>] ? kthread+0x7a/0x82
[172816.293182]  [<ffffffff81415af4>] ? kernel_thread_helper+0x4/0x10
[172816.293184]  [<ffffffff810487c1>] ? kthread_worker_fn+0x135/0x135
[172816.293186]  [<ffffffff81415af0>] ? gs_change+0xb/0xb
[172816.293188] Code: 8b 74 24 18 48 8b 7c 24 40 e8 99 cb ff ff 48 81 c4 88 
00 00 00 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 55 53 48 89 cb 48 83 ec 18 
[172816.293200]  8b 2f 81 e5 ff 0f 00 00 48 8d 04 2e 48 89 c1 4c 8d 54 10 ff 
[172816.293206] RIP  [<ffffffff81148998>] map_private_extent_buffer+0x9/0xde
[172816.293209]  RSP <ffff8801bb847b00>
[172816.293210] CR2: 0000000000000000
[172816.355504] ---[ end trace 095cf6945c90cf64 ]---

Regards,
Kai

