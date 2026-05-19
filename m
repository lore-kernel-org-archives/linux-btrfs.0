Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B07369236
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 20:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779224079; cv=none; b=cBBSsJn41uVbMpoaI+e0TyUNNVqvMMkSlR5t3Vu76CUeWOcLWhgkzWrkCpzcz9+tzQQZf7Wh5edxzffyOkasPI2hh1PIuRNQoCNWqVa4YrQ4T7xdAy35DctoXasiOnYqbJ0zj9paA1yX3yQoPdQIFcwwmjRhHsSAKBkcVvzCbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779224079; c=relaxed/simple;
	bh=GG4n9ZF7xXSnh0vRJ4R7xLxB52bmZjl5ZnkAy/2tKtM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=adJbQHQ2P7Co5SzjCHRSYCCBo9fXteSMy7aKTCBoFAER7Ad2CElXdjhNfcAeZn40rAdYjFc98XpKFKhueCpcDV9xEqBnL3PT8+Ig6aCCceEgwg5PYeWFTUNfGsA1cojXO9qud703R6x4PFdM2L/DvHdvaryRufDngWYDBdOk0X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e3a338673eso12815490a34.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 13:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779224077; x=1779828877;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sy++itqFq3hKWdnmcSX1X+a753tpwHW/M0150XNdXGU=;
        b=FB61qA36til0ptHC+zE5TFL1DZnW1pSmcTe604+XA0OS1QpKgrjymvA3/nV/+dbIQw
         G6fbUMMoUrNSYE/LjS8s7UDP1z9hCjH2snrw6KdxHAmDBFnDM7wDYRIsJZcsw8wdjoVD
         iWseH1/D9C3klwzm7u+EPYhFLWoti5lAsEhkdjJNAAGKuzaSsGwU06ABLGi1QycIrgE9
         3D9jl7tsITqJ7DxxbLHbtjtKdlODlv8RQl76D0igNRVh+39nBNP9Zc0uaUlDy3uB20Ql
         3XpCLu+SzvtVqlKCJifmVEZ5S8CdNggzMWc3D5x8PcLlJtbbcVZmPYQ2DfGMkwPN8qJr
         0Fag==
X-Forwarded-Encrypted: i=1; AFNElJ9jlfMKxhZc4kfyLEjWssqddWM0ZQS6ftp19ohI7uDiCJpnpBJE4CQbNVKZDxbRt59+emmIJeykNdg55A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6z4Gy9nTpLSNg7EWez7pikxWhdQY4hgVMo1e8SzXWHJrXf5Dl
	Iru3icjaq7BkQW4CE8rgWJKL1YQaOL0gQM0IFr2wXrpithtnKBKgBBmhOTDMbZYQL+eDiLrQZ9N
	0pSA0I2eeUz2uVqsS3zjRmfLwbGWuYuhOJMJ6Uy7d0GFeo1gop14DfDWCLek=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:163:b0:696:2cfa:5d85 with SMTP id
 006d021491bc7-69b8803d652mr9877587eaf.13.1779224077243; Tue, 19 May 2026
 13:54:37 -0700 (PDT)
Date: Tue, 19 May 2026 13:54:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0cce0d.170a0220.3cbd30.0137.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_rename2 (2)
From: syzbot <syzbot+8b14244ee8d43b313915@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d458a240344c Merge tag 'block-7.1-20260515' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12de58ec580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=8b14244ee8d43b313915
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142e1fce580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146998c8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/81db812cf8a9/disk-d458a240.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d60234f33956/vmlinux-d458a240.xz
kernel image: https://storage.googleapis.com/syzbot-assets/06b47f22d6a0/bzImage-d458a240.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/37b66df1a3ba/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15804d6a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b14244ee8d43b313915@syzkaller.appspotmail.com

------------[ cut here ]------------
!new_inode
WARNING: fs/btrfs/inode.c:8616 at btrfs_rename fs/btrfs/inode.c:8616 [inline], CPU#1: syz.1.22/6085
WARNING: fs/btrfs/inode.c:8616 at btrfs_rename2+0x1c07/0x40d0 fs/btrfs/inode.c:8854, CPU#1: syz.1.22/6085
Modules linked in:
CPU: 1 UID: 0 PID: 6085 Comm: syz.1.22 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:btrfs_rename fs/btrfs/inode.c:8616 [inline]
RIP: 0010:btrfs_rename2+0x1c07/0x40d0 fs/btrfs/inode.c:8854
Code: 00 e8 4d 43 dc fd 41 80 f6 01 45 0f b6 c6 48 8b 7c 24 18 48 c7 c6 46 09 67 8d ba 3b 21 00 00 e9 53 03 00 00 e8 2a 43 dc fd 90 <0f> 0b 90 41 bf ef ff ff ff e9 f2 f9 ff ff 4c 89 7c 24 08 4c 8b 7c
RSP: 0018:ffffc900046cf800 EFLAGS: 00010293
RAX: ffffffff83e83636 RBX: fffff520008d9f24 RCX: ffff888029319ec0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900046cfbb0 R08: ffff888029319ec0 R09: 0000000000000002
R10: 0000000000000100 R11: 00000000ffffffef R12: ffffc900046cfa38
R13: 1ffff1100bdaf993 R14: 00000000ffffffef R15: ffff8880457d4c58
FS:  00007f08aa1556c0(0000) GS:ffff888126274000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6dee4c5000 CR3: 000000003d816000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vfs_rename+0xa96/0xeb0 fs/namei.c:6054
 filename_renameat2+0x539/0x9c0 fs/namei.c:6172
 __do_sys_rename fs/namei.c:6216 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6212
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08aab1ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08aa155028 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f08aad96090 RCX: 00007f08aab1ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000200000000280
RBP: 00007f08aabb2d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f08aad96128 R14: 00007f08aad96090 R15: 00007ffc34538de8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
