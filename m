From: Christian Brunner <chb@muc.de>
Subject: Re: WARNING: at fs/btrfs/inode.c:2114
Date: Mon, 17 Oct 2011 17:23:38 +0200
Message-ID: <CAO47_-8RdWoS-1s-KJtbaZoQNLMgOnk=XvAFCNOY+iX+CEiyMg@mail.gmail.com>
References: <CAO47_--qdKE0z6maQCpD2xh+RY+ZvyRVKxDF0c3iqBA6pafkZQ@mail.gmail.com>
	<CAO47_-9rk-4muJ0+qMcyd_wmGyToFRp7VN5G1hfhZmmCGLNWDg@mail.gmail.com>
	<4E93A417.9040001@cn.fujitsu.com>
	<CAO47_--SRZK752VK-qJPXiCgcY-MrEfD-5zkT2PHF1RNt5iv1Q@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--SRZK752VK-qJPXiCgcY-MrEfD-5zkT2PHF1RNt5iv1Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/11 Christian Brunner <chb@muc.de>:
> 2011/10/11 Liu Bo <liubo2009@cn.fujitsu.com>:
>> On 10/10/2011 12:41 AM, Christian Brunner wrote:
>>> I just realized that this is still the same warning I reported some month ago.
>>>
>>> I thought that this had been fixed with
>>>
>>> 25d37af374263243214be9d912cbb46a8e469bc7
>>>
>>> which is included in the kernel I'm using. So I think there must be
>>> another Problem.
>>>
>>
>> Would you try with this patch:
>>
>> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2
>>
>
> This one is already included in my tree.

I have updated to a 3.0.6 kernel, with all the btrfs patches from
josef's git repo this weekend. But I'm still seeing the following
warning:

[75532.763336] ------------[ cut here ]------------
[75532.768570] WARNING: at fs/btrfs/inode.c:2114
btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
[75532.777807] Hardware name: ProLiant DL180 G6
[75532.782798] Modules linked in: btrfs zlib_deflate libcrc32c sunrpc
bonding ipv6 sg serio_raw pcspkr ghes hed iTCO_wdt iTCO_vendor_support
i7core_edac edac_core ixgbe dca mdio iomemory_vsl(P) hpsa squashfs
[last unloaded: scsi_wait_scan]
[75532.806891] Pid: 1858, comm: ceph-osd Tainted: P
3.0.6-1.fits.5.el6.x86_64 #1
[75532.815990] Call Trace:
[75532.818772]  [<ffffffff8106344f>] warn_slowpath_common+0x7f/0xc0
[75532.825514]  [<ffffffff810634aa>] warn_slowpath_null+0x1a/0x20
[75532.832076]  [<ffffffffa0281ff0>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]
[75532.840028]  [<ffffffffa027cd85>] commit_fs_roots+0xc5/0x1b0 [btrfs]
[75532.847196]  [<ffffffff8154c231>] ? mutex_lock+0x31/0x60
[75532.853198]  [<ffffffffa025da8a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[75532.860476]  [<ffffffffa027dcc6>]
btrfs_commit_transaction+0x3c6/0x820 [btrfs]
[75532.868599]  [<ffffffffa027d0e8>] ? wait_current_trans+0x28/0x110 [btrfs]
[75532.876264]  [<ffffffffa027e235>] ? join_transaction+0x25/0x250 [btrfs]
[75532.883762]  [<ffffffff81086410>] ? wake_up_bit+0x40/0x40
[75532.889839]  [<ffffffffa025a329>] btrfs_sync_fs+0x59/0xd0 [btrfs]
[75532.896703]  [<ffffffffa02abb25>] btrfs_ioctl+0x495/0xd50 [btrfs]
[75532.903544]  [<ffffffff8125ed20>] ? inode_has_perm+0x30/0x40
[75532.909902]  [<ffffffff81261a2c>] ? file_has_perm+0xdc/0xf0
[75532.916205]  [<ffffffff8117086a>] do_vfs_ioctl+0x9a/0x5a0
[75532.922276]  [<ffffffff81170e11>] sys_ioctl+0xa1/0xb0
[75532.927988]  [<ffffffff81555702>] system_call_fastpath+0x16/0x1b
[75532.934755] ---[ end trace a10c532625ad12af ]---

Regards,
Christian
