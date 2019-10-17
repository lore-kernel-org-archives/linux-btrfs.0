Return-Path: <SRS0=AqV7=YK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55311FA3733
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A65B2089C
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439695AbfJQL2t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:28:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:52734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439692AbfJQL2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Oct 2019 07:28:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0880B372;
        Thu, 17 Oct 2019 11:28:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E7A89DA808; Thu, 17 Oct 2019 13:28:57 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: tracepoints: constify all pointers
Date:   Thu, 17 Oct 2019 13:28:57 +0200
Message-Id: <04f6c0d03c2b398ffdca28690824e843f06e46f0.1571311653.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1571311653.git.dsterba@suse.com>
References: <cover.1571311653.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We don't modify the data passed to tracepoints, some of the declarations
are already const, add it to the rest.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 include/trace/events/btrfs.h | 52 ++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 11e9a6cc7f63..92da846981ce 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -292,7 +292,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
 
 TRACE_EVENT(btrfs_handle_em_exist,
 
-	TP_PROTO(struct btrfs_fs_info *fs_info,
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
 		const struct extent_map *existing, const struct extent_map *map,
 		u64 start, u64 len),
 
@@ -330,8 +330,8 @@ TRACE_EVENT(btrfs_handle_em_exist,
 /* file extent item */
 DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, u64 start),
 
 	TP_ARGS(bi, l, fi, start),
 
@@ -385,8 +385,8 @@ DECLARE_EVENT_CLASS(btrfs__file_extent_item_regular,
 DECLARE_EVENT_CLASS(
 	btrfs__file_extent_item_inline,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, int slot, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, int slot, u64 start),
 
 	TP_ARGS(bi, l, fi, slot,  start),
 
@@ -426,8 +426,8 @@ DECLARE_EVENT_CLASS(
 DEFINE_EVENT(
 	btrfs__file_extent_item_regular, btrfs_get_extent_show_fi_regular,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, u64 start),
 
 	TP_ARGS(bi, l, fi, start)
 );
@@ -435,8 +435,8 @@ DEFINE_EVENT(
 DEFINE_EVENT(
 	btrfs__file_extent_item_regular, btrfs_truncate_show_fi_regular,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, u64 start),
 
 	TP_ARGS(bi, l, fi, start)
 );
@@ -444,8 +444,8 @@ DEFINE_EVENT(
 DEFINE_EVENT(
 	btrfs__file_extent_item_inline, btrfs_get_extent_show_fi_inline,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, int slot, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, int slot, u64 start),
 
 	TP_ARGS(bi, l, fi, slot, start)
 );
@@ -453,8 +453,8 @@ DEFINE_EVENT(
 DEFINE_EVENT(
 	btrfs__file_extent_item_inline, btrfs_truncate_show_fi_inline,
 
-	TP_PROTO(struct btrfs_inode *bi, struct extent_buffer *l,
-		 struct btrfs_file_extent_item *fi, int slot, u64 start),
+	TP_PROTO(const struct btrfs_inode *bi, const struct extent_buffer *l,
+		 const struct btrfs_file_extent_item *fi, int slot, u64 start),
 
 	TP_ARGS(bi, l, fi, slot, start)
 );
@@ -1018,7 +1018,7 @@ TRACE_EVENT(btrfs_cow_block,
 
 TRACE_EVENT(btrfs_space_reservation,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info, char *type, u64 val,
+	TP_PROTO(const struct btrfs_fs_info *fs_info, const char *type, u64 val,
 		 u64 bytes, int reserve),
 
 	TP_ARGS(fs_info, type, val, bytes, reserve),
@@ -1051,7 +1051,7 @@ TRACE_EVENT(btrfs_space_reservation,
 TRACE_EVENT(btrfs_trigger_flush,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 flags, u64 bytes,
-		 int flush, char *reason),
+		 int flush, const char *reason),
 
 	TP_ARGS(fs_info, flags, bytes, flush, reason),
 
@@ -1642,7 +1642,7 @@ TRACE_EVENT(btrfs_qgroup_account_extent,
 TRACE_EVENT(qgroup_update_counters,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info,
-		 struct btrfs_qgroup *qgroup,
+		 const struct btrfs_qgroup *qgroup,
 		 u64 cur_old_count, u64 cur_new_count),
 
 	TP_ARGS(fs_info, qgroup, cur_old_count, cur_new_count),
@@ -1822,7 +1822,7 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_insert,
 );
 
 TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
-	TP_PROTO(struct btrfs_root *root, u64 ino, int mod),
+	TP_PROTO(const struct btrfs_root *root, u64 ino, int mod),
 
 	TP_ARGS(root, ino, mod),
 
@@ -1903,7 +1903,7 @@ TRACE_EVENT(btrfs_set_extent_bit,
 	TP_fast_assign_btrfs(tree->fs_info,
 		__entry->owner = tree->owner;
 		if (tree->private_data) {
-			struct inode *inode = tree->private_data;
+			const struct inode *inode = tree->private_data;
 
 			__entry->ino	= btrfs_ino(BTRFS_I(inode));
 			__entry->rootid	=
@@ -1942,7 +1942,7 @@ TRACE_EVENT(btrfs_clear_extent_bit,
 	TP_fast_assign_btrfs(tree->fs_info,
 		__entry->owner = tree->owner;
 		if (tree->private_data) {
-			struct inode *inode = tree->private_data;
+			const struct inode *inode = tree->private_data;
 
 			__entry->ino	= btrfs_ino(BTRFS_I(inode));
 			__entry->rootid	=
@@ -1982,7 +1982,7 @@ TRACE_EVENT(btrfs_convert_extent_bit,
 	TP_fast_assign_btrfs(tree->fs_info,
 		__entry->owner = tree->owner;
 		if (tree->private_data) {
-			struct inode *inode = tree->private_data;
+			const struct inode *inode = tree->private_data;
 
 			__entry->ino	= btrfs_ino(BTRFS_I(inode));
 			__entry->rootid	=
@@ -2091,8 +2091,8 @@ DEFINE_BTRFS_LOCK_EVENT(btrfs_tree_read_lock_atomic);
 
 DECLARE_EVENT_CLASS(btrfs__space_info_update,
 
-	TP_PROTO(struct btrfs_fs_info *fs_info,
-		 struct btrfs_space_info *sinfo, u64 old, s64 diff),
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct btrfs_space_info *sinfo, u64 old, s64 diff),
 
 	TP_ARGS(fs_info, sinfo, old, diff),
 
@@ -2114,16 +2114,16 @@ DECLARE_EVENT_CLASS(btrfs__space_info_update,
 
 DEFINE_EVENT(btrfs__space_info_update, update_bytes_may_use,
 
-	TP_PROTO(struct btrfs_fs_info *fs_info,
-		 struct btrfs_space_info *sinfo, u64 old, s64 diff),
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct btrfs_space_info *sinfo, u64 old, s64 diff),
 
 	TP_ARGS(fs_info, sinfo, old, diff)
 );
 
 DEFINE_EVENT(btrfs__space_info_update, update_bytes_pinned,
 
-	TP_PROTO(struct btrfs_fs_info *fs_info,
-		 struct btrfs_space_info *sinfo, u64 old, s64 diff),
+	TP_PROTO(const struct btrfs_fs_info *fs_info,
+		 const struct btrfs_space_info *sinfo, u64 old, s64 diff),
 
 	TP_ARGS(fs_info, sinfo, old, diff)
 );
-- 
2.23.0

