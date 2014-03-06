Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaCFFxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUdb009848
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 06/10] Btrfs: reclaim delalloc metadata more aggressively
Date: Thu, 6 Mar 2014 13:55:00 +0800
Message-Id: <1394085304-32589-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

generic/074 in xfstests failed sometimes because of the enospc error,
the reason of this problem is that we just reclaimed the space we need
from the reserved space for delalloc, and then tried to reserve the space,
but if some task did no-flush reservation between the above reclamation
and reservation,
	Task1			Task2
	shrink_delalloc()
	reclaim 1 block
	(The space that can
	 be reserved now is 1
	 block)
				do no-flush reservation
				reserve 1 block
				(The space that can
				 be reserved now is 0
				 block)
	reserving 1 block failed
the reservation of Task1 failed, but in fact, there was enough space to
reserve if we could reclaim more space before.

Fix this problem by the aggressive reclamation of the reserved delalloc
metadata space.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch.
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ddb5c84..07e3d14 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4174,7 +4174,7 @@ static int flush_space(struct btrfs_root *root,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(root, num_bytes, orig_bytes,
+		shrink_delalloc(root, num_bytes * 2, orig_bytes,
 				state == FLUSH_DELALLOC_WAIT);
 		break;
 	case ALLOC_CHUNK:
-- 
1.8.1.4

