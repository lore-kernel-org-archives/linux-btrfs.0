Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BDB2DCBF8
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785975211; cv=none; b=guiB22XkLnJTzBg33sBR+nMiW4I0i+ar5mmEuyEFX1ZsLd0DVOTjKDUgBGtb/nta+4JZdz4PP1LNvmrZ14wdICuxTsuKHSWf2mD5ZZZAV/bJbqViF+6XcTFkR1uJZuU/SgJ4Duwjfqs5Tt8Z8neFQZfjpE3LQ9sS9CX10nj2fU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785975211; c=relaxed/simple;
	bh=bjw+MWXXdFoamycPga2NhEFJc0dVESFS0gi9XPNZ9s4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Yc5hvkn4rmy5EH2xRSdH17nKvu9r1b9FiKRt43wm0zKlaCkjNNCxDKn1/ccmYIl696thtuq7s1zp3ARZzVIRcU8lBda944xpsVSzh2y3fh169/DZByV9N96O/dm+Pehp/8kQSdyYqAb0HIuoGrEHEaYtCl3iMLh3AFbUKf8NV2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7ee1e335245so1032362a34.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2026 17:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785975208; x=1786580008;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5kIycxKJtvA0t2yKEJH8tWA7REdFo1NxFn+SdJlk3IQ=;
        b=FnbA5YTdMGmBmUTTQ0vCYpdGAUoER9UrV++isQC+25FDnjw+Zc5pk5JVeUwZXPBC5V
         +k98JGGXcsX1h5GtGebhbVOeNVvke8tJtHxL273rFF4Ety9ArBOXuZC0K15IPohWcjMA
         FlUDuTk2lT+uxxKSFkfKGaKB99C5hi0i8PU2kW+eyUX0JbebhuY/b6dDImqQNQkpbIEI
         xGzXrijCCbPFfpqpFs1Ctxbij8eOitYbiyneihN1y8oVkdoAYjTqEjYi8nP6MJMx5XbD
         eHGfKBhDjyeSWMeSIDalsM28z8/JhRTMG9VFzJ8zCY+tttsGdL0ISbm6hhLraML7821q
         vG2A==
X-Forwarded-Encrypted: i=1; AHgh+Ro42ucRgWMGIkHV5QcN+OCZi9Lm9QiMdVRL+QWHawbInw5ZwXMha3GR4E4OtHwUmNWjr1zvd9Y8bv6tSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2Nz4X12K8nGBG5o6w0SO/YAVCiVaVpTxqCN66+SPHfGpOSCOP
	QvkC+me2ODj6ANx7/kC22/6Dod/A/fG5SF6xN+cPRKryk1h0UNy2In6hf40EKUYXLe/RKhj40HS
	tJRp/ixXDLpEGohBXFL4ekvoU347/dXuNhPNHGRZ7bFs+5h/Mq3NnF+Hc9pw=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b14:b0:6a3:7ad3:e728 with SMTP id
 006d021491bc7-6ae96f3a250mr4983105eaf.28.1785975208413; Wed, 05 Aug 2026
 17:13:28 -0700 (PDT)
Date: Wed, 05 Aug 2026 17:13:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a73d1a8.b50370da.49fe0.0008.GAE@google.com>
Subject: [syzbot] [btrfs?] kernel BUG in set_state_bits (2)
From: syzbot <syzbot+64579ad11e26758151bc@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    02dc699f83d0 Merge tag 'kbuild-fixes-7.2-1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1563cc9e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=64579ad11e26758151bc
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-02dc699f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e86689246460/vmlinux-02dc699f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f3bbc4a2d804/bzImage-02dc699f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+64579ad11e26758151bc@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
BTRFS: device fsid 395ef67a-297e-477c-816d-cd80a5b93e5d devid 1 transid 8 /dev/loop0 (7:0) scanned by syz.0.0 (5327)
BTRFS info (device loop0): first mount of filesystem 395ef67a-297e-477c-816d-cd80a5b93e5d
BTRFS info (device loop0): using sha256 checksum algorithm
BTRFS warning (device loop0): space cache v1 is being deprecated and will be removed in a future release, please use -o space_cache=v2
BTRFS info (device loop0): rebuilding free space tree
BTRFS info (device loop0): disabling free space tree
BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
BTRFS info (device loop0): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
BTRFS info (device loop0): enabling ssd optimizations
BTRFS info (device loop0): enabling disk space caching
BTRFS info (device loop0): force clearing of disk cache
BTRFS info (device loop0): enabling auto defrag
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5327 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40c/0x560 lib/fault-inject.c:174
 should_failslab+0xa8/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4539 [inline]
 slab_alloc_node mm/slub.c:4897 [inline]
 __kmalloc_cache_noprof+0xa8/0x660 mm/slub.c:5485
 _kmalloc_noprof include/linux/slab.h:988 [inline]
 ulist_add_merge+0x18d/0x4b0 fs/btrfs/ulist.c:222
 add_extent_changeset fs/btrfs/extent-io-tree.c:203 [inline]
 set_state_bits+0x1d3/0x3a0 fs/btrfs/extent-io-tree.c:400
 set_extent_bit+0x904/0x1c60 fs/btrfs/extent-io-tree.c:1217
 btrfs_set_record_extent_bits+0x50/0x90 fs/btrfs/extent-io-tree.c:1959
 qgroup_reserve_data+0x26e/0x8e0 fs/btrfs/qgroup.c:4279
 btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4323
 btrfs_check_data_free_space+0x2e0/0x490 fs/btrfs/delalloc-space.c:166
 reserve_space fs/btrfs/file.c:1114 [inline]
 copy_one_range fs/btrfs/file.c:1212 [inline]
 btrfs_buffered_write+0x4b2/0x1690 fs/btrfs/file.c:1376
 btrfs_do_write_iter+0x300/0x790 fs/btrfs/file.c:1452
 do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
 vfs_writev+0x343/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15bf79e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f15c05c9fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f15bfa25fa0 RCX: 00007f15bf79e019
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000006
RBP: 00007f15c05ca050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7b R11: 0000000000000246 R12: 0000000000000001
R13: 00007f15bfa26038 R14: 00007f15bfa25fa0 R15: 00007fff02c34098
 </TASK>
