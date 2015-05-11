Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199AbbEKIJF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87gKH028771
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 08/13] btrfs-progs: Introduce change_device_uuid() function.
Date: Mon, 11 May 2015 16:08:49 +0800
Message-ID: <1431331734-11714-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function just change a device item's uuid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Move to props.c
---
 props.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/props.c b/props.c
index 33fc39b..6cd9b4d 100644
--- a/props.c
+++ b/props.c
@@ -287,6 +287,27 @@ out:
 	return ret;
 }
 
+static int change_device_uuid(struct btrfs_root *root, struct extent_buffer *eb,
+			      int slot)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dev_item *di;
+	int ret = 0;
+
+	di = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
+	if (fs_info->new_fsid) {
+		if (!memcmp_extent_buffer(eb, fs_info->new_fsid,
+					  (unsigned long)btrfs_device_fsid(di),
+					  BTRFS_FSID_SIZE))
+			return ret;
+		write_extent_buffer(eb, fs_info->new_fsid,
+				    (unsigned long)btrfs_device_fsid(di),
+				    BTRFS_FSID_SIZE);
+		ret = write_tree_block(NULL, root, eb);
+	}
+	return ret;
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
-- 
2.4.0

