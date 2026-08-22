Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F443911BC
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 07:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787382635; cv=none; b=awX9PcL3fCjH2VIeBMARZPJbly4Yu9OH7rH89Fc9/nJGmYxYz9CYck0V/UfpTk4KcKkv3fyCIj0tYWGHaCQJtPvPYY+KU1bXiwe2e35eCZLb/+UVhOOMNwxFnBvDKoNS+Xxw/bet2OB/RtZUiaB6pvBGmSx87hrmDjncDuA1FGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787382635; c=relaxed/simple;
	bh=g8qD+/nbafJHmB8BnjqLYYSuUZxAMb9kyq4e1RhozAI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=C+TqwhqfUic4OZv1mcyQoBtPPwR39nIL/jBiOUyqxmKz7fkAPG67YsIRKv+6lkUq+bnxUhAC23rMKZxVy5fqHqNHbi+ujLHSucxRT+m6biaALG88YVLM7lsHFVgmc6i8683fL0Tq/t8RhgMY95DuYZLMZY2dseIk4FcyDPMDdNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a41b6fb855so666850b6e.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 00:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787382632; x=1787987432;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mZK3Wwe/U3EyWXFyrC6hRry4OWkpYni0+DKxaeISK7o=;
        b=PdgUYmzb6oVAw6ZpPS0Vv/eBjEO8y3qjovKMhqbw7t6LOTtlO6dyjtU0TfOrOGnSik
         wk/OlTjVBwa2/8q7tXrhqHv6WyzF62m5tan25Y1riCNmRkveLKwTFu68nOmzi4CTYr3v
         LBHkV52JO5bMULUdgzXK69clcEHy7/PIcQijv97oXGSHxYstpnMFtFNN6XiEOVE+uw3k
         ffF0rtvtSOPjpn46WXMIG1HdK1HQFvd62fk8dx23VARvcplO37HfE5nwJhwaXciQTGok
         WBpiL9vtVSe7WMGjuTD4fXURDBiUbVwqKxKPvTYygUsu+PKbc4THzOgAap3KvX5YJtwh
         n+QA==
X-Forwarded-Encrypted: i=1; AHgh+RraApPizfiT4DXpLPLUXs3KzjA5MedlRxV/mbfeYkz9Arr6d2wTUM63K4dQzMEn8Tl7d8xKxRdFqwi/cg==@vger.kernel.org
X-Gm-Message-State: AFuF++me2EPlb6pROhU/8sj+5qYGKQAKncaN8fpOLi06HJ5utZykFfTT
	MTtW6qgHUnO07nOzAwYqcUxk5ajQhQQ9ESSwuipx8MtyxIwNGQT+QHKlH4l/kachMzXBnSIa0I8
	USh/WxXZVd44nBQWL3L5Q1Iqvl79ow2QdXaX2iLZ0fkpLVD2CZVMd5eE9QMo=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b0c:b0:48a:ddd4:d36f with SMTP id
 5614622812f47-4b2ef33a8d5mr12675998b6e.8.1787382632160; Sat, 22 Aug 2026
 00:10:32 -0700 (PDT)
Date: Sat, 22 Aug 2026 00:10:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a894b68.ae6ddae5.3da009.0051.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in do_nonremap_reloc
From: syzbot <syzbot+ee138e182230b96006c6@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0f23d56f17fd Merge tag 'linux_kselftest-next-7.3-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163fb679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71fc77aa899cc4af
dashboard link: https://syzkaller.appspot.com/bug?extid=ee138e182230b96006c6
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0f23d56f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f14e4b85231d/vmlinux-0f23d56f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/824989a16f1e/bzImage-0f23d56f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee138e182230b96006c6@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
btrfs: Deprecated parameter 'usebackuproot'
BTRFS warning: 'usebackuproot' is deprecated, use 'rescue=usebackuproot' instead
BTRFS: device fsid c9fe44da-de57-406a-8241-57ec7d4412cf devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5310)
BTRFS info (device loop0): first mount of filesystem c9fe44da-de57-406a-8241-57ec7d4412cf
BTRFS info (device loop0): using crc32c checksum algorithm
BTRFS error (device loop0): failed to load root extent
BTRFS warning (device loop0): try to load backup roots slot 1
BTRFS warning (device loop0): couldn't read tree root
BTRFS warning (device loop0): try to load backup roots slot 2
BTRFS warning (device loop0): couldn't read tree root
BTRFS warning (device loop0): try to load backup roots slot 3
BTRFS info (device loop0): rebuilding free space tree
BTRFS info (device loop0): checking UUID tree
BTRFS info (device loop0): enabling ssd optimizations
BTRFS info (device loop0): turning off barriers
BTRFS info (device loop0): turning on sync discard
BTRFS info (device loop0): enabling free space tree
BTRFS info (device loop0): force clearing of disk cache
BTRFS info (device loop0): enabling auto defrag
BTRFS info (device loop0): trying to use backup root at mount time
BTRFS info (device loop0): use zlib compression, level 3
BTRFS info (device loop0): max_inline set to 0
BTRFS info (device loop0): balance: start -d -m
BTRFS info (device loop0): relocating block group 6881280 flags data|metadata
BTRFS info (device loop0): relocating block group 5242880 flags data|metadata
BTRFS info (device loop0): found 7 extents, stage: move data extents
------------[ cut here ]------------
rc->block_group->reserved > 0
WARNING: fs/btrfs/relocation.c:5389 at do_nonremap_reloc+0x53b/0x560 fs/btrfs/relocation.c:5389, CPU#0: syz.0.0/5310
Modules linked in:
CPU: 0 UID: 0 PID: 5310 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:do_nonremap_reloc+0x53b/0x560 fs/btrfs/relocation.c:5389
Code: 5d 41 5e 41 5f 5d e9 04 1f b0 07 cc e8 8e e8 9d fd 90 0f 0b 90 80 3c 2b 00 0f 85 57 ff ff ff e9 5a ff ff ff e8 76 e8 9d fd 90 <0f> 0b 90 80 3c 2b 00 75 84 eb 8a e8 65 e8 9d fd 90 0f 0b 90 eb b5
RSP: 0018:ffffc9000f5b79c8 EFLAGS: 00010283
RAX: ffffffff84292aba RBX: 1ffff11002447400 RCX: 0000000000100000
RDX: ffffc9000ec59000 RSI: 00000000000507c1 RDI: 00000000000507c2
RBP: dffffc0000000000 R08: ffffc9000f5b7947 R09: 1ffff92001eb6f28
R10: dffffc0000000000 R11: fffff52001eb6f29 R12: 0000000000000000
R13: ffff88801223a628 R14: 0000000000006000 R15: ffff88801223a000
FS:  00007f7d4eb846c0(0000) GS:ffff88808c534000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7d4a1d3fe8 CR3: 000000004508e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5520
 btrfs_relocate_chunk+0x114/0x810 fs/btrfs/volumes.c:3729
 __btrfs_balance+0x1b5f/0x29d0 fs/btrfs/volumes.c:4668
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:5055
 btrfs_ioctl_balance+0x3da/0x640 fs/btrfs/ioctl.c:3481
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d4dd9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d4eb83fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f7d4e025fa0 RCX: 00007f7d4dd9e0d9
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000007
RBP: 00007f7d4de35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7d4e026038 R14: 00007f7d4e025fa0 R15: 00007fffd2839a78
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
