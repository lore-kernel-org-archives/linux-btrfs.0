Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34303 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15-v6so17388844qkc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:57 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 25/36] btrfs: pass delayed_refs_root to btrfs_delayed_ref_lock
Date: Tue, 11 Sep 2018 13:57:56 -0400
Message-Id: <20180911175807.26181-26-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need the trans except to get the delayed_refs_root, so just
pass the delayed_refs_root into btrfs_delayed_ref_lock and call it a
day.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/delayed-ref.c | 5 +----
 fs/btrfs/delayed-ref.h | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 96ce087747b2..87778645bf4a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -197,12 +197,9 @@ find_ref_head(struct rb_root *root, u64 bytenr,
 	return NULL;
 }
 
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head)
 {
-	struct btrfs_delayed_ref_root *delayed_refs;
-
-	delayed_refs = &trans->transaction->delayed_refs;
 	lockdep_assert_held(&delayed_refs->lock);
 	if (mutex_trylock(&head->mutex))
 		return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 7769177b489e..ee636d7a710a 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -255,7 +255,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
 			    u64 bytenr);
-int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
+int btrfs_delayed_ref_lock(struct btrfs_delayed_ref_root *delayed_refs,
 			   struct btrfs_delayed_ref_head *head);
 static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
 {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5e928275826f..b68e3992e5e6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2600,7 +2600,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 			/* grab the lock that says we are going to process
 			 * all the refs for this head */
-			ret = btrfs_delayed_ref_lock(trans, locked_ref);
+			ret = btrfs_delayed_ref_lock(delayed_refs, locked_ref);
 			spin_unlock(&delayed_refs->lock);
 			/*
 			 * we may have dropped the spin lock to get the head
-- 
2.14.3
