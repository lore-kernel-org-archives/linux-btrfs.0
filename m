Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38363 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbdCOQcJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:32:09 -0400
Received: by mail-wm0-f45.google.com with SMTP id t189so27460141wmt.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 09:31:32 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: possible deadlock between fsfreeze and asynchronous faults
Message-ID: <440e7edc-ae54-dd15-f463-7c9ace03e22f@gmail.com>
Date: Wed, 15 Mar 2017 18:31:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is a nother lockdep splat I got: 

[ 1131.517411] ======================================================
[ 1131.518059] [ INFO: possible circular locking dependency detected ]
[ 1131.518059] 4.11.0-rc1-nbor #147 Tainted: G        W      
[ 1131.518059] -------------------------------------------------------
[ 1131.518059] xfs_io/2661 is trying to acquire lock:
[ 1131.518059]  (sb_internal#2){++++.+}, at: [<ffffffff810a6a05>] percpu_down_write+0x25/0x120
[ 1131.518059] 
[ 1131.518059] but task is already holding lock:
[ 1131.518059]  (sb_pagefaults){++++..}, at: [<ffffffff810a6a05>] percpu_down_write+0x25/0x120
[ 1131.518059] 
[ 1131.518059] which lock already depends on the new lock.
[ 1131.518059] 
[ 1131.518059] 
[ 1131.518059] the existing dependency chain (in reverse order) is:
[ 1131.518059] 
[ 1131.518059] -> #4 (sb_pagefaults){++++..}:
[ 1131.518059]        lock_acquire+0xc5/0x220
[ 1131.518059]        __sb_start_write+0x119/0x1d0
[ 1131.518059]        btrfs_page_mkwrite+0x51/0x420
[ 1131.518059]        do_page_mkwrite+0x38/0xb0
[ 1131.518059]        __handle_mm_fault+0x6b5/0xef0
[ 1131.518059]        handle_mm_fault+0x175/0x300
[ 1131.518059]        __do_page_fault+0x1e0/0x4d0
[ 1131.518059]        trace_do_page_fault+0xaa/0x270
[ 1131.518059]        do_async_page_fault+0x19/0x70
[ 1131.518059]        async_page_fault+0x28/0x30
[ 1131.518059] 
[ 1131.518059] -> #3 (&mm->mmap_sem){++++++}:
[ 1131.518059]        lock_acquire+0xc5/0x220
[ 1131.518059]        down_read+0x47/0x70
[ 1131.518059]        get_user_pages_unlocked+0x4f/0x1a0
[ 1131.518059]        get_user_pages_fast+0x81/0x170
[ 1131.518059]        iov_iter_get_pages+0xc1/0x300
[ 1131.518059]        __blockdev_direct_IO+0x14f8/0x34e0
[ 1131.518059]        btrfs_direct_IO+0x1e8/0x390
[ 1131.518059]        generic_file_direct_write+0xb5/0x160
[ 1131.518059]        btrfs_file_write_iter+0x26d/0x500
[ 1131.518059]        aio_write+0xdb/0x190
[ 1131.518059]        do_io_submit+0x5aa/0x830
[ 1131.518059]        SyS_io_submit+0x10/0x20
[ 1131.518059]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 1131.518059] 
[ 1131.518059] -> #2 (&ei->dio_sem){++++.+}:
[ 1131.518059]        lock_acquire+0xc5/0x220
[ 1131.518059]        down_write+0x44/0x80
[ 1131.518059]        btrfs_log_changed_extents+0x7c/0x660
[ 1131.518059]        btrfs_log_inode+0xb78/0xf50
[ 1131.518059]        btrfs_log_inode_parent+0x2a9/0xa70
[ 1131.518059]        btrfs_log_dentry_safe+0x74/0xa0
[ 1131.518059]        btrfs_sync_file+0x321/0x4d0
[ 1131.518059]        vfs_fsync_range+0x46/0xc0
[ 1131.518059]        vfs_fsync+0x1c/0x20
[ 1131.518059]        do_fsync+0x38/0x60
[ 1131.518059]        SyS_fsync+0x10/0x20
[ 1131.518059]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 1131.518059] 
[ 1131.518059] -> #1 (&ei->log_mutex){+.+...}:
[ 1131.518059]        lock_acquire+0xc5/0x220
[ 1131.518059]        __mutex_lock+0x7c/0x960
[ 1131.518059]        mutex_lock_nested+0x1b/0x20
[ 1131.518059]        btrfs_record_unlink_dir+0x3e/0xb0
[ 1131.518059]        btrfs_unlink+0x72/0xf0
[ 1131.518059]        vfs_unlink+0xbe/0x1b0
[ 1131.518059]        do_unlinkat+0x244/0x280
[ 1131.518059]        SyS_unlinkat+0x1d/0x30
[ 1131.518059]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 1131.518059] 
[ 1131.518059] -> #0 (sb_internal#2){++++.+}:
[ 1131.518059]        __lock_acquire+0x16f1/0x17c0
[ 1131.518059]        lock_acquire+0xc5/0x220
[ 1131.518059]        down_write+0x44/0x80
[ 1131.518059]        percpu_down_write+0x25/0x120
[ 1131.518059]        freeze_super+0xbf/0x1a0
[ 1131.518059]        do_vfs_ioctl+0x598/0x770
[ 1131.518059]        SyS_ioctl+0x4c/0x90
[ 1131.518059]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 1131.518059] 
[ 1131.518059] other info that might help us debug this:
[ 1131.518059] 
[ 1131.518059] Chain exists of:
[ 1131.518059]   sb_internal#2 --> &mm->mmap_sem --> sb_pagefaults
[ 1131.518059] 
[ 1131.518059]  Possible unsafe locking scenario:
[ 1131.518059] 
[ 1131.518059]        CPU0                    CPU1
[ 1131.518059]        ----                    ----
[ 1131.518059]   lock(sb_pagefaults);
[ 1131.518059]                                lock(&mm->mmap_sem);
[ 1131.518059]                                lock(sb_pagefaults);
[ 1131.518059]   lock(sb_internal#2);
[ 1131.518059] 
[ 1131.518059]  *** DEADLOCK ***
[ 1131.518059] 
[ 1131.518059] 3 locks held by xfs_io/2661:
[ 1131.518059]  #0:  (sb_writers#11){++++.+}, at: [<ffffffff810a6a05>] percpu_down_write+0x25/0x120
[ 1131.518059]  #1:  (&type->s_umount_key#33){+++++.}, at: [<ffffffff811e0b83>] freeze_super+0x93/0x1a0
[ 1131.518059]  #2:  (sb_pagefaults){++++..}, at: [<ffffffff810a6a05>] percpu_down_write+0x25/0x120
[ 1131.518059] 
[ 1131.518059] stack backtrace:
[ 1131.518059] CPU: 0 PID: 2661 Comm: xfs_io Tainted: G        W       4.11.0-rc1-nbor #147
[ 1131.518059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 1131.518059] Call Trace:
[ 1131.518059]  dump_stack+0x85/0xc9
[ 1131.518059]  print_circular_bug+0x2ac/0x2ba
[ 1131.518059]  __lock_acquire+0x16f1/0x17c0
[ 1131.518059]  ? mark_held_locks+0x66/0x90
[ 1131.518059]  ? _raw_spin_unlock_irqrestore+0x3f/0x70
[ 1131.518059]  lock_acquire+0xc5/0x220
[ 1131.518059]  ? percpu_down_write+0x25/0x120
[ 1131.518059]  down_write+0x44/0x80
[ 1131.518059]  ? percpu_down_write+0x25/0x120
[ 1131.518059]  percpu_down_write+0x25/0x120
[ 1131.518059]  freeze_super+0xbf/0x1a0
[ 1131.518059]  ? ns_capable+0x49/0x80
[ 1131.518059]  do_vfs_ioctl+0x598/0x770
[ 1131.518059]  ? _copy_to_user+0x6f/0xb0
[ 1131.518059]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
[ 1131.518059]  ? trace_hardirqs_on_caller+0x111/0x1e0
[ 1131.518059]  SyS_ioctl+0x4c/0x90
[ 1131.518059]  entry_SYSCALL_64_fastpath+0x23/0xc6
[ 1131.518059] RIP: 0033:0x7f05d8cae357
[ 1131.518059] RSP: 002b:00007ffca2c50c58 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 1131.518059] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f05d8cae357
[ 1131.518059] RDX: 00007ffca2c50c64 RSI: ffffffffc0045877 RDI: 0000000000000003
[ 1131.518059] RBP: 00007ffca2c50b20 R08: 000000000000ffff R09: 0000000000000001
[ 1131.518059] R10: 000000000000053f R11: 0000000000000202 R12: 0000000000000009
[ 1131.518059] R13: 0000000000000400 R14: 0000000000db1130 R15: 0000000000410aa0


The way I understand it is possible to deadlock if you get an asynchronous
pagefault while the filesystem is in the middle of being frozen. In the 
freeze path we have : sb_writers->sb_pagefaults->sb_internals locks aka the 
different locks being acquired sb_wait_write invocations. And in the 
do_async_page_fault call path (calltraces #4) we do take mmap_sem and in 
btrfs_page_mkwrite we take sb_pagefaults. 


Regards, 
Nikolay 
