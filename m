From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: flood of btrfs WARNINGs in dmesg
Date: Mon, 4 Oct 2010 16:24:24 +0200
Message-ID: <20101004142424.GA2870@scooter>
References: <4CA9D46D.6060309@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA9D46D.6060309@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

that issue is allready reported to this mailinglist and there is a longer
conversation about it.


Cheers,
Felix

On 04. October 2010 - 15:19, Tomasz Chmielewski wrote:
> Date:	Mon, 04 Oct 2010 15:19:41 +0200
> From: Tomasz Chmielewski <mangoo@wpkg.org>
> To: linux-btrfs@vger.kernel.org
> Subject: flood of btrfs WARNINGs in dmesg
> 
> With 2.6.35.x, I saw warnings like below in dmesg.
> 
> With 2.6.36-rc6, I even had a flood of them. Is it something to worry about? What causes it?
> 
> You can see more of these under http://www.virtall.com/files/dmesg-btrfs-flood.txt
> 
> 
> [74921.736528] ------------[ cut here ]------------
> [74921.736597] WARNING: at /home/kernel-ppa/COD/linux/fs/fs-writeback.c:87 __mark_inode_dirty+0x217/0x250()
> [74921.736604] Hardware name: Bochs
> [74921.736606] Dirtiable inode bdi default != sb bdi btrfs
> [74921.736611] Modules linked in: btrfs zlib_deflate crc32c libcrc32c lp parport psmouse serio_raw i2c_piix4 virtio_net floppy virtio_blk virtio_pci virtio_ring virtio
> [74921.736635] Pid: 22522, comm: rsync Not tainted 2.6.36-020636rc6-generic #201009291126
> [74921.736638] Call Trace:
> [74921.736649]  [<ffffffff8117aa77>] ? __mark_inode_dirty+0x217/0x250
> [74921.736678]  [<ffffffff81062730>] warn_slowpath_common+0x90/0xc0
> [74921.736683]  [<ffffffff8106285e>] warn_slowpath_fmt+0x6e/0x70
> [74921.736712]  [<ffffffffa00c4128>] ? __btrfs_end_transaction+0x128/0x210 [btrfs]
> [74921.736727]  [<ffffffffa00c4240>] ? btrfs_end_transaction+0x10/0x20 [btrfs]
> [74921.736744]  [<ffffffffa00c72fc>] ? btrfs_dirty_inode+0x7c/0x120 [btrfs]
> [74921.736781]  [<ffffffff8158835e>] ? _raw_spin_lock+0xe/0x20
> [74921.736785]  [<ffffffff8117aa77>] __mark_inode_dirty+0x217/0x250
> [74921.736804]  [<ffffffffa00ced98>] btrfs_setattr+0x78/0xb0 [btrfs]
> [74921.736814]  [<ffffffff8116ee70>] notify_change+0x170/0x2d0
> [74921.736824]  [<ffffffff8117e9bb>] utimes_common+0xdb/0x1a0
> [74921.736829]  [<ffffffff8117eb2a>] do_utimes+0xaa/0x110
> [74921.736833]  [<ffffffff8117ed16>] sys_futimesat+0x36/0xd0
> [74921.736837]  [<ffffffff8117edc9>] sys_utimes+0x19/0x20
> [74921.736854]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [74921.736870] ---[ end trace 7c45187572db04d2 ]---
> 
> 
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
