Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaCFF4D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:56:03 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265tv8Z010090
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:56:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] Btrfs-progs: fsck: handle case that we can not lookup extent info
Date: Thu, 6 Mar 2014 13:54:00 +0800
Message-Id: <1394085240-23520-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, --init-extent-tree works just because btrfs_lookup_extent_info()
blindly return 0, and this make it work if there are not any *FULL BACKREF*
mode in broken filesystem.

It is just a coincidence that --init-extent-tree option works, let's
do it in the right way firstly.

For now, we have not supported to rebuild extent tree if there are
any *FULL BACKREF* mode which means if there are snapshots with broken
filesystem, avoid using --init-extent-tree option now.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c  | 36 ++++++++++++++++++++++++++----------
 extent-tree.c |  2 +-
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ae611d1..d1cafe1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -52,6 +52,7 @@ static LIST_HEAD(duplicate_extents);
 static LIST_HEAD(delete_items);
 static int repair = 0;
 static int no_holes = 0;
+static int init_extent_tree = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -3915,11 +3916,19 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 
 	nritems = btrfs_header_nritems(buf);
 
-	ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+	/*
+	 * FIXME, this only works only if we don't have any full
+	 * backref mode.
+	 */
+	if (!init_extent_tree) {
+		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
 				       btrfs_header_level(buf), 1, NULL,
 				       &flags);
-	if (ret < 0)
-		flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
+		if (ret < 0)
+			flags = 0;
+	} else {
+		flags = 0;
+	}
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 		parent = bytenr;
@@ -5102,12 +5111,20 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 	int allocated = 0;
 	u64 flags = 0;
 
-	/* remember our flags for recreating the extent */
-	ret = btrfs_lookup_extent_info(NULL, info->extent_root, rec->start,
-				       rec->max_size, rec->metadata, NULL,
-				       &flags);
-	if (ret < 0)
-		flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	/*
+	 * remember our flags for recreating the extent.
+	 * FIXME, if we have cleared extent tree, we can not
+	 * lookup extent info in extent tree.
+	 */
+	if (!init_extent_tree) {
+		ret = btrfs_lookup_extent_info(NULL, info->extent_root,
+					rec->start, rec->max_size,
+					rec->metadata, NULL, &flags);
+		if (ret < 0)
+			flags = 0;
+	} else {
+		flags = 0;
+	}
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -6438,7 +6455,6 @@ int cmd_check(int argc, char **argv)
 	u64 num;
 	int option_index = 0;
 	int init_csum_tree = 0;
-	int init_extent_tree = 0;
 	enum btrfs_open_ctree_flags ctree_flags =
 		OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
 
diff --git a/extent-tree.c b/extent-tree.c
index 7860d1d..7979457 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1560,7 +1560,7 @@ again:
 		*flags = extent_flags;
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
-- 
1.9.0

