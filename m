Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab2GXKkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 06:40:13 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6OAeAET006620
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 18:40:12 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs-progs: show generation in command btrfs subvol list
Date: Tue, 24 Jul 2012 18:39:24 +0800
Message-Id: <1343126364-27919-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343126364-27919-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343126364-27919-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the ability to show root's generation when we use btrfs subvol list.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 btrfs-list.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index ac6507a..05360dc 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -57,6 +57,9 @@ struct root_info {
 	/* the dir id we're in from ref_tree */
 	u64 dir_id;
 
+	/* generation when the root is created or last updated */
+	u64 gen;
+
 	/* path from the subvol we live in to this root, including the
 	 * root's name.  This is null until we do the extra lookup ioctl.
 	 */
@@ -194,6 +197,19 @@ static int add_root(struct root_lookup *root_lookup,
 	return 0;
 }
 
+static int update_root(struct root_lookup *root_lookup, u64 root_id, u64 gen)
+{
+	struct root_info *ri;
+
+	ri = tree_search(&root_lookup->root, root_id);
+	if (!ri || ri->root_id != root_id) {
+		fprintf(stderr, "could not find subvol %llu\n", root_id);
+		return -ENOENT;
+	}
+	ri->gen = gen;
+	return 0;
+}
+
 /*
  * for a given root_info, search through the root_lookup tree to construct
  * the full path name to it.
@@ -615,11 +631,15 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	struct btrfs_ioctl_search_key *sk = &args.key;
 	struct btrfs_ioctl_search_header *sh;
 	struct btrfs_root_ref *ref;
+	struct btrfs_root_item *ri;
 	unsigned long off = 0;
 	int name_len;
 	char *name;
 	u64 dir_id;
+	u8 type;
+	u64 gen = 0;
 	int i;
+	int get_gen = 0;
 
 	root_lookup_init(root_lookup);
 	memset(&args, 0, sizeof(args));
@@ -644,6 +664,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 	sk->max_offset = (u64)-1;
 	sk->max_transid = (u64)-1;
 
+again:
 	/* just a big number, doesn't matter much */
 	sk->nr_items = 4096;
 
@@ -665,7 +686,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
 			off += sizeof(*sh);
-			if (sh->type == BTRFS_ROOT_BACKREF_KEY) {
+			if (!get_gen && sh->type == BTRFS_ROOT_BACKREF_KEY) {
 				ref = (struct btrfs_root_ref *)(args.buf + off);
 				name_len = btrfs_stack_root_ref_name_len(ref);
 				name = (char *)(ref + 1);
@@ -673,6 +694,11 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 
 				add_root(root_lookup, sh->objectid, sh->offset,
 					 dir_id, name, name_len);
+			} else if (get_gen && sh->type == BTRFS_ROOT_ITEM_KEY) {
+				ri = (struct btrfs_root_item *)(args.buf + off);
+				gen = btrfs_root_generation(ri);
+
+				update_root(root_lookup, sh->objectid, gen);
 			}
 
 			off += sh->len;
@@ -689,17 +715,38 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 		/* this iteration is done, step forward one root for the next
 		 * ioctl
 		 */
-		if (sk->min_type < BTRFS_ROOT_BACKREF_KEY) {
-			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
+		if (get_gen)
+			type = BTRFS_ROOT_ITEM_KEY;
+		else
+			type = BTRFS_ROOT_BACKREF_KEY;
+
+		if (sk->min_type < type) {
+			sk->min_type = type;
 			sk->min_offset = 0;
 		} else  if (sk->min_objectid < BTRFS_LAST_FREE_OBJECTID) {
 			sk->min_objectid++;
-			sk->min_type = BTRFS_ROOT_BACKREF_KEY;
+			sk->min_type = type;
 			sk->min_offset = 0;
 		} else
 			break;
 	}
 
+	if (!get_gen) {
+		memset(&args, 0, sizeof(args));
+
+		sk->tree_id = 1;
+		sk->max_type = BTRFS_ROOT_ITEM_KEY;
+		sk->min_type = BTRFS_ROOT_ITEM_KEY;
+
+		sk->min_objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+		sk->max_objectid = BTRFS_LAST_FREE_OBJECTID;
+		sk->max_offset = (u64)-1;
+		sk->max_transid = (u64)-1;
+
+		get_gen = 1;
+		goto again;
+	}
 	return 0;
 }
 
@@ -781,13 +828,15 @@ int list_subvols(int fd, int print_parent, int get_default)
 
 		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
 		if (print_parent) {
-			printf("ID %llu parent %llu top level %llu path %s\n",
+			printf("ID %llu gen %llu parent %llu top level %llu path %s\n",
 				(unsigned long long)entry->root_id,
+				(unsigned long long)entry->gen,
 				(unsigned long long)parent_id,
 				(unsigned long long)level, path);
 		} else {
-			printf("ID %llu top level %llu path %s\n",
+			printf("ID %llu gen %llu top level %llu path %s\n",
 				(unsigned long long)entry->root_id,
+				(unsigned long long)entry->gen,
 				(unsigned long long)level, path);
 		}
 
-- 
1.6.5.2

