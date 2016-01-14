Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164AbcANGAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 3C53341896E9
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:54 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 5/8] btrfs-progs: Add dedup feature for mkfs and convert
Date: Thu, 14 Jan 2016 13:57:47 +0800
Message-ID: <1452751070-2460-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new DEDUP ro compat flag and corresponding mkfs/convert flag
'dedup'.

Since dedup tree is completely isolated from fs tree, so even old kernel
could do read mount.
So add it to RO compat flag instead of common incompat flags

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/mkfs.btrfs.asciidoc |  9 +++++++++
 btrfs-convert.c                   | 19 +++++++++++++------
 mkfs.c                            |  8 ++++++--
 utils.c                           | 38 +++++++++++++++++++++++++++-----------
 utils.h                           |  7 ++++---
 5 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 12d8840..5c5b41d 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -207,6 +207,15 @@ reduced-size metadata for extent references, saves a few percent of metadata
 improved representation of file extents where holes are not explicitly
 stored as an extent, saves a few percent of metadata if sparse files are used
 
+*dedup*::
+allow btrfs to use new on-disk format designed for in-band(write time)
+de-duplication.
++
+on-disk storage backend and persist de-duplication status needs this feature.
++
+unlike other features, this is an RO compat flag, means old kernel can still
+mount fs read-only.
+
 BLOCK GROUPS, CHUNKS, RAID
 --------------------------
 
diff --git a/btrfs-convert.c b/btrfs-convert.c
index 02e5cdb..bf1df48 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2288,7 +2288,7 @@ err:
 
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
-		u64 features)
+		u64 features, u64 ro_features)
 {
 	int i, ret, blocks_per_node;
 	int fd = -1;
@@ -2343,8 +2343,9 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
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
@@ -2360,6 +2361,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	mkfs_cfg.sectorsize = blocksize;
 	mkfs_cfg.stripesize = blocksize;
 	mkfs_cfg.features = features;
+	mkfs_cfg.ro_features = ro_features;
 
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
@@ -2898,6 +2900,7 @@ int main(int argc, char *argv[])
 	char *file;
 	char fslabel[BTRFS_LABEL_SIZE];
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 ro_features = 0;
 
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
@@ -2956,7 +2959,8 @@ int main(int argc, char *argv[])
 				char *orig = strdup(optarg);
 				char *tmp = orig;
 
-				tmp = btrfs_parse_fs_features(tmp, &features);
+				tmp = btrfs_parse_fs_features(tmp, &features,
+							      &ro_features);
 				if (tmp) {
 					fprintf(stderr,
 						"Unrecognized filesystem feature '%s'\n",
@@ -2974,7 +2978,9 @@ int main(int argc, char *argv[])
 					char buf[64];
 
 					btrfs_parse_features_to_string(buf,
-						features & ~BTRFS_CONVERT_ALLOWED_FEATURES);
+						features &
+						~BTRFS_CONVERT_ALLOWED_FEATURES,
+						ro_features);
 					fprintf(stderr,
 						"ERROR: features not allowed for convert: %s\n",
 						buf);
@@ -3025,7 +3031,8 @@ int main(int argc, char *argv[])
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
index 5f1411f..9c7acc2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1372,6 +1372,7 @@ int main(int ac, char **av)
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 ro_features = 0;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
 
@@ -1434,7 +1435,8 @@ int main(int ac, char **av)
 				char *orig = strdup(optarg);
 				char *tmp = orig;
 
-				tmp = btrfs_parse_fs_features(tmp, &features);
+				tmp = btrfs_parse_fs_features(tmp, &features,
+							      &ro_features);
 				if (tmp) {
 					fprintf(stderr,
 						"Unrecognized filesystem feature '%s'\n",
@@ -1677,6 +1679,7 @@ int main(int ac, char **av)
 	mkfs_cfg.sectorsize = sectorsize;
 	mkfs_cfg.stripesize = stripesize;
 	mkfs_cfg.features = features;
+	mkfs_cfg.ro_features = ro_features;
 
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
@@ -1831,7 +1834,8 @@ raid_groups:
 			btrfs_group_profile_str(metadata_profile),
 			pretty_size(allocation.system));
 		printf("SSD detected:       %s\n", ssd ? "yes" : "no");
-		btrfs_parse_features_to_string(features_buf, features);
+		btrfs_parse_features_to_string(features_buf, features,
+					       ro_features);
 		printf("Incompat features:  %s", features_buf);
 		printf("\n");
 
diff --git a/utils.c b/utils.c
index 60235d8..6b0c67a 100644
--- a/utils.c
+++ b/utils.c
@@ -250,6 +250,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
 	btrfs_set_super_incompat_flags(&super, cfg->features);
+	btrfs_set_super_compat_ro_flags(&super, cfg->ro_features);
 	if (cfg->label)
 		strncpy(super.label, cfg->label, BTRFS_LABEL_SIZE - 1);
 
@@ -572,23 +573,26 @@ out:
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
@@ -597,9 +601,11 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
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
@@ -607,7 +613,7 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 	return !found;
 }
 
-void btrfs_parse_features_to_string(char *buf, u64 flags)
+void btrfs_parse_features_to_string(char *buf, u64 flags, u64 ro_flags)
 {
 	int i;
 
@@ -619,10 +625,15 @@ void btrfs_parse_features_to_string(char *buf, u64 flags)
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
 
@@ -632,6 +643,11 @@ void btrfs_process_fs_features(u64 flags)
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
 
@@ -659,7 +675,7 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
  * Return NULL if all features were parsed fine, otherwise return the name of
  * the first unparsed.
  */
-char* btrfs_parse_fs_features(char *namelist, u64 *flags)
+char *btrfs_parse_fs_features(char *namelist, u64 *flags, u64 *ro_flags)
 {
 	char *this_char;
 	char *save_ptr = NULL; /* Satisfy static checkers */
@@ -667,7 +683,7 @@ char* btrfs_parse_fs_features(char *namelist, u64 *flags)
 	for (this_char = strtok_r(namelist, ",", &save_ptr);
 	     this_char != NULL;
 	     this_char = strtok_r(NULL, ",", &save_ptr)) {
-		if (parse_one_fs_feature(this_char, flags))
+		if (parse_one_fs_feature(this_char, flags, ro_flags))
 			return this_char;
 	}
 
diff --git a/utils.h b/utils.h
index b625330..835fd22 100644
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
@@ -115,6 +115,7 @@ struct btrfs_mkfs_config {
 	u32 sectorsize;
 	u32 stripesize;
 	u64 features;
+	u64 ro_features;
 };
 
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
-- 
2.7.0



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
