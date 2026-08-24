Received: from mail-oi2-f4.google.com (mail-oi2-f4.google.com [74.125.231.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E481D405C3F
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 11:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787569714; cv=none; b=LZOWpRPx17hLj65Tcinj9tZ5TFrjL/JN9n0bAMwcjVHM/LApwYmoLjWhVQiXEvyxPkISCqm2eG95PU5nwClxDRVt6uzOZXMSdeHFXng+2EbREQ1ntgTDs71dwSTuTdgiuHzrCC0ADo1z0HI7DpooR5w72TQeYYDH+RPcOAPEjtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787569714; c=relaxed/simple;
	bh=XD/PG/WVYbhu4Ksh7OG4LjO6tuzWxJRPPSpTQCEHPBY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SXwp3DT9pVmiBg+3gyNG20GU5oEXy175CSnPV3UQfgITgiTLZFFTpDwtRzZpXUvGuHC3DYq5ETs87fwJ8YemG/ov4T5OEOAuEKTMLpLIhECNXTipCMjuWlVTb5T0Det6qvwN8cPcA0uSKz7yb4iMyDgcE9AFND3M/tmBdbKqN04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f4.google.com with SMTP id 5614622812f47-4ab2d8e7e4cso897280b6e.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787569712; x=1788174512;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXjOa2kIi5woPpcq9gPtLpRqv4S2Lm9sh/EE410lHps=;
        b=dQScOS0xYd5hNEHSjpB3rG0aDmYLY3g/GJFxW1/mLO9Wfe7wPLry+CDjp9u9ZgRO8B
         ZJ9kDKwK9GP5AUwMGrFr3b05Wa8lOA+8gRVNEByRNmSrlTUeSFZn5KMts7J6lJdtBwY1
         8DUy7gcN8rUz/Ji2NB9d83TACVI3ls1BmMYL0iJ1fr3jkl9H1WQTlAVZIu1Dv8uPG4ux
         vB6BiFe1TldynBKxMi2SdStYevZoqu6PAUFu94n3ri6gwV0GNXfo24mlXYJ/0frKOtWk
         Szl357oq2CQkrSFQ3h4+o1Ps4fUhqUiEl93hdX9X7HLzr2qTniRS1HD2qUP1rweoXw33
         9HPg==
X-Forwarded-Encrypted: i=1; AHgh+RpeyaCb8PRufHmj0gM+8Dr76xBBp3d1FkTp+6+Z5AquRAv7fU2l9H+DsAGJvfkgD9T8yBOT3RGZ18zO+g==@vger.kernel.org
X-Gm-Message-State: AFuF++ks/y7vKC9WzAoiN6IwigeQEk3p5RCPFu7JKnRmQYB2GKycEbe0
	+7R/evm0ghtFev8OcsP0RYzTqXYikL8Kyk2fHUnRAPjqvKqLUgXbjyWft3Kke5yvzHlKxpDerg9
	ddjVcc0U3nmLIFeyBQ71YPQ7tD4prN5aNNUkhMcV55Ns5pqWi3/pj0S0ESaE=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:124d:b0:489:a387:1e29 with SMTP id
 5614622812f47-4b2ef4eeeb6mr22129435b6e.20.1787569711870; Mon, 24 Aug 2026
 04:08:31 -0700 (PDT)
Date: Mon, 24 Aug 2026 04:08:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8c262f.dbb3a75c.7844.0002.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in btrfs_subpage_assert
From: syzbot <syzbot+d490d04560554e6259b9@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a4ff2be345d0 Merge tag 'v7.3-p1' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e1f815580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfcda1d4ca446c80
dashboard link: https://syzkaller.appspot.com/bug?extid=d490d04560554e6259b9
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a4ff2be3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0a03ffb73f4e/vmlinux-a4ff2be3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/27503648559b/bzImage-a4ff2be3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d490d04560554e6259b9@syzkaller.appspotmail.com

assertion failed: folio_test_private(folio) && folio_get_private(folio), in fs/btrfs/subpage.c:153
------------[ cut here ]------------
kernel BUG at fs/btrfs/subpage.c:153!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5316 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_subpage_assert+0x43f/0x4e0 fs/btrfs/subpage.c:153
Code: ae 8b fd eb 05 e8 e1 ae 8b fd 48 c7 c7 80 4d 3b 8c 48 c7 c6 20 53 3b 8c 48 c7 c2 20 4e 3b 8c b9 99 00 00 00 e8 f2 53 ec fc 90 <0f> 0b e8 ba ae 8b fd 4c 89 ff 48 c7 c6 80 54 3b 8c e8 eb b2 ec fc
RSP: 0018:ffffc9000e34f438 EFLAGS: 00010246
RAX: 0000000000000062 RBX: 0000000000000000 RCX: 8237ef3e22428900
RDX: ffffc90020001000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffea000039f800 R08: ffffc9000e34f1c7 R09: 1ffff92001c69e38
R10: dffffc0000000000 R11: fffff52001c69e39 R12: 1ffffd4000073f01
R13: ffff88804340c000 R14: 1ffffd4000073f00 R15: ffffea000039f800
FS:  00007fc1fc8ed6c0(0000) GS:ffff88808c526000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8aebf44cf0 CR3: 0000000012f73000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_subpage_set_fixup_dirty fs/btrfs/subpage.c:528 [inline]
 btrfs_folio_set_fixup_dirty+0x475/0xc70 fs/btrfs/subpage.c:567
 btrfs_data_dirty_folio+0x1c7/0x240 fs/btrfs/inode.c:10763
 bio_set_pages_dirty+0x372/0xa70 block/bio.c:1681
 __blkdev_direct_IO+0x81f/0xf30 block/fops.c:247
 blkdev_direct_IO+0x122e/0x17a0 block/fops.c:435
 blkdev_read_iter+0x223/0x420 block/fops.c:816
 aio_read+0x33a/0x4d0 fs/aio.c:1656
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x774/0x13d0 fs/aio.c:2106
 __do_sys_io_submit fs/aio.c:2165 [inline]
 __se_sys_io_submit+0x195/0x340 fs/aio.c:2135
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc1fb99e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc1fc8ecfe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fc1fbc26090 RCX: 00007fc1fb99e0d9
RDX: 00002000000000c0 RSI: 00000000000000ca RDI: 00007fc1fc8cc000
RBP: 00007fc1fba35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc1fbc26128 R14: 00007fc1fbc26090 R15: 00007ffeb5334bc8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btrfs_subpage_assert+0x43f/0x4e0 fs/btrfs/subpage.c:153
Code: ae 8b fd eb 05 e8 e1 ae 8b fd 48 c7 c7 80 4d 3b 8c 48 c7 c6 20 53 3b 8c 48 c7 c2 20 4e 3b 8c b9 99 00 00 00 e8 f2 53 ec fc 90 <0f> 0b e8 ba ae 8b fd 4c 89 ff 48 c7 c6 80 54 3b 8c e8 eb b2 ec fc
RSP: 0018:ffffc9000e34f438 EFLAGS: 00010246
RAX: 0000000000000062 RBX: 0000000000000000 RCX: 8237ef3e22428900
RDX: ffffc90020001000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffea000039f800 R08: ffffc9000e34f1c7 R09: 1ffff92001c69e38
R10: dffffc0000000000 R11: fffff52001c69e39 R12: 1ffffd4000073f01
R13: ffff88804340c000 R14: 1ffffd4000073f00 R15: ffffea000039f800
FS:  00007fc1fc8ed6c0(0000) GS:ffff88808c526000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9601fb6b0 CR3: 0000000012f73000 CR4: 0000000000352ef0


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
