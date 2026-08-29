Received: from mail-oi2-f5.google.com (mail-oi2-f5.google.com [74.125.231.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496B527E07E
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2026 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787986958; cv=none; b=lBmXswRxK50iVsObtoZtuLLi3/29PIZ7u/3mM3SKIHMIO1z5caqj7t16HVX9MIQKPCWdo3xOKuxs9JU0cIQin8r/zN4VeqYZzzHXzN2q3eUxYKI0VAYKbcZiPq6iWBBQZjVQ6etQ+xD1vwMbYpF69Dn25kHWkYO9RRO9Kx/NLxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787986958; c=relaxed/simple;
	bh=kbNeXW/ICKHU30aJ/o4rsV0t4dRnuC4Lb/lKpiyyjL0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M8l48/A+jPt3b6TmmfSYLDSq+rZJXbnfERFYGDrbX/q9rVsKkSlppVXNA1HyhkUbfMaavX4aqQo6HekhbfloJonM3t7CKqabtI4RmgLstmSwfbqq9sABU2NSIguOOXe9pKtSGXiIjWReSPiL3CxPAKNWb2HOKBr1RgdbnQuc2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f5.google.com with SMTP id 46e09a7af769-7f4e10aa28cso298324a34.0
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2026 00:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787986956; x=1788591756;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DUXjaMzi5/EgJKrAoped5owNC5y56qkeKiobRo8ozcI=;
        b=dSqy+P/eb0HCum4sJScaJwGcaT42+xY/A37DAu/nXnXmTblNSW5Mmi7S/Br7d/LKge
         xbr6WtIfx3us1Ly1R9aVRNMnH+5Hlx84dTso+tev+WMwANZPPYFmZjSizaLhtbaidR7j
         gpk+ISi7FsNeKPE1lR/Mm5NdK+RFRniGS43vRO3btAeCQA5TNw+3WC7CrOrG2DQMSBDT
         HDHgRYQmlNqqb9zLGPlg3CX5avC4FKU9GVCelfzScP/USlOR0NGwPUuML+EsjyPionDr
         Y8MKDsvivIXiWwlm8v4UOgdbJ/UhRTIxRNggVTehifYW1bR5v3oahPi5q5mkLIJA0uxO
         XLCw==
X-Forwarded-Encrypted: i=1; AHgh+RqT4g82nmClQ8hmu+HPz8xTD/nOgqH848eRUWERFknOMTlKHccOWuDHjwaVMSeLUBok13S+Y988T1rE6w==@vger.kernel.org
X-Gm-Message-State: AFuF++npRpmM5ux4PXJ7aCfrnDhmQH8g3oYDikHqKgchDVyClxfG5DR+
	7HXxLGF+smx+HmTEbkPM3xtl7Xe/iILp/reaaIrwv9Ums1UO1ydWW8V4UH7CaEKAQfcgDOd2s1u
	w6bkk9gkOt4SUlc897uym02MTX/sDSvoHOozEqU2qBDVm4uZMi9/8q0Vjrw0=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6d92:b0:489:5d05:552c with SMTP id
 5614622812f47-4b398352104mr14860732b6e.18.1787986956323; Sat, 29 Aug 2026
 00:02:36 -0700 (PDT)
Date: Sat, 29 Aug 2026 00:02:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a92840c.1d9ded08.62e62.0105.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_remove_from_free_space_tree
From: syzbot <syzbot+df8b249da18c45425242@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16467549580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c35c7e43de75adb
dashboard link: https://syzkaller.appspot.com/bug?extid=df8b249da18c45425242
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9adea981957f/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6676075cd03e/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df8b249da18c45425242@syzkaller.appspotmail.com

------------[ cut here ]------------
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/free-space-tree.c:869 at btrfs_remove_from_free_space_tree+0xbcd/0xda0 fs/btrfs/free-space-tree.c:869, CPU#0: kworker/u4:2/24
Modules linked in:
CPU: 0 UID: 0 PID: 24 Comm: kworker/u4:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound btrfs_async_reclaim_metadata_space
RIP: 0010:btrfs_remove_from_free_space_tree+0xbcd/0xda0 fs/btrfs/free-space-tree.c:869
Code: e2 74 1a 41 83 ff fb 74 0d 41 83 ff f4 75 15 e8 29 c1 8c fd eb 17 e8 22 c1 8c fd eb 10 e8 1b c1 8c fd eb 09 e8 14 c1 8c fd 90 <0f> 0b 90 44 89 f9 f7 d9 49 bd 00 00 00 00 00 fc ff df e9 5d fe ff
RSP: 0018:ffffc9000031ef60 EFLAGS: 00010293
RAX: ffffffff843a73ac RBX: ffff888052270001 RCX: ffff88801b7b4b00
RDX: 0000000000000000 RSI: ffffffff8f3ffd50 RDI: 00000000ffffffe4
RBP: ffffc9000031f158 R08: ffff88801b7b4b00 R09: 0000000000000003
R10: 00000000fffffffb R11: 0000000000000000 R12: 1ffff92000063df8
R13: dffffc0000000000 R14: ffff88801f5fb580 R15: 00000000ffffffe4
FS:  0000000000000000(0000) GS:ffff88808c30a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000007ff000 CR3: 000000000eb46000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_reserved_extent+0x4a/0x2b0 fs/btrfs/extent-tree.c:4976
 alloc_reserved_tree_block fs/btrfs/extent-tree.c:5155 [inline]
 run_delayed_tree_ref fs/btrfs/extent-tree.c:1815 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
 __btrfs_run_delayed_refs+0x18b5/0x43b0 fs/btrfs/extent-tree.c:2134
 btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
 btrfs_commit_transaction+0x28a/0x30b0 fs/btrfs/transaction.c:2256
 flush_space+0x28a/0xde0 fs/btrfs/space-info.c:-1
 do_async_reclaim_metadata_space+0x3e8/0x940 fs/btrfs/space-info.c:1211
 btrfs_async_reclaim_metadata_space+0x89/0xe0 fs/btrfs/space-info.c:1278
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
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
