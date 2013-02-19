Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab3BSLQS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 06:16:18 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 91B91A3A78
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 12:16:17 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [RFC][PATCH] btrfs-progs: mkfs: add -O option to specify fs features
Date: Tue, 19 Feb 2013 12:16:12 +0100
Message-Id: <1361272572-6393-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extend mkfs options to specify optional or potentially backwards
incompatible features. Use it for extended references.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

The RFC is for the option name, as there does not seem to be a common name
amongst other mkfses.


 man/mkfs.btrfs.8.in |  7 +++++++
 mkfs.c              | 14 ++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 41163e0..5ff4e2c 100644
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
@@ -76,6 +77,12 @@ Specify a directory to copy into the newly created fs.
 \fB\-K\fR, \fB\-\-nodiscard \fR
 Do not perform whole device TRIM operation by default.
 .TP
+\fB\-O\fR, \fB\-\-features \fIfeature1,feature2,...\fR
+A list of filesystem features turned on at mkfs time. Not all features are
+supported by old kernels.
+
+extref - allow creating more hardlinks per file (the upper limit is 65535)
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
 .SH UNIT
diff --git a/mkfs.c b/mkfs.c
index 5ece186..dd1e317 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -335,6 +335,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
 	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "\t -K --nodiscard do not perform whole device TRIM\n");
+	fprintf(stderr, "\t -O --features coma separated list of filesystem features\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
@@ -395,6 +396,7 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
+	{ "features", 0, NULL, 'O' },
 	{ 0, 0, 0, 0}
 };
 
@@ -1376,10 +1378,11 @@ int main(int ac, char **av)
 	char *pretty_buf;
 	struct btrfs_super_block *super;
 	u64 flags;
+	char *features = strdup("");
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:r:VMK", long_options,
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:VMK", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1409,6 +1412,10 @@ int main(int ac, char **av)
 			case 'M':
 				mixed = 1;
 				break;
+			case 'O':
+				free(features);
+				features = strdup(optarg);
+				break;
 			case 's':
 				sectorsize = parse_size(optarg);
 				break;
@@ -1652,7 +1659,10 @@ raid_groups:
 
 	super = &root->fs_info->super_copy;
 	flags = btrfs_super_incompat_flags(super);
-	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
+	if (strstr(features, "extref") == 0) {
+		fprintf(stderr, "Turning ON incompat feature: extref (increased hardlink limit per file)\n");
+		flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
+	}
 
 	if (mixed)
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-- 
1.8.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
