Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44877 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaHLId3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 04:33:29 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7C8XS5C020537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:29 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7C8XR1o019963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:28 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7C8XRLU002704
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:27 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: cleanup for btrfs workqueue tracepoints
Date: Tue, 12 Aug 2014 16:33:18 +0800
Message-Id: <1407832398-2409-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1407832398-2409-1-git-send-email-bo.li.liu@oracle.com>
References: <1407832398-2409-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tracepoint trace_btrfs_normal_work_done never has an user, just cleanup it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index bb8fe5a..aa595b1 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1046,13 +1046,6 @@ DEFINE_EVENT(btrfs__work, btrfs_work_sched,
 	TP_ARGS(work)
 );
 
-DEFINE_EVENT(btrfs__work, btrfs_normal_work_done,
-
-	TP_PROTO(struct btrfs_work *work),
-
-	TP_ARGS(work)
-);
-
 DEFINE_EVENT(btrfs__work__done, btrfs_all_work_done,
 
 	TP_PROTO(struct btrfs_work *work),
-- 
1.8.1.4

