Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:48205 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdI3Rzi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 13:55:38 -0400
Received: by mail-wr0-f180.google.com with SMTP id u5so1292123wrc.5
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 10:55:38 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Sat, 30 Sep 2017 18:55:36 +0100
Message-ID: <CABB28CwJ-OGqP3GvNUYjGtoi6eD1KEizij_u=Laxt6UQFeY3+Q@mail.gmail.com>
Subject: [4.14.0-0.rc2.git3.1.fc28.x86_64]: possible circular locking
 dependency detected
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raw oops dump:

[  173.695170] ======================================================
[  173.695175] WARNING: possible circular locking dependency detected
[  173.695181] 4.14.0-0.rc2.git3.1.fc28.x86_64 #1 Tainted: G           OE
[  173.695186] ------------------------------------------------------
[  173.695190] mysqld/1282 is trying to acquire lock:
[  173.695195]  (&mm->mmap_sem){++++}, at: [<ffffffff9426941e>]
get_user_pages_unlocked+0x5e/0x1b0
[  173.695217]
[  173.695222]  (&ei->dio_sem){++++}, at: [<ffffffffc0320bcf>]
btrfs_direct_IO+0x39f/0x400 [btrfs]
[  173.695293]
[  173.695299]
[  173.695304]
[  173.695322]        __lock_acquire+0x1107/0x11d0
[  173.695330]        lock_acquire+0xa3/0x1f0
[  173.695338]        down_write+0x51/0xc0
[  173.695397]        btrfs_log_changed_extents+0x89/0x640 [btrfs]
[  173.695449]        btrfs_log_inode+0x9c1/0x11d0 [btrfs]
[  173.695495]        btrfs_log_inode_parent+0x2df/0xad0 [btrfs]
[  173.695540]        btrfs_log_dentry_safe+0x60/0x80 [btrfs]
[  173.695588]        btrfs_sync_file+0x344/0x4f0 [btrfs]
[  173.695598]        vfs_fsync_range+0x4b/0xb0
[  173.695605]        do_fsync+0x3d/0x70
[  173.695612]        SyS_fsync+0x10/0x20
[  173.695621]        do_syscall_64+0x6c/0x1f0
[  173.695629]        return_from_SYSCALL_64+0x0/0x7a
[  173.695632]
[  173.695648]        __lock_acquire+0x1107/0x11d0
[  173.695656]        lock_acquire+0xa3/0x1f0
[  173.695662]        __mutex_lock+0x7f/0xa40
[  173.695669]        mutex_lock_nested+0x1b/0x20
[  173.695713]        btrfs_log_inode+0x159/0x11d0 [btrfs]
[  173.695755]        btrfs_log_inode_parent+0x2df/0xad0 [btrfs]
[  173.695797]        btrfs_log_dentry_safe+0x60/0x80 [btrfs]
[  173.695842]        btrfs_sync_file+0x344/0x4f0 [btrfs]
[  173.695850]        vfs_fsync_range+0x4b/0xb0
[  173.695857]        do_fsync+0x3d/0x70
[  173.695864]        SyS_fsync+0x10/0x20
[  173.695870]        do_syscall_64+0x6c/0x1f0
[  173.695878]        return_from_SYSCALL_64+0x0/0x7a
[  173.695882]
[  173.695898]        __sb_start_write+0x12b/0x1a0
[  173.695943]        start_transaction+0x368/0x4d0 [btrfs]
[  173.695985]        btrfs_join_transaction+0x1d/0x20 [btrfs]
[  173.696027]        delayed_ref_async_start+0x67/0xd0 [btrfs]
[  173.696074]        btrfs_worker_helper+0x93/0x610 [btrfs]
[  173.696078]
[  173.696094]        __lock_acquire+0x1107/0x11d0
[  173.696102]        lock_acquire+0xa3/0x1f0
[  173.696108]        wait_for_completion+0x62/0x1d0
[  173.696147]        btrfs_async_run_delayed_refs+0x163/0x180 [btrfs]
[  173.696190]        __btrfs_end_transaction+0x1f2/0x2e0 [btrfs]
[  173.696229]        btrfs_end_transaction+0x10/0x20 [btrfs]
[  173.696271]        btrfs_dirty_inode+0x71/0xd0 [btrfs]
[  173.696310]        btrfs_update_time+0x81/0xc0 [btrfs]
[  173.696319]        file_update_time+0xce/0x110
[  173.696362]        btrfs_page_mkwrite+0xf8/0x530 [btrfs]
[  173.696369]        do_page_mkwrite+0x2f/0xd0
[  173.696375]        do_wp_page+0x23e/0x6e0
[  173.696382]        __handle_mm_fault+0xb23/0x1310
[  173.696389]        handle_mm_fault+0x14d/0x310
[  173.696395]        __do_page_fault+0x26e/0x510
[  173.696401]        do_page_fault+0x38/0x280
[  173.696406]        page_fault+0x22/0x30
[  173.696409]
[  173.696425]        __lock_acquire+0x1107/0x11d0
[  173.696432]        lock_acquire+0xa3/0x1f0
[  173.696440]        __sb_start_write+0x12b/0x1a0
[  173.696481]        btrfs_page_mkwrite+0x68/0x530 [btrfs]
[  173.696487]        do_page_mkwrite+0x2f/0xd0
[  173.696494]        do_wp_page+0x23e/0x6e0
[  173.696501]        __handle_mm_fault+0xb23/0x1310
[  173.696507]        handle_mm_fault+0x14d/0x310
[  173.696513]        __do_page_fault+0x26e/0x510
[  173.696518]        do_page_fault+0x38/0x280
[  173.696523]        page_fault+0x22/0x30
[  173.696526]
[  173.696541]        check_prev_add+0x351/0x700
[  173.696548]        __lock_acquire+0x1107/0x11d0
[  173.696556]        lock_acquire+0xa3/0x1f0
[  173.696562]        down_read+0x48/0xb0
[  173.696568]        get_user_pages_unlocked+0x5e/0x1b0
[  173.696575]        get_user_pages_fast+0x7a/0xc0
[  173.696583]        iov_iter_get_pages+0xc9/0x300
[  173.696591]        do_blockdev_direct_IO+0x192b/0x2940
[  173.696599]        __blockdev_direct_IO+0x2e/0x30
[  173.696640]        btrfs_direct_IO+0x171/0x400 [btrfs]
[  173.696647]        generic_file_direct_write+0xa3/0x160
[  173.696690]        btrfs_file_write_iter+0x2fb/0x610 [btrfs]
[  173.696695]        aio_write+0x116/0x1a0
[  173.696700]        do_io_submit+0x42d/0x940
[  173.696706]        SyS_io_submit+0x10/0x20
[  173.696714]        entry_SYSCALL_64_fastpath+0x1f/0xbe
[  173.696717]
[  173.696722] Chain exists of:
[  173.696738]  Possible unsafe locking scenario:
[  173.696742]        CPU0                    CPU1
[  173.696745]        ----                    ----
[  173.696748]   lock(&ei->dio_sem);
[  173.696755]                                lock(&ei->log_mutex);
[  173.696762]                                lock(&ei->dio_sem);
[  173.696768]   lock(&mm->mmap_sem);
[  173.696775]
[  173.696781] 2 locks held by mysqld/1282:
[  173.696785]  #0:  (sb_writers#10){.+.+}, at: [<ffffffff9434a001>]
aio_write+0x191/0x1a0
[  173.696799]  #1:  (&ei->dio_sem){++++}, at: [<ffffffffc0320bcf>]
btrfs_direct_IO+0x39f/0x400 [btrfs]
[  173.696846]
[  173.696855] CPU: 0 PID: 1282 Comm: mysqld Tainted: G           OE
4.14.0-0.rc2.git3.1.fc28.x86_64 #1
[  173.696859] Hardware name: Sony Corporation VPCSB2M9E/VAIO, BIOS
R2087H4 06/15/2012
[  173.696864] Call Trace:
[  173.696875]  dump_stack+0x8e/0xd6
[  173.696884]  print_circular_bug+0x1f6/0x2e0
[  173.696893]  ? copy_trace+0x90/0x90
[  173.696901]  check_prev_add+0x351/0x700
[  173.696911]  ? rcu_read_lock_sched_held+0x22/0x80
[  173.696919]  ? __module_address+0x2c/0xf0
[  173.696932]  __lock_acquire+0x1107/0x11d0
[  173.696939]  ? __lock_acquire+0x1107/0x11d0
[  173.696947]  ? copy_trace+0x90/0x90
[  173.696958]  lock_acquire+0xa3/0x1f0
[  173.696966]  ? get_user_pages_unlocked+0x5e/0x1b0
[  173.696976]  down_read+0x48/0xb0
[  173.696983]  ? get_user_pages_unlocked+0x5e/0x1b0
[  173.696990]  get_user_pages_unlocked+0x5e/0x1b0
[  173.697000]  get_user_pages_fast+0x7a/0xc0
[  173.697009]  iov_iter_get_pages+0xc9/0x300
[  173.697020]  do_blockdev_direct_IO+0x192b/0x2940
[  173.697030]  ? update_stack_state+0x144/0x160
[  173.697071]  ? btrfs_endio_direct_read+0xe0/0xe0 [btrfs]
[  173.697113]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[  173.697158]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[  173.697195]  ? btrfs_endio_direct_read+0xe0/0xe0 [btrfs]
[  173.697209]  __blockdev_direct_IO+0x2e/0x30
[  173.697217]  ? __blockdev_direct_IO+0x2e/0x30
[  173.697254]  ? btrfs_endio_direct_read+0xe0/0xe0 [btrfs]
[  173.697291]  btrfs_direct_IO+0x171/0x400 [btrfs]
[  173.697328]  ? btrfs_endio_direct_read+0xe0/0xe0 [btrfs]
[  173.697339]  generic_file_direct_write+0xa3/0x160
[  173.697383]  btrfs_file_write_iter+0x2fb/0x610 [btrfs]
[  173.697391]  ? rcu_read_lock_sched_held+0x79/0x80
[  173.697400]  aio_write+0x116/0x1a0
[  173.697410]  ? sched_clock+0x9/0x10
[  173.697418]  ? __might_fault+0x3e/0x90
[  173.697427]  do_io_submit+0x42d/0x940
[  173.697432]  ? do_io_submit+0x42d/0x940
[  173.697441]  ? __do_page_fault+0x296/0x510
[  173.697451]  SyS_io_submit+0x10/0x20
[  173.697456]  ? SyS_io_submit+0x10/0x20
[  173.697464]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  173.697471] RIP: 0033:0x7f337131d687
[  173.697476] RSP: 002b:00007f334c9d34a8 EFLAGS: 00000206 ORIG_RAX:
00000000000000d1
[  173.697483] RAX: ffffffffffffffda RBX: 00007f335c694000 RCX: 00007f337131d687
[  173.697487] RDX: 00007f334c9d34b0 RSI: 0000000000000001 RDI: 00007f3368e20000
[  173.697492] RBP: 00007f334c9d3830 R08: 00007f334c9d34b0 R09: 0000000000000400
[  173.697496] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f335bd184a8
[  173.697500] R13: 0000562b50713f48 R14: 00000011d1d47ffa R15: 0000000000000001

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
