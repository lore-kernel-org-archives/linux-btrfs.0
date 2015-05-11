Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11526 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbbEKIJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:03 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87ecH028760
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 06/13] btrfs-progs: Introduce change_header_uuid() function.
Date: Mon, 11 May 2015 16:08:47 +0800
Message-ID: <1431331734-11714-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used to change fsid/chunk_tree_uuid of a node/leaf.
The function does it without transaction protect.

This is the basis of offline uuid change.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Move to props.c
---
 ctree.h |  2 ++
 props.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/ctree.h b/ctree.h
index 1608645..0fc876a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -956,7 +956,9 @@ struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
+	u8 *new_fsid;
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+	u8 *new_chunk_tree_uuid;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *extent_root;
 	struct btrfs_root *tree_root;
diff --git a/props.c b/props.c
index c7c6752..abc3ae0 100644
--- a/props.c
+++ b/props.c
@@ -25,6 +25,7 @@
 #include "commands.h"
 #include "utils.h"
 #include "props.h"
+#include "disk-io.h"
 
 #define XATTR_BTRFS_PREFIX     "btrfs."
 #define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
@@ -187,6 +188,36 @@ out:
 	return ret;
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
 
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
-- 
2.4.0

