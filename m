Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5C2319617
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337956; cv=none; b=rVHcVpRhwS0FgQmFFiVh4vTOaP/1UrPL/N9zLwtBbswhP2sTm3MJBuVkzhCoN/S6dc9ETPh6Xb/FAoVgBNer0tDMzYz6dr6L+bQS8DmYmX24R/9LuOhnutORVUd9KXR5fqkKPFFluyulKXgBgFGPK0BGrwrMRgFnyE1pVhjNVlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337956; c=relaxed/simple;
	bh=WWLad+SEr7e9JuF7hdeZJsZbqRr06mF+W0UBd7VyATk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r+XdXfggvJUncb6ftpGYbspgrO7kX8itQVG2tvjrfwEexkBVW6B6nJpD3eegP2ZiA67PYPQq8Ks2qAWAx0Fkk1wB3yKZhkCsr0ypw9Kg1Zew8BiLdw9tp0ClTqogzuQaTyv5+50MlaRk6ehp08/AVvFhQUHqEYD4X+bbNAmqv2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b38ea4c6acso3147001b6e.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Oct 2026 18:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337953; x=1791942753;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mg5IJEKwNggXAnN6aQLS4oZwLkPC0tljc12SAxzvFn0=;
        b=s4e9siCtASF5eXoeX3h2poB/3VpZaBrt9fdSemPeyyNEJbj3TtEHVJGTIPjpRaqgzl
         sKeD2fgdDGnNrmHSJKSkLRCIMlDEhghAS2bQGjKDUbGPvxXJ6gwel9TkV5M6AfNgZnlO
         3wybDvRN5Ndz+i6DbA6vkD7eT9QAid+ZuRjHZcGjr8AoeFMRQFSJH+ABSwYUMmyCJVB1
         GXaT5RTLCVNwIjMXNoCxk5d5ORNto5crYcj47Xlx5cRswbbcAQmWtxBo1S2vj324ZOM7
         Nnc3sHZssbfFsIzzcPSncDhA8LMRKj/YFYfdkpoFNpDla9zBCiS+d89uVzOmHV26HRtf
         OZXg==
X-Forwarded-Encrypted: i=1; AKwUvBwd5JKL3NIQnQipxAMGwvj0TlJN9S0o6nOaCLjSVP9PJYn/lKMHL09rOFi22aXuiDSvbgIiNB2sfpVWSA==@vger.kernel.org
X-Gm-Message-State: AFuF++mewMUIaFZ80bEgE6FNrkrIYB6dTKOvZ4SE+lJRi3oIkJXGgdEf
	I5HH/Fvi2NUw9UbZckCK92Fv+23warTdMB830JjI/x3KW9HYkcxEnfJlJNweLKsE+j4nn9/xPzr
	3awXDg8iZdtlVztVAnAnC2VEo1mwUBgsqkGD+uxill0tazmXhdlZtFKwvIsA=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:138c:b0:4f5:eaac:5151 with SMTP id
 5614622812f47-4fc462688c2mr1264168b6e.39.1791337953537; Tue, 06 Oct 2026
 18:52:33 -0700 (PDT)
Date: Tue, 06 Oct 2026 18:52:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac5a5e1.9ad129c8.3ce5b3.0010.GAE@google.com>
Subject: [syzbot] [btrfs?] KASAN: slab-use-after-free Read in add_root_to_dirty_list
From: syzbot <syzbot+947286c775f432b073a8@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mason@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5e0f8396d480 Merge tag 'hid-for-linus-2026100201' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11e86bf5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b924f079099ba6e
dashboard link: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5e0f8396.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc2553b94d4a/vmlinux-5e0f8396.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a71fb7875957/bzImage-5e0f8396.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 0
==================================================================
BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
Read of size 8 at addr ffff888040e0a528 by task syz.0.0/5324

CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
 __list_add_valid include/linux/list.h:104 [inline]
 __list_add include/linux/list.h:169 [inline]
 list_add include/linux/list.h:192 [inline]
 list_move include/linux/list.h:345 [inline]
 add_root_to_dirty_list+0x38b/0x470 fs/btrfs/ctree.c:232
 btrfs_force_cow_block+0xf09/0x1bf0 fs/btrfs/ctree.c:553
 btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
 btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
 btrfs_search_prev_slot fs/btrfs/free-space-tree.c:134 [inline]
 remove_free_space_extent fs/btrfs/free-space-tree.c:732 [inline]
 __btrfs_remove_from_free_space_tree fs/btrfs/free-space-tree.c:837 [inline]
 btrfs_remove_from_free_space_tree+0x4d6/0xda0 fs/btrfs/free-space-tree.c:866
 alloc_reserved_extent+0x4a/0x2b0 fs/btrfs/extent-tree.c:4976
 alloc_reserved_tree_block fs/btrfs/extent-tree.c:5155 [inline]
 run_delayed_tree_ref fs/btrfs/extent-tree.c:1815 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
 __btrfs_run_delayed_refs+0x18b5/0x43b0 fs/btrfs/extent-tree.c:2134
 btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
 btrfs_commit_transaction+0x28a/0x3170 fs/btrfs/transaction.c:2267
 sync_filesystem+0x1d2/0x240 fs/sync.c:66
 btrfs_reconfigure+0x2dc/0x2100 fs/btrfs/super.c:1511
 reconfigure_super+0x232/0x8f0 fs/super.c:1128
 do_remount fs/namespace.c:3410 [inline]
 path_mount+0xd4e/0x1050 fs/namespace.c:4160
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9c8dd9f3ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9c8eb89e18 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f9c8eb89ea0 RCX: 00007f9c8dd9f3ca
RDX: 0000200000000f40 RSI: 0000200000000f00 RDI: 0000000000000000
RBP: 0000200000000f40 R08: 00007f9c8eb89ea0 R09: 0000000001a4a438
R10: 0000000001a4a438 R11: 0000000000000246 R12: 0000200000000f00
R13: 00007f9c8eb89e60 R14: 0000000000000000 R15: 00002000000008c0
 </TASK>

Allocated by task 5323:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 btrfs_alloc_root+0x75/0x840 fs/btrfs/disk-io.c:638
 btrfs_create_tree+0xa8/0x5c0 fs/btrfs/disk-io.c:832
 btrfs_quota_enable+0x3d6/0x1e20 fs/btrfs/qgroup.c:1074
 btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5323:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6801
 btrfs_quota_enable+0x1208/0x1e20 fs/btrfs/qgroup.c:1292
 btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888040e0a000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1320 bytes inside of
 freed 4096-byte region [ffff888040e0a000, ffff888040e0b000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x40e08
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801b042140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 04fff00000000040 ffff88801b042140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 04fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4702, tgid 4702 (udevd), ts 61099742225
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 tomoyo_realpath_from_path+0xef/0x640 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path2_perm+0x2e7/0x760 security/tomoyo/file.c:928
 tomoyo_path_rename+0x14e/0x1b0 security/tomoyo/tomoyo.c:300
 security_path_rename+0x248/0x460 security/security.c:1544
 filename_renameat2+0x4ba/0x9a0 fs/namei.c:6321
 __do_sys_rename fs/namei.c:6370 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6366
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 4704 tgid 4704 ts 61084842824 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5823
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x307/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 tomoyo_realpath_from_path+0xef/0x640 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path2_perm+0x2e7/0x760 security/tomoyo/file.c:928
 tomoyo_path_rename+0x14e/0x1b0 security/tomoyo/tomoyo.c:300
 security_path_rename+0x248/0x460 security/security.c:1544
 filename_renameat2+0x4ba/0x9a0 fs/namei.c:6321
 __do_sys_rename fs/namei.c:6370 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6366
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888040e0a400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888040e0a480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888040e0a500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888040e0a580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888040e0a600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
