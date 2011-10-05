From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't skip writing out a empty block groups cache
Date: Wed,  5 Oct 2011 10:01:04 -0400
Message-ID: <1317823264-4402-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a slight bug where we will not bother writing out the block group
cache's space cache if it's space tree is empty.  Since it could have a cluster
or pinned extents that need to be written out this is just not a valid test.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0a8ccdb..b81556c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -575,10 +575,6 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	INIT_LIST_HEAD(&bitmap_list);
 
-	node = rb_first(&ctl->free_space_offset);
-	if (!node)
-		return -1;
-
 	if (!i_size_read(inode))
 		return -1;
 
@@ -639,6 +635,12 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (block_group)
 		start = block_group->key.objectid;
 
+	node = rb_first(&ctl->free_space_offset);
+	if (!node && cluster) {
+		node = rb_first(&cluster->root);
+		cluster = NULL;
+	}
+
 	/* Write out the extent entries */
 	do {
 		struct btrfs_free_space_entry *entry;
-- 
1.7.5.2

