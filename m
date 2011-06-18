From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix type mismatch in find_free_extent()
Date: Sat, 18 Jun 2011 23:26:38 +0300
Message-ID: <1308428798-29471-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

data parameter should be u64 because a full-sized chunk flags field is
passed instead of 0/1 for distinguishing data from metadata.  All
underlying functions expect u64.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b42efc2..5646348 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4846,7 +4846,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     u64 num_bytes, u64 empty_size,
 				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     int data)
+				     u64 data)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -4873,7 +4873,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
-		printk(KERN_ERR "No space info for %d\n", data);
+		printk(KERN_ERR "No space info for %llu\n", data);
 		return -ENOSPC;
 	}
 
-- 
1.7.2.5

