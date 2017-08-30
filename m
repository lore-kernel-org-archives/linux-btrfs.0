Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:38816 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbdH3R2v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 13:28:51 -0400
Received: by mail-pg0-f46.google.com with SMTP id b8so21699612pgn.5
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 10:28:51 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyil <yingyil@google.com>
Subject: [PATCH 4/4 v2] btrfs-progs: mkfs: add subvolume support to mkfs
Date: Wed, 30 Aug 2017 10:24:50 -0700
Message-Id: <20170830172450.27460-5-yingyil@google.com>
In-Reply-To: <20170830172450.27460-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

Add -S/--subvol [NAME] option to configure. It enables users to create a
subvolume under the toplevel volume and populate the created subvolume
with files from the rootdir specified by -r/--rootdir option.

Signed-off-by: yingyil <yingyil@google.com>
---
v2: Fixed the bug for subvolume creation failure: calling create_tree(), instead
of create_subvol() in convert/main.c since btrfs_make_root_dir() in
create_subvol() is not needed to be called in mkfs.

 mkfs/main.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 869c11fa..21abc4a4 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -363,6 +363,7 @@ static void print_usage(int ret)
 	printf("\t-U|--uuid UUID          specify the filesystem UUID (must be unique)\n");
 	printf("  creation:\n");
 	printf("\t-b|--byte-count SIZE    set filesystem size to SIZE (on the first device)\n");
+	printf("\t-S|--subvol NAME        create a sunvolume with NAME and copy files from ROOTDIR to the subvolume\n");
 	printf("\t-r|--rootdir DIR        copy files from DIR to the image root directory\n");
 	printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
 	printf("\t-f|--force              force overwrite of existing filesystem\n");
@@ -412,6 +413,18 @@ static char *parse_label(const char *input)
 	return strdup(input);
 }
 
+static char *parse_subvol_name(const char *input)
+{
+	int len = strlen(input);
+
+	if (len >= BTRFS_SUBVOL_NAME_MAX) {
+		error("subvolume name %s is too long (max %d)",
+			input, BTRFS_SUBVOL_NAME_MAX - 1);
+		exit(1);
+	}
+	return strdup(input);
+}
+
 static int add_directory_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, u64 objectid,
 			       ino_t parent_inum, const char *name,
@@ -1418,6 +1431,8 @@ int main(int argc, char **argv)
 	int discard = 1;
 	int ssd = 0;
 	int force_overwrite = 0;
+	char *subvol_name = NULL;
+	int subvol_name_set = 0;
 	char *source_dir = NULL;
 	int source_dir_set = 0;
 	u64 num_of_meta_chunks = 0;
@@ -1444,6 +1459,7 @@ int main(int argc, char **argv)
 			{ "sectorsize", required_argument, NULL, 's' },
 			{ "data", required_argument, NULL, 'd' },
 			{ "version", no_argument, NULL, 'V' },
+			{ "subvol", required_argument, NULL, 'S'},
 			{ "rootdir", required_argument, NULL, 'r' },
 			{ "nodiscard", no_argument, NULL, 'K' },
 			{ "features", required_argument, NULL, 'O' },
@@ -1453,7 +1469,7 @@ int main(int argc, char **argv)
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:r:U:VMKq",
+		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:S:r:U:VMKq",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1514,6 +1530,10 @@ int main(int argc, char **argv)
 				printf("mkfs.btrfs, part of %s\n",
 						PACKAGE_STRING);
 				goto success;
+			case 'S':
+				subvol_name = parse_subvol_name(optarg);
+				subvol_name_set = 1;
+				break;
 			case 'r':
 				source_dir = optarg;
 				source_dir_set = 1;
@@ -1534,6 +1554,11 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (subvol_name_set && !source_dir_set) {
+		error("root directory needs to be set");
+		goto error;
+	}
+
 	if (verbose) {
 		printf("%s\n", PACKAGE_STRING);
 		printf("See %s for more information.\n\n", PACKAGE_URL);
@@ -1872,10 +1897,48 @@ raid_groups:
 			goto out;
 		}
 
-		ret = make_image(source_dir, root);
-		if (ret) {
-			error("error wihle filling filesystem: %d", ret);
-			goto out;
+		if (subvol_name_set) {
+			u64 dirid, objectid;
+			struct btrfs_root *file_root;
+
+			dirid = btrfs_root_dirid(&fs_info->tree_root->root_item);
+			ret = btrfs_find_free_objectid(NULL, fs_info->tree_root, dirid, &objectid);
+			if (ret) {
+				error("unable to find a free objectid: %d", ret);
+				goto out;
+			}
+			trans = btrfs_start_transaction(root, 1);
+			if (!trans) {
+				error("unable to start transaction");
+				ret = -EINVAL;
+				goto out;
+			}
+			ret = create_tree(trans, root, objectid);
+			if (ret < 0) {
+				error("failed to create subvolume: %d", ret);
+				goto out;
+			}
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret) {
+				error("unable to commit transaction: %d", ret);
+				goto out;
+			}
+			file_root = btrfs_link_subvol(root, subvol_name, objectid, 0);
+			if (!file_root) {
+				error("unable to link the subvolume %s", subvol_name);
+				goto out;
+			}
+			ret = make_image(source_dir, file_root);
+			if (ret) {
+				error("error while filling filesystem: %d", ret);
+				goto out;
+			}
+		} else {
+			ret = make_image(source_dir, root);
+			if (ret) {
+				error("error while filling filesystem: %d", ret);
+				goto out;
+			}
 		}
 	}
 	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
@@ -1938,6 +2001,7 @@ out:
 
 	btrfs_close_all_devices();
 	free(label);
+	free(subvol_name);
 
 	return !!ret;
 error:
@@ -1945,6 +2009,7 @@ error:
 		close(fd);
 
 	free(label);
+	free(subvol_name);
 	exit(1);
 success:
 	exit(0);
-- 
2.14.1.342.g6490525c54-goog

