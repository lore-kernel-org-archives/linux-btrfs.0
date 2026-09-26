Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A8137DAD7
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790461413; cv=none; b=He7B4L3o93YQ+xZz4XtysokSx7tLRcDGvMS0HLFhb0lCN7mqcUz9P9nBRUipmzZkC8WaYQwB8h6+TFf0jIhJRw83h5k+CYL+ht+bOq2MdzPHNsoGtbJdrTfGHEGApz2AIfRaIrfDGgoKng75DusTn59oJQ1pPLC96qgrhaaOh1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790461413; c=relaxed/simple;
	bh=NPML9+6dXdZoN8Bk0OoABxJWQ+yVtxLx3/drBN0/cKc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JPDad3lt0HG2RivhnYG71xzdixcjesoinPCEkrPcP9xUMhLoCfnfF9fjNlvQWfGVCiOPvEAHLQtd1mAqS5cHJl6xrTAgfndGJFmPsEP1oUqrwNI+ddcqT8Ed4PUxr0h8pQ2gqqV7vgT5V+cqxpgEoiC1p6NHUWgBOCxJEPwN+3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c467e19391so4259012b6e.3
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 15:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790461410; x=1791066210;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zgnMvF8k80MkelLr8yx24geDiGOybqGlTuTOlprauxA=;
        b=aTO2Sg9jmMN1IJCoO+RYazyRAtKt0zzphvEQuUYKlVrRBnXFXqLK/zoUA0011fobxs
         GJQBOytO16HLc26tjSpBrmgTOW1PjdUFHjyVjxjF3lllRD1C9Vme1N+PMEzd6qmZfoC5
         GWmrrPDH7uvmRgj7itAj4QjIV2KU6LjHpD3fUpAidkWvGZBaAhYFmq36u2Fd1jh3AHGl
         KFfB1n8dcYN2VomIhU531EQ1KL1W/y71pqbDWepRvXH4TyKa050RJFXQSfwzkjLTxGNE
         JrsnHMhHCi9B9YA5jA/0LLoSWx4vUvQLoHDgI7neklrCqEz/MBD6nBS6CHVSsTrGdR2v
         cJjA==
X-Forwarded-Encrypted: i=1; AKwUvBzglC5BcciINvqrLiU92f9aB/1WIOOA4Cq8eEINT5lRh+9MFTi1f7bxaYMYyC74viQUUe5nStpRa1jO3w==@vger.kernel.org
X-Gm-Message-State: AFuF++nsbe4pAAGbGI4YQFMAcOO6QMNmknZmJoySspdXMHDDfJbOZouV
	Za4SBJwh0sW7QvaYYC+M0v+Q8N+PbTeVkMo5hryDhcMZekbfD78/JBxezmrDsxTeGIqsfyhAmjh
	F/4BitH/aDbqz4IFiD2rPPqQL7Zb/fS5nho2336ca2vb7FADUEC3RMenjtcE=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe0:b0:4d6:90d3:e187 with SMTP id
 5614622812f47-4d72ea5cc31mr10616995b6e.48.1790461410569; Sat, 26 Sep 2026
 15:23:30 -0700 (PDT)
Date: Sat, 26 Sep 2026 15:23:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab845e2.e548f532.1ca396.0034.GAE@google.com>
Subject: [syzbot] [btrfs?] WARNING in btrfs_add_reserved_bytes (2)
From: syzbot <syzbot+9f330950ca662bc43bf0@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    165768bb7026 Merge tag 'firewire-fixes-7.3-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16701205580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=9f330950ca662bc43bf0
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17920205580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177ed205580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-165768bb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8937d1c35787/vmlinux-165768bb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/04f73e6326ff/bzImage-165768bb.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/959597fde8f7/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1208e2c9580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f330950ca662bc43bf0@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: fs/btrfs/space-info.h:286 at btrfs_space_info_update_bytes_may_use fs/btrfs/space-info.h:286 [inline], CPU#0: syz-executor/5443
WARNING: fs/btrfs/space-info.h:286 at btrfs_add_reserved_bytes+0x51b/0x8b0 fs/btrfs/block-group.c:4029, CPU#0: syz-executor/5443
Modules linked in:
CPU: 0 UID: 0 PID: 5443 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:btrfs_space_info_update_bytes_may_use fs/btrfs/space-info.h:286 [inline]
RIP: 0010:btrfs_add_reserved_bytes+0x51b/0x8b0 fs/btrfs/block-group.c:4029
Code: ac 24 80 00 00 00 74 08 48 89 ef e8 2f b4 f6 fd 4c 8b 75 00 4c 89 f7 4c 89 ee e8 30 14 85 fd 4d 39 ee 73 18 e8 56 11 85 fd 90 <0f> 0b 90 45 31 f6 eb 2e e8 48 11 85 fd e9 f8 fb ff ff e8 3e 11 85
RSP: 0018:ffffc90001e1ec10 EFLAGS: 00010293
RAX: ffffffff8442dbba RBX: 1ffff1100889b910 RCX: ffff888000bc4b00
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffff8880444dc880 R08: ffffffff907a847f R09: 1ffffffff20f508f
R10: dffffc0000000000 R11: fffffbfff20f5090 R12: ffff8880444dc800
R13: 0000000000001000 R14: 0000000000000000 R15: ffff8880444dc820
FS:  000055559168c500(0000) GS:ffff88808c2bf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555916a7a28 CR3: 000000001f9a3000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 find_free_extent+0x3ff4/0x5cd0 fs/btrfs/extent-tree.c:4776
 btrfs_reserve_extent+0x349/0x850 fs/btrfs/extent-tree.c:4904
 btrfs_alloc_tree_block+0x1ed/0x1160 fs/btrfs/extent-tree.c:5375
 btrfs_force_cow_block+0x562/0x1bf0 fs/btrfs/ctree.c:501
 btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
 btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
 btrfs_insert_empty_items+0xa3/0x1a0 fs/btrfs/ctree.c:4310
 btrfs_insert_delayed_item fs/btrfs/delayed-inode.c:755 [inline]
 btrfs_insert_delayed_items fs/btrfs/delayed-inode.c:832 [inline]
 __btrfs_commit_inode_delayed_items+0xb0e/0x1ec0 fs/btrfs/delayed-inode.c:1115
 __btrfs_run_delayed_items+0x1d0/0x420 fs/btrfs/delayed-inode.c:1158
 btrfs_commit_transaction+0x844/0x3170 fs/btrfs/transaction.c:2383
 sync_filesystem+0x1d2/0x240 fs/sync.c:66
 generic_shutdown_super+0x77/0x2d0 fs/super.c:734
 kill_anon_super+0x3b/0x70 fs/super.c:1356
 btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2152
 deactivate_locked_super+0xbc/0x110 fs/super.c:589
 cleanup_mnt+0x3d3/0x460 fs/namespace.c:1317
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f68fe39f397
Code: a2 c7 05 5c 43 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fffcd75c7e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f68fe4344bb RCX: 00007f68fe39f397
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fffcd75c8a0
RBP: 00007fffcd75c8a0 R08: 00007fffcd75d8a0 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffcd75d930
R13: 00007f68fe4344bb R14: 000000000006482c R15: 00007fffcd75d970
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
