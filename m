Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792848832;
	b=g82BPc9Oji3HEIe3XY3FA6WW1d6Fcwbsek8Zjwfnt2M0Qf/HtkiIM5ZHAk9MfFnyFBnJ
	 W5DvhyjZa4/mdS5ezEUmwmtrl00pFOEU86oUEqVqAi/erPsrNoeHfmCbVclHZldPWxurO
	 3pegwyFTPP7ZmovOzFTfiVvcN+AITZ2MUYNAM0Na9Q8c8nnKsJCmBIugEf82gtAySJFN1
	 COTWrVmfMDzv0wx9tpEcLK5FafE1PY8LszY9Rc6hd7COhixNdrv3GV6s/1pzQlv+LHVvC
	 BaPwI/cYRuFcBGE0xznCIwVcLnQyeho/MO0kK3m5Mz6Cb1ilN0PTTJONWAs9QrQ5u2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792848832;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=lTPGxZ69LJ2b6gKb3IoJdEZhnVCERWAiNgQIhAFFu9M=;
	b=lwf4gNjo4Ir36BpDltxrdL7VMXjS52fQqs+hAhWpMvUtbzDMxnop3t1Sf2Xnqi5F5WGz
	 vC/mw2qtDiMuGKDFwBnSN9UosBjc3/KfL/EEcBddeCUfcgfteMKXqFgd98nSGYoA2cON6
	 jlKeSjaeB+mAZiTsaTEGLmExrn0mdlQys4a6F/1rkPKe0f23lu41EerdOw9bnsCIituj5
	 LAwQ5ijdN/ma6mDjAUpXB9NE8ZEP2lJKAF/Iu7DR83xhKrmWo1qp3Ej6HmK4UBbwhmhf3
	 KhDlqqiw9cSc2MtbqbMHKQ7UWHWzH9Jehgw8/jqUgc6ieVRIn+bhIbdhVw7MUbJirQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD339606A31B
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2026 13:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD339606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81b20bea169so1152293a34.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2026 06:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792848830; x=1793453630;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lTPGxZ69LJ2b6gKb3IoJdEZhnVCERWAiNgQIhAFFu9M=;
        b=iPjFC32kZf39imxr757TzsCGLNak/Um2lewXYPx4iPasJLRQkFSd5HKoJh4/bIAErY
         298BC9r5wt0gFqcaBOsFWunrc4joHSF4DyKF6eHTn0KDrOm7owFoqi7XkRtWzGkzPzLz
         zcu/7edm80DYuv0wXAvYQTIUmbTJ5DJVsnXPkoexxAiT1fb8F+dRjBEb1rOQiMts/rGo
         /ZFT1PDhrH6iZocxW4UggWBC/KROhNqgsjavjplUjjScVEmQhcHdI+T+llGH3wII49oD
         3AjO7MKpNuxtqrNg3nLAu7SmOrBPII/B9nTxgnYrSBqksDnPFb5AltdyB6fbXZhyGaQo
         4IZw==
X-Forwarded-Encrypted: i=1; AKwUvBwlyZ+5vQ1SvM8zf72hrT6TaX2cIs1qCJ2xE5TWhQ+jhqMUm3Qy5jih5rrNy57eErZEDq7V+b2Y72UOMg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKrxRr2kHH34R7SgL55ZldxJnvBPSfrOmpopC7cFx88Iln4gkWy
	17UFukEROVEuTHoRwz2g8FKricS8n/MW8MsmJkzEE6+F9HkESngYDEDtuharedHlHeI3shTcGa3
	sGOVWm3fr5bWFXraph/OW0Y36rJOs/9UST+5q0nN5SBl3uIr+QGSiVaOCEFI=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e8d1:10b0:50a:7162:87df with SMTP id
 5614622812f47-55bfffdd86cmr829522b6e.2.1792848830805; Sat, 24 Oct 2026
 06:33:50 -0700 (PDT)
Date: Sat, 24 Oct 2026 06:33:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adcb3be.4ce6c07b.2dfc0c.0005.GAE@google.com>
Subject: [syzbot] [btrfs?] possible deadlock in set_blocksize
From: syzbot <syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4169c9c90532 powerpc/irq: Fix build with CONFIG_PROC_FS=n
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14fdcbcd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e397d1e24d3cb03
dashboard link: https://syzkaller.appspot.com/bug?extid=5c01398781fb51df783a
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132c1a31580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor324/6058 is trying to acquire lock:
ffff888024d4e3e8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff888024d4e3e8 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at: set_blocksize+0x1e6/0x440 block/bdev.c:202

