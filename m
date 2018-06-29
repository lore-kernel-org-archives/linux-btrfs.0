Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbeF2GKo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:10:44 -0400
Subject: Re: [GIT PULL] Btrfs updates for 4.18
To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1528125657.git.dsterba@suse.com>
 <CAL3q7H7iLCPxA01811RJK-bEiRPAGJdTrHLogJr2a3Sq1g0k4g@mail.gmail.com>
 <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
 <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
 <20180611161508.GA24375@twin.jikos.cz>
 <ff25bbd0-33ce-4787-da4b-9025d381593a@oracle.com>
 <20180628182616.GK2287@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f131f209-f1d1-38b5-5f7c-bd30de3921fa@oracle.com>
Date: Fri, 29 Jun 2018 14:13:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180628182616.GK2287@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/29/2018 02:26 AM, David Sterba wrote:
> On Thu, Jun 28, 2018 at 07:22:59PM +0800, Anand Jain wrote:
>>    The circular locking dependency warning occurs at FSSTRESS_PROG.
>>    And in particular at doproc() in xfstests/ltp/fsstress.c, randomly
>>    at any of the command at
>>    opdesc_t        ops[] = { ..}
>>    which involves calling mmap file operation and if there is something
>>    to commit.
>>
>>    The commit transaction does need device_list_mutex which is also being
>>    used for the btrfs_open_devices() in the commit 542c5908abfe84f7.
>>
>>    But btrfs_open_devices() is only called at mount, and mmap() can
>>    establish only be established after the mount has completed. With
>>    this give its unclear to me why the circular locking dependency check
>>    is warning about this.
>>
>>    I feel until we have clarity about this and also solve other problem
>>    related to the streamlining of uuid_mutex, I suggest we revert
>>    542c5908abfe84f7. Sorry for the inconvenience.
> 
> Ok, the revert is one option. I'm cosidering adding both the locks, like
> is in https://patchwork.kernel.org/patch/10478443/ . This would have no
> effect, as btrfs_open_devices is called only from mount path and the
> list_sort is done only for the first time when there are not other
> users of the list that would not also be under the uuid_mutex.

> This passed the syzbot and other tests, so this does not break things
> and goes towards pushing the device_list_mutex as the real protection
> mechanism for the fs_devices members.

> Let me know what you think, the revert should be the last option if we
> don't have anything better.

  With this patch [1] as well I find the circular lock warning[2].
  [1]
   https://patchwork.kernel.org/patch/10478443/
  Test case:

   mkfs.btrfs -fq /dev/sdc && mount /dev/sdc /btrfs && 
/xfstests/ltp/fsstress -d /btrfs -w -p 1 -n 2000

  However when the device_list_mutex is removed, the warning goes away.
  Let me investigate bit more about circular locking dependency.

About using uuid_mutex in btrfs_open_devices().
  I am planning to be more conceivable about the using the
  bit map for the volume flags and which shall also include the
  EXCL OPS in progress flag for the fs_devices. Which means we hold
  uuid_mutex and set/reset EXCL OPS flag for the fs_devices. And so
  the other fsids like fsid2 can still hold the uuid_mutex while
  fsid1 is still mounting/opening (which may sleep).
  I hope you would agree to use bit map for volume, we also need this
  bit map to manage the volume status. Or if there is a better solution
  I am fine. However uuid_mutex isn't as it blocks fsids2 to mount.

Thanks, Anand

[2]
-------------------------------------------------------------------
  kernel:
  kernel: ======================================================
  kernel: WARNING: possible circular locking dependency detected
  kernel: 4.18.0-rc1+ #63 Not tainted
  kernel: ------------------------------------------------------
  kernel: fsstress/3062 is trying to acquire lock:
  kernel: 000000007d28aeca (&fs_info->reloc_mutex){+.+.}, at: 
btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:
                               but task is already holding lock:
  kernel: 000000002fc78565 (&mm->mmap_sem){++++}, at: 
