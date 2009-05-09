From: Sankar P <sankar.curiosity@gmail.com>
Subject: [PATCH] Spelling fix in btrfs code comment
Date: Sat, 09 May 2009 16:49:03 +0530
Message-ID: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	trivial@kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix a trivial spelling error in a comment

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

---
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e496644..3e2c7c7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
 }
 
 /*
- * return the block group that contains teh given bytenr
+ * return the block group that contains the given bytenr
  */
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,


