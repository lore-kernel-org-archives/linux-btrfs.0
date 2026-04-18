Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A27DF6C
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776529111; cv=none; b=NCmEst8MowXFgtO2v86vXgs03+3x1wKZGhooydI+IHFcyF1f24CkIcn6Y5dzFy/3X4YcmI21HmIPWyplt5rdj1JsWztSGhskBW7HeokkHa12XG+yj4EkpYtPgYB0ErDSoJCeN4s0Urkz5nXbodKq3LteYxQ+J2FrgLkepgcK5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776529111; c=relaxed/simple;
	bh=yb2RgiugMP9KIPaIriZTRVpFoOO6gr5YnImg0sI/iJw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AMr4rieGK7DnjtQbvN4cTF7XqYFy0lq/k/GvlNY8jZpYeKq69prNO1wdj9lHX5Tosll8S9J1AUgqiJl3+UnmsYZaQscdheP3FpFmTYxyRn65TRFEjorMtlRo4DmD4m8jcWAHoM4ONJwkk7fuOkTAWRtIJ9pkhlatuXdYwKBF53g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-68d7d187379so3289237eaf.1
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 09:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776529108; x=1777133908;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9J1+0eCeLXt32Dfr0Ncz3Nv0HT5xCvEYARTz0KXvAHI=;
        b=ijL3fcySK4mq9/m303iI6Kv6Gt6c0x5DjAN+8SFfF5j7FnRYLKhuQPZgWCKzOYUir2
         Va5GnhUE20GeeMCKstyj/Sea9ITAFAREvLCEbIX8u0LLoHJjeF3s3ibyXvBP7J3qS4/y
         58vgjtpFDSD5psSfKLB9jau/QfVAMMDkx3HVxaPYBDYGHmcLpCAa12tZkhl37URBt7jL
         /ZFgkPUQ8O6KQ4q8wwma1dLmKMVN77lRX4Nm24t9lSVLriOUBldVyMnR1zEmukCPHwVY
         ZCnRliu6hzAox8+vToncXpP9Yjuqp3uwmqCp5dCHZOCTCG/cUi5Yd1ntjlcWDGx1MjKc
         g5Qw==
X-Forwarded-Encrypted: i=1; AFNElJ/Nzj8UPCJ4k11ueQz7H0yqjyljZweIhV1cUtrO9fRB5eBvb/EKKYy6QQGh9lICDmtGxO9QMLMVJOkk+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzR6lNx6k9zTmMAB8/v1ryyeQWFJQR2bjBVZRuIHzLVnnAXimLK
	+n+KHtaNcKrpepI6elIl3fjeX1PZbjH1svqKGDHvdYM7d7ycpIMn0fwjk6b+kMwTit2XUTfvVs/
	Z1XTx57bQ3gwvs9+y8EEM1SUZrHY2bzBga7az7JZ09+4Md5v+F7+D6cceLFk=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2089:b0:67e:3ae6:9031 with SMTP id
 006d021491bc7-69462f45720mr4251430eaf.59.1776529108747; Sat, 18 Apr 2026
 09:18:28 -0700 (PDT)
Date: Sat, 18 Apr 2026 09:18:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e3aed4.a00a0220.1bd0ca.0047.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in replace_file_extents
From: syzbot <syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    43cfbdda5af6 Merge tag 'for-linus-iommufd' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fb82d2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eae4973b8684a00c
dashboard link: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-43cfbdda.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/473adbf1a380/vmlinux-43cfbdda.xz
kernel image: https://storage.googleapis.com/syzbot-assets/63ebea9fbab4/bzImage-43cfbdda.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com

