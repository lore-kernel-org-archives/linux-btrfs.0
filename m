Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:56945 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933660AbdKGInZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 08/12] btrfs-progs: fsfeatures: Introduce a new set of features, runtime_features
Date: Tue,  7 Nov 2017 16:42:55 +0800
Message-Id: <20171107084259.22367-12-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce runtime_features for fsfeatures.[ch], and related functions:
btrfs_list_all_runtime_features()
btrfs_parse_runtime_features()
btrfs_process_runtime_features()
btrfs_parse_runtime_features_to_string()

And rename one function to avoid confusion:
btrfs_parse_features_to_string() -> btrfs_parse_fs_features()

New runtime features mostly reuse the existing facility, just
introducing a new runtime_features[] array.

This provides the basis for later mkfs qgroup support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/main.c |   4 +-
 fsfeatures.c   | 128 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 fsfeatures.h   |   8 +++-
 mkfs/main.c    |   2 +-
 4 files changed, 114 insertions(+), 28 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 882daf7ced53..90161eed6b4d 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1118,7 +1118,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 		error("unable to open %s: %s", devname, strerror(errno));
 		goto fail;
 	}
-	btrfs_parse_features_to_string(features_buf, features);
+	btrfs_parse_fs_features_to_string(features_buf, features);
 	if (features == BTRFS_MKFS_DEFAULT_FEATURES)
 		strcat(features_buf, " (default)");
 
