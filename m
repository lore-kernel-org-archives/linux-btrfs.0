From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix call to btrfs_search_slot in free space cache
Date: Fri, 19 Aug 2011 16:28:48 -0400
Message-ID: <1313785728-17544-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We are setting ins_len to 1 even tho we are just modifying an item that should
be there already.  This may cause the search stuff to split nodes on the way
down needelessly.  Set this to 0 since we aren't inserting anything.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c4dab..7912380 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -798,7 +798,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	key.offset = offset;
 	key.type = 0;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0) {
 		ret = -1;
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, bytes - 1,
-- 
1.7.5.2

