Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB84215075
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786322071; cv=none; b=Z9+qzLa47be3o3hni6uEVcZ3KYhzOeZV5+MOYOphobZSGQUOnO27eyDSHwTQI/fvtXqx1ZrfNjN2vpmYQqn/qHM9URbrUCeDS21T3Z5s7R1nsGwOt6XthUevNkfmNVnIArRwpbOuXlKDK8N69T+p/jQOkdluvUT3fCK3/n31nds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786322071; c=relaxed/simple;
	bh=Tqq+gSWOUfswIoZP77Io+QWdLXiOFhXKNULLuD4Q/QI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZMnnPdLnk9B6aHLVJdipexTxq+Rn5IgwJHzp4dM+TotlHAZ3JBGHA9TEe3gBJ/NRKFYp6G41CyhMArYS8E38vNzfkOPGeoUZ714O6aGvZdoZTal16yiAVkOh5Ry5dQjmBjqxDUp0p/DF8AhyN7GRYAP/0vzx6La26cHbSMyWghY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7ebfcb4c999so2217079a34.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 17:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786322068; x=1786926868;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mDzf2PQuyzGK1ykg5zMa58wZtreRHGRIgzpNZ/559A8=;
        b=E1pR6QL07hgT0J5Jbie5fIuskgqC0lQYuzlACIrjsGnUmeL3dAP1keu4tHFVv2Gq8V
         sSs+R1vzn6TzEXoUzzzoHIkCg/VthTdW+4OLT4gxkvlwOX8B6dB2dvUjbeti9mhqNpDW
         J0LRvXtyFX6d3zzYwWgk4Cu81YLKbGQzQvdWP1aLvAEA2DNcJWiYdPOjuv6/J2yBDDob
         8bCgj7QNvHMFoFTgvAL3du3+OJGagNr3UQDeGcnxuwrqTRjaehDrZgmt7tYL7dLBNsrQ
         r3ij2jA2oXwhFid/PJ7sQ8ygwe63DRCfM1/lbmbWNnzG68kW2rHHkbkv9n29YSSa+YVw
         lUog==
X-Forwarded-Encrypted: i=1; AHgh+RqCAnnfRvPrHDX9L7vL58AeL1cNj3adcODDQfI7rk+D5fWeq78ntv5ZxDq4leS3/oD72lRFJRT3uixNyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzThRrq+Yl9W3ptPrICMTa5I+voXrAXX4ax+K8QXu6EeIPYu0/i
	5cbuPhseyxr/EdoTuVB5vJa4GUS5jV0eUeG6vgWIEaBnAPbRIdj+mjgnKD2alKPdqLz1qVdWkVX
	BSuxQ0doswpQHZ588cWHLSFQdYPCssI+dkiGuPHFjO6X0x7qDo5Do0k4WiKU=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1905:b0:6aa:e524:fd7f with SMTP id
 006d021491bc7-6ae970b941bmr20619107eaf.34.1786322068574; Sun, 09 Aug 2026
 17:34:28 -0700 (PDT)
Date: Sun, 09 Aug 2026 17:34:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a791c94.01d0871a.3a0d52.009a.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in __add_block_group_free_space
From: syzbot <syzbot+6931616d57696102d8aa@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    06cf61899d64 Merge tag 'x86-urgent-2026-08-08' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b27fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
dashboard link: https://syzkaller.appspot.com/bug?extid=6931616d57696102d8aa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-06cf6189.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2c3ef8ca53e1/vmlinux-06cf6189.xz
kernel image: https://storage.googleapis.com/syzbot-assets/52ac12d71a9c/bzImage-06cf6189.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6931616d57696102d8aa@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/free-space-tree.c:1440 at __add_block_group_free_space+0x5a3/0x5b0 fs/btrfs/free-space-tree.c:1440, CPU#0: kworker/u4:3/41
Modules linked in:
CPU: 0 UID: 0 PID: 41 Comm: kworker/u4:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_metadata_space
RIP: 0010:__add_block_group_free_space+0x5a3/0x5b0 fs/btrfs/free-space-tree.c:1440
Code: 07 38 c1 0f 8c ce fc ff ff 4c 89 f7 e8 76 bc 00 fe e9 c1 fc ff ff e8 1c 87 91 fd eb 10 e8 15 87 91 fd eb 09 e8 0e 87 91 fd 90 <0f> 0b 90 44 89 e1 f7 d9 e9 51 fe ff ff 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc900004374b8 EFLAGS: 00010293
RAX: ffffffff84358aa2 RBX: ffff888051eb8001 RCX: ffff88801ae58000
RDX: 0000000000000000 RSI: ffffffff8f1f5b20 RDI: 00000000ffffffe4
RBP: ffff888042b61490 R08: ffff88801ae58000 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: 00000000ffffffe4
R13: ffff8880435d3790 R14: ffff888042b614f0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808c549000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b6397df5f8 CR3: 00000000407ef000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 btrfs_add_block_group_free_space+0xd0/0x130 fs/btrfs/free-space-tree.c:1465
 btrfs_create_pending_block_groups+0xcc6/0x15e0 fs/btrfs/block-group.c:2952
 __btrfs_end_transaction+0x140/0x640 fs/btrfs/transaction.c:1092
 flush_space+0x3e9/0xde0 fs/btrfs/space-info.c:912
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
