Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35777 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbeDIMBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8747EAD39
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: tracepoints, use extended format with UUID where possible
Date: Mon,  9 Apr 2018 13:58:55 +0200
Message-Id: <fe7120ffd1fd1e7c920b91b7db91dd6059310eb6.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most of the strings are prefixed by the UUID of the filesystem that
generates the message, however there are a few events that still
opencode the macro magic and can be converted to the common macros.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1773355e9365..9be469706d30 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -666,8 +666,7 @@ TRACE_EVENT(btrfs_add_block_group,
 
 	TP_ARGS(fs_info, block_group, create),
 
-	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
+	TP_STRUCT__entry_btrfs(
 		__field(	u64,	offset			)
 		__field(	u64,	size			)
 		__field(	u64,	flags			)
@@ -676,8 +675,7 @@ TRACE_EVENT(btrfs_add_block_group,
 		__field(	int,	create			)
 	),
 
-	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
+	TP_fast_assign_btrfs(fs_info,
 		__entry->offset		= block_group->key.objectid;
 		__entry->size		= block_group->key.offset;
 		__entry->flags		= block_group->flags;
@@ -687,9 +685,9 @@ TRACE_EVENT(btrfs_add_block_group,
 		__entry->create		= create;
 	),
 
-	TP_printk("%pU: block_group offset=%llu size=%llu "
+	TP_printk_btrfs("block_group offset=%llu size=%llu "
 		  "flags=%llu(%s) bytes_used=%llu bytes_super=%llu "
-		  "create=%d", __entry->fsid,
+		  "create=%d",
 		  __entry->offset,
 		  __entry->size,
 		  __entry->flags,
@@ -1020,24 +1018,22 @@ TRACE_EVENT(btrfs_trigger_flush,
 
 	TP_ARGS(fs_info, flags, bytes, flush, reason),
 
-	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
+	TP_STRUCT__entry_btrfs(
 		__field(	u64,	flags			)
 		__field(	u64,	bytes			)
 		__field(	int,	flush			)
 		__string(	reason,	reason			)
 	),
 
-	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
+	TP_fast_assign_btrfs(fs_info,
 		__entry->flags	= flags;
 		__entry->bytes	= bytes;
 		__entry->flush	= flush;
 		__assign_str(reason, reason)
 	),
 
-	TP_printk("%pU: %s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
-		  __entry->fsid, __get_str(reason), __entry->flush,
+	TP_printk_btrfs("%s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
+		  __get_str(reason), __entry->flush,
 		  show_flush_action(__entry->flush),
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
@@ -1061,24 +1057,22 @@ TRACE_EVENT(btrfs_flush_space,
 
 	TP_ARGS(fs_info, flags, num_bytes, state, ret),
 
-	TP_STRUCT__entry(
-		__array(	u8,	fsid,	BTRFS_FSID_SIZE	)
+	TP_STRUCT__entry_btrfs(
 		__field(	u64,	flags			)
 		__field(	u64,	num_bytes		)
 		__field(	int,	state			)
 		__field(	int,	ret			)
 	),
 
-	TP_fast_assign(
-		memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE);
+	TP_fast_assign_btrfs(fs_info,
 		__entry->flags		=	flags;
 		__entry->num_bytes	=	num_bytes;
 		__entry->state		=	state;
 		__entry->ret		=	ret;
 	),
 
-	TP_printk("%pU: state=%d(%s) flags=%llu(%s) num_bytes=%llu ret=%d",
-		  __entry->fsid, __entry->state,
+	TP_printk_btrfs("state=%d(%s) flags=%llu(%s) num_bytes=%llu ret=%d",
+		  __entry->state,
 		  show_flush_state(__entry->state),
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
-- 
2.16.2

