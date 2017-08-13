Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28011 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdHMDwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:52:00 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: use BTRFS_FSID_SIZE for fsid
Date: Sun, 13 Aug 2017 11:58:30 +0800
Message-Id: <20170813035830.18660-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have define for FSID size so use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/trace/events/btrfs.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index cd99a3658156..c4e4b9427b81 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -73,11 +73,11 @@ struct btrfs_qgroup;
 	{ BTRFS_BLOCK_GROUP_RAID5,	"RAID5"},	\
 	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
 
-#define BTRFS_UUID_SIZE 16
-#define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_UUID_SIZE)
+#define BTRFS_FSID_SIZE 16
+#define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_FSID_SIZE)
 
 #define TP_fast_assign_fsid(fs_info)					\
-	memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE)
+	memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE)
 
 #define TP_STRUCT__entry_btrfs(args...)					\
 	TP_STRUCT__entry(						\
@@ -612,7 +612,7 @@ TRACE_EVENT(btrfs_add_block_group,
 	TP_ARGS(fs_info, block_group, create),
 
 	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
 		__field(	u64,	offset			)
 		__field(	u64,	size			)
 		__field(	u64,	flags			)
@@ -622,7 +622,7 @@ TRACE_EVENT(btrfs_add_block_group,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
+		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
 		__entry->offset		= block_group->key.objectid;
 		__entry->size		= block_group->key.offset;
 		__entry->flags		= block_group->flags;
@@ -969,7 +969,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 	TP_ARGS(fs_info, flags, bytes, flush, reason),
 
 	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
 		__field(	u64,	flags			)
 		__field(	u64,	bytes			)
 		__field(	int,	flush			)
@@ -977,7 +977,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
+		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
 		__entry->flags	= flags;
 		__entry->bytes	= bytes;
 		__entry->flush	= flush;
@@ -1010,7 +1010,7 @@ TRACE_EVENT(btrfs_flush_space,
 	TP_ARGS(fs_info, flags, num_bytes, orig_bytes, state, ret),
 
 	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
 		__field(	u64,	flags			)
 		__field(	u64,	num_bytes		)
 		__field(	u64,	orig_bytes		)
@@ -1019,7 +1019,7 @@ TRACE_EVENT(btrfs_flush_space,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
+		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
 		__entry->flags		=	flags;
 		__entry->num_bytes	=	num_bytes;
 		__entry->orig_bytes	=	orig_bytes;
-- 
2.13.1