but task is already holding lock:
ffff888027eb26a8 (btrfs_trans_num_extwriters){.+.+}-{0:0}, at: join_transaction+0x6b2/0xd40 fs/btrfs/transaction.c:331

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (btrfs_trans_num_extwriters){.+.+}-{0:0}:
       join_transaction+0x18a/0xd40 fs/btrfs/transaction.c:356
       start_transaction+0x731/0x1830 fs/btrfs/transaction.c:770
       btrfs_create_common+0x15c/0x310 fs/btrfs/inode.c:6991
       lookup_open+0xedc/0x1970 fs/namei.c:4569
       open_last_lookups fs/namei.c:4768 [inline]
       path_openat+0x70c/0x20f0 fs/namei.c:5007
       do_file_open+0x23e/0x4a0 fs/namei.c:5039
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (btrfs_trans_num_writers){.+.+}-{0:0}:
       __lock_release kernel/locking/lockdep.c:5627 [inline]
       lock_release+0x1a3/0x3c0 kernel/locking/lockdep.c:5964
       percpu_up_read include/linux/percpu-rwsem.h:114 [inline]
       __sb_end_write include/linux/fs/super.h:14 [inline]
       sb_end_intwrite+0x26/0x190 include/linux/fs/super.h:101
       __btrfs_end_transaction+0x237/0x640 fs/btrfs/transaction.c:1147
       btrfs_dirty_inode+0x14c/0x190 fs/btrfs/inode.c:6444
       touch_atime+0x2f8/0x670 fs/inode.c:2325
       file_accessed include/linux/fs.h:2279 [inline]
       btrfs_file_mmap_prepare+0x172/0x1f0 fs/btrfs/file.c:2003
       vfs_mmap_prepare include/linux/fs.h:2071 [inline]
       call_mmap_prepare mm/vma.c:2815 [inline]
       __mmap_region mm/vma.c:2913 [inline]
       mmap_region+0xe88/0x23c0 mm/vma.c:3014
       do_mmap+0xe0a/0x1300 mm/mmap.c:573
       vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
       ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xcb/0x130 mm/memory.c:7419
       _copy_to_iter+0xf9/0x1810 lib/iov_iter.c:196
       copy_page_to_iter+0x23f/0x330 lib/iov_iter.c:374
       copy_folio_to_iter include/linux/uio.h:204 [inline]
       filemap_read+0x7af/0x11e0 mm/filemap.c:2893
       blkdev_read_iter+0x2f1/0x420 block/fops.c:838
       new_sync_read fs/read_write.c:493 [inline]
       vfs_read+0x595/0xa80 fs/read_write.c:574
       ksys_read+0x150/0x270 fs/read_write.c:716
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_write+0x91/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       set_blocksize+0x1e6/0x440 block/bdev.c:202
       btrfs_init_new_device+0xa4e/0x1cf0 fs/btrfs/volumes.c:3046
       btrfs_ioctl_add_dev+0x1ad/0x640 fs/btrfs/ioctl.c:2571
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#10 --> btrfs_trans_num_writers --> btrfs_trans_num_extwriters

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(btrfs_trans_num_extwriters);
                               lock(btrfs_trans_num_writers);
                               lock(btrfs_trans_num_extwriters);
  lock(&sb->s_type->i_mutex_key#10);

 *** DEADLOCK ***

locks held by syz-executor324/6058: 3, last CPU#0:
 #0: ffff8880139a2650 (sb_internal#2){.+.+}-{0:0}, at: btrfs_init_new_device+0x7f3/0x1cf0 fs/btrfs/volumes.c:3022
 #1: ffff888027eb2680 (btrfs_trans_num_writers){.+.+}-{0:0}, at: join_transaction+0x6b2/0xd40 fs/btrfs/transaction.c:331
 #2: ffff888027eb26a8 (btrfs_trans_num_extwriters){.+.+}-{0:0}, at: join_transaction+0x6b2/0xd40 fs/btrfs/transaction.c:331

stack backtrace:
CPU: 0 UID: 0 PID: 6058 Comm: syz-executor324 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
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
 down_write+0x91/0x200 kernel/locking/rwsem.c:1631
 inode_lock include/linux/fs.h:1024 [inline]
 set_blocksize+0x1e6/0x440 block/bdev.c:202
 btrfs_init_new_device+0xa4e/0x1cf0 fs/btrfs/volumes.c:3046
 btrfs_ioctl_add_dev+0x1ad/0x640 fs/btrfs/ioctl.c:2571
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8612ea2ebb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffe693cf9a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f8612ea2ebb
RDX: 00007ffe693d2bf0 RSI: 000000005000940a RDI: 0000000000000003
RBP: 00007ffe693d2bf0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe693cfb20
R13: 0000000000000000 R14: 00007f8612e71000 R15: 00007ffe693cff70
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