vm_mmap_pgoff+0x9f/0x110
  kernel:
                               which lock already depends on the new lock.
  kernel:
                               the existing dependency chain (in reverse 
order) is:
  kernel:
                               -> #5 (&mm->mmap_sem){++++}:
  kernel:        _copy_from_user+0x1e/0x90
  kernel:        scsi_cmd_ioctl+0x2ba/0x480
  kernel:        cdrom_ioctl+0x3b/0xb2e
  kernel:        sr_block_ioctl+0x7e/0xc0
  kernel:        blkdev_ioctl+0x4ea/0x980
  kernel:        block_ioctl+0x39/0x40
  kernel:        do_vfs_ioctl+0xa2/0x6c0
  kernel:        ksys_ioctl+0x70/0x80
  kernel:        __x64_sys_ioctl+0x16/0x20
  kernel:        do_syscall_64+0x4a/0x180
  kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  kernel:
                               -> #4 (sr_mutex){+.+.}:
  kernel:        sr_block_open+0x24/0xd0
  kernel:        __blkdev_get+0xcb/0x480
  kernel:        blkdev_get+0x144/0x3a0
  kernel:        do_dentry_open+0x1b1/0x2d0
  kernel:        path_openat+0x57b/0xcc0
  kernel:        do_filp_open+0x9b/0x110
  kernel:        do_sys_open+0x1bd/0x250
  kernel:        do_syscall_64+0x4a/0x180
  kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  kernel:
                               -> #3 (&bdev->bd_mutex){+.+.}:
  kernel:        __blkdev_get+0x5d/0x480
  kernel:        blkdev_get+0x243/0x3a0
  kernel:        blkdev_get_by_path+0x4a/0x80
  kernel:        btrfs_get_bdev_and_sb+0x1b/0xa0 [btrfs]
  kernel:        open_fs_devices+0x85/0x270 [btrfs]
  kernel:        btrfs_open_devices+0x6b/0x70 [btrfs]
  kernel:        btrfs_mount_root+0x41a/0x7e0 [btrfs]
  kernel:        mount_fs+0x30/0x150
  kernel:        vfs_kern_mount.part.31+0x54/0x140
  kernel:        btrfs_mount+0x175/0x920 [btrfs]
  kernel:        mount_fs+0x30/0x150
  kernel:        vfs_kern_mount.part.31+0x54/0x140
  kernel:        do_mount+0x63b/0xd60
  kernel:        ksys_mount+0x80/0xd0
  kernel:        __x64_sys_mount+0x21/0x30
  kernel:        do_syscall_64+0x4a/0x180
  kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  kernel:
                               -> #2 (&fs_devs->device_list_mutex){+.+.}:
  kernel:        btrfs_run_dev_stats+0x47/0x3b0 [btrfs]
  kernel:        commit_cowonly_roots+0xb4/0x2b0 [btrfs]
  kernel:        btrfs_commit_transaction+0x3ab/0x9d0 [btrfs]
  kernel:        transaction_kthread+0x156/0x180 [btrfs]
  kernel:        kthread+0x11c/0x140
  kernel:        ret_from_fork+0x3a/0x50
  kernel:
                               -> #1 (&fs_info->tree_log_mutex){+.+.}:
  kernel:        btrfs_commit_transaction+0x350/0x9d0 [btrfs]
  kernel:        transaction_kthread+0x156/0x180 [btrfs]
  kernel:        kthread+0x11c/0x140
  kernel:        ret_from_fork+0x3a/0x50
  kernel:
                               -> #0 (&fs_info->reloc_mutex){+.+.}:
  kernel:        __mutex_lock+0x7f/0x9d0
  kernel:        btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:        start_transaction+0xa2/0x4a0 [btrfs]
  kernel:        btrfs_dirty_inode+0x42/0xd0 [btrfs]
  kernel:        touch_atime+0xab/0xd0
  kernel:        btrfs_file_mmap+0x3c/0x60 [btrfs]
  kernel:        mmap_region+0x3a8/0x5e0
  kernel:        do_mmap+0x3dd/0x5a0
  kernel:        vm_mmap_pgoff+0xcf/0x110
  kernel:        ksys_mmap_pgoff+0x1b5/0x220
  kernel:        do_syscall_64+0x4a/0x180
  kernel:        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  kernel:
                               other info that might help us debug this:
  kernel: Chain exists of:
                                 &fs_info->reloc_mutex --> sr_mutex --> 
