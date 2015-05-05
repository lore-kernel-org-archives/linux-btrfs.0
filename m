Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbbEEGSx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HZRP008357
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/8] btrfs-progs: Introduce function change_device_uuid().
Date: Tue, 5 May 2015 14:16:43 +0800
Message-ID: <1430806606-3226-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function just change a device item's uuid.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 9c1b7aa..6706cd7 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -198,6 +198,27 @@ out:
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
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-- 
2.3.7

