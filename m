Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48883 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752814AbcIUDQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:30 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 11/14] btrfs-progs: check: introduce low_memory mode fs_tree check
Date: Wed, 21 Sep 2016 11:16:01 +0800
Message-Id: <20160921031604.23334-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_fs_roots_v2() for check fs_tree in
low_memory mode. It call check_fs_root_v2() to check fs_root, and call
check_root_ref() to check root_ref.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 100 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7593013..934a3dd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4774,8 +4774,8 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 	struct btrfs_key key;
 	struct btrfs_root_ref *ref;
 	struct btrfs_root_ref *backref;
-	char ref_name[BTRFS_NAME_LEN];
-	char backref_name[BTRFS_NAME_LEN];
+	char ref_name[BTRFS_NAME_LEN] = {0};
+	char backref_name[BTRFS_NAME_LEN] = {0};
 	u64 ref_dirid;
 	u64 ref_seq;
 	u32 ref_namelen;
@@ -4850,6 +4850,94 @@ out:
 	return err;
 }
 
+/*
+ * Check all fs/file tree in low_memory mode.
+ *
+ * 1. for fs tree root item, call check_fs_root_v2()
+ * 2. for fs tree root ref/backref, call check_root_ref()
+ *
+ * Return 0 if no error occurred.
+ */
+static int check_fs_roots_v2(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *cur_root = NULL;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *node;
+	unsigned int ext_ref;
+	int slot;
+	int ret;
+	int err = 0;
+
+	ext_ref = btrfs_fs_incompat(fs_info,
+				    BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_FS_TREE_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	} else if (ret > 0) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	while (1) {
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
+			goto out;
+		if (key.type == BTRFS_ROOT_ITEM_KEY &&
+		    fs_root_objectid(key.objectid)) {
+			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+				cur_root = btrfs_read_fs_root_no_cache(fs_info,
+								       &key);
+			} else {
+				key.offset = (u64)-1;
+				cur_root = btrfs_read_fs_root(fs_info, &key);
+			}
+
+			if (IS_ERR(cur_root)) {
+				error("Fail to read fs/subvol tree: %lld",
+				      key.objectid);
+				err = -EIO;
+				goto next;
+			}
+
+			ret = check_fs_root_v2(cur_root, ext_ref);
+			err |= ret;
+
+			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+				btrfs_free_fs_root(cur_root);
+		} else if (key.type == BTRFS_ROOT_REF_KEY ||
+				key.type == BTRFS_ROOT_BACKREF_KEY) {
+			ret = check_root_ref(tree_root, &key, node, slot);
+			err |= ret;
+		}
+next:
+		ret = btrfs_next_item(tree_root, path);
+		if (ret > 0)
+			goto out;
+		if (ret < 0) {
+			err = ret;
+			goto out;
+		}
+	}
+
+out:
+	btrfs_free_path(path);
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct list_head *cur = rec->backrefs.next;
@@ -12544,7 +12632,10 @@ int cmd_check(int argc, char **argv)
 				     BTRFS_FEATURE_INCOMPAT_NO_HOLES);
 	if (!ctx.progress_enabled)
 		fprintf(stderr, "checking fs roots\n");
-	ret = check_fs_roots(root, &root_cache);
+	if (check_mode == CHECK_MODE_LOWMEM)
+		ret = check_fs_roots_v2(root->fs_info);
+	else
+		ret = check_fs_roots(root, &root_cache);
 	if (ret)
 		goto out;
 
@@ -12554,9 +12645,12 @@ int cmd_check(int argc, char **argv)
 		goto out;
 
 	fprintf(stderr, "checking root refs\n");
-	ret = check_root_refs(root, &root_cache);
-	if (ret)
-		goto out;
+	/* For low memory mode, check_fs_roots_v2 handles root refs */
+	if (check_mode != CHECK_MODE_LOWMEM) {
+		ret = check_root_refs(root, &root_cache);
+		if (ret)
+			goto out;
+	}
 
 	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
 		struct extent_buffer *eb;
-- 
2.10.0



