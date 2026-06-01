Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA557263B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 21:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780347686; cv=none; b=M7OwhjprDVbZyf8ZyM2WICLfQ7OWZ0N3cq7EKS4oVRfmYQftn/QGOuwrlTo4NfYB6I1ll7kdtMiuvbYhOOtGQSnQCEPKKs3N6VCq7cPj7d5zpRNe2jIIkm0YdXxxebJRGubNekZUJHoD58N8xGIf5W7qfWJPYYh/9KAEFiepv0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780347686; c=relaxed/simple;
	bh=1Ba9iskw4LaADGy0y4Xob6ukWKJkBdiQ1SvSwLtMZAY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YQ+Hc0//4+x3B3Lf/nWW56BUxYOLCs/eO02gmblM/bs7r89axv8deyrlXxYG04yp/UVlXDS/8ac4DLz5YZ++RpBqvZxOsvK0u36vDs7PUn3t2zCc+zl3N5bycCh428fI6iU4Iu+kIF4qh2EekX9tRU4FvRK6vJSAXH4+GvxWLa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7e6b550a521so2153425a34.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 14:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780347684; x=1780952484;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TMb2Y2z5Wcd9t4VWEuNrRZgQFtPj6LkE1GN5qTuU+64=;
        b=VQzi9car4tVq8YlE25dWRt5k8obz1SETfk5ttF8xrGZfFcE4e9Uwv3imcoe9bd8+ih
         oMyg7spM4QxJI9lmAEm6g5II75rhSZuaYh+drWFnO10ZrF0EiDQMLPbV1DVLQXVykhJf
         oWt6P4fTqT4E26k5lKxWwQr7CFGKFIEzCAiN3M+JzZwzNfKgDhYzRWEdrThSAC+TyC/r
         DO6XI/rXijqXyuP+K2eGmoOq7NeF0Y6uGqDx7h74SO6nAXlLNi9qRqAjuka/rxC6KCFN
         /7q97eEZ9j6ww5WzYtj5QUW9jqNZfEb+8tN+FHbPe7O+SxDDylaJU4/5np+8w3uC6aau
         phtw==
X-Forwarded-Encrypted: i=1; AFNElJ8WPsaNrhK6VZJMB134jYUNoDfYfnCCLa6KZDDUlT/NPK4XK12f/kPu/0HDjv00SHM3c3ubOHJDYfE+jQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjhk1HQIzGXvZQptlHicgcwhUQREZAId09llZwYA6kwcRU5PGH
	lFomD3ak5ECxFpFu7XkaN32xa/0ISvkl5Hg4hSDsnpPMWI1n498O1CcFGszxMLNh2rXfLZCstMX
	nJIQlQqn5TQs6jUrlq/rqa91S9GIb4jovKrvMMeRriHzZuJJApwc3gbvrhUE=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1527:b0:69d:a1d0:26d7 with SMTP id
 006d021491bc7-69e103d4231mr6614070eaf.47.1780347683892; Mon, 01 Jun 2026
 14:01:23 -0700 (PDT)
Date: Mon, 01 Jun 2026 14:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1df323.bb0696ed.125a22.000a.GAE@google.com>
Subject: [syzbot] [btrfs?] KASAN: slab-use-after-free Read in replace_file_extents
From: syzbot <syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4d3a2a466b8d HID: core: Fix size_t specifier in hid_report..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ce5950580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=0eea49bba18051dea35e
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4d3a2a46.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e6f8ace9c896/vmlinux-4d3a2a46.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d18ecf0e8cf/bzImage-4d3a2a46.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in replace_file_extents+0x85f/0x1590 fs/btrfs/relocation.c:941
Read of size 8 at addr ffff888012312010 by task syz.0.0/5346

CPU: 0 UID: 0 PID: 5346 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 replace_file_extents+0x85f/0x1590 fs/btrfs/relocation.c:941
 btrfs_force_cow_block+0xa4d/0x2450 fs/btrfs/ctree.c:532
 btrfs_cow_block+0x3c4/0xa90 fs/btrfs/ctree.c:699
 push_leaf_left+0x2ac/0x4a0 fs/btrfs/ctree.c:3506
 split_leaf+0xd16/0x12e0 fs/btrfs/ctree.c:3700
 search_leaf fs/btrfs/ctree.c:1958 [inline]
 btrfs_search_slot+0x2641/0x2d20 fs/btrfs/ctree.c:2148
 btrfs_insert_empty_items+0x9c/0x190 fs/btrfs/ctree.c:4301
 btrfs_insert_empty_item fs/btrfs/ctree.h:674 [inline]
 btrfs_insert_inode_ref+0x229/0xcb0 fs/btrfs/inode-item.c:316
 btrfs_rename fs/btrfs/inode.c:8706 [inline]
 btrfs_rename2+0x17bb/0x40d0 fs/btrfs/inode.c:8854
 vfs_rename+0xa96/0xeb0 fs/namei.c:6054
 ovl_do_rename_rd fs/overlayfs/overlayfs.h:370 [inline]
 ovl_check_rename_whiteout fs/overlayfs/super.c:593 [inline]
 ovl_make_workdir fs/overlayfs/super.c:713 [inline]
 ovl_get_workdir fs/overlayfs/super.c:836 [inline]
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x46b7/0x5e20 fs/overlayfs/super.c:1560
 vfs_get_super fs/super.c:1327 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1346
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3758 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3834
 do_mount fs/namespace.c:4167 [inline]
 __do_sys_mount fs/namespace.c:4383 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1ff79ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa2005affe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fa1ffa16180 RCX: 00007fa1ff79ce59
