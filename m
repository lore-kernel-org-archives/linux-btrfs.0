From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: allow not to trim a device
Date: Sat, 17 Mar 2012 19:51:37 +0100
Message-ID: <1332010297-18581-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 man/mkfs.btrfs.8.in |    4 ++++
 mkfs.c              |   15 +++++++++++----
 utils.c             |   18 +++++++++++++-----
 utils.h             |    2 ++
 4 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 2610e9d..5dec704 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -13,6 +13,7 @@ mkfs.btrfs \- create an btrfs filesystem
 [ \fB \-M\fP\fI mixed data+metadata\fP ]
 [ \fB \-n\fP\fI nodesize\fP ]
 [ \fB \-s\fP\fI sectorsize\fP ]
+[ \fB \-T\fP ]
 [ \fB \-h\fP ]
 [ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
 .SH DESCRIPTION
@@ -62,6 +63,9 @@ Specify the nodesize. By default the value is set to the pagesize.
 \fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
 Specify the sectorsize, the minimum block allocation.
 .TP
+\fB\-T\fR, \fB\-\-nodiscard \fR
+Do not perform whole device TRIM operation by default.
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
 .SH AVAILABILITY
diff --git a/mkfs.c b/mkfs.c
index 9b9e1e7..d36191f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -338,6 +338,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
+	fprintf(stderr, "\t -T --nodiscard do not perform whole device TRIM\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -398,6 +399,7 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "force", 0, NULL, 'f' },
+	{ "nodiscard", 0, NULL, 'T' },
 	{ 0, 0, 0, 0}
 };
 
@@ -1214,6 +1216,7 @@ int main(int ac, char **av)
 	int mixed = 0;
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
+	int nodiscard = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1225,7 +1228,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMf", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMfT", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1274,6 +1277,9 @@ int main(int ac, char **av)
 			case 'f':
 				force=1;
 				break;
+			case 'T':
+				nodiscard=1;
+				break;
 			default:
 				print_usage();
 		}
@@ -1315,7 +1321,8 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		first_file = file;
-		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
+		ret = __btrfs_prepare_device(fd, file, zero_end,
+				&dev_block_count, &mixed, nodiscard);
 		if (block_count == 0)
 			block_count = dev_block_count;
 	} else {
@@ -1412,8 +1419,8 @@ int main(int ac, char **av)
 			close(fd);
 			continue;
 		}
-		ret = btrfs_prepare_device(fd, file, zero_end,
-					   &dev_block_count, &mixed);
+		ret = __btrfs_prepare_device(fd, file, zero_end,
+					   &dev_block_count, &mixed, nodiscard);
 		mixed = old_mixed;
 		BUG_ON(ret);
 
diff --git a/utils.c b/utils.c
index a2be9c9..cfb8fde 100644
--- a/utils.c
+++ b/utils.c
@@ -539,6 +539,12 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 			 int *mixed)
 {
+	/* discard by default when called from 'device add' */
+	return __btrfs_prepare_device(fd, file, zero_end, block_count_ret, mixed, 0);
+}
+int __btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
+			 int *mixed, int nodiscard)
+{
 	u64 block_count;
 	u64 bytenr;
 	struct stat st;
@@ -562,11 +568,13 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		*mixed = 1;
 	}
 
-	/*
-	 * We intentionally ignore errors from the discard ioctl.  It is
-	 * not necessary for the mkfs functionality but just an optimization.
-	 */
-	discard_blocks(fd, 0, block_count);
+	if (!nodiscard) {
+		/*
+		 * We intentionally ignore errors from the discard ioctl.  It is
+		 * not necessary for the mkfs functionality but just an optimization.
+		 */
+		discard_blocks(fd, 0, block_count);
+	}
 
 	ret = zero_dev_start(fd);
 	if (ret) {
diff --git a/utils.h b/utils.h
index bf2d5a4..502d849 100644
--- a/utils.h
+++ b/utils.h
@@ -28,6 +28,8 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end,
 			 u64 *block_count_ret, int *mixed);
+int __btrfs_prepare_device(int fd, char *file, int zero_end,
+			 u64 *block_count_ret, int *mixed, int nodiscard);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-- 
1.7.6.233.gd79bc

