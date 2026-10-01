Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D7D466B44
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 21:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890709; cv=none; b=iAbhEuDGC+mTDYZs5rfoRH3WI3Xfx8typ6L7tHdT/Zw1+879SoUZM4M8GSCKeQvjidmZUuczJ1ZIZZW+QhX7o7QD0kBlg0v6VKBkAIv2duZw+TCwskS39kR9SnJAiTP2gIXlecoFl0fr68IIfDc4HW1N4pnYqwU47t4L7PRd0nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890709; c=relaxed/simple;
	bh=/lZxEh665BikeST0L+xJJ/DMpe47LhzV4ONcfDWIfmA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lAGHedREreyuH+DKZPRkYg9qidmKGmaBO+dOsxeiamUALc18hGv9OKlIo0Ahr7x092JGMBR2RZkmVrA/ooKLlgaeuIN/PAfenrqVImDweBg2Bh+Q1MKVuzcFsGOZ+rJV0eANsVSbuqmHCdUCFEJK32CISYRVo7E3IAedGK+uuF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso11672846b6e.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 14:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790890706; x=1791495506;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uST/fJA8PntdH+iehUrW7X8BNz4nkb3lh+gtfS1Ap2U=;
        b=bzvSnXCFnQtvhalnhUcCfy1iaIVFeQSwWtuOwhReXC2Okr6akYoZQdp9Yfvp/6qb7R
         0ooVN8eqGE5O464Kr+ZY1+dQ2xYWU9GKA+mZdcDRqK/EzhMiJ/73CSki7IBxcFTNm/cA
         B6yAFibWylaZwFWu35Aszr8l5uykD1H1f4UZTPhHhaJ20LUR36zlE7T7XY3Fwsd0mfim
         SXTduN1kjGXZDvGyTirY4UKBdb5okzIVJoSj1tRYs63dZWWzFxpaG12MfyzCaiq9xhsC
         8iz8bzngnYoSQjPSRCoCBsCr9tZnd96pG8HRvhwhxM4/lE1Bo43u97FzzEJblltckRuj
         IjTg==
X-Forwarded-Encrypted: i=1; AKwUvByHP/JpdMvg7qbN67/r0Jq2DjT67co8zqqeITTYbPqK1GirnCRo3440ITuL+DXJUP9qx1NswnOuzgl0sQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mGVeuPEUFd0ImAwDlMadduoM9+ZNRdR0f0YbPNTdsfwrAcDXrg
	0lObj2cM9Y/nhSMmgFjJOjOOtN+8i8lXpFz8EFipsMqg3zYAIK2N1RfIogbtuBfL0xdMjBauhZS
	kHRqBJBg5LGbDB/BN7lglLra8lPQLeeWT1TYbjQRFhD/1nQ2ZrfJTyC9uW8o=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6809:2ca:10b0:4f5:4780:582 with SMTP id
 5614622812f47-4f5478f7e75mr118947b6e.50.1790890706629; Thu, 01 Oct 2026
 14:38:26 -0700 (PDT)
Date: Thu, 01 Oct 2026 14:38:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abed2d2.eb639fcc.2b981.0006.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in btrfs_backref_release_cache (4)
From: syzbot <syzbot+918038c3f9425b05dcd3@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d266640c6c76 Merge tag 'driver-core-7.3-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16cc3315580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=918038c3f9425b05dcd3
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d266640c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/25e4cb4d0962/vmlinux-d266640c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea6eec983242/bzImage-d266640c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+918038c3f9425b05dcd3@syzkaller.appspotmail.com

BTRFS info (device loop0): balance: start -d -m
BTRFS info (device loop0): relocating block group 6881280 flags data|metadata
BTRFS info (device loop0): relocating block group 5242880 flags data|metadata
BTRFS info (device loop0): found 9 extents, stage: move data extents
assertion failed: !cache->nr_nodes, in fs/btrfs/backref.c:3163 (cache->nr_nodes=2)
------------[ cut here ]------------
kernel BUG at fs/btrfs/backref.c:3163!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_backref_release_cache+0x1fe/0x230 fs/btrfs/backref.c:3163
Code: 0f 0b e8 75 da 90 fd 48 c7 c7 20 c8 5b 8c 48 c7 c6 80 c8 5b 8c 48 c7 c2 80 bf 5b 8c b9 5b 0c 00 00 41 89 e8 e8 23 9e f0 fc 90 <0f> 0b e8 4b da 90 fd 48 c7 c7 c0 c8 5b 8c 48 c7 c6 20 c9 5b 8c 48
RSP: 0018:ffffc9000eb7f7e8 EFLAGS: 00010246
RAX: 0000000000000052 RBX: ffff88801fa82020 RCX: 980914ae5784ef00
RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffc9000eb7f567 R09: 1ffff92001d6feac
R10: dffffc0000000000 R11: fffff52001d6fead R12: dffffc0000000000
R13: 1ffff11003f50404 R14: ffff88801fa820f0 R15: ffff8880525fd3b0
FS:  00007facfea6b6c0(0000) GS:ffff88808c2bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 000000001235c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 relocate_block_group+0xb84/0xeb0 fs/btrfs/relocation.c:3756
 do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5391
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5558
 btrfs_relocate_chunk+0x114/0x810 fs/btrfs/volumes.c:3729
 __btrfs_balance+0x1b5f/0x29d0 fs/btrfs/volumes.c:4668
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:5055
 btrfs_ioctl_balance+0x3da/0x640 fs/btrfs/ioctl.c:3494
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7facfdb9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007facfea6afe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007facfde26090 RCX: 00007facfdb9e159
RDX: 0000200000000180 RSI: 00000000c4009420 RDI: 0000000000000006
RBP: 00007facfdc3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007facfde26128 R14: 00007facfde26090 R15: 00007fff41f35e48
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btrfs_backref_release_cache+0x1fe/0x230 fs/btrfs/backref.c:3163
Code: 0f 0b e8 75 da 90 fd 48 c7 c7 20 c8 5b 8c 48 c7 c6 80 c8 5b 8c 48 c7 c2 80 bf 5b 8c b9 5b 0c 00 00 41 89 e8 e8 23 9e f0 fc 90 <0f> 0b e8 4b da 90 fd 48 c7 c7 c0 c8 5b 8c 48 c7 c6 20 c9 5b 8c 48
RSP: 0018:ffffc9000eb7f7e8 EFLAGS: 00010246
RAX: 0000000000000052 RBX: ffff88801fa82020 RCX: 980914ae5784ef00
RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
RBP: 0000000000000002 R08: ffffc9000eb7f567 R09: 1ffff92001d6feac
R10: dffffc0000000000 R11: fffff52001d6fead R12: dffffc0000000000
R13: 1ffff11003f50404 R14: ffff88801fa820f0 R15: ffff8880525fd3b0
FS:  00007facfea6b6c0(0000) GS:ffff88808c2bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 000000001235c000 CR4: 0000000000352ef0


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
