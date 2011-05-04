From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] Btrfs: fix extent state leak on failed nodatasum reads
Date: Wed,  4 May 2011 16:18:50 +0200
Message-ID: <1304518730-13909-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When encountering an EIO while reading from a nodatasum extent, we
insert an error record into the inode's failure tree.
btrfs_readpage_end_io_hook returns early for nodatasum inodes. We'd
better clear the failure tree in that case, otherwise the kernel
complains about

	BUG extent_state: Objects remaining on kmem_cache_close()

on rmmod.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 870869a..9444551 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1970,7 +1970,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	}
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
-		return 0;
+		goto good;
 
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
 	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
-- 
1.7.3.4

