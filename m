Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:59022 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2KPAFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 19:05:07 -0500
Received: from chewy.home.zabbo.net (chewy.home.zabbo.net [192.168.242.31])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 6266E7200219
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 16:05:06 -0800 (PST)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: limit fallocate extent reservation to 256MB
Date: Thu, 15 Nov 2012 16:04:43 -0800
Message-Id: <1353024283-2014-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Very large fallocate requests are cpu bound and result in extents with a
repeating pattern of ever decreasing size:

$ time fallocate -l 1T file
real	0m13.039s

( an excerpt of the extents from btrfs-debug-tree: )
  prealloc data disk byte 1536292564992 nr 397312
  prealloc data disk byte 1536292962304 nr 196608
  prealloc data disk byte 1536293158912 nr 98304
  prealloc data disk byte 1536293257216 nr 49152
  prealloc data disk byte 1536293306368 nr 24576
  prealloc data disk byte 1536293330944 nr 12288
  prealloc data disk byte 1536293343232 nr 8192
  prealloc data disk byte 1536293351424 nr 4096
  prealloc data disk byte 1536293355520 nr 4096
  prealloc data disk byte 1536293359616 nr 4096

The excessive cpu use comes from __btrfs_prealloc_file_range() trying to
allocate the entire remaining size after each extent is allocated.
btrfs_reserve_extent() repeatedly cuts this requested size in half until
it gets down to the size that the allocators can return.  We limit the
problem for now by capping each reservation at 256 meg.

The small extents come from a masking bug when decreasing the requested
reservation size.  The high 32bits are cleared and the remaining low
bits might happen to reserve a small size.   Fix this by using
round_down() which properly casts the mask.

After these fixes huge fallocate requests are fast and result in nice
large extents:

$ time fallocate -l 1T file
real	0m0.082s

  prealloc data disk byte 1112425889792 nr 268435456
  prealloc data disk byte 1112694325248 nr 268435456
  prealloc data disk byte 1112962760704 nr 268435456

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/inode.c       | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6d2329d..3ae6bc3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5951,7 +5951,7 @@ again:
 	if (ret == -ENOSPC) {
 		if (!final_tried) {
 			num_bytes = num_bytes >> 1;
-			num_bytes = num_bytes & ~(root->sectorsize - 1);
+			num_bytes = round_down(num_bytes, root->sectorsize);
 			num_bytes = max(num_bytes, min_alloc_size);
 			if (num_bytes == min_alloc_size)
 				final_tried = true;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d80e70..7ad949e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8331,8 +8331,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			}
 		}
 
-		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, &ins, 1);
+		ret = btrfs_reserve_extent(trans, root,
+					   min(num_bytes, 256ULL * 1024 * 1024),
+					   min_size, 0, *alloc_hint, &ins, 1);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
-- 
1.7.11.7

