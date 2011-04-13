From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure to use the delalloc reserve when filling delalloc
Date: Wed, 13 Apr 2011 12:44:48 -0400
Message-ID: <1302713088-27373-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In the prealloc filling code and compressed code we don't set trans->block_rsv
to the delalloc block reserve properly, which is going to make us use metadata
from the wrong pool, this patch fixes that.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c4b914e..a23e9ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -619,6 +619,7 @@ retry:
 
 		trans = btrfs_join_transaction(root, 1);
 		BUG_ON(IS_ERR(trans));
+		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 		ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
@@ -1059,6 +1060,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root, 1);
 	}
 	BUG_ON(IS_ERR(trans));
+	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	cow_start = (u64)-1;
 	cur_offset = start;
-- 
1.7.2.3

