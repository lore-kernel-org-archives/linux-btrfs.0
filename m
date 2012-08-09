Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50160 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2HIGQz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 02:16:55 -0400
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: mitch.harder@sabayonlinux.org, jbacik@fusionio.com
Subject: [PATCH v2] Btrfs: fix race in run_clustered_refs
Date: Thu,  9 Aug 2012 08:16:53 +0200
Message-Id: <1344493013-8637-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With commit

commit d1270cd91f308c9d22b2804720c36ccd32dbc35e
Author: Arne Jansen <sensille@gmx.net>
Date:   Tue Sep 13 15:16:43 2011 +0200

     Btrfs: put back delayed refs that are too new
    
I added a window where the delayed_ref's head->ref_mod code can diverge
from the sum of the remaining refs, because we release the head->mutex
in the middle. This leads to btrfs_lookup_extent_info returning wrong
numbers. This patch fixes this by adjusting the head's ref_mod with each
delayed ref we run.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---

Changes v1->v2:
   Changed commit message. As Josef pointed out the race is new and has
   not been present before d1270cd9. The code is unchanged.

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

