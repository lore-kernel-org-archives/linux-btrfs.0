Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792595984;
	b=ZR8c8ySsQGOOhFP7JsO7UZZ6EcbHzEos0CDp/3irfVVfpLyuRHZE6TgynfRZAuHArnXM
	 6TD3/CyyKWENMUdMyynl18WX/kMxtQ4PZiTvzB2rWYuDMb1urxYBfvU2CCeLZ577gg4Ny
	 FuD3MnMkVBEQagKqkz0V7cstXOuYAmwdBERrZ1IP6eitKYlj79xhS6P3yRlZGly6omyOZ
	 YFl9hnpkSnlIbM3JP0Dgm0U7yG7EmyAyDggXsf0jltMEvIqqjM0GsxzanWmuk+qZrCO8C
	 /1BSmlhGQDGICQp2RB4R2VO59WkI39y2fR7jo9YjO2w1ceVs4iDudk9EvWppbAmYYeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792595984;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=d6dYEZiRYfGwCqAqnaEdKoo/lnjbYlfq/+kGQXWT0XY=;
	b=oCJllRABWeqmY3phKYtyT/MpbuBVPhh79GydLvOmqu3A+acNTbUnIYgrJzubvG3g5S1y
	 PVjpPdnDGmkNfxw2ePqFeRVwiy0SbFySfsQ1i4yBDMK0pGvyRdwqMKp8Oq3P7CLmrmlzD
	 zljiSw2mUv86IBiVZkuz0QjMWbeJI34ODVPRC4/S1T5sCZjdNVDiADBysIbJ3rIgOuX+g
	 ObdH8GANvsY3fYpj/ZnbpMc3QwoGqyGdV8kX3upPL9yDrI8HMJs6PbPjZ+/lMpcq00Fql
	 Pcg0zO7VPgbqVg/TF05pLCNdFd7iOH8+RJ29Rw/MWLEUEdrdRJgi/awQE/tMCm3mEAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900CD606A31D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 15:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 900CD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f8281066c4so942906b6e.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 08:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792595982; x=1793200782;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6dYEZiRYfGwCqAqnaEdKoo/lnjbYlfq/+kGQXWT0XY=;
        b=HjKDZSyZf39kWMVfcDZW+xszlQz5b0M/U+QVOMe/alx5F8rdhVwrnnd71AAvVgAdlR
         7bgtIMyRO6F5hyK6SDh6JI7fjqY8iG6m+938p1jdJlX3ClEooD+CBt6QI1kAfZOgf1FD
         0CCSK0lpB81lfrX0ximvv2Ln1eId241UF7AnxGmlwekMQuE3ljl7JiA9sFZAr8/ha9Xf
         QMMlYNjFg+KOPq3WDyHkFLl8p4y+QTZZlpZQgxdVWgEdfG6ZyO3UMKY0ncDbWWJsG08s
         n7b5mYiF642KdGbeoYrnjWEx0NaCMSoWVeELx2Dz0LDgTNau3q1s4th/6kYvp7TytBsi
         vOcA==
X-Forwarded-Encrypted: i=1; AKwUvBw3xc+KKQRlw2cJxdVXGyoHvtIpUa6OZS3z2eIzG0ACgvz9hutbMT0RNFeZHM/w8u45pLv5Fxn2gLfcQA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLTu0Ca26ByD2bwulSURmXeuHVTfISbh6CP0KMG3z/nZlYyLo8p
	/o0iAM3j04HF5X1w2BbpooUhKxvAalIxmUTi7mKcAAENFh+brgyGjX6pwfYplXcxiH2EPTq9LFH
	cdwYQY+3jpCylqM9ezvTriWGJkYH1ogvm7qmxvy8piPoLzLksS3CqRwb110Q=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f03:b0:54c:d3dc:b544 with SMTP id
 5614622812f47-5535af1ce64mr1308186b6e.32.1792595982507; Wed, 21 Oct 2026
 08:19:42 -0700 (PDT)
