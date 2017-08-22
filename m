Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49648 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751310AbdHVFfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 01:35:17 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 6E77047227B4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 13:35:12 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Make in-place exit to a common exit block
Date: Tue, 22 Aug 2017 13:35:06 +0800
Message-ID: <1503380106-44682-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As comment pointed out by David, make in-place exit
to a common exit block of mkfs.

v1:
Add some close(fd) when error occures in mkfs.
And add close(fd) when end use it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 mkfs/main.c | 74 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 2b109a5..1244dfa 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1410,7 +1410,7 @@ int main(int argc, char **argv)
 	u32 sectorsize = 4096;
 	u32 stripesize = 4096;
 	int zero_end = 1;
-	int fd;
+	int fd = -1;
 	int ret;
 	int i;
 	int mixed = 0;
@@ -1496,12 +1496,12 @@ int main(int argc, char **argv)
 					error("unrecognized filesystem feature '%s'",
 							tmp);
 					free(orig);
-					exit(1);
+					goto error;
 				}
 				free(orig);
 				if (features & BTRFS_FEATURE_LIST_ALL) {
 					btrfs_list_all_fs_features(0);
-					exit(0);
+					goto success;
 				}
 				break;
 				}
@@ -1515,8 +1515,7 @@ int main(int argc, char **argv)
 			case 'V':
 				printf("mkfs.btrfs, part of %s\n",
 						PACKAGE_STRING);
-				exit(0);
-				break;
+				goto success;
 			case 'r':
 				source_dir = optarg;
 				source_dir_set = 1;
@@ -1551,7 +1550,7 @@ int main(int argc, char **argv)
 
 	if (source_dir_set && dev_cnt > 1) {
 		error("the option -r is limited to a single device");
-		exit(1);
+		goto error;
 	}
 
 	if (*fs_uuid) {
@@ -1559,11 +1558,11 @@ int main(int argc, char **argv)
 
 		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
 			error("could not parse UUID: %s", fs_uuid);
-			exit(1);
+			goto error;
 		}
 		if (!test_uuid_unique(fs_uuid)) {
 			error("non-unique UUID: %s", fs_uuid);
-			exit(1);
+			goto error;
 		}
 	}
 
@@ -1571,7 +1570,7 @@ int main(int argc, char **argv)
 		file = argv[optind++];
 		if (is_block_device(file) == 1)
 			if (test_dev_for_mkfs(file, force_overwrite))
-				exit(1);
+				goto error;
 	}
 
 	optind = saved_optind;
@@ -1606,7 +1605,7 @@ int main(int argc, char **argv)
 			if (metadata_profile != data_profile) {
 				error(
 	"with mixed block groups data and metadata profiles must be the same");
-				exit(1);
+				goto error;
 			}
 		}
 
@@ -1628,12 +1627,12 @@ int main(int argc, char **argv)
 
 	if (btrfs_check_nodesize(nodesize, sectorsize,
 				 features))
-		exit(1);
+		goto error;
 
 	if (sectorsize < sizeof(struct btrfs_super_block)) {
 		error("sectorsize smaller than superblock: %u < %zu",
 				sectorsize, sizeof(struct btrfs_super_block));
-		exit(1);
+		goto error;
 	}
 
 	/* Check device/block_count after the nodesize is determined */
@@ -1642,7 +1641,7 @@ int main(int argc, char **argv)
 			block_count);
 		error("minimum size for btrfs filesystem is %llu",
 			btrfs_min_dev_size(nodesize));
-		exit(1);
+		goto error;
 	}
 	for (i = saved_optind; i < saved_optind + dev_cnt; i++) {
 		char *path;
@@ -1652,20 +1651,20 @@ int main(int argc, char **argv)
 		if (ret < 0) {
 			error("failed to check size for %s: %s",
 				path, strerror(-ret));
-			exit (1);
+			goto error;
 		}
 		if (ret > 0) {
 			error("'%s' is too small to make a usable filesystem",
 				path);
 			error("minimum size for each btrfs device is %llu",
 				btrfs_min_dev_size(nodesize));
-			exit(1);
+			goto error;
 		}
 	}
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
 			dev_cnt, mixed, ssd);
 	if (ret)
-		exit(1);
+		goto error;
 
 	dev_cnt--;
 
