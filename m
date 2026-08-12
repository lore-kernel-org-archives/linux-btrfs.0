Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4911A3165
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 00:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786493555; cv=none; b=UjAphuP/r/HUsG9l17dvPO9pSJ9NvpKyB2KyK93YqPjiVYnN3MTWMS+TEG9GatikqlgR9fcF/lyAmDsjpIhlIa1B0A6hKG4cuPLDIxK0g6sq12THQXhqjPDmILi8XmCP2HqsV2fA1ehLIIkZpvTYin+nGEbuybWpscPcNGDWIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786493555; c=relaxed/simple;
	bh=ubo+/Gaw9JwQBmjqOMiVQ1soIHjzt5XaVwlHOjihHDQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PJsXf/ZluP5A7wm1FRUl1lXadt1uxSKFFxeM81vnC6Ou9OF6Uf+ILH4v/852SmzGYOXRXgUScwfOIlbczC1zr+FuK97P2RUzgLscn2f/B+ByqJIu8ZQzpJWn2n0gKgWyD74bhnOmT2oSFLSs82t7ySm+p6nYgll8hTkxCDJO9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4b1bc2e44e0so514009b6e.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 17:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786493550; x=1787098350;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GaZJnBJ9c00c6qKiRZD2tbC7KQvTO8pZobLhqlvkl1Q=;
        b=NAiYwlNTJVqao9CNdDp1QDfV/1ti8P6ZhRLcWdaRyyzJuL0V6M0paR1ygQ3/yw//Tb
         xoGF+tmITl5Iq36riQgJyDRq0ZBKtDo1iHz4igHp5fqnwNAV7tGsCJ50rRAhO8y1vIzy
         NFigS4XHe4G2Nxbxc8aUiYs87hHehILbRIvrgxV0P+lFVI8x5PG+gPHGvL2WiytvJJ7h
         hBEuOVayXlbXskLzKkHsBeO0lkOTteLZ9QaKz8SMizS2C2ojZO0wWRr+8ua6J3tZM8mz
         0jj951nPryo9kgDCkn3XibvQvi7LQ8cwL/gowWpp3568awhSStvV2XXlOD8GSz04mldR
         Vtwg==
X-Forwarded-Encrypted: i=1; AHgh+RrIeBINAlVS8LStRzUMd0V/LTb2eyqHJ3x6ZfPiNz8DzEIbVzL6sE65QTlyeY82zUA6BiNxCXvg7/IOPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLSUTeC1Hv423NaGClm+nGH5SuctDZPy9ERHi1KyWzb/jBVfL8
	wazTpeE0fVoRheLTilq1z5pL+x70n/6er9/CQ2pvxQEECDK5oo37Svv4JE4Tbhb1NM7A34FR8mi
	8yQMA/0J6IBS30/G2gI3a1chOu2F3/AgMHGTdOpkgk2Fv5DvLzLiMODkgJh4=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:138e:b0:4b1:b83a:5888 with SMTP id
 5614622812f47-4b210bcbf1cmr1041178b6e.14.1786493550378; Tue, 11 Aug 2026
 17:12:30 -0700 (PDT)
Date: Tue, 11 Aug 2026 17:12:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7bba6e.c5ad36c8.12f49d.0024.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in __btrfs_run_delayed_items (3)
From: syzbot <syzbot+32e33c1af28c9b98ac7d@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f9a2394a2348 Merge tag 'mm-hotfixes-stable-2026-08-06-18-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=150fbe49580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd7fa9e412f91f87
dashboard link: https://syzkaller.appspot.com/bug?extid=32e33c1af28c9b98ac7d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f9a2394a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/44414e53d5ba/vmlinux-f9a2394a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a70c6743385f/bzImage-f9a2394a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32e33c1af28c9b98ac7d@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/delayed-inode.c:1161 at __btrfs_run_delayed_items+0x3dd/0x420 fs/btrfs/delayed-inode.c:1161, CPU#0: kworker/u4:0/12
Modules linked in:
CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_metadata_space
RIP: 0010:__btrfs_run_delayed_items+0x3dd/0x420 fs/btrfs/delayed-inode.c:1161
Code: c1 38 c1 0f 8c be fc ff ff 4c 89 ff e8 9c 14 0c fe e9 b1 fc ff ff e8 c2 e0 9c fd eb 10 e8 bb e0 9c fd eb 09 e8 b4 e0 9c fd 90 <0f> 0b 90 44 89 e1 f7 d9 e9 41 ff ff ff e8 a1 e0 9c fd 48 c7 c7 60
RSP: 0018:ffffc9000025f7b0 EFLAGS: 00010293
RAX: ffffffff842a322c RBX: ffff8880443bd580 RCX: ffff88801cedca80
RDX: 0000000000000000 RSI: ffffffff8f1e9f80 RDI: 00000000ffffffe4
RBP: 0000000000000001 R08: ffff88801cedca80 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: 00000000ffffffe4
R13: ffff8880441375a0 R14: ffff888050fd0000 R15: 1ffff11008877ab0
FS:  0000000000000000(0000) GS:ffff88808c54a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f22f3b039a0 CR3: 000000003f106000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 flush_space+0x5fd/0xde0 fs/btrfs/space-info.c:875
 do_async_reclaim_metadata_space+0x3e8/0x940 fs/btrfs/space-info.c:1211
 btrfs_async_reclaim_metadata_space+0x89/0xe0 fs/btrfs/space-info.c:1278
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
