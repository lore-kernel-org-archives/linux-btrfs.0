Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20411 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2HaFik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:40 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5cdxp025952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:40 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5cdkg026091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:39 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5cdVW027887
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:39 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: update delayed ref's tracepoints to show sequence
Date: Fri, 31 Aug 2012 13:36:56 +0800
Message-Id: <1346391419-4278-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've added a new field 'sequence' to delayed ref node, so update related
tracepoints.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/trace/events/btrfs.h |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 91b91e8..54fab04 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -445,6 +445,7 @@ TRACE_EVENT(btrfs_delayed_tree_ref,
 		__field(	u64,  ref_root		)
 		__field(	int,  level		)
 		__field(	int,  type		)
+		__field(	u64,  seq		)
 	),
 
 	TP_fast_assign(
@@ -455,17 +456,19 @@ TRACE_EVENT(btrfs_delayed_tree_ref,
 		__entry->ref_root	= full_ref->root;
 		__entry->level		= full_ref->level;
 		__entry->type		= ref->type;
+		__entry->seq		= ref->seq;
 	),
 
 	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
 		  "parent = %llu(%s), ref_root = %llu(%s), level = %d, "
-		  "type = %s",
+		  "type = %s, seq = %llu",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
 		  show_root_type(__entry->parent),
 		  show_root_type(__entry->ref_root),
-		  __entry->level, show_ref_type(__entry->type))
+		  __entry->level, show_ref_type(__entry->type),
+		  (unsigned long long)__entry->seq)
 );
 
 TRACE_EVENT(btrfs_delayed_data_ref,
@@ -485,6 +488,7 @@ TRACE_EVENT(btrfs_delayed_data_ref,
 		__field(	u64,  owner		)
 		__field(	u64,  offset		)
 		__field(	int,  type		)
+		__field(	u64,  seq		)
 	),
 
 	TP_fast_assign(
@@ -496,11 +500,12 @@ TRACE_EVENT(btrfs_delayed_data_ref,
 		__entry->owner		= full_ref->objectid;
 		__entry->offset		= full_ref->offset;
 		__entry->type		= ref->type;
+		__entry->seq		= ref->seq;
 	),
 
 	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
 		  "parent = %llu(%s), ref_root = %llu(%s), owner = %llu, "
-		  "offset = %llu, type = %s",
+		  "offset = %llu, type = %s, seq = %llu",
 		  (unsigned long long)__entry->bytenr,
 		  (unsigned long long)__entry->num_bytes,
 		  show_ref_action(__entry->action),
@@ -508,7 +513,8 @@ TRACE_EVENT(btrfs_delayed_data_ref,
 		  show_root_type(__entry->ref_root),
 		  (unsigned long long)__entry->owner,
 		  (unsigned long long)__entry->offset,
-		  show_ref_type(__entry->type))
+		  show_ref_type(__entry->type),
+		  (unsigned long long)__entry->seq)
 );
 
 TRACE_EVENT(btrfs_delayed_ref_head,
-- 
1.7.7.6

