From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 4/5] better error handling in btrfs_prepare_device()
Date: Tue,  1 May 2012 14:41:26 +0200
Message-ID: <1335876087-12248-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_prepare_device did abort the whole application on any error,
even when there were other tasks queued that could succeed, now it
returns non zero value on error.

Add more descriptive error messages: print failing device name and
cause of error.

Signed-off-by: Hubert Kario <kario@wit.edu.pl>

diff --git a/mkfs.c b/mkfs.c
index 7d1165f..9a58f67 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1310,6 +1310,10 @@ int main(int ac, char **av)
 		}
 		first_file = file;
 		ret = btrfs_prepare_device(fd, file, &dev_block_count, &mixed);
+		if (ret) {
+			fprintf(stderr, "Unable to init device %s\n", file);
+			exit(1);
+		}
 		if (block_count == 0)
 			block_count = dev_block_count;
 	} else {
diff --git a/utils.c b/utils.c
index e2c72ad..139ba8a 100644
--- a/utils.c
+++ b/utils.c
@@ -546,13 +546,13 @@ int btrfs_prepare_device(int fd, char *file, u64 *block_count_ret, int *mixed)
 	ret = fstat(fd, &st);
 	if (ret < 0) {
 		fprintf(stderr, "unable to stat %s\n", file);
-		exit(1);
+		return 1;
 	}
 
 	block_count = device_size(fd, &st);
 	if (block_count == 0) {
 		fprintf(stderr, "unable to find %s size\n", file);
-		exit(1);
+		return 1;
 	}
 
 	if (mixed && block_count < 1024 * 1024 * 1024 && !(*mixed)) {
@@ -568,21 +568,30 @@ int btrfs_prepare_device(int fd, char *file, u64 *block_count_ret, int *mixed)
 
 	ret = zero_dev_start(fd);
 	if (ret) {
-		fprintf(stderr, "failed to zero device start %d\n", ret);
-		exit(1);
+		fprintf(stderr, "failed to zero device %s start: %s\n", file,
+			strerror(-ret));
+		return 1;
 	}
 
 	for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		if (bytenr >= block_count)
+		/* don't zero the superblock if it's on device end boundary,
+		 * it will be zeroed by zero_dev_end() anyway */
+		if (bytenr + BTRFS_SUPER_INFO_SIZE >= block_count)
 			break;
-		zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
+		ret = zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
+		if (ret) {
+			fprintf(stderr, "failed to zero superblock no. %i "
+				"(at %lli) on device %s: %s\n", i, bytenr,
+				file, strerror(-ret));
+			return 1;
+		}
 	}
 
 	ret = zero_dev_end(fd, block_count);
 	if (ret) {
-		fprintf(stderr, "failed to zero device end %d\n", ret);
-		exit(1);
+		fprintf(stderr, "failed to zero device %s end: %s\n", file, strerror(-ret));
+		return 1;
 	}
 
 	if (block_count_ret)
-- 
1.7.10

