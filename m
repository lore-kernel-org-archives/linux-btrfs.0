Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59303 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3C1Rnk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 13:43:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EA0399A067C
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 11:43:39 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 6EIAzeW82uwQ4U5e (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 11:43:39 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add csum tree checks to btrfsck
Date: Thu, 28 Mar 2013 13:51:03 -0400
Message-ID: <1364493063-18741-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking at a recent user problem I noticed there are weird cases we could
possibly be leaving csums in place for an extent we've free'd.  I don't think
this can happen unless the extent tree is also corrupt, but just in case I'm
adding sanity checks to btrfsck.  This way we will catch this if it happens
normally since xfstests runs btrfsck between each run.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 187 insertions(+), 0 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index eef959e..b681f5d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2605,6 +2605,188 @@ out:
 	return 0;
 }
 
+static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
+			       u64 num_bytes)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		fprintf(stderr, "Error allocing path\n");
+		return -ENOMEM;
+	}
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = 0;
+
+again:
+	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
+				0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error looking up extent record %d\n", ret);
+		btrfs_free_path(path);
+		return ret;
+	} else if (ret && path->slots[0]) {
+		path->slots[0]--;
+	}
+
+	while (num_bytes) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error going to next leaf "
+					"%d\n", ret);
+				btrfs_free_path(path);
+				return ret;
+			} else if (ret) {
+				break;
+			}
+		}
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type != BTRFS_EXTENT_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+		if (key.objectid + key.offset < bytenr) {
+			path->slots[0]++;
+			continue;
+		}
+		if (key.objectid > bytenr + num_bytes)
+			break;
+
+		if (key.objectid == bytenr) {
+			if (key.offset >= num_bytes) {
+				num_bytes = 0;
+				break;
+			}
+			num_bytes -= key.offset;
+			bytenr += key.offset;
+		} else if (key.objectid < bytenr) {
+			if (key.objectid + key.offset >= bytenr + num_bytes) {
+				num_bytes = 0;
+				break;
+			}
+			num_bytes = (bytenr + num_bytes) -
+				(key.objectid + key.offset);
+			bytenr = key.objectid + key.offset;
+		} else {
+			if (key.objectid + key.offset < bytenr + num_bytes) {
+				u64 new_start = key.objectid + key.offset;
+				u64 new_bytes = bytenr + num_bytes - new_start;
+
+				/*
+				 * Weird case, the extent is in the middle of
+				 * our range, we'll have to search one side
+				 * and then the other.  Not sure if this happens
+				 * in real life, but no harm in coding it up
+				 * anyway just in case.
+				 */
+				btrfs_release_path(root, path);
+				ret = check_extent_exists(root, new_start,
+							  new_bytes);
+				if (ret) {
+					fprintf(stderr, "Right section didn't "
+						"have a record\n");
+					break;
+				}
+				num_bytes = key.objectid - bytenr;
+				goto again;
+			}
+			num_bytes = key.objectid - bytenr;
+		}
+		path->slots[0]++;
+	}
+	ret = 0;
+
+	if (num_bytes) {
+		fprintf(stderr, "There are no extents for csum range "
+			"%Lu-%Lu\n", bytenr, bytenr+num_bytes);
+		ret = 1;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int check_csums(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 offset = 0, num_bytes = 0;
+	u16 csum_size =
+		btrfs_super_csum_size(&root->fs_info->super_copy);
+	int errors = 0;
+	int ret;
+
+	root = root->fs_info->csum_root;
+
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+	key.offset = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching csum tree %d\n", ret);
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	if (ret > 0 && path->slots[0])
+		path->slots[0]--;
+	ret = 0;
+
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error going to next leaf "
+					"%d\n", ret);
+				break;
+			}
+			if (ret)
+				break;
+		}
+		leaf = path->nodes[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type != BTRFS_EXTENT_CSUM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		if (!num_bytes) {
+			offset = key.offset;
+		} else if (key.offset != offset + num_bytes) {
+			ret = check_extent_exists(root, offset, num_bytes);
+			if (ret) {
+				fprintf(stderr, "Csum exists for %Lu-%Lu but "
+					"there is no extent record\n",
+					offset, offset+num_bytes);
+				errors++;
+			}
+			offset = key.offset;
+			num_bytes = 0;
+		}
+
+		num_bytes += (btrfs_item_size_nr(leaf, path->slots[0]) /
+			      csum_size) * root->sectorsize;
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+	return errors;
+}
+
 static int run_next_block(struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
@@ -3685,6 +3867,11 @@ int cmd_check(int argc, char **argv)
 	if (ret)
 		goto out;
 
+	fprintf(stderr, "checking csums\n");
+	ret = check_csums(root);
+	if (ret)
+		goto out;
+
 	fprintf(stderr, "checking root refs\n");
 	ret = check_root_refs(root, &root_cache);
 out:
-- 
1.7.7.6

