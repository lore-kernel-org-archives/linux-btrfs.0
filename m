Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52824 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751719AbeEVDvs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 23:51:48 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
Subject: [PATCH] btrfs: handle failures of set_extent_bits in add_excluded_extent
Date: Tue, 22 May 2018 11:51:39 +0800
Message-ID: <1526961099-5922-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

set_extent_bits may return 0/-EEXIST, so return the result in
add_excluded_extent. And handle the failures in upper callers.

Caller of add_excluded_extent and failure process currently:
exclude_super_stripes
	<- btrfs_make_block_group  //handles the failure
	<- btrfs_read_block_groups //handles the failure
__exclude_logged_extent
	<- btrfs_exclude_logged_extents
	<- btrfs_alloc_logged_file_extent //propagate failure to upper
					caller
Add logic of propagate return value of __exclude_logged_extent to
btrfs_exclude_logged_extents.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75cfb80d2551..28fd71579141 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -215,11 +215,16 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
 			       u64 start, u64 num_bytes)
 {
 	u64 end = start + num_bytes - 1;
-	set_extent_bits(&fs_info->freed_extents[0],
+	int ret = 0;
+
+	ret = set_extent_bits(&fs_info->freed_extents[0],
 			start, end, EXTENT_UPTODATE);
-	set_extent_bits(&fs_info->freed_extents[1],
+	if (ret)
+		goto out;
+	ret = set_extent_bits(&fs_info->freed_extents[1],
 			start, end, EXTENT_UPTODATE);
-	return 0;
+out:
+	return ret;
 }
 
 static void free_excluded_extents(struct btrfs_fs_info *fs_info,
@@ -6463,6 +6468,7 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	int found_type;
 	int i;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(fs_info, MIXED_GROUPS))
 		return 0;
@@ -6479,10 +6485,14 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
 			continue;
 		key.objectid = btrfs_file_extent_disk_bytenr(eb, item);
 		key.offset = btrfs_file_extent_disk_num_bytes(eb, item);
-		__exclude_logged_extent(fs_info, key.objectid, key.offset);
+		ret = __exclude_logged_extent(fs_info, key.objectid,
+				key.offset);
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	return ret;
 }
 
 static void
-- 
1.9.1



