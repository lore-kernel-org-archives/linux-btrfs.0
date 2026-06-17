Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBE71D432D
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781660015; cv=none; b=bd7uB+ckP/nCREqOec0gUFgpzRcgLhuCdG3hGL4op/RRdppOAMDeQZq7ZsjUV/R1Ctjt0AbExam6Mssv5T9iEQE2CX8zQMfJSpPl1jgXnlhjsS9iA2QP21I7COFrPCZJd7prvMeQCOZg+VVBQS1aC0CNKjy+49NSu8fSeIFEuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781660015; c=relaxed/simple;
	bh=mRv7Eqs7EXZZH4CAmy0L5rN+q2ad8wI/2KEOwHRzLOo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NhSP+TbqS+bIQSVLNqkmqAKn9GhZrxRGa46gRTyAsd4+v8AKsSF7KbBycztTNcaQ7cOdy9qy4pwTDCwo2H2uDpjFInQ5BPkoa6nX8cuFp0hoyxtFlgojgPIK/7sFJfrxa16+QKbXIH7CJMI6x/nihJg9pJOuEQvY7sri2z6Oc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e60737a964so10152353a34.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 18:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781660013; x=1782264813;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9+ggiXFVPEh/C4DsLvAL8y9CgmsmMf1deiPtKj4kPAE=;
        b=dPPByk+Eu0r+Qw5jvvyszMDDu5ILlKQeCMAyOYQDcvS8yLIATKM0Ox8dG0Ico29Y79
         BkllUc4+gT6jmIT4dQ/1So7IqD99lGAZm9dao5wkpbtfA6WWbIKGHjjB1JW5/kzPytV4
         3uSVlWRacuo27adw7dLJHXE8nXdIMe3hXdf+/bsNsHVIf87vB5lNufWF2N3tHRa6+y0w
         Y/qQxeYCVLEQJYrOjvgVaND7lAtV09/oOQQ+EKNBUiszXftjPIcg37BmBs820MQ2p9+p
         3kPwzvoZbDi3D6qPBRX0NPXZlBqEN9Q/yji3EXGrVI3drfwtDaaBAX5Sm0TJelUPg+/Q
         XUoA==
X-Forwarded-Encrypted: i=1; AFNElJ8nBWP/gfDThb1efM7gfhCGY0LPRdqg2DAPJsYNoOW5ZblQK6okMhuMkft7FMrKFfFtmvsvS9CisSWXbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2f6Fj1ln8dSe5rVaCq+HDrUFrtJIj0bxnXXVgncDavxbZIm+b
	d41LqVbbTg0g+Ma3SYmJOFqdz1FJVjdLo5hiuvvJL6S+9PKelxtsGYuh/NI4dakVkN5JvcRMI3p
	b0rTPLaiG0zxDiBYmXTy1mPDxnyvAmRMsgQy8/eHaZvrgXnfP6mqWxAnTDKI=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1797:b0:45c:8fa8:7497 with SMTP id
 5614622812f47-489429eea8fmr1733053b6e.34.1781660013093; Tue, 16 Jun 2026
 18:33:33 -0700 (PDT)
