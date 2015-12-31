Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753598AbbLaPIL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:08:11 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 399CD41887D9
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:28 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 06/10] btrfs: reada: move reada_extent_put to place after __readahead_hook()
Date: Thu, 31 Dec 2015 23:03:40 +0800
Message-ID: <9e54577b63a574b60950a62828a2f05702a86422.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can't release reada_extent earlier than __readahead_hook(), because
__readahead_hook() still need to use it, it is necessary to hode a refcnt
to avoid it be freed.

Actually it is not a problem after my patch named:
  Avoid many times of empty loop
It make reada_extent in above line include at least one reada_extctl,
which keeps additional one refcnt for reada_extent.

But we still need this patch to make the code in pretty logic.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 66409f3..7015906 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -722,8 +722,6 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	}
 	logical = re->logical;
 
-	reada_extent_put(fs_info, re);
-
 	atomic_inc(&dev->reada_in_flight);
 	ret = reada_tree_block_flagged(fs_info->extent_root, logical,
 			mirror_num, &eb);
@@ -735,6 +733,8 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	if (eb)
 		free_extent_buffer(eb);
 
+	reada_extent_put(fs_info, re);
+
 	return 1;
 
 }
-- 
1.8.5.1



