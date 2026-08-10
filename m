Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC949620
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786320755; cv=none; b=X/nF6Eu2nEDaNF7xqnI3xsiNAbti1LB/JPmdBmpPJNb5Il6kOx8whupQZk1zlGv22A37O1WWVHCOHq1lv27k9TrTbnGmcbCAgChTpb9YCi3d78uVwUTnERodOm2ZIgjhRts5ciiKBCkzyrgY5uv5Hgc46V9smPXWOQOQH4cX6Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786320755; c=relaxed/simple;
	bh=4xurSwU0cAmSIfKEi6AOScHUqhMi5MjKmiuvcuQk9JE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EYSDSNF48IZLuBNLu+OjwwwsKzrd80fHd6kTHzWePkzgRlIwtSF08eKnIq03vTW85bKe5W0salTCtfT1xUBmZUsTJ7hH2EL3RrWkPkJRI0Qj4tV7Vb9rONgh3zSmYk233HupJBkOr5k2DKUbi9U3ay3UHhXa0FKRovsdxBrrATM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4b1a69b1188so1760714b6e.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 17:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786320752; x=1786925552;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gwlsc5IwhwT8WhzudQjXDbDhJ08HU0n1lZYdDeLgus=;
        b=WrCjd3QYpi4vIGycmd98LSYnk2JZp77Ca0cTgzo37VrIyEko19wKKLFFnLMiZCdhTP
         d01MAzEUYcBsQcJ4OlfkzMSNTt/+TI6oQK+AcUcSYP65ycoWZqAxtbPBeYwqHHCayapr
         sAHCYjnNQw9T3+GvH/WbSaBwe84oqiAR7hqfOTCZv5y/evgJX71DKaLOCHW1+OrW8sRb
         wqTIwGr0vIyzIzlxxLBY5mtohQNO1+D/2RVmU5xNmO2kfDA0GH9SW52DcYKOqa/jLZ/L
         GSOiHBBFQ6cE1byb+ZgY+272fCJb0Jvz5tITtHZIcVl43G+RgbFfY8oGLLtn6gQRR8yw
         jhnQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqyA3L3RoXf/n3dVXB86AbnjLg2jdMGhvkdh2gNK9gLQzM0OIQlQ/N2bLJSvADA6pcJ/Id715peQ1dOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YznOe2Si/5BMlgh6o8dauTMlXieik23xcHqNhoFLSyud6lGzEvr
	n1E13nnz3swQgnr4s7qGvGOt4hM1mbJewhKdw3U1YZcpRQ3Id/WxKcircBtEwDyBrJv6FnTLjW9
	PusiGeryRVQlGxVFcTmrjzExt8f/LOnpBYVdsHhb/LZG++U7r6Xxzch85Zr0=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:120e:b0:489:93ff:9ea0 with SMTP id
 5614622812f47-4afadf22b65mr20995133b6e.2.1786320752584; Sun, 09 Aug 2026
 17:12:32 -0700 (PDT)
Date: Sun, 09 Aug 2026 17:12:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a791770.01d0871a.3a0d52.0097.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_create_new_inode (3)
From: syzbot <syzbot+c1b8c52e6c0142c5e448@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1689be32580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=c1b8c52e6c0142c5e448
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2425c07b5d46/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cf278dd14da3/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c1b8c52e6c0142c5e448@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/inode.c:6576 at btrfs_create_new_inode+0x1ddc/0x1ee0 fs/btrfs/inode.c:6576, CPU#0: syz.0.0/5350
Modules linked in:
CPU: 0 UID: 0 PID: 5350 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_create_new_inode+0x1ddc/0x1ee0 fs/btrfs/inode.c:6576
Code: 00 00 00 83 fb f4 0f 85 e8 00 00 00 e8 6d 8d b3 fd e9 e7 00 00 00 e8 63 8d b3 fd eb 10 e8 5c 8d b3 fd eb 09 e8 55 8d b3 fd 90 <0f> 0b 90 89 d9 f7 d9 e9 b8 f8 ff ff e8 43 8d b3 fd eb 10 e8 3c 8d
RSP: 0018:ffffc9000e4676c0 EFLAGS: 00010287
RAX: ffffffff8413956b RBX: 00000000ffffffe4 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 000000000000106b RDI: 000000000000106c
RBP: ffffc9000e4678f0 R08: ffff888032e5ca80 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: ffff888052814640
R13: ffff888042f14610 R14: 00000000ffffffe4 R15: ffff88805203c001
FS:  00007f21d3c956c0(0000) GS:ffff88808c540000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000380000 CR3: 000000003ecc1000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_create_common+0x189/0x310 fs/btrfs/inode.c:6803
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
RIP: 0033:0x7f21d2d9e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f21d3c94fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f21d3026180 RCX: 00007f21d2d9e019
RDX: 000000000000275a RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007f21d2e3500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f21d3026218 R14: 00007f21d3026180 R15: 00007ffd6a122ff8
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
