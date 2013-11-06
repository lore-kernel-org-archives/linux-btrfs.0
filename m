Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38092 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFEE1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 23:04:27 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA644Qs5017227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:27 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA644PR9023989
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:26 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA644PZa023981
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:25 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs/tracepoint: update new flags for ordered extent TP
Date: Wed,  6 Nov 2013 12:04:14 +0800
Message-Id: <1383710654-25862-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1383710654-25862-1-git-send-email-bo.li.liu@oracle.com>
References: <1383710654-25862-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Flag BTRFS_ORDERED_TRUNCATED is a new one, update the tracepoint to
support it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4fbe10a..55c3829 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -216,7 +216,8 @@ TRACE_EVENT(btrfs_get_extent,
 		{ (1 << BTRFS_ORDERED_DIRECT),	 	"DIRECT" 	}, \
 		{ (1 << BTRFS_ORDERED_IOERR), 		"IOERR" 	}, \
 		{ (1 << BTRFS_ORDERED_UPDATED_ISIZE), 	"UPDATED_ISIZE"	}, \
-		{ (1 << BTRFS_ORDERED_LOGGED_CSUM), 	"LOGGED_CSUM"	})
+		{ (1 << BTRFS_ORDERED_LOGGED_CSUM), 	"LOGGED_CSUM"	}, \
+		{ (1 << BTRFS_ORDERED_TRUNCATED), 	"TRUNCATED"	})
 
 
 DECLARE_EVENT_CLASS(btrfs__ordered_extent,
-- 
1.8.2.1

