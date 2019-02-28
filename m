Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CAAC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B02B02183F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbfB1KDI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:03:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:59308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731561AbfB1KDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 05:03:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FB27ADD1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 10:03:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: trace: Add trace events for extent_io_tree
Date:   Thu, 28 Feb 2019 18:02:55 +0800
Message-Id: <20190228100255.10953-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190228100255.10953-1-wqu@suse.com>
References: <20190228100255.10953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although btrfs heavily relies on extent_io_tree, we don't really have
any good trace events for them.

This patch will add the folowing trace events:
trace_btrfs_set_extent_bit()
trace_btrfs_clear_extent_bit()
trace_btrfs_convert_extent_bit()

The output would be:
  btrfs_set_extent_bit: io_tree=INODE_IO_TREE ino=1 root=1 start=22036480 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: io_tree=INODE_IO_TREE ino=1 root=1 start=22040576 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: io_tree=INODE_IO_TREE ino=1 root=1 start=22044672 len=4096 set_bits=LOCKED
  btrfs_set_extent_bit: io_tree=INODE_IO_TREE ino=1 root=1 start=22048768 len=4096 set_bits=LOCKED
  btrfs_clear_extent_bit: io_tree=INODE_IO_TREE ino=1 root=1 start=22036480 len=16384 clear_bits=LOCKED
  ^^^ Extent buffer 22036480 read from disc, the locking progress

  btrfs_set_extent_bit: io_tree=TRANS_DIRTY_PAGES ino=1 root=1 start=30425088 len=16384 set_bits=DIRTY
  btrfs_set_extent_bit: io_tree=TRANS_DIRTY_PAGES ino=1 root=1 start=30441472 len=16384 set_bits=DIRTY
  ^^^ 2 new tree blocks allocated in one transaction

  btrfs_set_extent_bit: io_tree=FREED_EXTENTS0 ino=0 root=0 start=30523392 len=16384 set_bits=DIRTY
  btrfs_set_extent_bit: io_tree=FREED_EXTENTS0 ino=0 root=0 start=30556160 len=16384 set_bits=DIRTY
  ^^^ 2 old tree blocks get pinned down

There are 2 points which need extra attention:
1) Those trace events are pretty heavy
   The following workload would generate over 400 trace events.
	mkfs.btrfs -f $dev
	start_trace
	mount $dev $mnt -o enospc_debug
	sync
	touch $mnt/file1
	touch $mnt/file2
	touch $mnt/file3
	xfs_io -f -c "pwrite 0 16k" $mnt/file4
	umount $mnt
	end_trace
   It's not recommended to use them in real world environment.

2) No way to distinguish between different btrfs filesystems
   Due to the fact that we can't get fs_info easily from extent_io_tree,
   there is no way to distinguish events from different fses.
   To avoid extra noise, please ensure there is only one btrfs in your
   test environment.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c         |   4 +
 include/trace/events/btrfs.h | 151 +++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b1d76261e53..421417e4eb11 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -580,6 +580,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int clear = 0;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
+	trace_btrfs_clear_extent_bit(tree, start, end - start + 1, bits);
 
 	if (bits & EXTENT_DELALLOC)
 		bits |= EXTENT_NORESERVE;
@@ -850,6 +851,7 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_end;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
+	trace_btrfs_set_extent_bit(tree, start, end - start + 1, bits);
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
@@ -1083,6 +1085,8 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	bool first_iteration = true;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
+	trace_btrfs_convert_extent_bit(tree, start, end - start + 1, bits,
+				       clear_bits);
 
 again:
 	if (!prealloc) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 2887503e4d12..4c8e4c60c422 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -27,6 +27,7 @@ struct btrfs_work;
 struct __btrfs_workqueue;
 struct btrfs_qgroup_extent_record;
 struct btrfs_qgroup;
+struct extent_io_tree;
 struct prelim_ref;
 
 TRACE_DEFINE_ENUM(FLUSH_DELAYED_ITEMS_NR);
@@ -77,6 +78,17 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 		{ BTRFS_QGROUP_RSV_META_PERTRANS, "META_PERTRANS" },	\
 		{ BTRFS_QGROUP_RSV_META_PREALLOC, "META_PREALLOC" })
 
+#define show_extent_io_tree_owner(owner)				\
+	__print_symbolic(owner,						\
+		{ IO_TREE_FS_INFO_FREED_EXTENTS0, "FREED_EXTENTS0" },	\
+		{ IO_TREE_FS_INFO_FREED_EXTENTS1, "FREED_EXTENTS1" },	\
+		{ IO_TREE_INODE_IO_TREE,	 "INODE_IO_TREE" },	\
+		{ IO_TREE_INODE_IO_FAILURE_TREE, "INODE_IO_FAILURE" },	\
+		{ IO_TREE_RELOCATION_PROCESSED_BLOCKS, "RELOCATION" },	\
+		{ IO_TREE_TRANSACTION_DIRTY_PAGES, "TRANS_DIRTY_PAGES" },\
+		{ IO_TREE_ROOT_DIRTY_LOG_PAGES, "ROOT_DIRTY_LOG" },	\
+		{ IO_TREE_TMP })
+
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
 	{ BTRFS_BLOCK_GROUP_SYSTEM,	"SYSTEM"},	\
@@ -88,6 +100,25 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 	{ BTRFS_BLOCK_GROUP_RAID5,	"RAID5"},	\
 	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
 