BTRFS info (device loop0): balance: start -d -m
BTRFS info (device loop0): relocating block group 6881280 flags data|metadata
BTRFS info (device loop0): relocating block group 5242880 flags data|metadata
BTRFS info (device loop0): found 22 extents, stage: move data extents
------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:841!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:get_new_location fs/btrfs/relocation.c:838 [inline]
RIP: 0010:replace_file_extents+0x1574/0x1590 fs/btrfs/relocation.c:941
Code: 81 2c fe 49 8b 3e be 03 00 00 00 48 c7 c2 40 da 17 8c 44 89 e9 e8 cc dd 25 fd e8 f7 36 ff ff e9 a7 fc ff ff e8 ad 5f c0 fd 90 <0f> 0b e8 a5 5f c0 fd 90 0f 0b e8 9d 5f c0 fd 90 0f 0b e8 95 5f c0
RSP: 0000:ffffc900071f6e80 EFLAGS: 00010287
RAX: ffffffff8404c563 RBX: ffff88800e57f9a0 RCX: 0000000000100000
RDX: ffffc90021003000 RSI: 00000000000c282c RDI: 00000000000c282d
RBP: ffffc900071f7090 R08: ffffea0000ef04c7 R09: 1ffffd40001de098
R10: dffffc0000000000 R11: fffff940001de099 R12: 0000000000000483
R13: ffff88805b2e8000 R14: 0000000000000e70 R15: 80c06030180c2811
FS:  00007fa6cd9886c0(0000) GS:ffff88808c820000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2a6cc8ecf0 CR3: 000000001cdeb000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_force_cow_block+0xa4d/0x2450 fs/btrfs/ctree.c:532
 btrfs_cow_block+0x3c4/0xa90 fs/btrfs/ctree.c:699
 do_relocation+0xd2e/0x1920 fs/btrfs/relocation.c:2288
 relocate_tree_block fs/btrfs/relocation.c:2538 [inline]
 relocate_tree_blocks+0x11ee/0x2020 fs/btrfs/relocation.c:2645
 relocate_block_group+0x76f/0xe70 fs/btrfs/relocation.c:3570
 do_nonremap_reloc+0xa8/0x5b0 fs/btrfs/relocation.c:5250
 btrfs_relocate_block_group+0x7e6/0xc40 fs/btrfs/relocation.c:5416
 btrfs_relocate_chunk+0x115/0x820 fs/btrfs/volumes.c:3598
 __btrfs_balance+0x1db0/0x2ae0 fs/btrfs/volumes.c:4509
 btrfs_balance+0xaf3/0x11b0 fs/btrfs/volumes.c:4896
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa6ccb9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa6cd987fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fa6cce16090 RCX: 00007fa6ccb9c819
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000006
RBP: 00007fa6ccc32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa6cce16128 R14: 00007fa6cce16090 R15: 00007ffdf45f3438
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_new_location fs/btrfs/relocation.c:838 [inline]
RIP: 0010:replace_file_extents+0x1574/0x1590 fs/btrfs/relocation.c:941
Code: 81 2c fe 49 8b 3e be 03 00 00 00 48 c7 c2 40 da 17 8c 44 89 e9 e8 cc dd 25 fd e8 f7 36 ff ff e9 a7 fc ff ff e8 ad 5f c0 fd 90 <0f> 0b e8 a5 5f c0 fd 90 0f 0b e8 9d 5f c0 fd 90 0f 0b e8 95 5f c0
RSP: 0000:ffffc900071f6e80 EFLAGS: 00010287
RAX: ffffffff8404c563 RBX: ffff88800e57f9a0 RCX: 0000000000100000
RDX: ffffc90021003000 RSI: 00000000000c282c RDI: 00000000000c282d
RBP: ffffc900071f7090 R08: ffffea0000ef04c7 R09: 1ffffd40001de098
R10: dffffc0000000000 R11: fffff940001de099 R12: 0000000000000483
R13: ffff88805b2e8000 R14: 0000000000000e70 R15: 80c06030180c2811
FS:  00007fa6cd9886c0(0000) GS:ffff88808c820000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557e0c9528 CR3: 000000001cdeb000 CR4: 0000000000352ef0


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
