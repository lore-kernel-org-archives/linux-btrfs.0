From: Hector Ordorica <hector@ucsd.edu>
Subject: Recent btrfs segfault
Date: Wed, 18 Nov 2009 22:01:59 -0800
Message-ID: <6700d24e0911182201t1db5cbc1i2a8539ef8a15c84b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm really not to sure who to report this too, but my btrfs / partiton
segfaults when mounting. It also segfaults when trying to run btrfsck.

My setup:
Gentoo x64 install in Virtualbox (Windows 7 x64 host). 2.6.32_rc6
kernel. Recently converted from an ext4 filesystem with the
btrfs-convert utility. It seemed to work fine. I also mounted with the
compress option in an attempt to keep the virtual machine small.

It was working fine for a few days, but today Virtualbox crashed due
to incompatible virtualbox video modules after an update. After I
restarted the virtual machine, I started getting segfaults.

I booted a Ubuntu 9.10 VM to access my gentoo disk.

mount /dev/sdb3 /btrfs:

[ 1136.297328] device fsid dc43d4bf8be37f3a-84dc6c711faedd88 devid 1
transid 746 /dev/sdb3
[ 1136.349595] btrfs: unlinked 6 orphans

so far so good.

Then I try to browse the partiton:

cd /btrfs

[ 1166.443802] btrfs bad tree block start 10009583616 10002092032

Now I start nautilus /btrfs

