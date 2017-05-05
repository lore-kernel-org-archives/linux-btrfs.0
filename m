Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23169 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbdEECEM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 22:04:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs: cleanup qgroup trace event
Date: Fri,  5 May 2017 10:09:36 +0800
Message-Id: <20170505020936.6016-1-anand.jain@oracle.com>
In-Reply-To: <20170504140411.26723-1-anand.jain@oracle.com>
References: <20170504140411.26723-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 81fb6f77a026 (btrfs: qgroup: Add new trace point for
qgroup data reserve) added the following events which aren't used.
  btrfs__qgroup_data_map
  btrfs_qgroup_init_data_rsv_map
  btrfs_qgroup_free_data_rsv_map
So remove them.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
  cc: quwenruo@cn.fujitsu.com
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 include/trace/events/btrfs.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a3c3cab643a9..5471f9b4dc9e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1270,42 +1270,6 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
 	TP_ARGS(wq)
 );
 
-DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
-
-	TP_PROTO(struct inode *inode, u64 free_reserved),
-
-	TP_ARGS(inode, free_reserved),
-
-	TP_STRUCT__entry_btrfs(
-		__field(	u64,		rootid		)
-		__field(	unsigned long,	ino		)
-		__field(	u64,		free_reserved	)
-	),
-
-	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
-		__entry->rootid		=	BTRFS_I(inode)->root->objectid;
-		__entry->ino		=	inode->i_ino;
-		__entry->free_reserved	=	free_reserved;
-	),
-
-	TP_printk_btrfs("rootid=%llu ino=%lu free_reserved=%llu",
-		  __entry->rootid, __entry->ino, __entry->free_reserved)
-);
-
-DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_init_data_rsv_map,
-
-	TP_PROTO(struct inode *inode, u64 free_reserved),
-
-	TP_ARGS(inode, free_reserved)
-);
-
-DEFINE_EVENT(btrfs__qgroup_data_map, btrfs_qgroup_free_data_rsv_map,
-
-	TP_PROTO(struct inode *inode, u64 free_reserved),
-
-	TP_ARGS(inode, free_reserved)
-);
-
 #define BTRFS_QGROUP_OPERATIONS				\
 	{ QGROUP_RESERVE,	"reserve"	},	\
 	{ QGROUP_RELEASE,	"release"	},	\
-- 
2.10.0

