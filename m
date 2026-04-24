Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7B2248A8
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 02:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776998137; cv=none; b=qqA88rMnQh9kLJlKG742Me1eje4s+FcLTKAnm9zS+hWLT7J3atg5cfuYGHIaaAkQLNuN9dfwHR6Twt1KUrcgJ1vLj1f6M7+ED0FZrPr7tkl44HXtytEZTE4HNfqqKDrONyf6TC01PTdH0n+Bb8xMfaXiJ5AR9OnqMQUD0MW+7O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776998137; c=relaxed/simple;
	bh=2EZvwEGcrt1tiwRLtcHMO0tM94itIV7GvCue78p0q08=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=k4RhMjb0sZdnGDQkTplxxH5xqBGDqVZtYGa1dEgu5q0EVOcYvGSguLHNY63lc4Lq5UYWX6/6PyzNfN9C7OWKkNbD4F14BoS2N8ytY6+tlCpyHYccn4yUonsY3OAJSeMBS6eMYzzGb3BHWo4FsUMOeiZZFwtld5dU2cYH+qciSpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7dcc79309d0so8015305a34.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 19:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776998135; x=1777602935;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/s6duOhe5iGwsgMoXyGArdKN1ztF9KS9kBveVk4qrQE=;
        b=E2HV18BltvsBB051uDrZ+MR2+SB8KGj8Q7hWCULuhS1Z5nNXOpDaUiVJLmjhS1O8iP
         dUD1ehCpZJv0EnoKYk9+wkEAChSETsj9J7pUQTmQC4g8ur5MQrvpxgMS4rU2esvkZeXA
         h0RzXT8G8RL1e6JXyZ3JMohoIXth94Sg5Y2S7qqXJ3nnm+L2vN3nzpzp3RsfVzPfM5F6
         AkQBdwaiYreOYKJC1Tj2UeuOEHxYqycr/VhWIOV3XMekPqkXWmLLW3hXm96x2yB9T2AL
         UvwVX1uCfnZKHXLiJ2tuPmc2PSybrHB3B0q25BMy0YtySNhBPtrPXTq9wzcJe3Z6tukv
         iGpg==
X-Forwarded-Encrypted: i=1; AFNElJ/dlpl0uQ07Cwb3PSfxwdTId/a6pApi65zWFPo88h+4e+LfhR5dS1AYi+zIX4b0obhvY6RyKSbqyD10GA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ZpS91TP0gowUlr0OFw1sDv+aFX4NdYtl/hfdBWOWkkm2oP2V
	GGAXsk+AqtmniFhSBTJh9AjcydPyA8KQsNDcvl1tjbR4eosjSkoG9RWmVfKMQhUrZ8Pnoexj/xI
	EhQEMqQUeGYpep4n7jChyiGekqQM9vuerPSGG/inusnXDJFvA5FMmXrzVK4c=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6186:b0:694:96b4:feb9 with SMTP id
 006d021491bc7-69496b4ffe9mr5747159eaf.33.1776998135150; Thu, 23 Apr 2026
 19:35:35 -0700 (PDT)
Date: Thu, 23 Apr 2026 19:35:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ead6f7.a00a0220.9259.002f.GAE@google.com>
Subject: [syzbot] [btrfs?] possible deadlock in btrfs_finish_one_ordered (3)
From: syzbot <syzbot+639b46ea64e2a7c2b93d@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c1f49dea2b8f Merge tag 'mm-hotfixes-stable-2026-04-19-00-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a7d4ce580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b4ac2aaea441e9b
dashboard link: https://syzkaller.appspot.com/bug?extid=639b46ea64e2a7c2b93d
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/305242213735/disk-c1f49dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1da8423852f9/vmlinux-c1f49dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d8bb8e7b4ae2/bzImage-c1f49dea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+639b46ea64e2a7c2b93d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
kworker/u8:12/27491 is trying to acquire lock:
ffff888077978600 (sb_internal#2){.+.+}-{0:0}, at: btrfs_finish_one_ordered+0x88e/0x2680 fs/btrfs/inode.c:3254

but task is already holding lock:
ffff88803966a758 (btrfs_ordered_extent){++++}-{0:0}, at: btrfs_finish_one_ordered+0x39c/0x2680 fs/btrfs/inode.c:3216

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (btrfs_ordered_extent){++++}-{0:0}:
       btrfs_start_ordered_extent_nowriteback+0x390/0x700 fs/btrfs/ordered-data.c:890
       btrfs_start_ordered_extent fs/btrfs/ordered-data.h:203 [inline]
       btrfs_wait_ordered_range+0x154/0x260 fs/btrfs/ordered-data.c:942
       btrfs_sync_file+0x78a/0x1200 fs/btrfs/file.c:1662
       generic_write_sync include/linux/fs.h:2654 [inline]
       btrfs_do_write_iter+0x6a3/0x840 fs/btrfs/file.c:1468
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x61d/0xb90 fs/read_write.c:688
       ksys_write+0x150/0x270 fs/read_write.c:740
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&ei->i_mmap_lock){++++}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1568
       btrfs_page_mkwrite+0x636/0x1a60 fs/btrfs/file.c:1918
       do_page_mkwrite+0x14d/0x310 mm/memory.c:3668
       wp_page_shared mm/memory.c:4069 [inline]
       do_wp_page+0x19ba/0x4cc0 mm/memory.c:4288
       handle_pte_fault mm/memory.c:6427 [inline]
       __handle_mm_fault mm/memory.c:6549 [inline]
       handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
       do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
       handle_page_fault arch/x86/mm/fault.c:1474 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618

