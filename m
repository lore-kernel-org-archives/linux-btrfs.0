Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34380 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdFDVL6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jun 2017 17:11:58 -0400
Received: by mail-pg0-f67.google.com with SMTP id v14so3933560pgn.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jun 2017 14:11:58 -0700 (PDT)
Date: Sun, 4 Jun 2017 14:11:54 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>, Liu Bo <bo.li.liu@oracle.com>
Subject: [BUG] direct I/O pwrite() returning EEXIST on btrfs
Message-ID: <20170604211154.GA16696@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

For at least a few kernel versions now I've been receiving I/O errors in a KVM
guest when testing ext4 with kvm-xfstests on a particular computer.  I've
tracked this down to the host filesystem which is BTRFS, and is sometimes
returning EEXIST to pwrite() calls made by QEMU to write to the disk image using
direct I/O.  The disk image file is in "raw" format, does not have the 'C'
attribute, and the filesystem has snapshots.  This bug still occurs on latest
Linus tree (v4.12-rc3-239-g3c06e6cbdb6a).

The bug has something to do with BTRFS inserting extent_maps into the inode's
extent_map_tree.  The EEXIST error code is coming from merge_extent_mapping(),
as called by btrfs_get_extent(), as called by btrfs_get_blocks_direct().  It's
probably similar to, but not the same as, the bug fixed by 8e2bd3b7fac9 ("Btrfs:
deal with existing encompassing extent map in btrfs_get_extent()").

I haven't found a better way to reproduce it yet and I'm having trouble fully
understanding the relevant BTRFS code, but perhaps this report will ring a bell
for someone else a little sooner.

I also tried adding the following debugging code:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..846ace6ab34b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6768,7 +6768,9 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
 				struct extent_map *existing,
 				struct extent_map *em,
-				u64 map_start)
+				u64 map_start,
+				struct extent_map *prev_ret,
+				struct extent_map *next_ret)
 {
 	struct extent_map *prev;
 	struct extent_map *next;
@@ -6786,6 +6788,16 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
 		next = next_extent_map(prev);
 	}
 
+	if (prev)
+		*prev_ret = *prev;
+	else
+		*prev_ret = (struct extent_map){ 0 };
+
+	if (next)
+		*next_ret = *next;
+	else
+		*next_ret = (struct extent_map){ 0 };
+
 	start = prev ? extent_map_end(prev) : em->start;
 	start = max_t(u64, start, em->start);
 	end = next ? next->start : extent_map_end(em);
@@ -6857,7 +6869,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  */
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		struct page *page,
-	    size_t pg_offset, u64 start, u64 len,
+	    size_t pg_offset, const u64 start, const u64 len,
 		int create)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
@@ -7111,14 +7123,34 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 		} else if (start >= extent_map_end(existing) ||
 		    start <= existing->start) {
+			const u64 em_start = em->start;
+			const u64 em_end = extent_map_end(em);
+			const u64 existing_start = existing->start;
+			const u64 existing_end = extent_map_end(existing);
+			struct extent_map prev, next;
+
 			/*
 			 * The existing extent map is the one nearest to
 			 * the [start, start + len) range which overlaps
 			 */
 			err = merge_extent_mapping(em_tree, existing,
-						   em, start);
+						   em, start, &prev, &next);
 			free_extent_map(existing);
 			if (err) {
+				if (err == -EEXIST) {
+					pr_warn("merge_extent_mapping() returned -EEXIST!\n"
+						"given a request to find the extent map for [%llu, %llu)\n"
+						"found and tried to insert [%llu, %llu), but it overlapped\n"
+						"existing extent [%llu, %llu), then was adjusted to\n"
+						"[%llu, %llu) but still overlapped\n"
+						"prev=[%llu, %llu) or next=[%llu, %llu)\n",
+						start, start + len,
+						em_start, em_end,
+						existing_start, existing_end,
+						em->start, extent_map_end(em),
+						prev.start, extent_map_end(&prev),
+						next.start, extent_map_end(&next));
+				}
 				free_extent_map(em);
 				em = NULL;
 			}

---

This resulted in the output:

[  333.374373] merge_extent_mapping() returned -EEXIST!
               given a request to find the extent map for [2303893504, 2304409600)
               found and tried to insert [2303893504, 2306473984), but it overlapped
               existing extent [2303893504, 2304925696), then was adjusted to
               [2304925696, 2304925696) but still overlapped
               prev=[2303893504, 2304925696) or next=[2304925696, 2305441792)
[  333.376469] merge_extent_mapping() returned -EEXIST!
               given a request to find the extent map for [2296668160, 2297184256)
               found and tried to insert [2296668160, 2297700352), but it overlapped
               existing extent [2296668160, 2297184256), then was adjusted to
               [2297184256, 2297184256) but still overlapped
               prev=[2296668160, 2297184256) or next=[2297184256, 2297700352)

So merge_extent_mapping() tried and failed to insert a zero-length extent_map
into the tree, which is obviously wrong at some level...

Eric
