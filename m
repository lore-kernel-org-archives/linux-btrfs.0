Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:55990 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdI2ToM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:12 -0400
Received: by mail-qt0-f195.google.com with SMTP id x54so896531qth.12
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 02/21] btrfs: add tracepoints for outstanding extents mods
Date: Fri, 29 Sep 2017 15:43:46 -0400
Message-Id: <1506714245-23072-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is handy for tracing problems with modifying the outstanding
extents counters.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/btrfs_inode.h       |  2 ++
 include/trace/events/btrfs.h | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a6a22ef41f91..22daa79e77b8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -274,6 +274,8 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 	inode->outstanding_extents += mod;
 	if (btrfs_is_free_space_inode(inode))
 		return;
+	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
+						  mod);
 }
 
 static inline void btrfs_mod_reserved_extents(struct btrfs_inode *inode,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 77437f545c63..f0a374a720b0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1698,6 +1698,27 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_insert,
 	TP_ARGS(fs_info, oldref, newref, tree_size)
 );
 
+TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
+	TP_PROTO(struct btrfs_root *root, u64 ino, int mod),
+
+	TP_ARGS(root, ino, mod),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64, root_objectid	)
+		__field(	u64, ino		)
+		__field(	int, mod		)
+	),
+
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->root_objectid	= root->objectid;
+		__entry->ino		= ino;
+		__entry->mod		= mod;
+	),
+
+	TP_printk_btrfs("root = %llu(%s) ino = %llu mod = %d",
+			show_root_type(__entry->root_objectid),
+			(unsigned long long)__entry->ino, __entry->mod)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.7.4

