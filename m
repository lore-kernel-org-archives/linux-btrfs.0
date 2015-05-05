Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752624AbbEEGSv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HVSd008341
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/8] btrfs-progs: Allow open_ctree to ignore fsid mismatch.
Date: Tue, 5 May 2015 14:16:39 +0800
Message-ID: <1430806606-3226-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This feature is used for later UUID change function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h   | 1 +
 disk-io.c | 5 ++++-
 disk-io.h | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 10dc838..45fef3d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1010,6 +1010,7 @@ struct btrfs_fs_info {
 	unsigned int is_chunk_recover:1;
 	unsigned int quota_enabled:1;
 	unsigned int suppress_check_block_errors:1;
+	unsigned int ignore_fsid:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/disk-io.c b/disk-io.c
index c1cf146..8a91345 100644
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
@@ -1149,6 +1150,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->on_restoring = 1;
 	if (flags & OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS)
 		fs_info->suppress_check_block_errors = 1;
+	if (flags & OPEN_CTREE_IGNORE_FSID)
+		fs_info->ignore_fsid = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER),
diff --git a/disk-io.h b/disk-io.h
index 4caebeb..83cbe47 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -49,6 +49,9 @@ enum btrfs_open_ctree_flags {
 	 * tree bits.
 	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
 	 */
+
+	/* Currently, no codes check chunk_tree_uuid, so only ignore fsid */
+	OPEN_CTREE_IGNORE_FSID		= (1 << 10)
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.3.7

