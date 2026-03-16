Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4AB25228D
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773668431; cv=none; b=F3ZWaYgcp1/9RVJ2zIQCrjbUV++Kwg8SZGNP2ANQRDzTlGpfWXE/CXCdGkKtLVY9odV0RfoPvMw4LYLybRfwBj9VF+kDEi4HV4HvfmW1aB9qYgeydV2H0w/003NVaO0Q0gkMxu7rWEDok60NEjJdRmTz3K+E7PKjntguevgP2hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773668431; c=relaxed/simple;
	bh=p+3P4JUs1V4+xxqxPwpAMJrV8uAlwDsvwMYrAzcRoT8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eWmffuL/l8DKCeWUx150ymUT60uX2Xzq0iNhzg1yjSlTLWzkGpU13NqFKGMLznHn9IZDzsV5PEr05B31CMAYk9hwBG9kFyV8rAoR0D5MMs9jryjGSCxEDgDMy2Cs6JRwhGgBExwrTqW/2FI/dTIQXRC327sH0NeKFToN12m15eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d753cb3174so44224585a34.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 06:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773668429; x=1774273229;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lpYOf3euST0B9M0VgPqc0cDSB6qYsqLMk5rOtkx0oMI=;
        b=o9akyXyFqnLYPL11SGsAjhmgu/bn1hZY0hTq285pjo23V4FZJ5lFS0GcuxOnf+8rzY
         Wvj2XFkWk6m60Fe3oMIAlB1xlztfbfogYQ43s3uD23r/B9PHQ8MDQt9uRz3pA2O9yMzv
         nbUuh3IdVfBkjfRi40RUn0fPdx6h8z6scTvDmnZg4v0UQx63vKNGynfgCDNI8NpXhBHn
         Qesr/vlhUVecvzWYm7ty18HH0RD/RVNxzvFnsq0Ukt2z+erH+a/lyTi3Q8Knl+CStqxw
         uZEGu3XikkCGdjOzEORTFNT5KwwrsQQp+U3EZorsnHHbtjQSSEP08DRcQfXiDpj378z5
         K19Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPTpGkgiu5LhN2SBs8flsK7bZbO4V3IZ4SHv/1R0ior8BtWEzXsYdjAelidBHGvNgx1nqqDEpHqZPbjA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4PTUztoullRcFgxSuEqh8mOn0o8keBk7Ecoym0a2V+Sx8SrBM
	qd51NEtV548eMqWK9JN0YNm2cAKfLInoSBT7qVCG3A5imWsotWPAZMlXpE9ySwX0YhpYlz7hCsR
	Timtz60NEKuksNPPVeaKdn844gyWTc290qwOxF/gu0SrqFWsmtzL70rWvbq4=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:d809:0:b0:67b:e4a1:9e66 with SMTP id
 006d021491bc7-67be4a1a48amr5629775eaf.22.1773668428853; Mon, 16 Mar 2026
 06:40:28 -0700 (PDT)
Date: Mon, 16 Mar 2026 06:40:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b8084c.050a0220.248e02.0115.GAE@google.com>
Subject: [syzbot] [btrfs?] BUG: corrupted list in btrfs_free_compr_folio
From: syzbot <syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f338e7738378 Linux 7.0-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15265602580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
dashboard link: https://syzkaller.appspot.com/bug?extid=3c4d8371d65230f852a2
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f338e773.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2567fb35ebfb/vmlinux-f338e773.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f9124de81ddb/bzImage-f338e773.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c4d8371d65230f852a2@syzkaller.appspotmail.com

list_add double add: new=ffffea00010a8488, prev=ffffffff9a43a948, next=ffffea00010a8488.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:37!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 1045 Comm: kworker/u4:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: btrfs-delalloc btrfs_work_helper
RIP: 0010:__list_add_valid_or_report+0xa5/0x130 lib/list_debug.c:35
Code: 74 12 b0 01 5b 41 5c 41 5d 41 5e 41 5f 5d e9 12 c6 f8 06 cc 48 c7 c7 e0 d7 27 8c 4c 89 fe 4c 89 f2 48 89 d9 e8 5c 49 6d fc 90 <0f> 0b 48 c7 c7 c0 d5 27 8c e8 4d 49 6d fc 90 0f 0b 48 c7 c7 80 d6
RSP: 0018:ffffc90000d6f800 EFLAGS: 00010246
RAX: 0000000000000058 RBX: ffffea00010a8488 RCX: 9af6677df2ed2e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 1ffffd4000215092 R08: ffffc90000d6f587 R09: 1ffff920001adeb0
R10: dffffc0000000000 R11: fffff520001adeb1 R12: 1ffffffff3487529
R13: dffffc0000000000 R14: ffffffff9a43a948 R15: ffffea00010a8488
FS:  0000000000000000(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e37eb87168 CR3: 0000000041bd8000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:96 [inline]
 __list_add include/linux/list.h:158 [inline]
 list_add include/linux/list.h:177 [inline]
 btrfs_free_compr_folio+0x1e1/0x340 fs/btrfs/compression.c:218
 cleanup_compressed_bio fs/btrfs/compression.h:150 [inline]
 btrfs_compress_bio+0x35a/0x6b0 fs/btrfs/compression.c:1047
 compress_file_range+0x8df/0x19b0 fs/btrfs/inode.c:1023
 btrfs_work_helper+0x38c/0xc80 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid_or_report+0xa5/0x130 lib/list_debug.c:35
Code: 74 12 b0 01 5b 41 5c 41 5d 41 5e 41 5f 5d e9 12 c6 f8 06 cc 48 c7 c7 e0 d7 27 8c 4c 89 fe 4c 89 f2 48 89 d9 e8 5c 49 6d fc 90 <0f> 0b 48 c7 c7 c0 d5 27 8c e8 4d 49 6d fc 90 0f 0b 48 c7 c7 80 d6
RSP: 0018:ffffc90000d6f800 EFLAGS: 00010246
RAX: 0000000000000058 RBX: ffffea00010a8488 RCX: 9af6677df2ed2e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 1ffffd4000215092 R08: ffffc90000d6f587 R09: 1ffff920001adeb0
R10: dffffc0000000000 R11: fffff520001adeb1 R12: 1ffffffff3487529
R13: dffffc0000000000 R14: ffffffff9a43a948 R15: ffffea00010a8488
FS:  0000000000000000(0000) GS:ffff88808ca55000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e37eb87168 CR3: 0000000041bd8000 CR4: 0000000000352ef0


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
