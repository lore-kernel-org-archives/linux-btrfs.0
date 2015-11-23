Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47270 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbKWM4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 07:56:25 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/5] btrfs-progs: add framework to check features supported by sysfs
Date: Mon, 23 Nov 2015 20:56:15 +0800
Message-Id: <1448283378-10579-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a framework to check the /sys/fs/btrfs/features for the list
of supported features by the btrfs kernel. Which I hope by using it the
mkfs and btrfs-convert could tune to set features as supported by the
running kernel.


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 utils.h |  1 +
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/utils.c b/utils.c
index 24042e5..48a1989 100644
--- a/utils.c
+++ b/utils.c
@@ -577,22 +577,23 @@ out:
  */
 static const struct btrfs_fs_feature {
 	const char *name;
+	const char *name_ker;
 	u64 flag;
 	const char *desc;
 	const char *min_ker_ver;
 } mkfs_features[] = {
-	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
+	{ "mixed-bg", "mixed_groups", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
 		"mixed data and metadata block groups", "2.7.31"},
-	{ "extref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF,
+	{ "extref", "extended_iref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF,
 		"increased hardlink limit per file to 65536", "3.7"},
-	{ "raid56", BTRFS_FEATURE_INCOMPAT_RAID56,
+	{ "raid56", "raid56", BTRFS_FEATURE_INCOMPAT_RAID56,
 		"raid56 extended format", "3.9"},
-	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
+	{ "skinny-metadata", "skinny_metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
 		"reduced-size metadata extent refs", "3.10"},
-	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
+	{ "no-holes", "no_holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
 		"no explicit hole extents for files", "3.14"},
 	/* Keep this one last */
-	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
+	{ "list-all", "", BTRFS_FEATURE_LIST_ALL, NULL }
 };
 
 static int parse_one_fs_feature(const char *name, u64 *flags)
@@ -602,10 +603,12 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 
 	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
 		if (name[0] == '^' &&
-			!strcmp(mkfs_features[i].name, name + 1)) {
+			(!strcmp(mkfs_features[i].name, name + 1) ||
+			!strcmp(mkfs_features[i].name_ker, name + 1))) {
 			*flags &= ~ mkfs_features[i].flag;
 			found = 1;
-		} else if (!strcmp(mkfs_features[i].name, name)) {
+		} else if (!strcmp(mkfs_features[i].name, name) ||
+			!strcmp(mkfs_features[i].name_ker, name)) {
 			*flags |= mkfs_features[i].flag;
 			found = 1;
 		}
@@ -3147,3 +3150,50 @@ u64 btrfs_features_allowed_by_kernel(void)
 	}
 	return (features);
 }
+
+int check_or_load_btrfs_ko()
+{
+	int fd;
+
+	/*
+	 * open will load btrfs kernel module if its not loaded,
+	 * and if the kernel has CONFIG auto load set?
+	 */
+	fd = open("/dev/btrfs-control", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	close(fd);
+	return 0;
+}
+
+int btrfs_features_allowed_by_sysfs(u64 *features)
+{
+	int ret;
+	DIR *dir;
+	struct dirent *ent;
+
+	ret = check_or_load_btrfs_ko();
+	if (ret) {
+		/* returns, -errno */
+		return ret;
+	}
+
+	dir = opendir("/sys/fs/btrfs/features");
+	if (!dir) {
+		/*
+		 * An old kernel which does not support sysfs/features
+		 */
+		return -errno;
+	}
+
+	*features = 0;
+	while((ent = readdir(dir)) != NULL) {
+		if (!strcmp(".", ent->d_name) ||
+				!strcmp("..", ent->d_name))
+			continue;
+		parse_one_fs_feature(ent->d_name, features);
+	}
+	closedir(dir);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 9044643..af0aa31 100644
--- a/utils.h
+++ b/utils.h
@@ -105,6 +105,7 @@ char* btrfs_parse_fs_features(char *namelist, u64 *flags);
 void btrfs_process_fs_features(u64 flags);
 void btrfs_parse_features_to_string(char *buf, u64 flags);
 u64 btrfs_features_allowed_by_kernel(void);
+int btrfs_features_allowed_by_sysfs(u64 *features);
 
 struct btrfs_mkfs_config {
 	char *label;
-- 
2.6.2

