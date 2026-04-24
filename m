Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10B34A767
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777017275; cv=none; b=S2WrQ1rrFrWiwLHcKrtjCwG8phIYmsmulRSUGi3RTY9qhsAge2FKfybfJYhpWIO6i6KymNI90yIBdBWSAKPGyqMDKfiAkw/0vhMCHEu+g6YcdZDIKmWqz8pU5Ip7ghLMmbticWW+G7rTuGKg31lPWFY04uS2GM/2JSKm1Oyj0H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777017275; c=relaxed/simple;
	bh=MaraI430aZsozOsdIp+Rf471L3nAQsLpcrEn6ChTYKk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b1687IicwMQE/SgbOJCOe5vIJ630oDoROpEfJwwJugdH0pRVTXjmY0ifmWCbNGNCJbNo4n5ngmBb3MfpmePd6iJU1+GlrQ2Jkd/h9e4fo4uqUtgj3Dtlaqfz2wfSZ7Y8f4ZWgM9mUAGn7FzGEY6cFn0RQz4M66+tQnmb/otVdyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69491bd267fso8947950eaf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777017272; x=1777622072;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eFKi649ZkY5D599kqoYXiEqrp7pEoyOSrvNmABzUs8c=;
        b=fpGsfxtSWStFbJiW2r9nPCAT80lVndX4fZ561YYj87Zm+AGX63+UUsJNLIqKssFhia
         3TvZwHIZ2Vi/Y56eNKkHs+Psq2cjhUYlorcFC4Q97gTXmaFtTXSYr80jhlHAKoEnjKzI
         rFxE5zqyF+bluixfMjNueO3pLTYzcSyi1Y2W0xTHeU8nXHHoVgRFYa7cChFZgV6owYQy
         henlHZUnVudNoPWYan78njpzRmB3bWyYF8amZ4UocC7aEcKgTlEbUnxsYrAQjnadFh+l
         ChTewdQeyEmoKnv4saWizCMudBGimfUVAY8nK7nkWJOLGlsmcFkSwaAylxZ3BdjMcPrZ
         blMw==
X-Forwarded-Encrypted: i=1; AFNElJ9libmc9QH1Mdak5SBAVEl1hpqOxPQwIQhH8K9ppraQfe+6kilOWCWw+T53awNMjpuldy1KMP8d+xhJ/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YztcM9FbEYw3yKsTPtIseOsEeAJ1cfnjlR71q150Y6gBt+E51SM
	w7UXP0uDbG2NtOJdzmMvpAFfdLsBG13Nz1EHupQoTuMbm+JWKIcGTifl43JFfkTffLizwxnOivf
	yD9bZNGSaP8sJ1XzAJg8+iYtqoRRLskAneG09X0/tuzPCqxBozMKMSdRES8o=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f005:b0:696:1be1:92d0 with SMTP id
 006d021491bc7-6961be1a142mr3331947eaf.30.1777017272621; Fri, 24 Apr 2026
 00:54:32 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:54:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eb21b8.a00a0220.17a17.0056.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in __btrfs_update_delayed_inode (4)
From: syzbot <syzbot+768687d6d7c96a124e24@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bea8d77e45a8 Merge tag 'staging-7.1-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1636202a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8c5ce991a39e5d9
dashboard link: https://syzkaller.appspot.com/bug?extid=768687d6d7c96a124e24
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-bea8d77e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa29d85c34c6/vmlinux-bea8d77e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c65a4276191b/bzImage-bea8d77e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+768687d6d7c96a124e24@syzkaller.appspotmail.com

------------[ cut here ]------------
BTRFS: Transaction aborted (error -28)
WARNING: fs/btrfs/delayed-inode.c:1027 at __btrfs_update_delayed_inode+0xe3d/0x1070 fs/btrfs/delayed-inode.c:1027, CPU#0: kworker/u4:5/70
Modules linked in:
CPU: 0 UID: 0 PID: 70 Comm: kworker/u4:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_data_space
RIP: 0010:__btrfs_update_delayed_inode+0xe40/0x1070 fs/btrfs/delayed-inode.c:1027
Code: bc bd fd e9 22 01 00 00 e8 7d d1 a2 fd 84 c0 74 23 e8 a4 bc bd fd e9 0f 01 00 00 e8 9a bc bd fd 48 8d 3d 63 e8 34 0c 44 89 ee <67> 48 0f b9 3a e9 31 01 00 00 e8 51 38 b1 07 89 c3 31 ff 89 c6 e8
RSP: 0018:ffffc90000cff140 EFLAGS: 00010293
RAX: ffffffff84082226 RBX: 00000000ffffffe4 RCX: ffff888000bc4a00
RDX: 0000000000000000 RSI: 00000000ffffffe4 RDI: ffffffff903d0a90
RBP: ffffc90000cff270 R08: ffff888000bc4a00 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: ffff888011cf9200
R13: 00000000ffffffe4 R14: 0000000000000000 R15: ffff888012ef93c0
FS:  0000000000000000(0000) GS:ffff88808c812000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4b4adeaff8 CR3: 000000001f399000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_update_delayed_inode fs/btrfs/delayed-inode.c:1103 [inline]
 __btrfs_commit_inode_delayed_items+0x1dfa/0x1f50 fs/btrfs/delayed-inode.c:1127
 __btrfs_run_delayed_items+0x1f6/0x510 fs/btrfs/delayed-inode.c:1158
 btrfs_commit_transaction+0x836/0x30e0 fs/btrfs/transaction.c:2376
 flush_space+0x2a3/0xe20 fs/btrfs/space-info.c:-1
 do_async_reclaim_data_space+0x29a/0x520 fs/btrfs/space-info.c:1464
 btrfs_async_reclaim_data_space+0x41/0x90 fs/btrfs/space-info.c:1512
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	bc bd fd e9 22       	mov    $0x22e9fdbd,%esp
   5:	01 00                	add    %eax,(%rax)
   7:	00 e8                	add    %ch,%al
   9:	7d d1                	jge    0xffffffdc
   b:	a2 fd 84 c0 74 23 e8 	movabs %al,0xbca4e82374c084fd
  12:	a4 bc
  14:	bd fd e9 0f 01       	mov    $0x10fe9fd,%ebp
  19:	00 00                	add    %al,(%rax)
  1b:	e8 9a bc bd fd       	call   0xfdbdbcba
  20:	48 8d 3d 63 e8 34 0c 	lea    0xc34e863(%rip),%rdi        # 0xc34e88a
  27:	44 89 ee             	mov    %r13d,%esi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 31 01 00 00       	jmp    0x165
  34:	e8 51 38 b1 07       	call   0x7b1388a
  39:	89 c3                	mov    %eax,%ebx
  3b:	31 ff                	xor    %edi,%edi
  3d:	89 c6                	mov    %eax,%esi
  3f:	e8                   	.byte 0xe8


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
