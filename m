Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754FB2D9ED1
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 02:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779763724; cv=none; b=gVa4aPx47fQ7/BX45C6/kCQ07wB/EXvb/veAnwcrf6M01FFmwzgWNhIUP9lUuY/2WcmQERIEfRq5J2lSwZxyOHfj1IeKjCZdBsXT/jod2/EMZWvBR2MyPi46n/FXW4eS0OuHOjHA3xijUlpMPZsct+2iBSgGl7xho5O1fyafI3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779763724; c=relaxed/simple;
	bh=dDAgRjrSX0+xlTWFkOf11bTv23Jr1pOeKrvCdKvJBv4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pF82tLhROU01olBGrKQGVS9w1i8iu5UzkcBTNWHlxb+0KMbIWY/wBUxXMWvE+BIac/NQDlJ51sdH/t9cXEjSXTPYWm9Fo/1WJQ61+VljnGyUfPA/1+Vb/4VkT38OlgyLa7cZmOSiJLC1Po2ZQRJyrI/83lJW9iI134G+0jQtx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-69d874805edso4758276eaf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 19:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779763721; x=1780368521;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97oYBg5wuNU/byPfcdp0CKDYhf/5GQtqqfFL2NYxkts=;
        b=TGMi8UzWOKMAb0vX2Q8BB6lk7joSU1UgnQ+iywY5NX/745LLJBahhz+DDy56qFKUmJ
         M7Qo9ND1hPbLO1QK/VJl9RI5ZlezfsHPGrjMH1yOYScmTHqoEqmRiYEC/GRe9CYNgN4P
         eAc3KmV80cWPJ0pcK0i7Kqu1tyBmCPKlLO2bQ31rQnJtL6mRGa7Sxf7VOE/46YIuZsB5
         gRTWRhnu6D27ABjRLHkdhnwdDg8K/PFqavDxpJHGghTTJ2Eu3IuaWfsyx4MhVaSy0ZgN
         dy49BEc47TdPbJ/bH0SnJIUWvpVhvYiZB8MnEAKpHnIshlGYhyNSkmBOypo3xXgz8G2f
         2wOg==
X-Forwarded-Encrypted: i=1; AFNElJ8V8Swk3saEEF3BtbnDhJkDHza8TH7huj3tRTcFd3JRWkPjPhF8bPB5f/YnaMIiYNSyJN0/jkpofvwn8w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8VY4tiijrwv+MfjAKA1+TKy1NXe3VZemo86UAayDGgyqV4lci
	yE++9TBweIZ0DmHXlNSf7kq7iTG6Mao9sKX+gnj5HHEZUzu2wcAGbs8i1ZHkB9JIuTiwrhVa8IC
	1MferVoTZOy6DallM8O8OIUtRVdDqnvAK27zaSMdGP6QnkuRtFwn26cL3fpQ=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2004:b0:699:a77e:8783 with SMTP id
 006d021491bc7-69d7ec97a5amr7670595eaf.47.1779763721408; Mon, 25 May 2026
 19:48:41 -0700 (PDT)
Date: Mon, 25 May 2026 19:48:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a150a09.820a0220.e7972.0006.GAE@google.com>
Subject: [syzbot] [btrfs?] INFO: task hung in btrfs_invalidate_folio (4)
From: syzbot <syzbot+c7443384724bb0f9e913@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c1ecb239fa34 Add linux-next specific files for 20260522
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13a2f07a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0299bf0261ddd5
dashboard link: https://syzkaller.appspot.com/bug?extid=c7443384724bb0f9e913
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cced96580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ad22a6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b8845b668755/disk-c1ecb239.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/517b638d908a/vmlinux-c1ecb239.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd5e3b587fce/bzImage-c1ecb239.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1d1205e36e59/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1585acec580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c7443384724bb0f9e913@syzkaller.appspotmail.com

