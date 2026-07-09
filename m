Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985B43FC5CF
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 08:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783587096; cv=none; b=DmJ4nwgIBzRWrx7mWwB2IxoHHaq2Rcsiber/KNGeThuSPovA78JxeW3dIX0nvIGTGMWLngAjV4e56q1SKqnYOlV/xbRKuxScTwcCx1qbg5JWRbAM2qK3B2EsP9aZWoJg0zbARK7RvajPQbKshNmdM1KC0YiWFrdg4IqQ/TYso58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783587096; c=relaxed/simple;
	bh=te08C2vx+KvThW6ffohUinAE6+eq8yyYofp9TjpJ21U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PNybjH9vS2TuyGa+Zt8pP809DPFhz6Y7UCpA0667or2EnKs/ySQvTACewDRaBIcyXAhxybDRO7kln+Q+pKf2eQDemmgKMBDL0x9afyKecQxIHmWsHPhonfAv/mI+Zfzvc+93rspjpFJcz5Ty4cmktXdkjWiL9qHdM4izuzHoNKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-486cc29e03bso2217125b6e.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 01:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783587093; x=1784191893;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=togPLseL/1g0g45PaR6/QjXdyoU0ON4xTlr/BXJcnKw=;
        b=QohKGwuKqQrYXou/MQlTJde+JzIrS81JAy3Hx/vdjQZsUewwk6raUR4WfnECBcxMd9
         95D0qYBmUlkuo4ZKWau7C81hKM7u9XD9Pc7fcCvKWQMtVPc372cCEPuuJ7VT0VW1R5Nz
         MDtjUwNsQuhdYGOOz9TRX+MmhTfbooDrMD9vd8lEJQ4y1+HbmjLNLZzjhaUnsfQubDKE
         3AiDnWV3t2qz/mnUKUYKep0uUF/+LHUAXDrEHgckbDqwo7QCA6qZckY/vf6yz3RkFiNX
         +2Qn3w1mr6IGLJ2i/nyKESW7zRhOaj5L6YE+jUQue5sdjEWwI6KvUvpfTekKF5O49ybL
         qyvg==
X-Forwarded-Encrypted: i=1; AFNElJ9IgAmfRK6OtXqFYS+oq0Jn7DBMPXicqLeNQDu1Wa3/uM4hwS8NhoJf4stW2JsG36k2zV+sFJwtXIrnGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe2CLpnu+GU+oHbYvEHErpr7+Fc9tVjY2wDwDz1HHtamaCEAeR
	MKeLzmdvbqgmbKP8VRrosAeszsiwzHoqOku7DgrOSM0PrsUXMI39CPaKmHqFDAsPanab3gXq2lH
	JJhte6ltQBXQaRsT4AvarojcGt6jwXrA4QDlZeYbO1Ax+9vPIwFo6llgvE5s=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:120e:b0:495:fa8f:6ddb with SMTP id
 5614622812f47-4a205514485mr5893488b6e.28.1783587093730; Thu, 09 Jul 2026
 01:51:33 -0700 (PDT)
Date: Thu, 09 Jul 2026 01:51:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4f6115.57639fcc.86d58.001c.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in create_reloc_root
From: syzbot <syzbot+aca623fc25065fa06615@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7404ce516372 Merge tag 's390-7.2-3' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145075dc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=aca623fc25065fa06615
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-7404ce51.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3c0f4563b500/vmlinux-7404ce51.xz
kernel image: https://storage.googleapis.com/syzbot-assets/320dddfc3ad1/bzImage-7404ce51.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aca623fc25065fa06615@syzkaller.appspotmail.com

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5321 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40c/0x560 lib/fault-inject.c:174
 should_failslab+0xa8/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4567 [inline]
 slab_alloc_node mm/slub.c:4925 [inline]
 __kmalloc_cache_noprof+0xa8/0x660 mm/slub.c:5511
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 __add_reloc_root+0x75/0x4e0 fs/btrfs/relocation.c:577
 btrfs_init_reloc_root+0x3d6/0x590 fs/btrfs/relocation.c:800
 record_root_in_trans+0x27c/0x330 fs/btrfs/transaction.c:462
 btrfs_record_root_in_trans+0x15a/0x180 fs/btrfs/transaction.c:508
 start_transaction+0x3a6/0x18b0 fs/btrfs/transaction.c:794
 create_snapshot fs/btrfs/ioctl.c:795 [inline]
 btrfs_mksubvol+0x8c6/0x10c0 fs/btrfs/ioctl.c:887
 btrfs_mksnapshot+0xa3/0xe0 fs/btrfs/ioctl.c:929
 __btrfs_ioctl_snap_create+0x45d/0x6b0 fs/btrfs/ioctl.c:1191
 btrfs_ioctl_snap_create_v2+0x1e9/0x370 fs/btrfs/ioctl.c:1261
 btrfs_ioctl+0x8eb/0xd50 fs/btrfs/ioctl.c:-1
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc6fe59de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc6ff51bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc6fe826090 RCX: 00007fc6fe59de59
RDX: 0000200000002480 RSI: 0000000050009417 RDI: 0000000000000005
RBP: 00007fc6ff51c050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007fc6fe826128 R14: 00007fc6fe826090 R15: 00007ffc03132988
 </TASK>
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/relocation.c:735 at create_reloc_root+0x9d2/0xb80 fs/btrfs/relocation.c:735, CPU#0: syz.0.0/5321
Modules linked in:
CPU: 0 UID: 0 PID: 5321 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:create_reloc_root+0x9d2/0xb80 fs/btrfs/relocation.c:735
Code: 25 10 f8 f8 43 c6 44 25 12 f8 49 c7 c7 8b ff ff ff e9 69 fd ff ff e8 0d e2 9e fd eb 10 e8 06 e2 9e fd eb 09 e8 ff e1 9e fd 90 <0f> 0b 90 44 89 f9 f7 d9 49 bc 00 00 00 00 00 fc ff df e9 36 fe ff
RSP: 0018:ffffc900058575e0 EFLAGS: 00010293
RAX: ffffffff8427a091 RBX: ffff888052cd0001 RCX: ffff88801aeaca80
RDX: 0000000000000000 RSI: ffffffff8f1e83a0 RDI: 00000000ffffffef
RBP: ffffc90005857740 R08: ffff88801aeaca80 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff92000b0aec4 R14: ffff888043f5b378 R15: 00000000ffffffef
FS:  00007fc6ff51c6c0(0000) GS:ffff88808c54e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000003000 CR3: 0000000042b25000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_init_reloc_root+0x2f0/0x590 fs/btrfs/relocation.c:792
 record_root_in_trans+0x27c/0x330 fs/btrfs/transaction.c:462
 btrfs_record_root_in_trans+0x15a/0x180 fs/btrfs/transaction.c:508
 start_transaction+0x3a6/0x18b0 fs/btrfs/transaction.c:794
 btrfs_create_common+0x15c/0x310 fs/btrfs/inode.c:6797
 lookup_open fs/namei.c:4508 [inline]
 open_last_lookups fs/namei.c:4608 [inline]
 path_openat+0x133a/0x3830 fs/namei.c:4860
 do_file_open+0x23e/0x4a0 fs/namei.c:4892
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_openat fs/open.c:1390 [inline]
 __se_sys_openat fs/open.c:1385 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1385
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc6fe59de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc6ff51bfe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fc6fe826090 RCX: 00007fc6fe59de59
RDX: 000000000000275a RSI: 0000200000000200 RDI: ffffffffffffff9c
RBP: 00007fc6fe633e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc6fe826128 R14: 00007fc6fe826090 R15: 00007ffc03132988
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
