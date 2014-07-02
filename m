Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaGBVgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 17:36:39 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/3] btrfs: add trace for qgroup accounting
Date: Wed,  2 Jul 2014 14:35:17 -0700
Message-Id: <1404336919-26766-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1404336919-26766-1-git-send-email-mfasheh@suse.de>
References: <1404336919-26766-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want this to debug qgroup changes on live systems.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/qgroup.c            |  3 +++
 fs/btrfs/super.c             |  1 +
 include/trace/events/btrfs.h | 56 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cf5aead..a9f0f05 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1290,6 +1290,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
+	trace_btrfs_qgroup_record_ref(oper);
 	ret = insert_qgroup_oper(fs_info, oper);
 	if (ret) {
 		/* Shouldn't happen so have an assert for developers */
@@ -1909,6 +1910,8 @@ static int btrfs_qgroup_account(struct btrfs_trans_handle *trans,
 
 	ASSERT(is_fstree(oper->ref_root));
 
+	trace_btrfs_qgroup_account(oper);
+
 	switch (oper->type) {
 	case BTRFS_QGROUP_OPER_ADD_EXCL:
 	case BTRFS_QGROUP_OPER_SUB_EXCL:
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..ca7836c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -60,6 +60,7 @@
 #include "backref.h"
 #include "tests/btrfs-tests.h"
 
+#include "qgroup.h"
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 4ee4e30..b8774b3 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -23,6 +23,7 @@ struct map_lookup;
 struct extent_buffer;
 struct btrfs_work;
 struct __btrfs_workqueue;
+struct btrfs_qgroup_operation;
 
 #define show_ref_type(type)						\
 	__print_symbolic(type,						\
@@ -1119,6 +1120,61 @@ DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
 	TP_ARGS(wq)
 );
 
+#define show_oper_type(type)						\
+	__print_symbolic(type,						\
+		{ BTRFS_QGROUP_OPER_ADD_EXCL, 	"OPER_ADD_EXCL" },	\
+		{ BTRFS_QGROUP_OPER_ADD_SHARED, "OPER_ADD_SHARED" },	\
+		{ BTRFS_QGROUP_OPER_SUB_EXCL, 	"OPER_SUB_EXCL" },	\
+		{ BTRFS_QGROUP_OPER_SUB_SHARED,	"OPER_SUB_SHARED" })
+
+DECLARE_EVENT_CLASS(btrfs_qgroup_oper,
+
+	TP_PROTO(struct btrfs_qgroup_operation *oper),
+
+	TP_ARGS(oper),
+
+	TP_STRUCT__entry(
+		__field(	u64,  ref_root		)
+		__field(	u64,  bytenr		)
+		__field(	u64,  num_bytes		)
+		__field(	u64,  seq		)
+		__field(	int,  type		)
+		__field(	u64,  elem_seq		)
+	),
+
+	TP_fast_assign(
+		__entry->ref_root	= oper->ref_root;
+		__entry->bytenr		= oper->bytenr,
+		__entry->num_bytes	= oper->num_bytes;
+		__entry->seq 		= oper->seq;
+		__entry->type		= oper->type;
+		__entry->elem_seq	= oper->elem.seq;
+	),
+
+	TP_printk("ref_root = %llu, bytenr = %llu, num_bytes = %llu, "
+		  "seq = %llu, elem.seq = %llu, type = %s",
+		  (unsigned long long)__entry->ref_root,
+		  (unsigned long long)__entry->bytenr,
+		  (unsigned long long)__entry->num_bytes,
+		  (unsigned long long)__entry->seq,
+		  (unsigned long long)__entry->elem_seq,
+		  show_oper_type(__entry->type))
+);
+
+DEFINE_EVENT(btrfs_qgroup_oper, btrfs_qgroup_account,
+
+	TP_PROTO(struct btrfs_qgroup_operation *oper),
+
+	TP_ARGS(oper)
+);
+
+DEFINE_EVENT(btrfs_qgroup_oper, btrfs_qgroup_record_ref,
+
+	TP_PROTO(struct btrfs_qgroup_operation *oper),
+
+	TP_ARGS(oper)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
1.8.4.5

