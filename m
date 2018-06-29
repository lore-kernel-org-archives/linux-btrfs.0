Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753639AbeF2Ms1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 08:48:27 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ABE58AE00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 12:48:26 +0000 (UTC)
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Subject: lockdep splat between fsync and DIO
Message-ID: <09ccd44e-4a72-2468-c21b-d5b22890a341@suse.com>
Date: Fri, 29 Jun 2018 15:48:25 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running xfstest on today's misc-next revealed the following lockdep splat
(but the machine didn't lock up): 

[ 1477.192040] ======================================================
[ 1477.192226] WARNING: possible circular locking dependency detected
[ 1477.192393] 4.18.0-rc1-nbor #755 Not tainted
[ 1477.192522] ------------------------------------------------------
[ 1477.192686] fsstress/4314 is trying to acquire lock:
[ 1477.192827] 000000003e0774ac (sb_internal#2){.+.+}, at: start_transaction+0x2e8/0x4b0
[ 1477.193027] 
               but task is already holding lock:
[ 1477.193191] 00000000ef79de77 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x3bb/0x450
[ 1477.193395] 
               which lock already depends on the new lock.

[ 1477.193589] 
               the existing dependency chain (in reverse order) is:
[ 1477.193774] 
               -> #2 (&ei->dio_sem){++++}:
[ 1477.193928]        btrfs_log_changed_extents.isra.5+0x6e/0x9e0
[ 1477.194143]        btrfs_log_inode+0x96c/0xf10
[ 1477.194344]        btrfs_log_inode_parent+0x295/0xb10
[ 1477.194540]        btrfs_log_dentry_safe+0x4a/0x70
[ 1477.194743]        btrfs_sync_file+0x3eb/0x580
[ 1477.194928]        do_fsync+0x38/0x60
[ 1477.195114]        __x64_sys_fsync+0x10/0x20
[ 1477.195320]        do_syscall_64+0x5a/0x1a0
[ 1477.195496]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1477.195698] 
               -> #1 (&ei->log_mutex){+.+.}:
[ 1477.196001]        btrfs_record_unlink_dir+0x2a/0xa0
[ 1477.196225]        btrfs_unlink+0x5e/0xd0
[ 1477.196401]        vfs_unlink+0xc4/0x190
[ 1477.196602]        do_unlinkat+0x2ab/0x310
[ 1477.196774]        do_syscall_64+0x5a/0x1a0
[ 1477.197016]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1477.197230] 
               -> #0 (sb_internal#2){.+.+}:
[ 1477.197480]        __sb_start_write+0x126/0x1a0
[ 1477.197662]        start_transaction+0x2e8/0x4b0
[ 1477.197845]        find_free_extent+0x10c1/0x1430
[ 1477.198027]        btrfs_reserve_extent+0x9b/0x180
[ 1477.198224]        btrfs_get_blocks_direct+0x38d/0x700
[ 1477.198419]        __blockdev_direct_IO+0xb2f/0x39c7
[ 1477.198611]        btrfs_direct_IO+0x190/0x450
[ 1477.198790]        generic_file_direct_write+0x9d/0x160
[ 1477.198986]        btrfs_file_write_iter+0x217/0x60b
[ 1477.199179]        aio_write+0x136/0x1f0
[ 1477.199359]        io_submit_one+0x584/0x6d0
[ 1477.199543]        __se_sys_io_submit+0x91/0x220
[ 1477.199789]        do_syscall_64+0x5a/0x1a0
[ 1477.199964]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1477.200163] 
               other info that might help us debug this:

[ 1477.200522] Chain exists of:
                 sb_internal#2 --> &ei->log_mutex --> &ei->dio_sem

[ 1477.200891]  Possible unsafe locking scenario:

