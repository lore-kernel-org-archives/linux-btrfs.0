Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F007A79CD
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785543941; cv=none; b=UnPN8fmQo5Um+JUnaktq9bPecYXtmHN20OQIT2ORxOwDM7Ou2TmIZTu9ubDlIATYUquFXv5y3uqq18q5YVwhZt1AeHQ73Cbzn7hTQbqYPH3GLEnwMiKz2oyUtKmjQ2Np8ZlG0uAYbap43Y6j4Tin9/Of9uE/YaPmVeQRndBLJ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785543941; c=relaxed/simple;
	bh=teS2M+Gr3NrnWJBamGACrt+abN/YxOlxendnBGbV/Mg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sWQpLgF9bsUVzJEqmuCBdY8Ul9/7uF62ttfD1EXonKfVe8npLxY/cPLM4bVXcAo2hID1ddiikghZOFA4o8WpLc0xpzhdTDNMAn1M4WN3ZaIjSgLHg4wIATTdLguk6pkfIeVkC7HVvuhz1HhKJAvPMapAOV4zeWU/D4VOWTWhZY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4a41f46d629so2061253b6e.3
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 17:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785543939; x=1786148739;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o3OPq0jqvY17fQ39pGJqE4mxVrdLjtr7qic51IJSppc=;
        b=rYYgIRewsApCFDZoYSX2Pt1hbtUYJn+DeGMfksLpaRQ/t4WaZSB8u0cqyi7WozhBf8
         dTjvazhSoHnYGjzL8EJEJ9B9bNYwMfhRDqHSvgC898QYJlHZwEmYQqHopQDViiyUc3pp
         V2lu65IxNu9z9amngC2uVgYONNBgpntFD0UmBGUjkd9LJLpcmrsNE0SnSWziIWwRo7bU
         u5Fu5mGhoHJVWYR1AxCempNSpBh5TUy0kgrMg0+0OmXJhtnIa2TgMQrue+Z3/ifnSK+o
         d1+SjFlphrQXfEyfGIKM7Dx11P7exUsrQCa7aSsp/HBxRlONopXz+fZImUdg3dAgFtMC
         XC2g==
X-Forwarded-Encrypted: i=1; AHgh+Rpbt2hnfHgpIpzo4t4DSQOFm7NzY36OleefjRIT0Qx8E46g56FtQ9sgp2itvSJ+L81BQsRIVQViSIPY2w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6wGUsSLtNgnkwGsCEAUbJxDINGO+vTDtkcKjZ1RzwdOc8UTsX
	4mrwOVgR66lLFICHuLYQuMbSSBdJpaP2rEybhtzt2YeZT308O4kJcRz5ZsMnjLh1Poi59CkiM6P
	mcIyVO3XypzfG5a2GKUD2evvm38ZtMdWYOGQTmgBYmBfpEnvNy6UImNEczZ8=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2225:b0:4ab:230c:5faa with SMTP id
 5614622812f47-4af5e3e5522mr3478488b6e.18.1785543939027; Fri, 31 Jul 2026
 17:25:39 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:25:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d3d03.2d659fcc.1d46f5.01aa.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in compress_file_range
From: syzbot <syzbot+db04810ad3d91a0a4697@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f5098b6bae76 Linux 7.2-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17829632580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7079b368dcec295
dashboard link: https://syzkaller.appspot.com/bug?extid=db04810ad3d91a0a4697
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b18067cdf26c/disk-f5098b6b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2b364c33a0f2/vmlinux-f5098b6b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2dfce6f90a4d/bzImage-f5098b6b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+db04810ad3d91a0a4697@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:977!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 752 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Workqueue: btrfs-delalloc btrfs_work_helper
RIP: 0010:compress_file_range+0x1e27/0x2430 fs/btrfs/inode.c:977
Code: af 0c 01 e8 db 39 8a fd e9 55 fd ff ff e8 51 fc ae fd 48 c7 c6 20 1d 28 8c 48 89 df e8 a2 ab ff fd 90 0f 0b e8 3a fc ae fd 90 <0f> 0b e8 32 fc ae fd 48 8b 54 24 78 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc9000454fac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000020000 RCX: ffffffff845b3929
RDX: ffff8880272e9f00 RSI: ffffffff845b42e6 RDI: ffff8880272e9f00
RBP: 00000000fffffff4 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff4 R11: 0000000000000000 R12: 000000000001ffff
R13: 0000000000000fea R14: ffff888068d78000 R15: 0000000000000016
FS:  0000000000000000(0000) GS:ffff888123ede000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c3ea6fb CR3: 000000001cbb3000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 btrfs_work_helper+0x214/0xc70 fs/btrfs/async-thread.c:312
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:compress_file_range+0x1e27/0x2430 fs/btrfs/inode.c:977
Code: af 0c 01 e8 db 39 8a fd e9 55 fd ff ff e8 51 fc ae fd 48 c7 c6 20 1d 28 8c 48 89 df e8 a2 ab ff fd 90 0f 0b e8 3a fc ae fd 90 <0f> 0b e8 32 fc ae fd 48 8b 54 24 78 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc9000454fac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000020000 RCX: ffffffff845b3929
RDX: ffff8880272e9f00 RSI: ffffffff845b42e6 RDI: ffff8880272e9f00
RBP: 00000000fffffff4 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff4 R11: 0000000000000000 R12: 000000000001ffff
R13: 0000000000000fea R14: ffff888068d78000 R15: 0000000000000016
FS:  0000000000000000(0000) GS:ffff888123dde000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f16bf558fb0 CR3: 000000007c548000 CR4: 0000000000350ef0


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
