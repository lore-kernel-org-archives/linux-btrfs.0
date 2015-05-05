Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbbEEGSx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HXDV008350
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/8] btrfs-progs: Introduce change_header_uuid() function.
Date: Tue, 5 May 2015 14:16:41 +0800
Message-ID: <1430806606-3226-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used to change fsid/chunk_tree_uuid of a node/leaf.
The function does it without transaction protect.

This is the basis of offline uuid change.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 31 +++++++++++++++++++++++++++++++
 ctree.h     |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 808466f..f039d84 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -98,6 +98,37 @@ static int enable_skinny_metadata(struct btrfs_root *root)
 	return 0;
 }
 
+static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int same_fsid = 1;
+	int same_chunk_tree_uuid = 1;
+	int ret = 0;
+
+	/* Check for whether we need to change fs/chunk id */
+	if (!fs_info->new_fsid && !fs_info->new_chunk_tree_uuid)
+		return 0;
+	if (fs_info->new_fsid)
+		same_fsid = !memcmp_extent_buffer(eb, fs_info->new_fsid,
+					  btrfs_header_fsid(), BTRFS_FSID_SIZE);
+	if (fs_info->new_chunk_tree_uuid)
+		same_chunk_tree_uuid =
+			!memcmp_extent_buffer(eb, fs_info->new_chunk_tree_uuid,
+					      btrfs_header_chunk_tree_uuid(eb),
+					      BTRFS_UUID_SIZE);
+	if (same_fsid && same_chunk_tree_uuid)
+		return 0;
+	if (!same_fsid)
+		write_extent_buffer(eb, fs_info->new_fsid, btrfs_header_fsid(),
+				    BTRFS_FSID_SIZE);
+	if (!same_chunk_tree_uuid)
+		write_extent_buffer(eb, fs_info->new_chunk_tree_uuid,
+				    btrfs_header_chunk_tree_uuid(eb),
+				    BTRFS_UUID_SIZE);
+	ret = write_tree_block(NULL, root, eb);
+	return ret;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
diff --git a/ctree.h b/ctree.h
index 45fef3d..6f882aa 100644
--- a/ctree.h
+++ b/ctree.h
@@ -954,7 +954,9 @@ struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
+	u8 *new_fsid;
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+	u8 *new_chunk_tree_uuid;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *extent_root;
 	struct btrfs_root *tree_root;
-- 
2.3.7

