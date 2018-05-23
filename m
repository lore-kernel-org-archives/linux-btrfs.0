Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35090 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753787AbeEWDi3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 23:38:29 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>, <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: handle failures of set_extent_bits in add_excluded_extent
Date: Wed, 23 May 2018 11:37:47 +0800
Message-ID: <1527046667-19550-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

set_extent_bits may fail, return the result in add_excluded_extent.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Changelog:
v2-v1:
 1.remove goto to make the function run linearly.
 2.change commit description not pointing out the failure detail,
   since set_extent_bits's failure type may be added.
---
 fs/btrfs/extent-tree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75cfb80d2551..65ef3456fa62 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -215,11 +215,15 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
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
+		return ret;
+	ret = set_extent_bits(&fs_info->freed_extents[1],
 			start, end, EXTENT_UPTODATE);
-	return 0;
+	return ret;
 }
 
 static void free_excluded_extents(struct btrfs_fs_info *fs_info,
-- 
1.9.1



