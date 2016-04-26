Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbcDZDth (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:37 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 16/16] btrfs-progs: fsck: Introduce low memory mode
Date: Tue, 26 Apr 2016 11:49:03 +0800
Message-Id: <1461642543-4621-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new fsck mode: low memory mode.

Old btrfsck is doing a quite efficient but uses some memory for each
extent item.
Old method will ensure extents are only iterated once at extent/chunk
tree check process.

But since it uses a little memory for each extent item, for large fs
with several TB metadata, this can easily eat up memory and cause OOM.

To handle such limitation and improve scalability, the new low-memory
mode will not use any heap memory to record which extent is checked.
Instead it will use extent backref to avoid most of uneeded check on
shared fs/subvolume tree blocks.
And with the use forward and backward reference cross check, we can also
ensure every tree block is at least checked once.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.asciidoc |  2 +
 cmds-check.c                       | 80 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index 7371a23..96eadc8 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -35,6 +35,8 @@ run in read-only mode (default)
 create a new CRC tree and recalculate all checksums
 --init-extent-tree::
 create a new extent tree
+--low-memory::
+check fs in low memory usage mode(experimental)
 --check-data-csum::
 verify checksums of data blocks
 -p|--progress::
diff --git a/cmds-check.c b/cmds-check.c
index 85d6cf4..e9d68dd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -71,6 +71,7 @@ static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
+static int low_memory = 0;
 static struct btrfs_fs_info *global_info;
 static struct task_ctx ctx = { 0 };
 static struct cache_tree *roots_info_cache = NULL;
@@ -9721,6 +9722,63 @@ static int traversal_tree_block(struct btrfs_root *root,
 	return -err;
 }
 
+/*
+ * Low memory usage version check_chunks_and_extents.
+ */
+static int check_chunks_and_extents_v2(struct btrfs_root *root)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root *root1;
+	struct btrfs_root *cur_root;
+	int err = 0;
+	int ret;
+
+	root1 = root->fs_info->chunk_root;
+	ret = traversal_tree_block(root1, root1->node);
+	err |= -ret;
+
+	root1 = root->fs_info->tree_root;
+	ret = traversal_tree_block(root1, root1->node);
+	err |= -ret;
+
+	btrfs_init_path(&path);
+	key.objectid = BTRFS_EXTENT_TREE_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, root1, &key, &path, 0, 0);
+	if (ret) {
+		error("couldn't find extent_tree_root from tree_root");
+		goto out;
+	}
+
+	while (1) {
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.type != BTRFS_ROOT_ITEM_KEY)
+			goto next;
+		key.offset = (u64)-1;
+
+		cur_root = btrfs_read_fs_root(root->fs_info, &key);
+		if (IS_ERR(cur_root) || !cur_root) {
+			error("Fail to read tree: %lld", key.objectid);
+			goto next;
+		}
+
+		ret = traversal_tree_block(cur_root, cur_root->node);
+		err |= ret;
+
+next:
+		ret = btrfs_next_item(root1, &path);
+		if (ret)
+			goto out;
+	}
+
+out:
+	btrfs_release_path(&path);
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
@@ -10837,6 +10895,7 @@ const char * const cmd_check_usage[] = {
 	"--readonly                  run in read-only mode (default)",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
+	"--low-memory                check in low memory usage mode(experimental)",
 	"--check-data-csum           verify checkums of data blocks",
 	"-Q|--qgroup-report           print a report on qgroup consistency",
 	"-E|--subvol-extents <subvolid>",
@@ -10868,7 +10927,8 @@ int cmd_check(int argc, char **argv)
 		int c;
 		enum { GETOPT_VAL_REPAIR = 257, GETOPT_VAL_INIT_CSUM,
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
-			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE };
+			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
+			GETOPT_VAL_LOW_MEMORY };
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -10886,6 +10946,8 @@ int cmd_check(int argc, char **argv)
 			{ "chunk-root", required_argument, NULL,
 				GETOPT_VAL_CHUNK_TREE },
 			{ "progress", no_argument, NULL, 'p' },
+			{ "low-memory", no_argument, NULL,
+				GETOPT_VAL_LOW_MEMORY },
 			{ NULL, 0, NULL, 0}
 		};
 
@@ -10950,6 +11012,9 @@ int cmd_check(int argc, char **argv)
 			case GETOPT_VAL_CHECK_CSUM:
 				check_data_csum = 1;
 				break;
+			case GETOPT_VAL_LOW_MEMORY:
+				low_memory = 1;
+				break;
 		}
 	}
 
@@ -10967,6 +11032,14 @@ int cmd_check(int argc, char **argv)
 		exit(1);
 	}
 
+	/*
+	 * Not supported yet
+	 */
+	if (repair && low_memory) {
+		error("Low memory mode doesn't support repair yet");
+		exit(1);
+	}
+
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
@@ -11090,7 +11163,10 @@ int cmd_check(int argc, char **argv)
 
 	if (!ctx.progress_enabled)
 		fprintf(stderr, "checking extents\n");
-	ret = check_chunks_and_extents(root);
+	if (low_memory)
+		ret = check_chunks_and_extents_v2(root);
+	else
+		ret = check_chunks_and_extents(root);
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
-- 
2.8.0