BTRFS critical (device loop0): panic in set_state_bits:402: extent io tree error on add_extent_changeset state start 20480 end 61439 (errno=-12 Out of memory)
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-io-tree.c:402!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5327 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:set_state_bits+0x396/0x3a0 fs/btrfs/extent-io-tree.c:402
Code: 46 25 8e ba 92 01 00 00 44 89 e9 49 c7 c0 20 55 3b 8c 49 c7 c1 80 55 3b 8c 48 8b 04 24 ff 30 53 e8 4f e3 ed fc 48 83 c4 10 90 <0f> 0b 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f8775d0 EFLAGS: 00010282
RAX: f2fc0c23b03a6e00 RBX: 0000000000005000 RCX: 1ffff92001f0ee9c
RDX: 0000000000000003 RSI: ffffffff8e4b7282 RDI: ffff88803ee18000
RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffff88801acecad0
R13: 00000000fffffff4 R14: ffff88800e73c000 R15: 1ffff1100359d971
FS:  00007f15c05ca6c0(0000) GS:ffff88808c53f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000f000 CR3: 000000004365a000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 set_extent_bit+0x904/0x1c60 fs/btrfs/extent-io-tree.c:1217
 btrfs_set_record_extent_bits+0x50/0x90 fs/btrfs/extent-io-tree.c:1959
 qgroup_reserve_data+0x26e/0x8e0 fs/btrfs/qgroup.c:4279
 btrfs_qgroup_reserve_data+0x2e/0xb0 fs/btrfs/qgroup.c:4323
 btrfs_check_data_free_space+0x2e0/0x490 fs/btrfs/delalloc-space.c:166
 reserve_space fs/btrfs/file.c:1114 [inline]
 copy_one_range fs/btrfs/file.c:1212 [inline]
 btrfs_buffered_write+0x4b2/0x1690 fs/btrfs/file.c:1376
 btrfs_do_write_iter+0x300/0x790 fs/btrfs/file.c:1452
 do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
 vfs_writev+0x343/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15bf79e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f15c05c9fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f15bfa25fa0 RCX: 00007f15bf79e019
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000006
RBP: 00007f15c05ca050 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7b R11: 0000000000000246 R12: 0000000000000001
R13: 00007f15bfa26038 R14: 00007f15bfa25fa0 R15: 00007fff02c34098
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:set_state_bits+0x396/0x3a0 fs/btrfs/extent-io-tree.c:402
Code: 46 25 8e ba 92 01 00 00 44 89 e9 49 c7 c0 20 55 3b 8c 49 c7 c1 80 55 3b 8c 48 8b 04 24 ff 30 53 e8 4f e3 ed fc 48 83 c4 10 90 <0f> 0b 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f8775d0 EFLAGS: 00010282
RAX: f2fc0c23b03a6e00 RBX: 0000000000005000 RCX: 1ffff92001f0ee9c
RDX: 0000000000000003 RSI: ffffffff8e4b7282 RDI: ffff88803ee18000
RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffff88801acecad0
R13: 00000000fffffff4 R14: ffff88800e73c000 R15: 1ffff1100359d971
FS:  00007f15c05ca6c0(0000) GS:ffff88808c53f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000f000 CR3: 000000004365a000 CR4: 0000000000352ef0


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