INFO: task kworker/u8:3:57 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:3    state:D stack:21600 pid:57    tgid:57    ppid:2      task_flags:0x4208160 flags:0x00080000
Workqueue: writeback wb_workfn (flush-btrfs-129)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5402 [inline]
 __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
 __schedule_loop kernel/sched/core.c:7283 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7298
 wait_extent_bit fs/btrfs/extent-io-tree.c:905 [inline]
 btrfs_lock_extent_bits+0x59c/0x700 fs/btrfs/extent-io-tree.c:2008
 btrfs_lock_extent fs/btrfs/extent-io-tree.h:152 [inline]
 btrfs_invalidate_folio+0x440/0xc00 fs/btrfs/inode.c:7718
 extent_writepage fs/btrfs/extent_io.c:1848 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2552 [inline]
 btrfs_writepages+0x12f3/0x2410 fs/btrfs/extent_io.c:2684
 do_writepages+0x32e/0x550 mm/page-writeback.c:2571
 __writeback_single_inode+0x133/0x10e0 fs/fs-writeback.c:1764
 writeback_sb_inodes+0x97f/0x1980 fs/fs-writeback.c:2056
 wb_writeback+0x445/0xb00 fs/fs-writeback.c:2241
 wb_do_writeback fs/fs-writeback.c:2388 [inline]
 wb_workfn+0x3fd/0xf20 fs/fs-writeback.c:2428
 process_one_work+0x98b/0x1630 kernel/workqueue.c:3318
 process_scheduled_works kernel/workqueue.c:3401 [inline]
 worker_thread+0xb49/0x1140 kernel/workqueue.c:3482
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz.0.145:8523 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.145       state:D stack:22752 pid:8523  tgid:8522  ppid:5850   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5402 [inline]
 __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
 __schedule_loop kernel/sched/core.c:7283 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7298
 wb_wait_for_completion+0x3e8/0x790 fs/fs-writeback.c:227
 __writeback_inodes_sb_nr+0x24c/0x2d0 fs/fs-writeback.c:2847
 try_to_writeback_inodes_sb+0x9a/0xc0 fs/fs-writeback.c:2895
 btrfs_start_delalloc_flush fs/btrfs/transaction.c:2182 [inline]
 btrfs_commit_transaction+0x813/0x2fc0 fs/btrfs/transaction.c:2371
 btrfs_sync_file+0xdf4/0x1230 fs/btrfs/file.c:1822
 generic_write_sync include/linux/fs.h:2663 [inline]
 btrfs_do_write_iter+0x6a9/0x840 fs/btrfs/file.c:1473
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x629/0xba0 fs/read_write.c:688
 ksys_write+0x156/0x270 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a0bdece59
RSP: 002b:00007f5a0b446028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f5a0c065fa0 RCX: 00007f5a0bdece59
RDX: 000000000000029f RSI: 0000200000000200 RDI: 0000000000000004
RBP: 00007f5a0be82d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5a0c066038 R14: 00007f5a0c065fa0 R15: 00007ffe149206b8
 </TASK>
INFO: task syz.0.145:8539 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.145       state:D stack:23704 pid:8539  tgid:8522  ppid:5850   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5402 [inline]
 __schedule+0x16f9/0x5500 kernel/sched/core.c:7204
 __schedule_loop kernel/sched/core.c:7283 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7298
 wait_current_trans+0x39f/0x590 fs/btrfs/transaction.c:536
 start_transaction+0xbd8/0x1820 fs/btrfs/transaction.c:716
 clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 btrfs_clone+0x1316/0x2540 fs/btrfs/reflink.c:574
 btrfs_clone_files+0x271/0x3f0 fs/btrfs/reflink.c:795
 btrfs_remap_file_range+0x76b/0x1320 fs/btrfs/reflink.c:948
 vfs_clone_file_range+0x435/0x7b0 fs/remap_range.c:403
 ioctl_file_clone fs/ioctl.c:239 [inline]
 ioctl_file_clone_range fs/ioctl.c:257 [inline]
 do_vfs_ioctl+0xe15/0x1540 fs/ioctl.c:544
 __do_sys_ioctl fs/ioctl.c:595 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a0bdece59
RSP: 002b:00007f5a0b425028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5a0c066090 RCX: 00007f5a0bdece59
RDX: 00002000000000c0 RSI: 000000004020940d RDI: 0000000000000004
RBP: 00007f5a0be82d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5a0c066128 R14: 00007f5a0c066090 R15: 00007ffe149206b8
 </TASK>

Showing all locks held in the system:
4 locks held by pr/legacy/17:
 #0: ffffffff8dfbce40 (console_lock){+.+.}-{0:0}, at: legacy_kthread_func+0x1a3/0x250 kernel/printk/printk.c:3711
 #1: ffffffff8dea4738 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:305 [inline]
 #1: ffffffff8dea4738 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:428 [inline]
 #1: ffffffff8dea4738 (console_srcu){....}-{0:0}, at: console_srcu_read_lock kernel/printk/printk.c:291 [inline]
 #1: ffffffff8dea4738 (console_srcu){....}-{0:0}, at: console_flush_one_record+0xfa/0xb90 kernel/printk/printk.c:3246
 #2: ffffffff99ba1f78 (&port_lock_key){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #2: ffffffff99ba1f78 (&port_lock_key){+.+.}-{3:3}, at: uart_port_lock_irqsave include/linux/serial_core.h:719 [inline]
 #2: ffffffff99ba1f78 (&port_lock_key){+.+.}-{3:3}, at: serial8250_console_write+0x179/0x1b90 drivers/tty/serial/8250/8250_port.c:3321
 #3: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #3: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #3: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: __rt_spin_lock kernel/locking/spinlock_rt.c:50 [inline]
 #3: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1e0/0x400 kernel/locking/spinlock_rt.c:57
