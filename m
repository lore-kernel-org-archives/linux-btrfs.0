From: Christian Brunner <chb@muc.de>
Subject: Re: WARNING: at fs/btrfs/inode.c:2114
Date: Thu, 20 Oct 2011 17:31:03 +0200
Message-ID: <CAO47_-_fLgLaGVjLdcmx133Qt2a+S=H5oa=1w++S1LjveOGmKA@mail.gmail.com>
References: <CAO47_--qdKE0z6maQCpD2xh+RY+ZvyRVKxDF0c3iqBA6pafkZQ@mail.gmail.com>
	<CAO47_-9rk-4muJ0+qMcyd_wmGyToFRp7VN5G1hfhZmmCGLNWDg@mail.gmail.com>
	<4E93A417.9040001@cn.fujitsu.com>
	<CAO47_--SRZK752VK-qJPXiCgcY-MrEfD-5zkT2PHF1RNt5iv1Q@mail.gmail.com>
	<CAO47_-8RdWoS-1s-KJtbaZoQNLMgOnk=XvAFCNOY+iX+CEiyMg@mail.gmail.com>
	<4E9FF16D.70105@cn.fujitsu.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9FF16D.70105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/20 Liu Bo <liubo2009@cn.fujitsu.com>:
> On 10/17/2011 11:23 PM, Christian Brunner wrote:
>> 2011/10/11 Christian Brunner <chb@muc.de>:
>>
>> I have updated to a 3.0.6 kernel, with all the btrfs patches from
>> josef's git repo this weekend. But I'm still seeing the following
>> warning:
>>
>
> Hi,
>
> Would you try with this patch:
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/13728
>

I have now applied the patch josef sent to the list (Btrfs: use the
global reserve when truncating the free space cache inode), but the
warning is still there:

[   69.153400] ------------[ cut here ]------------
[   69.158669] WARNING: at fs/btrfs/inode.c:2114
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[   69.167984] Hardware name: ProLiant DL180 G6
[   69.173037] Modules linked in: btrfs zlib_deflate libcrc32c sunrpc
bonding ipv6 sg serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
ixgbe dca mdio i7core_edac edac_core iomemory_vsl(P) hpsa squashfs
[last unloaded: scsi_wait_scan]
[   69.197502] Pid: 3426, comm: ceph-osd Tainted: P
3.0.6-1.fits.8.el6.x86_64 #1
[   69.206591] Call Trace:
[   69.209389]  [<ffffffff8106344f>] warn_slowpath_common+0x7f/0xc0
[   69.216144]  [<ffffffff810634aa>] warn_slowpath_null+0x1a/0x20
[   69.222647]  [<ffffffffa028c080>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
[   69.230550]  [<ffffffffa0286e15>] commit_fs_roots+0xc5/0x1b0 [btrfs]
[   69.237698]  [<ffffffff8154c231>] ? mutex_lock+0x31/0x60
[   69.243707]  [<ffffffffa0267a8a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[   69.250966]  [<ffffffffa0287d56>]
btrfs_commit_transaction+0x3c6/0x820 [btrfs]
[   69.259087]  [<ffffffffa0287178>] ? wait_current_trans+0x28/0x110 [btrfs]
[   69.266720]  [<ffffffffa02882c5>] ? join_transaction+0x25/0x250 [btrfs]
[   69.274136]  [<ffffffff81086410>] ? wake_up_bit+0x40/0x40
[   69.280210]  [<ffffffffa0264329>] btrfs_sync_fs+0x59/0xd0 [btrfs]
[   69.287072]  [<ffffffffa02b5b95>] btrfs_ioctl+0x495/0xd50 [btrfs]
[   69.293922]  [<ffffffff8125ed20>] ? inode_has_perm+0x30/0x40
[   69.300286]  [<ffffffff81261a2c>] ? file_has_perm+0xdc/0xf0
[   69.306558]  [<ffffffff8117086a>] do_vfs_ioctl+0x9a/0x5a0
[   69.312657]  [<ffffffff81170e11>] sys_ioctl+0xa1/0xb0
[   69.318352]  [<ffffffff81555702>] system_call_fastpath+0x16/0x1b
[   69.325107] ---[ end trace 2fd1a5665203d8e3 ]---


Thanks,
Christian
