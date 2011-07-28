From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2204
Date: Thu, 28 Jul 2011 13:04:32 -0600
Message-ID: <CALFpzo55Tz7BXtemwN2Yq3b+iQmi2K4kHQVDW4xsk4o6OoTd5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Ahh , this was the kernel warning you mentioned over at ceph.  I just
ran into it as well, with a fresh ceph system, all storage nodes are
doing it (must be the cool thing), seems to have led to (or
coincidentally followed by) the "kernel BUG at
fs/btrfs/delayed-inode.c:1693!" emailed about.

WARNING: at fs/btrfs/inode.c:2194 btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
Hardware name: H8DGT
Modules linked in: btrfs zlib_deflate ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6
serio_raw pcspkr amd64_edac_mod edac_core edac_mce_amd i2c_piix4
i2c_core igb dca sg ses enclosure ext4 mbcache jbd2 sd_mod crc_t10dif
ata_generic pata_acpi pata_atiixp ahci libahci megaraid_sas dm_mod
[last unloaded: scsi_wait_scan]
Pid: 3066, comm: kworker/13:2 Tainted: G        W   3.0.0 #5
Call Trace:
 [<ffffffff8106000f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106006a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa022f240>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
 [<ffffffffa022a835>] commit_fs_roots+0xc5/0x1b0 [btrfs]
 [<ffffffffa022b8ee>] btrfs_commit_transaction+0x40e/0x850 [btrfs]
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
---[ end trace a90b454752c77b78 ]---
