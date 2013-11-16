Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49369 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3KPRJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:15 -0500
Received: by mail-wg0-f51.google.com with SMTP id m15so4620511wgh.6
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:14 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/7] recursive btrfs snapshot/delete: create traverse_list_subvol_rec()
Date: Sat, 16 Nov 2013 18:09:03 +0100
Message-Id: <1384621747-25441-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create the traverse_list_subvol_rec() function. Its aim is to permit
to process recursively the filesystems subvolumes.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs-list.c | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-list.h |   3 ++
 2 files changed, 124 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index 66f3127..b45c4d9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -2012,3 +2012,124 @@ void free_root_info(struct root_info *ri)
 	free(ri->name);
 	free(ri->full_path);
 }
+
+
+/*
+ * List and sort all subvolumes
+ */
+static int btrfs_list_all_subvols(int fd, struct root_lookup *root_sort,
+	struct root_lookup *root_lookup, int ascending)
+{
+	int ret = 0;
+	u64 top_id = 0;
+	struct btrfs_list_filter_set *filter_set;
+	struct btrfs_list_comparer_set *comp_set;
+
+	filter_set = btrfs_list_alloc_filter_set();
+	comp_set = btrfs_list_alloc_comparer_set();
+
+	btrfs_list_setup_filter(&filter_set,
+				BTRFS_LIST_FILTER_FULL_PATH,
+				top_id);
+	btrfs_list_setup_comparer(&comp_set, BTRFS_LIST_COMP_PATH, ascending);
+
+	ret = btrfs_list_subvols(fd, root_lookup);
+	if (ret)
+		goto exit;
+	__filter_and_sort_subvol(root_lookup, root_sort, filter_set,
+				 comp_set, top_id);
+
+	ret = 0;
+exit:
+	if (filter_set)
+		btrfs_list_free_filter_set(filter_set);
+	if (comp_set)
+		btrfs_list_free_comparer_set(comp_set);
+
+	return ret;
+}
+
+/*
+ * traverse the subvolumes list, calling func() for each subvolume path
+ * data is passed to func(). If all == true, func is called on all
+ * filesystem subvolumes. ascending set the order criteria
+ */
+int traverse_list_subvol_rec(char *path, int all, int ascending,
+	int (*func)(char *real_root, char *relative_root, char *path, void *data), 
+	void *data)
+{
+	struct root_lookup root_lookup = {{0}}, root_to_free = {{0}};
+	int ret, l=0, fd=-1;
+	DIR *fddir;
+	struct rb_node *n;
+	struct root_info ri = {{0}};
+	char	*rootpath = NULL;
+
+	ret = 1; /* failure */
+
+	if (!all) {
+		/* search the full_path of path */
+		ret = get_root_info(path, &ri);
+		if (ret) {
+			fprintf(stderr, "ERROR: cannot get info on '%s'\n", path);
+			goto out;
+		}
+	}
+
+	fd = open_file_or_dir(path, &fddir);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		goto out;
+	}
+	ret = btrfs_list_all_subvols(fd, &root_lookup, &root_to_free, ascending);
+	/* doesn't leak fd & fddir */
+	close_file_or_dir(fd, fddir);
+
+	if (ret) {
+		fprintf(stderr, "ERROR: cannot list the subvols\n");
+		goto out;
+	}
+
+	if (!all) {
+		n = rb_first(&root_lookup.root);
+		while (n) {
+			struct root_info *entry;
+
+			entry = rb_entry(n, struct root_info, sort_node);
+			if (entry->root_id == ri.root_id) {
+				rootpath = entry->full_path;
+				break;
+			}
+			n = rb_next(n);
+		}
+		BUG_ON(!rootpath);
+
+	} else {
+		rootpath = "<FS_TREE>";
+	}
+	l = strlen(rootpath);
+
+	for (n = rb_first(&root_lookup.root) ; n ; n = rb_next(n)) {
+		struct root_info *entry;
+
+		entry = rb_entry(n, struct root_info, sort_node);
+		if (!all && strncmp(rootpath, entry->full_path,l)) {
+			continue;
+		}
+
+		ret = func(rootpath, path, entry->full_path+l, data);
+		if (ret)
+			goto out;
+
+	}
+	ret = 0;
+
+out:
+
+	__free_all_subvolumn(&root_to_free);
+	if (!all)
+		free_root_info(&ri);
+
+	return ret;
+
+}
diff --git a/btrfs-list.h b/btrfs-list.h
index db32805..5c246e1 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -168,5 +168,8 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid);
 int btrfs_get_subvol(int fd, struct root_info *the_ri);
 int get_root_info(char *path, struct root_info *get_ri);
 void free_root_info(struct root_info *ri);
+int traverse_list_subvol_rec(char *path, int all, int ascending,
+	int (*func)(char *real_root, char *relative_root, char *path, void *data), 
+	void *data);
 
 #endif
-- 
1.8.4.3

