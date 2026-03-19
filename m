Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB82EC08C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773904897; cv=none; b=sDkVPCe+2Ej5Ve+brDwAw9CTGnsQLx7ekU8udRlpjBGIIBUzZhTc2Xeoeyp+CE7SgEa+H11onTcm892KWuP3JLatmrgtwEC/4Cn3p40RmureWXdRAxxTBqa22hIzW1WlPqNmUXQ9lWbqAHOj4egpAUJG93YWbD+UV1HZVlkFhJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773904897; c=relaxed/simple;
	bh=UqHkUT3qWbrWe8bOHFK/rOI44LsSmFqJyIF8Dfzjz4o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AyGSZRvC3pLPb4UhC5DUtgKV9noa4Ucd45Iv6B8auGbC7A8BS6JtXC0iFvQvfhTqYSROjyDO5WXVCeiDODrYA0YlvJBXhSCJ2Bg4lCJZdccSaz60n8nbkDORg0qmRVbjUxmYokzokt1oB/tZVj66Ops+/tmGSrlN2XMpP79BX5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67bcaf99fdcso12266276eaf.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 00:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904895; x=1774509695;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aCPL+v2rnTzdDIry6sM7gomXgbjse5YsdJ/k4L4WyVY=;
        b=q05AT16bkgcKKUQl4fE8Y0M088SV2HyvmO43F4Zl7ZoXwxOdg9LPFXn3Dru/I/hIM9
         l9NHXWjnR8vTFC2apU/gdBkGyn9eNVSPnDX+lKxraLYs7Wuodpn+H/8hOUzuAfflZHJx
         OI5DRqOnKtpRhDKs4XTjg3d2NrBg84GE/HFWQDQJkO37w1zG9DfCBAfYXxVwEkrlJ60B
         5gzFDA/to5ZTw3FGTyRwSx2m7/NfsoMkdWDFCYpKm2fZEaf4TAV24FsJPjE67fBv+Iqd
         XFUZSI6ttM8Z7YFIhsZxcs7FO9R/IJKn1QnzRuhhfihsvO4+nCTCi4rxHIIPi51LaSTz
         KDvA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ3ez3G8+MvNWJNCl0RsAlURksAVoowX4md5zLHElf7UHwduN4CKoUj39vwPNIVuJ6cSfdoepQKWgK8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkZWHIDq6HluS1qoTrmrLVCnPFOVEXJU5EFekgYvZCyUP7eQid
	BiI8vl5xKaD6HtxpJmiWE4ckewZbpBEZwvKmTIz+AMsETaHnGz/eWzffbX2aqgS7zH1Ijfj5uDk
	ig6ScG/7yYtVDUIw0x/HG3AdCoJSj1Ed76lu3eti9OsPLysHQpbXvxXsZS64=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dc7:b0:67b:c59b:466a with SMTP id
 006d021491bc7-67c0da659b5mr4095026eaf.7.1773904894739; Thu, 19 Mar 2026
 00:21:34 -0700 (PDT)
Date: Thu, 19 Mar 2026 00:21:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bba3fe.050a0220.227207.002f.GAE@google.com>
Subject: [syzbot] [btrfs?] INFO: task hung in btrfs_invalidate_folio (3)
From: syzbot <syzbot+63056bf627663701bbbf@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f0caa1d49cc0 Merge tag 'hid-for-linus-2026031701' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ad24da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45cb3c58fd963c27
dashboard link: https://syzkaller.appspot.com/bug?extid=63056bf627663701bbbf
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178bb406580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c82216580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cf6c805602fb/disk-f0caa1d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4237ac907af6/vmlinux-f0caa1d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fd0193de4f6c/bzImage-f0caa1d4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/810a9ef5b7b5/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=160868da580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63056bf627663701bbbf@syzkaller.appspotmail.com