Date: Tue, 16 Jun 2026 18:33:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a31f96d.d1b4d54b.11ef78.002d.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in btrfs_balance
From: syzbot <syzbot+dc9291cf132691aeb478@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1dadb7e7eb5a Merge tag 'sound-7.1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10eb83b6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=dc9291cf132691aeb478
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1dadb7e7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/83a43e146e33/vmlinux-1dadb7e7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/758209a3afac/bzImage-1dadb7e7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc9291cf132691aeb478@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
btrfs: Deprecated parameter 'usebackuproot'
BTRFS warning: 'usebackuproot' is deprecated, use 'rescue=usebackuproot' instead
BTRFS: device fsid c9fe44da-de57-406a-8241-57ec7d4412cf devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5338)
BTRFS info (device loop0): first mount of filesystem c9fe44da-de57-406a-8241-57ec7d4412cf
BTRFS info (device loop0): using crc32c checksum algorithm
BTRFS info (device loop0): rebuilding free space tree
BTRFS info (device loop0): setting nodatasum
BTRFS info (device loop0): allowing degraded mounts
BTRFS info (device loop0): setting nodatacow
BTRFS info (device loop0): enabling ssd optimizations
BTRFS info (device loop0): using spread ssd allocation scheme
BTRFS info (device loop0): turning on flush-on-commit
BTRFS info (device loop0): turning on async discard
BTRFS info (device loop0): enabling free space tree
BTRFS info (device loop0): force clearing of disk cache
BTRFS info (device loop0): trying to use backup root at mount time
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x412/0x560 lib/fault-inject.c:174
 should_failslab+0xa8/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4523 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 kmem_cache_alloc_noprof+0x87/0x650 mm/slub.c:4906
 btrfs_start_dirty_block_groups+0x340/0x10b0 fs/btrfs/block-group.c:3567
 btrfs_commit_transaction+0x375/0x2fc0 fs/btrfs/transaction.c:2291
 insert_balance_item+0xcd7/0x1610 fs/btrfs/volumes.c:3834
 btrfs_balance+0x7d2/0x11b0 fs/btrfs/volumes.c:4874
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f1d19ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1f1e011fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1f1d415fa0 RCX: 00007f1f1d19ce59
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000008
RBP: 00007f1f1e012050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f1f1d416038 R14: 00007f1f1d415fa0 R15: 00007ffd7ed8ab98
 </TASK>
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:4879!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_balance+0x1196/0x11b0 fs/btrfs/volumes.c:4879
Code: c9 fd 48 c7 c7 60 42 17 8c 48 c7 c6 20 4c 17 8c 48 c7 c2 e0 3f 17 8c b9 1b 13 00 00 e8 33 91 2b fd 90 0f 0b e8 3b ab c9 fd 90 <0f> 0b e8 33 ab c9 fd 90 0f 0b e8 2b ab c9 fd 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc900036efd70 EFLAGS: 00010293
RAX: ffffffff83fc1bd5 RBX: 0000000000000000 RCX: ffff88801ce1ca80
RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 00000000ffffffef
RBP: 00000000ffffffef R08: ffff88801ce1ca80 R09: 0000000000000002
R10: 00000000ffffffef R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880418a0000 R14: ffff8880121a2400 R15: 1ffff11008314002
FS:  00007f1f1e0126c0(0000) GS:ffff88808c894000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f111ff000 CR3: 000000001f443000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f1d19ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1f1e011fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1f1d415fa0 RCX: 00007f1f1d19ce59
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000009
RBP: 00007f1f1d232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1f1d416038 R14: 00007f1f1d415fa0 R15: 00007ffd7ed8ab98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btrfs_balance+0x1196/0x11b0 fs/btrfs/volumes.c:4879
Code: c9 fd 48 c7 c7 60 42 17 8c 48 c7 c6 20 4c 17 8c 48 c7 c2 e0 3f 17 8c b9 1b 13 00 00 e8 33 91 2b fd 90 0f 0b e8 3b ab c9 fd 90 <0f> 0b e8 33 ab c9 fd 90 0f 0b e8 2b ab c9 fd 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc900036efd70 EFLAGS: 00010293
RAX: ffffffff83fc1bd5 RBX: 0000000000000000 RCX: ffff88801ce1ca80
RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 00000000ffffffef
RBP: 00000000ffffffef R08: ffff88801ce1ca80 R09: 0000000000000002
R10: 00000000ffffffef R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880418a0000 R14: ffff8880121a2400 R15: 1ffff11008314002
FS:  00007f1f1e0126c0(0000) GS:ffff88808c894000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055697aa6da80 CR3: 000000001f443000 CR4: 0000000000352ef0


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
