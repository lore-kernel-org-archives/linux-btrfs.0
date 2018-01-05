Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35599 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbeAEUyL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 15:54:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w05KqOUY024178
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fagex02gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 20:54:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w05KsAWp000508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w05KsACO000483
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:10 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/10] Btrfs: add tracepoint for em's EEXIST case
Date: Fri,  5 Jan 2018 12:51:16 -0700
Message-Id: <20180105195117.5131-10-bo.li.liu@oracle.com>
In-Reply-To: <20180105195117.5131-1-bo.li.liu@oracle.com>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
subtle bugs around merge_extent_mapping.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c        |  3 +++
 include/trace/events/btrfs.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index b5d0add..a5a1d17 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -552,6 +552,9 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
 		ret = 0;
 
 		existing = search_extent_mapping(em_tree, start, len);
+
+		trace_btrfs_handle_em_exist(existing, em, start, len);
+
 		/*
 		 * existing will always be non-NULL, since there must be
 		 * extent causing the -EEXIST.
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4342a32..b7ffcf7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -249,6 +249,41 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 		  __entry->refs, __entry->compress_type)
 );
 
+TRACE_EVENT(btrfs_handle_em_exist,
+
+	TP_PROTO(const struct extent_map *existing, const struct extent_map *map, u64 start, u64 len),
+
+	TP_ARGS(existing, map, start, len),
+
+	TP_STRUCT__entry(
+		__field(	u64,  e_start		)
+		__field(	u64,  e_len		)
+		__field(	u64,  map_start		)
+		__field(	u64,  map_len		)
+		__field(	u64,  start		)
+		__field(	u64,  len		)
+	),
+
+	TP_fast_assign(
+		__entry->e_start	= existing->start;
+		__entry->e_len		= existing->len;
+		__entry->map_start	= map->start;
+		__entry->map_len	= map->len;
+		__entry->start		= start;
+		__entry->len		= len;
+	),
+
+	TP_printk("start=%llu len=%llu "
+		  "existing(start=%llu len=%llu) "
+		  "em(start=%llu len=%llu)",
+		  (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->len,
+		  (unsigned long long)__entry->e_start,
+		  (unsigned long long)__entry->e_len,
+		  (unsigned long long)__entry->map_start,
+		  (unsigned long long)__entry->map_len)
+);
+
 /* file extent item */
 DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
 
-- 
2.9.4

