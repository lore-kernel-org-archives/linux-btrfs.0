Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:38297 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdLLFMq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 00:12:46 -0500
Received: by mail-wr0-f172.google.com with SMTP id o2so19773636wro.5
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 21:12:45 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Tue, 12 Dec 2017 05:12:44 +0000
Message-ID: <CABB28CxbiCTVOUYKbUv7-O-0bAAweSJF--7OnJtNAnud6TipwQ@mail.gmail.com>
Subject: 4.15.0-0.rc2.git2.1.fc28.x86_64: possible circular locking dependency detected
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Jut done upgrade on my laptop to the latest Fedora rawhide packages.
After reboot and login in dmesg I found logged btrfs issue:

[   94.192907] ======================================================
[   94.192911] WARNING: possible circular locking dependency detected
[   94.192917] 4.15.0-0.rc2.git2.1.fc28.x86_64 #1 Not tainted
[   94.192921] ------------------------------------------------------
[   94.192926] mysqld/1225 is trying to acquire lock:
[   94.192930]  (&mm->mmap_sem){++++}, at: [<0000000065e31c80>]
get_user_pages_unlocked+0x5b/0x1b0
[   94.192955]
               but task is already holding lock:
[   94.192962]  (&ei->dio_sem){++++}, at: [<0000000008becadb>]
btrfs_direct_IO+0x395/0x410 [btrfs]
[   94.193059]
               which lock already depends on the new lock.

[   94.193069]
               the existing dependency chain (in reverse order) is:
[   94.193076]
               -> #4 (&ei->dio_sem){++++}:
[   94.193102]        down_write+0x4d/0xb0
[   94.193183]        btrfs_log_changed_extents+0x7c/0x680 [btrfs]
[   94.193261]        btrfs_log_inode+0x9c0/0x11a0 [btrfs]
[   94.193326]        btrfs_log_inode_parent+0x2d7/0xaa0 [btrfs]
[   94.193395]        btrfs_log_dentry_safe+0x58/0x80 [btrfs]
[   94.193466]        btrfs_sync_file+0x332/0x4e0 [btrfs]
[   94.193477]        do_fsync+0x38/0x60
[   94.193484]        SyS_fsync+0xc/0x10
[   94.193493]        do_syscall_64+0x66/0x210
[   94.193501]        return_from_SYSCALL_64+0x0/0x75
[   94.193505]
               -> #3 (&ei->log_mutex){+.+.}:
[   94.193519]        __mutex_lock+0x7f/0xa40
[   94.193563]        btrfs_log_inode+0x162/0x11a0 [btrfs]
[   94.193604]        btrfs_log_inode_parent+0x2d7/0xaa0 [btrfs]
[   94.193646]        btrfs_log_dentry_safe+0x58/0x80 [btrfs]
[   94.193692]        btrfs_sync_file+0x332/0x4e0 [btrfs]
[   94.193698]        do_fsync+0x38/0x60
[   94.193705]        SyS_fsync+0xc/0x10
[   94.193711]        do_syscall_64+0x66/0x210
[   94.193718]        return_from_SYSCALL_64+0x0/0x75
[   94.193721]
               -> #2 (sb_internal){.+.+}:
[   94.193737]        debug_check_no_obj_freed+0xde/0x248
[   94.193740]
               -> #1 ((completion)&async->wait){+.+.}:
[   94.193753]        wait_for_completion+0x63/0x1e0
[   94.193792]        btrfs_async_run_delayed_refs+0x14b/0x170 [btrfs]
[   94.193837]        __btrfs_end_transaction+0x1ee/0x2e0 [btrfs]
[   94.193881]        btrfs_dirty_inode+0x6a/0xd0 [btrfs]
[   94.193891]        touch_atime+0xab/0xd0
[   94.193934]        btrfs_file_mmap+0x3f/0x60 [btrfs]
[   94.193942]        mmap_region+0x3ac/0x5e0
[   94.193949]        do_mmap+0x2e1/0x450
[   94.193959]        vm_mmap_pgoff+0xd5/0x120
[   94.193966]        SyS_mmap_pgoff+0x1c2/0x250
[   94.193973]        entry_SYSCALL_64_fastpath+0x1f/0x96
[   94.193976]
               -> #0 (&mm->mmap_sem){++++}:
