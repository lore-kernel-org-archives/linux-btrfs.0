Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbaE1L0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 07:26:20 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SBQH0v029495
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 19:26:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs-progs: fsck: add an option to check data csums
Date: Wed, 28 May 2014 19:22:40 +0800
Message-ID: <1401276160-18562-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds an option '--check-data-csum' to verify data checksums.
fsck won't check data csums unless users specify this option explictly.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
       addressed comments from david.
       read as much as data once a time.
---
 Documentation/btrfs-check.txt |   2 +
 cmds-check.c                  | 125 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 485a49c..4623659 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -30,6 +30,8 @@ try to repair the filesystem.
 create a new CRC tree.
 --init-extent-tree::
 create a new extent tree.
+--check-data-csum::
+verify checkums of data blocks.
 
 EXIT STATUS
 -----------
diff --git a/cmds-check.c b/cmds-check.c
index 55e7753..058956e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -54,6 +54,7 @@ static LIST_HEAD(delete_items);
 static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
+static int check_data_csum = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -3733,6 +3734,109 @@ static int check_space_cache(struct btrfs_root *root)
 	return error ? -EINVAL : 0;
 }
 
+static int read_extent_data(struct btrfs_root *root, char *data,
+			u64 logical, u64 *len, int mirror)
+{
+	u64 offset = 0;
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_device *device;
+	int ret = 0;
+	u64 max_len = *len;
+
+	ret = btrfs_map_block(&info->mapping_tree, READ, logical, len,
+			      &multi, mirror, NULL);
+	if (ret) {
+		fprintf(stderr, "Couldn't map the block %llu\n",
+				logical + offset);
+		goto err;
+	}
+	device = multi->stripes[0].dev;
+
+	if (device->fd == 0)
+		goto err;
+	if (*len > max_len)
+		*len = max_len;
+
+	ret = pread64(device->fd, data, *len, multi->stripes[0].physical);
+	if (ret != *len)
+		ret = -EIO;
+	else
+		ret = 0;
+err:
+	kfree(multi);
+	return ret;
+}
+
+static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
+			u64 num_bytes, unsigned long leaf_offset,
+			struct extent_buffer *eb) {
+
+	u64 offset = 0;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	char *data;
+	unsigned long csum_offset;
+	u32 csum;
+	u32 csum_expected;
+	u64 read_len;
+	u64 data_checked = 0;
+	u64 tmp;
+	int ret = 0;
+	int mirror;
+	int num_copies;
+
+	if (num_bytes % root->sectorsize)
+		return -EINVAL;
+
+	data = malloc(num_bytes);
+	if (!data)
+		return -ENOMEM;
+
+	while (offset < num_bytes) {
+		mirror = 0;
+again:
+		read_len = num_bytes - offset;
+		/* read as much space once a time */
+		ret = read_extent_data(root, data + offset,
+				bytenr + offset, &read_len, mirror);
+		if (ret)
+			goto out;
+		data_checked = 0;
+		/* verify every 4k data's checksum */
+		while (data_checked < read_len) {
+			csum = ~(u32)0;
+			tmp = offset + data_checked;
+
+			csum = btrfs_csum_data(NULL, (char *)data + tmp,
+					       csum, root->sectorsize);
+			btrfs_csum_final(csum, (char *)&csum);
+
+			csum_offset = leaf_offset +
+				 tmp / root->sectorsize * csum_size;
+			read_extent_buffer(eb, (char *)&csum_expected,
+					   csum_offset, csum_size);
+			/* try another mirror */
+			if (csum != csum_expected) {
+				fprintf(stderr, "mirror %d bytenr %llu csum %u expected csum %u\n",
+						mirror, bytenr + tmp,
+						csum, csum_expected);
+				num_copies = btrfs_num_copies(
+						&root->fs_info->mapping_tree,
+						bytenr, num_bytes);
+				if (mirror < num_copies - 1) {
+					mirror += 1;
+					goto again;
+				}
+			}
+			data_checked += root->sectorsize;
+		}
+		offset += read_len;
+	}
+out:
+	free(data);
+	return ret;
+}
+
 static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 			       u64 num_bytes)
 {
@@ -3886,6 +3990,8 @@ static int check_csums(struct btrfs_root *root)
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int errors = 0;
 	int ret;
+	u64 data_len;
+	unsigned long leaf_offset;
 
 	root = root->fs_info->csum_root;
 
@@ -3927,6 +4033,16 @@ static int check_csums(struct btrfs_root *root)
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
@@ -3940,9 +4056,7 @@ static int check_csums(struct btrfs_root *root)
 			offset = key.offset;
 			num_bytes = 0;
 		}
-
-		num_bytes += (btrfs_item_size_nr(leaf, path->slots[0]) /
-			      csum_size) * root->sectorsize;
+		num_bytes += data_len;
 		path->slots[0]++;
 	}
 
@@ -6780,6 +6894,7 @@ static struct option long_options[] = {
 	{ "repair", 0, NULL, 0 },
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
+	{ "check-data-csum", 0, NULL, 0 },
 	{ "backup", 0, NULL, 0 },
 	{ "qgroup-report", 0, NULL, 'Q' },
 	{ NULL, 0, NULL, 0}
@@ -6794,6 +6909,7 @@ const char * const cmd_check_usage[] = {
 	"--repair                    try to repair the filesystem",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
+	"--check-data-csum           verify checkums of data blocks",
 	"--qgroup-report             print a report on qgroup consistency",
 	NULL
 };
@@ -6856,8 +6972,9 @@ int cmd_check(int argc, char **argv)
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

