Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52325 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450AbbASGrV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:21 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kfbJ022566
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 03/10] btrfs-progs: Add new btrfs_open_ctree_flags CHUNK_ONLY.
Date: Mon, 19 Jan 2015 14:45:05 +0800
Message-ID: <1421649912-14539-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new flag CHUNK_ONLY and internal used only flag __RETURN_CHUNK.

CHUNK_ONLY will imply __RETURN_CHUNK, SUPPRESS_ERROR and PARTIAL, which
will allow the fs to be opened with only chunk tree OK.

This will improve the usability for btrfs-find-root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 6 +++++-
 disk-io.h | 9 +++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index f08f612..71ca31f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1167,7 +1167,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 			   BTRFS_UUID_SIZE);
 
 	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, flags);
-	if (ret)
+	if (ret && !(flags & __RETURN_CHUNK_ROOT))
 		goto out_chunk;
 
 	return fs_info;
@@ -1212,6 +1212,8 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 	info = open_ctree_fs_info(filename, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
+	if (flags & __RETURN_CHUNK_ROOT)
+		return info->chunk_root;
 	return info->fs_root;
 }
 
@@ -1222,6 +1224,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	info = __open_ctree_fd(fp, path, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
+	if (flags & __RETURN_CHUNK_ROOT)
+		return info->chunk_root;
 	return info->fs_root;
 }
 
diff --git a/disk-io.h b/disk-io.h
index 90ede6b..2d23cc3 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -34,6 +34,15 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
 	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
 	OPEN_CTREE_SUPPRESS_ERROR	= (1 << 7), /* Suppress csum error */
+	__RETURN_CHUNK_ROOT		= (1 << 8), /* Return chunk root */
+	OPEN_CTREE_CHUNK_ONLY		= OPEN_CTREE_PARTIAL +
+					  OPEN_CTREE_SUPPRESS_ERROR +
+					  __RETURN_CHUNK_ROOT,
+	/*
+	 * TODO: cleanup: Split the open_ctree_flags into more indepent
+	 * tree bits.
+	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
+	 */
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.2.2

