Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60408 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777AbaEHBaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 21:30:23 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s481UKgk017792
	for <linux-btrfs@vger.kernel.org>; Thu, 8 May 2014 09:30:20 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fsck: add an option to check data csums
Date: Thu, 8 May 2014 09:26:49 +0800
Message-ID: <1399512409-661-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an option '--check-data-csum' to verify data csums.
fsck won't check data csums unless users specify this option explictly.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-check.txt |   2 +
 cmds-check.c                  | 122 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 485a49c..bc10755 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -30,6 +30,8 @@ try to repair the filesystem.
 create a new CRC tree.
 --init-extent-tree::
 create a new extent tree.
+--check-data-csum::
+check data csums.
 
 EXIT STATUS
 -----------
diff --git a/cmds-check.c b/cmds-check.c
index 103efc5..b53d49c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -53,6 +53,7 @@ static LIST_HEAD(delete_items);
 static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
+static int check_data_csum = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -3634,6 +3635,106 @@ static int check_space_cache(struct btrfs_root *root)
 	return error ? -EINVAL : 0;
 }
 
+static int read_extent_data(struct btrfs_root *root, char *data,
+			u64 logical, u64 len, int mirror)
+{
+	u64 offset = 0;
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_device *device;
+	int ret = 0;
+	u64 read_len;
+	unsigned long bytes_left = len;
+
+	while (bytes_left) {
+		read_len = bytes_left;
+		device = NULL;
+		ret = btrfs_map_block(&info->mapping_tree, READ,
+				logical + offset, &read_len, &multi,
+				mirror, NULL);
+		if (ret) {
+			fprintf(stderr, "Couldn't map the block %llu\n",
+					logical + offset);
+			goto error;
+		}
+		device = multi->stripes[0].dev;
+
+		if (device->fd == 0)
+			goto error;
+
+		if (read_len > root->sectorsize)
+			read_len = root->sectorsize;
+		if (read_len > bytes_left)
+			read_len = bytes_left;
+
+		ret = pread64(device->fd, data + offset, read_len,
+			      multi->stripes[0].physical);
+		if (ret != read_len)
+			goto error;
+		offset += read_len;
+		bytes_left -= read_len;
+		kfree(multi);
+		multi = NULL;
+	}
+	return 0;
+error:
+	kfree(multi);
+	return -EIO;
+}
+
+static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
+			u64 num_bytes, unsigned long leaf_offset,
+			struct extent_buffer *eb) {
+
+	u64 offset = 0;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	char *data;
+	u32 crc;
+	unsigned long tmp;
+	char result[csum_size];
+	char out[csum_size];
+	int ret = 0;
+	__s64 cmp;
+	int mirror;
+	int num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+				bytenr, num_bytes);
+
+	BUG_ON(num_bytes % root->sectorsize);
+	data = malloc(root->sectorsize);
+	if (!data)
+		return -ENOMEM;
+
+	while (offset < num_bytes) {
+		mirror = 0;
+again:
+		ret = read_extent_data(root, data, bytenr + offset,
+				root->sectorsize, mirror);
+		if (ret)
+			goto out;
+
+		crc = ~(u32)0;
+		crc = btrfs_csum_data(NULL, (char *)data, crc,
+				      root->sectorsize);
+		btrfs_csum_final(crc, result);
+
+		tmp = leaf_offset + offset / root->sectorsize * csum_size;
+		read_extent_buffer(eb, out, tmp, csum_size);
+		cmp = memcmp(out, result, csum_size);
+		if (cmp) {
+			fprintf(stderr, "mirror: %d range bytenr: %llu, len: %d checksum mismatch\n",
+				mirror, bytenr + offset, root->sectorsize);
+			if (mirror < num_copies - 1) {
+				mirror += 1;
+				goto again;
+			}
+		}
+		offset += root->sectorsize;
+	}
+out:
+	free(data);
+	return ret;
+}
+
 static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 			       u64 num_bytes)
 {
@@ -3771,6 +3872,8 @@ static int check_csums(struct btrfs_root *root)
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int errors = 0;
 	int ret;
+	u64 data_len;
+	unsigned long leaf_offset;
 
 	root = root->fs_info->csum_root;
 
@@ -3812,6 +3915,16 @@ static int check_csums(struct btrfs_root *root)
 			continue;
 		}
 
+		data_len = (btrfs_item_size_nr(leaf, path->slots[0]) /
+			      csum_size) * root->sectorsize;
+		if (!check_data_csum)
+			goto skip_csum_check;
+		leaf_offset = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		ret = check_extent_csums(root, key.offset, data_len,
+					 leaf_offset, leaf);
+		if (ret)
+			break;
+skip_csum_check:
 		if (!num_bytes) {
 			offset = key.offset;
 		} else if (key.offset != offset + num_bytes) {
@@ -3825,9 +3938,7 @@ static int check_csums(struct btrfs_root *root)
 			offset = key.offset;
 			num_bytes = 0;
 		}
-
-		num_bytes += (btrfs_item_size_nr(leaf, path->slots[0]) /
-			      csum_size) * root->sectorsize;
+		num_bytes += data_len;
 		path->slots[0]++;
 	}
 
@@ -6665,6 +6776,7 @@ static struct option long_options[] = {
 	{ "repair", 0, NULL, 0 },
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
+	{ "check-data-csum", 0, NULL, 0 },
 	{ "backup", 0, NULL, 0 },
 	{ NULL, 0, NULL, 0}
 };
@@ -6678,6 +6790,7 @@ const char * const cmd_check_usage[] = {
 	"--repair                    try to repair the filesystem",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
+	"--check-data-csum           check data csums",
 	NULL
 };
 
@@ -6736,8 +6849,9 @@ int cmd_check(int argc, char **argv)
 			ctree_flags |= (OPEN_CTREE_WRITES |
 					OPEN_CTREE_NO_BLOCK_GROUPS);
 			repair = 1;
+		} else if (option_index == 4) {
+			check_data_csum = 1;
 		}
-
 	}
 	argc = argc - optind;
 
-- 
1.9.0

