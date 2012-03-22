From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 04/35] btrfs: Fix kfree of member instead of structure
Date: Wed, 21 Mar 2012 21:11:08 -0400
Message-ID: <20120322011133.538275590@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
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
index 66e4f29..29ecd54 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -487,7 +487,7 @@ static noinline int add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(head_ref);
 	} else {
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
@@ -549,7 +549,7 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
@@ -611,7 +611,7 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
 		 */
-		kfree(ref);
+		kfree(full_ref);
 	} else {
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
-- 
1.7.9



