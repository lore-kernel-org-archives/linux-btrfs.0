Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3EPPEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 11:04:08 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A6FE9A50DD
	for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 17:04:06 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: add -O option to specify fs features
Date: Thu, 16 May 2013 17:04:04 +0200
Message-Id: <1368716644-5921-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extend mkfs options to specify optional or potentially backwards
incompatible features.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 man/mkfs.btrfs.8.in |   9 ++++
 mkfs.c              | 124 +++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index a3f1503..548e754 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -15,6 +15,7 @@ mkfs.btrfs \- create a btrfs filesystem
 [ \fB\-s\fP\fI sectorsize\fP ]
 [ \fB\-r\fP\fI rootdir\fP ]
 [ \fB\-K\fP ]
+[ \fB\-O\fP\fI feature1,feature2,...\fP ]
 [ \fB\-h\fP ]
 [ \fB\-V\fP ]
 \fI device\fP [ \fIdevice ...\fP ]
@@ -77,6 +78,14 @@ Specify a directory to copy into the newly created fs.
 \fB\-K\fR, \fB\-\-nodiscard \fR
 Do not perform whole device TRIM operation by default.
 .TP
+\fB\-O\fR, \fB\-\-features \fIfeature1,feature2,...\fR
+A list of filesystem features turned on at mkfs time. Not all features are
+supported by old kernels.
+
+To see all run
+
+\fBmkfs.btrfs -O list-all\fR
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
 .SH UNIT
diff --git a/mkfs.c b/mkfs.c
index 7ff60e5..79a5779 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -336,6 +336,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
+	fprintf(stderr, "\t -O --features comma separated list of filesystem features\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
@@ -397,6 +398,7 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
+	{ "features", 0, NULL, 'O' },
 	{ 0, 0, 0, 0}
 };
 
@@ -1253,6 +1255,87 @@ static int is_ssd(const char *file)
 	return !atoi((const char *)&rotational);
 }
 
+#define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
+
+static const struct btrfs_fs_feature {
+	const char *name;
+	u64 flag;
+	const char *desc;
+} mkfs_features[] = {
+	{ "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
+		"mixed data and metadata block groups" },
+	{ "extref", BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF,
+		"increased hardlink limit per file to 65536" },
+	{ "raid56", BTRFS_FEATURE_INCOMPAT_RAID56,
+		"raid56 extended format" },
+	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
+		"reduced-size metadata extent refs" },
+	/* Keep this one last */
+	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
+};
+
+static void list_all_fs_features(void)
+{
+	int i;
+
+	fprintf(stderr, "Filesystem features available at mkfs time:\n");
+	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
+		fprintf(stderr, "%-20s- %s (0x%llx)\n",
+				mkfs_features[i].name,
+				mkfs_features[i].desc,
+				mkfs_features[i].flag);
+	}
+}
+
+static int parse_one_fs_feature(const char *name, u64 *flags)
+{
+	int i;
+	int found = 0;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
+		if (!strcmp(mkfs_features[i].name, name)) {
+			*flags |= mkfs_features[i].flag;
+			found = 1;
+		}
+	}
+
+	return !found;
+}
+
+static void process_fs_features(u64 flags)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
+		if (flags & mkfs_features[i].flag) {
+			fprintf(stderr,
+				"Turning ON incompat feature '%s': %s\n",
+				mkfs_features[i].name,
+				mkfs_features[i].desc);
+		}
+	}
+}
+
+
+/*
+ * Return NULL if all features were parsed fine, otherwise return the name of
+ * the first unparsed.
+ */
+static char* parse_fs_features(char *namelist, u64 *flags)
+{
+	char *this_char;
+	char *save_ptr = NULL; /* Satisfy static checkers */
+
+	for (this_char = strtok_r(namelist, ",", &save_ptr);
+	     this_char != NULL;
+	     this_char = strtok_r(NULL, ",", &save_ptr)) {
+		if (parse_one_fs_feature(this_char, flags))
+			return this_char;
+	}
+
+	return NULL;
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1293,10 +1376,11 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
+	u64 features = 0;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:r:VMK",
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMK",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1326,6 +1410,25 @@ int main(int ac, char **av)
 			case 'M':
 				mixed = 1;
 				break;
+			case 'O': {
+				char *orig = strdup(optarg);
+				char *tmp = orig;
+
+				tmp = parse_fs_features(tmp, &features);
+				if (tmp) {
+					fprintf(stderr,
+						"Unrecognized filesystem feature '%s'\n",
+							tmp);
+					free(orig);
+					exit(1);
+				}
+				free(orig);
+				if (features & BTRFS_FEATURE_LIST_ALL) {
+					list_all_fs_features();
+					exit(0);
+				}
+				break;
+				}
 			case 's':
 				sectorsize = parse_size(optarg);
 				break;
@@ -1521,21 +1624,22 @@ raid_groups:
 	super = root->fs_info->super_copy;
 	flags = btrfs_super_incompat_flags(super);
 
+	/*
+	 * FS features that can be set by other means than -O
+	 * just set the bit here
+	 */
 	if (mixed)
-		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-
-	btrfs_set_super_incompat_flags(super, flags);
+		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
 
 	if ((data_profile | metadata_profile) &
 	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
-		struct btrfs_super_block *super = root->fs_info->super_copy;
-		u64 flags = btrfs_super_incompat_flags(super);
-
-		flags |= BTRFS_FEATURE_INCOMPAT_RAID56;
-		btrfs_set_super_incompat_flags(super, flags);
-		printf("Setting RAID5/6 feature flag\n");
+		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
+	process_fs_features(features);
+	flags |= features;
+	btrfs_set_super_incompat_flags(super, flags);
+
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-- 
1.8.2

