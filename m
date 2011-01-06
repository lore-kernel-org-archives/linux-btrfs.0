From: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Subject: Bug at inode.c and warning on btrfs_orphan_commit_root
Date: Thu, 6 Jan 2011 19:38:05 +0100
Message-ID: <14C7F4F06DB5814AB0DE29716C4F6D67177D4416@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

These traces appeared on my CEPH nodes (node 1 and 2) while running some iozone tests on the client.

Let me know if you need any other details.

- Jan


[18565.087014] ------------[ cut here ]------------
[18565.088005] kernel BUG at fs/btrfs/inode.c:6403!
[18565.088005] invalid opcode: 0000 [#1] SMP
[18565.088005] last sysfs file: /sys/module/btrfs/initstate
[18565.088005] CPU 0
[18565.088005] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc loop evdev radeon ttm drm_kms_helper drm e1000e i3200_edac snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_algo_bit shpchp pci_hotplug edac_core it8213 pcspkr i2c_core ide_core serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
[18565.088005]
[18565.088005] Pid: 2004, comm: cosd Not tainted 2.6.37 #7 X7SBi-LN4/X7SBi-LN4
[18565.088005] RIP: 0010:[<ffffffffa015d787>]  [<ffffffffa015d787>] btrfs_truncate+0x470/0x4a5 [btrfs]
[18565.088005] RSP: 0018:ffff88011841dd68  EFLAGS: 00010286
[18565.088005] RAX: 00000000ffffffe4 RBX: ffff8801171e9848 RCX: ffff88012bae0870
[18565.088005] RDX: 0000000000000000 RSI: ffffea000418e100 RDI: 0000000000000206
[18565.088005] RBP: ffff88011eac7000 R08: 0000000000000106 R09: ffff8801171e9848
[18565.088005] R10: 000000000000002c R11: ffff880128f94800 R12: ffff880128f94800
[18565.088005] R13: ffff8801171e9848 R14: 0000000000000000 R15: ffff8801171e9970
[18565.088005] FS:  00007ff3d3fe5710(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
[18565.088005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18565.088005] CR2: 00007ff3cad3d000 CR3: 000000011c2e3000 CR4: 00000000000406f0
[18565.088005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18565.088005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18565.088005] Process cosd (pid: 2004, threadinfo ffff88011841c000, task ffff88012b6f71b0)
[18565.088005] Stack:
[18565.088005]  ffff88011eac7000 ffffffff810e9cfe ffff88011eac7000 ffffffff810ce096
[18565.088005]  ffff8801171e96e0 0000000000000000 0000000000000000 0000000000000000
[18565.088005]  ffff8801171e96b0 0000100000000000 0000000000000000 0000000000000000
[18565.088005] Call Trace:
[18565.088005]  [<ffffffff810e9cfe>] ? virt_to_head_page+0x9/0x2d
[18565.088005]  [<ffffffff810ce096>] ? unmap_mapping_range+0x59/0xf5
[18565.088005]  [<ffffffff810bdf72>] ? vmtruncate+0x36/0x3e
[18565.088005]  [<ffffffffa015fdbb>] ? btrfs_setattr+0x1d5/0x230 [btrfs]
[18565.088005]  [<ffffffff8104b332>] ? current_fs_time+0x1e/0x24
[18565.088005]  [<ffffffff81104a61>] ? notify_change+0x195/0x27e
[18565.088005]  [<ffffffff810f15cb>] ? do_truncate+0x68/0x86
[18565.088005]  [<ffffffff810f9d92>] ? get_write_access+0x10/0x3a
[18565.088005]  [<ffffffff810f16da>] ? sys_truncate+0xf1/0x125
[18565.088005]  [<ffffffff810099d2>] ? system_call_fastpath+0x16/0x1b
[18565.088005] Code: 83 7b 5c 00 74 13 48 89 de 48 89 ef e8 9e e3 ff ff 85 c0 74 04 0f 0b eb fe 48 89 da 4c 89 e6 48 89 ef e8 da ad ff ff 85 c0 74 04 <0f> 0b eb fe 4c 89 e6 48 89 ef 48 8b 5d 20 e8 bf 7f ff ff 85 c0
[18565.088005] RIP  [<ffffffffa015d787>] btrfs_truncate+0x470/0x4a5 [btrfs]
[18565.088005]  RSP <ffff88011841dd68>






[18196.051725] ------------[ cut here ]------------
[18196.051746] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
[18196.051748] Hardware name: X7SBi-LN4
[18196.051750] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc loop snd_pcm snd_timer e1000e snd soundcore i2c_i801 snd_page_alloc parport_pc radeon ttm tpm_tis parport drm_kms_helper tpm video tpm_bios it8213 evdev drm i3200_edac i2c_algo_bit ghes i2c_core hed container output edac_core ide_core processor pcspkr button thermal_sys serio_raw shpchp pci_hotplug ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_piix ata_generic libata scsi_mod
[18196.051780] Pid: 17053, comm: kworker/2:0 Not tainted 2.6.37 #7
[18196.051781] Call Trace:
[18196.051787]  [<ffffffff81046dac>] ? warn_slowpath_common+0x78/0x8c
[18196.051798]  [<ffffffffa014fde3>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[18196.051807]  [<ffffffffa014820c>] ? commit_fs_roots+0x8d/0xf4 [btrfs]
[18196.051817]  [<ffffffffa0149289>] ? btrfs_commit_transaction+0x34b/0x61f [btrfs]
[18196.051821]  [<ffffffff8105fd51>] ? autoremove_wake_function+0x0/0x2a
[18196.051831]  [<ffffffffa0149780>] ? do_async_commit+0x0/0x1b [btrfs]
[18196.051841]  [<ffffffffa0149792>] ? do_async_commit+0x12/0x1b [btrfs]
[18196.051843]  [<ffffffff8105b06c>] ? process_one_work+0x1d1/0x2ee
[18196.051846]  [<ffffffff8105ca83>] ? worker_thread+0x12d/0x247
[18196.051848]  [<ffffffff8105c956>] ? worker_thread+0x0/0x247
[18196.051851]  [<ffffffff8105c956>] ? worker_thread+0x0/0x247
[18196.051853]  [<ffffffff8105f8ff>] ? kthread+0x7a/0x82
[18196.051856]  [<ffffffff8100a7e4>] ? kernel_thread_helper+0x4/0x10
[18196.051858]  [<ffffffff8105f885>] ? kthread+0x0/0x82
[18196.051861]  [<ffffffff8100a7e0>] ? kernel_thread_helper+0x0/0x10
[18196.051863] ---[ end trace 212766401439239a ]---


