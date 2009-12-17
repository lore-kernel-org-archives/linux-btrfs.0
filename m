From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set a incompat flag when setting default subvol
Date: Thu, 17 Dec 2009 17:17:47 -0500
Message-ID: <20091217221746.GA2192@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Older kernels would generally be able to still mount the filesystem with the
default subvolume set, but it would result in a different volume being mounted,
which could be an even more unpleasant suprise for users.  So if you set your
default subvolume, you can't go back to older kernels.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    4 +++-
 fs/btrfs/ioctl.c |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 917211b..8c57180 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -370,11 +370,13 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
 #define BTRFS_FEATURE_INCOMPAT_SUPP		\
-	BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF
+	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |	\
+	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 81d8378..9070b86 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1563,6 +1563,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	struct btrfs_path *path;
 	struct btrfs_key location;
 	struct btrfs_disk_key disk_key;
+	struct btrfs_super_block *disk_super;
+	u64 features;
 	u64 objectid = 0;
 	u64 dir_id;
 
@@ -1610,6 +1612,12 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
+	disk_super = &root->fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (!(features & BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)) {
+		features |= BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
 	btrfs_end_transaction(trans, root);
 
 	return 0;
-- 
1.5.4.3

