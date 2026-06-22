Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3647535DA68
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 06:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782109405; cv=none; b=RRMUN19VF3NgnGifqyTsKkjSroRT8Bl8i4iJnY+C7POiGogyCvmSNEqR7WAhXnwAcMfBkabwOZAAg1K8DmQ3WgW6hPSDNEyHxWmZRCAOLU7SY95VlIoJQuP9juYNfRjFSYDcFmtblbetj9MH0RugrRuqgMsVdCRiw7quKg/nB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782109405; c=relaxed/simple;
	bh=onOjjTh8SW8L2TEGf6z4AK/cycxI8sOqA/fNiCShHc0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=STDmoFCN338b4fyPi3Xfxe+upmDmDQctwVtB/1s/RBHuC+6VIoEU4XkNVy+ByJSmD4UcoTTWmXfFa1cFqiq/JtcrdnnBlhAwxbbyl9ElxjX2uXcI02ZrcI3kzJYrwwKP1alWgbzRNu3kmCNn4f+pxl2nkSopT1/RqwYDtFrtP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-48e2ce64834so100093b6e.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 23:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782109403; x=1782714203;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/4/Z7xYZESHQBZQP04s+Mwsd5byCeziEx3yuuwsQbJo=;
        b=OvxQoHeUj1wgXhi1MdaDu7soO8CJf/qbwhxVduxiABFo3B6pE33QrSzHHi95qvX/C4
         Bvb4EuEAL+Ms0U1x7WrV7A6MNav5st+X5FAlZUbwA2ORlQNKcA5qm2kJmnTvl+6+NBTy
         EVLJV7fU4GMS9xEwMla6Vopo7m2sKuFLGD873Wy49vNXBv9AbpdOk07yUppvRuOXgMgw
         byoWp86C0ugTOPsmZ8s7OEn7D28ve6nLNAj0axjFc62CXJTJrDVhIzHfJalGXFDTQQfu
         M0Kn5lmL0uds3gtv54LBie2SFr1r6SLAs7laffey/fFd96G1nwE1yw/DN5t/GD+xAROU
         U+eQ==
X-Forwarded-Encrypted: i=1; AFNElJ9L1lxSWnWjhS0V261bzjvOge7NAghhV7XyJJO2KOhEoRYsxGHpUpDXnRh4HpwHbvOdgpYI7xTveH93BA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3r2B0i9cvGFjMuyYpfgibRtbn0plD6xVePIOXzHbJPJRL22uW
	ipbltwnRdo8+5rdf0+C0uY8NzALxxTBla5pu61VzuKDXCRruUoDGGn/P7djpjjtZNSaZi/SuP6G
	G7taOHq27gGjhzX70mjxiBmvsVcM03MuBFpLhphTIVPkefhdo23v8Bsi0h00=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a29:b0:47b:bd7b:10d0 with SMTP id
 5614622812f47-4896aa24c4fmr10766016b6e.13.1782109403359; Sun, 21 Jun 2026
 23:23:23 -0700 (PDT)
Date: Sun, 21 Jun 2026 23:23:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a38d4db.8ae01289.3f93.0054.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in extent_writepage_io (2)
From: syzbot <syzbot+11036d2e408a419c179c@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1a3746ccbb0a Merge tag 'strncpy-removal-v7.2-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15dc501c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5fece1a9477c321
dashboard link: https://syzkaller.appspot.com/bug?extid=11036d2e408a419c179c
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1a3746cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/376997b632fc/vmlinux-1a3746cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0920309c4838/bzImage-1a3746cc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11036d2e408a419c179c@syzkaller.appspotmail.com

assertion failed: !btrfs_extent_map_is_compressed(em), in fs/btrfs/extent_io.c:1720
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:1720!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 24 Comm: kworker/u4:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_metadata_space
RIP: 0010:submit_one_sector fs/btrfs/extent_io.c:1720 [inline]
RIP: 0010:extent_writepage_io+0x1022/0x11a0 fs/btrfs/extent_io.c:1826
Code: 28 fd 90 0f 0b e8 9e 6b c7 fd 48 c7 c7 20 aa 17 8c 48 c7 c6 e0 c0 17 8c 48 c7 c2 a0 aa 17 8c b9 b8 06 00 00 e8 af d4 28 fd 90 <0f> 0b e8 77 6b c7 fd 48 c7 c7 20 aa 17 8c 48 c7 c6 80 c1 17 8c 48
RSP: 0000:ffffc9000031edc0 EFLAGS: 00010246
RAX: 0000000000000053 RBX: 0000000000000002 RCX: 2628df0bc8950a00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffea00014e8dc0 R08: ffffc9000031eb47 R09: 1ffff92000063d68
R10: dffffc0000000000 R11: fffff52000063d69 R12: 0000000000001000
R13: dffffc0000000000 R14: ffff88803fc2b2f0 R15: 000000000051f000
FS:  0000000000000000(0000) GS:ffff88808c848000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2289ad1000 CR3: 000000003f92d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 extent_writepage fs/btrfs/extent_io.c:1936 [inline]
 extent_write_cache_pages fs/btrfs/extent_io.c:2593 [inline]
 btrfs_writepages+0x17a1/0x28b0 fs/btrfs/extent_io.c:2725
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 filemap_writeback mm/filemap.c:388 [inline]
 filemap_flush_nr+0x21b/0x360 mm/filemap.c:463
 start_delalloc_inodes+0x4cf/0xab0 fs/btrfs/inode.c:8752
 btrfs_start_delalloc_roots+0x513/0x790 fs/btrfs/inode.c:8812
 shrink_delalloc fs/btrfs/space-info.c:773 [inline]
 flush_space+0x73c/0xde0 fs/btrfs/space-info.c:883
 do_async_reclaim_metadata_space+0x3e8/0x940 fs/btrfs/space-info.c:1211
 btrfs_async_reclaim_metadata_space+0x89/0xe0 fs/btrfs/space-info.c:1278
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:submit_one_sector fs/btrfs/extent_io.c:1720 [inline]
RIP: 0010:extent_writepage_io+0x1022/0x11a0 fs/btrfs/extent_io.c:1826
Code: 28 fd 90 0f 0b e8 9e 6b c7 fd 48 c7 c7 20 aa 17 8c 48 c7 c6 e0 c0 17 8c 48 c7 c2 a0 aa 17 8c b9 b8 06 00 00 e8 af d4 28 fd 90 <0f> 0b e8 77 6b c7 fd 48 c7 c7 20 aa 17 8c 48 c7 c6 80 c1 17 8c 48
RSP: 0000:ffffc9000031edc0 EFLAGS: 00010246
RAX: 0000000000000053 RBX: 0000000000000002 RCX: 2628df0bc8950a00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffea00014e8dc0 R08: ffffc9000031eb47 R09: 1ffff92000063d68
R10: dffffc0000000000 R11: fffff52000063d69 R12: 0000000000001000
R13: dffffc0000000000 R14: ffff88803fc2b2f0 R15: 000000000051f000
FS:  0000000000000000(0000) GS:ffff88808c848000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f22964869c8 CR3: 00000000121e5000 CR4: 0000000000352ef0


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
