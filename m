Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8912 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbbLaPHE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:07:04 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id F00794092576
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:25 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 02/10] btrfs: reada: Move is_need_to_readahead contition earlier
Date: Thu, 31 Dec 2015 23:03:36 +0800
Message-ID: <0479ff13d49a9efd9630bf1ced86468b1fc078a4.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move is_need_to_readahead contition earlier to avoid useless loop
to get relative data for readahead.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index fb21bf0..dcc5b69 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -665,7 +665,6 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	u64 logical;
 	int ret;
 	int i;
-	int need_kick = 0;
 
 	spin_lock(&fs_info->reada_lock);
 	if (dev->reada_curr_zone == NULL) {
@@ -701,6 +700,15 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 
 	spin_unlock(&fs_info->reada_lock);
 
+	spin_lock(&re->lock);
+		if (re->scheduled_for || list_empty(&re->extctl)) {
+			spin_unlock(&re->lock);
+			reada_extent_put(fs_info, re);
+			return 0;
+		}
+		re->scheduled_for = dev;
+	spin_unlock(&re->lock);
+
 	/*
 	 * find mirror num
 	 */
@@ -712,18 +720,8 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	}
 	logical = re->logical;
 
-	spin_lock(&re->lock);
-	if (!re->scheduled_for && !list_empty(&re->extctl)) {
-		re->scheduled_for = dev;
-		need_kick = 1;
-	}
-	spin_unlock(&re->lock);
-
 	reada_extent_put(fs_info, re);
 
-	if (!need_kick)
-		return 0;
-
 	atomic_inc(&dev->reada_in_flight);
 	ret = reada_tree_block_flagged(fs_info->extent_root, logical,
 			mirror_num, &eb);
-- 
1.8.5.1



