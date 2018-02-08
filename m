Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29055 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbeBHDXK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:10 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C267748AE765
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:06 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 07/18] btrfs-progs: lowmem check: introduce avoid_extents_overwrite()
Date: Thu, 8 Feb 2018 11:27:26 +0800
Message-ID: <20180208032737.31561-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another global u64 last_allocated_chunk records the last chunk start
allocated by lowmem repair.
Although global variable is not so graceful, it simplifies codes much.

avoid_extents_overwrite() prefer to allocates new chunk first.
If it failed because of no space or wrong used bytes(fsck-tests/004),
then it try to exclude metadata blocks but costs lots of time in
large filesystem.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3649d570e11c..ea4019c32a3f 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -28,6 +28,8 @@
 #include "check/mode-common.h"
 #include "check/mode-lowmem.h"
 
+static u64 last_allocated_chunk;
+
 static int calc_extent_flag(struct btrfs_root *root, struct extent_buffer *eb,
 			    u64 *flags_ret)
 {
@@ -491,6 +493,50 @@ static int try_to_force_cow_in_new_chunk(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+	int mixed = btrfs_fs_incompat(fs_info, MIXED_GROUPS);
+
+	if (fs_info->excluded_extents)
+		return 0;
+
+	if (last_allocated_chunk != (u64)-1) {
+		ret = try_to_force_cow_in_new_chunk(fs_info,
+			last_allocated_chunk, &last_allocated_chunk);
+		if (!ret)
+			goto out;
+		/*
+		 * If failed, do not try to allocate chunk again in
+		 * next call.
+		 * If there is no space left to allocate, try to exclude all
+		 * metadata blocks. Mixed filesystem is unsupported.
+		 */
+		last_allocated_chunk = (u64)-1;
+		if (ret != -ENOSPC || mixed)
+			goto out;
+	}
+
+	printf(
+	"Try to exclude all metadata blcoks and extents, it may be slow\n");
+	ret = exclude_metadata_blocks(fs_info);
+out:
+	if (ret)
+		error("failed to avoid extents overwrite %s", strerror(-ret));
+	return ret;
+}
+
+static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
+{
+	int ret = 0;
+
+	cleanup_excluded_extents(fs_info);
+	if (last_allocated_chunk)
+		ret = clear_block_groups_full(fs_info,
+					BTRFS_BLOCK_GROUP_METADATA);
+	return ret;
+}
+
 /*
  * This function only handles BACKREF_MISSING,
  * If corresponding extent item exists, increase the ref, else insert an extent
-- 
2.16.1



