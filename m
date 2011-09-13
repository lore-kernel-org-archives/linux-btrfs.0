From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0
 [btrfs]()
Date: Tue, 13 Sep 2011 09:02:39 +0800
Message-ID: <4E6EABAF.9010903@cn.fujitsu.com>
References: <4E6BDAEB.7020206@tuxadero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: martin@tuxadero.com
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E6BDAEB.7020206@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/2011 05:47 AM, Martin Mailand wrote:
> Hi
> I am hitting this Warning reproducible, the workload is a ceph osd,
> kernel ist 3.1.0-rc5.
> 

Have posted a patch for this:

http://marc.info/?l=linux-btrfs&m=131547325515336&w=2

thanks,
liubo

> Best Regards,
>  martin
> 
> [ 5472.099766] ------------[ cut here ]------------
> [ 5472.099833] WARNING: at fs/btrfs/inode.c:2193
> btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
> [ 5472.099838] Hardware name: MS-96B3
> [ 5472.099842] Modules linked in: radeon ttm drm_kms_helper drm
> i2c_algo_bit psmouse sp5100_tco edac_core lp shpchp serio_raw k8temp
> i2c_piix4 edac_mce_amd parport ahci pata_atiixp e1000e libahci btrfs
> zlib_deflate libcrc32c
> [ 5472.099878] Pid: 2066, comm: kworker/1:1 Not tainted 3.1.0-rc5-custom #1
> [ 5472.099882] Call Trace:
> [ 5472.099898]  [<ffffffff81063c1f>] warn_slowpath_common+0x7f/0xc0
> [ 5472.099907]  [<ffffffff81063c7a>] warn_slowpath_null+0x1a/0x20
> [ 5472.099935]  [<ffffffffa003f420>] btrfs_orphan_commit_root+0xb0/0xc0
> [btrfs]
> [ 5472.099961]  [<ffffffffa00380aa>] commit_fs_roots.clone.21+0xba/0x1a0
> [btrfs]
> [ 5472.099971]  [<ffffffff815db96e>] ? _raw_spin_lock+0xe/0x20
> [ 5472.099997]  [<ffffffffa003966f>]
> btrfs_commit_transaction+0x3ef/0x870 [btrfs]
> [ 5472.100065]  [<ffffffff81012871>] ? __switch_to+0x261/0x2f0
> [ 5472.100084]  [<ffffffff81086bf0>] ? wake_up_bit+0x40/0x40
> [ 5472.100120]  [<ffffffffa0039af0>] ?
> btrfs_commit_transaction+0x870/0x870 [btrfs]
> [ 5472.100155]  [<ffffffffa0039b0f>] do_async_commit+0x1f/0x30 [btrfs]
> [ 5472.100171]  [<ffffffff8108110d>] process_one_work+0x11d/0x430
> [ 5472.100187]  [<ffffffff81081c69>] worker_thread+0x169/0x360
> [ 5472.100203]  [<ffffffff81081b00>] ? manage_workers.clone.21+0x240/0x240
> [ 5472.100220]  [<ffffffff81086496>] kthread+0x96/0xa0
> [ 5472.100236]  [<ffffffff815e5bb4>] kernel_thread_helper+0x4/0x10
> [ 5472.100253]  [<ffffffff81086400>] ? flush_kthread_worker+0xb0/0xb0
> [ 5472.100269]  [<ffffffff815e5bb0>] ? gs_change+0x13/0x13
> [ 5472.100279] ---[ end trace a8bae5767c2c3e55 ]---
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

