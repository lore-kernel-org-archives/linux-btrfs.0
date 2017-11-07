Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48303 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933661AbdKGInZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 09/12] btrfs-progs: mkfs: Introduce --runtime-features option
Date: Tue,  7 Nov 2017 16:42:56 +0800
Message-Id: <20171107084259.22367-13-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like -O|--features, introduce -R|--runtime-features to enable
features like qgroup, and maybe space cache later.

Currently only mkfs is supported, mainly for test purpose.
Convert is not supported yet.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.asciidoc | 16 ++++++++++
 mkfs/main.c                       | 64 +++++++++++++++++++++++++++------------
 2 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e265fb7..7def34cc9074 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -116,6 +116,16 @@ features that mkfs.btrfs supports run:
 +
 +mkfs.btrfs -O list-all+
 
+*-R|--runtime-features <feature1>[,<feature2>...]*::
+A list of runtime features turned on at mkfs time.
+Although no runtime feature is enabled by default,
+to disable a feature, prefix it with '^'.
++
+See section *RUNTIME FEATURES* for more details.  To see all available
+runtime features that mkfs.btrfs supports run:
++
++mkfs.btrfs -R list-all+
+
 *-f|--force*::
 Forcibly overwrite the block devices when an existing filesystem is detected.
 By default, mkfs.btrfs will utilize 'libblkid' to check for any known
@@ -204,6 +214,12 @@ reduced-size metadata for extent references, saves a few percent of metadata
 improved representation of file extents where holes are not explicitly
 stored as an extent, saves a few percent of metadata if sparse files are used
 
+RUNTIME FEATURES
+----------------
+
+Btrfs has some feature which can be enabled by ioctl after mount.
+Some of such features can also be enabled during creation time.
+
 BLOCK GROUPS, CHUNKS, RAID
 --------------------------
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 2bb30a6edea9..bca97146cecb 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -356,27 +356,28 @@ static void print_usage(int ret)
 	printf("Usage: mkfs.btrfs [options] dev [ dev ... ]\n");
 	printf("Options:\n");
 	printf("  allocation profiles:\n");
-	printf("\t-d|--data PROFILE       data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
-	printf("\t-m|--metadata PROFILE   metadata profile, values like for data profile\n");
-	printf("\t-M|--mixed              mix metadata and data together\n");
+	printf("\t-d|--data PROFILE          data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
+	printf("\t-m|--metadata PROFILE      metadata profile, values like for data profile\n");
+	printf("\t-M|--mixed                 mix metadata and data together\n");
 	printf("  features:\n");
-	printf("\t-n|--nodesize SIZE      size of btree nodes\n");
-	printf("\t-s|--sectorsize SIZE    data block size (may not be mountable by current kernel)\n");
-	printf("\t-O|--features LIST      comma separated list of filesystem features (use '-O list-all' to list features)\n");
-	printf("\t-L|--label LABEL        set the filesystem label\n");
-	printf("\t-U|--uuid UUID          specify the filesystem UUID (must be unique)\n");
+	printf("\t-n|--nodesize SIZE         size of btree nodes\n");
+	printf("\t-s|--sectorsize SIZE       data block size (may not be mountable by current kernel)\n");
+	printf("\t-O|--features LIST         comma separated list of filesystem features (use '-O list-all' to list features)\n");
+	printf("\t-R|--runtime-features LIST comma separated list of runtime features (use '-R list-all' to list runtime features)\n");
+	printf("\t-L|--label LABEL           set the filesystem label\n");
+	printf("\t-U|--uuid UUID             specify the filesystem UUID (must be unique)\n");
 	printf("  creation:\n");
-	printf("\t-b|--byte-count SIZE    set filesystem size to SIZE (on the first device)\n");
-	printf("\t-r|--rootdir DIR        copy files from DIR to the image root directory\n");
-	printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
-	printf("\t-f|--force              force overwrite of existing filesystem\n");
+	printf("\t-b|--byte-count SIZE       set filesystem size to SIZE (on the first device)\n");
+	printf("\t-r|--rootdir DIR           copy files from DIR to the image root directory\n");
+	printf("\t-K|--nodiscard             do not perform whole device TRIM\n");
+	printf("\t-f|--force                 force overwrite of existing filesystem\n");
 	printf("  general:\n");
-	printf("\t-q|--quiet              no messages except errors\n");
-	printf("\t-V|--version            print the mkfs.btrfs version and exit\n");
-	printf("\t--help                  print this help and exit\n");
+	printf("\t-q|--quiet                 no messages except errors\n");
+	printf("\t-V|--version               print the mkfs.btrfs version and exit\n");
+	printf("\t--help                     print this help and exit\n");
 	printf("  deprecated:\n");
-	printf("\t-A|--alloc-start START  the offset to start the filesystem\n");
-	printf("\t-l|--leafsize SIZE      deprecated, alias for nodesize\n");
+	printf("\t-A|--alloc-start START     the offset to start the filesystem\n");
+	printf("\t-l|--leafsize SIZE         deprecated, alias for nodesize\n");
 	exit(ret);
 }
 
@@ -1560,6 +1561,7 @@ int main(int argc, char **argv)
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 runtime_features = 0;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
 
@@ -1580,13 +1582,14 @@ int main(int argc, char **argv)
 			{ "rootdir", required_argument, NULL, 'r' },
 			{ "nodiscard", no_argument, NULL, 'K' },
 			{ "features", required_argument, NULL, 'O' },
+			{ "runtime-features", required_argument, NULL, 'R' },
 			{ "uuid", required_argument, NULL, 'U' },
 			{ "quiet", 0, NULL, 'q' },
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP },
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:r:U:VMKq",
+		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:R:O:r:U:VMKq",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1636,6 +1639,25 @@ int main(int argc, char **argv)
 				}
 				break;
 				}
+			case 'R': {
+				char *orig = strdup(optarg);
+				char *tmp = orig;
+
+				tmp = btrfs_parse_runtime_features(tmp,
+						&runtime_features);
+				if (tmp) {
+					error("unrecognized runtime feature '%s'",
+					      tmp);
+					free(orig);
+					goto error;
+				}
+				free(orig);
+				if (runtime_features & BTRFS_FEATURE_LIST_ALL) {
+					btrfs_list_all_runtime_features(0);
+					goto success;
+				}
+				break;
+				}
 			case 's':
 				sectorsize = parse_size(optarg);
 				break;
@@ -2046,8 +2068,10 @@ raid_groups:
 			pretty_size(allocation.system));
 		printf("SSD detected:       %s\n", ssd ? "yes" : "no");
 		btrfs_parse_fs_features_to_string(features_buf, features);
-		printf("Incompat features:  %s", features_buf);
-		printf("\n");
+		printf("Incompat features:  %s\n", features_buf);
+		btrfs_parse_runtime_features_to_string(features_buf,
+				runtime_features);
+		printf("Runtime features:   %s\n", features_buf);
 
 		list_all_devices(root);
 	}
-- 
2.15.0

