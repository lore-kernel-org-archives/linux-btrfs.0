Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:44949 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756293AbdLPEdm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 23:33:42 -0500
Received: by mail-wm0-f43.google.com with SMTP id t8so20737246wmc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 20:33:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTd2y8vs5WYwgLKGZJfRr4-G0RGh+1OEanq_u00+zL-TQ@mail.gmail.com>
References: <CABB28CxbiCTVOUYKbUv7-O-0bAAweSJF--7OnJtNAnud6TipwQ@mail.gmail.com>
 <CAJCQCtTd2y8vs5WYwgLKGZJfRr4-G0RGh+1OEanq_u00+zL-TQ@mail.gmail.com>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Sat, 16 Dec 2017 04:33:40 +0000
Message-ID: <CABB28CzRa5R4ZynWwfLKoqa6ObZH_RL5VVSfrDEQ5=CFgyX8aQ@mail.gmail.com>
Subject: Re: 4.15.0-0.rc2.git2.1.fc28.x86_64: possible circular locking
 dependency detected
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 December 2017 at 06:50, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mon, Dec 11, 2017 at 10:12 PM, Tomasz Kłoczko
> <kloczko.tomasz@gmail.com> wrote:
> > Hi,
> >
> > Jut done upgrade on my laptop to the latest Fedora rawhide packages.
> > After reboot and login in dmesg I found logged btrfs issue:
> >
> > [   94.192907] ======================================================
> > [   94.192911] WARNING: possible circular locking dependency detected
> > [   94.192917] 4.15.0-0.rc2.git2.1.fc28.x86_64 #1 Not tainted
>
> I'm not seeing it so far with 4.15.0-0.rc3.git0.1.fc28.x86_64+debug.

[   90.516496] 4.15.0-0.rc3.git1.1.fc28.x86_64 #1 Not tainted
[   90.516502] ------------------------------------------------------
[   90.516509] mysqld/1236 is trying to acquire lock:
[   90.516515]  (&mm->mmap_sem){++++}, at: [<000000004969b9d5>]
get_user_pages_unlocked+0x5b/0x1b0
[   90.516543]
               but task is already holding lock:
[   90.516550]  (&ei->dio_sem){++++}, at: [<000000000cdc761a>]
btrfs_direct_IO+0x395/0x410 [btrfs]
[   90.516644]
               which lock already depends on the new lock.

[   90.516650]
               the existing dependency chain (in reverse order) is:
[   90.516654]
               -> #5 (&ei->dio_sem){++++}:
[   90.516672]        down_write+0x4d/0xb0
[   90.516732]        btrfs_log_changed_extents+0x7c/0x680 [btrfs]
[   90.516807]        btrfs_log_inode+0x9c0/0x11a0 [btrfs]
[   90.516864]        btrfs_log_inode_parent+0x2d7/0xaa0 [btrfs]
[   90.516915]        btrfs_log_dentry_safe+0x58/0x80 [btrfs]
[   90.516973]        btrfs_sync_file+0x332/0x4e0 [btrfs]
[   90.516987]        do_fsync+0x38/0x60
[   90.516997]        SyS_fsync+0xc/0x10
[   90.517008]        do_syscall_64+0x66/0x210
[   90.517020]        return_from_SYSCALL_64+0x0/0x75
[   90.517026]
               -> #4 (&ei->log_mutex){+.+.}:
[   90.517049]        __mutex_lock+0x7f/0xa40
[   90.517126]        btrfs_log_inode+0x162/0x11a0 [btrfs]
[   90.517202]        btrfs_log_inode_parent+0x2d7/0xaa0 [btrfs]
[   90.517277]        btrfs_log_dentry_safe+0x58/0x80 [btrfs]
[   90.517356]        btrfs_sync_file+0x332/0x4e0 [btrfs]
[   90.517367]        do_fsync+0x38/0x60
[   90.517378]        SyS_fsync+0xc/0x10
[   90.517387]        do_syscall_64+0x66/0x210
[   90.517400]        return_from_SYSCALL_64+0x0/0x75
[   90.517406]
               -> #3 (sb_internal){.+.+}:
[   90.517499]        free_extent_buffer+0x2f/0x90 [btrfs]
[   90.517505]
               -> #2 ((completion)&async->wait){+.+.}:
[   90.517529]        wait_for_completion+0x63/0x1e0
[   90.517596]        btrfs_async_run_delayed_refs+0x14b/0x170 [btrfs]
[   90.517668]        __btrfs_end_transaction+0x1ee/0x2e0 [btrfs]
[   90.517739]        btrfs_dirty_inode+0x6a/0xd0 [btrfs]
[   90.517756]        file_update_time+0xce/0x110
[   90.517809]        btrfs_page_mkwrite+0xff/0x560 [btrfs]
[   90.517816]        do_page_mkwrite+0x2a/0xc0
[   90.517822]        do_wp_page+0x234/0x5d0
[   90.517828]        __handle_mm_fault+0x658/0x1330
[   90.517834]        handle_mm_fault+0x14c/0x310
[   90.517840]        __do_page_fault+0x28c/0x530
[   90.517845]        do_page_fault+0x32/0x270
[   90.517853]        page_fault+0x22/0x30
[   90.517856]
               -> #1 (sb_pagefaults){.+.+}:
