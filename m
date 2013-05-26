Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41038 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3EZNvY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:24 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpL1F007279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:22 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpNFA012227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:23 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpMtJ009911
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs: update new flags for tracepoint
Date: Sun, 26 May 2013 21:50:28 +0800
Message-Id: <1369576231-17836-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding new flags to keep tracepoints consistent with btrfs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ea546a4..2902657 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -40,22 +40,25 @@ struct extent_buffer;
 		{ BTRFS_ROOT_TREE_DIR_OBJECTID, "ROOT_TREE_DIR"	},	\
 		{ BTRFS_CSUM_TREE_OBJECTID, 	"CSUM_TREE"	},	\
 		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
+		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
 		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
 	obj, ((obj >= BTRFS_DATA_RELOC_TREE_OBJECTID) ||		\
 	      (obj >= BTRFS_ROOT_TREE_OBJECTID &&			\
-	       obj <= BTRFS_CSUM_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
+	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define BTRFS_GROUP_FLAGS	\
-	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"}, \
-	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"}, \
-	{ BTRFS_BLOCK_GROUP_METADATA,	"METADATA"}, \
-	{ BTRFS_BLOCK_GROUP_RAID0,	"RAID0"}, \
-	{ BTRFS_BLOCK_GROUP_RAID1,	"RAID1"}, \
-	{ BTRFS_BLOCK_GROUP_DUP,	"DUP"}, \
-	{ BTRFS_BLOCK_GROUP_RAID10,	"RAID10"}
+	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
+	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
+	{ BTRFS_BLOCK_GROUP_METADATA,	"METADATA"},	\
+	{ BTRFS_BLOCK_GROUP_RAID0,	"RAID0"}, 	\
+	{ BTRFS_BLOCK_GROUP_RAID1,	"RAID1"}, 	\
+	{ BTRFS_BLOCK_GROUP_DUP,	"DUP"}, 	\
+	{ BTRFS_BLOCK_GROUP_RAID10,	"RAID10"}, 	\
+	{ BTRFS_BLOCK_GROUP_RAID5,	"RAID5"},	\
+	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
 
 #define BTRFS_UUID_SIZE 16
 
@@ -154,7 +157,9 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 		{ EXTENT_FLAG_PINNED, 		"PINNED" 	},	\
 		{ EXTENT_FLAG_COMPRESSED, 	"COMPRESSED" 	},	\
 		{ EXTENT_FLAG_VACANCY, 		"VACANCY" 	},	\
-		{ EXTENT_FLAG_PREALLOC, 	"PREALLOC" 	})
+		{ EXTENT_FLAG_PREALLOC, 	"PREALLOC" 	},	\
+		{ EXTENT_FLAG_LOGGING,	 	"LOGGING" 	},	\
+		{ EXTENT_FLAG_FILLING,	 	"FILLING" 	})
 
 TRACE_EVENT(btrfs_get_extent,
 
@@ -201,13 +206,17 @@ TRACE_EVENT(btrfs_get_extent,
 );
 
 #define show_ordered_flags(flags)					\
-	__print_symbolic(flags,					\
+	__print_symbolic(flags,						\
 		{ BTRFS_ORDERED_IO_DONE, 	"IO_DONE" 	},	\
 		{ BTRFS_ORDERED_COMPLETE, 	"COMPLETE" 	},	\
 		{ BTRFS_ORDERED_NOCOW, 		"NOCOW" 	},	\
 		{ BTRFS_ORDERED_COMPRESSED, 	"COMPRESSED" 	},	\
 		{ BTRFS_ORDERED_PREALLOC, 	"PREALLOC" 	},	\
-		{ BTRFS_ORDERED_DIRECT, 	"DIRECT" 	})
+		{ BTRFS_ORDERED_DIRECT, 	"DIRECT" 	},	\
+		{ BTRFS_ORDERED_IOERR, 		"IOERR" 	},	\
+		{ BTRFS_ORDERED_UPDATED_ISIZE, 	"UPDATED_ISIZE"	},	\
+		{ BTRFS_ORDERED_LOGGED_CSUM, 	"LOGGED_CSUM"	})
+
 
 DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 
@@ -555,7 +564,9 @@ TRACE_EVENT(btrfs_delayed_ref_head,
 		{ BTRFS_BLOCK_GROUP_RAID0, 	"RAID0" },	\
 		{ BTRFS_BLOCK_GROUP_RAID1, 	"RAID1" },	\
 		{ BTRFS_BLOCK_GROUP_DUP, 	"DUP"	},	\
-		{ BTRFS_BLOCK_GROUP_RAID10, 	"RAID10"})
+		{ BTRFS_BLOCK_GROUP_RAID10, 	"RAID10"},	\
+		{ BTRFS_BLOCK_GROUP_RAID5, 	"RAID5"	},	\
+		{ BTRFS_BLOCK_GROUP_RAID6, 	"RAID6"	})
 
 DECLARE_EVENT_CLASS(btrfs__chunk,
 
-- 
1.7.7

