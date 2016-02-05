Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33020 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbcBEBZO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:25:14 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id D610E4056407
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Feb 2016 09:25:04 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 5/8] btrfs-progs: Add dedup feature for mkfs and convert
Date: Fri,  5 Feb 2016 09:23:01 +0800
Message-Id: <1454635384-10106-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635384-10106-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635384-10106-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new DEDUP ro compat flag and corresponding mkfs/convert flag
'dedup'.

Since dedup tree is completely isolated from fs tree, so even old kernel
could do read mount.
So add it to RO compat flag instead of common incompat flags

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/mkfs.btrfs.asciidoc |  9 ++++++++
 btrfs-convert.c                   | 19 +++++++++++-----
 mkfs.c                            |  8 +++++--
 utils.c                           | 47 +++++++++++++++++++++++++++++----------
 utils.h                           |  7 +++---
 5 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 0b145c7..f52690d 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -208,6 +208,15 @@ reduced-size metadata for extent references, saves a few percent of metadata
 improved representation of file extents where holes are not explicitly
 stored as an extent, saves a few percent of metadata if sparse files are used
 
+*dedup*::
+allow btrfs to use new on-disk format designed for in-band(write time)
+de-duplication.
++
+on-disk storage backend and persist de-duplication status needs this feature.
++
+this feature is RO compat feature, means old kernel can still mount it
+read-only.
+
 BLOCK GROUPS, CHUNKS, RAID
 --------------------------
 
diff --git a/btrfs-convert.c b/btrfs-convert.c
index 4baa68e..ad25065 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2453,7 +2453,7 @@ static int convert_open_fs(const char *devname,
 
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
-		u64 features)
+		u64 features, u64 ro_features)
 {
 	int i, ret, blocks_per_node;
 	int fd = -1;
@@ -2504,8 +2504,9 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	btrfs_parse_features_to_string(features_buf, features);
-	if (features == BTRFS_MKFS_DEFAULT_FEATURES)
+	btrfs_parse_features_to_string(features_buf, features, ro_features);
+	if (features == BTRFS_MKFS_DEFAULT_FEATURES &&
+	    ro_features == 0)
 		strcat(features_buf, " (default)");
 
 	printf("create btrfs filesystem:\n");
@@ -2521,6 +2522,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	mkfs_cfg.sectorsize = blocksize;
 	mkfs_cfg.stripesize = blocksize;
 	mkfs_cfg.features = features;
+	mkfs_cfg.ro_features = ro_features;
 
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
@@ -3071,6 +3073,7 @@ int main(int argc, char *argv[])
 	char *file;
 	char fslabel[BTRFS_LABEL_SIZE];
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 ro_features = 0;
 
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
@@ -3129,7 +3132,8 @@ int main(int argc, char *argv[])
 				char *orig = strdup(optarg);
 				char *tmp = orig;
 
-				tmp = btrfs_parse_fs_features(tmp, &features);
+				tmp = btrfs_parse_fs_features(tmp, &features,
+							      &ro_features);
 				if (tmp) {
 					fprintf(stderr,
 						"Unrecognized filesystem feature '%s'\n",
@@ -3147,7 +3151,9 @@ int main(int argc, char *argv[])
 					char buf[64];
 
 					btrfs_parse_features_to_string(buf,
-						features & ~BTRFS_CONVERT_ALLOWED_FEATURES);
+						features &
+						~BTRFS_CONVERT_ALLOWED_FEATURES,
+						ro_features);
 					fprintf(stderr,
 						"ERROR: features not allowed for convert: %s\n",
 						buf);
@@ -3198,7 +3204,8 @@ int main(int argc, char *argv[])
 		ret = do_rollback(file);
 	} else {
 		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
-				copylabel, fslabel, progress, features);
+				copylabel, fslabel, progress, features,
+				ro_features);
 	}
 	if (ret)
 		return 1;
diff --git a/mkfs.c b/mkfs.c
index ea58404..184b9d2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1369,6 +1369,7 @@ int main(int ac, char **av)
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 ro_features = 0;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
 
@@ -1431,7 +1432,8 @@ int main(int ac, char **av)
 				char *orig = strdup(optarg);
 				char *tmp = orig;
 
-				tmp = btrfs_parse_fs_features(tmp, &features);
+				tmp = btrfs_parse_fs_features(tmp, &features,
+							      &ro_features);
 				if (tmp) {
 					fprintf(stderr,
 						"Unrecognized filesystem feature '%s'\n",
@@ -1674,6 +1676,7 @@ int main(int ac, char **av)
 	mkfs_cfg.sectorsize = sectorsize;
 	mkfs_cfg.stripesize = stripesize;
 	mkfs_cfg.features = features;
+	mkfs_cfg.ro_features = ro_features;
 
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
@@ -1828,7 +1831,8 @@ raid_groups:
 			btrfs_group_profile_str(metadata_profile),
 			pretty_size(allocation.system));
 		printf("SSD detected:       %s\n", ssd ? "yes" : "no");
-		btrfs_parse_features_to_string(features_buf, features);
+		btrfs_parse_features_to_string(features_buf, features,
+					       ro_features);
 		printf("Incompat features:  %s", features_buf);
 		printf("\n");
 
diff --git a/utils.c b/utils.c
index 3df8b42..a1af682 100644
--- a/utils.c
+++ b/utils.c
@@ -252,6 +252,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
 	btrfs_set_super_incompat_flags(&super, cfg->features);
+	btrfs_set_super_compat_ro_flags(&super, cfg->ro_features);
 	if (cfg->label)
 		strncpy(super.label, cfg->label, BTRFS_LABEL_SIZE - 1);
 
@@ -574,23 +575,26 @@ out:
 static const struct btrfs_fs_feature {
 	const char *name;
 	u64 flag;
+	u64 ro_flag;
 	const char *desc;
 } mkfs_features[] = {
-	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
+	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS, 0,
 		"mixed data and metadata block groups" },
-	{ "extref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF,
+	{ "extref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF, 0,
 		"increased hardlink limit per file to 65536" },
-	{ "raid56", BTRFS_FEATURE_INCOMPAT_RAID56,
+	{ "raid56", BTRFS_FEATURE_INCOMPAT_RAID56, 0,
 		"raid56 extended format" },
-	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
+	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA, 0,
 		"reduced-size metadata extent refs" },
-	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
+	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES, 0,
 		"no explicit hole extents for files" },
+	{ "dedup", 0, BTRFS_FEATURE_COMPAT_RO_DEDUP,
+		"support on-disk dedup backend and persist dedup status" },
 	/* Keep this one last */
-	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
+	{ "list-all", BTRFS_FEATURE_LIST_ALL, 0, NULL }
 };
 
