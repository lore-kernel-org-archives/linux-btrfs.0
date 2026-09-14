Received: from mail-oo2-f5.google.com (mail-oo2-f5.google.com [74.125.231.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148583B42F7
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415246; cv=none; b=ZoVy5BCaNIOq6HibxtQgS/irPeLVmbBBeqgJ68DG9JMVpM/kIMo3ufcy1WVybcy9KZAxzlny9XGpmqG8bA1qaGgidpPcLqV03y7ImlS1GsHNn8vBP6DCjImEVjn+Y0Lzxb4w/iKe7x4mvx74XGcuLJfdswfSyZohGx4eUQie9MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415246; c=relaxed/simple;
	bh=Z6drefBUvFbnQmX2o4EOjIxhx7XOWpI+5JoPTRwW4VM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RG3CQjWz1ScG8a3YpAyIqcS2aUuVoJpg4VUbKI+91a95UldTEwNeTpvugVJh5Fwu1godrBLfKtyfNwkGQfLOl6Q8q9U6P1AduSLZaWIYi0HnKqgMXGa/CFgXicQnZyZS3ykhUbOiPYD2i7cmV0q4E6awaNhpfE4VfuO6JgfY8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f5.google.com with SMTP id 006d021491bc7-6c184d8081eso246849eaf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 12:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789415243; x=1790020043;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pgid3c+Yl5L6oK+pTmWJ/RX2dX2USQQ9hMG96Fe/xE4=;
        b=jdQjKqeSDp5ettrMCfopCf5Nm/SHrj/eMZgdChb4/d7tELxN0YDDl1bCYqxHQNw9By
         KIFa+hnjnq2oWF37VH61UV2dAVr4MO0YoU+BmuDTP7vxKcMHek/6iZP266YR/CFMw2SX
         LXFzhG9XWl+ALc4s4vT29ZUkqk8qKiEyWFu6W9iEgfhqzYJ4BBXSjnsfEvQ0HQ6FOvKT
         nml/EEPt/u5/SkslaKSF5S/k9zf9FWqEpRly+d1Zo5IHBzqxg+H5dM14tWmdBHBXOOFk
         xJ06KpeUT1efcIoGpJnDdWf0oQIqz83DxDU31wawFtek24UE5csXU77U+nD2rgeofgz2
         dNKA==
X-Forwarded-Encrypted: i=1; AKwUvBwgEqhR2LONR2n4wnEouYpnV57lEbvv13Pit9Fp2kwoye7blcMhbJd8nZkRBtmMHOFCzdt/poA80yO46Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kwWmqHaJwk+r+i70pOANrFWGTKVWVy3tJ7PDBGyZc47I2cFwVA
	r6v67NlHg4G5ws8QJaW4I1kqxF3ATUMuwM9+3KgwF5DtKoOLbddZjidWmGJ7hIbS4wENTCC05js
	pDIOmwF7I3k6RPwT+0JK6kyRc5yz5dXxGwSDl1aATjSy4sicKHKJoGTb2WjY=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8c6:b0:6b3:5c73:2188 with SMTP id
 006d021491bc7-6c53f2524d4mr2299376eaf.5.1789415242996; Mon, 14 Sep 2026
 12:47:22 -0700 (PDT)
Date: Mon, 14 Sep 2026 12:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa84f4a.a211d2ce.1a5198.029a.GAE@google.com>
Subject: [syzbot] [btrfs?] possible deadlock in join_transaction (4)
From: syzbot <syzbot+e394e20544a6531e8243@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    50d05c7c76c9 Merge tag 'landlock-7.3-rc3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e7c1f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=e394e20544a6531e8243
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/806434f9f24c/disk-50d05c7c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/742427c076bd/vmlinux-50d05c7c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/53ca26203b1a/bzImage-50d05c7c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e394e20544a6531e8243@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
kworker/u8:5/62 is trying to acquire lock:
ffff8880504d2680 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x6b2/0xd40 fs/btrfs/transaction.c:299

but task is already holding lock:
ffff888022714650 (sb_internal#3){.+.+}-{0:0}, at: flush_space+0x2f6/0xde0 fs/btrfs/space-info.c:903

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (sb_internal#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       start_transaction+0x575/0x17d0 fs/btrfs/transaction.c:723
       btrfs_dirty_inode+0x9f/0x190 fs/btrfs/inode.c:6449
       touch_atime+0x2f8/0x670 fs/inode.c:2326
       file_accessed include/linux/fs.h:2277 [inline]
       btrfs_file_mmap_prepare+0x172/0x1f0 fs/btrfs/file.c:2003
       vfs_mmap_prepare include/linux/fs.h:2069 [inline]
       call_mmap_prepare mm/vma.c:2776 [inline]
       __mmap_region mm/vma.c:2863 [inline]
       mmap_region+0xe8a/0x2240 mm/vma.c:2964
       do_mmap+0xe0a/0x1300 mm/mmap.c:573
       vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
       ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&mm->mmap_lock){++++}-{4:4}:
       down_read_killable+0x50/0x3b0 kernel/locking/rwsem.c:1599
       mmap_read_lock_killable+0x1d/0x70 include/linux/mmap_lock.h:609
       get_mmap_lock_carefully mm/mmap_lock.c:450 [inline]
       lock_mm_and_find_vma+0x2d6/0x340 mm/mmap_lock.c:501
       do_user_addr_fault+0x343/0x1340 arch/x86/mm/fault.c:1366
       handle_page_fault arch/x86/mm/fault.c:1483 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
       filldir+0x2bd/0x630 fs/readdir.c:-1
       dir_emit include/linux/fs.h:3607 [inline]
       kernfs_fop_readdir+0x580/0x960 fs/kernfs/dir.c:1999
       iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
       __do_sys_getdents fs/readdir.c:319 [inline]
       __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&root->kernfs_rwsem){++++}-{4:4}:
       down_write+0x96/0x200 kernel/locking/rwsem.c:1631
       kernfs_add_one+0x41/0x6f0 fs/kernfs/dir.c:825
       kernfs_create_dir_ns+0x1a1/0x230 fs/kernfs/dir.c:1130
       sysfs_create_dir_ns+0x12f/0x2a0 fs/sysfs/dir.c:59
       create_dir lib/kobject.c:73 [inline]
       kobject_add_internal+0x622/0xcd0 lib/kobject.c:240
       kobject_add_varg lib/kobject.c:374 [inline]
       kobject_init_and_add+0x12b/0x1a0 lib/kobject.c:457
       btrfs_sysfs_add_qgroups+0x118/0x2f0 fs/btrfs/sysfs.c:2604
       btrfs_quota_enable+0x274/0x1e20 fs/btrfs/qgroup.c:1032
       btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&fs_info->qgroup_ioctl_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       btrfs_quota_enable+0x2b1/0x1e20 fs/btrfs/qgroup.c:1061
       btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (btrfs_trans_num_extwriters){++++}-{0:0}:
       join_transaction+0x18a/0xd40 fs/btrfs/transaction.c:324
       start_transaction+0x6ed/0x17d0 fs/btrfs/transaction.c:729
       __cow_file_range_inline+0x161/0x1000 fs/btrfs/inode.c:625
       run_delalloc_inline fs/btrfs/inode.c:2358 [inline]
       btrfs_run_delalloc_range+0x1796/0x1fd0 fs/btrfs/inode.c:2419
       writepage_delalloc+0x10a4/0x1c60 fs/btrfs/extent_io.c:1710
       extent_writepage fs/btrfs/extent_io.c:2090 [inline]
       extent_write_cache_pages fs/btrfs/extent_io.c:2843 [inline]
       btrfs_writepages+0x1625/0x28c0 fs/btrfs/extent_io.c:2975
       do_writepages+0x338/0x560 mm/page-writeback.c:2560
       filemap_writeback mm/filemap.c:387 [inline]
       filemap_fdatawrite_range+0x1ef/0x2f0 mm/filemap.c:412
       btrfs_fdatawrite_range+0x54/0xf0 fs/btrfs/file.c:3858
       btrfs_direct_write+0x5cd/0xce0 fs/btrfs/direct-io.c:1046
       btrfs_do_write_iter+0x325/0x790 fs/btrfs/file.c:1427
       iter_file_splice_write+0xa31/0x1240 fs/splice.c:736
       do_splice_from fs/splice.c:936 [inline]
       direct_splice_actor+0x101/0x160 fs/splice.c:1159
       splice_direct_to_actor+0x57b/0xcb0 fs/splice.c:1103
       do_splice_direct_actor fs/splice.c:1202 [inline]
       do_splice_direct+0x195/0x290 fs/splice.c:1228
       do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
       __do_sys_sendfile64 fs/read_write.c:1432 [inline]
       __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (btrfs_trans_num_writers){++++}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       join_transaction+0x6cf/0xd40 fs/btrfs/transaction.c:299
       start_transaction+0x6ed/0x17d0 fs/btrfs/transaction.c:729
       flush_space+0x2f6/0xde0 fs/btrfs/space-info.c:903
       do_async_reclaim_data_space+0x137/0x550 fs/btrfs/space-info.c:1455
       btrfs_async_reclaim_data_space+0x41/0x90 fs/btrfs/space-info.c:1519
       process_one_work kernel/workqueue.c:3396 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  btrfs_trans_num_writers --> &mm->mmap_lock --> sb_internal#3

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_internal#3);
                               lock(&mm->mmap_lock);
                               lock(sb_internal#3);
  rlock(btrfs_trans_num_writers);

 *** DEADLOCK ***

locks held by kworker/u8:5/62: 3, last CPU#0:
 #0: ffff88801b0a4140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff88801b0a4140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff88801b0a4140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #0: ffff88801b0a4140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #1: ffffc9000203fc40 ((work_completion)(&fs_info->async_data_reclaim_work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc9000203fc40 ((work_completion)(&fs_info->async_data_reclaim_work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc9000203fc40 ((work_completion)(&fs_info->async_data_reclaim_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
 #1: ffffc9000203fc40 ((work_completion)(&fs_info->async_data_reclaim_work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
 #2: ffff888022714650 (sb_internal#3){.+.+}-{0:0}, at: flush_space+0x2f6/0xde0 fs/btrfs/space-info.c:903

stack backtrace:
CPU: 0 UID: 0 PID: 62 Comm: kworker/u8:5 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Workqueue: events_unbound btrfs_async_reclaim_data_space
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 join_transaction+0x6cf/0xd40 fs/btrfs/transaction.c:299
 start_transaction+0x6ed/0x17d0 fs/btrfs/transaction.c:729
 flush_space+0x2f6/0xde0 fs/btrfs/space-info.c:903
 do_async_reclaim_data_space+0x137/0x550 fs/btrfs/space-info.c:1455
 btrfs_async_reclaim_data_space+0x41/0x90 fs/btrfs/space-info.c:1519
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
netdevsim netdevsim3 eth22: set [0, 0] type 1 family 0 port 8472 - 0
netdevsim netdevsim3 eth22: set [1, 0] type 2 family 0 port 20002 - 0
netdevsim netdevsim3 eth23: set [0, 0] type 1 family 0 port 8472 - 0
netdevsim netdevsim3 eth23: set [1, 0] type 2 family 0 port 20002 - 0
netdevsim netdevsim3 eth21: set [0, 0] type 1 family 0 port 8472 - 0
netdevsim netdevsim3 eth21: set [1, 0] type 2 family 0 port 20002 - 0
netdevsim netdevsim3 eth24: set [0, 0] type 1 family 0 port 8472 - 0
netdevsim netdevsim3 eth24: set [1, 0] type 2 family 0 port 20002 - 0


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
