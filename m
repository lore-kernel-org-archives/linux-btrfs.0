Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41648 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbeIKW6q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:58:46 -0400
Received: by mail-qt0-f195.google.com with SMTP id t39-v6so29163960qtc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 05/36] btrfs: only count ref heads run in __btrfs_run_delayed_refs
Date: Tue, 11 Sep 2018 13:57:36 -0400
Message-Id: <20180911175807.26181-6-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We pick the number of ref's to run based on the number of ref heads, and
only make the decision to stop once we've processed entire ref heads, so
only count the ref heads we've run and bail once we've hit the number of
ref heads we wanted to process.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 98f36dfeccb0..b32bd38390dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2592,6 +2592,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				spin_unlock(&delayed_refs->lock);
 				break;
 			}
+			count++;
 
 			/* grab the lock that says we are going to process
 			 * all the refs for this head */
@@ -2605,7 +2606,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			 */
 			if (ret == -EAGAIN) {
 				locked_ref = NULL;
-				count++;
 				continue;
 			}
 		}
@@ -2633,7 +2633,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			locked_ref = NULL;
 			cond_resched();
-			count++;
 			continue;
 		}
 
@@ -2651,7 +2650,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				return ret;
 			}
 			locked_ref = NULL;
-			count++;
 			continue;
 		}
 
@@ -2702,7 +2700,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		}
 
 		btrfs_put_delayed_ref(ref);
-		count++;
 		cond_resched();
 	}
 
-- 
2.14.3
