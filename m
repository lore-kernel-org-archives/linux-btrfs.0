From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/8] Btrfs: make profile_is_valid() check more strict
Date: Tue, 27 Mar 2012 18:04:22 +0300
Message-ID: <1332860668-27298-3-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

"0" is a valid value for an on-disk chunk profile, but it is not a valid
extended profile.  (We have a separate bit for single chunks in extended
case)

Also rename it to alloc_profile_is_valid() for clarity.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h       |   21 +++++++++++++--------
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/volumes.c     |    6 +++---
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aba7832..f057e92 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2735,22 +2735,27 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info);
 }
 /**
- * profile_is_valid - tests whether a given profile is valid and reduced
+ * alloc_profile_is_valid - see if a given profile is valid and reduced
  * @flags: profile to validate
  * @extended: if true @flags is treated as an extended profile
  */
-static inline int profile_is_valid(u64 flags, int extended)
+static inline int alloc_profile_is_valid(u64 flags, int extended)
 {
-	u64 mask = ~BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	u64 mask = (extended ? BTRFS_EXTENDED_PROFILE_MASK :
+			       BTRFS_BLOCK_GROUP_PROFILE_MASK);
 
 	flags &= ~BTRFS_BLOCK_GROUP_TYPE_MASK;
-	if (extended)
-		mask &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 
-	if (flags & mask)
+	/* 1) check that all other bits are zeroed */
+	if (flags & ~mask)
 		return 0;
-	/* true if zero or exactly one bit set */
-	return (flags & (~flags + 1)) == flags;
+
+	/* 2) see if profile is reduced */
+	if (flags == 0)
+		return !extended; /* "0" is valid for usual profiles */
+
+	/* true if exactly one bit set */
+	return (flags & (flags - 1)) == 0;
 }
 
 /* root-item.c */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9f16fdb..8c5bd8f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3400,7 +3400,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	int wait_for_alloc = 0;
 	int ret = 0;
 
-	BUG_ON(!profile_is_valid(flags, 0));
+	BUG_ON(!alloc_profile_is_valid(flags, 0));
 
 	space_info = __find_space_info(extent_root->fs_info, flags);
 	if (!space_info) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4b263a2..e4ef0f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2669,7 +2669,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID10);
 
-	if (!profile_is_valid(bctl->data.target, 1) ||
+	if (!alloc_profile_is_valid(bctl->data.target, 1) ||
 	    bctl->data.target & ~allowed) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "data profile %llu\n",
@@ -2677,7 +2677,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!profile_is_valid(bctl->meta.target, 1) ||
+	if (!alloc_profile_is_valid(bctl->meta.target, 1) ||
 	    bctl->meta.target & ~allowed) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "metadata profile %llu\n",
@@ -2685,7 +2685,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!profile_is_valid(bctl->sys.target, 1) ||
+	if (!alloc_profile_is_valid(bctl->sys.target, 1) ||
 	    bctl->sys.target & ~allowed) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "system profile %llu\n",
-- 
1.7.9.1

