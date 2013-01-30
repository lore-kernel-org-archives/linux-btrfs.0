Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24581 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3A3J6c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 04:58:32 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 10/12] Btrfs-progs: filter the deleted subvolumes when listing snapshots
Date: Wed, 30 Jan 2013 17:56:26 +0800
Message-Id: <1359539788-10667-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359539788-10667-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359539788-10667-1-git-send-email-anand.jain@oracle.com>

From: Wang Shilong <wangsl-fnst@cn.fujistu.com>

btrfs snapshot list command will stop by the deleted subvolumes.

The problem may happen by two ways:
1. a subvolume deletion is not commited, that is ROOT_BACKREF has been deleted,
   but ROOT_ITEM still exists. The command will fail to fill the path of
   the deleted subvolumes because we can not get the parent fs/file tree.
2. a subvolume is possibly deleted when we fill the path, For example,
   Fs tree
     |->subv0
	  |->subv1

   We may fill the path of subv1 firstly, after that, some user deletes subv1
   and subv0, and then we fill the path of subv0. The command will fail to
   fill the path of subv0 because we can not get path of subv0. And the command
   also will fail to make the full path of subv1 because we don't have the path
   of subv0.

Since these subvolumes have been deleted, we should filter them. This patch
fixed the above problem by this way.

For the 1st case, ->ref_tree of the deleted subvolumes are 0.
For the 2nd case, if we found the error number that ioctl() returns is ENOENT,
we will set ->ref_tree to 0.
And when we make the full path of the subvolumes, we will check ->ref_tree of
them and their parent. If someone's ->ref_tree or its parent's ->ref_tree is 0,
we will filter it.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 545aa15..69ee3e7 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -564,6 +564,12 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 	while (1) {
 		char *tmp;
 		u64 next;
+		/*
+		* ref_tree = 0 indicates the subvolumes
+		* has been deleted.
+		*/
+		if (!found->ref_tree)
+			return -ENOENT;
 		int add_len = strlen(found->path);
 
 		/* room for / and for null */
@@ -592,6 +598,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 			break;
 		}
 
+		/*
+		* if the ref_tree = BTRFS_FS_TREE_OBJECTID,
+		* we are at the top
+		*/
 		if (next == BTRFS_FS_TREE_OBJECTID) {
 			char p[] = "<FS_TREE>";
 			add_len = strlen(p);
@@ -608,14 +618,12 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		}
 
 		/*
-		 * if the ref_tree wasn't in our tree of roots, we're
-		 * at the top
-		 */
+		* if the ref_tree wasn't in our tree of roots, the
+		* subvolume was deleted.
+		*/
 		found = root_tree_search(rl, next);
-		if (!found) {
-			ri->top_id = next;
-			break;
-		}
+		if (!found)
+			return -ENOENT;
 	}
 
 	ri->full_path = full_path;
@@ -638,6 +646,9 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	if (ri->path)
 		return 0;
 
+	if (!ri->ref_tree)
+		return -ENOENT;
+
 	memset(&args, 0, sizeof(args));
 	args.treeid = ri->ref_tree;
 	args.objectid = ri->dir_id;
@@ -645,6 +656,10 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	e = errno;
 	if (ret) {
+		if (e == ENOENT) {
+			ri->ref_tree = 0;
+			return -ENOENT;
+		}
 		fprintf(stderr, "ERROR: Failed to lookup path for root %llu - %s\n",
 			(unsigned long long)ri->ref_tree,
 			strerror(e));
@@ -1255,10 +1270,13 @@ static void __filter_and_sort_subvol(struct root_lookup *all_subvols,
 	while (n) {
 		entry = rb_entry(n, struct root_info, rb_node);
 
-		resolve_root(all_subvols, entry, top_id);
+		ret = resolve_root(all_subvols, entry, top_id);
+		if (ret == -ENOENT)
+			goto skip;
 		ret = filter_root(entry, filter_set);
 		if (ret)
 			sort_tree_insert(sort_tree, entry, comp_set);
+skip:
 		n = rb_prev(n);
 	}
 }
@@ -1273,7 +1291,7 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 		int ret;
 		entry = rb_entry(n, struct root_info, rb_node);
 		ret = lookup_ino_path(fd, entry);
-		if(ret < 0)
+		if (ret && ret != -ENOENT)
 			return ret;
 		n = rb_next(n);
 	}
@@ -1721,7 +1739,11 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 		struct root_info *entry;
 
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, top_id);
+		ret = resolve_root(&root_lookup, entry, top_id);
+		if (ret == -ENOENT && entry->root_id == root) {
+			ret_path = NULL;
+			break;
+		}
 		if (entry->root_id == root) {
 			ret_path = entry->full_path;
 			entry->full_path = NULL;
-- 
1.8.1.227.g44fe835