-> #6 (sb_pagefaults#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_pagefault include/linux/fs/super.h:159 [inline]
       btrfs_page_mkwrite+0x351/0x1a60 fs/btrfs/file.c:1873
       do_page_mkwrite+0x14d/0x310 mm/memory.c:3668
       wp_page_shared mm/memory.c:4069 [inline]
       do_wp_page+0x19ba/0x4cc0 mm/memory.c:4288
       handle_pte_fault mm/memory.c:6427 [inline]
       __handle_mm_fault mm/memory.c:6549 [inline]
       handle_mm_fault+0x151d/0x3170 mm/memory.c:6718
       do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1385
       handle_page_fault arch/x86/mm/fault.c:1474 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
       _inline_copy_to_user include/linux/uaccess.h:206 [inline]
       _copy_to_user+0x85/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:236 [inline]
       do_pipe2+0xd4/0x190 fs/pipe.c:1040
       __do_sys_pipe fs/pipe.c:1061 [inline]
       __se_sys_pipe fs/pipe.c:1059 [inline]
       __x64_sys_pipe+0x3a/0x50 fs/pipe.c:1059
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&mm->mmap_lock){++++}-{4:4}:
       down_write_killable+0xa6/0x240 kernel/locking/rwsem.c:1637
       mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
       upgrade_mmap_lock_carefully+0xba/0x1b0 mm/mmap_lock.c:474
       lock_mm_and_find_vma+0x12b/0x340 mm/mmap_lock.c:527
       do_user_addr_fault+0x330/0x1340 arch/x86/mm/fault.c:1357
       handle_page_fault arch/x86/mm/fault.c:1474 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       filldir64+0x2b2/0x640 fs/readdir.c:368
       dir_emit include/linux/fs.h:3578 [inline]
       offset_dir_emit fs/libfs.c:499 [inline]
       offset_iterate_dir fs/libfs.c:515 [inline]
       offset_readdir+0x3fc/0x530 fs/libfs.c:564
       iterate_dir+0x399/0x570 fs/readdir.c:110
       __do_sys_getdents64 fs/readdir.c:399 [inline]
       __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&type->i_mutex_dir_key#5){++++}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1568
       inode_lock_shared include/linux/fs.h:1044 [inline]
       lookup_slow+0x46/0x70 fs/namei.c:1931
       walk_component fs/namei.c:2278 [inline]
       lookup_last fs/namei.c:2785 [inline]
       path_lookupat+0x3f5/0x8c0 fs/namei.c:2809
       filename_lookup+0x256/0x5d0 fs/namei.c:2838
       kern_path+0x3d/0x150 fs/namei.c:3044
       is_same_device fs/btrfs/volumes.c:764 [inline]
       device_list_add+0xfd1/0x2280 fs/btrfs/volumes.c:898
       btrfs_scan_one_device+0x3ef/0x680 fs/btrfs/volumes.c:1499
       btrfs_get_tree_super fs/btrfs/super.c:1858 [inline]
       btrfs_get_tree_subvol fs/btrfs/super.c:2087 [inline]
       btrfs_get_tree+0x4ab/0x1910 fs/btrfs/super.c:2121
       vfs_get_tree+0x92/0x2a0 fs/super.c:1754
       fc_mount fs/namespace.c:1193 [inline]
       do_new_mount_fc fs/namespace.c:3758 [inline]
       do_new_mount+0x341/0xd30 fs/namespace.c:3834
       do_mount fs/namespace.c:4167 [inline]
       __do_sys_mount fs/namespace.c:4383 [inline]
       __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&fs_devs->device_list_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:632 [inline]
       __mutex_lock+0x1a3/0x1550 kernel/locking/mutex.c:806
       insert_dev_extents fs/btrfs/block-group.c:2876 [inline]
       btrfs_create_pending_block_groups+0x77b/0x1b40 fs/btrfs/block-group.c:2927
       __btrfs_end_transaction+0x140/0x650 fs/btrfs/transaction.c:1091
       flush_space+0x406/0xe20 fs/btrfs/space-info.c:912
       do_async_reclaim_data_space+0x145/0x520 fs/btrfs/space-info.c:1448
       btrfs_async_reclaim_data_space+0x41/0x90 fs/btrfs/space-info.c:1512
       process_one_work kernel/workqueue.c:3302 [inline]
       process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
       worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (btrfs_trans_num_extwriters){++++}-{0:0}:
       join_transaction+0x192/0xe40 fs/btrfs/transaction.c:324
       start_transaction+0xbef/0x1820 fs/btrfs/transaction.c:719
       btrfs_dirty_inode+0x9f/0x190 fs/btrfs/inode.c:6441
       touch_atime+0x2f8/0x6b0 fs/inode.c:2265
       file_accessed include/linux/fs.h:2264 [inline]
       filemap_read+0x1053/0x1230 mm/filemap.c:2878
       __kernel_read+0x504/0x9b0 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x446/0x860 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x51d/0x9c0 security/integrity/ima/ima_api.c:300
       process_measurement+0x12cd/0x1c80 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4701 [inline]
       path_openat+0x2e4d/0x3860 fs/namei.c:4858
       do_file_open+0x23e/0x4a0 fs/namei.c:4887
       do_sys_openat2+0x113/0x200 fs/open.c:1364
       do_sys_open fs/open.c:1370 [inline]
       __do_sys_openat fs/open.c:1386 [inline]
       __se_sys_openat fs/open.c:1381 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1381
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (btrfs_trans_num_writers){++++}-{0:0}:
       join_transaction+0x171/0xe40 fs/btrfs/transaction.c:323
       start_transaction+0xbef/0x1820 fs/btrfs/transaction.c:719
       btrfs_dirty_inode+0x9f/0x190 fs/btrfs/inode.c:6441
       touch_atime+0x2f8/0x6b0 fs/inode.c:2265
       file_accessed include/linux/fs.h:2264 [inline]
       filemap_read+0x1053/0x1230 mm/filemap.c:2878
       __kernel_read+0x504/0x9b0 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x446/0x860 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x51d/0x9c0 security/integrity/ima/ima_api.c:300
       process_measurement+0x12cd/0x1c80 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4701 [inline]
       path_openat+0x2e4d/0x3860 fs/namei.c:4858
       do_file_open+0x23e/0x4a0 fs/namei.c:4887
       do_sys_openat2+0x113/0x200 fs/open.c:1364
       do_sys_open fs/open.c:1370 [inline]
       __do_sys_openat fs/open.c:1386 [inline]
       __se_sys_openat fs/open.c:1381 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1381
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       start_transaction+0xaa9/0x1820 fs/btrfs/transaction.c:713
       btrfs_finish_one_ordered+0x88e/0x2680 fs/btrfs/inode.c:3254
       btrfs_work_helper+0x37b/0xc20 fs/btrfs/async-thread.c:312
       process_one_work kernel/workqueue.c:3302 [inline]
       process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
       worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &ei->i_mmap_lock --> btrfs_ordered_extent

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(btrfs_ordered_extent);
                               lock(&ei->i_mmap_lock);
                               lock(btrfs_ordered_extent);
  rlock(sb_internal#2);

 *** DEADLOCK ***

3 locks held by kworker/u8:12/27491:
 #0: ffff88807c47f940 ((wq_completion)btrfs-endio-write){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3277 [inline]
 #0: ffff88807c47f940 ((wq_completion)btrfs-endio-write){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
 #1: ffffc90006627c40 ((work_completion)(&work->normal_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3278 [inline]
 #1: ffffc90006627c40 ((work_completion)(&work->normal_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
 #2: ffff88803966a758 (btrfs_ordered_extent){++++}-{0:0}, at: btrfs_finish_one_ordered+0x39c/0x2680 fs/btrfs/inode.c:3216

stack backtrace:
CPU: 1 UID: 0 PID: 27491 Comm: kworker/u8:12 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Workqueue: btrfs-endio-write btrfs_work_helper
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 start_transaction+0xaa9/0x1820 fs/btrfs/transaction.c:713
 btrfs_finish_one_ordered+0x88e/0x2680 fs/btrfs/inode.c:3254
 btrfs_work_helper+0x37b/0xc20 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
