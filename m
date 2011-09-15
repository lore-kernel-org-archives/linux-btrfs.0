From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 17/20] btrfs: make add_delayed_tree_ref() void
Date: Thu, 15 Sep 2011 10:34:56 -0700
Message-ID: <1316108099-5099-18-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

add_delayed_tree_ref() unconditionally returns 0. This makes it trivial to
turn into a void function. This kills another BUG_ON().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/delayed-ref.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b5c3d7c..afe1b1e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -467,10 +467,10 @@ static noinline void add_delayed_ref_head(struct btrfs_trans_handle *trans,
 /*
  * helper to insert a delayed tree ref into the rbtree.
  */
-static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
-					 struct btrfs_delayed_ref_node *ref,
-					 u64 bytenr, u64 num_bytes, u64 parent,
-					 u64 ref_root, int level, int action)
+static void add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+				 struct btrfs_delayed_ref_node *ref,
+				 u64 bytenr, u64 num_bytes, u64 parent,
+				 u64 ref_root, int level, int action)
 {
 	struct btrfs_delayed_ref_node *existing;
 	struct btrfs_delayed_tree_ref *full_ref;
@@ -515,7 +515,6 @@ static noinline int add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 		delayed_refs->num_entries++;
 		trans->delayed_ref_updates++;
 	}
-	return 0;
 }
 
 /*
@@ -587,7 +586,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	int ret;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmalloc(sizeof(*ref), GFP_NOFS);
@@ -612,9 +610,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	add_delayed_ref_head(trans, &head_ref->node, bytenr, num_bytes, action,
 			     0);
 
-	ret = add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes,
-				   parent, ref_root, level, action);
-	BUG_ON(ret);
+	add_delayed_tree_ref(trans, &ref->node, bytenr, num_bytes, parent,
+			     ref_root, level, action);
+
 	spin_unlock(&delayed_refs->lock);
 	return 0;
 }
-- 
1.7.6

