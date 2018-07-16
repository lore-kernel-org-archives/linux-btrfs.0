Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44433 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727192AbeGPJdf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 05:33:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 14E844B5CC1C
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 17:07:05 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: inspect-internal: add option '-k u64,u8,u64' of dump-tree
Date: Mon, 16 Jul 2018 17:13:25 +0800
Message-ID: <20180716091325.12621-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For big filesystems, there are many items in trees(extent tree
specially).
For example, to dump one extent, we usually dump extent tree then pipe
result to grep. The time-consuming part is that dump tree traverses
items. And it eats cpu and memory too.

This patch introduces an option '-k u64,u8,u64' for users(developers more
likely) to appoint a specific key to search and dump, then the path
from root node down the leaf will be dumped.
The search of the key costs most time of this way.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Change log:
v2:
  Rename btrfs_search_spec_key() to btrfs_search_print_path().
  Rename is_key_spec to is_spec_key_set.
  Move btrfs_search_print_path() after open_ctree(), call it only once.
  Remove duplicate code and replaced with btrfs_print_tree().
  Modify the usage about '-k'.
  All are suggested by Qu Wenruo.
  
 cmds-inspect-dump-tree.c | 41 ++++++++++++++++++++-
 print-tree.c             | 77 ++++++++++++++++++++++++++++++++++++++++
 print-tree.h             |  2 ++
 3 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index c8acd55a0c3a..80df826af0fd 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -184,6 +184,21 @@ static u64 treeid_from_string(const char *str, const char **end)
 	return id;
 }
 
+static int parse_key(struct btrfs_key *key)
+{
+
+	int ret = sscanf(optarg, "%llu,%hhu,%llu", &key->objectid,
+			 &key->type, &key->offset);
+	if (ret != 3) {
+		error("error parsing key '%s'\n", optarg);
+		ret = -EINVAL;
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
 const char * const cmd_inspect_dump_tree_usage[] = {
 	"btrfs inspect-internal dump-tree [options] device",
 	"Dump tree structures from a given device",
@@ -199,6 +214,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	"-u|--uuid              print only the uuid tree",
 	"-b|--block <block_num> print info from the specified block only",
 	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
+	"-k|--key <u64,u8,u64>  search the specific key then print path, must with -t(conflicts with others)",
 	"--follow               use with -b, to show all children tree blocks of <block_num>",
 	NULL
 };
@@ -224,8 +240,10 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	unsigned open_ctree_flags;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
+	struct btrfs_key spec_key = { 0 };
 	u64 tree_id = 0;
 	bool follow = false;
+	bool is_spec_key_set = false;
 
 	/*
 	 * For debug-tree, we care nothing about extent tree (it's just backref
@@ -248,10 +266,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			{ "block", required_argument, NULL, 'b'},
 			{ "tree", required_argument, NULL, 't'},
 			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
+			{ "key", required_argument, NULL, 'k'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "deb:rRut:", long_options, NULL);
+		c = getopt_long(argc, argv, "deb:rRut:k:", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -300,6 +319,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 			}
 			break;
 			}
+		case 'k':
+			ret = parse_key(&spec_key);
+			if (ret)
+				exit(1);
+			is_spec_key_set = true;
+			break;
 		case GETOPT_VAL_FOLLOW:
 			follow = true;
 			break;
@@ -308,6 +333,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		}
 	}
 
+	if (!tree_id && is_spec_key_set)
+		usage(cmd_inspect_dump_tree_usage);
+
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_inspect_dump_tree_usage);
 
@@ -325,6 +353,17 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		goto out;
 	}
 
+	if (is_spec_key_set) {
+		root = info->tree_root;
+		if (IS_ERR(root) || !root) {
+			ret = root ? PTR_ERR(root) : -1;
+			error("unable to open %s", argv[optind]);
+			goto out;
+		}
+
+		btrfs_search_print_path(info, tree_id, &spec_key);
+		goto close_root;
+	}
 	if (block_only) {
 		root = info->chunk_root;
 		leaf = read_tree_block(info, block_only, 0);
diff --git a/print-tree.c b/print-tree.c
index a09ecfbb28f0..3868e42d5d29 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1459,3 +1459,80 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 
 	return;
 }
+
+void btrfs_search_print_path(struct btrfs_fs_info *fs_info, u64 root_objectid,
+			     struct btrfs_key *skey)
+{
+	int ret;
+	int level;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct extent_buffer *next;
+	struct extent_buffer *eb;
+	struct btrfs_path path;
+
+	key.objectid = root_objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		root = btrfs_read_fs_root_no_cache(fs_info, &key);
+	else
+		root = btrfs_read_fs_root(fs_info, &key);
+
+	if (IS_ERR(root) || !root) {
+		error("failed to read tree: %lld", key.objectid);
+		return;
+	}
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, skey, &path, 0, 0);
+	if (ret < 0) {
+		error("error search the key [%llu, %u, %llu] in root %llu",
+		      skey->objectid, skey->type, skey->offset, root->objectid);
+		goto out;
+	}
+
+	if (ret > 0) {
+		if (path.slots[0] > btrfs_header_nritems(path.nodes[0])) {
+			ret = btrfs_next_item(root, &path);
+			if (ret) {
+				error(
+	"error search the key [%llu, %u, %llu] in root %llu, no next key",
+					skey->objectid, skey->type,
+					skey->offset, root->objectid);
+				goto out;
+			}
+		}
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		printf("next to search key is [%llu, %u, %llu]\n",
+		       key.objectid, key.type, key.offset);
+	}
+
+	level = btrfs_header_level(root->node);
+	for (; level >= 0 ; level--) {
+		eb = path.nodes[level];
+		next = path.nodes[level - 1];
+
+		btrfs_print_tree(path.nodes[level], 0);
+
+		if (level == 0)
+			break;
+		if (btrfs_header_level(next) != btrfs_header_level(eb) - 1) {
+			warning(
+				"eb corrupted: parent bytenr %llu slot %d level %d child bytenr %llu level has %d expect %d, skipping the slot",
+				btrfs_header_bytenr(eb), path.slots[level],
+				btrfs_header_level(eb),
+				btrfs_header_bytenr(next),
+				btrfs_header_level(next),
+				btrfs_header_level(eb) - 1);
+			continue;
+		}
+	}
+
+out:
+	if (root_objectid == BTRFS_TREE_RELOC_OBJECTID)
+		btrfs_free_fs_root(root);
+	btrfs_release_path(&path);
+}
diff --git a/print-tree.h b/print-tree.h
index 62667d7f6195..c7694596e0ee 100644
--- a/print-tree.h
+++ b/print-tree.h
@@ -26,4 +26,6 @@ void print_chunk_item(struct extent_buffer *eb, struct btrfs_chunk *chunk);
 void print_extent_item(struct extent_buffer *eb, int slot, int metadata);
 void print_objectid(FILE *stream, u64 objectid, u8 type);
 void print_key_type(FILE *stream, u64 objectid, u8 type);
+void btrfs_search_print_path(struct btrfs_fs_info *info, u64 root_objectid,
+			     struct btrfs_key *key);
 #endif
-- 
2.17.1



