Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36037 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdI2ToZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:25 -0400
Received: by mail-qk0-f194.google.com with SMTP id z14so406565qkg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:24 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 11/21] btrfs: move ref_mod modification into the if (ref) logic
Date: Fri, 29 Sep 2017 15:43:55 -0400
Message-Id: <1506714245-23072-12-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We only use this logic if our ref isn't a ref_head, so move it up into
the if (ref) case since we know that this is a normal ref and not a
delayed ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bae2eac11db7..ac1196af6b7e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2745,10 +2745,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			list_del(&ref->list);
 			if (!list_empty(&ref->add_list))
 				list_del(&ref->add_list);
-		}
-		atomic_dec(&delayed_refs->num_entries);
-
-		if (!btrfs_delayed_ref_is_head(ref)) {
 			/*
 			 * when we play the delayed ref, also correct the
 			 * ref_mod on head
@@ -2765,6 +2761,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				WARN_ON(1);
 			}
 		}
+		atomic_dec(&delayed_refs->num_entries);
+
 		/*
 		 * record the must insert reserved flag before we
 		 * drop the spin lock.
-- 
2.7.4

