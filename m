Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaHOPiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 11:38:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7FFcEZ2031944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:38:15 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7FFcErn019438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:38:14 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7FFcDNl026919
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Aug 2014 15:38:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: show real function name in btrfs workqueue tracepoint
Date: Fri, 15 Aug 2014 23:38:06 +0800
Message-Id: <1408117086-1201-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use %pf instead of %p, just same as kernel workqueue tracepoints.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index e26c541..6c1f897 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1009,7 +1009,7 @@ DECLARE_EVENT_CLASS(btrfs__work,
 		__entry->normal_work	= &work->normal_work;
 	),
 
-	TP_printk("work=%p (normal_work=%p), wq=%p, func=%p, ordered_func=%p,"
+	TP_printk("work=%p (normal_work=%p), wq=%p, func=%pf, ordered_func=%p,"
 		  " ordered_free=%p",
 		  __entry->work, __entry->normal_work, __entry->wq,
 		   __entry->func, __entry->ordered_func, __entry->ordered_free)
-- 
1.8.1.4

