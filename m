Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D708291C10
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539111; cv=none; b=icVp60++ifwpAy7CJNLZGbkFoKtcG/lJJcJ+qWfpXBQpWFc5P1a/oxiZPXydNQWQE2+pu0r85zT0DNkl+UAaJMrbD8EJbcCLFwfvRMnoVa6kd2yZe8sH5btJaM/MqN+6wqpKoCc/o8omGjReFvb6M8aWEr1i8Mx+R6khBQt89og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539111; c=relaxed/simple;
	bh=OjSlO7L/47/oCEhL5nfm2cuZjo/rGLmL1KAsnWVmuMc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qYsQpnt8WZtjEsxI6VsROK6sYijGgNwDFbQZS64YFholb+6AK4GKyAFNWfQzsTz8Mh6D7b8cW/mYYqBFI9xTF6xWi4WoNty1V82ekuMF3MeiOdFiu46dXfHspnM/2LrMUdqqg4fwkgrrj7stBe4/ZVa3P3poqqeAazxX9kYe3gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4a46a76f236so1825016b6e.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 02:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539109; x=1785143909;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5N8a9xJAEh3ZFvP5fC1UnjnIGPW/J8eDuSUC835aYp4=;
        b=qHJ8DDBtxfifgqCa5CTkPipMzovzm8k8Pf0HUIH9vncF/bBgbRlai7YZZpuXtUNzQF
         fVt2Mh81bbegLQvjxoPondKdsSGXq1/MX3+4GI+IPf7ipY2gD/J0qw96dytkz3Ld2UII
         amH6HxFJIA8RMwMjZ1/sjQZuGru+jIMqmovRvI4umkq4M2xPRWv8UUqlSRfufJ03EVgO
         SKG90mWwYZftwCdAuc5HuCgpl457jh/oLS3sq2+FR7QK1nXp4wEdcmTEIuz0o5Ywnx+7
         1sLQNfYtHp8t4iRmJxi4OY6ixebxH6Si3mK9VGZZPPS7EAX+CqkDQutP8at9NTadTFOX
         5Z+A==
X-Forwarded-Encrypted: i=1; AHgh+RrIVYceZ3WN52CmamP28TG5/bEfnTOHmkLjDrRz8VJ7AHDCLPAThYNcopuFLBzhDa2p6omwS1kXtpNwbg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9gzEWR6F9cexDZPHy/uEcl+9H2tZHtaihZOOZTkfGNABmFXFq
	tetPV2wZF5uQIdhF2p2wAaC3iUAYgH3iHr4TBLP0VJ8+1Y3IQAHQrGwowuK753CzEjgWbSrWmeK
	zAUIldsnvcllrTprPTrFiyXO0nNO1IRgWYq/c9AzKRHUBjNAZ+i8u3O/r8hk=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fde:b0:497:dedc:605c with SMTP id
 5614622812f47-4a4d01f0c8cmr9230992b6e.7.1784539109035; Mon, 20 Jul 2026
 02:18:29 -0700 (PDT)
Date: Mon, 20 Jul 2026 02:18:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5de7e5.f1649fcc.2a4208.052f.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in radix_tree_tag_set
From: syzbot <syzbot+edbd404a2566556eed08@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    37e2f878a7a6 Merge tag 'linux_kselftest-kunit-fixes-7.2-rc..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13878b46580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=98da55a882774dfe
dashboard link: https://syzkaller.appspot.com/bug?extid=edbd404a2566556eed08
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fe4eac79f31b/disk-37e2f878.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3befde5dfc88/vmlinux-37e2f878.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6e5c89a0b86b/bzImage-37e2f878.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+edbd404a2566556eed08@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at lib/radix-tree.c:974!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 1429 Comm: kworker/u8:10 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/25/2026
Workqueue: btrfs-endio-write btrfs_work_helper
RIP: 0010:radix_tree_tag_set+0x3ff/0x410 lib/radix-tree.c:974
Code: c7 c7 20 10 96 8f 48 8b 14 24 e8 ac 26 c2 f9 e9 dc fe ff ff e8 12 3b 88 f6 90 0f 0b e8 0a 3b 88 f6 90 0f 0b e8 02 3b 88 f6 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc900063376e0 EFLAGS: 00010293
RAX: ffffffff8b3cfd8e RBX: 0000000000000005 RCX: ffff88802924be00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e1c3000 R12: ffff88805e3fc188
R13: 1ffff110072500c4 R14: 0000000000000000 R15: ffff888065c981f8
FS:  0000000000000000(0000) GS:ffff888125c49000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8125d8a6b0 CR3: 0000000053ae4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 record_root_in_trans+0x23a/0x330 fs/btrfs/transaction.c:437
 btrfs_record_root_in_trans+0x15a/0x180 fs/btrfs/transaction.c:508
 start_transaction+0x3a4/0x1880 fs/btrfs/transaction.c:794
 btrfs_finish_one_ordered+0x8bb/0x1f00 fs/btrfs/inode.c:3077
 btrfs_work_helper+0x338/0xc30 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:radix_tree_tag_set+0x3ff/0x410 lib/radix-tree.c:974
Code: c7 c7 20 10 96 8f 48 8b 14 24 e8 ac 26 c2 f9 e9 dc fe ff ff e8 12 3b 88 f6 90 0f 0b e8 0a 3b 88 f6 90 0f 0b e8 02 3b 88 f6 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc900063376e0 EFLAGS: 00010293
RAX: ffffffff8b3cfd8e RBX: 0000000000000005 RCX: ffff88802924be00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e1c3000 R12: ffff88805e3fc188
R13: 1ffff110072500c4 R14: 0000000000000000 R15: ffff888065c981f8
FS:  0000000000000000(0000) GS:ffff888125c49000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8125d8a6b0 CR3: 0000000053ae4000 CR4: 00000000003526f0


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
