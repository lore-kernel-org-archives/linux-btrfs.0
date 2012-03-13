From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: allow dup for data chunks in mixed mode
Date: Tue, 13 Mar 2012 22:47:39 +0200
Message-ID: <1331671659-7721-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Before commit a46e7ff2 was merged it was possible to create dup for
data+metadata chunks (mixed mode) by giving -m raid1 -d raid1 -M to
mkfs.  a46e7ff2 purposefully disabled behind the scenes profile
upgrading/downgrading, so give users a chance to pick dup explicitly and
bail if dup for data is requested in normal mode.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 mkfs.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d3f45bd..6d3ef29 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -258,17 +258,23 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 
 	if (metadata_profile & ~allowed) {
 		fprintf(stderr,	"unable to create FS with metadata "
-			"profile %llu (%llu devices)\n", metadata_profile,
+			"profile %llu (have %llu devices)\n", metadata_profile,
 			num_devices);
 		exit(1);
 	}
 	if (data_profile & ~allowed) {
 		fprintf(stderr, "unable to create FS with data "
-			"profile %llu (%llu devices)\n", data_profile,
+			"profile %llu (have %llu devices)\n", data_profile,
 			num_devices);
 		exit(1);
 	}
 
+	/* allow dup'ed data chunks only in mixed mode */
+	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
+		fprintf(stderr, "dup for data is allowed only in mixed mode\n");
+		exit(1);
+	}
+
 	if (allowed & metadata_profile) {
 		u64 meta_flags = BTRFS_BLOCK_GROUP_METADATA;
 
@@ -329,7 +335,7 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
-	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10, dup or single\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -355,10 +361,12 @@ static u64 parse_profile(char *s)
 		return BTRFS_BLOCK_GROUP_RAID1;
 	} else if (strcmp(s, "raid10") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID10;
+	} else if (strcmp(s, "dup") == 0) {
+		return BTRFS_BLOCK_GROUP_DUP;
 	} else if (strcmp(s, "single") == 0) {
 		return 0;
 	} else {
-		fprintf(stderr, "Unknown option %s\n", s);
+		fprintf(stderr, "Unknown profile %s\n", s);
 		print_usage();
 	}
 	/* not reached */
-- 
1.7.9.1