@@ -1678,7 +1677,7 @@ int main(int argc, char **argv)
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			error("unable to open %s: %s", file, strerror(errno));
-			exit(1);
+			goto error;
 		}
 		ret = btrfs_prepare_device(fd, file, &dev_block_count,
 				block_count,
@@ -1686,22 +1685,21 @@ int main(int argc, char **argv)
 				(discard ? PREP_DEVICE_DISCARD : 0) |
 				(verbose ? PREP_DEVICE_VERBOSE : 0));
 		if (ret) {
-			close(fd);
-			exit(1);
+			goto error;
 		}
 		if (block_count && block_count > dev_block_count) {
 			error("%s is smaller than requested size, expected %llu, found %llu",
 					file,
 					(unsigned long long)block_count,
 					(unsigned long long)dev_block_count);
-			exit(1);
+			goto error;
 		}
 	} else {
 		fd = open(file, O_CREAT | O_RDWR,
 				S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 		if (fd < 0) {
 			error("unable to open %s: %s", file, strerror(errno));
-			exit(1);
+			goto error;
 		}
 
 		source_dir_size = size_sourcedir(source_dir, sectorsize,
@@ -1711,7 +1709,7 @@ int main(int argc, char **argv)
 		ret = zero_output_file(fd, block_count);
 		if (ret) {
 			error("unable to zero the output file");
-			exit(1);
+			goto error;
 		}
 		/* our "device" is the new image file */
 		dev_block_count = block_count;
@@ -1721,7 +1719,7 @@ int main(int argc, char **argv)
 	if (dev_block_count < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
 		error("device is too small to make filesystem, must be at least %llu",
 				(unsigned long long)BTRFS_MKFS_SYSTEM_GROUP_SIZE);
-		exit(1);
+		goto error;
 	}
 
 	if (group_profile_max_safe_loss(metadata_profile) <
@@ -1740,41 +1738,42 @@ int main(int argc, char **argv)
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
 		error("error during mkfs: %s", strerror(-ret));
-		exit(1);
+		goto error;
 	}
 
 	fs_info = open_ctree_fs_info(file, 0, 0, 0,
 			OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
 	if (!fs_info) {
 		error("open ctree failed");
-		close(fd);
-		exit(1);
+		goto error;
 	}
+	close(fd);
+	fd = -1;
 	root = fs_info->fs_root;
 	fs_info->alloc_start = alloc_start;
 
 	ret = create_metadata_block_groups(root, mixed, &allocation);
 	if (ret) {
 		error("failed to create default block groups: %d", ret);
-		exit(1);
+		goto error;
 	}
 
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans) {
 		error("failed to start transaction");
-		exit(1);
+		goto error;
 	}
 
 	ret = create_data_block_groups(trans, root, mixed, &allocation);
 	if (ret) {
 		error("failed to create default data block groups: %d", ret);
-		exit(1);
+		goto error;
 	}
 
 	ret = make_root_dir(trans, root);
 	if (ret) {
 		error("failed to setup the root directory: %d", ret);
-		exit(1);
+		goto error;
 	}
 
 	ret = btrfs_commit_transaction(trans, root);
@@ -1786,7 +1785,7 @@ int main(int argc, char **argv)
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans) {
 		error("failed to start transaction");
-		exit(1);
+		goto error;
 	}
 
 	if (dev_cnt == 0)
@@ -1803,7 +1802,7 @@ int main(int argc, char **argv)
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			error("unable to open %s: %s", file, strerror(errno));
-			exit(1);
+			goto error;
 		}
 		ret = btrfs_device_already_in_root(root, fd,
 						   BTRFS_SUPER_INFO_OFFSET);
@@ -1819,8 +1818,7 @@ int main(int argc, char **argv)
 				(zero_end ? PREP_DEVICE_ZERO_END : 0) |
 				(discard ? PREP_DEVICE_DISCARD : 0));
 		if (ret) {
-			close(fd);
-			exit(1);
+			goto error;
 		}
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
@@ -1944,4 +1942,12 @@ out:
 	free(label);
 
 	return !!ret;
+error:
+	if (fd > 0)
+		close(fd);
+
+	free(label);
+	exit(1);
+success:
+	exit(0);
 }
-- 
1.9.1