[ 1477.201137]        CPU0                    CPU1
[ 1477.201356]        ----                    ----
[ 1477.201533]   lock(&ei->dio_sem);
[ 1477.201687]                                lock(&ei->log_mutex);
[ 1477.201887]                                lock(&ei->dio_sem);
[ 1477.202088]   lock(sb_internal#2);
[ 1477.202290] 
                *** DEADLOCK ***

[ 1477.202581] 1 lock held by fsstress/4314:
[ 1477.202745]  #0: 00000000ef79de77 (&ei->dio_sem){++++}, at: btrfs_direct_IO+0x3bb/0x450
[ 1477.203039] 
               stack backtrace:
[ 1477.203312] CPU: 0 PID: 4314 Comm: fsstress Not tainted 4.18.0-rc1-nbor #755
[ 1477.203537] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 1477.203850] Call Trace:
[ 1477.203992]  dump_stack+0x85/0xcb
[ 1477.204151]  print_circular_bug.isra.19+0x1c8/0x2b0
[ 1477.204383]  __lock_acquire+0x182e/0x1900
[ 1477.204551]  ? lock_acquire+0xa3/0x210
[ 1477.204715]  lock_acquire+0xa3/0x210
[ 1477.204889]  ? start_transaction+0x2e8/0x4b0
[ 1477.205065]  __sb_start_write+0x126/0x1a0
[ 1477.205271]  ? start_transaction+0x2e8/0x4b0
[ 1477.205455]  start_transaction+0x2e8/0x4b0
[ 1477.205631]  find_free_extent+0x10c1/0x1430
[ 1477.205806]  btrfs_reserve_extent+0x9b/0x180
[ 1477.205980]  btrfs_get_blocks_direct+0x38d/0x700
[ 1477.206193]  __blockdev_direct_IO+0xb2f/0x39c7
[ 1477.206397]  ? __lock_acquire+0x2b6/0x1900
[ 1477.206571]  ? __lock_acquire+0x2b6/0x1900
[ 1477.206744]  ? can_nocow_extent+0x480/0x480
[ 1477.206921]  ? btrfs_run_delalloc_work+0x40/0x40
[ 1477.207107]  ? btrfs_direct_IO+0x190/0x450
[ 1477.207322]  btrfs_direct_IO+0x190/0x450
[ 1477.207492]  ? btrfs_run_delalloc_work+0x40/0x40
[ 1477.207678]  generic_file_direct_write+0x9d/0x160
[ 1477.207862]  btrfs_file_write_iter+0x217/0x60b
[ 1477.208044]  aio_write+0x136/0x1f0
[ 1477.208244]  ? lock_acquire+0xa3/0x210
[ 1477.208415]  ? __might_fault+0x3e/0x90
[ 1477.208580]  ? io_submit_one+0x584/0x6d0
[ 1477.208749]  io_submit_one+0x584/0x6d0
[ 1477.208917]  ? lock_acquire+0xa3/0x210
[ 1477.209086]  __se_sys_io_submit+0x91/0x220
[ 1477.209296]  ? do_syscall_64+0x5a/0x1a0
[ 1477.209468]  do_syscall_64+0x5a/0x1a0
[ 1477.209636]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1477.209826] RIP: 0033:0x7fa509cee697
[ 1477.209988] Code: 00 75 08 8b 47 0c 39 47 08 74 08 e9 c3 ff ff ff 0f 1f 00 31 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00 
[ 1477.210587] RSP: 002b:00007ffc03046688 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[ 1477.210872] RAX: ffffffffffffffda RBX: 00007ffc030466f0 RCX: 00007fa509cee697
[ 1477.211098] RDX: 00007ffc03046730 RSI: 0000000000000001 RDI: 00007fa50a315000
[ 1477.211361] RBP: 0000000000000001 R08: 0000000000000015 R09: 0000000000000000
[ 1477.211591] R10: 00007fa509acbb78 R11: 0000000000000246 R12: 000000000000032a
[ 1477.211818] R13: 0000000000000003 R14: 0000000000140000 R15: 0000000000017000

I think it considers the following scenario a possible deadlock: 

T1:                                                                         T2:
do_fsync                                                             
  btrfs_sync_file                                                      
    start_transaction (acquire sb_intwrite)             generic_file_direct_write                               
    btrfs_log_inode_parent                                 btrfs_direct_IO (acquire dio_sem)           
      btrfs_log_inode					        __blockdev_direct_IO
        							  btrfs_get_blocks_direct
								    btrfs_reserve_extent
								       find_free_extent
 									 start_transaction (acquire intwrite, block on T1)
														


          btrfs_log_changed_extents (acquire dio_sem, block on T2)


The allocator (find_free_extent) will try to allocate a chunk, thus start a 
transaction under dio_sem, whereas we can have an alternative thread doing fsync, 
that has already acquired sb_intwrite and will want to acquire dio_sem. However, 
it seems this is false-positive since both threads take sb_intwrite (that's the 
per-cpu rw semaphore comprising the freeze protection) in read mode. 
