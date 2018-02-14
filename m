Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51447 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754191AbeBNGnc (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 14 Feb 2018 01:43:32 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Fix read beyond boundary bug in build_roots_info_cache()
Date: Wed, 14 Feb 2018 14:43:25 +0800
Message-Id: <20180214064325.21561-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This bug is exposed by fsck-test with D=asan, hit by test case 020, with
the following error report:

=================================================================
==10740==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x621000061580 at pc 0x56051f0db6cd bp 0x7ffe170f3e20 sp 0x7ffe170f3e10
READ of size 1 at 0x621000061580 thread T0
    #0 0x56051f0db6cc in btrfs_extent_inline_ref_type /home/adam/btrfs/btrfs-progs/ctree.h:1727
    #1 0x56051f13b669 in build_roots_info_cache /home/adam/btrfs/btrfs-progs/cmds-check.c:14306
    #2 0x56051f13c86a in repair_root_items /home/adam/btrfs/btrfs-progs/cmds-check.c:14450
    #3 0x56051f13ea89 in cmd_check /home/adam/btrfs/btrfs-progs/cmds-check.c:14965
    #4 0x56051efe75bb in main /home/adam/btrfs/btrfs-progs/btrfs.c:302
    #5 0x7f04ddbb0f49 in __libc_start_main (/usr/lib/libc.so.6+0x20f49)
    #6 0x56051efe68c9 in _start (/home/adam/btrfs/btrfs-progs/btrfs+0x5b8c9)

0x621000061580 is located 0 bytes to the right of 4224-byte region [0x621000060500,0x621000061580)
allocated by thread T0 here:
    #0 0x7f04ded50ce1 in __interceptor_calloc /build/gcc/src/gcc/libsanitizer/asan/asan_malloc_linux.cc:70
    #1 0x56051f04685e in __alloc_extent_buffer /home/adam/btrfs/btrfs-progs/extent_io.c:553
    #2 0x56051f047563 in alloc_extent_buffer /home/adam/btrfs/btrfs-progs/extent_io.c:687
    #3 0x56051efff1d1 in btrfs_find_create_tree_block /home/adam/btrfs/btrfs-progs/disk-io.c:187
    #4 0x56051f000133 in read_tree_block /home/adam/btrfs/btrfs-progs/disk-io.c:327
    #5 0x56051efeddb8 in read_node_slot /home/adam/btrfs/btrfs-progs/ctree.c:652
    #6 0x56051effb0d9 in btrfs_next_leaf /home/adam/btrfs/btrfs-progs/ctree.c:2853
    #7 0x56051f13b343 in build_roots_info_cache /home/adam/btrfs/btrfs-progs/cmds-check.c:14267
    #8 0x56051f13c86a in repair_root_items /home/adam/btrfs/btrfs-progs/cmds-check.c:14450
    #9 0x56051f13ea89 in cmd_check /home/adam/btrfs/btrfs-progs/cmds-check.c:14965
    #10 0x56051efe75bb in main /home/adam/btrfs/btrfs-progs/btrfs.c:302
    #11 0x7f04ddbb0f49 in __libc_start_main (/usr/lib/libc.so.6+0x20f49)

It's completely possible that one extent/metadata item has no inline
reference, while build_roots_info_cache() doesn't have such check.

Fix it by checking @iref against item end to avoid such problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---

I'm pretty sure this fix will cause conflict with original mode code
split.
Maybe it's better to merge original code split first?

---
 cmds-check.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 99fbafc5538c..b15802887e70 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -14255,6 +14255,7 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
 		struct btrfs_key found_key;
 		struct btrfs_extent_item *ei;
 		struct btrfs_extent_inline_ref *iref;
+		unsigned long item_end;
 		int slot = path.slots[0];
 		int type;
 		u64 flags;
@@ -14283,6 +14284,7 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
 
 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 		flags = btrfs_extent_flags(leaf, ei);
+		item_end = (unsigned long)ei + btrfs_item_size_nr(leaf, slot);
 
 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
 		    !(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
@@ -14299,6 +14301,15 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
 			level = btrfs_tree_block_level(leaf, binfo);
 		}
 
+		/*
+		 * It's valid one extent/metadata item has no inline ref, but
+		 * SHARED_BLOCK_REF or other shared refernce.
+		 * So we need to do extra check to avoid read beyond leaf
+		 * boudnary.
+		 */
+		if ((unsigned long)iref >= item_end)
+			goto next;
+
 		/*
 		 * For a root extent, it must be of the following type and the
 		 * first (and only one) iref in the item.
-- 
2.16.1

