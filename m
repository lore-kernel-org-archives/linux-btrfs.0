Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64082 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750980AbcHXENH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 00:13:07 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] btrfs: Fix extent map leak in find_first_block_group
Date: Wed, 24 Aug 2016 12:13:00 +0800
Message-ID: <20160824041300.20072-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following commit introduced the extent map leak:
commit 6fb37b756acce6d6e045f79c3764206033f617b4
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Wed Jun 22 18:31:27 2016 -0700

    Btrfs: check inconsistence between chunk and block group

This leads to slab warning at rmmod time.

Cc: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c2b81b0..e621823 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9905,6 +9905,7 @@ static int find_first_block_group(struct btrfs_root *root,
 				ret = -ENOENT;
 			} else {
 				ret = 0;
+				free_extent_map(em);
 			}
 			goto out;
 		}
-- 
2.7.4



