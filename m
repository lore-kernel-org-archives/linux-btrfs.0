Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2KAH3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:29:02 -0400
Message-ID: <509224D1.40509@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:29:21 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:2950
References: <20121101070413.GC19617@blackbox.djwong.org>
In-Reply-To: <20121101070413.GC19617@blackbox.djwong.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 1 Nov 2012 00:04:13 -0700, Darrick J. Wong wrote:
> Hi,
> 
> I have a torture test[1] that I run to test stable page writeback.  When I run
> it against a btrfs (3.7.0-rc3) I observe the kernel bug messsage[2] that I've
> attached at the end of this message.  The test program spawns a bunch of
> threads, which try to rewrite file blocks either through mmap or through
> regular pwrite calls.
> 
> I'll take a look at it tomorrow, but I was wondering if this caught anybody's
> eye...

I'm looking into the following problem now, it seems that the file extent metadata
is modified when we do logging.

Thanks
Miao

> 
> # gcc -o wac wac.c
> # mount /dev/path/to/a/btrfs /mnt
> # ./wac -l 65536 -n 32 -m 32 -f -r /mnt/victimfile
> <wait a few seconds>
> <kaboom>
> 
> --D
> 
> [1] http://djwong.org/docs/wac.c
> [2] Double stack-trace:
> [ 9713.768350] ------------[ cut here ]------------
> [ 9713.773188] WARNING: at /storage/home/djwong/cdev/work/linux-spw/fs/btrfs/tree-log.c:3716 btrfs_log_inode_parent+0x427/0x480 [btrfs]()
> [ 9713.778876] Hardware name: Bochs
> [ 9713.780877] Modules linked in: btrfs sd_mod scsi_debug ext4 mbcache jbd2 scsi_mod sch_fq_codel nfsv4 eeprom nfsd auth_rpcgss exportfs af_packet raid1 raid0 md_mod zlib_deflate libcrc32c [last unloaded: sd_mod]
> [ 9713.786778] Pid: 1992, comm: wac Not tainted 3.7.0-rc3-spw #42
> [ 9713.789183] Call Trace:
> [ 9713.791102]  [<ffffffff8105210f>] warn_slowpath_common+0x7f/0xc0
> [ 9713.793428]  [<ffffffff8105216a>] warn_slowpath_null+0x1a/0x20
> [ 9713.795826]  [<ffffffffa030ad57>] btrfs_log_inode_parent+0x427/0x480 [btrfs]
> [ 9713.798310]  [<ffffffff8117c97c>] ? dget_parent+0x1c/0xe0
> [ 9713.800653]  [<ffffffffa030adf6>] btrfs_log_dentry_safe+0x46/0x70 [btrfs]
> [ 9713.803149]  [<ffffffffa02e21c6>] btrfs_sync_file+0x1a6/0x240 [btrfs]
> [ 9713.805626]  [<ffffffff81550f49>] ? sysret_check+0x22/0x5d
> [ 9713.807861]  [<ffffffff8119705d>] do_fsync+0x5d/0x90
> [ 9713.810077]  [<ffffffff812595ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 9713.812642]  [<ffffffff81197460>] sys_fsync+0x10/0x20
> [ 9713.814793]  [<ffffffff81550f1d>] system_call_fastpath+0x1a/0x1f
> [ 9713.817178] ---[ end trace 47f6b9aede5fa6f5 ]---
> [ 9715.884354] ------------[ cut here ]------------
> [ 9715.888197] kernel BUG at /storage/home/djwong/cdev/work/linux-spw/fs/btrfs/ctree.c:2950!
> [ 9715.888197] invalid opcode: 0000 [#1] PREEMPT SMP 
> [ 9715.888197] Modules linked in: btrfs sd_mod scsi_debug ext4 mbcache jbd2 scsi_mod sch_fq_codel nfsv4 eeprom nfsd auth_rpcgss exportfs af_packet raid1 raid0 md_mod zlib_deflate libcrc32c [last unloaded: sd_mod]
> [ 9715.888197] CPU 0 
> [ 9715.888197] Pid: 1990, comm: wac Tainted: G        W    3.7.0-rc3-spw #42 Bochs Bochs
> [ 9715.888197] RIP: 0010:[<ffffffffa02af5b9>]  [<ffffffffa02af5b9>] btrfs_set_item_key_safe+0x149/0x150 [btrfs]
> [ 9715.888197] RSP: 0018:ffff880028735ae8  EFLAGS: 00010246
> [ 9715.888197] RAX: 0000000000000000 RBX: 000000000000000f RCX: 000000000000e000
> [ 9715.888197] RDX: 0000000000000000 RSI: ffff880028735c16 RDI: ffff880028735ac7
> [ 9715.888197] RBP: ffff880028735b48 R08: 0000000000000c9e R09: ffff880028735b08
> [ 9715.888197] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880016b62bf0
> [ 9715.888197] R13: ffff880028735c16 R14: ffff880028735b07 R15: ffff8800293edbd0
> [ 9715.888197] FS:  00007f3ffa3b3700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
> [ 9715.888197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 9715.888197] CR2: 00007f3ffa3b0fba CR3: 000000002872d000 CR4: 00000000000007f0
> [ 9715.888197] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 9715.888197] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 9715.888197] Process wac (pid: 1990, threadinfo ffff880028734000, task ffff88002870de50)
> [ 9715.888197] Stack:
> [ 9715.888197]  ffff880028735b48 ffff88002f678000 ffff8800131c2000 0100000000000000
> [ 9715.888197]  6c00000000000001 000000000000e000 ffff880028735b48 ffff8800293edbd0
> [ 9715.888197]  ffff880016b62bf0 000000000000d000 0000000000000001 0000000000000000
> [ 9715.888197] Call Trace:
> [ 9715.888197]  [<ffffffffa02e46e7>] __btrfs_drop_extents+0x557/0xb00 [btrfs]
> [ 9715.888197]  [<ffffffffa0306fdd>] btrfs_log_changed_extents+0x5bd/0x610 [btrfs]
> [ 9715.888197]  [<ffffffffa02efff7>] ? free_extent_buffer+0x37/0x90 [btrfs]
> [ 9715.888197]  [<ffffffffa0308efb>] btrfs_log_inode+0x50b/0x5b0 [btrfs]
> [ 9715.888197]  [<ffffffff8117c9b8>] ? dget_parent+0x58/0xe0
> [ 9715.888197]  [<ffffffffa030aac2>] btrfs_log_inode_parent+0x192/0x480 [btrfs]
> [ 9715.888197]  [<ffffffff8117c97c>] ? dget_parent+0x1c/0xe0
> [ 9715.888197]  [<ffffffffa030adf6>] btrfs_log_dentry_safe+0x46/0x70 [btrfs]
> [ 9715.888197]  [<ffffffffa02e21c6>] btrfs_sync_file+0x1a6/0x240 [btrfs]
> [ 9715.888197]  [<ffffffff81550f49>] ? sysret_check+0x22/0x5d
> [ 9715.888197]  [<ffffffff8119705d>] do_fsync+0x5d/0x90
> [ 9715.888197]  [<ffffffff812595ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 9715.888197]  [<ffffffff81197460>] sys_fsync+0x10/0x20
> [ 9715.888197]  [<ffffffff81550f1d>] system_call_fastpath+0x1a/0x1f
> [ 9715.888197] Code: 00 00 4c 89 f6 4c 89 e7 48 98 48 8d 04 80 48 8d 54 80 65 e8 aa 1b 04 00 4c 89 ee 4c 89 f7 e8 2f f2 ff ff 85 c0 0f 8f 57 ff ff ff <0f> 0b 0f 0b 0f 1f 00 66 66 66 66 90 55 48 b8 00 00 00 00 00 16 
> [ 9715.888197] RIP  [<ffffffffa02af5b9>] btrfs_set_item_key_safe+0x149/0x150 [btrfs]
> [ 9715.888197]  RSP <ffff880028735ae8>
> [ 9716.008975] ---[ end trace 47f6b9aede5fa6f6 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