INFO: task kworker/u8:7:1053 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:7    state:D stack:23520 pid:1053  tgid:1053  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: writeback wb_workfn (flush-btrfs-46)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1553/0x5240 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 wait_extent_bit fs/btrfs/extent-io-tree.c:811 [inline]
 btrfs_lock_extent_bits+0x59c/0x700 fs/btrfs/extent-io-tree.c:1914
 btrfs_lock_extent fs/btrfs/extent-io-tree.h:152 [inline]
 btrfs_invalidate_folio+0x43d/0xc40 fs/btrfs/inode.c:7704
 extent_writepage fs/btrfs/extent_io.c:1852 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2580 [inline]
 btrfs_writepages+0x12ff/0x2440 fs/btrfs/extent_io.c:2713
 do_writepages+0x32e/0x550 mm/page-writeback.c:2554
 __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
 writeback_sb_inodes+0x995/0x19d0 fs/fs-writeback.c:2042
 wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
 wb_do_writeback fs/fs-writeback.c:2374 [inline]
 wb_workfn+0x41a/0xf60 fs/fs-writeback.c:2414
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz.4.64:6910 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.64        state:D stack:22752 pid:6910  tgid:6905  ppid:5944   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1553/0x5240 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 wait_current_trans+0x39f/0x590 fs/btrfs/transaction.c:535
 start_transaction+0x6a7/0x1650 fs/btrfs/transaction.c:705
 clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
 btrfs_clone_files+0x271/0x3f0 fs/btrfs/reflink.c:750
 btrfs_remap_file_range+0x76b/0x1320 fs/btrfs/reflink.c:903
 vfs_copy_file_range+0xda7/0x1390 fs/read_write.c:1600
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f73afc799
RSP: 002b:00007f5f7315e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f5f73d75fa0 RCX: 00007f5f73afc799
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f5f73b92c99 R08: 0000000000000863 R09: 0000000000000000
R10: 00002000000000c0 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5f73d76038 R14: 00007f5f73d75fa0 R15: 00007fff138a5068
 </TASK>
INFO: task syz.4.64:6975 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.64        state:D stack:24736 pid:6975  tgid:6905  ppid:5944   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1553/0x5240 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7008
 wb_wait_for_completion+0x3e8/0x790 fs/fs-writeback.c:227
 __writeback_inodes_sb_nr+0x24c/0x2d0 fs/fs-writeback.c:2838
 try_to_writeback_inodes_sb+0x9a/0xc0 fs/fs-writeback.c:2886
 btrfs_start_delalloc_flush fs/btrfs/transaction.c:2175 [inline]
 btrfs_commit_transaction+0x82e/0x31a0 fs/btrfs/transaction.c:2364
 btrfs_ioctl+0xca7/0xd00 fs/btrfs/ioctl.c:5206
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f73afc799
RSP: 002b:00007f5f7313d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5f73d76090 RCX: 00007f5f73afc799
RDX: 0000000000000000 RSI: 0000000000009408 RDI: 0000000000000004
RBP: 00007f5f73b92c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5f73d76128 R14: 00007f5f73d76090 R15: 00007fff138a5068
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:0/12:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90000117c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90000117c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
1 lock held by khungtaskd/37:
 #0: ffffffff8ddcb980
 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:850 [inline]
 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:2/40:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90000b17c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90000b17c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
10 locks held by kworker/u8:6/144:
2 locks held by kworker/u8:7/1053:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90005affc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90005affc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
2 locks held by kworker/u8:8/1115:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90005ebfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90005ebfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
2 locks held by kworker/u8:9/1138:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90005fdfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90005fdfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
5 locks held by kworker/u8:10/1156:
2 locks held by kworker/u8:11/1176:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc900060bfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc900060bfc40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
3 locks held by kworker/u8:13/4443:
 #0: ffff88806a862938 ((wq_completion)loop8){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88806a862938 ((wq_completion)loop8){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90010d57c40 ((work_completion)(&worker->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90010d57c40 ((work_completion)(&worker->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffff88802624a160 (&lo->lo_work_lock){+.+.}-{3:3}, at: spin_lock_irq include/linux/spinlock_rt.h:96 [inline]
 #2: ffff88802624a160 (&lo->lo_work_lock){+.+.}-{3:3}, at: loop_process_work+0x125/0x11b0 drivers/block/loop.c:1953
