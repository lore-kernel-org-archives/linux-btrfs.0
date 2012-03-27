From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 3/8] Btrfs: move alloc_profile_is_valid() to volumes.c
Date: Tue, 27 Mar 2012 18:04:23 +0300
Message-ID: <1332860668-27298-4-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Header file is not a good place to define functions.  This also moves a
call to alloc_profile_is_valid() down the stack and removes a redundant
check from __btrfs_alloc_chunk() - alloc_profile_is_valid() takes it
into account.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   23 -----------------------
 fs/btrfs/extent-tree.c |    2 --
 fs/btrfs/volumes.c     |   30 +++++++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f057e92..a56e1e0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2734,29 +2734,6 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->super_for_commit);
 	kfree(fs_info);
 }
-/**
- * alloc_profile_is_valid - see if a given profile is valid and reduced
- * @flags: profile to validate
- * @extended: if true @flags is treated as an extended profile
- */
-static inline int alloc_profile_is_valid(u64 flags, int extended)
-{
-	u64 mask = (extended ? BTRFS_EXTENDED_PROFILE_MASK :
-			       BTRFS_BLOCK_GROUP_PROFILE_MASK);
-
-	flags &= ~BTRFS_BLOCK_GROUP_TYPE_MASK;
-
-	/* 1) check that all other bits are zeroed */
-	if (flags & ~mask)
-		return 0;
-
-	/* 2) see if profile is reduced */
-	if (flags == 0)
-		return !extended; /* "0" is valid for usual profiles */
-
-	/* true if exactly one bit set */
-	return (flags & (flags - 1)) == 0;
-}
 
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8c5bd8f..304710c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3400,8 +3400,6 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	int wait_for_alloc = 0;
 	int ret = 0;
 
-	BUG_ON(!alloc_profile_is_valid(flags, 0));
-
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
 		ret = update_space_info(extent_root->fs_info, flags,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e4ef0f2..def9e25 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2598,6 +2598,30 @@ error:
 	return ret;
 }
 
+/**
+ * alloc_profile_is_valid - see if a given profile is valid and reduced
+ * @flags: profile to validate
+ * @extended: if true @flags is treated as an extended profile
+ */
+static int alloc_profile_is_valid(u64 flags, int extended)
+{
+	u64 mask = (extended ? BTRFS_EXTENDED_PROFILE_MASK :
+			       BTRFS_BLOCK_GROUP_PROFILE_MASK);
+
+	flags &= ~BTRFS_BLOCK_GROUP_TYPE_MASK;
+
+	/* 1) check that all other bits are zeroed */
+	if (flags & ~mask)
+		return 0;
+
+	/* 2) see if profile is reduced */
+	if (flags == 0)
+		return !extended; /* "0" is valid for usual profiles */
+
+	/* true if exactly one bit set */
+	return (flags & (flags - 1)) == 0;
+}
+
 static inline int balance_need_close(struct btrfs_fs_info *fs_info)
 {
 	/* cancel requested || normal exit path */
@@ -3124,11 +3148,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int i;
 	int j;
 
-	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
-	    (type & BTRFS_BLOCK_GROUP_DUP)) {
-		WARN_ON(1);
-		type &= ~BTRFS_BLOCK_GROUP_DUP;
-	}
+	BUG_ON(!alloc_profile_is_valid(type, 0));
 
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
-- 
1.7.9.1