[   94.193990]        lock_acquire+0x9f/0x1f0
[   94.193995]        down_read+0x44/0xa0
[   94.194001]        get_user_pages_unlocked+0x5b/0x1b0
[   94.194006]        get_user_pages_fast+0xcf/0x140
[   94.194014]        iov_iter_get_pages+0xc5/0x2f0
[   94.194021]        do_blockdev_direct_IO+0x193c/0x2950
[   94.194065]        btrfs_direct_IO+0x166/0x410 [btrfs]
[   94.194074]        generic_file_direct_write+0x9d/0x160
[   94.194117]        btrfs_file_write_iter+0x300/0x650 [btrfs]
[   94.194125]        aio_write+0x116/0x1a0
[   94.194132]        do_io_submit+0x42d/0x940
[   94.194139]        entry_SYSCALL_64_fastpath+0x1f/0x96
[   94.194142]
               other info that might help us debug this:

[   94.194147] Chain exists of:
                 &mm->mmap_sem --> &ei->log_mutex --> &ei->dio_sem

[   94.194162]  Possible unsafe locking scenario:

[   94.194166]        CPU0                    CPU1
[   94.194169]        ----                    ----
[   94.194172]   lock(&ei->dio_sem);
[   94.194178]                                lock(&ei->log_mutex);
[   94.194184]                                lock(&ei->dio_sem);
[   94.194190]   lock(&mm->mmap_sem);
[   94.194196]
                *** DEADLOCK ***

[   94.194202] 2 locks held by mysqld/1225:
[   94.194205]  #0:  (sb_writers#10){.+.+}, at: [<00000000164669fb>]
aio_write+0x191/0x1a0
[   94.194220]  #1:  (&ei->dio_sem){++++}, at: [<0000000008becadb>]
btrfs_direct_IO+0x395/0x410 [btrfs]
[   94.194268]
               stack backtrace:
[   94.194276] CPU: 1 PID: 1225 Comm: mysqld Not tainted
4.15.0-0.rc2.git2.1.fc28.x86_64 #1
[   94.194281] Hardware name: Sony Corporation VPCSB2M9E/VAIO, BIOS
R2087H4 06/15/2012
[   94.194285] Call Trace:
[   94.194296]  dump_stack+0x85/0xbf
[   94.194304]  print_circular_bug+0x1f5/0x2e0
[   94.194315]  ? copy_trace+0x80/0x80
[   94.194320]  check_prev_add+0x3da/0x780
[   94.194332]  ? __lock_acquire+0x11e9/0x1270
[   94.194338]  __lock_acquire+0x11e9/0x1270
[   94.194349]  lock_acquire+0x9f/0x1f0
[   94.194355]  ? get_user_pages_unlocked+0x5b/0x1b0
[   94.194365]  down_read+0x44/0xa0
[   94.194371]  ? get_user_pages_unlocked+0x5b/0x1b0
[   94.194376]  get_user_pages_unlocked+0x5b/0x1b0
[   94.194383]  ? mark_held_locks+0x4e/0x80
[   94.194391]  get_user_pages_fast+0xcf/0x140
[   94.194400]  iov_iter_get_pages+0xc5/0x2f0
[   94.194411]  do_blockdev_direct_IO+0x193c/0x2950
[   94.194417]  ? __lock_acquire+0x2c3/0x1270
[   94.194460]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   94.194504]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[   94.194552]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[   94.194591]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   94.194633]  ? btrfs_direct_IO+0x166/0x410 [btrfs]
[   94.194669]  btrfs_direct_IO+0x166/0x410 [btrfs]
[   94.194706]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   94.194718]  generic_file_direct_write+0x9d/0x160
[   94.194763]  btrfs_file_write_iter+0x300/0x650 [btrfs]
[   94.194776]  aio_write+0x116/0x1a0
[   94.194787]  ? __might_fault+0x3e/0x90
[   94.194797]  ? do_io_submit+0x42d/0x940
[   94.194804]  do_io_submit+0x42d/0x940
[   94.194819]  ? entry_SYSCALL_64_fastpath+0x1f/0x96
[   94.194826]  entry_SYSCALL_64_fastpath+0x1f/0x96
[   94.194833] RIP: 0033:0x7f7e2d309687
[   94.194837] RSP: 002b:00007f7e10ce34a8 EFLAGS: 00000206 ORIG_RAX:
00000000000000d1
[   94.194844] RAX: ffffffffffffffda RBX: 00007f7e186a8000 RCX: 00007f7e2d309687
[   94.194849] RDX: 00007f7e10ce34b0 RSI: 0000000000000001 RDI: 00007f7e24ddb000
[   94.194853] RBP: 00007f7e10ce3830 R08: 00007f7e10ce34b0 R09: 0000000000000400
[   94.194857] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f7e17d18c50
[   94.194861] R13: 0000561dfbb5d028 R14: 000000185b3a7525 R15: 0000000000000001

kloczek
-- 
Tomasz Kłoczko  | LinkedIn: http://lnkd.in/FXPWxH
