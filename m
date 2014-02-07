Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37672 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751916AbaBGAWw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 19:22:52 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:53678 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WBZDW-0047lA-Kq
	for linux-btrfs@vger.kernel.org; Thu, 06 Feb 2014 17:22:51 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Subject: INFO: possible irq lock inversion dependency detected, btrfs
Message-Id: <0D5787EC-F1B3-4815-A2D6-0D809CA9449B@colorremedies.com>
Date: Thu, 6 Feb 2014 17:22:48 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


User has reported a Fedora Rawhide bug that includes a lot of Btrfs messages. Kernel is 3.14.0-0.rc1.git1.1.fc21.x86_64.

https://bugzilla.redhat.com/show_bug.cgi?id=1062439

A more full dmesg isn't included in the bug report. I haven't hit this particular bug running the same kernel, but I am seeing more IRQ complaints on baremetal than prior kernels.


dmesg:
…
BTRFS: device label fedora devid 1 transid 14 /dev/vda3
BTRFS: device label fedora devid 1 transid 14 /dev/vda3
BTRFS: device label fedora devid 1 transid 14 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
BTRFS: device label fedora devid 1 transid 15 /dev/vda3
BTRFS: device label fedora devid 1 transid 15 /dev/vda3
BTRFS: device label fedora devid 1 transid 15 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
EXT4-fs (vda1): INFO: recovery required on readonly filesystem
EXT4-fs (vda1): write access will be enabled during recovery
EXT4-fs (vda1): recovery complete
EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev vda1, type ext4), uses xattr
BTRFS: device label fedora devid 1 transid 16 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
BTRFS: device label fedora devid 1 transid 16 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev dm-1, type ext4), uses xattr
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
BTRFS: device label fedora devid 1 transid 16 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
BTRFS: device label fedora devid 1 transid 18 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
BTRFS: device label fedora devid 1 transid 4 /dev/vda3
BTRFS: device label fedora devid 1 transid 4 /dev/vda3
BTRFS: device label fedora devid 1 transid 4 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
BTRFS: flagging fs with big metadata feature
BTRFS: creating UUID tree
SELinux: initialized (dev vda3, type btrfs), uses xattr
BTRFS: device label fedora devid 1 transid 7 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
Adding 838652k swap on /dev/vda2.  Priority:-1 extents:1 across:838652k FS
BTRFS: device label fedora devid 1 transid 9 /dev/vda3
BTRFS info (device vda3): disk space caching is enabled
SELinux: initialized (dev vda3, type btrfs), uses xattr
EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
SELinux: initialized (dev vda1, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
BTRFS: device label fedora devid 1 transid 9 /dev/vda3

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.14.0-0.rc1.git1.1.fc21.x86_64 #1 Not tainted
---------------------------------------------------------
kswapd0/30 just changed the state of lock:
 (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa01e09ad>] __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
but this lock took another, RECLAIM_FS-unsafe lock in the past:
 (&found->groups_sem){+++++.}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&found->groups_sem);
                               local_irq_disable();
                               lock(&delayed_node->mutex);
                               lock(&found->groups_sem);
  <Interrupt>
    lock(&delayed_node->mutex);

 *** DEADLOCK ***

2 locks held by kswapd0/30:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811c45af>] shrink_slab+0x3f/0x180
 #1:  (&type->s_umount_key#49){+++++.}, at: [<ffffffff81236a74>] grab_super_passive+0x44/0x90

