From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 74/99] btrfs: Fix kfree of member instead of structure
Date: Wed, 23 Nov 2011 19:36:47 -0500
Message-ID: <20111124004228.383044261@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Correctness fix: The kfree calls in the add_delayed_* functions free
 the node that's passed into it, but the node is a member of another
 structure. It works because it's always the first member of the
 containing structure, but it should really be using the containing
 structure itself.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b004960..e388ca3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -455,7 +455,7 @@ static noinline void add_delayed_ref_head(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(head_ref);
 	} else {
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
@@ -510,7 +510,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -565,7 +565,7 @@ static noinline void add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;