3 locks held by kworker/u9:1/5115:
 #0: ffff88803456c938 ((wq_completion)hci6){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88803456c938 ((wq_completion)hci6){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc9000f917c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc9000f917c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
 #2: ffff888031fd8f80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1d3/0x400 net/bluetooth/hci_sync.c:331
1 lock held by syslogd/5147:
 #0: ffff88802963f598 (&ei->socket.wq.wait){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #0: ffff88802963f598 (&ei->socket.wq.wait){+.+.}-{3:3}, at: finish_wait+0xbe/0x1e0 kernel/sched/wait.c:394
3 locks held by klogd/5154:
2 locks held by getty/5553:
 #0: ffff8880379060a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e8b2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x462/0x13c0 drivers/tty/n_tty.c:2211
4 locks held by syz.4.64/6910:
 #0: ffff888040716480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff888040716480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff88805e1eed68 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff88805e1eed68 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff88805e1eebc8 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff888040716770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888040716770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.4.64/6975:
 #0: ffff8880395a7118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff8880395a7140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff8880407160d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/6971:
 #0: ffff8880395a4d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
4 locks held by syz.0.74/7139:
 #0: ffff888028b52480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff888028b52480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff8880445477b8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff8880445477b8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff888044547618 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff888028b52770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888028b52770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.0.74/7181:
 #0: ffff88803961b118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff88803961b140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff888028b520d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/7159:
 #0: ffff888039618d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
4 locks held by syz.2.80/7215:
 #0: ffff888035edc480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff888035edc480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff888040951098 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff888040951098 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff888040950ef8 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff888035edc770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888035edc770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.2.80/7269:
 #0: ffff88805b5a7118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff88805b5a7140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff888035edc0d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/7265:
 #0: ffff88805b5a4d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
4 locks held by syz.5.96/7519:
 #0: ffff888020336480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff888020336480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff888044546d68 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff888044546d68 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff888044546bc8 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff888020336770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888020336770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.5.96/7570:
 #0: ffff88803cfe3118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff88803cfe3140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff8880203360d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/7563:
 #0: ffff88803cfe0d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
5 locks held by kworker/u8:14/8416:
2 locks held by kworker/u8:15/8574:
2 locks held by udevd/8677:
 #0: ffff8880222a83b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #0: ffff8880222a83b0 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x237/0x4f0 mm/util.c:579
 #1: ffff88803655d068 (&anon_vma->rwsem){++++}-{4:4}, at: anon_vma_lock_read mm/internal.h:235 [inline]
 #1: ffff88803655d068 (&anon_vma->rwsem){++++}-{4:4}, at: validate_mm+0x1e3/0x4c0 mm/vma.c:677
4 locks held by syz.6.164/8838:
 #0: ffff88801e68a480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff88801e68a480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff8880445458c8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff8880445458c8 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff888044545728 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff88801e68a770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff88801e68a770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.6.164/8888:
 #0: ffff88803f40b118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff88803f40b140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff88801e68a0d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/8884:
 #0: ffff88803f408d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
4 locks held by syz.1.172/8963:
 #0: ffff88805c294480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff88805c294480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff88805abcaf88 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff88805abcaf88 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff88805abcade8 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff88805c294770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff88805c294770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.1.172/9027:
 #0: ffff88802a7fb118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff88802a7fb140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff88805c2940d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
1 lock held by btrfs-transacti/9025:
 #0: ffff88802a7f8d98 (&fs_info->transaction_kthread_mutex){+.+.}-{4:4}, at: transaction_kthread+0xe4/0x450 fs/btrfs/disk-io.c:1515
2 locks held by kworker/u8:16/9083:
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88801f2b8138 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90010587c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90010587c40 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
4 locks held by kworker/u8:17/9084:
3 locks held by kworker/u8:18/9197:
2 locks held by kworker/u8:20/9396:
 #0: ffff88807150d138 ((wq_completion)btrfs-flush_delalloc#198){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3251 [inline]
 #0: ffff88807150d138 ((wq_completion)btrfs-flush_delalloc#198){+.+.}-{0:0}, at: process_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
 #1: ffffc90011d17c40 ((work_completion)(&work->normal_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3252 [inline]
 #1: ffffc90011d17c40 ((work_completion)(&work->normal_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa8d/0x18c0 kernel/workqueue.c:3359
