From: Christian Brunner <chb@muc.de>
Subject: WARNING: at fs/btrfs/inode.c:2204
Date: Thu, 21 Jul 2011 16:17:15 +0200
Message-ID: <CAO47_--0gzs9XzQVYynX76-DHrqh98-ifhLFnuAx9wj8kQpikQ@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm running a Ceph Object Store with 3.0-rc7 and patches from Josef.
Occasionally I get the attached warning.

Everything seems to be working after this warning, but I am concerned...

Thanks,
Christian

[13319.808020] ------------[ cut here ]------------
[13319.813284] WARNING: at fs/btrfs/inode.c:2204
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[13319.822563] Hardware name: ProLiant DL180 G6
[13319.827586] Modules linked in: btrfs zlib_deflate libcrc32c bonding
ipv6 serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
[last unloaded: scsi_wait_scan]
[13319.851192] Pid: 23617, comm: kworker/6:0 Tainted: P
3.0.0-1.fits.2.el6.x86_64 #1
[13319.860661] Call Trace:
[13319.863433]  [<ffffffff8106306f>] warn_slowpath_common+0x7f/0xc0
[13319.870172]  [<ffffffff810630ca>] warn_slowpath_null+0x1a/0x20
[13319.876724]  [<ffffffffa022d030>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
[13319.884633]  [<ffffffffa0227e05>] commit_fs_roots+0xc5/0x1b0 [btrfs]
[13319.891762]  [<ffffffffa02288ae>]
btrfs_commit_transaction+0x3ce/0x840 [btrfs]
[13319.899917]  [<ffffffff8105cb6f>] ? dequeue_task_fair+0x20f/0x220
[13319.906726]  [<ffffffff8100a38b>] ? __switch_to+0x12b/0x320
[13319.912943]  [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
[13319.918971]  [<ffffffffa0228ff0>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
[13319.926775]  [<ffffffffa022900f>] do_async_commit+0x1f/0x30 [btrfs]
[13319.933825]  [<ffffffff8107e388>] process_one_work+0x128/0x450
[13319.940419]  [<ffffffff8108116b>] worker_thread+0x17b/0x3c0
[13319.946670]  [<ffffffff81080ff0>] ? manage_workers+0x220/0x220
[13319.953210]  [<ffffffff81085836>] kthread+0x96/0xa0
[13319.958682]  [<ffffffff81562b44>] kernel_thread_helper+0x4/0x10
[13319.965316]  [<ffffffff810857a0>] ? kthread_worker_fn+0x1a0/0x1a0
[13319.972183]  [<ffffffff81562b40>] ? gs_change+0x13/0x13
[13319.978065] ---[ end trace 942778a443791443 ]---
