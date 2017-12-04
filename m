Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44215 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752196AbdLEB14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 20:27:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB4NfrLD182888
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ekpeyn3fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 23:43:24 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhNse013537
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB4NhNLT003666
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: do not merge rbios if their fail stripe index are not identical
Date: Mon,  4 Dec 2017 15:40:36 -0700
Message-Id: <20171204224037.7556-3-bo.li.liu@oracle.com>
In-Reply-To: <20171204224037.7556-1-bo.li.liu@oracle.com>
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since fail stripe index in rbio would be used to decide which
algorithm reconstruction would be run, we cannot merge rbios if
their's fail striped index are different, otherwise, one of the two
reconstructions would fail.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index c4188fb..8d09535 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -601,6 +601,15 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 	if (last->operation == BTRFS_RBIO_REBUILD_MISSING)
 		return 0;
 
+	if (last->operation == BTRFS_RBIO_READ_REBUILD) {
+		int fa = (last->faila < last->failb) ? last->faila : last->failb;
+		int fb = (last->faila < last->failb) ? last->failb : last->faila;
+		int cur_fa = (cur->faila < cur->failb) ? cur->faila : cur->failb;
+		int cur_fb = (cur->faila < cur->failb) ? cur->failb : cur->faila;
+
+		if (fa != cur_fa || fb != cur_fb)
+			return 0;
+	}
 	return 1;
 }
 
-- 
2.9.4