the shortest dependencies between 2nd lock and 1st lock:
 -> (&found->groups_sem){+++++.} ops: 4248 {
    HARDIRQ-ON-W at:
                      [<ffffffff810f9479>] __lock_acquire+0x659/0x1c40
                      [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                      [<ffffffff817d6e6e>] down_write+0x4e/0xc0
                      [<ffffffffa017785b>] __link_block_group+0x3b/0xf0 [btrfs]
                      [<ffffffffa017973b>] btrfs_read_block_groups+0x30b/0x690 [btrfs]
                      [<ffffffffa0188a79>] open_ctree+0x17f9/0x21e0 [btrfs]
                      [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                      [<ffffffff81237449>] mount_fs+0x39/0x1b0
                      [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                      [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                      [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                      [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
    HARDIRQ-ON-R at:
                      [<ffffffff810f9360>] __lock_acquire+0x540/0x1c40
                      [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                      [<ffffffff817d6dd1>] down_read+0x51/0xa0
                      [<ffffffffa0183fed>] btrfs_calc_num_tolerated_disk_barrier_failures+0x1cd/0x350 [btrfs]
                      [<ffffffffa0188a97>] open_ctree+0x1817/0x21e0 [btrfs]
                      [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                      [<ffffffff81237449>] mount_fs+0x39/0x1b0
                      [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                      [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                      [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                      [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
    SOFTIRQ-ON-W at:
                      [<ffffffff810f94af>] __lock_acquire+0x68f/0x1c40
                      [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                      [<ffffffff817d6e6e>] down_write+0x4e/0xc0
                      [<ffffffffa017785b>] __link_block_group+0x3b/0xf0 [btrfs]
                      [<ffffffffa017973b>] btrfs_read_block_groups+0x30b/0x690 [btrfs]
                      [<ffffffffa0188a79>] open_ctree+0x17f9/0x21e0 [btrfs]
                      [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                      [<ffffffff81237449>] mount_fs+0x39/0x1b0
                      [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                      [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                      [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                      [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
    SOFTIRQ-ON-R at:
                      [<ffffffff810f94af>] __lock_acquire+0x68f/0x1c40
                      [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                      [<ffffffff817d6dd1>] down_read+0x51/0xa0
                      [<ffffffffa0183fed>] btrfs_calc_num_tolerated_disk_barrier_failures+0x1cd/0x350 [btrfs]
                      [<ffffffffa0188a97>] open_ctree+0x1817/0x21e0 [btrfs]
                      [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                      [<ffffffff81237449>] mount_fs+0x39/0x1b0
                      [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                      [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                      [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                      [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
    RECLAIM_FS-ON-W at:
                         [<ffffffff810f8819>] mark_held_locks+0xb9/0x140
                         [<ffffffff810fbc4a>] lockdep_trace_alloc+0x7a/0xe0
                         [<ffffffff8121180f>] __kmalloc_track_caller+0x4f/0x350
                         [<ffffffff813d6e21>] kvasprintf+0x61/0xa0
                         [<ffffffff813c9601>] kobject_set_name_vargs+0x21/0x70
                         [<ffffffff813ca092>] kobject_add+0x62/0xd0
                         [<ffffffffa01778e4>] __link_block_group+0xc4/0xf0 [btrfs]
                         [<ffffffffa017973b>] btrfs_read_block_groups+0x30b/0x690 [btrfs]
                         [<ffffffffa0188a79>] open_ctree+0x17f9/0x21e0 [btrfs]
                         [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                         [<ffffffff81237449>] mount_fs+0x39/0x1b0
                         [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                         [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                         [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                         [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
    INITIAL USE at:
                     [<ffffffff810f9167>] __lock_acquire+0x347/0x1c40
                     [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                     [<ffffffff817d6e6e>] down_write+0x4e/0xc0
                     [<ffffffffa017785b>] __link_block_group+0x3b/0xf0 [btrfs]
                     [<ffffffffa017973b>] btrfs_read_block_groups+0x30b/0x690 [btrfs]
                     [<ffffffffa0188a79>] open_ctree+0x17f9/0x21e0 [btrfs]
                     [<ffffffffa015bc5e>] btrfs_mount+0x63e/0x810 [btrfs]
                     [<ffffffff81237449>] mount_fs+0x39/0x1b0
                     [<ffffffff8125780b>] vfs_kern_mount+0x6b/0x150
                     [<ffffffff8125a6de>] do_mount+0x24e/0xbb0
                     [<ffffffff8125b386>] SyS_mount+0x96/0xf0
                     [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
  }
  ... key      at: [<ffffffffa021c7e0>] __key.42525+0x0/0xfffffffffffe5820 [btrfs]
  ... acquired at:
   [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
   [<ffffffff817d6dd1>] down_read+0x51/0xa0
   [<ffffffffa017719b>] find_free_extent+0x80b/0xe90 [btrfs]
   [<ffffffffa01779d8>] btrfs_reserve_extent+0xa8/0x140 [btrfs]
   [<ffffffffa0177cee>] btrfs_alloc_free_block+0xfe/0x480 [btrfs]
   [<ffffffffa01611f4>] __btrfs_cow_block+0x134/0x550 [btrfs]
   [<ffffffffa01617a6>] btrfs_cow_block+0x116/0x270 [btrfs]
   [<ffffffffa0165630>] btrfs_search_slot+0x1e0/0xa30 [btrfs]
   [<ffffffffa01e14ac>] btrfs_delete_delayed_items+0xcc/0x330 [btrfs]
   [<ffffffffa01e1ed2>] __btrfs_run_delayed_items+0x122/0x1e0 [btrfs]
   [<ffffffffa01e1fc3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
   [<ffffffffa018a449>] btrfs_flush_all_pending_stuffs+0x19/0x70 [btrfs]
   [<ffffffffa018b512>] btrfs_commit_transaction+0x232/0xaa0 [btrfs]
   [<ffffffffa0156354>] btrfs_sync_fs+0x54/0x160 [btrfs]
   [<ffffffff8126aff5>] sync_filesystem+0x85/0xc0
   [<ffffffff81235500>] generic_shutdown_super+0x30/0xf0
   [<ffffffff812357a2>] kill_anon_super+0x12/0x20
   [<ffffffffa0158a06>] btrfs_kill_super+0x16/0x90 [btrfs]
   [<ffffffff81235c7d>] deactivate_locked_super+0x3d/0x60
   [<ffffffff81236256>] deactivate_super+0x46/0x60
   [<ffffffff812582fd>] mntput_no_expire+0x17d/0x1f0
   [<ffffffff81259c5d>] SyS_umount+0x9d/0x110
   [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b

-> (&delayed_node->mutex){+.+.-.} ops: 250816 {
   HARDIRQ-ON-W at:
                    [<ffffffff810f9479>] __lock_acquire+0x659/0x1c40
                    [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                    [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
                    [<ffffffffa01e2663>] btrfs_delete_delayed_dir_index+0x83/0x200 [btrfs]
                    [<ffffffffa019523f>] btrfs_unlink_subvol+0x17f/0x360 [btrfs]
                    [<ffffffffa01be55a>] btrfs_ioctl_snap_destroy+0x47a/0x770 [btrfs]
                    [<ffffffffa01c42eb>] btrfs_ioctl+0x1c3b/0x2e10 [btrfs]
                    [<ffffffff81248750>] do_vfs_ioctl+0x300/0x520
                    [<ffffffff81248a11>] SyS_ioctl+0xa1/0xc0
                    [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
   SOFTIRQ-ON-W at:
                    [<ffffffff810f94af>] __lock_acquire+0x68f/0x1c40
                    [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                    [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
                    [<ffffffffa01e2663>] btrfs_delete_delayed_dir_index+0x83/0x200 [btrfs]
                    [<ffffffffa019523f>] btrfs_unlink_subvol+0x17f/0x360 [btrfs]
                    [<ffffffffa01be55a>] btrfs_ioctl_snap_destroy+0x47a/0x770 [btrfs]
                    [<ffffffffa01c42eb>] btrfs_ioctl+0x1c3b/0x2e10 [btrfs]
                    [<ffffffff81248750>] do_vfs_ioctl+0x300/0x520
                    [<ffffffff81248a11>] SyS_ioctl+0xa1/0xc0
                    [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
   IN-RECLAIM_FS-W at:
                       [<ffffffff810f93d4>] __lock_acquire+0x5b4/0x1c40
                       [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                       [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
                       [<ffffffffa01e09ad>] __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
                       [<ffffffffa01e22a4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
                       [<ffffffffa0196eee>] btrfs_evict_inode+0x1ae/0x5d0 [btrfs]
                       [<ffffffff81252473>] evict+0xa3/0x1a0
                       [<ffffffff812525ae>] dispose_list+0x3e/0x50
                       [<ffffffff812535c6>] prune_icache_sb+0x56/0x80
                       [<ffffffff81236cd8>] super_cache_scan+0x108/0x180
                       [<ffffffff811c424b>] shrink_slab_node+0x14b/0x440
                       [<ffffffff811c45fe>] shrink_slab+0x8e/0x180
                       [<ffffffff811c744d>] kswapd_shrink_zone+0x14d/0x1f0
                       [<ffffffff811c9030>] kswapd+0x4b0/0xa60
                       [<ffffffff810c43cf>] kthread+0xff/0x120
                       [<ffffffff817e2cfc>] ret_from_fork+0x7c/0xb0
   INITIAL USE at:
                   [<ffffffff810f9167>] __lock_acquire+0x347/0x1c40
                   [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
                   [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
                   [<ffffffffa01e2663>] btrfs_delete_delayed_dir_index+0x83/0x200 [btrfs]
                   [<ffffffffa019523f>] btrfs_unlink_subvol+0x17f/0x360 [btrfs]
                   [<ffffffffa01be55a>] btrfs_ioctl_snap_destroy+0x47a/0x770 [btrfs]
                   [<ffffffffa01c42eb>] btrfs_ioctl+0x1c3b/0x2e10 [btrfs]
                   [<ffffffff81248750>] do_vfs_ioctl+0x300/0x520
                   [<ffffffff81248a11>] SyS_ioctl+0xa1/0xc0
                   [<ffffffff817e2da9>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa0220738>] __key.37530+0x0/0xfffffffffffe18c8 [btrfs]
 ... acquired at:
   [<ffffffff810f7dea>] check_usage_forwards+0x16a/0x180
   [<ffffffff810f8657>] mark_lock+0x1a7/0x2b0
   [<ffffffff810f93d4>] __lock_acquire+0x5b4/0x1c40
   [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
   [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
   [<ffffffffa01e09ad>] __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
   [<ffffffffa01e22a4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
   [<ffffffffa0196eee>] btrfs_evict_inode+0x1ae/0x5d0 [btrfs]
   [<ffffffff81252473>] evict+0xa3/0x1a0
   [<ffffffff812525ae>] dispose_list+0x3e/0x50
   [<ffffffff812535c6>] prune_icache_sb+0x56/0x80
   [<ffffffff81236cd8>] super_cache_scan+0x108/0x180
   [<ffffffff811c424b>] shrink_slab_node+0x14b/0x440
   [<ffffffff811c45fe>] shrink_slab+0x8e/0x180
   [<ffffffff811c744d>] kswapd_shrink_zone+0x14d/0x1f0
   [<ffffffff811c9030>] kswapd+0x4b0/0xa60
   [<ffffffff810c43cf>] kthread+0xff/0x120
   [<ffffffff817e2cfc>] ret_from_fork+0x7c/0xb0


stack backtrace:
CPU: 0 PID: 30 Comm: kswapd0 Not tainted 3.14.0-0.rc1.git1.1.fc21.x86_64 #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000000 000000008ae747be ffff88007f3f9718 ffffffff817cef2d
 ffffffff82a1fec0 ffff88007f3f9758 ffffffff817ca5c6 ffffffff81a4d7ec
 0000000000000000 ffff880079ead7f0 ffff880079eacc50 ffffffff81a4d7ec
Call Trace:
 [<ffffffff817cef2d>] dump_stack+0x4d/0x66
 [<ffffffff817ca5c6>] print_irq_inversion_bug.part.42+0x1ac/0x1b8
 [<ffffffff810f7dea>] check_usage_forwards+0x16a/0x180
 [<ffffffff810f7c80>] ? check_usage_backwards+0x180/0x180
 [<ffffffff810f8657>] mark_lock+0x1a7/0x2b0
 [<ffffffff810f93d4>] __lock_acquire+0x5b4/0x1c40
 [<ffffffff810f8819>] ? mark_held_locks+0xb9/0x140
 [<ffffffff817d818c>] ? _raw_spin_unlock_irq+0x2c/0x40
 [<ffffffff810f8a7d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff817d818c>] ? _raw_spin_unlock_irq+0x2c/0x40
 [<ffffffff810ceeed>] ? finish_task_switch+0x7d/0x130
 [<ffffffff810ceeaf>] ? finish_task_switch+0x3f/0x130
 [<ffffffff810fb252>] lock_acquire+0xa2/0x1d0
 [<ffffffffa01e09ad>] ? __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
 [<ffffffff817d4687>] mutex_lock_nested+0x87/0x430
 [<ffffffffa01e09ad>] ? __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
 [<ffffffff810dd26d>] ? sched_clock_local+0x1d/0x80
 [<ffffffffa01e09ad>] ? __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
 [<ffffffffa0196ec5>] ? btrfs_evict_inode+0x185/0x5d0 [btrfs]
 [<ffffffff810dd4b8>] ? sched_clock_cpu+0xa8/0xd0
 [<ffffffff810dd536>] ? local_clock+0x16/0x30
 [<ffffffffa01e09ad>] __btrfs_release_delayed_node+0x3d/0x1f0 [btrfs]
 [<ffffffffa01e22a4>] btrfs_remove_delayed_node+0x24/0x30 [btrfs]
 [<ffffffffa0196eee>] btrfs_evict_inode+0x1ae/0x5d0 [btrfs]
 [<ffffffff81252473>] evict+0xa3/0x1a0
 [<ffffffff812525ae>] dispose_list+0x3e/0x50
 [<ffffffff812535c6>] prune_icache_sb+0x56/0x80
 [<ffffffff81236cd8>] super_cache_scan+0x108/0x180
 [<ffffffff811c424b>] shrink_slab_node+0x14b/0x440
 [<ffffffff811c45af>] ? shrink_slab+0x3f/0x180
 [<ffffffff811c45fe>] shrink_slab+0x8e/0x180
 [<ffffffff811c744d>] kswapd_shrink_zone+0x14d/0x1f0
 [<ffffffff811c9030>] kswapd+0x4b0/0xa60
 [<ffffffff811c8b80>] ? mem_cgroup_shrink_node_zone+0x2f0/0x2f0
 [<ffffffff810c43cf>] kthread+0xff/0x120
 [<ffffffff810c42d0>] ? insert_kthread_work+0x80/0x80
 [<ffffffff817e2cfc>] ret_from_fork+0x7c/0xb0
 [<ffffffff810c42d0>] ? insert_kthread_work+0x80/0x80
JFS: nTxBlock = 8192, nTxLock = 65536
fuse init (API version 7.22)
SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
BTRFS: device label fedora devid 1 transid 17 /dev/vda3