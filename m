Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeHOKbH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 06:31:07 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C11F8AED2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 07:40:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Factor out loop processing all refs of a head
Date: Wed, 15 Aug 2018 10:39:55 +0300
Message-Id: <1534318796-23111-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1534318796-23111-1-git-send-email-nborisov@suse.com>
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a new helper encompassing the implicit inner loop
in __btrfs_run_delayed_refs which processes all the refs for a given
head. The code is mostly copy/paste, the only difference is that if we
detect a newer reference then -EAGAIN is returned so that callers can
react correctly. Also at the end of the loop the head is relocked and
btrfs_merge_delayed_refs is run again to retain the pre-refactoring
semantics.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6a2c86c8a756..165a29871814 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2536,6 +2536,85 @@ struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
 	return head;
 }
 
+STATIC
+int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
+				    struct btrfs_delayed_ref_head *locked_ref,
+				    unsigned long *run_refs)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_extent_op *extent_op;
+	struct btrfs_delayed_ref_node *ref;
+	int must_insert_reserved = 0;
+	int ret;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	while ((ref = select_delayed_ref(locked_ref))) {
+
+		if (ref->seq &&
+		    btrfs_check_delayed_seq(fs_info, ref->seq)) {
+			spin_unlock(&locked_ref->lock);
+			unselect_delayed_ref_head(delayed_refs, locked_ref);
+			return -EAGAIN;
+		}
+
+		(*run_refs)++;
+		ref->in_tree = 0;
+		rb_erase(&ref->ref_node, &locked_ref->ref_tree);
+		RB_CLEAR_NODE(&ref->ref_node);
+		if (!list_empty(&ref->add_list))
+			list_del(&ref->add_list);
+		/*
+		 * When we play the delayed ref, also correct the ref_mod on
+		 * head
+		 */
+		switch (ref->action) {
+		case BTRFS_ADD_DELAYED_REF:
+		case BTRFS_ADD_DELAYED_EXTENT:
+			locked_ref->ref_mod -= ref->ref_mod;
+			break;
+		case BTRFS_DROP_DELAYED_REF:
+			locked_ref->ref_mod += ref->ref_mod;
+			break;
+		default:
+			WARN_ON(1);
+		}
+		atomic_dec(&delayed_refs->num_entries);
+
+		/*
+		 * Record the must-insert_reserved flag before we drop the
+		 * spin lock.
+		 */
+		must_insert_reserved = locked_ref->must_insert_reserved;
+		locked_ref->must_insert_reserved = 0;
+
+		extent_op = locked_ref->extent_op;
+		locked_ref->extent_op = NULL;
+		spin_unlock(&locked_ref->lock);
+
+		ret = run_one_delayed_ref(trans, ref, extent_op,
+					  must_insert_reserved);
+
+		btrfs_free_delayed_extent_op(extent_op);
+		if (ret) {
+			unselect_delayed_ref_head(delayed_refs, locked_ref);
+			btrfs_put_delayed_ref(ref);
+			btrfs_debug(fs_info, "run_one_delayed_ref returned %d",
+				    ret);
+			return ret;
+		}
+
+		btrfs_put_delayed_ref(ref);
+		cond_resched();
+
+		spin_lock(&locked_ref->lock);
+		btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref);
+	}
+
+	return 0;
+}
+
 /*
  * Returns 0 on success or if called with an already aborted transaction.
  * Returns -ENOMEM or -EIO on failure and will abort the transaction.
-- 
2.7.4
