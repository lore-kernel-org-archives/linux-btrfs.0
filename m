Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8141 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbcCYR0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u2PHKiZ7021139
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:15 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 21vva22wh8-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:15 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/14] Btrfs: add tracepoint for adding block groups
Date: Fri, 25 Mar 2016 13:25:52 -0400
Message-ID: <1458926760-17563-7-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm writing a tool to visualize the enospc system inside btrfs, I need this
tracepoint in order to keep track of the block groups in the system.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c       |  2 ++
 include/trace/events/btrfs.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 90ac821..0db4319 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9849,6 +9849,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			goto error;
 		}
 
+		trace_btrfs_add_block_group(root->fs_info, cache, 0);
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					cache->bytes_super, &space_info);
@@ -10019,6 +10020,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	 * Now that our block group has its ->space_info set and is inserted in
 	 * the rbtree, update the space info's counters.
 	 */
+	trace_btrfs_add_block_group(root->fs_info, cache, 1);
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				cache->bytes_super, &cache->space_info);
 	if (ret) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d866f21..3e61deb8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -440,6 +440,46 @@ TRACE_EVENT(btrfs_sync_fs,
 	TP_printk("wait = %d", __entry->wait)
 );
 
+TRACE_EVENT(btrfs_add_block_group,
+
+	TP_PROTO(struct btrfs_fs_info *fs_info,
+		 struct btrfs_block_group_cache *block_group, int create),
+
+	TP_ARGS(fs_info, block_group, create),
+
+	TP_STRUCT__entry(
+		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
+		__field(	u64,	offset			)
+		__field(	u64,	size			)
+		__field(	u64,	flags			)
+		__field(	u64,	bytes_used		)
+		__field(	u64,	bytes_super		)
+		__field(	int,	create			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
+		__entry->offset		= block_group->key.objectid;
+		__entry->size		= block_group->key.offset;
+		__entry->flags		= block_group->flags;
+		__entry->bytes_used	=
+			btrfs_block_group_used(&block_group->item);
+		__entry->bytes_super	= block_group->bytes_super;
+		__entry->create		= create;
+	),
+
+	TP_printk("%pU: block_group offset = %llu, size = %llu, "
+		  "flags = %llu(%s), bytes_used = %llu, bytes_super = %llu, "
+		  "create = %d", __entry->fsid,
+		  (unsigned long long)__entry->offset,
+		  (unsigned long long)__entry->size,
+		  (unsigned long long)__entry->flags,
+		  __print_flags((unsigned long)__entry->flags, "|",
+				BTRFS_GROUP_FLAGS),
+		  (unsigned long long)__entry->bytes_used,
+		  (unsigned long long)__entry->bytes_super, __entry->create)
+);
+
 #define show_ref_action(action)						\
 	__print_symbolic(action,					\
 		{ BTRFS_ADD_DELAYED_REF,    "ADD_DELAYED_REF" },	\
-- 
2.5.0

