Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50F26F2BE
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786493492; cv=none; b=HCWTbDH7M/oL7pKR4w8axyokooGxY2rtvhnLhykoToH7k/DK8ySd9ZGB6JESsA53ubLcSpEkRMeIpB5h3WnljFhUrN8cvbMOKrTNUNw/AVsFPiPY2/5d9YRhQQ1NxhG+b2gLTLlmt7xpQzDQA0Lw5UpKLc4EzWl0+/QFsUtxm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786493492; c=relaxed/simple;
	bh=WVKAzDuyDPFJl7QFNeUDCoer/VoalPUxFvP61jnIw3g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QsT/CsRRyfts96V0Q3EDFLk2j1ZJmPwNeMk6EQ3pS+y7MoX1p9vYxF9dKWnsg2qUgkoy04K+4drql8QtU8d36z6igaAxik/QfDXwKrGbyqRS/rPAUuqZLDemUZe/ZKnF5IJGIr8ztvc5Z3eoi7stEGbssP4+A8xs1KLtTPAbVj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4ab4af22d09so469077b6e.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 17:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786493489; x=1787098289;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EdydXNAfSVjXM3eEHmMj/x1ykITJwoQPDmjvh0b3iRA=;
        b=Wvv0RXm9/qeBJjGbmXJS0VhTyoDFFWkx0l1xPQDwjaFYBa1lSmYLpFh3981U1Jnj/j
         bBkq45EvcAqTLsrjwgz5H+CNyKiAu3I11LVrcC77zUSs7FiLmaPWbkmZ7MfYyHw+1wJu
         /iox5NqRev7ofcec2rDzOYrXLbd+Gj3QMijl7zYcUON5HmJLdkRcO4lSv5DnTfvR+MGK
         crOGcQwcYc8oOZZcIInN7LJCrPDTqjtXs/cIPbDKfAXriRKrecnz/0FJ6sg4zMi9VxLV
         57yhhK06nH7IckIzMOSRmf1VJp+ZRBBWSiYETFakYIwL/IgwViozTYbbmf0OES5eZ5Cm
         jrEQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro3OGl6hqMaWnp9jHNNto3FKa3DJi1n8j/QJDJ4XadA3q/aVfHwOYGAIENl7IiFQgPwPbzC38s8Wy7IxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzu3sBXpZpfC8/x7HDJrWumnMb2fWTNGAfO5ipc4mBf0A4Gkbb
	8HlYfKTmGh5DhMVutL+6BbiMqEKfCo7dsKfSKVHCrLAx5zUfbwK0eow/9qPQGAASHiNbfn9/iYd
	bfF9gFeHyoyNJJTPoxEJAph+HX45tCqYpGjgvM87Egh29gfMtoHAP8LOlM80=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a10:b0:4a4:934:b316 with SMTP id
 5614622812f47-4b210c77ff6mr1054908b6e.21.1786493489088; Tue, 11 Aug 2026
 17:11:29 -0700 (PDT)
Date: Tue, 11 Aug 2026 17:11:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7bba31.3668565d.e8814.0007.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in btrfs_assert_inode_range_clean
From: syzbot <syzbot+d6b4e882f299b4de30e1@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f9a2394a2348 Merge tag 'mm-hotfixes-stable-2026-08-06-18-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12412fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd7fa9e412f91f87
dashboard link: https://syzkaller.appspot.com/bug?extid=d6b4e882f299b4de30e1
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f9a2394a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/44414e53d5ba/vmlinux-f9a2394a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a70c6743385f/bzImage-f9a2394a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6b4e882f299b4de30e1@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
BTRFS: device fsid 14d642db-7b15-43e4-81e6-4b8fac6a25f8 devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5319)
BTRFS info (device loop0): first mount of filesystem 14d642db-7b15-43e4-81e6-4b8fac6a25f8
BTRFS info (device loop0): using blake2b checksum algorithm
BTRFS info (device loop0): enabling ssd optimizations
BTRFS info (device loop0): turning on async discard
BTRFS info (device loop0): enabling free space tree
BTRFS info (device loop0): use zstd compression, level 3
BTRFS error (device loop0): found unexpected ordered extent in file range [0, 6295551] for inode 263 root 5 (ordered range [131072, 262143])
assertion failed: ordered == NULL, in fs/btrfs/inode.c:10662
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:10662!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5319 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_assert_inode_range_clean+0x2cf/0x320 fs/btrfs/inode.c:10662
Code: fd 48 8b 3c 24 e8 11 8b 04 00 48 c7 c7 c0 27 38 8c 48 c7 c6 a0 40 38 8c 48 c7 c2 a0 28 38 8c b9 a6 29 00 00 e8 62 9c 13 fd 90 <0f> 0b 89 d9 80 e1 07 38 c1 0f 8c b8 fe ff ff be 08 00 00 00 48 89
RSP: 0018:ffffc9000f186f28 EFLAGS: 00010246
RAX: 000000000000003c RBX: 0000000000000001 RCX: 67b6815a688fe000
RDX: ffffc9000e8ca000 RSI: 00000000000057ab RDI: 00000000000057ac
RBP: 0000000000020000 R08: ffffc9000f186ca7 R09: 1ffff92001e30d94
R10: dffffc0000000000 R11: fffff52001e30d95 R12: 0000000000000000
R13: 0000000000000005 R14: dffffc0000000000 R15: 0000000000600fff
FS:  00007f0a019ce6c0(0000) GS:ffff88808c54a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f817db41000 CR3: 0000000043099000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_punch_hole_lock_range+0x521/0x5b0 fs/btrfs/file.c:2291
 btrfs_punch_hole fs/btrfs/file.c:2756 [inline]
 btrfs_fallocate+0x17a8/0x1c30 fs/btrfs/file.c:3128
 vfs_fallocate+0x65a/0x7e0 fs/open.c:338
 madvise_remove mm/madvise.c:1038 [inline]
 madvise_vma_behavior+0x2c07/0x4340 mm/madvise.c:1351
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a00b9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0a019cdfe8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0a00e25fa0 RCX: 00007f0a00b9e0d9
RDX: 0000000000000009 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f0a00c35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0a00e26038 R14: 00007f0a00e25fa0 R15: 00007ffe34d18798
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btrfs_assert_inode_range_clean+0x2cf/0x320 fs/btrfs/inode.c:10662
Code: fd 48 8b 3c 24 e8 11 8b 04 00 48 c7 c7 c0 27 38 8c 48 c7 c6 a0 40 38 8c 48 c7 c2 a0 28 38 8c b9 a6 29 00 00 e8 62 9c 13 fd 90 <0f> 0b 89 d9 80 e1 07 38 c1 0f 8c b8 fe ff ff be 08 00 00 00 48 89
RSP: 0018:ffffc9000f186f28 EFLAGS: 00010246
RAX: 000000000000003c RBX: 0000000000000001 RCX: 67b6815a688fe000
RDX: ffffc9000e8ca000 RSI: 00000000000057ab RDI: 00000000000057ac
RBP: 0000000000020000 R08: ffffc9000f186ca7 R09: 1ffff92001e30d94
R10: dffffc0000000000 R11: fffff52001e30d95 R12: 0000000000000000
R13: 0000000000000005 R14: dffffc0000000000 R15: 0000000000600fff
FS:  00007f0a019ce6c0(0000) GS:ffff88808c54a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0a019ad9a0 CR3: 0000000043099000 CR4: 0000000000352ef0


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