&mm->mmap_sem
  kernel:  Possible unsafe locking scenario:
  kernel:        CPU0                    CPU1
  kernel:        ----                    ----
  kernel:   lock(&mm->mmap_sem);
  kernel:                                lock(sr_mutex);
  kernel:                                lock(&mm->mmap_sem);
  kernel:   lock(&fs_info->reloc_mutex);
  kernel:
                                *** DEADLOCK ***
  kernel: 3 locks held by fsstress/3062:
  kernel:  #0: 000000002fc78565 (&mm->mmap_sem){++++}, at: 
vm_mmap_pgoff+0x9f/0x110
  kernel:  #1: 0000000074df19d7 (sb_writers#9){.+.+}, at: 
touch_atime+0x64/0xd0
  kernel:  #2: 00000000e7f8e0ad (sb_internal#2){.+.+}, at: 
start_transaction+0x2e8/0x4a0 [btrfs]
  kernel:
                               stack backtrace:
  kernel: CPU: 0 PID: 3062 Comm: fsstress Not tainted 4.18.0-rc1+ #63
  kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
  kernel: Call Trace:
  kernel:  dump_stack+0x67/0x9b
  kernel:  print_circular_bug.isra.36+0x1ce/0x1db
  kernel:  __lock_acquire+0x1442/0x1540
  kernel:  ? lock_acquire+0xa6/0x200
  kernel:  lock_acquire+0xa6/0x200
  kernel:  ? btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:  __mutex_lock+0x7f/0x9d0
  kernel:  ? btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:  ? rcu_read_lock_sched_held+0x74/0x80
  kernel:  ? find_held_lock+0x2d/0x90
  kernel:  ? join_transaction+0x3b0/0x410 [btrfs]
  kernel:  ? btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:  btrfs_record_root_in_trans+0x43/0x70 [btrfs]
  kernel:  start_transaction+0xa2/0x4a0 [btrfs]
  kernel:  btrfs_dirty_inode+0x42/0xd0 [btrfs]
  kernel:  touch_atime+0xab/0xd0
  kernel:  btrfs_file_mmap+0x3c/0x60 [btrfs]
  kernel:  mmap_region+0x3a8/0x5e0
  kernel:  do_mmap+0x3dd/0x5a0
  kernel:  vm_mmap_pgoff+0xcf/0x110
  kernel:  ksys_mmap_pgoff+0x1b5/0x220
  kernel:  ? trace_hardirqs_off_thunk+0x1a/0x1c
  kernel:  do_syscall_64+0x4a/0x180
  kernel:  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  kernel: RIP: 0033:0x7ff6d43429da
  kernel: Code: 89 f5 41 54 49 89 fc 55 53 74 35 49 63 e8 48 63 da 4d 89 
f9 49 89 e8 4d 63 d6 48 89 da 4c 89 ee 4c 89 e7 b8 09 00 00 00 0f 05 
<48> 3d 00 f0 ff ff 77 56 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 00
  kernel: RSP: 002b:00007fff738dc648 EFLAGS: 00000246 ORIG_RAX: 
0000000000000009
  kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007ff6d43429da
  kernel: RDX: 0000000000000002 RSI: 000000000001bcd5 RDI: 0000000000000000
  kernel: RBP: 0000000000000003 R08: 0000000000000003 R09: 000000000008e000
  kernel: R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
  kernel: R13: 000000000001bcd5 R14: 0000000000000002 R15: 000000000008e000
-------------------------------------------------------------------

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
