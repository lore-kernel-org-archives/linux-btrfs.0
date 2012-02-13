From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs: prepare incompat flags for more compression methods
Date: Mon, 13 Feb 2012 20:05:34 +0100
Message-ID: <1329159937-23976-1-git-send-email-dsterba@suse.cz>
References: <20120213190325.GJ15350@twin.jikos.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213190325.GJ15350@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h   |    9 +++++----
 fs/btrfs/disk-io.c |    4 +++-
 fs/btrfs/ioctl.c   |    6 +++++-
 fs/btrfs/super.c   |    8 ++++++++
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9cf62f8..76fea8c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -461,7 +461,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
 #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
-#define BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY	(1ULL << 4)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD	(1ULL << 4)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -470,7 +470,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
-	 BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY)
+	 BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -627,8 +627,9 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
 	BTRFS_COMPRESS_SNAPPY = 3,
-	BTRFS_COMPRESS_TYPES = 3,
-	BTRFS_COMPRESS_LAST  = 4,
+	BTRFS_COMPRESS_LZ4   = 4,
+	BTRFS_COMPRESS_TYPES = 4,
+	BTRFS_COMPRESS_LAST  = 5,
 };
 
 struct btrfs_inode_item {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d8deea9..e179980 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2138,7 +2138,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_SNAPPY)
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY;
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD;
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZ4)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD;
 	btrfs_set_super_incompat_flags(disk_super, features);
 
 	features = btrfs_super_compat_ro_flags(disk_super) &
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 834e95c..d568a11 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1182,7 +1182,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		btrfs_set_super_incompat_flags(disk_super, features);
 	}
 	if (range->compress_type == BTRFS_COMPRESS_SNAPPY) {
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY;
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+	if (range->compress_type == BTRFS_COMPRESS_LZ4) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_SQUAD;
 		btrfs_set_super_incompat_flags(disk_super, features);
 	}
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c91f0e1..b65c94b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -287,6 +287,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			} else if (strcmp(args[0].from, "snappy") == 0) {
 				compress_type = "snappy";
 				info->compress_type = BTRFS_COMPRESS_SNAPPY;
+			} else if (strcmp(args[0].from, "lz4") == 0) {
+				compress_type = "lz4";
+				info->compress_type = BTRFS_COMPRESS_LZ4;
+				/* remove when implemented */
+				ret = -EINVAL;
+				goto out;
 			} else {
 				ret = -EINVAL;
 				goto out;
@@ -734,6 +740,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 			compress_type = "zlib";
 		else if (info->compress_type == BTRFS_COMPRESS_SNAPPY)
 			compress_type = "snappy";
+		else if (info->compress_type == BTRFS_COMPRESS_LZ4)
+			compress_type = "lz4";
 		else if (info->compress_type == BTRFS_COMPRESS_LZO)
 			compress_type = "lzo";
 		else
-- 
1.7.8

