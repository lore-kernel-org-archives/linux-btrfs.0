Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:60866 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2HHTtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 15:49:08 -0400
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: mitch.harder@sabayonlinux.org
Subject: [PATCH] Btrfs: fix race in run_clustered refs
Date: Wed,  8 Aug 2012 21:49:06 +0200
Message-Id: <1344455346-7578-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

run_clustered_refs runs all delayed refs for one head one by one. During
the runs, the delayed_refs->lock is released. In this window, the ref_mod
from the head does not match the sum of all refs below the head. When
btrfs_lookup_extent_info is run in this window, it gives inconsistent
results.
The qgroups patch added code to put delayed refs back, thus opening this
window very wide.
This patch assures that head->ref_mod always matches the queued refs, but
a window still remains where on-disk refs + delayed_refs miss the ref
currently being run.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e66dc9a..60d175a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2318,6 +2318,23 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
+		if (locked_ref) {
+			/*
+			 * when we play the delayed ref, also correct the
+			 * ref_mod on head
+			 */
+			switch (ref->action) {
+			case BTRFS_ADD_DELAYED_REF:
+			case BTRFS_ADD_DELAYED_EXTENT:
+				locked_ref->node.ref_mod -= ref->ref_mod;
+				break;
+			case BTRFS_DROP_DELAYED_REF:
+				locked_ref->node.ref_mod += ref->ref_mod;
+				break;
+			default:
+				WARN_ON(1);
+			}
+		}
 		spin_unlock(&delayed_refs->lock);
 
 		ret = run_one_delayed_ref(trans, root, ref, extent_op,
-- 
1.7.7.3

