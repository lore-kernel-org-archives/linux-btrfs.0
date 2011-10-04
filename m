From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 53/65] btrfs: Fix kfree of member instead of structure
Date: Mon, 03 Oct 2011 23:23:23 -0400
Message-ID: <20111004032305.990631851@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
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
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -455,7 +455,7 @@ static noinline void add_delayed_ref_hea
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(head_ref);
 	} else {
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
@@ -510,7 +510,7 @@ static noinline void add_delayed_tree_re
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -565,7 +565,7 @@ static noinline void add_delayed_data_re
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;



