Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24203 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932595AbdDQD0y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 8/9] btrfs-progs: modify: Introduce option to specify range by root,ino and offset
Date: Mon, 17 Apr 2017 11:26:41 +0800
Message-ID: <20170417032642.30770-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new option, --root-ino-offset, provides a better method to allow
test case scripts to corrupt specified range more easily.

Unlike the old method to call fiemap and then btrfs-map-logical, we can
use more easy-to-get values like rootid, ino, and in-file offset to
specify the destination.

Special note for special extents:
Compressed extent will be all modified if any of the extent get covered
by the destination.
Inline/prealloc/hole extent will be skipped.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 modify/mirror.c | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 187 insertions(+), 6 deletions(-)

diff --git a/modify/mirror.c b/modify/mirror.c
index f17dc9a7..c89927f6 100644
--- a/modify/mirror.c
+++ b/modify/mirror.c
@@ -199,9 +199,177 @@ static int modify_logical(struct btrfs_fs_info *fs_info, u64 logical, u64 len,
 	return 0;
 }
 
+struct root_ino_offset {
+	u64 root;
+	u64 ino;
+	u64 offset;
+	bool set;
+};
+
+static int modify_root_ino_offset(struct btrfs_fs_info *fs_info,
+				  struct root_ino_offset *dest,
+				  u64 length, int stripe)
+{
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	u64 cur = dest->offset;
+	int ret;
+
+	if (!is_fstree(dest->root)) {
+		error("rootid %llu is not a valid subvolume id", dest->root);
+		return -EINVAL;
+	}
+	if (!IS_ALIGNED(dest->offset, sectorsize)) {
+		error("offset %llu is not aligned to sectorsize %u",
+			dest->offset, sectorsize);
+		return -EINVAL;
+	}
+
+	key.objectid = dest->root;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		error("failed to read out root %llu: %s",
+			dest->root, strerror(-ret));
+		return ret;
+	}
+
+	btrfs_init_path(&path);
+	key.objectid = dest->ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = cur;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, &path, dest->ino,
+					  BTRFS_EXTENT_DATA_KEY);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			error("root %llu ino %llu offset %llu not found",
+				dest->root, dest->ino, dest->offset);
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+	while (cur < dest->offset + length) {
+		struct extent_buffer *leaf = path.nodes[0];
+		struct btrfs_file_extent_item *fi;
+		int slot = path.slots[0];
+		u64 corrupt_start;
+		u64 corrupt_len;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid != dest->ino ||
+		    key.type != BTRFS_EXTENT_DATA_KEY)
+			goto out;
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		/* Skip inline extent */
+		if (btrfs_file_extent_type(leaf, fi) ==
+				BTRFS_FILE_EXTENT_INLINE) {
+			cur = key.offset + sectorsize;
+			goto next;
+		}
+
+		/* Skip unrelated extent */
+		if (key.offset + btrfs_file_extent_num_bytes(leaf, fi) <=
+				dest->offset) {
+			cur = key.offset + btrfs_file_extent_num_bytes(leaf,
+					fi);
+			goto next;
+		}
+
+		/* Skip hole or prealloc extent */
+		if (btrfs_file_extent_disk_num_bytes(leaf, fi) == 0 ||
+		    btrfs_file_extent_type(leaf, fi) ==
+				BTRFS_FILE_EXTENT_PREALLOC) {
+			cur = key.offset + btrfs_file_extent_num_bytes(leaf,
+						fi);
+			goto next;
+		}
+
+		/* For compressed extent, corrupt all on-disk data */
+		if (btrfs_file_extent_compression(leaf, fi) !=
+			BTRFS_COMPRESS_NONE) {
+			ret = modify_logical(fs_info,
+				btrfs_file_extent_disk_bytenr(leaf, fi),
+				btrfs_file_extent_disk_num_bytes(leaf, fi),
+				stripe);
+			if (ret < 0)
+				goto out;
+			cur = key.offset +
+				btrfs_file_extent_num_bytes(leaf, fi);
+			goto next;
+		}
+
+		/* Regular plain extents, corrupt given range */
+		corrupt_start = btrfs_file_extent_disk_bytenr(leaf, fi) +
+			cur - key.offset + btrfs_file_extent_offset(leaf, fi);
+		corrupt_len = min(dest->offset + length, key.offset +
+				btrfs_file_extent_num_bytes(leaf, fi)) - cur;
+		ret = modify_logical(fs_info, corrupt_start, corrupt_len, stripe);
+		if (ret < 0)
+			goto out;
+		cur += corrupt_len;
+
+next:
+		ret = btrfs_next_item(root, &path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static void parse_root_ino_offset(struct root_ino_offset *dest, char *optarg)
+{
+	char *this_char;
+	char *save_ptr = NULL;
+	int i = 0;
+
+	for (this_char = strtok_r(optarg, ",", &save_ptr);
+	     this_char != NULL;
+	     this_char = strtok_r(NULL, ",", &save_ptr)) {
+		switch (i) {
+		case 0:
+			dest->root = arg_strtou64(this_char);
+			break;
+		case 1:
+			dest->ino = arg_strtou64(this_char);
+			break;
+		case 2:
+			dest->offset = arg_strtou64(this_char);
+			break;
+		default:
+			goto error;
+		}
+		i++;
+	}
+error:
+	if (i != 3) {
+		error("--root-ino-offset must be specified in number,number,number form");
+		exit(1);
+	}
+	dest->set = true;
+}
+
 int modify_mirror(int argc, char **argv)
 {
 	struct btrfs_fs_info *fs_info;
+	struct root_ino_offset dest = { 0 };
 	char *device;
 	u64 length = (u64)-1;
 	u64 logical = (u64)-1;
@@ -211,13 +379,16 @@ int modify_mirror(int argc, char **argv)
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_LOGICAL = 257, GETOPT_VAL_LENGTH,
-			GETOPT_VAL_STRIPE };
+			GETOPT_VAL_STRIPE, GETOPT_VAL_ROOT_INO_OFFSET };
 		static const struct option long_options[] = {
 			{ "logical", required_argument, NULL,
 				GETOPT_VAL_LOGICAL },
 			{ "length", required_argument, NULL,
 				GETOPT_VAL_LENGTH },
-			{ "stripe", required_argument, NULL, GETOPT_VAL_STRIPE }
+			{ "stripe", required_argument, NULL, GETOPT_VAL_STRIPE },
+			{ "root-ino-offset", required_argument, NULL,
+				GETOPT_VAL_ROOT_INO_OFFSET},
+			{ NULL, 0, NULL, 0 }
 		};
 
 		c = getopt_long(argc, argv, "", long_options, NULL);
