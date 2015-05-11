Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11526 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752208AbbEKIJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87hB6028775
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/13] btrfs-progs: Introduce change_devices_uuid() function.
Date: Mon, 11 May 2015 16:08:50 +0800
Message-ID: <1431331734-11714-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function will change all dev items' fsid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Move to props.c
---
 props.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/props.c b/props.c
index 6cd9b4d..59e09b3 100644
--- a/props.c
+++ b/props.c
@@ -308,6 +308,49 @@ static int change_device_uuid(struct btrfs_root *root, struct extent_buffer *eb,
 	return ret;
 }
 
+static int change_devices_uuid(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->chunk_root;
+	struct btrfs_path *path;
+	struct btrfs_key key = {0, 0, 0};
+	int ret = 0;
+
+	/*
+	 * Unlike change_extents_uuid, we only need to change fsid in dev_item
+	 */
+	if (!fs_info->new_fsid)
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	/* No transaction again */
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.type != BTRFS_DEV_ITEM_KEY ||
+		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
+			goto next;
+		ret = change_device_uuid(root, path->nodes[0], path->slots[0]);
+		if (ret < 0)
+			goto out;
+next:
+		ret = btrfs_next_item(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
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

