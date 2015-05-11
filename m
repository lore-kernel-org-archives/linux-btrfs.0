Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264AbbEKIJC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:02 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87bEe028750
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 04/13] btrfs-progs: Add open_ctree check for uuid changing.
Date: Mon, 11 May 2015 16:08:45 +0800
Message-ID: <1431331734-11714-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now open_ctree will exit if it found the superblock is marked
CHANGING_FSID/CHUNK_TREE_UUID, except given IGNORE_FSID/CHUNK_TREE_ID
open ctree flags.

Kernel will do the same thing later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Abort open_ctree if uuid change is not done.
---
 ctree.h   |  2 ++
 disk-io.c | 19 ++++++++++++++++++-
 disk-io.h |  3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 8dc70a5..1608645 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1012,6 +1012,8 @@ struct btrfs_fs_info {
 	unsigned int is_chunk_recover:1;
 	unsigned int quota_enabled:1;
 	unsigned int suppress_check_block_errors:1;
+	unsigned int ignore_fsid:1;
+	unsigned int ignore_chunk_tree_id:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/disk-io.c b/disk-io.c
index c1cf146..0edebfa 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -49,7 +49,8 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
-		if (!memcmp_extent_buffer(buf, fs_devices->fsid,
+		if (root->fs_info->ignore_fsid ||
+		    !memcmp_extent_buffer(buf, fs_devices->fsid,
 					  btrfs_header_fsid(),
 					  BTRFS_FSID_SIZE)) {
 			ret = 0;
@@ -1149,6 +1150,10 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->on_restoring = 1;
 	if (flags & OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS)
 		fs_info->suppress_check_block_errors = 1;
+	if (flags & OPEN_CTREE_IGNORE_FSID)
+		fs_info->ignore_fsid = 1;
+	if (flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ID)
+		fs_info->ignore_chunk_tree_id = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER),
@@ -1180,6 +1185,18 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		goto out_devices;
 	}
 
+	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_CHANGING_FSID &&
+	    !fs_info->ignore_fsid) {
+		fprintf(stderr, "Under uuid changing, fsid inconsistent\n");
+		goto out_devices;
+	}
+	if (btrfs_super_flags(disk_super) &
+			BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID &&
+	    !fs_info->ignore_chunk_tree_id) {
+		fprintf(stderr, "Under uuid changing, chunk tree uuid inconsistent\n");
+		goto out_devices;
+	}
+
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
 	ret = btrfs_check_fs_compatibility(fs_info->super_copy,
diff --git a/disk-io.h b/disk-io.h
index 4caebeb..e1c2030 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -49,6 +49,9 @@ enum btrfs_open_ctree_flags {
 	 * tree bits.
 	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
 	 */
+
+	OPEN_CTREE_IGNORE_FSID		= (1 << 10),
+	OPEN_CTREE_IGNORE_CHUNK_TREE_ID	= (1 << 11)
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.4.0

