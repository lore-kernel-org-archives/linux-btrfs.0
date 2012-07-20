Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48544 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2GTPGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 11:06:42 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id MyVAffbFkZOXjJgX (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 09:06:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: detect if the disk we are formatting is a ssd
Date: Fri, 20 Jul 2012 11:11:38 -0400
Message-ID: <1342797098-6493-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

SSD's do not gain anything by having metadata DUP turned on.  The underlying
file system that is a part of all SSD's could easily map duplicate metadat
blocks into the same erase block which effectively eliminates the benefit of
duplicating the metadata on disk.  So detect if we are formatting a single
SSD drive and if we are do not use DUP.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 mkfs.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index dff5eb8..858ba21 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -234,7 +234,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int metadata_profile_opt, int mixed)
+			      int metadata_profile_opt, int mixed, int ssd)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	u64 allowed;
@@ -246,7 +246,7 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	 */
 	if (!metadata_profile_opt && !mixed) {
 		metadata_profile = (num_devices > 1) ?
-			BTRFS_BLOCK_GROUP_RAID1 : BTRFS_BLOCK_GROUP_DUP;
+			BTRFS_BLOCK_GROUP_RAID1 : (ssd) ? 0: BTRFS_BLOCK_GROUP_DUP;
 	}
 	if (!data_profile_opt && !mixed) {
 		data_profile = (num_devices > 1) ?
@@ -1201,6 +1201,36 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 	return ret;
 }
 
+static int is_ssd(const char *file)
+{
+	char *dev = strrchr(file, '/');
+	char path[PATH_MAX];
+	int fd;
+	char rotational;
+
+	if (!dev)
+		return 0;
+
+	/* Move ahead one to the actual device */
+	dev++;
+	if (*dev == '\0')
+		return 0;
+
+	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		return 0;
+	}
+
+	if (read(fd, &rotational, sizeof(char)) < sizeof(char)) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+
+	return !atoi((const char *)&rotational);
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1227,6 +1257,7 @@ int main(int ac, char **av)
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 	int nodiscard = 0;
+	int ssd = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1352,6 +1383,9 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
+
+	ssd = is_ssd(file);
+
 	if (mixed) {
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
@@ -1438,7 +1472,7 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 metadata_profile_opt, mixed);
+				 metadata_profile_opt, mixed, ssd);
 		BUG_ON(ret);
 	}
 
-- 
1.7.7.6

