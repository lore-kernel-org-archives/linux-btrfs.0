From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 13/21] Btrfs: implement online profile changing
Date: Fri,  6 Jan 2012 16:31:01 +0200
Message-ID: <1325860269-15013-14-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Profile changing is done by launching a balance with
BTRFS_BALANCE_CONVERT bits set and target fields of respective
btrfs_balance_args structs initialized.  Profile reducing code in this
case will pick restriper's target profile if it's available instead of
doing a blind reduce.  If target profile is not yet available it goes
back to a plain reduce.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   56 ++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |    5 +++
 3 files changed, 129 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1a18ea..e6a832e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3030,7 +3030,9 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 /*
  * @flags: available profiles in extended format (see ctree.h)
  *
- * Returns reduced profile in chunk format.
+ * Returns reduced profile in chunk format.  If profile changing is in
+ * progress (either running or paused) picks the target profile (if it's
+ * already available), otherwise falls back to plain reducing.
  */
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
@@ -3042,6 +3044,34 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	u64 num_devices = root->fs_info->fs_devices->rw_devices +
 		root->fs_info->fs_devices->missing_devices;
 
+	/* pick restriper's target profile if it's available */
+	spin_lock(&root->fs_info->balance_lock);
+	if (root->fs_info->balance_ctl) {
+		struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
+		u64 tgt = 0;
+
+		if ((flags & BTRFS_BLOCK_GROUP_DATA) &&
+		    (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		    (flags & bctl->data.target)) {
+			tgt = BTRFS_BLOCK_GROUP_DATA | bctl->data.target;
+		} else if ((flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
+			   (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+			   (flags & bctl->sys.target)) {
+			tgt = BTRFS_BLOCK_GROUP_SYSTEM | bctl->sys.target;
+		} else if ((flags & BTRFS_BLOCK_GROUP_METADATA) &&
+			   (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+			   (flags & bctl->meta.target)) {
+			tgt = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
+		}
+
+		if (tgt) {
+			spin_unlock(&root->fs_info->balance_lock);
+			flags = tgt;
+			goto out;
+		}
+	}
+	spin_unlock(&root->fs_info->balance_lock);
+
 	if (num_devices == 1)
 		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0);
 	if (num_devices < 4)
@@ -3065,6 +3095,7 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
 	}
 
+out:
 	/* extended -> chunk profile */
 	flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	return flags;
@@ -6795,6 +6826,29 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 	u64 stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
+	if (root->fs_info->balance_ctl) {
+		struct btrfs_balance_control *bctl = root->fs_info->balance_ctl;
+		u64 tgt = 0;
+
+		/* pick restriper's target profile and return */
+		if (flags & BTRFS_BLOCK_GROUP_DATA &&
+		    bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+			tgt = BTRFS_BLOCK_GROUP_DATA | bctl->data.target;
+		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM &&
+			   bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+			tgt = BTRFS_BLOCK_GROUP_SYSTEM | bctl->sys.target;
+		} else if (flags & BTRFS_BLOCK_GROUP_METADATA &&
+			   bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+			tgt = BTRFS_BLOCK_GROUP_METADATA | bctl->meta.target;
+		}
+
+		if (tgt) {
+			/* extended -> chunk profile */
+			tgt &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+			return tgt;
+		}
+	}
+
 	/*
 	 * we add in the count of missing devices because we want
 	 * to make sure that any RAID levels on a degraded FS
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 719e61d..ad94f26 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2430,6 +2430,75 @@ int btrfs_balance(struct btrfs_balance_control *bctl, int resume)
 		}
 	}
 
+	/*
+	 * Profile changing sanity checks.  Skip them if a simple
+	 * balance is requested.
+	 */
+	if (!((bctl->data.flags | bctl->sys.flags | bctl->meta.flags) &
+	      BTRFS_BALANCE_ARGS_CONVERT))
+		goto do_balance;
+
+	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	if (fs_info->fs_devices->num_devices == 1)
+		allowed |= BTRFS_BLOCK_GROUP_DUP;
+	else if (fs_info->fs_devices->num_devices < 4)
+		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
+	else
+		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_RAID10);
+
+	if (!profile_is_valid(bctl->data.target, 1) ||
+	    bctl->data.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start balance with target "
+		       "data profile %llu\n",
+		       (unsigned long long)bctl->data.target);
+		ret = -EINVAL;
+		goto out;
+	}
+	if (!profile_is_valid(bctl->meta.target, 1) ||
+	    bctl->meta.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start balance with target "
+		       "metadata profile %llu\n",
+		       (unsigned long long)bctl->meta.target);
+		ret = -EINVAL;
+		goto out;
+	}
+	if (!profile_is_valid(bctl->sys.target, 1) ||
+	    bctl->sys.target & ~allowed) {
+		printk(KERN_ERR "btrfs: unable to start balance with target "
+		       "system profile %llu\n",
+		       (unsigned long long)bctl->sys.target);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (bctl->data.target & BTRFS_BLOCK_GROUP_DUP) {
+		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* allow to reduce meta or sys integrity only if force set */
+	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
+			BTRFS_BLOCK_GROUP_RAID10;
+	if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	     (fs_info->avail_system_alloc_bits & allowed) &&
+	     !(bctl->sys.target & allowed)) ||
+	    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+	     (fs_info->avail_metadata_alloc_bits & allowed) &&
+	     !(bctl->meta.target & allowed))) {
+		if (bctl->flags & BTRFS_BALANCE_FORCE) {
+			printk(KERN_INFO "btrfs: force reducing metadata "
+			       "integrity\n");
+		} else {
+			printk(KERN_ERR "btrfs: balance will reduce metadata "
+			       "integrity, use force if you want this\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+do_balance:
 	if (!resume)
 		set_balance_control(bctl);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 879afcb..13ff08d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -196,6 +196,9 @@ struct map_lookup {
 #define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
 					 BTRFS_BALANCE_SYSTEM |	    \
 					 BTRFS_BALANCE_METADATA)
+
+#define BTRFS_BALANCE_FORCE		(1ULL << 3)
+
 /*
  * Balance filters
  */
@@ -205,6 +208,8 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 
+#define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
+
 struct btrfs_balance_args;
 struct btrfs_balance_control {
 	struct btrfs_fs_info *fs_info;
-- 
1.7.6.3

