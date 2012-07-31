Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56399 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2GaFuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 01:50:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6V5nmiT001622
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 13:49:49 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs-progs: list snapshots by generation
Date: Tue, 31 Jul 2012 13:49:36 +0800
Message-Id: <1343713776-14232-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343713776-14232-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343713776-14232-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The idea is that we usually use snapshot to backup/restore our data, and the
common way can be a cron script which makes lots of snapshots, so we can end
up with spending some time to find the latest snapshot to restore.

This adds a feature for 'btrfs subvolume list' to let it list snapshots by their
_created_ generation.

What we need to do is just to list them in descending order and get the latest
snapshot.  What's more, we can find the oldest snapshot as well by listing
snapshots in ascending order.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfs-list.c     |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 cmds-subvolume.c |   19 +++++-
 2 files changed, 185 insertions(+), 10 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 05360dc..0374b41 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -87,13 +87,23 @@ static int comp_entry(struct root_info *entry, u64 root_id, u64 ref_tree)
 	return 0;
 }
 
+static int comp_entry_with_gen(struct root_info *entry, u64 root_id,
+			       u64 ref_tree, u64 gen)
+{
+	if (entry->gen < gen)
+		return 1;
+	if (entry->gen > gen)
+		return -1;
+	return comp_entry(entry, root_id, ref_tree);
+}
+
 /*
  * insert a new root into the tree.  returns the existing root entry
  * if one is already there.  Both root_id and ref_tree are used
  * as the key
  */
 static struct rb_node *tree_insert(struct rb_root *root, u64 root_id,
-				   u64 ref_tree, struct rb_node *node)
+				   u64 ref_tree, u64 *gen, struct rb_node *node)
 {
 	struct rb_node ** p = &root->rb_node;
 	struct rb_node * parent = NULL;
@@ -104,7 +114,11 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 root_id,
 		parent = *p;
 		entry = rb_entry(parent, struct root_info, rb_node);
 
-		comp = comp_entry(entry, root_id, ref_tree);
+		if (!gen)
+			comp = comp_entry(entry, root_id, ref_tree);
+		else
+			comp = comp_entry_with_gen(entry, root_id, ref_tree,
+						   *gen);
 
 		if (comp < 0)
 			p = &(*p)->rb_left;
@@ -171,7 +185,7 @@ static struct root_info *tree_search(struct rb_root *root, u64 root_id)
  */
 static int add_root(struct root_lookup *root_lookup,
 		    u64 root_id, u64 ref_tree, u64 dir_id, char *name,
-		    int name_len)
+		    int name_len, u64 *gen)
 {
 	struct root_info *ri;
 	struct rb_node *ret;
@@ -185,11 +199,15 @@ static int add_root(struct root_lookup *root_lookup,
 	ri->dir_id = dir_id;
 	ri->root_id = root_id;
 	ri->ref_tree = ref_tree;
-	strncpy(ri->name, name, name_len);
+	if (name)
+		strncpy(ri->name, name, name_len);
 	if (name_len > 0)
 		ri->name[name_len] = 0;
+	if (gen)
+		ri->gen = *gen;
 
-	ret = tree_insert(&root_lookup->root, root_id, ref_tree, &ri->rb_node);
+	ret = tree_insert(&root_lookup->root, root_id, ref_tree, gen,
+			  &ri->rb_node);
 	if (ret) {
 		printf("failed to insert tree %llu\n", (unsigned long long)root_id);
 		exit(1);
@@ -693,7 +711,7 @@ again:
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
 				add_root(root_lookup, sh->objectid, sh->offset,
-					 dir_id, name, name_len);
+					 dir_id, name, name_len, NULL);
 			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
 				ri = (struct btrfs_root_item *)(args.buf + off);
 				gen = btrfs_root_generation(ri);
@@ -750,6 +768,79 @@ again:
 	return 0;
 }
 
+static int __list_snapshot_search(int fd, struct root_lookup *root_lookup)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	u64 gen = 0;
+	int i;
+
+	root_lookup_init(root_lookup);
+	memset(&args, 0, sizeof(args));
+
+	sk->tree_id = 1;
+	sk->max_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_type = BTRFS_ROOT_ITEM_KEY;
+	sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+	sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+	sk->nr_items = 4096;
+
+	while (1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		if (ret < 0)
+			return ret;
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+
+		/*
+		 * for each item, pull the key out of the header and then
+		 * read the root_ref item it contains
+		 */
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+			if (sh->type == BTRFS_ROOT_ITEM_KEY && sh->offset) {
+				gen = sh->offset;
+
+				add_root(root_lookup, sh->objectid, 0,
+					 0, NULL, 0, &gen);
+			}
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_objectid = sh->objectid;
+			sk->min_type = sh->type;
+			sk->min_offset = sh->offset;
+		}
+		sk->nr_items = 4096;
+		/* this iteration is done, step forward one root for the next
+		 * ioctl
+		 */
+		if (sk->min_type < BTRFS_ROOT_ITEM_KEY) {
+			sk->min_type = BTRFS_ROOT_ITEM_KEY;
+			sk->min_offset = 0;
+		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
+			sk->min_objectid++;
+			sk->min_type = BTRFS_ROOT_ITEM_KEY;
+			sk->min_offset = 0;
+		} else
+			break;
+	}
+	return 0;
+}
+
 static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 {
 	struct rb_node *n;
@@ -847,6 +938,79 @@ int list_subvols(int fd, int print_parent, int get_default)
 	return ret;
 }
 
