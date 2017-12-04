Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58662 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdLDXnZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 18:43:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB4NgE0i021407
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:24 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2enc4r8qt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 23:43:24 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhNwQ017175
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB4NhNTV015356
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: remove redundant check in rbio_can_merge
Date: Mon,  4 Dec 2017 15:40:35 -0700
Message-Id: <20171204224037.7556-2-bo.li.liu@oracle.com>
In-Reply-To: <20171204224037.7556-1-bo.li.liu@oracle.com>
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Given the above
'
if (last->operation != cur->operation)
	return 0;
',
it's guaranteed that two operations are same.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24a6222..c4188fb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -595,12 +595,10 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 	 * bio list here, anyone else that wants to
 	 * change this stripe needs to do their own rmw.
 	 */
-	if (last->operation == BTRFS_RBIO_PARITY_SCRUB ||
-	    cur->operation == BTRFS_RBIO_PARITY_SCRUB)
+	if (last->operation == BTRFS_RBIO_PARITY_SCRUB)
 		return 0;
 
-	if (last->operation == BTRFS_RBIO_REBUILD_MISSING ||
-	    cur->operation == BTRFS_RBIO_REBUILD_MISSING)
+	if (last->operation == BTRFS_RBIO_REBUILD_MISSING)
 		return 0;
 
 	return 1;
-- 
2.9.4

