Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752786AbeDSIGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 04:06:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B6234AEC4
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 08:06:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Drop fs_info parameter from btrfs_merge_delayed_refs
Date: Thu, 19 Apr 2018 11:06:39 +0300
Message-Id: <1524125199-5435-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1524125199-5435-1-git-send-email-nborisov@suse.com>
References: <1524125199-5435-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 2 +-
 fs/btrfs/delayed-ref.h | 1 -
 fs/btrfs/extent-tree.c | 3 +--
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index f343ee0b143a..51385c6edf04 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -286,10 +286,10 @@ static bool merge_ref(struct btrfs_trans_handle *trans,
 }
 
 void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info,
 			      struct btrfs_delayed_ref_root *delayed_refs,
 			      struct btrfs_delayed_ref_head *head)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_node *ref;
 	struct rb_node *node;
 	u64 seq = 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e2e4f3f703c2..9c03f914577c 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -250,7 +250,6 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				u64 bytenr, u64 num_bytes,
 				struct btrfs_delayed_extent_op *extent_op);
 void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info,
 			      struct btrfs_delayed_ref_root *delayed_refs,
 			      struct btrfs_delayed_ref_head *head);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9749d781f1f3..afcd16ee39f2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2697,8 +2697,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 * insert_inline_extent_backref()).
 		 */
 		spin_lock(&locked_ref->lock);
-		btrfs_merge_delayed_refs(trans, fs_info, delayed_refs,
-					 locked_ref);
+		btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref);
 
 		/*
 		 * locked_ref is the head node, so we have to go one
-- 
2.7.4