@@ -1761,7 +1761,7 @@ int main(int argc, char *argv[])
 				if (features & ~BTRFS_CONVERT_ALLOWED_FEATURES) {
 					char buf[64];
 
-					btrfs_parse_features_to_string(buf,
+					btrfs_parse_fs_features_to_string(buf,
 						features & ~BTRFS_CONVERT_ALLOWED_FEATURES);
 					error("features not allowed for convert: %s",
 						buf);
diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f1277..02205dcec32d 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -29,10 +29,15 @@
 #define VERSION_TO_STRING3(a,b,c)	#a "." #b "." #c, KERNEL_VERSION(a,b,c)
 #define VERSION_TO_STRING2(a,b)		#a "." #b, KERNEL_VERSION(a,b,0)
 
+enum feature_source {
+	FS_FEATURES,
+	RUNTIME_FEATURES
+};
+
 /*
  * Feature stability status and versions: compat <= safe <= default
  */
-static const struct btrfs_fs_feature {
+struct btrfs_feature {
 	const char *name;
 	u64 flag;
 	const char *sysfs_name;
@@ -55,7 +60,9 @@ static const struct btrfs_fs_feature {
 	const char *default_str;
 	u32 default_ver;
 	const char *desc;
-} mkfs_features[] = {
+};
+
+static const struct btrfs_feature mkfs_features[] = {
 	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
 		"mixed_groups",
 		VERSION_TO_STRING3(2,6,37),
@@ -90,18 +97,41 @@ static const struct btrfs_fs_feature {
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
 
-static int parse_one_fs_feature(const char *name, u64 *flags)
+static const struct btrfs_feature runtime_features[] = {
+	/* Keep this one last */
+	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
+};
+
+static size_t get_feature_array_size(enum feature_source source)
+{
+	if (source == FS_FEATURES)
+		return ARRAY_SIZE(mkfs_features);
+	return ARRAY_SIZE(runtime_features);
+}
+
+static const struct btrfs_feature *get_feature(int i,
+			enum feature_source source)
 {
+	if (source == FS_FEATURES)
+		return &mkfs_features[i];
+	return &runtime_features[i];
+}
+
+static int parse_one_fs_feature(const char *name, u64 *flags,
+				enum feature_source source)
+{
+	int array_size = get_feature_array_size(source);
 	int i;
 	int found = 0;
 
-	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
+	for (i = 0; i < array_size; i++) {
+		const struct btrfs_feature *feat = get_feature(i, source);
 		if (name[0] == '^' &&
-			!strcmp(mkfs_features[i].name, name + 1)) {
-			*flags &= ~ mkfs_features[i].flag;
+			!strcmp(feat->name, name + 1)) {
+			*flags &= ~feat->flag;
 			found = 1;
-		} else if (!strcmp(mkfs_features[i].name, name)) {
-			*flags |= mkfs_features[i].flag;
+		} else if (!strcmp(feat->name, name)) {
+			*flags |= feat->flag;
 			found = 1;
 		}
 	}
@@ -109,41 +139,72 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
 	return !found;
 }
 
-void btrfs_parse_features_to_string(char *buf, u64 flags)
+static void parse_features_to_string(char *buf, u64 flags,
+				     enum feature_source source)
 {
+	int array_size = get_feature_array_size(source);
 	int i;
 
 	buf[0] = 0;
 
-	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
-		if (flags & mkfs_features[i].flag) {
+	for (i = 0; i < array_size; i++) {
+		if (flags & get_feature(i, source)->flag) {
 			if (*buf)
 				strcat(buf, ", ");
-			strcat(buf, mkfs_features[i].name);
+			strcat(buf, get_feature(i, source)->name);
 		}
 	}
 }
 
-void btrfs_process_fs_features(u64 flags)
+void btrfs_parse_fs_features_to_string(char *buf, u64 flags)
+{
+	parse_features_to_string(buf, flags, FS_FEATURES);
+}
+
+void btrfs_parse_runtime_features_to_string(char *buf, u64 flags)
+{
+	parse_features_to_string(buf, flags, RUNTIME_FEATURES);
+}
+
+static void process_features(u64 flags, enum feature_source source)
 {
 	int i;
+	int array_size = get_feature_array_size(source);
+
+	for (i = 0; i < array_size; i++) {
+		const struct btrfs_feature *feat = get_feature(i, source);
 
-	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
-		if (flags & mkfs_features[i].flag) {
+		if (flags & feat->flag) {
 			printf("Turning ON incompat feature '%s': %s\n",
-				mkfs_features[i].name,
-				mkfs_features[i].desc);
+				feat->name, feat->desc);
 		}
 	}
 }
 
-void btrfs_list_all_fs_features(u64 mask_disallowed)
+void btrfs_process_fs_features(u64 flags)
+{
+	process_features(flags, FS_FEATURES);
+}
+
+void btrfs_process_runtime_features(u64 flags)
+{
+	process_features(flags, RUNTIME_FEATURES);
+}
+
+static void list_all_features(u64 mask_disallowed, enum feature_source source)
 {
 	int i;
+	int array_size = get_feature_array_size(source);
+	char *prefix;
+
+	if (source == FS_FEATURES)
+		prefix = "Filesystem";
+	else
+		prefix = "Runtime";
 
-	fprintf(stderr, "Filesystem features available:\n");
-	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
-		const struct btrfs_fs_feature *feat = &mkfs_features[i];
+	fprintf(stderr, "%s features available:\n", prefix);
+	for (i = 0; i < array_size - 1; i++) {
+		const struct btrfs_feature *feat = get_feature(i, source);
 
 		if (feat->flag & mask_disallowed)
 			continue;
@@ -159,11 +220,22 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
 	}
 }
 
+void btrfs_list_all_fs_features(u64 mask_disallowed)
+{
+	list_all_features(mask_disallowed, FS_FEATURES);
+}
+
+void btrfs_list_all_runtime_features(u64 mask_disallowed)
+{
+	list_all_features(mask_disallowed, RUNTIME_FEATURES);
+}
+
 /*
  * Return NULL if all features were parsed fine, otherwise return the name of
  * the first unparsed.
  */
-char* btrfs_parse_fs_features(char *namelist, u64 *flags)
+static char *parse_features(char *namelist, u64 *flags,
+			    enum feature_source source)
 {
 	char *this_char;
 	char *save_ptr = NULL; /* Satisfy static checkers */
@@ -171,13 +243,23 @@ char* btrfs_parse_fs_features(char *namelist, u64 *flags)
 	for (this_char = strtok_r(namelist, ",", &save_ptr);
 	     this_char != NULL;
 	     this_char = strtok_r(NULL, ",", &save_ptr)) {
-		if (parse_one_fs_feature(this_char, flags))
+		if (parse_one_fs_feature(this_char, flags, source))
 			return this_char;
 	}
 
 	return NULL;
 }
 
+char *btrfs_parse_fs_features(char *namelist, u64 *flags)
+{
+	return parse_features(namelist, flags, FS_FEATURES);
+}
+
+char *btrfs_parse_runtime_features(char *namelist, u64 *flags)
+{
+	return parse_features(namelist, flags, RUNTIME_FEATURES);
+}
+
 void print_kernel_version(FILE *stream, u32 version)
 {
 	u32 v[3];
diff --git a/fsfeatures.h b/fsfeatures.h
index 3cc9452a3327..7ea4a2b47740 100644
--- a/fsfeatures.h
+++ b/fsfeatures.h
@@ -40,9 +40,13 @@
 #define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
 
 void btrfs_list_all_fs_features(u64 mask_disallowed);
-char* btrfs_parse_fs_features(char *namelist, u64 *flags);
+void btrfs_list_all_runtime_features(u64 mask_disallowed);
+char *btrfs_parse_fs_features(char *namelist, u64 *flags);
+char *btrfs_parse_runtime_features(char *namelist, u64 *flags);
 void btrfs_process_fs_features(u64 flags);
-void btrfs_parse_features_to_string(char *buf, u64 flags);
+void btrfs_process_runtime_features(u64 flags);
+void btrfs_parse_fs_features_to_string(char *buf, u64 flags);
+void btrfs_parse_runtime_features_to_string(char *buf, u64 flags);
 void print_kernel_version(FILE *stream, u32 version);
 u32 get_running_kernel_version(void);
 int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features);
diff --git a/mkfs/main.c b/mkfs/main.c
index a846540b37ff..2bb30a6edea9 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -2045,7 +2045,7 @@ raid_groups:
 			btrfs_group_profile_str(metadata_profile),
 			pretty_size(allocation.system));
 		printf("SSD detected:       %s\n", ssd ? "yes" : "no");
-		btrfs_parse_features_to_string(features_buf, features);
+		btrfs_parse_fs_features_to_string(features_buf, features);
 		printf("Incompat features:  %s", features_buf);
 		printf("\n");
 
-- 
2.15.0

