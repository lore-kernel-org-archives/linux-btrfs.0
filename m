Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751008AbdHSJDo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Aug 2017 05:03:44 -0400
Subject: Re: [PATCH] btrfs: change how we decide to commit transactions during
 flushing
To: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1503086959-23467-1-git-send-email-jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d773e3e1-4117-eb5d-fff7-205a47e3c5b8@suse.com>
Date: Sat, 19 Aug 2017 12:03:41 +0300
MIME-Version: 1.0
In-Reply-To: <1503086959-23467-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.08.2017 23:09, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Nikolay reported that generic/273 was failing currently with ENOSPC.
> Turns out this is because we get to the point where the outstanding
> reservations are greater than the pinned space on the fs.  This is a
> mistake, previously we used the current reservation amount in
> may_commit_transaction, not the entire outstanding reservation amount.
> Fix this to find the minimum byte size needed to make progress in
> flushing, and pass that into may_commit_transaction.  From there we can
> make a smarter decision on whether to commit the transaction or not.
> This fixes the failure in generic/273.
> 

How about achieving the same end-goal with this diff. E.g. localising
the changes in may_commit transaction?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6ca75dc62a3c..49629266f824 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4837,6 +4837,13 @@ static void shrink_delalloc(struct btrfs_fs_info
*fs_info, u64 to_reclaim,
        }
 }

+struct reserve_ticket {
+       u64 bytes;
+       int error;
+       struct list_head list;
+       wait_queue_head_t wait;
+};
+
 /**
  * maybe_commit_transaction - possibly commit the transaction if its ok to
  * @root - the root we're allocating for
@@ -4873,9 +4880,24 @@ static int may_commit_transaction(struct
btrfs_fs_info *fs_info,
        if (space_info != delayed_rsv->space_info)
                return -ENOSPC;

+       spin_lock(&space_info->lock);
+       if (!list_empty(&space_info->tickets))
+               bytes = list_first_entry(&space_info->tickets,
+                                        struct reserve_ticket,
+                                        list)->bytes;
+       else if (!list_empty(&space_info->priority_tickets))
+                bytes = list_first_entry(&space_info->priority_tickets,
+                                         struct reserve_ticket,
+                                         list)->bytes;
+       spin_unlock(&space_info->lock);
+
        spin_lock(&delayed_rsv->lock);
+       if (delayed_rsv->size > bytes)
+               bytes = 0;
+       else
+               bytes -= delayed_rsv->size;
        if (percpu_counter_compare(&space_info->total_bytes_pinned,
-                                  bytes - delayed_rsv->size) < 0) {
+                                  bytes) < 0) {
                spin_unlock(&delayed_rsv->lock);
                return -ENOSPC;
        }
@@ -4889,13 +4911,6 @@ static int may_commit_transaction(struct
btrfs_fs_info *fs_info,
        return btrfs_commit_transaction(trans);
 }

-struct reserve_ticket {
-       u64 bytes;
-       int error;
-       struct list_head list;
-       wait_queue_head_t wait;
-};
-
 /*
  * Try to flush some data based on policy set by @state. This is only
advisory
  * and may fail for various reasons. The caller is supposed to examine the

