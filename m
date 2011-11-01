From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs-progs: change the way mkfs picks raid profiles
Date: Tue,  1 Nov 2011 23:27:39 +0200
Message-ID: <1320182859-26246-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently mkfs in response to

  mkfs.btrfs -d raid10 dev1 dev2

instead of telling "you can't do that" creates a SINGLE on two devices,
and only rebalance can transform it to raid0.  Generally, it never warns
users about decisions it makes and it's not at all obvious which profile
it picks when.

Fix this by checking the number of effective devices and reporting back
if the specified profile is impossible to create.  Do not create FS in
case invalid profile was given.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 mkfs.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index e3ced19..66f0c9d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -228,12 +228,26 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
-			      u64 metadata_profile, int mixed)
+			      int data_profile_opt, u64 metadata_profile,
+			      int metadata_profile_opt, int mixed)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	u64 allowed;
 	int ret;
 
+	/*
+	 * Set default profiles according to number of added devices.
+	 * For mixed groups defaults are single/single.
+	 */
+	if (!metadata_profile_opt && !mixed) {
+		metadata_profile = (num_devices > 1) ?
+			BTRFS_BLOCK_GROUP_RAID1 : BTRFS_BLOCK_GROUP_DUP;
+	}
+	if (!data_profile_opt && !mixed) {
+		data_profile = (num_devices > 1) ?
+			BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
+	}
+
 	if (num_devices == 1)
 		allowed = BTRFS_BLOCK_GROUP_DUP;
 	else if (num_devices >= 4) {
@@ -242,6 +256,19 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	} else
 		allowed = BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1;
 
+	if (metadata_profile & ~allowed) {
+		fprintf(stderr,	"unable to create FS with metadata "
+			"profile %llu (%llu devices)\n", metadata_profile,
+			num_devices);
+		exit(1);
+	}
+	if (data_profile & ~allowed) {
+		fprintf(stderr, "unable to create FS with data "
+			"profile %llu (%llu devices)\n", data_profile,
+			num_devices);
+		exit(1);
+	}
+
 	if (allowed & metadata_profile) {
 		u64 meta_flags = BTRFS_BLOCK_GROUP_METADATA;
 
@@ -325,15 +352,16 @@ static u64 parse_profile(char *s)
 	if (strcmp(s, "raid0") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID0;
 	} else if (strcmp(s, "raid1") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP;
+		return BTRFS_BLOCK_GROUP_RAID1;
 	} else if (strcmp(s, "raid10") == 0) {
-		return BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_DUP;
+		return BTRFS_BLOCK_GROUP_RAID10;
 	} else if (strcmp(s, "single") == 0) {
 		return 0;
 	} else {
 		fprintf(stderr, "Unknown option %s\n", s);
 		print_usage();
 	}
+	/* not reached */
 	return 0;
 }
 
@@ -1170,8 +1198,8 @@ int main(int ac, char **av)
 	u64 dev_block_count = 0;
 	u64 blocks[7];
 	u64 alloc_start = 0;
-	u64 metadata_profile = BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP;
-	u64 data_profile = BTRFS_BLOCK_GROUP_RAID0;
+	u64 metadata_profile = 0;
+	u64 data_profile = 0;
 	u32 leafsize = getpagesize();
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
@@ -1303,11 +1331,6 @@ int main(int ac, char **av)
 		}
 	}
 	if (mixed) {
-		if (!metadata_profile_opt)
-			metadata_profile = 0;
-		if (!data_profile_opt)
-			data_profile = 0;
-
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
 				"profiles must be the same\n");
@@ -1390,7 +1413,8 @@ int main(int ac, char **av)
 raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
-				 metadata_profile, mixed);
+				 data_profile_opt, metadata_profile,
+				 metadata_profile_opt, mixed);
 		BUG_ON(ret);
 	}
 
-- 
1.7.6.3

