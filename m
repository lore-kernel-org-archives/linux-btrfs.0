Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:46370 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933977AbeFWBoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 21:44:24 -0400
MIME-Version: 1.0
From: shankarapailoor <shankarapailoor@gmail.com>
Date: Fri, 22 Jun 2018 18:44:22 -0700
Message-ID: <CAB+yDaa3OycpeiEbFEGCOMoCmNoXH2By8aC87HCNaDL+O6SDJA@mail.gmail.com>
Subject: Task Hung in btrfs_start_ordered_extent
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using Syzkaller to fuzz linux 4.18.0-rc1 with btrfs and I found
the following task hung bug. This is reproducible and I have a C
program to reproduce the bug here: https://pastebin.com/dMfR6yZx

Syzkaller hit 'INFO: task hung in btrfs_start_ordered_extent' bug.

random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
random: sshd: uninitialized urandom read (32 bytes read)
INFO: task syz-executor329:3499 blocked for more than 120 seconds.
      Not tainted 4.18.0-rc1+ #35
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor329 D23328  3499   3498 0x00000000
Call Trace:
 context_switch kernel/sched/core.c:2862 [inline]
 __schedule+0x8cd/0x1d20 kernel/sched/core.c:3504
 schedule+0x7c/0x1a0 kernel/sched/core.c:3548
 btrfs_start_ordered_extent+0x366/0x510 fs/btrfs/ordered-data.c:784
 __do_contiguous_readpages fs/btrfs/extent_io.c:3113 [inline]
 __extent_readpages+0x1c3/0x6b0 fs/btrfs/extent_io.c:3158
 extent_readpages+0x1f5/0x6d0 fs/btrfs/extent_io.c:4153
 btrfs_readpages+0x25/0x30 fs/btrfs/inode.c:8724
 read_pages+0x10d/0x500 mm/readahead.c:121
 __do_page_cache_readahead+0x4ab/0x590 mm/readahead.c:209
 ra_submit mm/internal.h:66 [inline]
 do_sync_mmap_readahead mm/filemap.c:2444 [inline]
 filemap_fault+0x939/0x1b20 mm/filemap.c:2520
 __do_fault+0x84/0x1a0 mm/memory.c:3231
 do_read_fault mm/memory.c:3641 [inline]
 do_fault mm/memory.c:3741 [inline]
 handle_pte_fault mm/memory.c:3972 [inline]
 __handle_mm_fault+0x1931/0x2b40 mm/memory.c:4096
 handle_mm_fault+0x3a4/0xa10 mm/memory.c:4133
 faultin_page mm/gup.c:518 [inline]
 __get_user_pages+0x3dc/0x11f0 mm/gup.c:718
 __get_user_pages_locked mm/gup.c:889 [inline]
 get_user_pages_unlocked+0x25a/0x390 mm/gup.c:1012
 get_user_pages_fast+0x163/0x310 mm/gup.c:1865
 iov_iter_get_pages+0x235/0xd70 lib/iov_iter.c:1129
 dio_refill_pages fs/direct-io.c:170 [inline]
 dio_get_page fs/direct-io.c:214 [inline]
 do_direct_IO fs/direct-io.c:980 [inline]
 do_blockdev_direct_IO+0x33c2/0x7800 fs/direct-io.c:1331
 __blockdev_direct_IO+0x9d/0xc6 fs/direct-io.c:1417
 btrfs_direct_IO+0x3c6/0xbf0 fs/btrfs/inode.c:8629
 generic_file_direct_write+0x1e6/0x440 mm/filemap.c:3042
 __btrfs_direct_write fs/btrfs/file.c:1813 [inline]
 btrfs_file_write_iter+0x770/0x166a fs/btrfs/file.c:1954
 call_write_iter include/linux/fs.h:1795 [inline]
 new_sync_write fs/read_write.c:474 [inline]
 __vfs_write+0x4e8/0x660 fs/read_write.c:487
 vfs_write+0x189/0x510 fs/read_write.c:549
 ksys_write+0xd8/0x1b0 fs/read_write.c:598
 __do_sys_write fs/read_write.c:610 [inline]
 __se_sys_write fs/read_write.c:607 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:607
 do_syscall_64+0xda/0x560 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440799
Code: Bad RIP value.
RSP: 002b:00007ffdf3c66738 EFLAGS: 00000217 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000440799
RDX: 00000000d996d7aa RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000004000 R09: 0000000000004000
R10: 0000000000000004 R11: 0000000000000217 R12: 0000000000401c20
R13: 0000000000401cb0 R14: 0000000000000000 R15: 0000000000000000

My kernel configs: https://pastebin.com/KFcaLxhj

Please let me know if I can provide more information

-- 
Regards,
Shankara Pailoor
