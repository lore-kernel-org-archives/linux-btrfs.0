Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA04A23
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 12:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130525; cv=none; b=m7DV8cCARcoVfv47oXrktfuvMn4NydKWpcf/GJO8h0EAoyrtSqvE0OWleHbAiF8i5+EPVEFD4FAZj4RWjFOSMQzzcELMX59zBv8cHSLeeWIU6jm4p9L992LIbZnfOem5OhdU6qRI1+TWXPyg0baa4tNtQNoDo1IQQDxR/559cEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130525; c=relaxed/simple;
	bh=Zu4rer59LPl1z3PxQxhlPJ/hOA8fx93qfSSZ4HNu90U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TwWG7NmdowNWJGzfkb+CBda5XEdG//q8Z2Bn5QbeSFrtPU/KR01nZYPr4uGWCK6yzSE9LFnennj9lPlu1vqtRNy7TM25sjGCzNhCczIjTNEKM3WjfEafJEGMaWI6lLacedNRosOY6TGrdRizA2pQ+mywxLuDadxs9S8BpzB8OJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-48e5de5a23cso448456b6e.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 05:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782130523; x=1782735323;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NG4MDUMX1ixV9VQjV+6OX8VhzP/PSPnyFIA443/ypi0=;
        b=DjGZbaCYqmKIEJ8adMq7lTHpMiAG1UH3d858UZrNJuaTa9eeaNzlrMc8JistgGd+d2
         /AtrbL6zSa5R8tfp5V9TT5XCzkiSVdRTv/MEjc24kjBG6lHuoCq/EI2FNZmA5e4eQ/u9
         5+xgJe4Y79+0iesBAEkAwXQVOjNFk0dSN8pxFTPvDTDoLH10WXd/o1PeitgatcZCbvTG
         UCFO5uhfyOvN5Gq0QvwB38g+P6RkG7XCco295i5HgDiQeOJJKQLxU0lY/Ph2Mt24ufCp
         UzXuuFE5f8k/C2xXgNoHuOA9hOaBAdzRuUX0bhYVeHgsJOK0sxL+cCkDwg0IEVSG91/r
         vyWw==
X-Forwarded-Encrypted: i=1; AFNElJ+g99SObGdqSAqz6Px+jDYJ0hh8pGeHpBC0gv9g547CJo5Roh1Mwnc9jClRnZS9lUwRTBegg+QdhQVHiQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv2T6iBSlGyBvoiJeGTlQH6NFB19GB0h+AowWiaSzJqC4isxEY
	2oillVdJ55VUEJYCsNyzpBI3yJRLHdmOuok8kbhbDwHRSEbzP+ucNJbkCqEHuFNgf/0zlvi8nTA
	z6Qkb0Ah6g6eZD9l29K0meQyO9OX6OrmWMHQwQiS//iN8RU+ScMyo2Yr80is=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:50a0:b0:479:dcb1:dcf8 with SMTP id
 5614622812f47-489b0f976f1mr14927999b6e.29.1782130523495; Mon, 22 Jun 2026
 05:15:23 -0700 (PDT)
Date: Mon, 22 Jun 2026 05:15:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a39275b.5031c61f.34f2da.0001.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in btrfs_alloc_ordered_extent
From: syzbot <syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1a3746ccbb0a Merge tag 'strncpy-removal-v7.2-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b76bd2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9519196b0a0d47bc
dashboard link: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1132d7b6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d74555c02bc2/disk-1a3746cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8ba08fd52fd4/vmlinux-1a3746cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/daed17e06386/bzImage-1a3746cc.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/b45f0a44ace9/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1048caae580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/c015b75738a7/mount_17.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=157292ae580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com

