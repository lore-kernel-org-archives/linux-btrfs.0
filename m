Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63163 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbcCYR01 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:27 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKUUf021302
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:26 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 21vva6jmxq-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:26 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/14] Btrfs: add fsid to some tracepoints
Date: Fri, 25 Mar 2016 13:25:57 -0400
Message-ID: <1458926760-17563-12-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When tracing enospc problems on a box with multiple file systems mounted I need
to be able to differentiate between the two file systems.  Most of the important
trace points I'm looking at already have an fsid, but the reserved extent trace
points do not, so add that to make it possible to figure out which trace point
belongs to which file system.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 include/trace/events/btrfs.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 6c192dc..b0f555e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -873,18 +873,21 @@ DECLARE_EVENT_CLASS(btrfs__reserved_extent,
 	TP_ARGS(root, start, len),
 
 	TP_STRUCT__entry(
-		__field(	u64,  root_objectid		)
-		__field(	u64,  start			)
-		__field(	u64,  len			)
+		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__field(	u64,	root_objectid		)
+		__field(	u64,	start			)
+		__field(	u64,	len			)
 	),
 
 	TP_fast_assign(
+		memcpy(__entry->fsid, root->fs_info->fsid, BTRFS_UUID_SIZE);
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->start		= start;
 		__entry->len		= len;
 	),
 
-	TP_printk("root = %llu(%s), start = %llu, len = %llu",
+	TP_printk("%pU: root = %llu(%s), start = %llu, len = %llu",
+		  __entry->fsid,
 		  show_root_type(__entry->root_objectid),
 		  (unsigned long long)__entry->start,
 		  (unsigned long long)__entry->len)
@@ -941,6 +944,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 	TP_ARGS(root, block_group, start, len),
 
 	TP_STRUCT__entry(
+		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
 		__field(	u64,	root_objectid		)
 		__field(	u64,	bg_objectid		)
 		__field(	u64,	flags			)
@@ -949,6 +953,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 	),
 
 	TP_fast_assign(
+		memcpy(__entry->fsid, root->fs_info->fsid, BTRFS_UUID_SIZE);
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->bg_objectid	= block_group->key.objectid;
 		__entry->flags		= block_group->flags;
@@ -956,8 +961,8 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
 		__entry->len		= len;
 	),
 
-	TP_printk("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
-		  "start = %Lu, len = %Lu",
+	TP_printk("%pU: root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
+		  "start = %Lu, len = %Lu", __entry->fsid,
 		  show_root_type(__entry->root_objectid), __entry->bg_objectid,
 		  __entry->flags, __print_flags((unsigned long)__entry->flags,
 						"|", BTRFS_GROUP_FLAGS),
-- 
2.5.0

