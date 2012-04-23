From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Ceph on btrfs 3.4rc
Date: Mon, 23 Apr 2012 09:20:42 +0200
Message-ID: <CAJafhzTjrW1Ueva7RKi42yFKCip9YDdcTd0HXFUp+o+ubMHjcQ@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I decided to run the test over the weekend. The good news is, that the
system is still running without performance degradation. But in the
meantime I've got over 5000 WARNINGs of this kind:

[330700.043557] btrfs: block rsv returned -28
[330700.043559] ------------[ cut here ]------------
[330700.048898] WARNING: at fs/btrfs/extent-tree.c:6220
btrfs_alloc_free_block+0x357/0x370 [btrfs]()
[330700.058880] Hardware name: ProLiant DL180 G6
[330700.064044] Modules linked in: btrfs zlib_deflate libcrc32c xfs
exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
iTCO_vendor_support i7core_edac edac_core ixgbe dca mdio
iomemory_vsl(PO) hpsa squashfs [last unloaded: scsi_wait_scan]
[330700.090361] Pid: 7954, comm: btrfs-endio-wri Tainted: P        W
O 3.3.2-1.fits.1.el6.x86_64 #1
[330700.100393] Call Trace:
[330700.103263]  [<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
[330700.110201]  [<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
[330700.116905]  [<ffffffffa03436f7>] btrfs_alloc_free_block+0x357/0x37=
0 [btrfs]
[330700.124988]  [<ffffffffa0330eb0>] ? __btrfs_cow_block+0x330/0x530 [=
btrfs]
[330700.132787]  [<ffffffffa0398174>] ?
btrfs_add_delayed_data_ref+0x64/0x1c0 [btrfs]
[330700.141369]  [<ffffffffa0372d8b>] ? read_extent_buffer+0xbb/0x120 [=
btrfs]
[330700.149194]  [<ffffffffa0365d6d>] ?
btrfs_token_item_offset+0x5d/0xe0 [btrfs]
[330700.157373]  [<ffffffffa0330cb3>] __btrfs_cow_block+0x133/0x530 [bt=
rfs]
[330700.165023]  [<ffffffffa032f2ed>] ?
read_block_for_search+0x14d/0x3d0 [btrfs]
[330700.173183]  [<ffffffffa0331684>] btrfs_cow_block+0xf4/0x1f0 [btrfs=
]
[330700.180552]  [<ffffffffa03344b8>] btrfs_search_slot+0x3e8/0x8e0 [bt=
rfs]
[330700.188128]  [<ffffffffa03469f4>] btrfs_lookup_csum+0x74/0x170 [btr=
fs]
[330700.195634]  [<ffffffff811589e5>] ? kmem_cache_alloc+0x105/0x130
[330700.202551]  [<ffffffffa03477e0>] btrfs_csum_file_blocks+0xd0/0x6d0=
 [btrfs]
[330700.210542]  [<ffffffffa03768b1>] ? clear_extent_bit+0x161/0x420 [b=
trfs]
[330700.218237]  [<ffffffffa0354109>] add_pending_csums+0x49/0x70 [btrf=
s]
[330700.225706]  [<ffffffffa0357de6>]
btrfs_finish_ordered_io+0x276/0x3d0 [btrfs]
[330700.233940]  [<ffffffffa0357f8c>]
btrfs_writepage_end_io_hook+0x4c/0xa0 [btrfs]
[330700.242345]  [<ffffffffa0376cb9>] end_extent_writepage+0x69/0x100 [=
btrfs]
[330700.250192]  [<ffffffffa0376db6>] end_bio_extent_writepage+0x66/0xa=
0 [btrfs]
[330700.258327]  [<ffffffff8119959d>] bio_endio+0x1d/0x40
[330700.264214]  [<ffffffffa034b135>] end_workqueue_fn+0x45/0x50 [btrfs=
]
[330700.271612]  [<ffffffffa03831df>] worker_loop+0x14f/0x5a0 [btrfs]
[330700.278672]  [<ffffffffa0383090>] ? btrfs_queue_worker+0x300/0x300 =
[btrfs]
[330700.286582]  [<ffffffffa0383090>] ? btrfs_queue_worker+0x300/0x300 =
[btrfs]
[330700.294535]  [<ffffffff810703fe>] kthread+0x9e/0xb0
[330700.300244]  [<ffffffff8158c224>] kernel_thread_helper+0x4/0x10
[330700.307031]  [<ffffffff81070360>] ? kthread_freezable_should_stop+0=
x70/0x70
[330700.315061]  [<ffffffff8158c220>] ? gs_change+0x13/0x13
[330700.321167] ---[ end trace b8c31966cca74ca0 ]---

The filesystems have plenty of free space:

/dev/sda              1.9T   16G  1.8T   1% /ceph/osd.000
/dev/sdb              1.9T   15G  1.8T   1% /ceph/osd.001
/dev/sdc              1.9T   13G  1.8T   1% /ceph/osd.002
/dev/sdd              1.9T   14G  1.8T   1% /ceph/osd.003

# btrfs fi df /ceph/osd.000
Data: total=3D38.01GB, used=3D15.53GB
System, DUP: total=3D8.00MB, used=3D64.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D37.50GB, used=3D82.19MB
Metadata: total=3D8.00MB, used=3D0.00

A few more btrfs_orphan_commit_root WARNINGS are present too. If
needed I could upload the messages file.

Regards,
Christian

Am 20. April 2012 17:09 schrieb Christian Brunner <christian@brunner-mu=
c.de>:
> After running ceph on XFS for some time, I decided to try btrfs again=
=2E
> Performance with the current "for-linux-min" branch and big metadata
> is much better. The only problem (?) I'm still seeing is a warning
> that seems to occur from time to time:
>
> [87703.784552] ------------[ cut here ]------------
> [87703.789759] WARNING: at fs/btrfs/inode.c:2103
> btrfs_orphan_commit_root+0xf6/0x100 [btrfs]()
> [87703.799070] Hardware name: ProLiant DL180 G6
> [87703.804024] Modules linked in: btrfs zlib_deflate libcrc32c xfs
> exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
> iTCO_vendor_support i7core_edac edac_core ixgbe dca mdio
> iomemory_vsl(PO) hpsa squashfs [last unloaded: scsi_wait_scan]
> [87703.828166] Pid: 929, comm: kworker/1:2 Tainted: P =A0 =A0 =A0 =A0=
 =A0 O
> 3.3.2-1.fits.1.el6.x86_64 #1
> [87703.837513] Call Trace:
> [87703.840280] =A0[<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
> [87703.847016] =A0[<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
> [87703.853533] =A0[<ffffffffa0355686>] btrfs_orphan_commit_root+0xf6/=
0x100 [btrfs]
> [87703.861541] =A0[<ffffffffa0350a06>] commit_fs_roots+0xc6/0x1c0 [bt=
rfs]
> [87703.868674] =A0[<ffffffffa0351bcb>]
> btrfs_commit_transaction+0x5db/0xa50 [btrfs]
> [87703.876745] =A0[<ffffffff810127a3>] ? __switch_to+0x153/0x440
> [87703.882966] =A0[<ffffffff81070a90>] ? wake_up_bit+0x40/0x40
> [87703.888997] =A0[<ffffffffa0352040>] ?
> btrfs_commit_transaction+0xa50/0xa50 [btrfs]
> [87703.897271] =A0[<ffffffffa035205f>] do_async_commit+0x1f/0x30 [btr=
fs]
> [87703.904262] =A0[<ffffffff81068949>] process_one_work+0x129/0x450
> [87703.910777] =A0[<ffffffff8106b7eb>] worker_thread+0x17b/0x3c0
> [87703.916991] =A0[<ffffffff8106b670>] ? manage_workers+0x220/0x220
> [87703.923504] =A0[<ffffffff810703fe>] kthread+0x9e/0xb0
> [87703.928952] =A0[<ffffffff8158c224>] kernel_thread_helper+0x4/0x10
> [87703.935555] =A0[<ffffffff81070360>] ? kthread_freezable_should_sto=
p+0x70/0x70
> [87703.943323] =A0[<ffffffff8158c220>] ? gs_change+0x13/0x13
> [87703.949149] ---[ end trace b8c31966cca731fa ]---
> [91128.812399] ------------[ cut here ]------------
> [91128.817576] WARNING: at fs/btrfs/inode.c:2103
> btrfs_orphan_commit_root+0xf6/0x100 [btrfs]()
> [91128.826930] Hardware name: ProLiant DL180 G6
> [91128.831897] Modules linked in: btrfs zlib_deflate libcrc32c xfs
> exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
> iTCO_vendor_support i7core_edac edac_core ixgbe dca mdio
> iomemory_vsl(PO) hpsa squashfs [last unloaded: scsi_wait_scan]
> [91128.856086] Pid: 6806, comm: btrfs-transacti Tainted: P =A0 =A0 =A0=
 =A0W =A0O
> 3.3.2-1.fits.1.el6.x86_64 #1
> [91128.865912] Call Trace:
> [91128.868670] =A0[<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
> [91128.875379] =A0[<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
> [91128.881900] =A0[<ffffffffa0355686>] btrfs_orphan_commit_root+0xf6/=
0x100 [btrfs]
> [91128.889894] =A0[<ffffffffa0350a06>] commit_fs_roots+0xc6/0x1c0 [bt=
rfs]
> [91128.897019] =A0[<ffffffffa03a2b61>] ?
> btrfs_run_delayed_items+0xf1/0x160 [btrfs]
> [91128.905075] =A0[<ffffffffa0351bcb>]
> btrfs_commit_transaction+0x5db/0xa50 [btrfs]
> [91128.913156] =A0[<ffffffffa03524b2>] ? start_transaction+0x92/0x310=
 [btrfs]
> [91128.920643] =A0[<ffffffff81070a90>] ? wake_up_bit+0x40/0x40
> [91128.926667] =A0[<ffffffffa034cfcb>] transaction_kthread+0x26b/0x2e=
0 [btrfs]
> [91128.934254] =A0[<ffffffffa034cd60>] ?
> btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
> [91128.943671] =A0[<ffffffffa034cd60>] ?
> btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
> [91128.953079] =A0[<ffffffff810703fe>] kthread+0x9e/0xb0
> [91128.958532] =A0[<ffffffff8158c224>] kernel_thread_helper+0x4/0x10
> [91128.965133] =A0[<ffffffff81070360>] ? kthread_freezable_should_sto=
p+0x70/0x70
> [91128.972913] =A0[<ffffffff8158c220>] ? gs_change+0x13/0x13
> [91128.978826] ---[ end trace b8c31966cca731fb ]---
>
> I'm able to reproduce this with ceph on a single server with 4 disks
> (4 filesystems/osds) and a small test program based on librbd. It is
> simply writing random bytes on a rbd volume (see attachment).
>
> Is this something I should care about? Any hint's on solving this
> would be appreciated.
>
> Thanks,
> Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
