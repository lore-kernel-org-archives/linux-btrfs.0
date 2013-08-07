Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45739 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab3HGMFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 08:05:43 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r77C5fYE010755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:42 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5e5H015340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:41 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5enp014813
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: avoid write to the disk before sure to create fs
Date: Wed,  7 Aug 2013 20:11:25 +0800
Message-Id: <1375877485-12105-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>

This patch provides fix for the following bug,

When mkfs.btrfs fails the disks shouldn't be written.
------------
btrfs fi show /dev/sdb
Label: none  uuid: 60fb76f4-3b4d-4632-a7da-6a44dea5573d
        Total devices 1 FS bytes used 24.00KiB
        devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

mkfs.btrfs -dsingle -mraid1 /dev/sdb -f
::
unable to create FS with metadata profile 16 (have 1 devices)

btrfs fi show /dev/sdb
Label: none  uuid: 2da2179d-ecb1-4a4e-a44d-e7613a08c18d
        Total devices 1 FS bytes used 24.00KiB
        devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
-------------

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c  |  104 +++++++++++++++++++++++++--------------------------------------
 utils.c |   41 +++++++++++++++++++++++++
 utils.h |    2 +
 3 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 6325c1f..d01d08b 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -195,83 +195,28 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      int metadata_profile_opt, int mixed, int ssd)
 {
 	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
-	u64 allowed = 0;
-	u64 devices_for_raid = num_devices;
 	int ret;
 
-	/*
-	 * Set default profiles according to number of added devices.
-	 * For mixed groups defaults are single/single.
-	 */
-	if (!metadata_profile_opt && !mixed) {
-		if (num_devices == 1 && ssd)
-			printf("Detected a SSD, turning off metadata "
-			       "duplication.  Mkfs with -m dup if you want to "
-			       "force metadata duplication.\n");
-		metadata_profile = (num_devices > 1) ?
-			BTRFS_BLOCK_GROUP_RAID1 : (ssd) ? 0: BTRFS_BLOCK_GROUP_DUP;
-	}
-	if (!data_profile_opt && !mixed) {
-		data_profile = (num_devices > 1) ?
-			BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
-	}
-
-	if (devices_for_raid > 4)
-		devices_for_raid = 4;
-
-	switch (devices_for_raid) {
-	default:
-	case 4:
-		allowed |= BTRFS_BLOCK_GROUP_RAID10;
-	case 3:
-		allowed |= BTRFS_BLOCK_GROUP_RAID6;
-	case 2:
-		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			BTRFS_BLOCK_GROUP_RAID5;
-		break;
-	case 1:
-		allowed |= BTRFS_BLOCK_GROUP_DUP;
-	}
-
-	if (metadata_profile & ~allowed) {
-		fprintf(stderr,	"unable to create FS with metadata "
-			"profile %llu (have %llu devices)\n", metadata_profile,
-			num_devices);
-		exit(1);
-	}
-	if (data_profile & ~allowed) {
-		fprintf(stderr, "unable to create FS with data "
-			"profile %llu (have %llu devices)\n", data_profile,
-			num_devices);
-		exit(1);
-	}
-
-	/* allow dup'ed data chunks only in mixed mode */
-	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
-		fprintf(stderr, "dup for data is allowed only in mixed mode\n");
-		exit(1);
-	}
-
-	if (allowed & metadata_profile) {
+	if (metadata_profile) {
 		u64 meta_flags = BTRFS_BLOCK_GROUP_METADATA;
 
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_SYSTEM |
-					    (allowed & metadata_profile));
+					    metadata_profile);
 		BUG_ON(ret);
 
 		if (mixed)
 			meta_flags |= BTRFS_BLOCK_GROUP_DATA;
 
 		ret = create_one_raid_group(trans, root, meta_flags |
-					    (allowed & metadata_profile));
+					    metadata_profile);
 		BUG_ON(ret);
 
 	}