@@ -233,6 +404,9 @@ int modify_mirror(int argc, char **argv)
 		case GETOPT_VAL_STRIPE:
 			stripe = strtostripe(optarg);
 			break;
+		case GETOPT_VAL_ROOT_INO_OFFSET:
+			parse_root_ino_offset(&dest, optarg);
+			break;
 		case '?':
 		case 'h':
 			usage(modify_mirror_usage);
@@ -252,9 +426,13 @@ int modify_mirror(int argc, char **argv)
 		error("%s is currently mounted, aborting", device);
 		return -EINVAL;
 	}
-	if (logical == (u64)-1) {
-		error("--logical must be specified");
-		return -EINVAL;
+	if (logical == (u64)-1 && !dest.set) {
+		error("--logical or --root-ino-offset must be specified");
+		return 1;
+	}
+	if (logical != (u64)-1 && dest.set) {
+		error("--logical conflicts with --root-ino-offset");
+		return 1;
 	}
 	if (stripe == STRIPE_UNINITILIZED) {
 		printf("--stripe not specified, fallback to 0 (1st stripe)\n");
@@ -271,7 +449,10 @@ int modify_mirror(int argc, char **argv)
 			fs_info->tree_root->sectorsize);
 		length = fs_info->tree_root->sectorsize;
 	}
-	ret = modify_logical(fs_info, logical, length, stripe);
+	if (logical != (u64)-1)
+		ret = modify_logical(fs_info, logical, length, stripe);
+	else
+		ret = modify_root_ino_offset(fs_info, &dest, length, stripe);
 	if (ret < 0)
 		error("failed to modify btrfs: %s", strerror(-ret));
 	else
-- 
2.12.2



