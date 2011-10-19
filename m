From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't flush the cache inode before writing it
Date: Wed, 19 Oct 2011 10:33:52 -0400
Message-ID: <1319034832-9428-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed we had a little bit of latency when writing out the space cache
inodes.  It's because we flush it before we write anything in case we have dirty
pages already there.  This doesn't matter though since we're just going to
overwrite the space, and there really shouldn't be any dirty pages anyway.  This
makes some of my tests run a little bit faster.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2fecfc3..de205d5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -829,10 +829,6 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (!i_size_read(inode))
 		return -1;
 
-	filemap_write_and_wait(inode->i_mapping);
-	btrfs_wait_ordered_range(inode, inode->i_size &
-				 ~(root->sectorsize - 1), (u64)-1);
-
 	io_ctl_init(&io_ctl, inode, root);
 
 	/* Get the cluster for this block_group if it exists */
-- 
1.7.5.2

