Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752615AbbEKIJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87ffg028764
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 07/13] btrfs-progs: Introduce change_extents_uuid() function.
Date: Mon, 11 May 2015 16:08:48 +0800
Message-ID: <1431331734-11714-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the function which iterates all metadata extent and change their
fsid.

This function also does it without transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Move to props.c
---
 props.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/props.c b/props.c
index abc3ae0..33fc39b 100644
--- a/props.c
+++ b/props.c
@@ -219,6 +219,74 @@ static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
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
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
-- 
2.4.0

