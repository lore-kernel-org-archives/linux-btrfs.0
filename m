From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix missing clear_extent_bit
Date: Wed, 28 Sep 2011 18:00:34 +0800
Message-ID: <1317204034-11239-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We forget to clear inode's dirty_bytes and EXTENT_DIRTY at the end of write.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/file.c  |    1 -
 fs/btrfs/inode.c |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..3f3b4a8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1150,7 +1150,6 @@ fail:
 		faili--;
 	}
 	return err;
-
 }
 
 static noinline ssize_t __btrfs_buffered_write(struct file *file,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..d42bea4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -882,7 +882,7 @@ static noinline int cow_file_range(struct inode *inode,
 		 */
 		op = unlock ? EXTENT_CLEAR_UNLOCK_PAGE : 0;
 		op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
-			EXTENT_SET_PRIVATE2;
+		      EXTENT_SET_PRIVATE2;
 
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 					     start, start + ram_size - 1,
@@ -1778,6 +1778,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 				   ordered_extent->len);
 		BUG_ON(ret);
 	}
+	clear_extent_bit(io_tree, ordered_extent->file_offset,
+			 ordered_extent->file_offset + ordered_extent->len - 1,
+			 EXTENT_DIRTY, 0, 0, &cached_state, GFP_NOFS);
 	unlock_extent_cached(io_tree, ordered_extent->file_offset,
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
-- 
1.6.5.2

