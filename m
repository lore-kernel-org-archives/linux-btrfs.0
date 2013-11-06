Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3KFEE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 23:04:26 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA644PF0005371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:26 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA644OvQ026308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:25 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA644NoK023940
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 04:04:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs/tracepoint: fix to report right flags for ordered extent
Date: Wed,  6 Nov 2013 12:04:13 +0800
Message-Id: <1383710654-25862-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use set_bit() to assign ordered extent's flags, but in the related
tracepoint we don't do the same thing, which makes the trace output
not to parse flags correctly.

Also, since the flags are bits stuff, we change to use __print_flags with
a 'delim' instead of __print_symbolic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f18b3b7..4fbe10a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -206,17 +206,17 @@ TRACE_EVENT(btrfs_get_extent,
 		  __entry->refs, __entry->compress_type)
 );
 
-#define show_ordered_flags(flags)					\
-	__print_symbolic(flags,						\
-		{ BTRFS_ORDERED_IO_DONE, 	"IO_DONE" 	},	\
-		{ BTRFS_ORDERED_COMPLETE, 	"COMPLETE" 	},	\
-		{ BTRFS_ORDERED_NOCOW, 		"NOCOW" 	},	\
-		{ BTRFS_ORDERED_COMPRESSED, 	"COMPRESSED" 	},	\
-		{ BTRFS_ORDERED_PREALLOC, 	"PREALLOC" 	},	\
-		{ BTRFS_ORDERED_DIRECT, 	"DIRECT" 	},	\
-		{ BTRFS_ORDERED_IOERR, 		"IOERR" 	},	\
-		{ BTRFS_ORDERED_UPDATED_ISIZE, 	"UPDATED_ISIZE"	},	\
-		{ BTRFS_ORDERED_LOGGED_CSUM, 	"LOGGED_CSUM"	})
+#define show_ordered_flags(flags)					   \
+	__print_flags(flags, "|",					   \
+		{ (1 << BTRFS_ORDERED_IO_DONE), 	"IO_DONE" 	}, \
+		{ (1 << BTRFS_ORDERED_COMPLETE), 	"COMPLETE" 	}, \
+		{ (1 << BTRFS_ORDERED_NOCOW), 		"NOCOW" 	}, \
+		{ (1 << BTRFS_ORDERED_COMPRESSED), 	"COMPRESSED" 	}, \
+		{ (1 << BTRFS_ORDERED_PREALLOC), 	"PREALLOC" 	}, \
+		{ (1 << BTRFS_ORDERED_DIRECT),	 	"DIRECT" 	}, \
+		{ (1 << BTRFS_ORDERED_IOERR), 		"IOERR" 	}, \
+		{ (1 << BTRFS_ORDERED_UPDATED_ISIZE), 	"UPDATED_ISIZE"	}, \
+		{ (1 << BTRFS_ORDERED_LOGGED_CSUM), 	"LOGGED_CSUM"	})
 
 
 DECLARE_EVENT_CLASS(btrfs__ordered_extent,
-- 
1.8.2.1