[ 1491.040914] btrfs bad tree block start 10009583616 10002092032
[ 1491.040961] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000030
[ 1491.040964] IP: [<ffffffffa03c6bdf>] btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.040975] PGD 274ff067 PUD 274fe067 PMD 0
[ 1491.040977] Oops: 0000 [#1] SMP
[ 1491.040978] last sysfs file:
/sys/devices/pci0000:00/0000:00:0d.0/host1/target1:0:0/1:0:0:0/model
[ 1491.040980] CPU 3
[ 1491.040981] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
isofs udf crc_itu_t vboxvideo drm binfmt_misc vboxvfs vboxnetflt
vboxnetadp vboxdrv snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event vboxguest psmouse serio_raw
iptable_filter snd_seq i2c_piix4 ip_tables snd_timer lp snd_seq_device
x_tables snd soundcore snd_page_alloc ppdev parport_pc parport
virtio_net virtio_pci virtio_ring virtio
[ 1491.040999] Pid: 2280, comm: nautilus Not tainted 2.6.31-14-generic
#48-Ubuntu VirtualBox
[ 1491.041000] RIP: 0010:[<ffffffffa03c6bdf>]  [<ffffffffa03c6bdf>]
btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.041007] RSP: 0018:ffff8800274f9af8  EFLAGS: 00010283
[ 1491.041008] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: 0000000000000004
[ 1491.041009] RDX: 0000000000000008 RSI: 0000000000000000 RDI: ffff88002ae2e800
[ 1491.041010] RBP: ffff8800274f9b78 R08: 0000000000000001 R09: 0000000000000000
[ 1491.041012] R10: 0000000000000000 R11: 00000000ffffffff R12: 00000002541fe000
[ 1491.041013] R13: 00000000fffffffb R14: 0000000000000005 R15: 0000000000000000
[ 1491.041014] FS:  00007fda227d8910(0000) GS:ffff880001a4e000(0000)
knlGS:0000000000000000
[ 1491.041015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1491.041016] CR2: 0000000000000030 CR3: 000000002d0be000 CR4: 00000000000006e0
[ 1491.041020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1491.041021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1491.041022] Process nautilus (pid: 2280, threadinfo
ffff8800274f8000, task ffff88003c8f96b0)
[ 1491.041023] Stack:
[ 1491.041024]  ffff880043f8f800 00000002541fe000 0000000000000246
ffff88002ae2e800
[ 1491.041026] <0> ffff8800274f9b68 ffffffff81115466 00000002541fe000
00000000001000a8
[ 1491.041028] <0> 0000000000000000 ffff88002ae2d000 00000002541fe000
ffff880029857ea0
[ 1491.041030] Call Trace:
[ 1491.041034]  [<ffffffff81115466>] ? kmem_cache_alloc+0x126/0x150
[ 1491.041040]  [<ffffffffa03c3adf>] __btrfs_free_extent+0x6ef/0x7f0 [btrfs]
[ 1491.041047]  [<ffffffffa03bdd43>] ? update_reserved_extents+0x63/0xf0 [btrfs]
[ 1491.041053]  [<ffffffffa03c41a2>] run_delayed_tree_ref+0x172/0x180 [btrfs]
[ 1491.041054]  [<ffffffff811144d1>] ? __slab_free+0x91/0x120
[ 1491.041060]  [<ffffffffa03c43b1>] run_one_delayed_ref+0x81/0xb0 [btrfs]
[ 1491.041067]  [<ffffffffa03c4d04>] run_clustered_refs+0xc4/0x230 [btrfs]
[ 1491.041073]  [<ffffffffa03c4f3a>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
[ 1491.041080]  [<ffffffffa03d021c>] __btrfs_end_transaction+0x5c/0x120 [btrfs]
[ 1491.041087]  [<ffffffffa03d02fb>] btrfs_end_transaction+0xb/0x10 [btrfs]
[ 1491.041094]  [<ffffffffa03d51ef>] btrfs_dirty_inode+0x4f/0x60 [btrfs]
[ 1491.041097]  [<ffffffff8113f9d6>] __mark_inode_dirty+0x36/0x130
[ 1491.041099]  [<ffffffff811340d4>] touch_atime+0xf4/0x150
[ 1491.041101]  [<ffffffff81122f4d>] sys_readlinkat+0x9d/0xc0
[ 1491.041103]  [<ffffffff81122f86>] sys_readlink+0x16/0x20
[ 1491.041106]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
[ 1491.041107] Code: 75 f0 4c 8b 7d f8 c9 c3 0f 1f 40 00 55 48 89 e5
48 83 c4 80 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 6d e8 4c 89 75 f0
4c 89 7d f8 <48> 8b 46 30 65 48 8b 14 25 88 cb 00 00 83 82 44 e0 ff ff
01 49
[ 1491.041122] RIP  [<ffffffffa03c6bdf>] btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.041128]  RSP <ffff8800274f9af8>
[ 1491.041129] CR2: 0000000000000030
[ 1491.041130] ---[ end trace 4bb0a2bcbc497d88 ]---
[ 1491.436402] btrfs bad tree block start 10009583616 10002092032
[ 1491.436423] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000030
[ 1491.436426] IP: [<ffffffffa03c6bdf>] btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.436461] PGD 354f2067 PUD 44d5f067 PMD 0
[ 1491.436465] Oops: 0000 [#2] SMP
[ 1491.436468] last sysfs file:
/sys/devices/pci0000:00/0000:00:0d.0/host1/target1:0:0/1:0:0:0/model
[ 1491.436470] CPU 0
[ 1491.436472] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
isofs udf crc_itu_t vboxvideo drm binfmt_misc vboxvfs vboxnetflt
vboxnetadp vboxdrv snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event vboxguest psmouse serio_raw
iptable_filter snd_seq i2c_piix4 ip_tables snd_timer lp snd_seq_device
x_tables snd soundcore snd_page_alloc ppdev parport_pc parport
virtio_net virtio_pci virtio_ring virtio
[ 1491.436501] Pid: 2245, comm: btrfs-transacti Tainted: G      D
2.6.31-14-generic #48-Ubuntu VirtualBox
[ 1491.436504] RIP: 0010:[<ffffffffa03c6bdf>]  [<ffffffffa03c6bdf>]
btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.436516] RSP: 0018:ffff88002d02da80  EFLAGS: 00010283
[ 1491.436518] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: 0000000000000004
[ 1491.436519] RDX: 0000000000000008 RSI: 0000000000000000 RDI: ffff88002ae2e800
[ 1491.436521] RBP: ffff88002d02db00 R08: 0000000000000001 R09: 0000000a6816c0b4
[ 1491.436523] R10: 0000000000000001 R11: 00000000ffffffff R12: 00000002541f8000
[ 1491.436525] R13: 00000000fffffffb R14: 0000000000000002 R15: 0000000000000000
[ 1491.436528] FS:  0000000000000000(0000) GS:ffff8800019f4000(0000)
knlGS:0000000000000000
[ 1491.436530] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1491.436532] CR2: 0000000000000030 CR3: 00000000451ef000 CR4: 00000000000006f0
[ 1491.436537] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1491.436540] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1491.436542] Process btrfs-transacti (pid: 2245, threadinfo
ffff88002d02c000, task ffff8800449b5ac0)
[ 1491.436544] Stack:
[ 1491.436545]  0000000000000000 00000002541f8000 ffff88002d02daa0
ffff88002ae2e800
[ 1491.436548] <0> ffff88002d02daf0 ffffffff81115466 00000002541f8000
00000000001000a8
[ 1491.436551] <0> 0000000000000000 ffff88002ae2a000 00000002541f8000
ffff8800285e27e0
[ 1491.436555] Call Trace:
[ 1491.436561]  [<ffffffff81115466>] ? kmem_cache_alloc+0x126/0x150
[ 1491.436572]  [<ffffffffa03c3adf>] __btrfs_free_extent+0x6ef/0x7f0 [btrfs]
[ 1491.436583]  [<ffffffffa03bdd43>] ? update_reserved_extents+0x63/0xf0 [btrfs]
[ 1491.436594]  [<ffffffffa03c41a2>] run_delayed_tree_ref+0x172/0x180 [btrfs]
[ 1491.436597]  [<ffffffff811144d1>] ? __slab_free+0x91/0x120
[ 1491.436607]  [<ffffffffa03c43b1>] run_one_delayed_ref+0x81/0xb0 [btrfs]
[ 1491.436618]  [<ffffffffa03c4d04>] run_clustered_refs+0xc4/0x230 [btrfs]
[ 1491.436629]  [<ffffffffa03c4f3a>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
[ 1491.436633]  [<ffffffff81527ef9>] ? mutex_lock+0x19/0x50
[ 1491.436647]  [<ffffffffa03ea22e>] ?
btrfs_run_ordered_operations+0x1ee/0x210 [btrfs]
[ 1491.436659]  [<ffffffffa03d0fef>] btrfs_commit_transaction+0x9f/0x7a0 [btrfs]
[ 1491.436664]  [<ffffffff81078b30>] ? autoremove_wake_function+0x0/0x40
[ 1491.436676]  [<ffffffffa03d05e6>] ? start_transaction+0x106/0x140 [btrfs]
[ 1491.436688]  [<ffffffffa03cb7b1>] transaction_kthread+0x211/0x240 [btrfs]
[ 1491.436699]  [<ffffffffa03cb5a0>] ? transaction_kthread+0x0/0x240 [btrfs]
[ 1491.436702]  [<ffffffff81078746>] kthread+0xa6/0xb0
[ 1491.436706]  [<ffffffff810130ea>] child_rip+0xa/0x20
[ 1491.436709]  [<ffffffff810786a0>] ? kthread+0x0/0xb0
[ 1491.436711]  [<ffffffff810130e0>] ? child_rip+0x0/0x20
[ 1491.436712] Code: 75 f0 4c 8b 7d f8 c9 c3 0f 1f 40 00 55 48 89 e5
48 83 c4 80 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 6d e8 4c 89 75 f0
4c 89 7d f8 <48> 8b 46 30 65 48 8b 14 25 88 cb 00 00 83 82 44 e0 ff ff
01 49
[ 1491.436740] RIP  [<ffffffffa03c6bdf>] btrfs_print_leaf+0x1f/0x570 [btrfs]
[ 1491.436751]  RSP <ffff88002d02da80>
[ 1491.436752] CR2: 0000000000000030
[ 1491.437001] ---[ end trace 4bb0a2bcbc497d89 ]---

At this point the filesystem cannot be unmounted or browsed and I have
to restart the VM to unmount.

I am able to access my files and read them fine if I mount read only.
I can easily copy to another partition (virtual disks), so I am more
interested in trying to figure out if btrfsck can be fixed to solve my
problem.

btrfsck /dev/sdb3

[   31.095703] btrfsck[2201]: segfault at c4 ip 000000000040f01e sp
00007fff95c4fe30 error 4 in btrfsck[400000+1d000]

My home partition with btrfs is ok:

root@Ubuntu:~# btrfsck /dev/sdb4

root 256 inode 257 errors 800
found 504918016 bytes used err is 1
total csum bytes: 98204
total tree bytes: 2203648
total fs tree bytes: 1908736
btree space waste bytes: 555881
file data blocks allocated: 600379392
 referenced 597245952
Btrfs Btrfs v0.19


Any tips? How can I help troubleshoot in Ubuntu 9.10
