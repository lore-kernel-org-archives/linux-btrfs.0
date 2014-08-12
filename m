Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaHLId2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 04:33:28 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7C8XRFC004785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:28 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7C8XQd5002662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:27 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7C8XPB6028245
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 08:33:26 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: add work_struct information for workqueue tracepoint
Date: Tue, 12 Aug 2014 16:33:17 +0800
Message-Id: <1407832398-2409-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel workqueue's tracepoints print the address of work_struct, while btrfs
workqueue's tracepoints print the address of btrfs_work.

We need a connection between this two, for example when debuging, we usually
grep an address in the trace output.  So it'd be better to also print
work_struct in btrfs workqueue's tracepoint.

Please note that we can only add this into those tracepoints whose work is still
available in memory because we need to reference the work.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4ee4e30..bb8fe5a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -996,6 +996,7 @@ DECLARE_EVENT_CLASS(btrfs__work,
 		__field(	void *,	func			)
 		__field(	void *,	ordered_func		)
 		__field(	void *,	ordered_free		)
+		__field(	void *,	normal_work		)
 	),
 
 	TP_fast_assign(
@@ -1004,11 +1005,13 @@ DECLARE_EVENT_CLASS(btrfs__work,
 		__entry->func		= work->func;
 		__entry->ordered_func	= work->ordered_func;
 		__entry->ordered_free	= work->ordered_free;
+		__entry->normal_work	= &work->normal_work;
 	),
 
-	TP_printk("work=%p, wq=%p, func=%p, ordered_func=%p, ordered_free=%p",
-		  __entry->work, __entry->wq, __entry->func,
-		  __entry->ordered_func, __entry->ordered_free)
+	TP_printk("work=%p (normal_work=%p), wq=%p, func=%p, ordered_func=%p,"
+		  " ordered_free=%p",
+		  __entry->work, __entry->normal_work, __entry->wq,
+		   __entry->func, __entry->ordered_func, __entry->ordered_free)
 );
 
 /* For situiations that the work is freed */
-- 
1.8.1.4

