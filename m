From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2114
Date: Tue, 11 Oct 2011 10:04:07 +0800
Message-ID: <4E93A417.9040001@cn.fujitsu.com>
References: <CAO47_--qdKE0z6maQCpD2xh+RY+ZvyRVKxDF0c3iqBA6pafkZQ@mail.gmail.com> <CAO47_-9rk-4muJ0+qMcyd_wmGyToFRp7VN5G1hfhZmmCGLNWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chb@muc.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9rk-4muJ0+qMcyd_wmGyToFRp7VN5G1hfhZmmCGLNWDg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2011 12:41 AM, Christian Brunner wrote:
> I just realized that this is still the same warning I reported some month ago.
> 
> I thought that this had been fixed with
> 
> 25d37af374263243214be9d912cbb46a8e469bc7
> 
> which is included in the kernel I'm using. So I think there must be
> another Problem.
> 

Would you try with this patch:

http://marc.info/?l=linux-btrfs&m=131547325515336&w=2

thanks,
liubo

> Regards,
> Christian
> 
> 2011/10/9 Christian Brunner <chb@muc.de>:
>> I gave btrfs "for-chris" from josef's github repo a try in our ceph
>> cluster. During the rebuild I git the following warning.
>>
>> Everything still seems to work... Should I be concerned?
>>
>> Thanks,
>> Christian
>>
>> [12554.886362] ------------[ cut here ]------------
>> [12554.891693] WARNING: at fs/btrfs/inode.c:2114
>> btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
>> [12554.901210] Hardware name: ProLiant DL180 G6
>> [12554.906338] Modules linked in: btrfs zlib_deflate libcrc32c bonding
>> ipv6 pcspkr serio_raw ghes hed iTCO_wdt iTCO_vendor_support
>> i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
>> [last unloaded: scsi_wait_scan]
>> [12554.930791] Pid: 4686, comm: flush-btrfs-1 Tainted: P
>> 3.0.6-1.fits.1.el6.x86_64 #1
>> [12554.940483] Call Trace:
>> [12554.943400]  [<ffffffff8106344f>] warn_slowpath_common+0x7f/0xc0
>> [12554.950378]  [<ffffffff810634aa>] warn_slowpath_null+0x1a/0x20
>> [12554.957070]  [<ffffffffa022be60>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
>> [12554.965301]  [<ffffffffa0226c45>] commit_fs_roots+0xc5/0x1b0 [btrfs]
>> [12554.972571]  [<ffffffff815593d1>] ? mutex_lock+0x31/0x60
>> [12554.978652]  [<ffffffffa0207a5a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
>> [12554.986017]  [<ffffffffa0227b96>]
>> btrfs_commit_transaction+0x3c6/0x830 [btrfs]
>> [12554.994256]  [<ffffffffa0228115>] ? join_transaction+0x25/0x250 [btrfs]
>> [12555.001814]  [<ffffffff81086410>] ? wake_up_bit+0x40/0x40
>> [12555.008061]  [<ffffffffa022b35b>] btrfs_write_inode+0xbb/0xc0 [btrfs]
>> [12555.015490]  [<ffffffff81184c71>] writeback_single_inode+0x201/0x260
>> [12555.022879]  [<ffffffff81184f6b>] writeback_sb_inodes+0xeb/0x1c0
>> [12555.029721]  [<ffffffff8118532f>] wb_writeback+0x18f/0x480
>> [12555.036031]  [<ffffffff81558105>] ? __schedule+0x3f5/0x8b0
>> [12555.042295]  [<ffffffff81072f3c>] ? lock_timer_base+0x3c/0x70
>> [12555.048860]  [<ffffffff811856bd>] wb_do_writeback+0x9d/0x270
>> [12555.055384]  [<ffffffff81073060>] ? del_timer+0xf0/0xf0
>> [12555.061375]  [<ffffffff81185932>] bdi_writeback_thread+0xa2/0x280
>> [12555.068375]  [<ffffffff81185890>] ? wb_do_writeback+0x270/0x270
>> [12555.075203]  [<ffffffff81185890>] ? wb_do_writeback+0x270/0x270
>> [12555.081971]  [<ffffffff81085d96>] kthread+0x96/0xa0
>> [12555.087582]  [<ffffffff815639c4>] kernel_thread_helper+0x4/0x10
>> [12555.094338]  [<ffffffff81085d00>] ? kthread_worker_fn+0x1a0/0x1a0
>> [12555.101296]  [<ffffffff815639c0>] ? gs_change+0x13/0x13
>> [12555.107290] ---[ end trace 57ec2e8544131a12 ]---
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

