Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8090C67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7DC20665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F7DC20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbeJWR5Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:24 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18632 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728603AbeJWR5Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:24 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602842"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 15BBB4B6EDBE
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:42 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:48 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 10/13] btrfs-progs: check: fix bug in find_possible_backrefs
Date:   Tue, 23 Oct 2018 17:41:44 +0800
Message-ID: <20181023094147.7906-11-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 15BBB4B6EDBE.A25AD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

It may cost more time to search all extent data of correspond files but
should not influence total speed too much cause that only corrupted
extent items are participated in.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 check/main.c | 110 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 92 insertions(+), 18 deletions(-)

diff --git a/check/main.c b/check/main.c
index bd1f322e0f12..90d9fd570287 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7015,6 +7015,89 @@ out:
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
@@ -7024,9 +7107,9 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 	struct extent_backref *back, *tmp;
 	struct data_backref *dback;
 	struct cache_extent *cache;
-	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	u64 bytenr, bytes;
+	u64 refs;
 	int ret;
 
 	rbtree_postorder_for_each_entry_safe(back, tmp,
@@ -7054,24 +7137,15 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
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
@@ -7090,7 +7164,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 				continue;
 		}
 
-		dback->found_ref += 1;
+		dback->found_ref += refs;
 		dback->disk_bytenr = bytenr;
 		dback->bytes = bytes;
 
-- 
2.19.1



