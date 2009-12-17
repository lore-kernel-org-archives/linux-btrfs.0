From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set a compat flag when setting default subvol
Date: Thu, 17 Dec 2009 16:40:24 -0500
Message-ID: <20091217214024.GC4122@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is just to mark the fs that it's been tinkered with to set the default
subvolume.  It's a compatible change because older kernels will just ignore the
default setting and mount the same thing they always have.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    5 ++++-
 fs/btrfs/ioctl.c |    8 ++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 917211b..fa8a3e7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -371,7 +371,10 @@ struct btrfs_super_block {
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 
-#define BTRFS_FEATURE_COMPAT_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_DEFAULT_SUBVOL	(1ULL << 0)
+
+#define BTRFS_FEATURE_COMPAT_SUPP		\
+	BTRFS_FEATURE_COMPAT_DEFAULT_SUBVOL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
 #define BTRFS_FEATURE_INCOMPAT_SUPP		\
 	BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 81d8378..6a78711 100644
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
+	features = btrfs_super_compat_flags(disk_super);
+	if (!(features & BTRFS_FEATURE_COMPAT_DEFAULT_SUBVOL)) {
+		features |= BTRFS_FEATURE_COMPAT_DEFAULT_SUBVOL;
+		btrfs_set_super_compat_flags(disk_super, features);
+	}
 	btrfs_end_transaction(trans, root);
 
 	return 0;
-- 
1.5.4.3

