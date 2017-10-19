Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43966 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdJSSQJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:16:09 -0400
Received: by mail-qt0-f195.google.com with SMTP id j58so15596377qtj.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 11:16:08 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] btrfs: add tracepoints for outstanding extents mods
Date: Thu, 19 Oct 2017 14:15:56 -0400
Message-Id: <1508436962-6851-3-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
References: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
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
index e3ac29e72714..5ebeafc19936 100644
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
index bfe2f23b578c..567dcf2022bb 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1695,6 +1695,27 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_insert,
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
2.7.5

