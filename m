Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60100 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2JQQGy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 12:06:54 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so793940wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 09:06:52 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 18:06:52 +0200
Message-ID: <CAOcd+r2VUEjti7uNht-vaa603ZHE5XDXUdW1zODhrfO4iPMxUA@mail.gmail.com>
Subject: [PATCH] Btrfs-progs: Filter out deleting or already-deleted
 subvolumes in lookup_ino_path.
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a subvolume is deleted between __list_subvol_search() and
__list_subvol_fill_paths(),
the tool would have stopped with an error. So drop those subvolumes
that did not have ROOT_BACKREF, and those
for whom a path component to the parent root was missing.
(Note that BTRFS_IOC_INO_LOOKUP does not do a search if dirid is
BTRFS_FIRST_FREE_OBJECTID, so such
a subvolume will be considered as still existing, but subvolume
listing will not fail at least).

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>

diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..faf5b1a 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -672,6 +672,13 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	if (ri->path)
 		return 0;

+	/*
+	 * If the subvolume's ROOT_BACKREF does not exist anymore, consider it
+	 * as deleted.
+	 */
+	if (ri->ref_tree == 0)
+		return -ENOENT;
+
 	memset(&args, 0, sizeof(args));
 	args.treeid = ri->ref_tree;
 	args.objectid = ri->dir_id;
@@ -679,9 +686,15 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: Failed to lookup path for root %llu - %s\n",
-			(unsigned long long)ri->ref_tree,
-			strerror(e));
+		ret = -e;
+		/*
+		 * If one of the path components is missing, we will conside
+		 * the subvolume as deleted.
+		 */
+		if (ret != -ENOENT)
+			fprintf(stderr, "ERROR: Failed to lookup path for root %llu - %s\n",
+				(unsigned long long)ri->ref_tree,
+				strerror(e));
 		return ret;
 	}

@@ -1290,19 +1303,32 @@ static void __filter_and_sort_subvol(struct
root_lookup *all_subvols,
 	}
 }

-static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
+static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup,
+	struct root_lookup *root_lookup_final)
 {
 	struct rb_node *n;

+	root_lookup_init(root_lookup_final);
+
 	n = rb_first(&root_lookup->root);
 	while (n) {
 		struct root_info *entry;
 		int ret;
 		entry = rb_entry(n, struct root_info, rb_node);
 		ret = lookup_ino_path(fd, entry);
-		if(ret < 0)
+		if(ret < 0 && ret != -ENOENT)
 			return ret;
-		n = rb_next(n);
+		rb_erase(&entry->rb_node, &root_lookup->root);
+		/*
+		 * If lookup_ino_path() returned ENOENT, some of the path
+		 * components are missing. Let's consider this subvolume
+		 * as deleted then.
+		 */
+		if (ret == -ENOENT)
+			__free_root_info(entry);
+		else
+			root_tree_insert(root_lookup_final, entry);
+		n = rb_first(&root_lookup->root);
 	}

 	return 0;
@@ -1446,6 +1472,7 @@ int btrfs_list_subvols(int fd, struct
btrfs_list_filter_set *filter_set,
 		       int is_tab_result)
 {
 	struct root_lookup root_lookup;
+	struct root_lookup root_lookup_final;
 	struct root_lookup root_sort;
 	int ret;

@@ -1460,15 +1487,15 @@ int btrfs_list_subvols(int fd, struct
btrfs_list_filter_set *filter_set,
 	 * now we have an rbtree full of root_info objects, but we need to fill
 	 * in their path names within the subvol that is referencing each one.
 	 */
-	ret = __list_subvol_fill_paths(fd, &root_lookup);
+	ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
 	if (ret < 0)
 		return ret;

-	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
+	__filter_and_sort_subvol(&root_lookup_final, &root_sort, filter_set,
 				 comp_set, fd);

 	print_all_volume_info(&root_sort, is_tab_result);
-	__free_all_subvolumn(&root_lookup);
+	__free_all_subvolumn(&root_lookup_final);
 	return ret;
 }

@@ -1655,6 +1682,7 @@ int btrfs_list_find_updated_files(int fd, u64
root_id, u64 oldest_gen)
 char *btrfs_list_path_for_root(int fd, u64 root)
 {
 	struct root_lookup root_lookup;
+	struct root_lookup root_lookup_final;
 	struct rb_node *n;
 	char *ret_path = NULL;
 	int ret;
@@ -1664,16 +1692,16 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	if (ret < 0)
 		return ERR_PTR(ret);

-	ret = __list_subvol_fill_paths(fd, &root_lookup);
+	ret = __list_subvol_fill_paths(fd, &root_lookup, &root_lookup_final);
 	if (ret < 0)
 		return ERR_PTR(ret);

-	n = rb_last(&root_lookup.root);
+	n = rb_last(&root_lookup_final.root);
 	while (n) {
 		struct root_info *entry;

 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, top_id);
+		resolve_root(&root_lookup_final, entry, top_id);
 		if (entry->root_id == root) {
 			ret_path = entry->full_path;
 			entry->full_path = NULL;
@@ -1681,7 +1709,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)

 		n = rb_prev(n);
 	}
-	__free_all_subvolumn(&root_lookup);
+	__free_all_subvolumn(&root_lookup_final);

 	return ret_path;
 }
