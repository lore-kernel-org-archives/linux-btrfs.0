From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 04/10] Btrfs: always save ref_root in delayed refs
Date: Wed,  4 Jan 2012 18:35:42 +0100
Message-ID: <eebe063b7f916087cd5c61de57b20a3a30894a96.1325692561.git.list.btrfs@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

For consistent backref walking and (later) qgroup calculation the
information to which root a delayed ref belongs is useful even for shared
refs.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/delayed-ref.c |   18 ++++++++----------
 fs/btrfs/delayed-ref.h |   12 ++++--------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3a0f0ab..babd37b 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -495,13 +495,12 @@ static noinline int add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	ref->in_tree = 1;
 
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
-	if (parent) {
-		full_ref->parent = parent;
+	full_ref->parent = parent;
+	full_ref->root = ref_root;
+	if (parent)
 		ref->type = BTRFS_SHARED_BLOCK_REF_KEY;
-	} else {
-		full_ref->root = ref_root;
+	else
 		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
-	}
 	full_ref->level = level;
 
 	trace_btrfs_delayed_tree_ref(ref, full_ref, action);
@@ -551,13 +550,12 @@ static noinline int add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	ref->in_tree = 1;
 
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
-	if (parent) {
-		full_ref->parent = parent;
+	full_ref->parent = parent;
+	full_ref->root = ref_root;
+	if (parent)
 		ref->type = BTRFS_SHARED_DATA_REF_KEY;
-	} else {
-		full_ref->root = ref_root;
+	else
 		ref->type = BTRFS_EXTENT_DATA_REF_KEY;
-	}
 
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 8316bff..a5fb2bc 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -98,19 +98,15 @@ struct btrfs_delayed_ref_head {
 
 struct btrfs_delayed_tree_ref {
 	struct btrfs_delayed_ref_node node;
-	union {
-		u64 root;
-		u64 parent;
-	};
+	u64 root;
+	u64 parent;
 	int level;
 };
 
 struct btrfs_delayed_data_ref {
 	struct btrfs_delayed_ref_node node;
-	union {
-		u64 root;
-		u64 parent;
-	};
+	u64 root;
+	u64 parent;
 	u64 objectid;
 	u64 offset;
 };
-- 
1.7.3.4