-	if (!mixed && num_devices > 1 && (allowed & data_profile)) {
+	if (!mixed && num_devices > 1 && data_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
-					    (allowed & data_profile));
+					    data_profile);
 		BUG_ON(ret);
 	}
 	recow_roots(trans, root);
@@ -1464,14 +1409,48 @@ int main(int ac, char **av)
 			}
 	}
 
-	/* if we are here that means all devs are good to btrfsify */
 	optind = saved_optind;
 	dev_cnt = ac - optind;
 
+	file = av[optind++];
+	ssd = is_ssd(file);
+
+	/*
+	* Set default profiles according to number of added devices.
+	* For mixed groups defaults are single/single.
+	*/
+	if (!mixed) {
+		if (!metadata_profile_opt) {
+			if (dev_cnt == 1 && ssd)
+				printf("Detected a SSD, turning off metadata "
+				"duplication.  Mkfs with -m dup if you want to "
+				"force metadata duplication.\n");
+
+			metadata_profile = (dev_cnt > 1) ?
+					BTRFS_BLOCK_GROUP_RAID1 : (ssd) ?
+					0: BTRFS_BLOCK_GROUP_DUP;
+		}
+		if (!data_profile_opt) {
+			data_profile = (dev_cnt > 1) ?
+				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
+		}
+	} else {
+		/* this is not needed but just for completeness */
+		metadata_profile = 0;
+		data_profile = 0;
+	}
+
+	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
+			dev_cnt, mixed, estr);
+	if (ret) {
+		fprintf(stderr, "Error: %s\n", estr);
+		exit(1);
+	}
+
+	/* if we are here that means all devs are good to btrfsify */
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
-	file = av[optind++];
 	dev_cnt--;
 
 	if (!source_dir_set) {
@@ -1514,7 +1493,6 @@ int main(int ac, char **av)
 		dev_block_count = block_count;
 	}
 
-	ssd = is_ssd(file);
 
 	if (mixed) {
 		if (metadata_profile != data_profile) {
diff --git a/utils.c b/utils.c
index e35529e..8a57967 100644
--- a/utils.c
+++ b/utils.c
@@ -1798,6 +1798,47 @@ out:
 	return ret;
 }
 
+int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
+	u64 dev_cnt, int mixed, char *estr)
+{
+	size_t sz = 100;
+	u64 allowed = 0;
+
+	switch (dev_cnt) {
+	default:
+	case 4:
+		allowed |= BTRFS_BLOCK_GROUP_RAID10;
+	case 3:
+		allowed |= BTRFS_BLOCK_GROUP_RAID6;
+	case 2:
+		allowed |= BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
+			BTRFS_BLOCK_GROUP_RAID5;
+		break;
+	case 1:
+		allowed |= BTRFS_BLOCK_GROUP_DUP;
+	}
+
+	if (metadata_profile & ~allowed) {
+		snprintf(estr, sz, "unable to create FS with metadata "
+			"profile %llu (have %llu devices)\n",
+			metadata_profile, dev_cnt);
+		return 1;
+	}
+	if (data_profile & ~allowed) {
+		snprintf(estr, sz, "unable to create FS with data "
+			"profile %llu (have %llu devices)\n",
+			metadata_profile, dev_cnt);
+		return 1;
+	}
+
+	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
+		snprintf(estr, sz,
+			"dup for data is allowed only in mixed mode");
+		return 1;
+	}
+	return 0;
+}
+
 /* Check if disk is suitable for btrfs
  * returns:
  *  1: something is wrong, estr provides the error
diff --git a/utils.h b/utils.h
index 1e5353b..6419c3e 100644
--- a/utils.h
+++ b/utils.h
@@ -80,4 +80,6 @@ u64 btrfs_device_size(int fd, struct stat *st);
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
+int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
+	u64 dev_cnt, int mixed, char *estr);
 #endif
-- 
1.7.1

