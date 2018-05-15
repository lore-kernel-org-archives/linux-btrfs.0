Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60326 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753100AbeEORiF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:38:05 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
Date: Wed, 16 May 2018 01:37:36 +0800
Message-Id: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a btree block, aka. extent buffer, is not available in the extent
buffer cache, it'll be read out from the disk instead, i.e.

btrfs_search_slot()
  read_block_for_search()  # hold parent and its lock, go to read child
    btrfs_release_path()
    read_tree_block()  # read child

Unfortunately, the parent lock got released before reading child, so
commit 5bdd3536cbbe ("Btrfs: Fix block generation verification race") had
used 0 as parent transid to read the child block.  It forces
read_tree_block() not to check if parent transid is different with the
generation id of the child that it reads out from disk.

A simple PoC is included in btrfs/124,

0. A two-disk raid1 btrfs,

1. Right after mkfs.btrfs, block A is allocated to be device tree's root.

2. Mount this filesystem and put it in use, after a while, device tree's
   root got COW but block A hasn't been allocated/overwritten yet.

3. Umount it and reload the btrfs module to remove both disks from the
   global @fs_devices list.

4. mount -odegraded dev1 and write some data, so now block A is allocated
   to be a leaf in checksum tree.  Note that only dev1 has the latest
   metadata of this filesystem.

5. Umount it and mount it again normally (with both disks), since raid1
   can pick up one disk by the writer task's pid, if btrfs_search_slot()
   needs to read block A, dev2 which does NOT have the latest metadata
   might be read for block A, then we got a stale block A.

6. As parent transid is not checked, block A is marked as uptodate and
   put into the extent buffer cache, so the future search won't bother
   to read disk again, which means it'll make changes on this stale
   one and make it dirty and flush it onto disk.

To avoid the problem, parent transid needs to be passed to
read_tree_block().

In order to get a valid parent transid, we need to hold the parent's
lock until finish reading child.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3fd44835b386..b3f6f300e492 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2436,10 +2436,8 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 	if (p->reada != READA_NONE)
 		reada_for_search(fs_info, p, level, slot, key->objectid);
 
-	btrfs_release_path(p);
-
 	ret = -EAGAIN;
-	tmp = read_tree_block(fs_info, blocknr, 0, parent_level - 1,
+	tmp = read_tree_block(fs_info, blocknr, gen, parent_level - 1,
 			      &first_key);
 	if (!IS_ERR(tmp)) {
 		/*
@@ -2454,6 +2452,8 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 	} else {
 		ret = PTR_ERR(tmp);
 	}
+
+	btrfs_release_path(p);
 	return ret;
 }
 
-- 
1.8.3.1