RDX: 0000200000000100 RSI: 0000200000002240 RDI: 0000000000000000
RBP: 00007fa1ff832d6f R08: 0000200000000440 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa1ffa16218 R14: 00007fa1ffa16180 R15: 00007ffc734fba78
 </TASK>

Allocated by task 5325:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x31c/0x660 mm/slub.c:5419
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 alloc_reloc_control fs/btrfs/relocation.c:3808 [inline]
 btrfs_relocate_block_group+0x217/0xc40 fs/btrfs/relocation.c:5364
 btrfs_relocate_chunk+0x115/0x820 fs/btrfs/volumes.c:3598
 __btrfs_balance+0x1db0/0x2ae0 fs/btrfs/volumes.c:4509
 btrfs_balance+0xaf3/0x11b0 fs/btrfs/volumes.c:4896
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5325:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free mm/slub.c:6250 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6565
 free_reloc_control fs/btrfs/relocation.c:3830 [inline]
 btrfs_relocate_block_group+0x95d/0xc40 fs/btrfs/relocation.c:5446
 btrfs_relocate_chunk+0x115/0x820 fs/btrfs/volumes.c:3598
 __btrfs_balance+0x1db0/0x2ae0 fs/btrfs/volumes.c:4509
 btrfs_balance+0xaf3/0x11b0 fs/btrfs/volumes.c:4896
 btrfs_ioctl_balance+0x3d3/0x610 fs/btrfs/ioctl.c:3453
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888012312000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 16 bytes inside of
 freed 2048-byte region [ffff888012312000, ffff888012312800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12310
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac42000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac42000 dead000000000100 dead000000000122
head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9, tgid 9 (kworker/0:0), ts 83905464494, free_ts 83674944822
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3467
 new_slab mm/slub.c:3525 [inline]
 refill_objects+0x339/0x3d0 mm/slub.c:7271
 refill_sheaf mm/slub.c:2816 [inline]
 __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
 alloc_from_pcs mm/slub.c:4749 [inline]
 slab_alloc_node mm/slub.c:4883 [inline]
 __do_kmalloc_node mm/slub.c:5294 [inline]
 __kmalloc_node_track_caller_noprof+0x572/0x7b0 mm/slub.c:5407
 kmalloc_reserve net/core/skbuff.c:635 [inline]
 __alloc_skb+0x2c1/0x7d0 net/core/skbuff.c:713
 alloc_skb include/linux/skbuff.h:1383 [inline]
 mld_newpack+0x14c/0xc90 net/ipv6/mcast.c:1775
 add_grhead+0x5a/0x2a0 net/ipv6/mcast.c:1886
 add_grec+0x1452/0x1740 net/ipv6/mcast.c:2025
 mld_send_cr net/ipv6/mcast.c:2148 [inline]
 mld_ifc_work+0x6e6/0xe70 net/ipv6/mcast.c:2693
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
page last free pid 5282 tgid 5282 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
 __slab_free+0x274/0x2c0 mm/slub.c:5612
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 __kmalloc_cache_noprof+0x2ba/0x660 mm/slub.c:5414
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 kernfs_fop_open+0x3f0/0xda0 fs/kernfs/file.c:641
 do_dentry_open+0x785/0x14e0 fs/open.c:947
 vfs_open+0x3b/0x340 fs/open.c:1079
 do_open fs/namei.c:4699 [inline]
 path_openat+0x2e08/0x3860 fs/namei.c:4858
 do_file_open+0x23e/0x4a0 fs/namei.c:4887
 do_sys_openat2+0x113/0x200 fs/open.c:1364
 do_sys_open fs/open.c:1370 [inline]
 __do_sys_openat fs/open.c:1386 [inline]
 __se_sys_openat fs/open.c:1381 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1381
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888012311f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888012311f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888012312000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888012312080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888012312100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
