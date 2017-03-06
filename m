Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbdCFMVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Mar 2017 07:21:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD944ADAF
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Mar 2017 12:21:39 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Subject: lockdep splat on latest master
Message-ID: <0d22993e-516a-3d79-eea1-beeebf8a882a@suse.com>
Date: Mon, 6 Mar 2017 14:21:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Running generic/208 on latest linux master I got the following splat: 

[ 3540.719007] ======================================================
[ 3540.719007] [ INFO: possible circular locking dependency detected ]
[ 3540.719007] 4.11.0-rc1-nbor #147 Tainted: G        W      
[ 3540.719007] -------------------------------------------------------
[ 3540.719007] aio-dio-invalid/1451 is trying to acquire lock:
[ 3540.719007]  (&mm->mmap_sem){++++++}, at: [<ffffffff81192daf>] get_user_pages_unlocked+0x4f/0x1a0
[ 3540.719007]
[ 3540.719007] but task is already holding lock:
[ 3540.719007]  (&ei->dio_sem){++++.+}, at: [<ffffffff813ea5d4>] btrfs_direct_IO+0x324/0x390
[ 3540.719007]
[ 3540.719007] which lock already depends on the new lock.
[ 3540.719007]
[ 3540.719007]
[ 3540.719007] the existing dependency chain (in reverse order) is:
[ 3540.719007]
[ 3540.719007] -> #4 (&ei->dio_sem){++++.+}:
[ 3540.719007]        lock_acquire+0xc5/0x220
[ 3540.719007]        down_write+0x44/0x80
[ 3540.719007]        btrfs_log_changed_extents+0x7c/0x660
[ 3540.719007]        btrfs_log_inode+0xb78/0xf50
[ 3540.719007]        btrfs_log_inode_parent+0x2a9/0xa70
[ 3540.719007]        btrfs_log_dentry_safe+0x74/0xa0
[ 3540.719007]        btrfs_sync_file+0x321/0x4d0
[ 3540.719007]        vfs_fsync_range+0x46/0xc0
[ 3540.719007]        vfs_fsync+0x1c/0x20
[ 3540.719007]        do_fsync+0x38/0x60
[ 3540.719007]        SyS_fdatasync+0x13/0x20
[ 3540.719007]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 3540.719007]
[ 3540.719007] -> #3 (&ei->log_mutex){+.+...}:
[ 3540.719007]        lock_acquire+0xc5/0x220
[ 3540.719007]        __mutex_lock+0x7c/0x960
[ 3540.719007]        mutex_lock_nested+0x1b/0x20
[ 3540.719007]        btrfs_record_unlink_dir+0x3e/0xb0
[ 3540.719007]        btrfs_unlink+0x72/0xf0
[ 3540.719007]        vfs_unlink+0xbe/0x1b0
[ 3540.719007]        do_unlinkat+0x244/0x280
[ 3540.719007]        SyS_unlinkat+0x1d/0x30
[ 3540.719007]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 3540.719007]
[ 3540.719007] -> #2 (sb_internal#2){++++.+}:
[ 3540.719007]        lock_acquire+0xc5/0x220
[ 3540.719007]        down_write+0x44/0x80
[ 3540.719007]        percpu_down_write+0x25/0x120
[ 3540.719007]        freeze_super+0xbf/0x1a0
[ 3540.719007]        do_vfs_ioctl+0x598/0x770
[ 3540.719007]        SyS_ioctl+0x4c/0x90
[ 3540.719007]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 3540.719007]
[ 3540.719007] -> #1 (sb_pagefaults){++++..}:
[ 3540.719007]        lock_acquire+0xc5/0x220
[ 3540.719007]        __sb_start_write+0x119/0x1d0
[ 3540.719007]        btrfs_page_mkwrite+0x51/0x420
[ 3540.719007]        do_page_mkwrite+0x38/0xb0
[ 3540.719007]        __handle_mm_fault+0x6b5/0xef0
[ 3540.719007]        handle_mm_fault+0x175/0x300
[ 3540.719007]        __do_page_fault+0x1e0/0x4d0
[ 3540.719007]        trace_do_page_fault+0xaa/0x270
[ 3540.719007]        do_async_page_fault+0x19/0x70
[ 3540.719007]        async_page_fault+0x28/0x30
[ 3540.719007]
[ 3540.719007] -> #0 (&mm->mmap_sem){++++++}:
[ 3540.719007]        __lock_acquire+0x16f1/0x17c0
[ 3540.719007]        lock_acquire+0xc5/0x220
[ 3540.719007]        down_read+0x47/0x70
[ 3540.719007]        get_user_pages_unlocked+0x4f/0x1a0
[ 3540.719007]        get_user_pages_fast+0x81/0x170
[ 3540.719007]        iov_iter_get_pages+0xc1/0x300
[ 3540.719007]        __blockdev_direct_IO+0x14f8/0x34e0
[ 3540.719007]        btrfs_direct_IO+0x1e8/0x390
[ 3540.719007]        generic_file_direct_write+0xb5/0x160
[ 3540.719007]        btrfs_file_write_iter+0x26d/0x500
[ 3540.719007]        aio_write+0xdb/0x190
[ 3540.719007]        do_io_submit+0x5aa/0x830
[ 3540.719007]        SyS_io_submit+0x10/0x20
[ 3540.719007]        entry_SYSCALL_64_fastpath+0x23/0xc6
[ 3540.719007]
[ 3540.719007] other info that might help us debug this:
[ 3540.719007]
[ 3540.719007] Chain exists of:
[ 3540.719007]   &mm->mmap_sem --> &ei->log_mutex --> &ei->dio_sem
[ 3540.719007]
[ 3540.719007]  Possible unsafe locking scenario:
[ 3540.719007]
[ 3540.719007]        CPU0                    CPU1
[ 3540.719007]        ----                    ----
[ 3540.719007]   lock(&ei->dio_sem);
[ 3540.719007]                                lock(&ei->log_mutex);
[ 3540.719007]                                lock(&ei->dio_sem);
[ 3540.719007]   lock(&mm->mmap_sem);
[ 3540.719007]
[ 3540.719007]  *** DEADLOCK ***
[ 3540.719007]
[ 3540.719007] 2 locks held by aio-dio-invalid/1451:
[ 3540.719007]  #0:  (sb_writers#11){++++.+}, at: [<ffffffff812322d8>] aio_write+0x168/0x190
[ 3540.719007]  #1:  (&ei->dio_sem){++++.+}, at: [<ffffffff813ea5d4>] btrfs_direct_IO+0x324/0x390
[ 3540.719007]
[ 3540.719007] stack backtrace:
[ 3540.719007] CPU: 3 PID: 1451 Comm: aio-dio-invalid Tainted: G        W       4.11.0-rc1-nbor #147
[ 3540.719007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 3540.719007] Call Trace:
[ 3540.719007]  dump_stack+0x85/0xc9
[ 3540.719007]  print_circular_bug+0x2ac/0x2ba
[ 3540.719007]  __lock_acquire+0x16f1/0x17c0
[ 3540.719007]  ? __lock_acquire+0x300/0x17c0
[ 3540.719007]  lock_acquire+0xc5/0x220
[ 3540.719007]  ? get_user_pages_unlocked+0x4f/0x1a0
[ 3540.719007]  down_read+0x47/0x70
[ 3540.719007]  ? get_user_pages_unlocked+0x4f/0x1a0
[ 3540.719007]  get_user_pages_unlocked+0x4f/0x1a0 <- ACQUIRE MMAP_SEM
[ 3540.719007]  ? mark_held_locks+0x66/0x90
[ 3540.719007]  ? get_user_pages_fast+0x14f/0x170
[ 3540.719007]  get_user_pages_fast+0x81/0x170
[ 3540.719007]  iov_iter_get_pages+0xc1/0x300
[ 3540.719007]  __blockdev_direct_IO+0x14f8/0x34e0
[ 3540.719007]  ? block_rsv_add_bytes+0x55/0x70
[ 3540.719007]  ? btrfs_page_exists_in_range+0x250/0x250
[ 3540.719007]  ? btrfs_page_exists_in_range+0x250/0x250
[ 3540.719007]  ? insert_reserved_file_extent.constprop.72+0x2f0/0x2f0
[ 3540.719007]  btrfs_direct_IO+0x1e8/0x390  < - ACQUIRE DIO_SEM
[ 3540.719007]  ? insert_reserved_file_extent.constprop.72+0x2f0/0x2f0
[ 3540.719007]  generic_file_direct_write+0xb5/0x160
[ 3540.719007]  btrfs_file_write_iter+0x26d/0x500
[ 3540.719007]  ? aio_write+0x168/0x190
[ 3540.719007]  aio_write+0xdb/0x190
[ 3540.719007]  ? __might_fault+0x43/0xa0
[ 3540.719007]  do_io_submit+0x5aa/0x830
[ 3540.719007]  ? do_io_submit+0x2f3/0x830
[ 3540.719007]  SyS_io_submit+0x10/0x20
[ 3540.719007]  entry_SYSCALL_64_fastpath+0x23/0xc6
[ 3540.719007] RIP: 0033:0x7f3fd9025697
[ 3540.719007] RSP: 002b:00007fff768d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[ 3540.719007] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f3fd9025697
[ 3540.719007] RDX: 00007fff768d0cf0 RSI: 0000000000000001 RDI: 00007f3fd9449000
[ 3540.719007] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f3fd9020260
[ 3540.719007] R10: 00007fff768d0c90 R11: 0000000000000246 R12: 0000000000000000
[ 3540.719007] R13: 00007fff768d0eb0 R14: 0000000000000000 R15: 0000000000000000
