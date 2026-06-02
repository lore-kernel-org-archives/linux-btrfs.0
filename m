Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16A3B995E
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780399595; cv=none; b=FHNTGtrk3V4PFybvjePiKX8KFnsXS3ARCh/wAg2IyOCAXpZ0XERV5DnVv3GElgZ5zC+PCRHlVT2sFvYLRAdlMxmWbAv43kr1A6eBItXtIWPeaUTjXKoIz8GJK3tiHh6Ht7mi+/BMqVqe7Td1R632caYJwxBIT+Jeke/HBZqIWXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780399595; c=relaxed/simple;
	bh=5pE2Ymouaba+O3IzfKfpW1hoW3ltOn6AdEhvqYKrngs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qgGVuhvrsWMuxmp38QcaT9BzuHZODVXTsRR5ydooE81iiK2WHz20d19SdUH+Ics4KjLdcbC3Wd4ax9YgrSD5g79Gj3m6i1jLjyxUeNQLpyFn4w5ut5aUL63w593C0cIoiYvXd4Cbd94+qq0MXxTCZ9djRSXpHFZjxp/cukHNVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7e6dd5840c1so325659a34.2
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 04:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780399593; x=1781004393;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1URkFmoixrENPbmnI3c55CBJCtYc95AQ8UntyUkCRg=;
        b=qHTa4cwncIkP89xKNMAU3GbdIeC+Iq6aJMHfWfNSvCdgXyPGEwmkF+K/UjBnrrFjDa
         rXu78hgSJpy2qMw3wAhaXDTBbYBay3xEO+GGreCbNNhdv90e5PNlCKc+xLt2e9qio4+6
         OZC0Ia1JMBA9HM73NySxGurxyMMSzlm1OQO3ft2lkZySOBLudogz50KtwmtYe5jjui3D
         W8lLK3qecfO28VpfCfdDNNWEoa3Q3NAbNfhMA9r6r8x57oxVvMZkO8bpFSX0JqLwfsx8
         O9CLV7epfZ1OOpm4gksviBpLuh0wNuTD2pX31fb9XHqhf5rcNkBXE/Hcyuaax3FVJwzT
         JNDQ==
X-Forwarded-Encrypted: i=1; AFNElJ/gQkQk4uEXKjlpKaH1uWeJUThcF7LSfCx9/SxrjE2rqNothKO/N1Uy099QkZrmyOf+Kdhyt8OSsAB5fg==@vger.kernel.org
X-Gm-Message-State: AOJu0YySXLTGMKKtbFTA0z93X18SnWIPkSlWJnSIIFFVkdRzIbzvk1mO
	EZjjF/WYrbXm4x7nKzKsS5ypmLbL11tkXYW2rYhcQv21UQZqdUPRaaA/cev6W0bbxebD0LfvDMQ
	aNYIkUYzUevJD4gYDRk+JxUWrJREL416lNtUHtAckFDlBnJAFqedsQGV5mSk=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee08:0:b0:69e:35a5:136e with SMTP id
 006d021491bc7-69e35a51bb7mr2468662eaf.24.1780399593012; Tue, 02 Jun 2026
 04:26:33 -0700 (PDT)
Date: Tue, 02 Jun 2026 04:26:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1ebde9.c1435f33.112120.0176.GAE@google.com>
Subject: [syzbot] [btrfs?] KASAN: slab-use-after-free Write in btrfs_put_root
From: syzbot <syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f5e5d3509bff Merge tag 'spi-fix-v7.1-rc5' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11e71673980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=b3d472d13f9d7bf20669
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f5e5d350.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0def87a3e804/vmlinux-f5e5d350.xz
kernel image: https://storage.googleapis.com/syzbot-assets/88c9dae4373a/bzImage-f5e5d350.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com

BTRFS info (device loop0 state EA): last unmount of filesystem 3a375e4e-b156-4d76-a2ad-16e198ce1409
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
BUG: KASAN: slab-use-after-free in atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400 [inline]
BUG: KASAN: slab-use-after-free in __refcount_sub_and_test include/linux/refcount.h:389 [inline]
BUG: KASAN: slab-use-after-free in __refcount_dec_and_test include/linux/refcount.h:432 [inline]
BUG: KASAN: slab-use-after-free in refcount_dec_and_test include/linux/refcount.h:450 [inline]
BUG: KASAN: slab-use-after-free in btrfs_put_root+0x2f/0x250 fs/btrfs/disk-io.c:1806
Write of size 4 at addr ffff88803f978630 by task syz.0.0/5338

CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
 atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400 [inline]
 __refcount_sub_and_test include/linux/refcount.h:389 [inline]
 __refcount_dec_and_test include/linux/refcount.h:432 [inline]
 refcount_dec_and_test include/linux/refcount.h:450 [inline]
 btrfs_put_root+0x2f/0x250 fs/btrfs/disk-io.c:1806
 btrfs_drop_and_free_fs_root+0x160/0x210 fs/btrfs/disk-io.c:4154
 btrfs_free_fs_roots+0x2f9/0x3c0 fs/btrfs/disk-io.c:1847
 close_ctree+0x798/0x12d0 fs/btrfs/disk-io.c:4442
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:646
 kill_anon_super+0x3b/0x70 fs/super.c:1292
 btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2127
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x70f/0x22c0 kernel/exit.c:976
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 __do_sys_exit_group kernel/exit.c:1130 [inline]
 __se_sys_exit_group kernel/exit.c:1128 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1128
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f958ef9ce59
Code: Unable to access opcode bytes at 0x7f958ef9ce2f.
RSP: 002b:00007fffd4058318 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f958ef9ce59
RDX: 00007f958c3f8000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f958f1e73e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f958f1e73e0 R14: 0000000000000003 R15: 00007fffd40583d0
 </TASK>

Allocated by task 1061:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5420
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 btrfs_alloc_root+0x75/0x930 fs/btrfs/disk-io.c:611
 read_tree_root_path+0x127/0xb00 fs/btrfs/disk-io.c:976
 btrfs_read_tree_root+0x34/0x60 fs/btrfs/disk-io.c:1040
 create_reloc_root+0x6b3/0xcb0 fs/btrfs/relocation.c:677
 btrfs_init_reloc_root+0x2ec/0x4b0 fs/btrfs/relocation.c:744
 record_root_in_trans+0x2ab/0x350 fs/btrfs/transaction.c:461
 btrfs_record_root_in_trans+0x15c/0x180 fs/btrfs/transaction.c:507
 start_transaction+0x39c/0x1820 fs/btrfs/transaction.c:793
 btrfs_finish_one_ordered+0x88e/0x2680 fs/btrfs/inode.c:3254
 btrfs_work_helper+0x37b/0xc20 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 5339:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free mm/slub.c:6251 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6566
 __del_reloc_root+0x341/0x3b0 fs/btrfs/relocation.c:547
 free_reloc_roots+0x5f/0x90 fs/btrfs/relocation.c:1803
 merge_reloc_roots+0x73f/0x8a0 fs/btrfs/relocation.c:1888
 relocate_block_group+0xbcc/0xe70 fs/btrfs/relocation.c:3638
 do_nonremap_reloc+0xa8/0x5b0 fs/btrfs/relocation.c:5268
 btrfs_relocate_block_group+0x7e6/0xc40 fs/btrfs/relocation.c:5434
 btrfs_relocate_chunk+0x115/0x820 fs/btrfs/volumes.c:3598
 __btrfs_balance+0x1db0/0x2ae0 fs/btrfs/volumes.c:4509
 btrfs_balance+0xaf3/0x11b0 fs/btrfs/volumes.c:4896
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88803f978000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1584 bytes inside of
 freed 4096-byte region [ffff88803f978000, ffff88803f979000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3f978
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
head: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
head: 04fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 24, tgid 24 (kworker/u4:2), ts 105728970387, free_ts 29540875453
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x2593/0x2610 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3467
 new_slab mm/slub.c:3525 [inline]
 refill_objects+0x339/0x3d0 mm/slub.c:7272
 refill_sheaf mm/slub.c:2816 [inline]
 __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4652
 alloc_from_pcs mm/slub.c:4750 [inline]
 slab_alloc_node mm/slub.c:4884 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kmalloc_node_track_caller_noprof+0x572/0x7b0 mm/slub.c:5408
 kmalloc_reserve net/core/skbuff.c:635 [inline]
 __alloc_skb+0x2c1/0x7d0 net/core/skbuff.c:713
 alloc_skb include/linux/skbuff.h:1385 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:819 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:876 [inline]
 nsim_dev_trap_report_work+0x29a/0xb90 drivers/net/netdevsim/dev.c:922
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page last free pid 77 tgid 77 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 __free_frozen_pages+0xc1c/0xd30 mm/page_alloc.c:2938
 vfree+0x1d1/0x2f0 mm/vmalloc.c:3472
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3392
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88803f978500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803f978580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88803f978600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88803f978680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803f978700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