1 lock held by khungtaskd/38:
 #0: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6777
2 locks held by kworker/u8:3/57:
 #0: ffff88801b6b3938 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x897/0x1630 kernel/workqueue.c:3293
 #1: ffffc9000123fc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8be/0x1630 kernel/workqueue.c:3294
2 locks held by getty/5375:
 #0: ffff8880360c50a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003cbe2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x462/0x13a0 drivers/tty/n_tty.c:2211
2 locks held by kworker/u8:5/5860:
 #0: ffff88801b6b3938 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x897/0x1630 kernel/workqueue.c:3293
 #1: ffffc90003937c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8be/0x1630 kernel/workqueue.c:3294
6 locks held by syz.0.145/8523:
 #0: ffff88803720ef28 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x252/0x320 fs/file.c:1260
 #1: ffff88802b4ca480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2733 [inline]
 #1: ffff88802b4ca480 (sb_writers#12){.+.+}-{0:0}, at: vfs_write+0x22d/0xba0 fs/read_write.c:684
 #2: ffff88802b4ca770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_sync_file+0xcae/0x1230 fs/btrfs/file.c:1729
 #3: ffff8880371eb110 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x612/0xd50 fs/btrfs/transaction.c:299
 #4: ffff8880371eb138 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x612/0xd50 fs/btrfs/transaction.c:299
 #5: ffff88802b4ca0d0 (&type->s_umount_key#55){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2892
4 locks held by syz.0.145/8539:
 #0: ffff88802b4ca480 (sb_writers#12){.+.+}-{0:0}, at: ioctl_file_clone fs/ioctl.c:239 [inline]
 #0: ffff88802b4ca480 (sb_writers#12){.+.+}-{0:0}, at: ioctl_file_clone_range fs/ioctl.c:257 [inline]
 #0: ffff88802b4ca480 (sb_writers#12){.+.+}-{0:0}, at: do_vfs_ioctl+0xe15/0x1540 fs/ioctl.c:544
 #1: ffff888059b39080 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff888059b39080 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:368
 #2: ffff888059b38ee0 (&ei->i_mmap_lock){+.+.}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:371
 #3: ffff88802b4ca770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff88802b4ca770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x1316/0x2540 fs/btrfs/reflink.c:574
1 lock held by btrfs-transacti/8537:
 #0: ffff8880371e8d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe6/0x450 fs/btrfs/disk-io.c:1521
6 locks held by syz.1.185/9335:
 #0: ffff88803e944128 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x252/0x320 fs/file.c:1260
 #1: ffff888057250480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2733 [inline]
 #1: ffff888057250480 (sb_writers#12){.+.+}-{0:0}, at: vfs_write+0x22d/0xba0 fs/read_write.c:684
 #2: ffff888057250770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_sync_file+0xcae/0x1230 fs/btrfs/file.c:1729
 #3: ffff8880263fb110 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x612/0xd50 fs/btrfs/transaction.c:299
 #4: ffff8880263fb138 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x612/0xd50 fs/btrfs/transaction.c:299
 #5: ffff8880572500d0 (&type->s_umount_key#55){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2892
4 locks held by syz.1.185/9353:
 #0: ffff888057250480 (sb_writers#12){.+.+}-{0:0}, at: ioctl_file_clone fs/ioctl.c:239 [inline]
 #0: ffff888057250480 (sb_writers#12){.+.+}-{0:0}, at: ioctl_file_clone_range fs/ioctl.c:257 [inline]
 #0: ffff888057250480 (sb_writers#12){.+.+}-{0:0}, at: do_vfs_ioctl+0xe15/0x1540 fs/ioctl.c:544
 #1: ffff888044751ab8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #1: ffff888044751ab8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:368
 #2: ffff888044751918 (&ei->i_mmap_lock){+.+.}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:371
 #3: ffff888057250770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888057250770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x1316/0x2540 fs/btrfs/reflink.c:574
1 lock held by btrfs-transacti/9351:
 #0: ffff8880263f8d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe6/0x450 fs/btrfs/disk-io.c:1521
