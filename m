Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29150 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751214AbeEVJrJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:47:09 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: handle failures of set_extent_bits in add_excluded_extent
Date: Tue, 22 May 2018 17:46:50 +0800
Message-ID: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

set_extent_bits may return 0/-EEXIST, so return the result in
add_excluded_extent.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75cfb80d2551..2e85e99b5e6f 100644
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
-- 
1.9.1



