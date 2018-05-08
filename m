Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15459 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933109AbeEHIY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:29 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 05/16] btrfs-progs: lowmem: introduce avoid_extents_overwrite()
Date: Tue, 8 May 2018 16:30:01 +0800
Message-ID: <20180508083012.12090-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Declare a global u64 variable last_allocated_chunk records start of
the last chunk allocated by lowmem repair.
Although global variable is not graceful, it simplifies codes much.

avoid_extents_overwrite() prefers to allocates a new chunk first.
If it failed because of no space or wrong used bytes(fsck-tests/004),
then it try to exclude metadata blocks which costs lots of time in
large filesystems.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index eb50c7e63ead..9ca533bd2a0e 100644
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
2.17.0