4 locks held by syz.3.229/9896:
 #0: ffff888071198480 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2710 [inline]
 #0: ffff888071198480 (sb_writers#12){.+.+}-{0:0}, at: vfs_copy_file_range+0x9bb/0x1390 fs/read_write.c:1588
 #1: ffff88805e034428 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #1: ffff88805e034428 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: btrfs_inode_lock+0x51/0xe0 fs/btrfs/inode.c:369
 #2: ffff88805e034288 (&ei->i_mmap_lock){++++}-{4:4}, at: btrfs_inode_lock+0xcb/0xe0 fs/btrfs/inode.c:372
 #3: ffff888071198770 (sb_internal#2){.+.+}-{0:0}, at: clone_copy_inline_extent fs/btrfs/reflink.c:299 [inline]
 #3: ffff888071198770 (sb_internal#2){.+.+}-{0:0}, at: btrfs_clone+0x128a/0x24d0 fs/btrfs/reflink.c:529
3 locks held by syz.3.229/9963:
 #0: ffff888070247118 (btrfs_trans_num_writers){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #1: ffff888070247140 (btrfs_trans_num_extwriters){++++}-{0:0}, at: join_transaction+0x41b/0xc90 fs/btrfs/transaction.c:298
 #2: ffff8880711980d0 (&type->s_umount_key#56){++++}-{4:4}, at: try_to_writeback_inodes_sb+0x22/0xc0 fs/fs-writeback.c:2883
4 locks held by syz.7.242/10098:
2 locks held by syz.7.242/10121:
 #0: ffff888063b19020 (&fs_info->ordered_operations_mutex){+.+.}-{4:4}, at: btrfs_wait_ordered_roots+0xe7/0x6f0 fs/btrfs/ordered-data.c:823
 #1: ffff888063c209a8 (&root->ordered_extent_mutex){+.+.}-{4:4}, at: btrfs_wait_ordered_extents+0x23d/0xcf0 fs/btrfs/ordered-data.c:767
2 locks held by syz.9.243/10101:
 #0: ffff8880355860d0 (&type->s_umount_key#55/1){+.+.}-{4:4}, at: alloc_super+0x28c/0xac0 fs/super.c:345
 #1: ffffffff8dc6bab8 (wq_pool_mutex){+.+.}-{4:4}, at: apply_wqattrs_lock kernel/workqueue.c:5279 [inline]
 #1: ffffffff8dc6bab8 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0x9ef/0x1e90 kernel/workqueue.c:5832
5 locks held by syz.8.244/10103:
2 locks held by syz.4.245/10109:
4 locks held by udevd/10130:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 37 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xfd9/0x1030 kernel/hung_task.c:515
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 17 Comm: pr/legacy Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:400
Code: e8 be 9b 94 fc 44 89 f9 d3 e3 49 83 ee 80 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 ff b2 fa fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f c3 cc cc cc cc cc 44 89 f9 80 e1 07
RSP: 0018:ffffc900001679d0 EFLAGS: 00000202
RAX: 1ffffffff332a600 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff99953750 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff852fdaf0 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff999534c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88812633c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe8d6b8bb60 CR3: 000000002c606000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:128 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:150 [inline]
 wait_for_lsr+0x1aa/0x2f0 drivers/tty/serial/8250/8250_port.c:1961
 fifo_wait_for_lsr drivers/tty/serial/8250/8250_port.c:3234 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3257 [inline]
 serial8250_console_write+0x120d/0x1b90 drivers/tty/serial/8250/8250_port.c:3342
 console_emit_next_record kernel/printk/printk.c:3163 [inline]
 console_flush_one_record+0x68b/0xb90 kernel/printk/printk.c:3269
 legacy_kthread_func+0x1b6/0x250 kernel/printk/printk.c:3712
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
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
