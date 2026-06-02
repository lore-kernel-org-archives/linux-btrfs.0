Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195FB3E2ADD
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780409609; cv=none; b=oh5uDqxnqgPZGuqwwtp68jwN6QOjM7oInW/q0bPLKSgZ6vLFe20uekZhoou9GlKtgN0ELM9pcxXGztQtQaw4karEKLassD4G0LEm+Lv9GHEaWmKKoYPWYeeRrM3x/WC1G8YIKtCw0ABfhvzKg9kLofzQUimNzFtJTQNmklpG32o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780409609; c=relaxed/simple;
	bh=WbCFZnSi2FSNCAbvRDORd0PKY3Zm7kQTnqg+0Ks56+4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EWCSRblwLavSU/uA1vOp0fxmlEHAtydxspzlhcCz4pMhJyEF3zwpPuhPTASTz7ZOw4HsgqPPoTXHZqdpcBBE6VTOu6OZ+5rQro5zvBUycbBwXmRL0krjBGPBngW+M6xkNNYXFJoiE+BbBO95dkzYlDdIBklv3GBzYTXuFoSMljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69d8e718acbso13062249eaf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 07:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780409607; x=1781014407;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cj20YBJSdiyXTTx5MDb2PMmF3MBwkxjR6N7sz5j3VyM=;
        b=Ldp+skqSe4ecczI0xyW2REeC4pmMkWvap+4xJ0YLIdZLvL5NaBGdkm91ZJAtMt8jDT
         QJKtFCWm2xFJJxOkuyP2JMoYfs8i93hN9k3+BF09S/1cl9NQXsiomPQBiXZmuSj8W7f/
         EiAvJjQZgWg55tmDwpP1sVYB5fOeFebg7qjx3MiviBKx7hL2ucgUtivMur/ykcut6uoi
         8cgp2Je6RejNTRy8Hsb98D0UxqpK99/o4z8/OCAf4UVnYVv6+9rAg/l4mKpQzegOwi+8
         uvGObz81aVP0K86dRRNRCvlTZrtcMoBbhM82UV194yCCGHZWav70AWeLK4/JTor+0jgp
         OvGw==
X-Forwarded-Encrypted: i=1; AFNElJ8+6vq7GiHfenKPA7JaCUAY1z3yilMSQitMTv914XPQK/EHxWFRCZWXYWzqrx+RrmgQuy4AHLpV81ysdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW5AZBkyvhuF0dKGg7HzHZ/AxPn2QnqBz953RyFlRRKRqjKD6N
	zrZ7kSjTwpd/XZdQSBEMb5rV/CTM44V5RE0JgXq307bvImcMNjLswT9bgSxMegok0jsbtmpdB6Z
	u9bh4BpT+GnLpdgtElPZpZP178qPhQs7PSNKS3tYMFcqqh2dJbCA/FTrjxCE=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c87:b0:69d:b3af:c908 with SMTP id
 006d021491bc7-69e1053e91bmr8296346eaf.35.1780409607123; Tue, 02 Jun 2026
 07:13:27 -0700 (PDT)
Date: Tue, 02 Jun 2026 07:13:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1ee507.b4221f80.1326c5.0004.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_add_delayed_iput (3)
From: syzbot <syzbot+6a843bf8604711c8fab0@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8fde5d1d47f6 Merge tag 'acpi-7.1-rc6' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15af697e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd38685893011045
dashboard link: https://syzkaller.appspot.com/bug?extid=6a843bf8604711c8fab0
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7e05a6204e66/disk-8fde5d1d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bc2122f096ea/vmlinux-8fde5d1d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa9b3cad3a6c/bzImage-8fde5d1d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6a843bf8604711c8fab0@syzkaller.appspotmail.com

------------[ cut here ]------------
test_bit(BTRFS_FS_STATE_NO_DELAYED_IPUT, &fs_info->fs_state)
WARNING: fs/btrfs/inode.c:3596 at btrfs_add_delayed_iput+0x2e3/0x340 fs/btrfs/inode.c:3596, CPU#0: kworker/u8:10/1187
Modules linked in:
CPU: 0 UID: 0 PID: 1187 Comm: kworker/u8:10 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: btrfs-endio-write btrfs_work_helper
RIP: 0010:btrfs_add_delayed_iput+0x2e3/0x340 fs/btrfs/inode.c:3596
Code: 53 a3 45 fe 48 8b 3b 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d e9 dd a4 ad fd e8 48 78 de fd e9 f8 fd ff ff e8 3e 78 de fd 90 <0f> 0b 90 e9 52 fe ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 84
RSP: 0018:ffffc900065d77c8 EFLAGS: 00010293
RAX: ffffffff83e5f502 RBX: ffff88805aba0000 RCX: ffff888029768000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed100b574497 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff888061194788 R15: 0000000000000200
FS:  0000000000000000(0000) GS:ffff888126186000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe553a3f000 CR3: 00000000596c2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 btrfs_put_ordered_extent+0x18f/0x430 fs/btrfs/ordered-data.c:629
 btrfs_finish_one_ordered+0xf63/0x2680 fs/btrfs/inode.c:3433
 btrfs_work_helper+0x38b/0xc20 fs/btrfs/async-thread.c:312
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
