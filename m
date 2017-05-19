Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16803 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdESSkB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 14:40:01 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4JIe0XD028902
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 18:40:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4JIdxQa021542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 18:40:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v4JIdxrb026576
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 18:39:59 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: skip commit transaction if we don't have enough pinned bytes
Date: Fri, 19 May 2017 11:39:15 -0600
Message-Id: <20170519173915.29846-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We commit transaction in order to reclaim space from pinned bytes because
it could process delayed refs, and in may_commit_transaction(), we check
first if pinned bytes are enough for the required space, we then check if
that plus bytes reserved for delayed insert are enough for the required
space.

This changes the code to the above logic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..bded1ddd1bb6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 
 	spin_lock(&delayed_rsv->lock);
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes - delayed_rsv->size) >= 0) {
+				   bytes - delayed_rsv->size) < 0) {
 		spin_unlock(&delayed_rsv->lock);
 		return -ENOSPC;
 	}
-- 
2.13.0

