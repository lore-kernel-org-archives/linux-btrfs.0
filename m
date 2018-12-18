Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC178C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A586D217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbeLRKrR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:47:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:38706 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeLRKrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:47:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1635FB004;
        Tue, 18 Dec 2018 10:47:15 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 10/13] btrfs-progs: check: fix wrong @offset used in find_possible_backrefs()
Date:   Tue, 18 Dec 2018 18:46:43 +0800
Message-Id: <20181218104646.29599-11-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181218104646.29599-1-wqu@suse.com>
References: <20181218104646.29599-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Function find_possible_backrefs() is used to locate the file extents
referring to an data extent.

For data extent backref, its btrfs_extent_data_ref structure has
the following members:
- root
  Which root refers to this data extent

- objectid
  Which inode refers to this data extent

- offset
  Search *hint*.
  Its value is @file_offset - @extent_offset.

While for @file_offset, it's directly recorded in (INO EXTENT_DATA
FILE_OFFSET) key.

So when searching the file extents refers to this data extent, we can't
use btrfs_extent_data_ref::offset as search key::offset.

We must search from file offset 0, and iterate all file extents until we
hit a file extent matches the data backref.

Thankfully such time consuming behavior is not triggered frequently,
it only gets called for repair, so it shouldn't affect normal check
routine.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
[Update commit message]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 110 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 92 insertions(+), 18 deletions(-)

diff --git a/check/main.c b/check/main.c
index dcee3f54aac7..2ae1eeb9bec8 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7131,6 +7131,89 @@ out:
 	return ret ? ret : nr_del;
 }
 
+/*
+ * Based extent backref item, we find all file extent items in the fs tree. By
+ * the info we can rebuild the extent backref item
+ */
+static int __find_possible_backrefs(struct btrfs_root *root,
+		u64 owner, u64 offset, u64 bytenr, u64 *refs_ret,
+		u64 *bytes_ret)
+{
+	int ret = 0;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	u64 backref_offset, disk_bytenr;
+	int slot;
+
+	btrfs_init_path(&path);
+
+	key.objectid = owner;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret) {
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	btrfs_release_path(&path);
+
+	key.objectid = owner;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	while (1) {
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret) {
+				if (ret > 0)
+					ret = 0;
+				break;
+			}
+
+			leaf = path.nodes[0];
+			slot = path.slots[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if ((found_key.objectid != owner) ||
+			(found_key.type != BTRFS_EXTENT_DATA_KEY))
+			break;
+
+		fi = btrfs_item_ptr(leaf, slot,
+				struct btrfs_file_extent_item);
+
+		backref_offset = found_key.offset -
+			btrfs_file_extent_offset(leaf, fi);
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		*bytes_ret = btrfs_file_extent_disk_num_bytes(leaf,
+								fi);
+		if ((disk_bytenr == bytenr) &&
+			(backref_offset == offset)) {
+			(*refs_ret)++;
+		}
+		path.slots[0]++;
+	}
+
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int find_possible_backrefs(struct btrfs_fs_info *info,
 				  struct btrfs_path *path,
 				  struct cache_tree *extent_cache,
@@ -7140,9 +7223,9 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 	struct extent_backref *back, *tmp;
 	struct data_backref *dback;
 	struct cache_extent *cache;
-	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	u64 bytenr, bytes;
+	u64 refs;
 	int ret;
 
 	rbtree_postorder_for_each_entry_safe(back, tmp,
@@ -7170,24 +7253,15 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 		if (IS_ERR(root))
 			return PTR_ERR(root);
 
-		key.objectid = dback->owner;
-		key.type = BTRFS_EXTENT_DATA_KEY;
-		key.offset = dback->offset;
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (ret) {
-			btrfs_release_path(path);
-			if (ret < 0)
-				return ret;
-			/* Didn't find it, we can carry on */
-			ret = 0;
+		refs = 0;
+		bytes = 0;
+		ret = __find_possible_backrefs(root, dback->owner,
+				dback->offset, rec->start, &refs, &bytes);
+		if (ret)
 			continue;
-		}
 
-		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				    struct btrfs_file_extent_item);
-		bytenr = btrfs_file_extent_disk_bytenr(path->nodes[0], fi);
-		bytes = btrfs_file_extent_disk_num_bytes(path->nodes[0], fi);
-		btrfs_release_path(path);
+		bytenr = rec->start;
+
 		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (cache) {
 			struct extent_record *tmp;
@@ -7206,7 +7280,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 				continue;
 		}
 
-		dback->found_ref += 1;
+		dback->found_ref += refs;
 		dback->disk_bytenr = bytenr;
 		dback->bytes = bytes;
 
-- 
2.20.0

