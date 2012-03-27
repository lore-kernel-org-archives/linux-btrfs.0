From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4/8] Btrfs: add get_restripe_target() helper
Date: Tue, 27 Mar 2012 18:04:24 +0300
Message-ID: <1332860668-27298-5-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add get_restripe_target() helper and switch everybody to use it.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   94 +++++++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 304710c..faf52e0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3110,6 +3110,35 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 }
 
 /*
+ * returns target flags in extended format or 0 if restripe for this
+ * chunk_type is not in progress
+ */
+static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
+{
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+	u64 target = 0;
+
+	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
+	       !spin_is_locked(&fs_info->balance_lock));
+
+	if (!bctl)
+		return 0;
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA &&
+	    bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		target = BTRFS_BLOCK_GROUP_DATA | bctl->data.target;
+	} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM &&
+		   bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		target = BTRFS_BLOCK_GROUP_SYSTEM | bctl->sys.target;
+	} else if (flags & BTRFS_BLOCK_GROUP_METADATA &&
+		   bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		target = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
+	}
+
+	return target;
+}
+
+/*
  * @flags: available profiles in extended format (see ctree.h)
  *
  * Returns reduced profile in chunk format.  If profile changing is in
@@ -3125,31 +3154,19 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	 */
 	u64 num_devices = root->fs_info->fs_devices->rw_devices +
 		root->fs_info->fs_devices->missing_devices;
+	u64 target;
 
-	/* pick restriper's target profile if it's available */
+	/*
+	 * see if restripe for this chunk_type is in progress, if so
+	 * try to reduce to the target profile
+	 */
 	spin_lock(&root->fs_info->balance_lock);
-	if (root->fs_info->balance_ctl) {
-		struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
-		u64 tgt = 0;
-
-		if ((flags & BTRFS_BLOCK_GROUP_DATA) &&
-		    (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-		    (flags & bctl->data.target)) {
-			tgt = BTRFS_BLOCK_GROUP_DATA | bctl->data.target;
-		} else if ((flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
-			   (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-			   (flags & bctl->sys.target)) {
-			tgt = BTRFS_BLOCK_GROUP_SYSTEM | bctl->sys.target;
-		} else if ((flags & BTRFS_BLOCK_GROUP_METADATA) &&
-			   (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-			   (flags & bctl->meta.target)) {
-			tgt = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
-		}
-
-		if (tgt) {
+	target = get_restripe_target(root->fs_info, flags);
+	if (target) {
+		/* pick target profile only if it's already available */
+		if ((flags & target) & BTRFS_EXTENDED_PROFILE_MASK) {
 			spin_unlock(&root->fs_info->balance_lock);
-			flags = tgt;
-			goto out;
+			return extended_to_chunk(target);
 		}
 	}
 	spin_unlock(&root->fs_info->balance_lock);
@@ -3177,7 +3194,6 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
 	}
 
-out:
 	return extended_to_chunk(flags);
 }
 
@@ -6888,28 +6904,15 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices;
-	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
-		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
-
-	if (root->fs_info->balance_ctl) {
-		struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
-		u64 tgt = 0;
-
-		/* pick restriper's target profile and return */
-		if (flags & BTRFS_BLOCK_GROUP_DATA &&
-		    bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-			tgt = BTRFS_BLOCK_GROUP_DATA | bctl->data.target;
-		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM &&
-			   bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-			tgt = BTRFS_BLOCK_GROUP_SYSTEM | bctl->sys.target;
-		} else if (flags & BTRFS_BLOCK_GROUP_METADATA &&
-			   bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-			tgt = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
-		}
+	u64 stripped;
 
-		if (tgt)
-			return extended_to_chunk(tgt);
-	}
+	/*
+	 * if restripe for this chunk_type is on pick target profile and
+	 * return, otherwise do the usual balance
+	 */
+	stripped = get_restripe_target(root->fs_info, flags);
+	if (stripped)
+		return extended_to_chunk(stripped);
 
 	/*
 	 * we add in the count of missing devices because we want
@@ -6919,6 +6922,9 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	num_devices = root->fs_info->fs_devices->rw_devices +
 		root->fs_info->fs_devices->missing_devices;
 
+	stripped = BTRFS_BLOCK_GROUP_RAID0 |
+		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
+
 	if (num_devices == 1) {
 		stripped |= BTRFS_BLOCK_GROUP_DUP;
 		stripped = flags & ~stripped;
-- 
1.7.9.1