BTRFS critical (device loop5): panic in insert_ordered_extent:264: overlapping ordered extents, existing oe file_offset 32768 num_bytes 430080 flags 0x1089, new oe file_offset 32768 num_bytes 430080 flags 0x80 (errno=-17 Object already exists)
------------[ cut here ]------------
kernel BUG at fs/btrfs/ordered-data.c:264!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 6463 Comm: syz.5.32 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:insert_ordered_extent fs/btrfs/ordered-data.c:261 [inline]
RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0 fs/btrfs/ordered-data.c:336
Code: fb 8d ba 08 01 00 00 b9 ef ff ff ff 49 c7 c0 20 95 17 8c 4d 89 f9 ff 75 00 41 54 41 55 41 56 53 e8 e2 80 2e fd 48 83 c4 28 90 <0f> 0b e8 36 2f ca fd 48 c7 c7 80 8c 17 8c 48 c7 c6 e0 8c 17 8c 48
RSP: 0018:ffffc90004cbe890 EFLAGS: 00010296
RAX: fbe9776bb6e42800 RBX: 0000000000069000 RCX: 1ffff92000997cf0
RDX: 0000000000000000 RSI: ffffffff8c295400 RDI: ffff888035451f00
RBP: ffff888055183ca0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1cfca14 R12: 0000000000069000
R13: 0000000000008000 R14: 0000000000001089 R15: 0000000000008000
FS:  00007f4d802736c0(0000) GS:ffff888125253000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6fbd9eed90 CR3: 0000000075aa9000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 cow_one_range fs/btrfs/inode.c:1241 [inline]
 cow_file_range+0x744/0x12a0 fs/btrfs/inode.c:1403
 fallback_to_cow+0x5ea/0xa00 fs/btrfs/inode.c:1751
 run_delalloc_nocow+0x110c/0x17a0 fs/btrfs/inode.c:2181
 btrfs_run_delalloc_range+0xbe4/0x1c20 fs/btrfs/inode.c:2419
 writepage_delalloc+0x104d/0x1ba0 fs/btrfs/extent_io.c:1558
 extent_writepage fs/btrfs/extent_io.c:1930 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2593 [inline]
 btrfs_writepages+0x1667/0x28b0 fs/btrfs/extent_io.c:2725
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 filemap_writeback mm/filemap.c:388 [inline]
 filemap_fdatawrite_range+0x1ef/0x2f0 mm/filemap.c:413
 btrfs_fdatawrite_range+0x54/0xf0 fs/btrfs/file.c:3884
 btrfs_direct_write+0x69d/0xc20 fs/btrfs/direct-io.c:1038
 btrfs_do_write_iter+0x325/0x790 fs/btrfs/file.c:1449
 do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
 vfs_writev+0x343/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d7f39ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d80273028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f4d7f616270 RCX: 00007f4d7f39ce59
RDX: 0000000000000001 RSI: 0000200000000240 RDI: 0000000000000004
RBP: 00007f4d7f432e6f R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000007000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d7f616308 R14: 00007f4d7f616270 R15: 00007fff80ba6368
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:insert_ordered_extent fs/btrfs/ordered-data.c:261 [inline]
RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0 fs/btrfs/ordered-data.c:336
Code: fb 8d ba 08 01 00 00 b9 ef ff ff ff 49 c7 c0 20 95 17 8c 4d 89 f9 ff 75 00 41 54 41 55 41 56 53 e8 e2 80 2e fd 48 83 c4 28 90 <0f> 0b e8 36 2f ca fd 48 c7 c7 80 8c 17 8c 48 c7 c6 e0 8c 17 8c 48
RSP: 0018:ffffc90004cbe890 EFLAGS: 00010296
RAX: fbe9776bb6e42800 RBX: 0000000000069000 RCX: 1ffff92000997cf0
RDX: 0000000000000000 RSI: ffffffff8c295400 RDI: ffff888035451f00
RBP: ffff888055183ca0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1cfca14 R12: 0000000000069000
R13: 0000000000008000 R14: 0000000000001089 R15: 0000000000008000
FS:  00007f4d802736c0(0000) GS:ffff888125253000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6fbd9eed90 CR3: 0000000075aa9000 CR4: 0000000000350ef0


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
