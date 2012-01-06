From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 12/21] Btrfs: do not reduce profile in do_chunk_alloc()
Date: Fri,  6 Jan 2012 16:31:00 +0200
Message-ID: <1325860269-15013-13-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Every caller of do_chunk_alloc() feeds it the reduced allocation
profile, so stop trying to reduce it one more time.  Instead check the
validity of the passed profile.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   18 ++++++++++++++++++
 fs/btrfs/extent-tree.c |    2 +-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c4d98c8..1e7aea6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2536,6 +2536,24 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->super_for_commit);
 	kfree(fs_info);
 }
+/**
+ * profile_is_valid - tests whether a given profile is valid and reduced
+ * @flags: profile to validate
+ * @extended: if true @flags is treated as an extended profile
+ */
+static inline int profile_is_valid(u64 flags, int extended)
+{
+	u64 mask = ~BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	flags &= ~BTRFS_BLOCK_GROUP_TYPE_MASK;
+	if (extended)
+		mask &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+
+	if (flags & mask)
+		return 0;
+	/* true if zero or exactly one bit set */
+	return (flags & (~flags + 1)) == flags;
+}
 
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 946b067..a1a18ea 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3295,7 +3295,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	int wait_for_alloc = 0;
 	int ret = 0;
 
-	flags = btrfs_reduce_alloc_profile(extent_root, flags);
+	BUG_ON(!profile_is_valid(flags, 0));
 
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
-- 
1.7.6.3

