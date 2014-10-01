Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3665 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaJAOdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 10:33:49 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] Btrfs-progs: rebuild the crc tree with --init-csum-tree
Date: Wed, 1 Oct 2014 10:33:44 -0400
Message-ID: <1412174024-5156-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fusionio.com>

We have --init-csum-tree, which just empties the csum tree.  I'm not sure why we
would ever need this, but we definitely need to be able to rebuild the csum tree
in some cases.  This patch adds the ability to completely rebuild the crc tree
by reading all of the data and adding csum entries for them.  This patch doesn't
pay attention to NODATASUM inodes, it'll happily add csums for everything.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 03b0fbd..3141aa4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6625,6 +6625,98 @@ out:
 	return ret;
 }
 
+static int populate_csum(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *csum_root, char *buf, u64 start,
+			 u64 len)
+{
+	u64 offset = 0;
+	u64 sectorsize;
+	int ret = 0;
+
+	while (offset < len) {
+		sectorsize = csum_root->sectorsize;
+		ret = read_extent_data(csum_root, buf, start + offset,
+				       &sectorsize, 0);
+		if (ret)
+			break;
+		ret = btrfs_csum_file_block(trans, csum_root, start + len,
+					    start + offset, buf, sectorsize);
+		if (ret)
+			break;
+		offset += sectorsize;
+	}
+	return ret;
+}
+
+static int fill_csum_tree(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *csum_root)
+{
+	struct btrfs_root *extent_root = csum_root->fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_extent_item *ei;
+	struct extent_buffer *leaf;
+	char *buf;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
+	if (ret < 0) {
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	buf = malloc(csum_root->sectorsize);
+	if (!buf) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
+
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(extent_root, path);
+			if (ret < 0)
+				break;
+			if (ret) {
+				ret = 0;
+				break;
+			}
+		}
+		leaf = path->nodes[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type != BTRFS_EXTENT_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		ei = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_extent_item);
+		if (!(btrfs_extent_flags(leaf, ei) &
+		      BTRFS_EXTENT_FLAG_DATA)) {
+			path->slots[0]++;
+			continue;
+		}
+
+		ret = populate_csum(trans, csum_root, buf, key.objectid,
+				    key.offset);
+		if (ret)
+			break;
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+	free(buf);
+	return ret;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -6794,6 +6886,12 @@ int cmd_check(int argc, char **argv)
 				ret = -EIO;
 				goto close_out;
 			}
+
+			ret = fill_csum_tree(trans, info->csum_root);
+			if (ret) {
+				fprintf(stderr, "crc refilling failed\n");
+				return -EIO;
+			}
 		}
 		/*
 		 * Ok now we commit and run the normal fsck, which will add
-- 
1.8.3.1

