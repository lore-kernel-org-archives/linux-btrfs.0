From: Josef Bacik <josef@redhat.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Tue, 24 Apr 2012 11:21:41 -0400
Message-ID: <20120424152141.GB3326@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Christian Brunner <christian@brunner-muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote:
> After running ceph on XFS for some time, I decided to try btrfs again.
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
> [87703.828166] Pid: 929, comm: kworker/1:2 Tainted: P           O
> 3.3.2-1.fits.1.el6.x86_64 #1
> [87703.837513] Call Trace:
> [87703.840280]  [<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
> [87703.847016]  [<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
> [87703.853533]  [<ffffffffa0355686>] btrfs_orphan_commit_root+0xf6/0x100 [btrfs]
> [87703.861541]  [<ffffffffa0350a06>] commit_fs_roots+0xc6/0x1c0 [btrfs]
> [87703.868674]  [<ffffffffa0351bcb>]
> btrfs_commit_transaction+0x5db/0xa50 [btrfs]
> [87703.876745]  [<ffffffff810127a3>] ? __switch_to+0x153/0x440
> [87703.882966]  [<ffffffff81070a90>] ? wake_up_bit+0x40/0x40
> [87703.888997]  [<ffffffffa0352040>] ?
> btrfs_commit_transaction+0xa50/0xa50 [btrfs]
> [87703.897271]  [<ffffffffa035205f>] do_async_commit+0x1f/0x30 [btrfs]
> [87703.904262]  [<ffffffff81068949>] process_one_work+0x129/0x450
> [87703.910777]  [<ffffffff8106b7eb>] worker_thread+0x17b/0x3c0
> [87703.916991]  [<ffffffff8106b670>] ? manage_workers+0x220/0x220
> [87703.923504]  [<ffffffff810703fe>] kthread+0x9e/0xb0
> [87703.928952]  [<ffffffff8158c224>] kernel_thread_helper+0x4/0x10
> [87703.935555]  [<ffffffff81070360>] ? kthread_freezable_should_stop+0x70/0x70
> [87703.943323]  [<ffffffff8158c220>] ? gs_change+0x13/0x13
> [87703.949149] ---[ end trace b8c31966cca731fa ]---
> [91128.812399] ------------[ cut here ]------------
> [91128.817576] WARNING: at fs/btrfs/inode.c:2103
> btrfs_orphan_commit_root+0xf6/0x100 [btrfs]()
> [91128.826930] Hardware name: ProLiant DL180 G6
> [91128.831897] Modules linked in: btrfs zlib_deflate libcrc32c xfs
> exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
> iTCO_vendor_support i7core_edac edac_core ixgbe dca mdio
> iomemory_vsl(PO) hpsa squashfs [last unloaded: scsi_wait_scan]
> [91128.856086] Pid: 6806, comm: btrfs-transacti Tainted: P        W  O
> 3.3.2-1.fits.1.el6.x86_64 #1
> [91128.865912] Call Trace:
> [91128.868670]  [<ffffffff8104df6f>] warn_slowpath_common+0x7f/0xc0
> [91128.875379]  [<ffffffff8104dfca>] warn_slowpath_null+0x1a/0x20
> [91128.881900]  [<ffffffffa0355686>] btrfs_orphan_commit_root+0xf6/0x100 [btrfs]
> [91128.889894]  [<ffffffffa0350a06>] commit_fs_roots+0xc6/0x1c0 [btrfs]
> [91128.897019]  [<ffffffffa03a2b61>] ?
> btrfs_run_delayed_items+0xf1/0x160 [btrfs]
> [91128.905075]  [<ffffffffa0351bcb>]
> btrfs_commit_transaction+0x5db/0xa50 [btrfs]
> [91128.913156]  [<ffffffffa03524b2>] ? start_transaction+0x92/0x310 [btrfs]
> [91128.920643]  [<ffffffff81070a90>] ? wake_up_bit+0x40/0x40
> [91128.926667]  [<ffffffffa034cfcb>] transaction_kthread+0x26b/0x2e0 [btrfs]
> [91128.934254]  [<ffffffffa034cd60>] ?
> btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
> [91128.943671]  [<ffffffffa034cd60>] ?
> btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
> [91128.953079]  [<ffffffff810703fe>] kthread+0x9e/0xb0
> [91128.958532]  [<ffffffff8158c224>] kernel_thread_helper+0x4/0x10
> [91128.965133]  [<ffffffff81070360>] ? kthread_freezable_should_stop+0x70/0x70
> [91128.972913]  [<ffffffff8158c220>] ? gs_change+0x13/0x13
> [91128.978826] ---[ end trace b8c31966cca731fb ]---
> 
> I'm able to reproduce this with ceph on a single server with 4 disks
> (4 filesystems/osds) and a small test program based on librbd. It is
> simply writing random bytes on a rbd volume (see attachment).
> 
> Is this something I should care about? Any hint's on solving this
> would be appreciated.
> 

Can you send me a config or some basic steps for me to setup ceph on my box so I
can run this program and finally track down this problem?  Thanks,

Josef
