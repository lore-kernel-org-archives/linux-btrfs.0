From: "Jim Schutt" <jaschut@sandia.gov>
Subject: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Tue, 10 Apr 2012 13:39:14 -0600
Message-ID: <4F848C62.6030100@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I hit this BUG today.

I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
i.e. 3.3.1 +
   commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
   commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"

The btrfs filesystem in question is backing a Ceph OSD under
a heavy write load.

Here's the bug:

[510342.517157] ------------[ cut here ]------------
[510342.521855] kernel BUG at fs/btrfs/extent_io.c:3982!
[510342.526894] invalid opcode: 0000 [#1] SMP
[510342.531102] CPU 4
[510342.533028] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa iw_cxgb4 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun kvm uinput sg sd_mod joydev ata_piix libata button microcode mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ehci_hcd uhci_hcd ioatdma dm_mod i7core_edac edac_core nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 igb dca e1000 [last unloaded: scsi_wait_scan]
[510342.587836]
[510342.589412] Pid: 16609, comm: kworker/4:2 Not tainted 3.3.1-00162-gd8b2857 #15 Supermicro X8DTH-i/6/iF/6F/X8DTH
[510342.599601] RIP: 0010:[<ffffffffa057924c>]  [<ffffffffa057924c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[510342.610893] RSP: 0018:ffff88015fb6ba10  EFLAGS: 00010202
[510342.616277] RAX: 0000000000000004 RBX: ffff880ab81865a0 RCX: ffff880174bc0230
[510342.623476] RDX: ffff8801335bf9b1 RSI: 00000000000d0fb8 RDI: ffff880ab81865a0
[510342.630675] RBP: ffff88015fb6ba40 R08: 0000000000000038 R09: 0000000000000003
[510342.637874] R10: 0000000000000008 R11: ffff8804658c9e40 R12: ffff88015fb6a000
[510342.645069] R13: ffff880ab81865a0 R14: 000000000000000e R15: ffff88015fb6bc10
[510342.652268] FS:  0000000000000000(0000) GS:ffff880627c80000(0000) knlGS:0000000000000000
[510342.660418] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[510342.666234] CR2: ffffffffff600400 CR3: 0000000001a05000 CR4: 00000000000006e0
[510342.673427] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[510342.680627] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[510342.687827] Process kworker/4:2 (pid: 16609, threadinfo ffff88015fb6a000, task ffff880102ca4410)
[510342.696669] Stack:
[510342.698769]  ffff880100000000 ffff880ab81865a0 ffff88015fb6a000 ffff8806057d2eb0
[510342.706297]  000000000000000e ffff88015fb6bc10 ffff88015fb6ba70 ffffffffa05793f2
[510342.713825]  ffff88015fb6bb80 ffff880ab81865a0 ffff88015fb6bb50 0000000000000008
[510342.721362] Call Trace:
[510342.723912]  [<ffffffffa05793f2>] release_extent_buffer+0xa2/0xe0 [btrfs]
[510342.730790]  [<ffffffffa05795b4>] free_extent_buffer+0x34/0x80 [btrfs]
[510342.737407]  [<ffffffffa057a126>] btree_write_cache_pages+0x246/0x410 [btrfs]
[510342.744637]  [<ffffffffa054e96a>] btree_writepages+0x3a/0x50 [btrfs]
[510342.751060]  [<ffffffff810fc421>] do_writepages+0x21/0x40
[510342.756537]  [<ffffffff810f0b0b>] __filemap_fdatawrite_range+0x5b/0x60
[510342.763136]  [<ffffffff810f0de3>] filemap_fdatawrite_range+0x13/0x20
[510342.769568]  [<ffffffffa0554ecf>] btrfs_write_marked_extents+0x7f/0xe0 [btrfs]
[510342.776867]  [<ffffffffa0554f5e>] btrfs_write_and_wait_marked_extents+0x2e/0x60 [btrfs]
[510342.784951]  [<ffffffffa0554fbb>] btrfs_write_and_wait_transaction+0x2b/0x50 [btrfs]
[510342.792768]  [<ffffffffa055604c>] btrfs_commit_transaction+0x7ac/0xa10 [btrfs]
[510342.800060]  [<ffffffff81079540>] ? set_next_entity+0x90/0xa0
[510342.805875]  [<ffffffff8105f5d0>] ? wake_up_bit+0x40/0x40
[510342.811365]  [<ffffffffa0556590>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[510342.818403]  [<ffffffffa05565af>] do_async_commit+0x1f/0x30 [btrfs]
[510342.824748]  [<ffffffffa0556590>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[510342.831774]  [<ffffffff81058680>] process_one_work+0x140/0x490
[510342.837673]  [<ffffffff8105a417>] worker_thread+0x187/0x3f0
[510342.843319]  [<ffffffff8105a290>] ? manage_workers+0x120/0x120
[510342.849225]  [<ffffffff8105f02e>] kthread+0x9e/0xb0
[510342.854176]  [<ffffffff81486c64>] kernel_thread_helper+0x4/0x10
[510342.860168]  [<ffffffff8147d84a>] ? retint_restore_args+0xe/0xe
[510342.866161]  [<ffffffff8105ef90>] ? kthread_freezable_should_stop+0x80/0x80
[510342.873198]  [<ffffffff81486c60>] ? gs_change+0xb/0xb
[510342.878322] Code: 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 8b 47 38 49 89 fd 85 c0 75 0c 48 8b 47 20 4c 8d 7f 20 84 c0 79 04 <0f> 0b eb fe 48 8b 47 20 a8 04 75 f4 48 8b 07 49 89 c4 4c 03 67
[510342.898331] RIP  [<ffffffffa057924c>] btrfs_release_extent_buffer_page.clone.0+0x2c/0x130 [btrfs]
[510342.907294]  RSP <ffff88015fb6ba10>
[510342.911241] ---[ end trace 62013c6b6e2e5135 ]---


Please let me know if there is anything I can do
to help track this down.

Thanks -- Jim

