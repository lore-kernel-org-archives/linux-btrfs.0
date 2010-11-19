From: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Subject: Btrfs_truncate ?
Date: Fri, 19 Nov 2010 08:21:21 +0100
Message-ID: <14C7F4F06DB5814AB0DE29716C4F6D671720BCEA@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

This happened when running an iozone test over ceph, it was doing lots of random reads. 

I have no idea how to properly interpret this, I should find it out. Let me know if you need something else.

Thanks!



[69003.803272] ------------[ cut here ]------------
[69003.807987] kernel BUG at fs/btrfs/inode.c:6230!
[69003.807987] invalid opcode: 0000 [#1] SMP
[69003.807987] last sysfs file: /sys/module/btrfs/initstate
[69003.807987] CPU 0
[69003.807987] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc bonding loop evdev radeon ttm snd_pcm snd_timer drm_kms_helper snd drm i2c_algo_bit i2c_i801 soundcore snd_page_alloc i2c_core i3200_edac e1000e shpchp pci_hotplug edac_core it8213 pcspkr ide_core serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
[69003.807987]
[69003.807987] Pid: 1666, comm: cosd Not tainted 2.6.37-rc1+ #1 X7SBi-LN4/X7SBi-LN4
[69003.807987] RIP: 0010:[<ffffffffa015250e>]  [<ffffffffa015250e>] btrfs_truncate+0x447/0x47c [btrfs]
[69003.807987] RSP: 0018:ffff880127723d68  EFLAGS: 00010286
[69003.807987] RAX: 00000000ffffffe4 RBX: ffff880127b11848 RCX: ffff88012bab8bd0
[69003.807987] RDX: 0000000000000000 RSI: ffffea000418d840 RDI: 0000000000000206
[69003.807987] RBP: ffff880127910900 R08: 0000000000000106 R09: ffff880127b11848
[69003.807987] R10: 0000000000000002 R11: ffff880128667000 R12: ffff880128667000
[69003.807987] R13: ffff880127b11848 R14: 0000000000000000 R15: ffff880127b11970
[69003.807987] FS:  00007f806d7a3710(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
[69003.807987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[69003.807987] CR2: 00007ff9ceb7f000 CR3: 0000000127489000 CR4: 00000000000406f0
[69003.807987] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[69003.807987] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[69003.807987] Process cosd (pid: 1666, threadinfo ffff880127722000, task ffff8801274caed0)
[69003.807987] Stack:
[69003.807987]  ffff880127910900 ffffffff810ea526 ffff880127910900 ffffffff810ce78a
[69003.807987]  ffff880127b116e0 0000000000000000 0000000000000000 0000000000000000
[69003.807987]  ffff880127b116b0 0000100000000000 0000000000000000 0000000000000000
[69003.807987] Call Trace:
[69003.807987]  [<ffffffff810ea526>] ? virt_to_head_page+0x9/0x2d
[69003.807987]  [<ffffffff810ce78a>] ? unmap_mapping_range+0x59/0xf5
[69003.807987]  [<ffffffff810be8f1>] ? vmtruncate+0x36/0x41
[69003.807987]  [<ffffffffa0152718>] ? btrfs_setattr+0x1d5/0x230 [btrfs]
[69003.807987]  [<ffffffff8104b2b6>] ? current_fs_time+0x1e/0x24
[69003.807987]  [<ffffffff811055e5>] ? notify_change+0x195/0x27e
[69003.807987]  [<ffffffff810f1f4a>] ? do_truncate+0x68/0x86
[69003.807987]  [<ffffffff810fa6a4>] ? get_write_access+0x10/0x3a
[69003.807987]  [<ffffffff810f2059>] ? sys_truncate+0xf1/0x125
[69003.807987]  [<ffffffff81009a82>] ? system_call_fastpath+0x16/0x1b
[69003.807987] Code: 83 7b 5c 00 74 13 48 89 de 48 89 ef e8 50 e1 ff ff 85 c0 74 04 0f 0b eb fe 48 89 da 4c 89 e6 48 89 ef e8 0d 9d ff ff 85 c0 74 04 <0f> 0b eb fe 48 8b 5d 20 4c 89 e6 48 89 ef e8 59 70 ff ff 85 c0
[69003.807987] RIP  [<ffffffffa015250e>] btrfs_truncate+0x447/0x47c [btrfs]
[69003.807987]  RSP <ffff880127723d68>
[69004.051172] ---[ end trace f6f04441e6b02726 ]---
[69374.600892] ------------[ cut here ]------------
[69374.606357] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
[69374.611890] Hardware name: X7SBi-LN4
[69374.617420] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc bonding loop evdev radeon ttm snd_pcm snd_timer drm_kms_helper snd drm i2c_algo_bit i2c_i801 soundcore snd_page_alloc i2c_core i3200_edac e1000e shpchp pci_hotplug edac_core it8213 pcspkr ide_core serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
[69374.635897] Pid: 2447, comm: kworker/1:0 Tainted: G      D     2.6.37-rc1+ #1
[69374.642049] Call Trace:
[69374.648229]  [<ffffffff81046c88>] ? warn_slowpath_common+0x78/0x8c
[69374.648239]  [<ffffffffa015091c>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[69374.648248]  [<ffffffffa0148064>] ? commit_fs_roots+0x8d/0xf4 [btrfs]
[69374.648258]  [<ffffffffa01490aa>] ? btrfs_commit_transaction+0x34b/0x61f [btrfs]
[69374.648264]  [<ffffffff81060101>] ? autoremove_wake_function+0x0/0x2a
[69374.648273]  [<ffffffffa01495a1>] ? do_async_commit+0x0/0x1b [btrfs]
[69374.648282]  [<ffffffffa01495b3>] ? do_async_commit+0x12/0x1b [btrfs]
[69374.648285]  [<ffffffff8105b3e4>] ? process_one_work+0x1d1/0x2ee
[69374.648287]  [<ffffffff8105ce09>] ? worker_thread+0x12d/0x247
[69374.648289]  [<ffffffff8105ccdc>] ? worker_thread+0x0/0x247
[69374.648291]  [<ffffffff8105ccdc>] ? worker_thread+0x0/0x247
[69374.648293]  [<ffffffff8105fcac>] ? kthread+0x7a/0x82
[69374.648297]  [<ffffffff8100a8a4>] ? kernel_thread_helper+0x4/0x10
[69374.648299]  [<ffffffff8105fc32>] ? kthread+0x0/0x82
[69374.648301]  [<ffffffff8100a8a0>] ? kernel_thread_helper+0x0/0x10
[69374.648303] ---[ end trace f6f04441e6b02727 ]---
[69598.338584] ------------[ cut here ]------------
[69598.343634] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
[69598.348771] Hardware name: X7SBi-LN4
[69598.353906] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc bonding loop evdev radeon ttm snd_pcm snd_timer drm_kms_helper snd drm i2c_algo_bit i2c_i801 soundcore snd_page_alloc i2c_core i3200_edac e1000e shpchp pci_hotplug edac_core it8213 pcspkr ide_core serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
[69598.370837] Pid: 2447, comm: kworker/1:0 Tainted: G      D W   2.6.37-rc1+ #1
[69598.376496] Call Trace:
[69598.382119]  [<ffffffff81046c88>] ? warn_slowpath_common+0x78/0x8c
[69598.387829]  [<ffffffffa015091c>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[69598.393639]  [<ffffffffa0148064>] ? commit_fs_roots+0x8d/0xf4 [btrfs]
[69598.399429]  [<ffffffffa01490aa>] ? btrfs_commit_transaction+0x34b/0x61f [btrfs]
[69598.405245]  [<ffffffff81060101>] ? autoremove_wake_function+0x0/0x2a
[69598.411074]  [<ffffffffa01495a1>] ? do_async_commit+0x0/0x1b [btrfs]
[69598.416939]  [<ffffffffa01495b3>] ? do_async_commit+0x12/0x1b [btrfs]
[69598.422777]  [<ffffffff8105b3e4>] ? process_one_work+0x1d1/0x2ee
[69598.428641]  [<ffffffff8105ce09>] ? worker_thread+0x12d/0x247
[69598.434526]  [<ffffffff8105ccdc>] ? worker_thread+0x0/0x247
[69598.440388]  [<ffffffff8105ccdc>] ? worker_thread+0x0/0x247
[69598.446071]  [<ffffffff8105fcac>] ? kthread+0x7a/0x82
[69598.451595]  [<ffffffff8100a8a4>] ? kernel_thread_helper+0x4/0x10
[69598.457078]  [<ffffffff8105fc32>] ? kthread+0x0/0x82
[69598.462509]  [<ffffffff8100a8a0>] ? kernel_thread_helper+0x0/0x10
[69598.467942] ---[ end trace f6f04441e6b02728 ]