Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756071AbbEEGSz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:55 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HaFr008364
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/8] btrfs-progs: Introduce change_devices_uuid() function.
Date: Tue, 5 May 2015 14:16:44 +0800
Message-ID: <1430806606-3226-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function will change all dev items' fsid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 6706cd7..8a5b3c2 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -219,6 +219,49 @@ static int change_device_uuid(struct btrfs_root *root, struct extent_buffer *eb,
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
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-- 
2.3.7