-static int parse_one_fs_feature(const char *name, u64 *flags)
+static int parse_one_fs_feature(const char *name, u64 *flags, u64 *ro_flags)
 {
 	int i;
 	int found = 0;
@@ -599,9 +603,11 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 		if (name[0] == '^' &&
 			!strcmp(mkfs_features[i].name, name + 1)) {
 			*flags &= ~ mkfs_features[i].flag;
+			*ro_flags &= ~mkfs_features[i].ro_flag;
 			found = 1;
 		} else if (!strcmp(mkfs_features[i].name, name)) {
 			*flags |= mkfs_features[i].flag;
+			*ro_flags |= mkfs_features[i].ro_flag;
 			found = 1;
 		}
 	}
@@ -609,7 +615,7 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 	return !found;
 }
 
-void btrfs_parse_features_to_string(char *buf, u64 flags)
+void btrfs_parse_features_to_string(char *buf, u64 flags, u64 ro_flags)
 {
 	int i;
 
@@ -621,10 +627,15 @@ void btrfs_parse_features_to_string(char *buf, u64 flags)
 				strcat(buf, ", ");
 			strcat(buf, mkfs_features[i].name);
 		}
+		if (ro_flags & mkfs_features[i].ro_flag) {
+			if (*buf)
+				strcat(buf, ", ");
+			strcat(buf, mkfs_features[i].name);
+		}
 	}
 }
 
-void btrfs_process_fs_features(u64 flags)
+void btrfs_process_fs_features(u64 flags, u64 ro_flags)
 {
 	int i;
 
@@ -634,6 +645,11 @@ void btrfs_process_fs_features(u64 flags)
 				mkfs_features[i].name,
 				mkfs_features[i].desc);
 		}
+		if (ro_flags & mkfs_features[i].ro_flag) {
+			printf("Turning ON RO compat features '%s': %s\n",
+				mkfs_features[i].name,
+				mkfs_features[i].desc);
+		}
 	}
 }
 
@@ -649,11 +665,18 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
 			continue;
 		if (mkfs_features[i].flag & BTRFS_MKFS_DEFAULT_FEATURES)
 			is_default = ", default";
-		fprintf(stderr, "%-20s- %s (0x%llx%s)\n",
+		if (mkfs_features[i].flag)
+			printf("%-20s- %s (incompat flag: 0x%llx%s)\n",
 				mkfs_features[i].name,
 				mkfs_features[i].desc,
 				mkfs_features[i].flag,
 				is_default);
+		else
+			printf("%-20s- %s (ro compat flag: 0x%llx%s)\n",
+				mkfs_features[i].name,
+				mkfs_features[i].desc,
+				mkfs_features[i].ro_flag,
+				is_default);
 	}
 }
 
@@ -661,7 +684,7 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
  * Return NULL if all features were parsed fine, otherwise return the name of
  * the first unparsed.
  */
-char* btrfs_parse_fs_features(char *namelist, u64 *flags)
+char *btrfs_parse_fs_features(char *namelist, u64 *flags, u64 *ro_flags)
 {
 	char *this_char;
 	char *save_ptr = NULL; /* Satisfy static checkers */
@@ -669,7 +692,7 @@ char* btrfs_parse_fs_features(char *namelist, u64 *flags)
 	for (this_char = strtok_r(namelist, ",", &save_ptr);
 	     this_char != NULL;
 	     this_char = strtok_r(NULL, ",", &save_ptr)) {
-		if (parse_one_fs_feature(this_char, flags))
+		if (parse_one_fs_feature(this_char, flags, ro_flags))
 			return this_char;
 	}
 
diff --git a/utils.h b/utils.h
index d53357a..4a14d25 100644
--- a/utils.h
+++ b/utils.h
@@ -102,9 +102,9 @@ void units_set_mode(unsigned *units, unsigned mode);
 void units_set_base(unsigned *units, unsigned base);
 
 void btrfs_list_all_fs_features(u64 mask_disallowed);
-char* btrfs_parse_fs_features(char *namelist, u64 *flags);
-void btrfs_process_fs_features(u64 flags);
-void btrfs_parse_features_to_string(char *buf, u64 flags);
+char *btrfs_parse_fs_features(char *namelist, u64 *flags, u64 *ro_flags);
+void btrfs_process_fs_features(u64 flags, u64 ro_flags);
+void btrfs_parse_features_to_string(char *buf, u64 flags, u64 ro_flags);
 
 struct btrfs_mkfs_config {
 	char *label;
@@ -119,6 +119,7 @@ struct btrfs_mkfs_config {
 
 	/* Super bytenr after make_btrfs */
 	u64 super_bytenr;
+	u64 ro_features;
 };
 
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
-- 
2.7.0



