Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34789 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbDSIRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 04:17:45 -0400
Received: by pacyx8 with SMTP id yx8so174016950pac.1
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 01:17:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>, Shaohua Li <shli@fb.com>
Subject: [PATCH] Revert "btrfs: delete chunk allocation attemp when setting block group ro"
Date: Sun, 19 Apr 2015 01:17:05 -0700
Message-Id: <c99a895bc0facef23387ef7b44c98c0df41216fa.1429431096.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 2f0810880f082fa8ba66ab2c33b02e4ff9770a5e.

This tried to fix the following test case:

	mkfs.ext4 -F /dev/sda
	btrfs-convert /dev/sda
	mount /dev/sda /mnt
	btrfs device add -f /dev/sdb /mnt
	btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt

Before the reverted commit, this test case failed with ENOSPC because
all chunks on the freshly converted filesystem were allocated, although
many were empty. The reverted commit removed an allocation attempt in
btrfs_set_block_group_ro(), but that fix wasn't right. After the
reverted commit, the balance succeeds, but the data/metadata profiles
aren't actually updated:

	# btrfs fi df /mnt
	Data, single: total=208.00MiB, used=49.48MiB
	System, single: total=32.00MiB, used=4.00KiB
	Metadata, single: total=208.00MiB, used=48.00KiB
	GlobalReserve, single: total=4.00MiB, used=0.00B

Indeed, several users reported that this commit caused a regression and
that converting the data and metadata profiles no longer works. This is
because the chunk allocation in question was where we actually allocated
the chunk with the new profile. Not seeing a more obvious fix, let's
just revert this. We can work around the ENOSPC in the original test
case by just issuing a balance to free up the unused block groups before
the conversion, anyways:

	mkfs.ext4 -F /dev/sda
	btrfs-convert /dev/sda
	mount /dev/sda /mnt
	btrfs balance start -v /mnt
	btrfs device add -f /dev/sdb /mnt
	btrfs balance start -v -dconvert=raid1 -mconvert=raid1 /mnt

Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
Holger reported this awhile ago and I haven't seen a proper fix make it
to the ML. I messed around with it for awhile and came up empty, but I
figured I might as well send this in. Applies to v4.0.

 fs/btrfs/extent-tree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b353ad..6421852 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8537,6 +8537,14 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
+	alloc_flags = update_block_group_flags(root, cache->flags);
+	if (alloc_flags != cache->flags) {
+		ret = do_chunk_alloc(trans, root, alloc_flags,
+				     CHUNK_ALLOC_FORCE);
+		if (ret < 0)
+			goto out;
+	}
+
 	ret = set_block_group_ro(cache, 0);
 	if (!ret)
 		goto out;
@@ -8547,11 +8555,6 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 		goto out;
 	ret = set_block_group_ro(cache, 0);
 out:
-	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-		alloc_flags = update_block_group_flags(root, cache->flags);
-		check_system_chunk(trans, root, alloc_flags);
-	}
-
 	btrfs_end_transaction(trans, root);
 	return ret;
 }
-- 
2.3.5

