From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 3/5] Remove unused option in btrfs_prepare_device
Date: Tue,  1 May 2012 14:40:31 +0200
Message-ID: <1335876033-12201-3-git-send-email-kario@wit.edu.pl>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

zero_end is set explicitly to 1 inside the fuction so the device end
always will be zeroed out

Signed-off-by: Hubert Kario <kario@wit.edu.pl>

diff --git a/btrfs-vol.c b/btrfs-vol.c
index 0efdbc1..c7b9f80 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -150,7 +150,7 @@ int main(int ac, char **av)
 	if (cmd == BTRFS_IOC_ADD_DEV) {
 		int mixed = 0;
 
-		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count, &mixed);
+		ret = btrfs_prepare_device(devfd, device, &dev_block_count, &mixed);
 		if (ret) {
 			fprintf(stderr, "Unable to init %s\n", device);
 			exit(1);
diff --git a/cmds-device.c b/cmds-device.c
index 05a549c..a28752f 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -107,7 +107,7 @@ static int cmd_add_dev(int argc, char **argv)
 			continue;
 		}
 
-		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count, &mixed);
+		res = btrfs_prepare_device(devfd, argv[i], &dev_block_count, &mixed);
 		if (res) {
 			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
 			close(devfd);
@@ -263,7 +263,6 @@ static int cmd_zero_dev(int argc, char **argv)
 	int n;
 	u64 device_len;
 	int mixed_mode_needed = 1; /* keep btrfs_prepare_device() quiet */
-	const int ZERO_END = 1;
 
 	if( argc < 2 ) {
 		usage(cmd_zero_dev_usage);
@@ -279,8 +278,8 @@ static int cmd_zero_dev(int argc, char **argv)
 			continue;
 		}
 
-		n = btrfs_prepare_device(fd, file, ZERO_END, &device_len,
-			&mixed_mode_needed);
+		n = btrfs_prepare_device(fd, file, &device_len,
+					 &mixed_mode_needed);
 		if (n) {
 			fprintf(stderr, "Error when zeroing out %s\n", file);
 			ret |= n;
diff --git a/mkfs.c b/mkfs.c
index c531ef2..7d1165f 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1209,7 +1209,6 @@ int main(int ac, char **av)
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
-	int zero_end = 1;
 	int option_index = 0;
 	int fd;
 	int ret;
@@ -1264,7 +1263,6 @@ int main(int ac, char **av)
 					       "metadata/data groups\n");
 					mixed = 1;
 				}
-				zero_end = 0;
 				break;
 			case 'V':
 				print_version();
@@ -1311,7 +1309,7 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		first_file = file;
-		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
+		ret = btrfs_prepare_device(fd, file, &dev_block_count, &mixed);
 		if (block_count == 0)
 			block_count = dev_block_count;
 	} else {
@@ -1376,7 +1374,6 @@ int main(int ac, char **av)
 
 	btrfs_register_one_device(file);
 
-	zero_end = 1;
 	while(ac-- > 0) {
 		int old_mixed = mixed;
 
@@ -1404,8 +1401,7 @@ int main(int ac, char **av)
 			close(fd);
 			continue;
 		}
-		ret = btrfs_prepare_device(fd, file, zero_end,
-					   &dev_block_count, &mixed);
+		ret = btrfs_prepare_device(fd, file, &dev_block_count, &mixed);
 		mixed = old_mixed;
 		BUG_ON(ret);
 
diff --git a/utils.c b/utils.c
index 6773be0..e2c72ad 100644
--- a/utils.c
+++ b/utils.c
@@ -536,8 +536,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			 int *mixed)
+int btrfs_prepare_device(int fd, char *file, u64 *block_count_ret, int *mixed)
 {
 	u64 block_count;
 	u64 bytenr;
@@ -555,7 +554,6 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		fprintf(stderr, "unable to find %s size\n", file);
 		exit(1);
 	}
-	zero_end = 1;
 
 	if (mixed && block_count < 1024 * 1024 * 1024 && !(*mixed)) {
 		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
@@ -581,12 +579,10 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
 	}
 
-	if (zero_end) {
-		ret = zero_dev_end(fd, block_count);
-		if (ret) {
-			fprintf(stderr, "failed to zero device end %d\n", ret);
-			exit(1);
-		}
+	ret = zero_dev_end(fd, block_count);
+	if (ret) {
+		fprintf(stderr, "failed to zero device end %d\n", ret);
+		exit(1);
 	}
 
 	if (block_count_ret)
diff --git a/utils.h b/utils.h
index c5f55e1..b7ba663 100644
--- a/utils.h
+++ b/utils.h
@@ -26,8 +26,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
-int btrfs_prepare_device(int fd, char *file, int zero_end,
-			 u64 *block_count_ret, int *mixed);
+int btrfs_prepare_device(int fd, char *file, u64 *block_count_ret,
+			 int *mixed);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-- 
1.7.10

