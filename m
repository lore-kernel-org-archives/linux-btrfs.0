Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935169AbeCHClE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6A56BAF0A
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 04/20] btrfs-progs: btrfs-list: add rb_entry helpers for root_info
Date: Wed,  7 Mar 2018 21:40:31 -0500
Message-Id: <20180308024047.10104-5-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We use rb_entry all over the place for the root_info pointers.  Add
a helper to make the code more readable.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-list.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e01c5899..90c98be1 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -44,6 +44,16 @@ struct root_lookup {
 	struct rb_root root;
 };
 
+static inline struct root_info *to_root_info(struct rb_node *node)
+{
+	return rb_entry(node, struct root_info, rb_node);
+}
+
+static inline struct root_info *to_root_info_sorted(struct rb_node *node)
+{
+	return rb_entry(node, struct root_info, sort_node);
+}
+
 static struct {
 	char	*name;
 	char	*column_name;
@@ -309,7 +319,7 @@ static int sort_tree_insert(struct root_lookup *sort_tree,
 
 	while (*p) {
 		parent = *p;
-		curr = rb_entry(parent, struct root_info, sort_node);
+		curr = to_root_info_sorted(parent);
 
 		ret = sort_comp(ins, curr, comp_set);
 		if (ret < 0)
@@ -340,7 +350,7 @@ static int root_tree_insert(struct root_lookup *root_tree,
 
 	while(*p) {
 		parent = *p;
-		curr = rb_entry(parent, struct root_info, rb_node);
+		curr = to_root_info(parent);
 
 		ret = comp_entry_with_rootid(ins, curr, 0);
 		if (ret < 0)
@@ -371,7 +381,7 @@ static struct root_info *root_tree_search(struct root_lookup *root_tree,
 	tmp.root_id = root_id;
 
 	while(n) {
-		entry = rb_entry(n, struct root_info, rb_node);
+		entry = to_root_info(n);
 
 		ret = comp_entry_with_rootid(&tmp, entry, 0);
 		if (ret < 0)
@@ -528,7 +538,7 @@ static void free_root_info(struct rb_node *node)
 {
 	struct root_info *ri;
 
-	ri = rb_entry(node, struct root_info, rb_node);
+	ri = to_root_info(node);
 	free(ri->name);
 	free(ri->path);
 	free(ri->full_path);
@@ -1268,7 +1278,7 @@ static void filter_and_sort_subvol(struct root_lookup *all_subvols,
 
 	n = rb_last(&all_subvols->root);
 	while (n) {
-		entry = rb_entry(n, struct root_info, rb_node);
+		entry = to_root_info(n);
 
 		ret = resolve_root(all_subvols, entry, top_id);
 		if (ret == -ENOENT) {
@@ -1300,7 +1310,7 @@ static int list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	while (n) {
 		struct root_info *entry;
 		int ret;
-		entry = rb_entry(n, struct root_info, rb_node);
+		entry = to_root_info(n);
 		ret = lookup_ino_path(fd, entry);
 		if (ret && ret != -ENOENT)
 			return ret;
@@ -1467,7 +1477,7 @@ static void print_all_subvol_info(struct root_lookup *sorted_tree,
 
 	n = rb_first(&sorted_tree->root);
 	while (n) {
-		entry = rb_entry(n, struct root_info, sort_node);
+		entry = to_root_info_sorted(n);
 
 		/* The toplevel subvolume is not listed by default */
 		if (entry->root_id == BTRFS_FS_TREE_OBJECTID)
@@ -1558,7 +1568,7 @@ int btrfs_get_toplevel_subvol(int fd, struct root_info *the_ri)
 		return ret;
 
 	rbn = rb_first(&rl.root);
-	ri = rb_entry(rbn, struct root_info, rb_node);
+	ri = to_root_info(rbn);
 
 	if (ri->root_id != BTRFS_FS_TREE_OBJECTID)
 		return -ENOENT;
@@ -1590,7 +1600,7 @@ int btrfs_get_subvol(int fd, struct root_info *the_ri)
 
 	rbn = rb_first(&rl.root);
 	while(rbn) {
-		ri = rb_entry(rbn, struct root_info, rb_node);
+		ri = to_root_info(rbn);
 		rr = resolve_root(&rl, ri, root_id);
 		if (rr == -ENOENT) {
 			ret = -ENOENT;
@@ -1814,7 +1824,7 @@ char *btrfs_list_path_for_root(int fd, u64 root)
 	while (n) {
 		struct root_info *entry;
 
-		entry = rb_entry(n, struct root_info, rb_node);
+		entry = to_root_info(n);
 		ret = resolve_root(&root_lookup, entry, top_id);
 		if (ret == -ENOENT && entry->root_id == root) {
 			ret_path = NULL;
-- 
2.12.3

