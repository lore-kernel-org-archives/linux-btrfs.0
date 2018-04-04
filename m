Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41913 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbeDDM5p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Apr 2018 08:57:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D583EAF05
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 12:57:43 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Drop delayed_refs argument from btrfs_check_delayed_seq
Date: Wed,  4 Apr 2018 15:57:42 +0300
Message-Id: <1522846662-30109-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's used to print its pointer in a debug statement but doesn't really
bring any useful information to the error message.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 9 +++------
 fs/btrfs/delayed-ref.h | 4 +---
 fs/btrfs/extent-tree.c | 2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 2677257c149d..5ac2d7909782 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -336,9 +336,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 }
 
-int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
-			    struct btrfs_delayed_ref_root *delayed_refs,
-			    u64 seq)
+int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq)
 {
 	struct seq_list *elem;
 	int ret = 0;
@@ -349,10 +347,9 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 					struct seq_list, list);
 		if (seq >= elem->seq) {
 			btrfs_debug(fs_info,
-				"holding back delayed_ref %#x.%x, lowest is %#x.%x (%p)",
+				"holding back delayed_ref %#x.%x, lowest is %#x.%x",
 				(u32)(seq >> 32), (u32)seq,
-				(u32)(elem->seq >> 32), (u32)elem->seq,
-				delayed_refs);
+				(u32)(elem->seq >> 32), (u32)elem->seq);
 			ret = 1;
 		}
 	}
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 9e3e5aff0937..cdf4a94ce5c1 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -280,9 +280,7 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 struct btrfs_delayed_ref_head *
 btrfs_select_ref_head(struct btrfs_trans_handle *trans);
 
-int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
-			    struct btrfs_delayed_ref_root *delayed_refs,
-			    u64 seq);
+int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
 
 /*
  * helper functions to cast a node into its container
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d83d449e749a..80ed159b0991 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2718,7 +2718,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		ref = select_delayed_ref(locked_ref);
 
 		if (ref && ref->seq &&
-		    btrfs_check_delayed_seq(fs_info, delayed_refs, ref->seq)) {
+		    btrfs_check_delayed_seq(fs_info, ref->seq)) {
 			spin_unlock(&locked_ref->lock);
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			locked_ref = NULL;
-- 
2.7.4

