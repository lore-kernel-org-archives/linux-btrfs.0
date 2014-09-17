Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30691 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaIQNg4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 09:36:56 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8HDatqK027615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 13:36:56 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8HDasBX020814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 13:36:55 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8HDaswT007714
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 13:36:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix wrong parse of extent map's tracepoint
Date: Wed, 17 Sep 2014 21:36:41 +0800
Message-Id: <1410961001-1590-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tracepoint of extent map doesn't parse @flag correctly, we set @flag via
set_bit(), so we need to parse it on a bit bias.

Also add the missing flag, EXTENT_FLAG_FS_MAPPING.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4ee4e30..9c69cf0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -157,12 +157,13 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 
 #define show_map_flags(flag)						\
 	__print_flags(flag, "|",					\
-		{ EXTENT_FLAG_PINNED, 		"PINNED" 	},	\
-		{ EXTENT_FLAG_COMPRESSED, 	"COMPRESSED" 	},	\
-		{ EXTENT_FLAG_VACANCY, 		"VACANCY" 	},	\
-		{ EXTENT_FLAG_PREALLOC, 	"PREALLOC" 	},	\
-		{ EXTENT_FLAG_LOGGING,	 	"LOGGING" 	},	\
-		{ EXTENT_FLAG_FILLING,	 	"FILLING" 	})
+		{ (1 << EXTENT_FLAG_PINNED), 		"PINNED" 	},\
+		{ (1 << EXTENT_FLAG_COMPRESSED), 	"COMPRESSED" 	},\
+		{ (1 << EXTENT_FLAG_VACANCY), 		"VACANCY" 	},\
+		{ (1 << EXTENT_FLAG_PREALLOC), 		"PREALLOC" 	},\
+		{ (1 << EXTENT_FLAG_LOGGING),	 	"LOGGING" 	},\
+		{ (1 << EXTENT_FLAG_FILLING),	 	"FILLING" 	},\
+		{ (1 << EXTENT_FLAG_FS_MAPPING),	"FS_MAPPING"	})
 
 TRACE_EVENT_CONDITION(btrfs_get_extent,
 
-- 
1.8.1.4

