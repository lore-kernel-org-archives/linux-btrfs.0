Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756057AbbEEGSx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HYAD008353
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/8] btrfs-progs: Introduce change_extents_uuid() function.
Date: Tue, 5 May 2015 14:16:42 +0800
Message-ID: <1430806606-3226-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the function which iterates all metadata extent and change their
fsid.

This function also does it without transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index f039d84..9c1b7aa 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -20,6 +20,7 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <uuid/uuid.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <dirent.h>
@@ -129,6 +130,74 @@ static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
 	return ret;
 }
 
+static int change_extents_uuid(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_key key = {0, 0, 0};
+	int ret = 0;
+
+	if (!fs_info->new_fsid && !fs_info->new_chunk_tree_uuid)
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * Here we don't use transaction as it will takes a lot of reserve
+	 * space, and that will make a near-full btrfs unable to change uuid
+	 */
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		struct btrfs_extent_item *ei;
+		struct extent_buffer *eb;
+		u64 flags;
+		u64 bytenr;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY)
+			goto next;
+		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_extent_item);
+		flags = btrfs_extent_flags(path->nodes[0], ei);
+		if (!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
+			goto next;
+
+		bytenr = key.objectid;
+		eb = read_tree_block(root, bytenr, root->nodesize, 0);
+		if (IS_ERR(eb)) {
+			fprintf(stderr, "Failed to read tree block: %llu\n",
+				bytenr);
+			ret = PTR_ERR(eb);
+			goto out;
+		}
+		ret = change_header_uuid(root, eb);
+		free_extent_buffer(eb);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to change uuid of tree block: %llu\n",
+				bytenr);
+			goto out;
+		}
+next:
+		ret = btrfs_next_item(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-- 
2.3.7

