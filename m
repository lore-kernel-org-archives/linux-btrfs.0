Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab3BUJre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 04:47:34 -0500
Message-ID: <5125ED66.4060405@cn.fujitsu.com>
Date: Thu, 21 Feb 2013 17:48:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: fix wrong outstanding_extents when doing DIO write
References: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
In-Reply-To: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running the 083th case of xfstests on the filesystem with
"compress-force=lzo", the following WARNINGs were triggered.
  WARNING: at fs/btrfs/inode.c:7908
  WARNING: at fs/btrfs/inode.c:7909
  WARNING: at fs/btrfs/inode.c:7911
  WARNING: at fs/btrfs/extent-tree.c:4510
  WARNING: at fs/btrfs/extent-tree.c:4511

This problem was introduced by the patch "Btrfs: fix deadlock due
to unsubmitted". In this patch, there are two bugs which caused
the above problem.

The 1st one is a off-by-one bug, if the DIO write return 0, it is
also a short write, we need release the reserved space for it. But
we didn't do it in that patch. Fix it by change "ret > 0" to
"ret >= 0".

The 2nd one is ->outstanding_extents was increased twice when
a short write happened. As we know, ->outstanding_extents is
a counter to keep track of the number of extent items we may
use duo to delalloc, when we reserve the free space for a
delalloc write, we assume that the write will introduce just
one extent item, so we increase ->outstanding_extents by 1 at
that time. And then we will increase it every time we split the
write, it is done at the beginning of btrfs_get_blocks_direct().
So when a short write happens, we needn't increase
->outstanding_extents again. But this patch done.

In order to fix the 2nd problem, I re-write the logic for
->outstanding_extents operation. We don't increase it at the
beginning of btrfs_get_blocks_direct(), instead, we just
increase it when the split actually happens.

Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b009fb5..9a1cc04 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6067,12 +6067,9 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	int unlock_bits = EXTENT_LOCKED;
 	int ret = 0;
 
-	if (create) {
-		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->outstanding_extents++;
-		spin_unlock(&BTRFS_I(inode)->lock);
+	if (create)
 		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
-	} else
+	else
 		len = min_t(u64, len, root->sectorsize);
 
 	lockstart = start;
@@ -6214,6 +6211,10 @@ unlock:
 		if (start + len > i_size_read(inode))
 			i_size_write(inode, start + len);
 
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->lock);
+
 		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
 				     &cached_state, GFP_NOFS);
@@ -6716,14 +6717,11 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	if (rw & WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
 			btrfs_delalloc_release_space(inode, count);
-		else if (ret > 0 && (size_t)ret < count) {
-			spin_lock(&BTRFS_I(inode)->lock);
-			BTRFS_I(inode)->outstanding_extents++;
-			spin_unlock(&BTRFS_I(inode)->lock);
+		else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode,
 						     count - (size_t)ret);
-		}
-		btrfs_delalloc_release_metadata(inode, 0);
+		else
+			btrfs_delalloc_release_metadata(inode, 0);
 	}
 out:
 	if (wakeup)
-- 
1.7.11.7