+#define EXTENT_FLAGS					\
+	{ EXTENT_DIRTY,		"DIRTY"},		\
+	{ EXTENT_WRITEBACK,	"WRITEBACK"},		\
+	{ EXTENT_UPTODATE,	"UPTODATE"},		\
+	{ EXTENT_LOCKED,	"LOCKED"},		\
+	{ EXTENT_NEW,		"NEW"},			\
+	{ EXTENT_DELALLOC,	"DELALLOC"},		\
+	{ EXTENT_DEFRAG,	"DEFRAG"},		\
+	{ EXTENT_BOUNDARY,	"BOUNDARY"},		\
+	{ EXTENT_NODATASUM,	"NODATASUM"},		\
+	{ EXTENT_CLEAR_META_RESV,"CLEAR_META_RSV"},	\
+	{ EXTENT_FIRST_DELALLOC,"FIRST_DELALLOC"},	\
+	{ EXTENT_NEED_WAIT,	"NEED_WAIT"},		\
+	{ EXTENT_DAMAGED,	"DAMAGED"},		\
+	{ EXTENT_NORESERVE,	"NORESERVE"},		\
+	{ EXTENT_QGROUP_RESERVED,"QGROUP_RESERVED"},	\
+	{ EXTENT_CLEAR_DATA_RESV,"CLEAR_DATA_RESV"},	\
+	{ EXTENT_DELALLOC_NEW,	"DELALLOC_NEW"}
+
 #define BTRFS_FSID_SIZE 16
 #define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_FSID_SIZE)
 
@@ -1878,6 +1909,126 @@ DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
 	TP_ARGS(bg_cache)
 );
 
+TRACE_EVENT(btrfs_set_extent_bit,
+	TP_PROTO(const struct extent_io_tree *tree,
+		 u64 start, u64 len, unsigned set_bits),
+
+	TP_ARGS(tree, start, len, set_bits),
+
+	TP_STRUCT__entry(
+		__field(	unsigned,	owner	)
+		__field(	u64,		ino	)
+		__field(	u64,		rootid	)
+		__field(	u64,		start	)
+		__field(	u64,		len	)
+		__field(	unsigned,	set_bits)
+	),
+
+	TP_fast_assign(
+		__entry->owner	= tree->owner;
+		if (tree->private_data) {
+			struct inode *inode = tree->private_data;
+
+			__entry->ino	= inode->i_ino;
+			__entry->rootid	=
+				BTRFS_I(inode)->root->root_key.objectid;
+		} else {
+			__entry->ino	= 0;
+			__entry->rootid	= 0;
+		}
+		__entry->start		= start;
+		__entry->len		= len;
+		__entry->set_bits	= set_bits;
+	),
+
+	TP_printk(
+"io_tree=%s ino=%llu root=%llu start=%llu len=%llu set_bits=%s",
+		  show_extent_io_tree_owner(__entry->owner), __entry->ino,
+		  __entry->rootid, __entry->start, __entry->len,
+		  __print_flags(__entry->set_bits, "|", EXTENT_FLAGS))
+);
+
+TRACE_EVENT(btrfs_clear_extent_bit,
+	TP_PROTO(const struct extent_io_tree *tree,
+		 u64 start, u64 len, unsigned clear_bits),
+
+	TP_ARGS(tree, start, len, clear_bits),
+
+	TP_STRUCT__entry(
+		__field(	unsigned,	owner	)
+		__field(	u64,		ino	)
+		__field(	u64,		rootid	)
+		__field(	u64,		start	)
+		__field(	u64,		len	)
+		__field(	unsigned,	clear_bits)
+	),
+
+	TP_fast_assign(
+		__entry->owner	= tree->owner;
+		if (tree->private_data) {
+			struct inode *inode = tree->private_data;
+
+			__entry->ino	= inode->i_ino;
+			__entry->rootid	=
+				BTRFS_I(inode)->root->root_key.objectid;
+		} else {
+			__entry->ino	= 0;
+			__entry->rootid	= 0;
+		}
+		__entry->start		= start;
+		__entry->len		= len;
+		__entry->clear_bits	= clear_bits;
+	),
+
+	TP_printk(
+"io_tree=%s ino=%llu root=%llu start=%llu len=%llu clear_bits=%s",
+		  show_extent_io_tree_owner(__entry->owner), __entry->ino,
+		  __entry->rootid, __entry->start, __entry->len,
+		  __print_flags(__entry->clear_bits, "|", EXTENT_FLAGS))
+);
+
+TRACE_EVENT(btrfs_convert_extent_bit,
+	TP_PROTO(const struct extent_io_tree *tree,
+		 u64 start, u64 len, unsigned set_bits, unsigned clear_bits),
+
+	TP_ARGS(tree, start, len, set_bits, clear_bits),
+
+	TP_STRUCT__entry(
+		__field(	unsigned,	owner	)
+		__field(	u64,		ino	)
+		__field(	u64,		rootid	)
+		__field(	u64,		start	)
+		__field(	u64,		len	)
+		__field(	unsigned,	set_bits)
+		__field(	unsigned,	clear_bits)
+	),
+
+	TP_fast_assign(
+		__entry->owner	= tree->owner;
+		if (tree->private_data) {
+			struct inode *inode = tree->private_data;
+
+			__entry->ino	= inode->i_ino;
+			__entry->rootid	=
+				BTRFS_I(inode)->root->root_key.objectid;
+		} else {
+			__entry->ino	= 0;
+			__entry->rootid	= 0;
+		}
+		__entry->start		= start;
+		__entry->len		= len;
+		__entry->set_bits	= set_bits;
+		__entry->clear_bits	= clear_bits;
+	),
+
+	TP_printk(
+"io_tree=%s ino=%llu root=%llu start=%llu len=%llu set_bits=%s clear_bits=%s",
+		  show_extent_io_tree_owner(__entry->owner), __entry->ino,
+		  __entry->rootid, __entry->start, __entry->len,
+		  __print_flags(__entry->set_bits , "|", EXTENT_FLAGS),
+		  __print_flags(__entry->clear_bits, "|", EXTENT_FLAGS))
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.21.0

