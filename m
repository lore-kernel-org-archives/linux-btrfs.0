From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs-progs: fix btrfsck's snapshot wrong "unresolved
 refs"
Date: Thu, 23 Feb 2012 15:52:58 +0800
Message-ID: <4F45F05A.8050103@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the fs/file tree is not the parent of the snapshot, it is reasonable
that we can not find the relative reference and back reference. But btrfsck
doesn't consider this case, and reports "unresolved refs" message, it's wrong,
fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfsck.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 1935dd7..a8a8211 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -745,7 +745,65 @@ static int leave_shared_node(struct btrfs_root *root,
 	return 0;
 }
 
-static int process_dir_item(struct extent_buffer *eb,
+static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
+			 u64 child_root_id)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	int has_parent = 0;
+	int ret;
+
+	btrfs_init_path(&path);
+
+	key.objectid = parent_root_id;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = child_root_id;
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path,
+				0, 0);
+	BUG_ON(ret < 0);
+	btrfs_release_path(root, &path);
+	if (!ret)
+		return 1;
+
+	key.objectid = child_root_id;
+	key.type = BTRFS_ROOT_BACKREF_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path,
+				0, 0);
+	BUG_ON(ret <= 0);
+
+	while (1) {
+		leaf = path.nodes[0];
+		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root->fs_info->tree_root, &path);
+			BUG_ON(ret < 0);
+
+			if (ret > 0)
+				break;
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+		if (key.objectid != child_root_id ||
+		    key.type != BTRFS_ROOT_BACKREF_KEY)
+			break;
+
+		has_parent = 1;
+
+		if (key.offset == parent_root_id) {
+			btrfs_release_path(root, &path);
+			return 1;
+		}
+
+		path.slots[0]++;
+	}
+
+	btrfs_release_path(root, &path);
+	return has_parent? 0 : -1;
+}
+
+static int process_dir_item(struct btrfs_root *root,
+			    struct extent_buffer *eb,
 			    int slot, struct btrfs_key *key,
 			    struct shared_node *active_node)
 {
@@ -793,9 +851,13 @@ static int process_dir_item(struct extent_buffer *eb,
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
 		} else if (location.type == BTRFS_ROOT_ITEM_KEY) {
-			add_inode_backref(root_cache, location.objectid,
-					  key->objectid, key->offset, namebuf,
-					  len, filetype, key->type, error);
+			u64 parent = root->objectid;
+
+			if (is_child_root(root, parent, location.objectid))
+				add_inode_backref(root_cache, location.objectid,
+						  key->objectid, key->offset,
+						  namebuf, len, filetype,
+						  key->type, error);
 		} else {
 			fprintf(stderr, "warning line %d\n", __LINE__);
 		}
@@ -1026,7 +1088,7 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		switch (key.type) {
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
-			ret = process_dir_item(eb, i, &key, active_node);
+			ret = process_dir_item(root, eb, i, &key, active_node);
 			break;
 		case BTRFS_INODE_REF_KEY:
 			ret = process_inode_ref(eb, i, &key, active_node);
-- 
1.7.6.5
