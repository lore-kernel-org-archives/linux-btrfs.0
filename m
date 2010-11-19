From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs_truncate ?
Date: Fri, 19 Nov 2010 08:01:56 -0500
Message-ID: <1290171484-sup-8125@think>
References: <14C7F4F06DB5814AB0DE29716C4F6D671720BCEA@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Smets, Jan (Jan)" <jan.smets@alcatel-lucent.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <14C7F4F06DB5814AB0DE29716C4F6D671720BCEA@FRMRSSXCHMBSB1.dc-m.alcatel-lucent.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Smets, Jan (Jan)'s message of 2010-11-19 02:21:21 -0500:
> Hi list
> 
> This happened when running an iozone test over ceph, it was doing lots of random reads. 
> 
> I have no idea how to properly interpret this, I should find it out. Let me know if you need something else.
> 
> Thanks!
> 
> 
> 
> [69003.803272] ------------[ cut here ]------------
> [69003.807987] kernel BUG at fs/btrfs/inode.c:6230!
> [69003.807987] invalid opcode: 0000 [#1] SMP
> [69003.807987] last sysfs file: /sys/module/btrfs/initstate
> [69003.807987] CPU 0
> [69003.807987] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc bonding loop evdev radeon ttm snd_pcm snd_timer drm_kms_helper snd drm i2c_algo_bit i2c_i801 soundcore snd_page_alloc i2c_core i3200_edac e1000e shpchp pci_hotplug edac_core it8213 pcspkr ide_core serio_raw ext4 mbcache jbd2 crc16 btrfs zlib_deflate sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
> [69003.807987]
> [69003.807987] Pid: 1666, comm: cosd Not tainted 2.6.37-rc1+ #1 X7SBi-LN4/X7SBi-LN4
> [69003.807987] RIP: 0010:[<ffffffffa015250e>]  [<ffffffffa015250e>] btrfs_truncate+0x447/0x47c [btrfs]
> [69003.807987] RSP: 0018:ffff880127723d68  EFLAGS: 00010286
> [69003.807987] RAX: 00000000ffffffe4 RBX: ffff880127b11848 RCX: ffff88012bab8bd0

This is a BUG_ON in btrfs_truncate for any errors from
btrfs_update_inode.  Looking at the registers, btrfs_update_inode
returned 00000000ffffffe4, which is -ENOSPC.

Which is good, because the other choice would have been ENOENT, which
would be much harder to find.

So we need to tweak the reservations a little in btrfs_truncate().
Thanks for this report!

-chris
