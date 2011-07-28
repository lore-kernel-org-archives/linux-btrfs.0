From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1693!
Date: Thu, 28 Jul 2011 12:57:00 -0600
Message-ID: <CALFpzo5MPj10Hkf2Peq3Zko9wE+DccxmS070S0VmRbFYEQk2pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I too have run into this just today, file system is nearly fresh:


------------[ cut here ]------------
kernel BUG at fs/btrfs/delayed-inode.c:1693!
invalid opcode: 0000 [#9] SMP
CPU 21
Modules linked in: btrfs zlib_deflate ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
serio_raw pcspkr amd64_edac_mod edac_core edac_mce_amd i2c_piix4
i2c_core igb dca sg ses enclosure ext4 mbcache jbd2 sd_mod crc_t10dif
ata_generic pata_acpi pata_atiixp ahci libahci megaraid_sas dm_mod
[last unloaded: scsi_wait_scan]

Pid: 4445, comm: cosd Tainted: G      D W   3.0.0 #5 Supermicro H8DGT/H8DGT
RIP: 0010:[<ffffffffa02756d0>]  [<ffffffffa02756d0>]
btrfs_delayed_update_inode+0x120/0x130 [btrfs]
RSP: 0018:ffff8807ea0ddbb8  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff8804814cebe8 RCX: 0000000000018000
RDX: 0000000000017000 RSI: 0000000000018000 RDI: ffff8807eb8f41d0
RBP: ffff8807ea0ddbf8 R08: 0000000000000000 R09: 0000000000000016
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8804814cec30
R13: ffff88067df691d8 R14: ffff8803f3a7da50 R15: ffff8807dea6a800
FS:  00007fb19f027700(0000) GS:ffff88081f4a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd83c1d2000 CR3: 00000007eba74000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cosd (pid: 4445, threadinfo ffff8807ea0dc000, task ffff8807eb022a80)
Stack:
 0000000000000001 0000000000018000 000000000000a7f0 ffff88067df691d8
 ffff8803f3a7da50 ffff88067df691d8 ffff880654f58a30 0000000000000000
 ffff8807ea0ddc48 ffffffffa0233a43 ffff8807ea5839a8 000000000000018c
Call Trace:
 [<ffffffffa0233a43>] btrfs_update_inode+0x53/0x160 [btrfs]
 [<ffffffffa025cfec>] btrfs_ioctl_clone+0x9bc/0xc90 [btrfs]
 [<ffffffffa025d5db>] btrfs_ioctl+0x31b/0xd20 [btrfs]
 [<ffffffff811675c9>] ? do_filp_open+0x49/0xa0
 [<ffffffff8116a27a>] do_vfs_ioctl+0x9a/0x540
 [<ffffffff8116a7c1>] sys_ioctl+0xa1/0xb0
 [<ffffffff8153eec2>] system_call_fastpath+0x16/0x1b
Code: 00 03 00 00 8d 0c 49 48 89 ca 48 89 4d c8 e8 28 db f9 ff 85 c0
48 8b 4d c8 75 10 48 89 4b 08 e9 40 ff ff ff 0f 1f 80 00 00 00 00 <0f>
0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48
RIP  [<ffffffffa02756d0>] btrfs_delayed_update_inode+0x120/0x130 [btrfs]
 RSP <ffff8807ea0ddbb8>
---[ end trace a90b454752c77b8a ]---


Just prior to this, lots of these:

------------[ cut here ]------------
WARNING: at fs/btrfs/inode.c:2194 btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
Hardware name: H8DGT
Modules linked in: btrfs zlib_deflate ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
serio_raw pcspkr amd64_edac_mod edac_core edac_mce_amd i2c_piix4
i2c_core igb dca sg ses enclosure ext4 mbcache jbd2 sd_mod crc_t10dif
ata_generic pata_acpi pata_atiixp ahci libahci megaraid_sas dm_mod
[last unloaded: scsi_wait_scan]
Pid: 5445, comm: kworker/14:0 Tainted: G        W   3.0.0 #5
Call Trace:
 [<ffffffff8106000f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106006a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa022f240>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
 [<ffffffffa022a835>] commit_fs_roots+0xc5/0x1b0 [btrfs]
 [<ffffffffa022b8ee>] btrfs_commit_transaction+0x40e/0x850 [btrfs]
 [<ffffffff81059e5f>] ? dequeue_task_fair+0x20f/0x220
 [<ffffffff8100a78b>] ? __switch_to+0x12b/0x320
 [<ffffffff810825d0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa022c000>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
 [<ffffffffa022c01f>] do_async_commit+0x1f/0x30 [btrfs]
 [<ffffffff8107b971>] process_one_work+0x131/0x450
 [<ffffffff8107d51c>] worker_thread+0x17c/0x3c0
 [<ffffffff8107d3a0>] ? manage_workers+0x220/0x220
 [<ffffffff81081f56>] kthread+0x96/0xa0
 [<ffffffff81540004>] kernel_thread_helper+0x4/0x10
 [<ffffffff81081ec0>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff81540000>] ? gs_change+0x13/0x13
---[ end trace a90b454752c77b80 ]---