+int list_snapshots(int fd, int print_parent, int order)
+{
+	struct root_lookup root_lookup;
+	struct root_lookup root_lookup_snap;
+	struct rb_node *n;
+	int ret;
+
+	ret = __list_snapshot_search(fd, &root_lookup_snap);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(errno));
+		return ret;
+	}
+	
+	ret = __list_subvol_search(fd, &root_lookup);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(errno));
+		return ret;
+	}
+
+	/*
+	 * now we have an rbtree full of root_info objects, but we need to fill
+	 * in their path names within the subvol that is referencing each one.
+	 */
+	ret = __list_subvol_fill_paths(fd, &root_lookup);
+	if (ret < 0)
+		return ret;
+
+	/* now that we have all the subvol-relative paths filled in,
+	 * we have to string the subvols together so that we can get
+	 * a path all the way back to the FS root
+	 */
+	if (!order)
+		n = rb_last(&root_lookup_snap.root);
+	else
+		n = rb_first(&root_lookup_snap.root);
+	while (n) {
+		struct root_info *entry_snap;
+		struct root_info *entry;
+		u64 level;
+		u64 parent_id;
+		char *path;
+
+		entry_snap = rb_entry(n, struct root_info, rb_node);
+		entry = tree_search(&root_lookup.root, entry_snap->root_id);
+
+		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
+		if (print_parent) {
+			printf("ID %llu gen %llu cgen %llu parent %llu top level %llu path %s\n",
+				(unsigned long long)entry->root_id,
+				(unsigned long long)entry->gen,
+				(unsigned long long)entry_snap->gen,
+				(unsigned long long)parent_id,
+				(unsigned long long)level, path);
+		} else {
+			printf("ID %llu gen %llu cgen %llu top level %llu path %s\n",
+				(unsigned long long)entry->root_id,
+				(unsigned long long)entry->gen,
+				(unsigned long long)entry_snap->gen,
+				(unsigned long long)level, path);
+		}
+
+		free(path);
+		if (!order)
+			n = rb_prev(n);
+		else
+			n = rb_next(n);
+	}
+
+	return ret;
+}
+
 static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
 			    struct btrfs_file_extent_item *item,
 			    u64 found_gen, u64 *cache_dirid,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3508ce6..9c75b47 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -219,10 +219,12 @@ static int cmd_subvol_delete(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-p] <path>",
+	"btrfs subvolume list [-ps] <path>",
 	"List subvolumes (and snapshots)",
 	"",
-	"-p     print parent ID",
+	"-p           print parent ID",
+	"-s value     list snapshots with generation in ascending/descending order",
+	"             (1: ascending, 0: descending)",
 	NULL
 };
 
@@ -231,11 +233,13 @@ static int cmd_subvol_list(int argc, char **argv)
 	int fd;
 	int ret;
 	int print_parent = 0;
+	int print_snap_only = 0;
+	int order = 0;
 	char *subvol;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "p");
+		int c = getopt(argc, argv, "ps:");
 		if (c < 0)
 			break;
 
@@ -243,6 +247,10 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'p':
 			print_parent = 1;
 			break;
+		case 's':
+			print_snap_only = 1;
+			order = atoi(optarg);
+			break;
 		default:
 			usage(cmd_subvol_list_usage);
 		}
@@ -268,7 +276,10 @@ static int cmd_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, print_parent, 0);
+	if (!print_snap_only)
+		ret = list_subvols(fd, print_parent, 0);
+	else
+		ret = list_snapshots(fd, print_parent, order);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.6.5.2

