Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEC745039
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 01:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782005192; cv=none; b=MnX0uY0ulav1ekuRWImJWsDNOVMDn0PU1pAJzy34DV8bb9DBrwvzMj9NqppVjwwH8W3lbj9xlxpDlsL6bDQycD1x4ihVOzZI9AacfWUc0NHh7UvYJg4rn0IXbt4J1UUo0RCZm7chL+tnOv4lFkPy1Z3BonELRv8a1gKRYkqpQ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782005192; c=relaxed/simple;
	bh=Wsks1uNlE2mHQs3OXJ+2u8IWbM+eeeAgsicLWC7aBFo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MOzp+8HDsgCCbrllgfP6bMkDQKACdsmlXRUNc6XCiPAwsMH/g1qgONhwbHb3/o32d983w4njzOgrUNFwDN6FdKhk0uDTrQnZxomzwONqM9GlOGLCFDndeToyooMMEAyAwKXS4W1REbn3f/JYdLjRxvQl0CyDJ+xoecJqxR5P8+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-48976713b46so2966852b6e.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 18:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782005190; x=1782609990;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kGQdaqIDMHoLRSJVJCh1dXyBDnNfrEx1idVgBHUGFDM=;
        b=rwlHc8dJCaAHEofmPlNzpOwwbn7aO6v0+QldApxb8anBlwu9u8Z0nV4G+8nGoTgttc
         gsUOX2jelZqLIvauGUPH3YmxPMHJFLpnzD/fjsij6qrohV+4UBdGp7PK5UhPza7eMRO1
         1U51hG4R0CW/3g5rMapPqpwRTXdzgMDCfmxug67THjQiV0+TDdIX1+FMKJBI/1/5yl2n
         NsXuq+pWSoNQG6/VSpwzOJm3okNDGT6iIN2Jn1UBWEUp82yQQCJLaxLC0w4ROYK33GV2
         fZy9upAHyGSEJhE8yUkddPE0b36voqB3I2OdmenWYtBvvInGsTo/hhnHQXxKS/mniS2X
         Jl9g==
X-Forwarded-Encrypted: i=1; AFNElJ/LleJBZ5DaX/fb2u7vCg0l759DuKkmQibpyaazCqzd3piH6YRPmvUCHNkc34AIgsOnDSSq4Xc9GfatAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoUtso6mlqHCQfSBIiWmjokd7cYXvjUMv9SGIBgHOY1oCio6lX
	rxIXWjI6xWHOPPkrPjfzz73qMFZH/5NRAARuxhXNCyHEedj0SnZk6gpItbyMgYvcqR5PhUuBCKw
	89Rx2og+ty7x2DU1mPaTvW0W5DfrLD+Ykb5/FQC+aSbp6RjQ/bkQha/AMVH8=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1491:b0:479:ac7d:6d8a with SMTP id
 5614622812f47-4896ac02527mr8495746b6e.24.1782005189828; Sat, 20 Jun 2026
 18:26:29 -0700 (PDT)
Date: Sat, 20 Jun 2026 18:26:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a373dc5.764cf64f.168fbe.0001.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_force_cow_block
From: syzbot <syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9ecfb2f7287a Merge tag 'trace-ring-buffer-v7.2' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a15b7a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41904f685679d171
dashboard link: https://syzkaller.appspot.com/bug?extid=d950c6ba09b79f6e1864
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9ecfb2f7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e769c7b13970/vmlinux-9ecfb2f7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1e58f90eb1c5/bzImage-9ecfb2f7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com

		extent compression 0
	item 18 key (258 EXTENT_DATA 421888) itemoff 2800 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8777728 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 19 key (258 EXTENT_DATA 438272) itemoff 2747 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8790016 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 20 key (258 EXTENT_DATA 479232) itemoff 2694 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8794112 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 21 key (258 EXTENT_DATA 552960) itemoff 2641 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8798208 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 22 key (258 EXTENT_DATA 593920) itemoff 2588 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8802304 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 23 key (258 EXTENT_DATA 638976) itemoff 2535 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8818688 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 24 key (258 EXTENT_DATA 667648) itemoff 2482 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8843264 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 25 key (258 EXTENT_DATA 700416) itemoff 2429 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8851456 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 26 key (258 EXTENT_DATA 729088) itemoff 2376 itemsize 53
		generation 16 type 1
		extent data disk bytenr 8884224 nr 4096
		extent data offset 0 nr 4096 ram 4096
		extent compression 0
	item 27 key (18446744073709551611 ORPHAN_ITEM 258) itemoff 2376 itemsize 0
BTRFS error (device loop0): unexpected non-zero offset in file extent item for data reloc inode 258 key offset 0 offset 9277520992061368337
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/ctree.c:531 at btrfs_force_cow_block+0x1a3a/0x1bf0 fs/btrfs/ctree.c:531, CPU#0: syz.0.0/5346
Modules linked in:
CPU: 0 UID: 0 PID: 5346 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_force_cow_block+0x1a3a/0x1bf0 fs/btrfs/ctree.c:531
Code: 82 d9 fd 90 0f 0b 90 44 89 f1 f7 d9 4c 8b 6c 24 08 e9 d8 f7 ff ff e8 b5 82 d9 fd eb 10 e8 ae 82 d9 fd eb 09 e8 a7 82 d9 fd 90 <0f> 0b 90 44 89 f1 f7 d9 4c 8b 6c 24 08 e9 1e f8 ff ff e8 8f 82 d9
RSP: 0018:ffffc9000f7ff0e0 EFLAGS: 00010287
RAX: ffffffff83ecb219 RBX: ffff888041980001 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 00000000000e8c21 RDI: 00000000000e8c22
RBP: ffffc9000f7ff260 R08: ffff888040818000 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: dffffc0000000000
R13: ffff88800010e2f0 R14: 00000000ffffff8b R15: ffff888056ac103f
FS:  00007fecbea066c0(0000) GS:ffff88808c84f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f54c062f120 CR3: 0000000043809000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
 do_relocation+0xd1c/0x17a0 fs/btrfs/relocation.c:2350
 relocate_tree_block fs/btrfs/relocation.c:2600 [inline]
 relocate_tree_blocks+0x11a3/0x1fc0 fs/btrfs/relocation.c:2707
 relocate_block_group+0x77c/0xe90 fs/btrfs/relocation.c:3635
 do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
 btrfs_relocate_chunk+0x114/0x810 fs/btrfs/volumes.c:3647
 __btrfs_balance+0x1b5f/0x29d0 fs/btrfs/volumes.c:4586
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
 btrfs_ioctl_balance+0x3da/0x640 fs/btrfs/ioctl.c:3474
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fecbdb9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fecbea05fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fecbde16180 RCX: 00007fecbdb9ce59
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 000000000000000a
RBP: 00007fecbdc32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fecbde16218 R14: 00007fecbde16180 R15: 00007ffc571bd148
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