[   90.517872]        __sb_start_write+0x138/0x1b0
[   90.517915]        btrfs_page_mkwrite+0x6a/0x560 [btrfs]
[   90.517921]        do_page_mkwrite+0x2a/0xc0
[   90.517927]        do_wp_page+0x234/0x5d0
[   90.517932]        __handle_mm_fault+0x658/0x1330
[   90.517938]        handle_mm_fault+0x14c/0x310
[   90.517943]        __do_page_fault+0x28c/0x530
[   90.517949]        do_page_fault+0x32/0x270
[   90.517956]        page_fault+0x22/0x30
[   90.517959]
               -> #0 (&mm->mmap_sem){++++}:
[   90.517973]        lock_acquire+0x9f/0x1f0
[   90.517979]        down_read+0x44/0xa0
[   90.517984]        get_user_pages_unlocked+0x5b/0x1b0
[   90.517989]        get_user_pages_fast+0xcf/0x140
[   90.517998]        iov_iter_get_pages+0xc5/0x2f0
[   90.518006]        do_blockdev_direct_IO+0x193c/0x2950
[   90.518050]        btrfs_direct_IO+0x166/0x410 [btrfs]
[   90.518059]        generic_file_direct_write+0x9d/0x160
[   90.518104]        btrfs_file_write_iter+0x300/0x650 [btrfs]
[   90.518111]        aio_write+0x116/0x1a0
[   90.518118]        do_io_submit+0x42d/0x940
[   90.518125]        entry_SYSCALL_64_fastpath+0x1f/0x96
[   90.518128]
               other info that might help us debug this:

[   90.518133] Chain exists of:
                 &mm->mmap_sem --> &ei->log_mutex --> &ei->dio_sem

[   90.518148]  Possible unsafe locking scenario:

[   90.518152]        CPU0                    CPU1
[   90.518155]        ----                    ----
[   90.518158]   lock(&ei->dio_sem);
[   90.518164]                                lock(&ei->log_mutex);
[   90.518170]                                lock(&ei->dio_sem);
[   90.518176]   lock(&mm->mmap_sem);
[   90.518182]
                *** DEADLOCK ***

[   90.518189] 2 locks held by mysqld/1236:
[   90.518192]  #0:  (sb_writers#10){.+.+}, at: [<00000000eb213d33>]
aio_write+0x191/0x1a0
[   90.518216]  #1:  (&ei->dio_sem){++++}, at: [<000000000cdc761a>]
btrfs_direct_IO+0x395/0x410 [btrfs]
[   90.518278]
               stack backtrace:
[   90.518286] CPU: 1 PID: 1236 Comm: mysqld Not tainted
4.15.0-0.rc3.git1.1.fc28.x86_64 #1
[   90.518291] Hardware name: Sony Corporation VPCSB2M9E/VAIO, BIOS
R2087H4 06/15/2012
[   90.518295] Call Trace:
[   90.518307]  dump_stack+0x85/0xbf
[   90.518315]  print_circular_bug+0x1f5/0x2e0
[   90.518326]  ? copy_trace+0x80/0x80
[   90.518331]  check_prev_add+0x3da/0x780
[   90.518343]  ? __lock_acquire+0x11e9/0x1270
[   90.518349]  __lock_acquire+0x11e9/0x1270
[   90.518359]  lock_acquire+0x9f/0x1f0
[   90.518365]  ? get_user_pages_unlocked+0x5b/0x1b0
[   90.518375]  down_read+0x44/0xa0
[   90.518380]  ? get_user_pages_unlocked+0x5b/0x1b0
[   90.518386]  get_user_pages_unlocked+0x5b/0x1b0
[   90.518392]  ? mark_held_locks+0x4e/0x80
[   90.518400]  get_user_pages_fast+0xcf/0x140
[   90.518409]  iov_iter_get_pages+0xc5/0x2f0
[   90.518420]  do_blockdev_direct_IO+0x193c/0x2950
[   90.518426]  ? __lock_acquire+0x2c3/0x1270
[   90.518472]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   90.518516]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[   90.518565]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
[   90.518606]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   90.518651]  ? btrfs_direct_IO+0x166/0x410 [btrfs]
[   90.518691]  btrfs_direct_IO+0x166/0x410 [btrfs]
[   90.518732]  ? btrfs_endio_direct_read+0xb0/0xb0 [btrfs]
[   90.518744]  generic_file_direct_write+0x9d/0x160
[   90.518791]  btrfs_file_write_iter+0x300/0x650 [btrfs]
[   90.518804]  aio_write+0x116/0x1a0
[   90.518815]  ? __might_fault+0x3e/0x90
[   90.518825]  ? do_io_submit+0x42d/0x940
[   90.518831]  do_io_submit+0x42d/0x940
[   90.518847]  ? entry_SYSCALL_64_fastpath+0x1f/0x96
[   90.518854]  entry_SYSCALL_64_fastpath+0x1f/0x96
[   90.518860] RIP: 0033:0x7f445beeb687
[   90.518864] RSP: 002b:00007f443fe3a4a8 EFLAGS: 00000206 ORIG_RAX:
00000000000000d1
[   90.518872] RAX: ffffffffffffffda RBX: 00007f4447eec000 RCX: 00007f445beeb687
[   90.518876] RDX: 00007f443fe3a4b0 RSI: 0000000000000001 RDI: 00007f4454048000
[   90.518880] RBP: 00007f443fe3a830 R08: 00007f443fe3a4b0 R09: 0000000000000400
[   90.518885] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f44475c32f8
[   90.518889] R13: 000055a2bcf52028 R14: 00000018db0711f3 R15: 0000000000000001

kloczek
-- 
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
