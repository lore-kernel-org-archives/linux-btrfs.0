Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA4731ED8B
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785002788; cv=none; b=Qn+X2UWE/LP39NBkTgTpzkVpgz73no9koFPAZqMfOcS5nvBV8cc5adzobbGya/mZQfBvRYwYDvHFxPN3nHBVK1wFR00At18keUJ/nlfRaI7hLMzmkDsljTfeFD0ylM3kehODo57cUr2XHlJafH/5c1D/RYP1gWQsq1qeGF04dd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785002788; c=relaxed/simple;
	bh=XDt4EWlz36rUGzsVP3bs/XGPatV/qbXVAxuuuS4k0KQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=d5EYXJQYV2WV0hwsJ5girFBLdSegs3KpeCqhqiRe0ScxXyQatf9joxZU7eMmwSXhjuZZpD65+9OuotthbVjoayJ9h95zIbIw5bLM7HoQXeDBdW2T5/6fzVv4kux6f7XAtv9DSvXQSCvohErMoIhyhBJBC5irSe5rAmMlqowqKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4a7de733fa9so1863719b6e.3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 11:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785002785; x=1785607585;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ZDy09wiHC8UUs73jGqHYwI9KWgvrdpaQ6QB1ceyg2s=;
        b=coXcpU2aGbI7lnA0z3G8HzFp92PxbzVO8EkDGDHrgZNJKnC/932g7d30f9kONdj8ko
         nIEGT+FWWz+N1ZTbZFTzcfbWdYmFS63YSsErjnI4SAhADUha5nYN2IPeg64f683h+/jC
         LXO0dhrGMXOOjtfQg1hvYGRzWAK9hkDnJILpMQPmXv//p6W/w4d9NvhhIy7vwKx+YrcV
         rHze5WL1hG8V1N2GY+16aPUoGJdyKyFPeZB2c9eLhXvwka8i5KE8MnA3M74Vdl37fHPf
         A8n2NgUqf/T5hPFFCGOXX8xyJs8YIZm595EnaBxe1oEa/MT7ka3kMUXBX2fz4WjSe6Ow
         Xjrw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/qd6bMVQM5f6H/BBgJDyx8cSmZSMT/0rGHthIjXj3HzhpAkVkv+fj0zCjYoFU22KFJV3LqxA+lH7hhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFqdnyRI1OiBzlb/3XerLwjTMsoGcl74OxS1bbGmelSqW5/SH+
	ZIUDFD9w23uLlO6w5iSOqU7zRK6ckXCndvGJDQwtRWoZwUbESj680C9hO1K5OhTelZtCZkLoKhS
	NW5NQuNH+mT/cEMbCKHfKorgjaxu+neUcmyCU1LLfbX/TfjWql15DVOvYBY8=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220a:b0:49b:c387:36c5 with SMTP id
 5614622812f47-4ab6a10d714mr3374919b6e.17.1785002785629; Sat, 25 Jul 2026
 11:06:25 -0700 (PDT)
Date: Sat, 25 Jul 2026 11:06:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a64fb21.073198cf.94f0f.0019.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in prepare_to_merge
From: syzbot <syzbot+bb14fd4ddd0269623f20@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b95f03f04d47 Merge tag 'mm-hotfixes-stable-2026-07-20-11-3..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148b4ab9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=bb14fd4ddd0269623f20
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-b95f03f0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/46cc4d5161ad/vmlinux-b95f03f0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4cb305677dbb/bzImage-b95f03f0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bb14fd4ddd0269623f20@syzkaller.appspotmail.com

BTRFS info (device loop0): balance: start -d -m
BTRFS info (device loop0): relocating block group 6881280 flags data|metadata
------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/relocation.c:1850 at prepare_to_merge+0x11a7/0x1740 fs/btrfs/relocation.c:1850, CPU#0: syz.0.0/5325
Modules linked in:
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:prepare_to_merge+0x11a7/0x1740 fs/btrfs/relocation.c:1850
Code: fc ef ff ff 4c 89 e7 e8 d7 24 0c fe e9 ef ef ff ff e8 1d 4b a8 07 e8 f8 f8 9c fd eb 10 e8 f1 f8 9c fd eb 09 e8 ea f8 9c fd 90 <0f> 0b 90 44 89 e1 f7 d9 4c 8b 6c 24 38 e9 5c f9 ff ff 89 f9 80 e1
RSP: 0018:ffffc9000e63f700 EFLAGS: 00010287
RAX: ffffffff842988e6 RBX: ffff888052c2c001 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 00000000000723ec RDI: 00000000000723ed
RBP: ffffc9000e63f810 R08: ffff88801f4d2540 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000002 R12: 00000000ffffffe4
R13: ffff8880122865e8 R14: dffffc0000000000 R15: ffff88803fbda538
FS:  00007f43e4dd66c0(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000004478f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 relocate_block_group+0xbc6/0xe90 fs/btrfs/relocation.c:3700
 do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5322
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5489
 btrfs_relocate_chunk+0x114/0x810 fs/btrfs/volumes.c:3647
 __btrfs_balance+0x1b5f/0x29d0 fs/btrfs/volumes.c:4586
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
 btrfs_ioctl_balance+0x3da/0x640 fs/btrfs/ioctl.c:3480
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f43e3f9de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f43e4dd5fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f43e4226090 RCX: 00007f43e3f9de99
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000008
RBP: 00007f43e4033eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f43e4226128 R14: 00007f43e4226090 R15: 00007ffdeedc4388
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