6 locks held by udevd/9397:
 #0: ffff8880232f23c8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff8880232f23c8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: blkdev_read_iter+0x2ff/0x440 block/fops.c:854
 #1: ffff8880232f2598 (mapping.invalidate_lock){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 #1: ffff8880232f2598 (mapping.invalidate_lock){++++}-{4:4}, at: do_page_cache_ra mm/readahead.c:349 [inline]
 #1: ffff8880232f2598 (mapping.invalidate_lock){++++}-{4:4}, at: force_page_cache_ra+0x2ec/0x360 mm/readahead.c:380
 #2: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #2: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #2: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: blk_mq_dispatch_queue_requests+0x552/0x800 block/blk-mq.c:2908
 #3: ffff8880b863b860 (&rq->__lock){-...}-{2:2}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #3: ffff8880b863b860 (&rq->__lock){-...}-{2:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #3: ffff8880b863b860 (&rq->__lock){-...}-{2:2}, at: __rt_spin_trylock kernel/locking/spinlock_rt.c:110 [inline]
 #3: ffff8880b863b860 (&rq->__lock){-...}-{2:2}, at: rt_spin_trylock+0x10c/0x2b0 kernel/locking/spinlock_rt.c:118
 #4: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #4: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #4: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: __rt_spin_lock kernel/locking/spinlock_rt.c:50 [inline]
 #4: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1e0/0x400 kernel/locking/spinlock_rt.c:57
 #5: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #5: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #5: ffffffff8dfcabc0 (rcu_read_lock){....}-{1:3}, at: page_table_check_set+0x126/0x510 mm/page_table_check.c:112

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:119
 nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd3/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:task_wait_context kernel/locking/lockdep.c:4788 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4877 [inline]
RIP: 0010:__lock_acquire+0x9a5/0x2d10 kernel/locking/lockdep.c:5189
Code: 4a 86 ff 48 c7 c7 71 ba 70 8d e8 d6 6e 86 ff e8 41 9e 91 ff e8 8c cc 03 00 e9 93 0a 00 00 41 83 be e8 0b 00 00 00 41 0f 94 c4 <41> 80 f4 03 41 3b 9e f8 0b 00 00 0f 8d 19 fc ff ff e9 1f fb ff ff
RSP: 0018:ffffc90000007c98 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 0000000000000003 RCX: 00000000000e40aa
RDX: 0000000000000002 RSI: 0000000000004000 RDI: 0000000000000000
RBP: ffff88801d682b78 R08: ffffffff81b1ebf9 R09: ffff8880b8628418
R10: dffffc0000000000 R11: ffffffff81b1eb00 R12: 0000000000000001
R13: ffff88801d682b78 R14: ffff88801d681f00 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff888125eec000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f02a929f000 CR3: 0000000024f2c000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5870
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
 _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
 hrtimer_interrupt+0xf9/0x950 kernel/time/hrtimer.c:2197
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:81 [inline]
RIP: 0010:__orc_find arch/x86/kernel/unwind_orc.c:103 [inline]
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
RIP: 0010:unwind_next_frame+0x515/0x2550 arch/x86/kernel/unwind_orc.c:510
Code: 83 e0 fe 4c 8d 3c 45 00 00 00 00 49 01 ef 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 0f b6 04 08 84 c0 75 27 49 63 07 <4c> 01 f8 49 8d 4f 04 4c 39 e0 48 0f 46 e9 49 8d 47 fc 48 0f 47 d8
RSP: 0018:ffffc90000147618 EFLAGS: 00000246
RAX: fffffffff282df12 RBX: ffffffff8facfe80 RCX: dffffc0000000000
RDX: ffffffff8facfe44 RSI: ffffffff90281a54 RDI: ffffffff8ba9cd20
RBP: ffffffff8facfe44 R08: 0000000000000010 R09: ffffffff8dfcabc0
R10: ffffc90000147738 R11: ffffffff81b048a0 R12: ffffffff822fdd2c
R13: ffffffff8facfe44 R14: ffffc900001476e8 R15: ffffffff8facfe60
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3131 [inline]
 call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
 slab_free_hook mm/slub.c:2664 [inline]
 slab_free mm/slub.c:6284 [inline]
 kmem_cache_free+0x526/0x6c0 mm/slub.c:6411
 mempool_free+0xf5/0x140 mm/mempool.c:711
 blk_update_request+0x57e/0xe60 block/blk-mq.c:1016
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1178
 blk_complete_reqs block/blk-mq.c:1253 [inline]
 blk_done_softirq+0x10a/0x160 block/blk-mq.c:1258
 handle_softirqs+0x1de/0x6d0 kernel/softirq.c:626
 run_ksoftirqd+0x52/0x180 kernel/softirq.c:1080
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
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

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
