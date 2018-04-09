Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35749 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751502AbeDIMBS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CDD8AEF9
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs: tracepoints, use %llu instead of %Lu
Date: Mon,  9 Apr 2018 13:58:48 +0200
Message-Id: <79807fe2f6c2381a369e2938d9e7ec422b40d4ff.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For consistency, use the %llu form.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index dafd58ad86ec..200c45911919 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1002,7 +1002,7 @@ TRACE_EVENT(btrfs_space_reservation,
 		__entry->reserve	= reserve;
 	),
 
-	TP_printk_btrfs("%s: %Lu %s %Lu", __get_str(type), __entry->val,
+	TP_printk_btrfs("%s: %llu %s %llu", __get_str(type), __entry->val,
 			__entry->reserve ? "reserve" : "release",
 			__entry->bytes)
 );
@@ -1141,7 +1141,7 @@ TRACE_EVENT(find_free_extent,
 		__entry->data		= data;
 	),
 
-	TP_printk_btrfs("root=%Lu(%s) len=%Lu empty_size=%Lu flags=%Lu(%s)",
+	TP_printk_btrfs("root=%llu(%s) len=%llu empty_size=%llu flags=%llu(%s)",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  __entry->num_bytes, __entry->empty_size, __entry->data,
 		  __print_flags((unsigned long)__entry->data, "|",
@@ -1170,8 +1170,8 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 		__entry->len		= len;
 	),
 
-	TP_printk_btrfs("root=%Lu(%s) block_group=%Lu flags=%Lu(%s) "
-		  "start=%Lu len=%Lu",
+	TP_printk_btrfs("root=%llu(%s) block_group=%llu flags=%llu(%s) "
+		  "start=%llu len=%llu",
 		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
 		  __entry->bg_objectid,
 		  __entry->flags, __print_flags((unsigned long)__entry->flags,
@@ -1222,8 +1222,8 @@ TRACE_EVENT(btrfs_find_cluster,
 		__entry->min_bytes	= min_bytes;
 	),
 
-	TP_printk_btrfs("block_group=%Lu flags=%Lu(%s) start=%Lu len=%Lu "
-		  "empty_size=%Lu min_bytes=%Lu", __entry->bg_objectid,
+	TP_printk_btrfs("block_group=%llu flags=%llu(%s) start=%llu len=%llu "
+		  "empty_size=%llu min_bytes=%llu", __entry->bg_objectid,
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
 				BTRFS_GROUP_FLAGS), __entry->start,
@@ -1244,7 +1244,7 @@ TRACE_EVENT(btrfs_failed_cluster_setup,
 		__entry->bg_objectid	= block_group->key.objectid;
 	),
 
-	TP_printk_btrfs("block_group=%Lu", __entry->bg_objectid)
+	TP_printk_btrfs("block_group=%llu", __entry->bg_objectid)
 );
 
 TRACE_EVENT(btrfs_setup_cluster,
@@ -1273,8 +1273,8 @@ TRACE_EVENT(btrfs_setup_cluster,
 		__entry->bitmap		= bitmap;
 	),
 
-	TP_printk_btrfs("block_group=%Lu flags=%Lu(%s) window_start=%Lu "
-		  "size=%Lu max_size=%Lu bitmap=%d",
+	TP_printk_btrfs("block_group=%llu flags=%llu(%s) window_start=%llu "
+		  "size=%llu max_size=%llu bitmap=%d",
 		  __entry->bg_objectid,
 		  __entry->flags,
 		  __print_flags((unsigned long)__entry->flags, "|",
-- 
2.16.2

