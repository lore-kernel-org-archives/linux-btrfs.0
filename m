Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:61830 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751027AbeEUJcq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:32:46 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C2D214B40405
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 17:32:41 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove unnecessary if judge
Date: Mon, 21 May 2018 17:32:14 +0800
Message-ID: <1526895134-1714-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since add_excluded_extent always returns 0,
no need to judge ret.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75cfb80d2551..4d876b32e136 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -249,8 +249,6 @@ static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
 		cache->bytes_super += stripe_len;
 		ret = add_excluded_extent(fs_info, cache->key.objectid,
 					  stripe_len);
-		if (ret)
-			return ret;
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -282,10 +280,6 @@ static int exclude_super_stripes(struct btrfs_fs_info *fs_info,
 
 			cache->bytes_super += len;
 			ret = add_excluded_extent(fs_info, start, len);
-			if (ret) {
-				kfree(logical);
-				return ret;
-			}
 		}
 
 		kfree(logical);
-- 
1.9.1