Date: Wed, 21 Oct 2026 08:19:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad8d80e.d1c214cc.659fa.0028.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_put_transaction (6)
From: syzbot <syzbot+08b7cbf4e9ac1f9139bf@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    58161ead29e5 Merge tag 'drm-fixes-2026-10-17' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d89621580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
dashboard link: https://syzkaller.appspot.com/bug?extid=08b7cbf4e9ac1f9139bf
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-58161ead.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b76eb31da21c/vmlinux-58161ead.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fca526cf319c/bzImage-58161ead.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+08b7cbf4e9ac1f9139bf@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 00007fc8df425fa0 RCX: 00007fc8df19e559
RDX: 000020000001e740 RSI: 000000008004587d RDI: 0000000000000008
RBP: 00007fc8df235ab8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc8df426038 R14: 00007fc8df425fa0 R15: 00007ffe864adf08
 </TASK>
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 5, space 0, times 9992
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x410/0x560 lib/fault-inject.c:174
 should_failslab+0xa8/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4638 [inline]
 slab_alloc_node mm/slub.c:4974 [inline]
 kmem_cache_alloc_lru_noprof+0xa7/0x5f0 mm/slub.c:5029
 __xas_nomem+0x33d/0x420 lib/xarray.c:341
 __xa_cmpxchg_raw lib/xarray.c:1789 [inline]
 __xa_cmpxchg+0x138/0x1f0 lib/xarray.c:1769
 xa_cmpxchg include/linux/xarray.h:699 [inline]
 xa_reserve include/linux/xarray.h:1088 [inline]
 add_delayed_ref+0x2ac/0x1ed0 fs/btrfs/delayed-ref.c:1073
 btrfs_alloc_tree_block+0xce7/0x1160 fs/btrfs/extent-tree.c:5426
 btrfs_force_cow_block+0x562/0x1bf0 fs/btrfs/ctree.c:501
 btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
 btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
 btrfs_insert_empty_items+0xa3/0x1a0 fs/btrfs/ctree.c:4310
 btrfs_insert_delayed_item fs/btrfs/delayed-inode.c:755 [inline]
 btrfs_insert_delayed_items fs/btrfs/delayed-inode.c:832 [inline]
 __btrfs_commit_inode_delayed_items+0xb0e/0x1ec0 fs/btrfs/delayed-inode.c:1115
 __btrfs_run_delayed_items+0x1d0/0x420 fs/btrfs/delayed-inode.c:1158
 btrfs_commit_transaction+0x844/0x3170 fs/btrfs/transaction.c:2384
 sync_filesystem+0x1d2/0x240 fs/sync.c:66
 freeze_super+0x52e/0x11c0 fs/super.c:2300
 btrfs_ioctl_shutdown+0x146/0x1b0 fs/btrfs/ioctl.c:5183
 btrfs_ioctl+0xbcd/0xd50 fs/btrfs/ioctl.c:5697
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc8df19e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc8e012ffe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc8df425fa0 RCX: 00007fc8df19e559
RDX: 000020000001e740 RSI: 000000008004587d RDI: 0000000000000008
RBP: 00007fc8df235ab8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc8df426038 R14: 00007fc8df425fa0 R15: 00007ffe864adf08
 </TASK>
BTRFS error (device loop0 state A): Transaction 9 aborted (-ENOMEM)
BTRFS: error (device loop0 state A) in __btrfs_run_delayed_items:1161: errno=-12 Out of memory
BTRFS info (device loop0 state EA): forced readonly
BTRFS warning (device loop0 state EA): Skipping commit of aborted transaction.
BTRFS: error (device loop0 state EA) in cleanup_transaction:2074: errno=-12 Out of memory
------------[ cut here ]------------
!xa_empty(&transaction->delayed_refs.head_refs)
WARNING: fs/btrfs/transaction.c:146 at btrfs_put_transaction+0x537/0x570 fs/btrfs/transaction.c:146, CPU#0: syz.0.0/5325
Modules linked in:
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_put_transaction+0x537/0x570 fs/btrfs/transaction.c:146
Code: fd fb ff ff e8 9a e8 ac fd 4c 89 f7 be 03 00 00 00 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 6f 17 c7 00 e8 7a e8 ac fd 90 <0f> 0b 90 e9 65 fb ff ff e8 6c e8 ac fd 90 0f 0b 90 e9 82 fb ff ff
RSP: 0018:ffffc9000f7978b0 EFLAGS: 00010287
RAX: ffffffff841b39b6 RBX: ffff888013966000 RCX: 0000000000100000
RDX: ffffc9000ef1a000 RSI: 000000000002eb87 RDI: 000000000002eb88
RBP: dffffc0000000000 R08: ffff888013966013 R09: 1ffff1100272cc02
R10: dffffc0000000000 R11: ffffed100272cc03 R12: ffff888053ca4758
R13: ffff888054d34d40 R14: ffff888013966350 R15: dffffc0000000000
FS:  00007fc8e01306c0(0000) GS:ffff88808b0b4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc8d3fff000 CR3: 0000000044c6d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 cleanup_transaction+0x5c5/0x7c0 fs/btrfs/transaction.c:2122
 btrfs_commit_transaction+0x2627/0x3170 fs/btrfs/transaction.c:2676
 sync_filesystem+0x1d2/0x240 fs/sync.c:66
 freeze_super+0x52e/0x11c0 fs/super.c:2300
 btrfs_ioctl_shutdown+0x146/0x1b0 fs/btrfs/ioctl.c:5183
 btrfs_ioctl+0xbcd/0xd50 fs/btrfs/ioctl.c:5697
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc8df19e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc8e012ffe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc8df425fa0 RCX: 00007fc8df19e559
RDX: 000020000001e740 RSI: 000000008004587d RDI: 0000000000000008
RBP: 00007fc8df235ab8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc8df426038 R14: 00007fc8df425fa0 R15: 00007ffe864adf08
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
