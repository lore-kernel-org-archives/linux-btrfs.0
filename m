Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:50726 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2GBPlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 11:41:53 -0400
Message-ID: <4FF1C140.3070705@jan-o-sch.net>
Date: Mon, 02 Jul 2012 17:41:52 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: ziegler@uni-freiburg.de
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kmem_cache_destroy called for cache that still has objects
References: <E1Slh32-0005X2-JH@tux00.mathematik.uni-freiburg.de>
In-Reply-To: <E1Slh32-0005X2-JH@tux00.mathematik.uni-freiburg.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I print the insteresting part of syslog below.
> 
> I mount the disk with
> mount -t btrfs -o compress,noatime,nodiratime,noacl,noexec,nosuid /dev/sdb1 /usb
> 
> The error parts in the syslog come from the the mistaken
> "mount /usb" and the line
> /dev/sdb1       /usb    auto defaults,noauto,noatime,nodiratime,users,noexec,nosuid,nodev,nobarrier,noauto_da_alloc,data=writeback 0 0
> in fstab. I could not see other errors.
> 
> Regards,
> Martin
> 
> ####################################
> Jul  2 12:33:57 zertz kernel: sd 10:0:0:0: [sdb] Attached SCSI disk
> Jul  2 12:33:59 zertz kernel: Btrfs loaded
> Jul  2 12:33:59 zertz kernel: device fsid e8f96f55-a297-4bb5-8e8e-2dbf7db7e7af devid 1 transid 2627 /dev/sdb1
> Jul  2 12:33:59 zertz kernel: btrfs: turning off barriers
> Jul  2 12:33:59 zertz kernel: btrfs: unrecognized mount option 'noauto_da_alloc'
> Jul  2 12:33:59 zertz kernel: btrfs: open_ctree failed
> Jul  2 12:34:07 zertz kernel: device fsid e8f96f55-a297-4bb5-8e8e-2dbf7db7e7af devid 1 transid 2627 /dev/sdb1
> Jul  2 12:34:07 zertz kernel: btrfs: use zlib compression
> Jul  2 12:34:07 zertz kernel: btrfs: disk space caching is enabled
> Jul  2 12:34:07 zertz kernel: btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
> Jul  2 12:35:01 zertz /USR/SBIN/CRON[8308]: (root) CMD (zanacron)
> Jul  2 12:35:01 zertz zanacron[8309](root): zanacron
> Jul  2 12:35:01 zertz zanacron[8309](root): runs zanacron daily_online in 2 minutes
> Jul  2 12:36:23 zertz kernel: Btrfs loaded
> Jul  2 12:36:23 zertz kernel: device fsid e8f96f55-a297-4bb5-8e8e-2dbf7db7e7af devid 1 transid 2635 /dev/sdb1
> Jul  2 12:36:23 zertz kernel: btrfs: use zlib compression
> Jul  2 12:36:23 zertz kernel: btrfs: disk space caching is enabled
> Jul  2 12:36:23 zertz kernel: btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
> Jul  2 12:37:00 zertz zanacron[8421](root): zanacron daily_online
> Jul  2 12:37:00 zertz zanacron[8421](root): runs /bin/run-parts  --report /usr/local/etc/cron/cron.daily/online
> Jul  2 12:43:25 zertz kernel: =============================================================================
> Jul  2 12:43:25 zertz kernel: BUG btrfs_transaction_cache (Tainted: G        W   ): Objects remaining on kmem_cache_close()
> Jul  2 12:43:25 zertz kernel: -----------------------------------------------------------------------------
> Jul  2 12:43:25 zertz kernel:
> Jul  2 12:43:25 zertz kernel: INFO: Slab 0xffffea00001c7580 objects=27 used=1 fp=0xffff8800071d7e10 flags=0x4000000000004080
> Jul  2 12:43:25 zertz kernel: Pid: 8613, comm: modprobe Tainted: G        W    3.5.0-rc4+ #278
> Jul  2 12:43:25 zertz kernel: Call Trace:
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c3688>] ? slab_err+0xb1/0xd3
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c4079>] ? unfreeze_partials+0x1b7/0x1b7
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c19fc>] ? ksm_migrate_page+0x2f/0x2f
> Jul  2 12:43:25 zertz kernel: [<ffffffff8109a85b>] ? free_one_page+0x15c/0x20a
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c4a73>] ? __kmalloc+0x43/0x129
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c5281>] ? kmem_cache_destroy+0x146/0x2a3
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0414e6c>] ? btrfs_destroy_cachep+0x34/0x59 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0451c10>] ? btrfs_log_inode+0x448/0x448 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffff81065b4e>] ? sys_delete_module+0x1ca/0x24e
> Jul  2 12:43:25 zertz kernel: [<ffffffff810e1e7d>] ? mntput_no_expire+0x13/0x11c
> Jul  2 12:43:25 zertz kernel: [<ffffffff810cacb2>] ? filp_close+0x56/0x5d
> Jul  2 12:43:25 zertz kernel: [<ffffffff8137a7e2>] ? system_call_fastpath+0x16/0x1b
> Jul  2 12:43:25 zertz kernel: INFO: Object 0xffff8800071d6250 @offset=592
> Jul  2 12:43:25 zertz kernel: SLUB btrfs_transaction_cache: kmem_cache_destroy called for cache that still has objects.
> Jul  2 12:43:25 zertz kernel: Pid: 8613, comm: modprobe Tainted: G        W    3.5.0-rc4+ #278
> Jul  2 12:43:25 zertz kernel: Call Trace:
> Jul  2 12:43:25 zertz kernel: [<ffffffff810c53cd>] ? kmem_cache_destroy+0x292/0x2a3
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0414e6c>] ? btrfs_destroy_cachep+0x34/0x59 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0451c10>] ? btrfs_log_inode+0x448/0x448 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0451c16>] ? exit_btrfs_fs+0x6/0x36 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffffa0451c10>] ? btrfs_log_inode+0x448/0x448 [btrfs]
> Jul  2 12:43:25 zertz kernel: [<ffffffff81065b4e>] ? sys_delete_module+0x1ca/0x24e
> Jul  2 12:43:25 zertz kernel: [<ffffffff810e1e7d>] ? mntput_no_expire+0x13/0x11c
> Jul  2 12:43:25 zertz kernel: [<ffffffff810cacb2>] ? filp_close+0x56/0x5d
> Jul  2 12:43:25 zertz kernel: [<ffffffff8137a7e2>] ? system_call_fastpath+0x16/0x1b
> Jul  2 12:43:52 zertz kernel: Btrfs loaded
> Jul  2 12:43:52 zertz kernel: device fsid e8f96f55-a297-4bb5-8e8e-2dbf7db7e7af devid 1 transid 2639 /dev/sdb1
> Jul  2 12:43:52 zertz kernel: btrfs: use zlib compression
> Jul  2 12:43:52 zertz kernel: btrfs: disk space caching is enabled
> Jul  2 12:43:52 zertz kernel: btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
> ###############################################################################################

I'm recently seeing such buffer leaks as well. It's always about tree blocks,
and it's always just two or three refs left for a buffer. I can somehow
reproduce it and will be looking into it probably tomorrow. (May still be
unrelated, of course.)

Martin, please try to maintain In-Reply-To headers.

-Jan
