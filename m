Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C5120297C
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786322070; cv=none; b=YaV4xGEl3f6N0sEFtvmVCYrus3lJZudBo78YqOLg70lMrnYCLIgn6/m1JqKbavnLuOH6gntryNtKEl9pAzhWWmli0ov2weSznu1PxPnhGsiungoj+WGRA1yh5ibFNLQV9eUzhKuXwdDkjjBq1g+Mqu6pev5uqLDQamVF7+5DxFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786322070; c=relaxed/simple;
	bh=yf0Yg2BZEyXTPnZFI70/uOYfiqHNOhLhLsSFtHg/hNU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HC8ssXt1iDlgnI83bYERZ3wn4UIGXAGgH/udd/aCI47K9x3Bs6ArmV++4wOLhHqgXIG/GfR4tFT+3H39nvoTo9bnJSh2cyqYG4B5/Zv94pBl/sHTKK47Q1S775ljmcuCJRL/bW95EMms8nsa0e0CeW1xFT3Nukxc9+mkhFU/StI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-4a416619e8dso2498299b6e.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 17:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786322068; x=1786926868;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UvCgGx+8Hwf/2ac1wbaF2WX/q14zt4C8bFfNBBcFcmY=;
        b=EL+bMd1z9IcNdNJlgSMjHkjYtubiuWHOPgHB9MmUwMgyjDy3j8Md/MZHqRYYSxNEDM
         1N1mMnHA2QYDawrmavHH5XkEYL4WlPtOZjXCmGbfy/oHZchy8sUJikZLFtccGOty4V6h
         ymoTH/Trsz3KWCZI2UQr6oVFFxY0xo623iN9qSs6NQLoEdvgTozVRduVd/KGwXJ31s/X
         Pr0NRHBo99nPSVPizNYjcwmaD/9iXzjA075IHcV3jVzYl8P78ZyNCfpQUk+Jjg75/kpd
         GKGOL+3nBC7BwH9gyujOhntUdIRre9EhRZMFpW/ne1njFNF+x9mObS//SRut/VEOeZph
         9JVA==
X-Forwarded-Encrypted: i=1; AHgh+RqafjTnd8Vrmk8aEs7ZQQoxNKeb6lNRJECthTMrvFRYzG017zoM7IqXXnnYAvFL/n3ymQ/Z1LK96piuMw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj3GLQVoNkf+yPcr48B1AN9vVJlp6WSqdk9d7+av/eL3PaQRiz
	dpeHjDcz1xKfAqSIY0snGmbWYs23ooB5zN2yAyoT3QDMDwsweEHtGdvDRIvBiYO3CcuFkGi0jIP
	3sbcGsmZjRdryLpm507atx9NzlIr2fvaXDKMBoknPPLMemFs6NBhZKEOpunM=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1824:b0:4a4:cedc:6859 with SMTP id
 5614622812f47-4b1af69b549mr8483198b6e.4.1786322068310; Sun, 09 Aug 2026
 17:34:28 -0700 (PDT)
Date: Sun, 09 Aug 2026 17:34:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a791c94.01d0871a.3a0d52.0099.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_init_new_device
From: syzbot <syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e65bb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7079b368dcec295
dashboard link: https://syzkaller.appspot.com/bug?extid=3bf3e110b2d406b8166c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/25bde0bfecb5/disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a5ebf809884/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d1810845ac3/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bf3e110b2d406b8166c@syzkaller.appspotmail.com

kobject: kobject_add_internal failed for 2 with -EEXIST, don't try to register things with the same name in the same directory.
BTRFS warning (device loop7): devinfo init for devid 2 failed: -17
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/volumes.c:3013 at btrfs_init_new_device+0x1fc6/0x3e70 fs/btrfs/volumes.c:3013, CPU#1: syz.7.121/6685
Modules linked in:
CPU: 1 UID: 0 PID: 6685 Comm: syz.7.121 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:btrfs_init_new_device+0x1fc6/0x3e70 fs/btrfs/volumes.c:3013
Code: fd 48 c7 c6 60 79 29 8c e8 97 62 a4 fd 8d 45 1e 83 f8 19 77 0f ba 01 00 04 02 48 0f a3 c2 0f 82 94 8b ca fc e8 ab 67 a4 fd 90 <0f> 0b 90 e9 86 8b ca fc e8 9d 67 a4 fd 48 8b 7c 24 40 e8 e3 81 f3
RSP: 0018:ffffc90005627960 EFLAGS: 00010283
RAX: 0000000000030d92 RBX: ffff88807adf0000 RCX: ffffc9002560b000
RDX: 0000000000080000 RSI: ffffffff8465ec15 RDI: ffff8880207d0000
RBP: 00000000ffffffef R08: 0000000000000005 R09: fffffffffffffffb
R10: ffffffffffffffef R11: 0000000000000000 R12: ffff888079bb4a80
R13: ffff88807adf1c00 R14: ffff88802bc92000 R15: ffff88805186c5e0
FS:  00007f40c8b946c0(0000) GS:ffff888123ed9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e4921b1d4 CR3: 000000002d0c8000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 btrfs_ioctl_add_dev+0x34a/0x5f0 fs/btrfs/ioctl.c:2558
 btrfs_ioctl+0xce8/0x5d10 fs/btrfs/ioctl.c:5529
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40c7d9e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f40c8b94028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f40c8026090 RCX: 00007f40c7d9e019
RDX: 00002000000023c0 RSI: 000000005000940a RDI: 0000000000000009
RBP: 00007f40c7e3500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f40c8026128 R14: 00007f40c8026090 R15: 00007fff8c42dc38
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
