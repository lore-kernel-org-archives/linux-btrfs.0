Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34435 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbeGSPdo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:44 -0400
Received: by mail-qt0-f196.google.com with SMTP id m13-v6so7421380qth.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:13 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/22] btrfs: only track ref_heads in delayed_ref_updates
Date: Thu, 19 Jul 2018 10:49:48 -0400
Message-Id: <20180719145006.17532-4-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  So instead track only the ref
heads added by this trans handle and adjust the counting appropriately
in __btrfs_run_delayed_refs.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 3 ---
 fs/btrfs/extent-tree.c | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e1b322d651dd..e5a8fb7ba9f6 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -234,8 +234,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -460,7 +458,6 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 33cd43dd73ee..168312ead4ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2667,6 +2667,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				spin_unlock(&delayed_refs->lock);
 				break;
 			}
+			count++;
 
 			/* grab the lock that says we are going to process
 			 * all the refs for this head */
@@ -2680,7 +2681,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			 */
 			if (ret == -EAGAIN) {
 				locked_ref = NULL;
-				count++;
 				continue;
 			}
 		}
@@ -2708,7 +2708,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			locked_ref = NULL;
 			cond_resched();
-			count++;
 			continue;
 		}
 
@@ -2726,7 +2725,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				return ret;
 			}
 			locked_ref = NULL;
-			count++;
 			continue;
 		}
 
@@ -2777,7 +2775,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		}
 
 		btrfs_put_delayed_ref(ref);
-		count++;
 		cond_resched();
 	}
 
-- 
2.14.3

