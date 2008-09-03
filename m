From: "Ryan Hope" <rmh3093@gmail.com>
Subject: kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
Date: Wed, 3 Sep 2008 10:52:28 -0400
Message-ID: <48f7fe350809030752s329a0d09y27530d22237c57ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can reproduce this bug every time. I have a reiser4 (created with
ccreg40 plugin) partition on a ubs thumbdrive. The partition has a
linux distro installed on it. I tried copying the contents of the
partition on the thumb drive (~2gig) to a btrfs loop back image
residing on an ext3 partition. The copy process will segfault every
time it gets near the end of the copy process, after its copied about
2gig (its will copying the /usr or /var dir) it will segfault (I also
have 2 gig of ram). I tried this with btrfs stable and unstable. I was
able to reproduce this at least 6 times before I gave up. FYI the
kernel below is 2.6.27-rc5 patched with btrfs.

-Ryan

------------[ cut here ]------------
kernel BUG at fs/btrfs-stable/extent-tree.c:2111!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: btrfs radeon drm sr_mod cdrom iwl3945 mac80211

Pid: 7909, comm: cp Not tainted (2.6.27-rc5-zen2 #2)
EIP: 0060:[<f94b22b6>] EFLAGS: 00010296 CPU: 0
EIP is at __btrfs_reserve_extent+0x2f6/0x3f0 [btrfs]
EAX: 0000001e EBX: 00000000 ECX: 00000082 EDX: 00000046
ESI: 00000024 EDI: 00001000 EBP: 00000000 ESP: b2a75504
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cp (pid: 7909, ti=b2a75000 task=f7d73700 task.ti=b2a75000)
Stack: f94e19a8 00000024 00000000 00000000 00000000 00000000 ffffffff ffffffff
       00000000 00000000 b2a75617 00000000 00000000 00000000 00000000 00000024
       00000000 00000000 00000000 00000000 00001000 00000000 f5dbbe00 b106b960
Call Trace:
 [<f94b27c3>] btrfs_alloc_extent+0x93/0x110 [btrfs]
 [<f94b2910>] btrfs_alloc_free_block+0xd0/0x110 [btrfs]
 [<f94a8879>] __btrfs_cow_block+0x569/0x780 [btrfs]
 [<f94d9cd1>] map_private_extent_buffer+0x91/0x150 [btrfs]
 [<f94a8b99>] btrfs_cow_block+0x109/0x1f0 [btrfs]
 [<f94a90e2>] push_leaf_right+0x132/0x610 [btrfs]
 [<f94ca358>] btrfs_item_offset+0xd8/0xe0 [btrfs]
 [<f94d9cd1>] map_private_extent_buffer+0x91/0x150 [btrfs]
 [<f94aab54>] split_leaf+0x84/0x9d0 [btrfs]
 [<f94ca358>] btrfs_item_offset+0xd8/0xe0 [btrfs]
 [<f94a7b61>] leaf_space_used+0x91/0xc0 [btrfs]
 [<f94a82b5>] btrfs_leaf_free_space+0x45/0xa0 [btrfs]
 [<f94a9e86>] bin_search+0xa6/0xb0 [btrfs]
 [<f94acf8b>] btrfs_search_slot+0xe7b/0x16e0 [btrfs]
 [<f94e0808>] btrfs_tree_unlock+0x8/0x10 [btrfs]
 [<f94a79ee>] unlock_up+0x9e/0x110 [btrfs]
 [<f94acfb2>] btrfs_search_slot+0xea2/0x16e0 [btrfs]
 [<f94d9cd1>] map_private_extent_buffer+0x91/0x150 [btrfs]
 [<f94d47e5>] set_extent_bit+0x145/0x440 [btrfs]
 [<f94ca358>] btrfs_item_offset+0xd8/0xe0 [btrfs]
 [<f94d3999>] merge_state+0x69/0x100 [btrfs]
 [<f94adda1>] btrfs_insert_empty_items+0x61/0x430 [btrfs]
 [<f94ae5c7>] hash_extent_ref+0x57/0xb0 [btrfs]
 [<f94afeb0>] btrfs_insert_extent_backref+0xd0/0x1c0 [btrfs]
 [<f94b019a>] finish_current_insert+0xca/0x280 [btrfs]
 [<f94b2643>] __btrfs_alloc_reserved_extent+0x1f3/0x2e0 [btrfs]
 [<f94b2813>] btrfs_alloc_extent+0xe3/0x110 [btrfs]
 [<f94b2910>] btrfs_alloc_free_block+0xd0/0x110 [btrfs]
 [<f94aac94>] split_leaf+0x1c4/0x9d0 [btrfs]
 [<f94a7b61>] leaf_space_used+0x91/0xc0 [btrfs]
 [<f94acf8b>] btrfs_search_slot+0xe7b/0x16e0 [btrfs]
 [<f94e0808>] btrfs_tree_unlock+0x8/0x10 [btrfs]
 [<f94acfb2>] btrfs_search_slot+0xea2/0x16e0 [btrfs]
 [<f94e0808>] btrfs_tree_unlock+0x8/0x10 [btrfs]
 [<f94a6a7d>] btrfs_release_path+0xd/0x60 [btrfs]
 [<f94adda1>] btrfs_insert_empty_items+0x61/0x430 [btrfs]
 [<f94d935b>] read_extent_buffer+0xcb/0x160 [btrfs]
 [<f94c5ec4>] insert_inline_extent+0xf4/0x4e0 [btrfs]
 [<f94c7838>] dirty_and_release_pages+0x3e8/0x740 [btrfs]
 [<f94c3c30>] btrfs_get_extent+0x0/0xb20 [btrfs]
 [<8026805e>] page_address+0xde/0x100
 [<f94c80f2>] btrfs_file_write+0x552/0xa50 [btrfs]
 [<80402f9c>] security_file_permission+0xc/0x10
 [<802811fa>] rw_verify_area+0x4a/0xc0
 [<f94c7ba0>] btrfs_file_write+0x0/0xa50 [btrfs]
 [<802816d0>] vfs_write+0xa0/0x140
 [<80281841>] sys_write+0x41/0x80
 [<802034ed>] sysenter_do_call+0x12/0x25
 [<80630000>] i8042_probe+0x1da/0x602
 =======================
Code: 5f 5d c3 66 90 83 e6 e7 e9 eb fd ff ff 3b 6c 24 4c 73 32 8b 54
24 54 89 74 24 04 c7 04 24 a8 19 4e f9 89 54 24 08 e8 f2 6a 18 87 <0f>
0b eb fe 8d b6 00 00 00 00 39 c7 0f 83 e0 fe ff ff e9 c5 fe
EIP: [<f94b22b6>] __btrfs_reserve_extent+0x2f6/0x3f0 [btrfs] SS:ESP
0068:b2a75504
---[ end trace 34db5e11b5be2e82 ]---
