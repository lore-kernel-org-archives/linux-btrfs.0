Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19783 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3HPMq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 08:46:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: mkfs should check for small vol well before
Date: Fri, 16 Aug 2013 20:52:30 +0800
Message-Id: <1376657550-15011-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fix the regression introduced by 830427d
that it no more creates the FS if disk is small
and if no mixed option is provided.
This patch will bring it to the original design
which will force mixed profile when disk is small
and go ahead to create the FS.

Which also means that before we open the device
for the write we should also check if disk is small.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c  |   20 +++++++++++---------
 utils.c |   29 +++++++++++++++++++++++++++++
 utils.h |    1 +
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 73f5425..e58e5c0 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1415,6 +1415,17 @@ int main(int ac, char **av)
 	file = av[optind++];
 	ssd = is_ssd(file);
 
+	if (is_vol_small(file)) {
+		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
+		mixed = 1;
+		if (metadata_profile != data_profile) {
+			if (metadata_profile_opt || data_profile_opt) {
+				fprintf(stderr, "With mixed block groups data and metadata "
+					"profiles must be the same\n");
+				exit(1);
+			}
+		}
+	}
 	/*
 	* Set default profiles according to number of added devices.
 	* For mixed groups defaults are single/single.
@@ -1435,7 +1446,6 @@ int main(int ac, char **av)
 				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
 		}
 	} else {
-		/* this is not needed but just for completeness */
 		metadata_profile = 0;
 		data_profile = 0;
 	}
@@ -1494,14 +1504,6 @@ int main(int ac, char **av)
 	}
 
 
-	if (mixed) {
-		if (metadata_profile != data_profile) {
-			fprintf(stderr, "With mixed block groups data and metadata "
-				"profiles must be the same\n");
-			exit(1);
-		}
-	}
-
 	blocks[0] = BTRFS_SUPER_INFO_OFFSET;
 	for (i = 1; i < 7; i++) {
 		blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
diff --git a/utils.c b/utils.c
index c26193e..422530d 100644
--- a/utils.c
+++ b/utils.c
@@ -1963,3 +1963,32 @@ int scan_for_btrfs(int where, int update_kernel)
 	}
 	return ret;
 }
+
+int is_vol_small(char *file)
+{
+	int fd = -1;
+	int e;
+	struct stat st;
+	u64 size;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+	if (fstat(fd, &st) < 0) {
+		e = -errno;
+		close(fd);
+		return e;
+	}
+	size = btrfs_device_size(fd, &st);
+	if (size == 0) {
+		close(fd);
+		return -1;
+	}
+	if (size < 1024 * 1024 * 1024) {
+		close(fd);
+		return 1;
+	} else {
+		close(fd);
+		return 0;
+	}
+}
diff --git a/utils.h b/utils.h
index 4b449b8..eb6fba3 100644
--- a/utils.h
+++ b/utils.h
@@ -82,4 +82,5 @@ int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+int is_vol_small(char *file);
 #endif
-- 
1.7.1

