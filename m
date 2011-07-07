From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 1/2] btrfs-list: split list_subvols
Date: Thu,  7 Jul 2011 18:01:39 +0200
Message-ID: <f5f491b620db38729cf0c594d090b40b305f7c38.1310053983.git.list.btrfs@jan-o-sch.net>
References: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

split list_subvols to separate functions and allow printing only in the
containing function. lets us make use of those functions when resolving
logical addresses.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 btrfs-list.c |  104 ++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 07b179a..dd685c2 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -199,10 +199,9 @@ static int add_root(struct root_lookup *root_lookup,
  * This can't be called until all the root_info->path fields are filled
  * in by lookup_ino_path
  */
-static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_parent)
+static int resolve_root(struct root_lookup *rl, struct root_info *ri,
+			u64 *root_id, u64 *parent_id, u64 *top_id, char **path)
 {
-	u64 top_id;
-	u64 parent_id = 0;
 	char *full_path = NULL;
 	int len = 0;
 	struct root_info *found;
@@ -211,6 +210,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_
 	 * we go backwards from the root_info object and add pathnames
 	 * from parent directories as we go.
 	 */
+	*parent_id = 0;
 	found = ri;
 	while (1) {
 		char *tmp;
@@ -234,13 +234,12 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_
 
 		next = found->ref_tree;
 		/* record the first parent */
-		if ( parent_id == 0 ) {
-			parent_id = next;
-		}
+		if (*parent_id == 0)
+			*parent_id = next;
 
 		/* if the ref_tree refers to ourselves, we're at the top */
 		if (next == found->root_id) {
-			top_id = next;
+			*top_id = next;
 			break;
 		}
 
@@ -250,20 +249,15 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri, int print_
 		 */
 		found = tree_search(&rl->root, next);
 		if (!found) {
-			top_id = next;
+			*top_id = next;
 			break;
 		}
 	}
-	if (print_parent) {
-		printf("ID %llu parent %llu top level %llu path %s\n",
-		       (unsigned long long)ri->root_id, (unsigned long long)parent_id, (unsigned long long)top_id,
-			full_path);
-	} else {
-		printf("ID %llu top level %llu path %s\n",
-		       (unsigned long long)ri->root_id, (unsigned long long)top_id,
-			full_path);
-	}
-	free(full_path);
+
+	*root_id = ri->root_id;
+	*parent_id = ri->root_id;
+	*path = full_path;
+
 	return 0;
 }
 
@@ -560,10 +554,8 @@ build:
 	return full;
 }
 
-int list_subvols(int fd, int print_parent)
+static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 {
-	struct root_lookup root_lookup;
-	struct rb_node *n;
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
@@ -574,9 +566,11 @@ int list_subvols(int fd, int print_parent)
 	char *name;
 	u64 dir_id;
 	int i;
-	int e;
 
-	root_lookup_init(&root_lookup);
+	root_lookup_init(root_lookup);
+	memset(&args, 0, sizeof(args));
+
+	root_lookup_init(root_lookup);
 
 	memset(&args, 0, sizeof(args));
 
@@ -603,12 +597,8 @@ int list_subvols(int fd, int print_parent)
 
 	while(1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		e = errno;
-		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(e));
+		if (ret < 0)
 			return ret;
-		}
 		/* the ioctl returns the number of item it found in nr_items */
 		if (sk->nr_items == 0)
 			break;
@@ -629,7 +619,7 @@ int list_subvols(int fd, int print_parent)
 				name = (char *)(ref + 1);
 				dir_id = btrfs_stack_root_ref_dirid(ref);
 
-				add_root(&root_lookup, sh->objectid, sh->offset,
+				add_root(root_lookup, sh->objectid, sh->offset,
 					 dir_id, name, name_len);
 			}
 
@@ -657,11 +647,15 @@ int list_subvols(int fd, int print_parent)
 		} else
 			break;
 	}
-	/*
-	 * now we have an rbtree full of root_info objects, but we need to fill
-	 * in their path names within the subvol that is referencing each one.
-	 */
-	n = rb_first(&root_lookup.root);
+
+	return 0;
+}
+
+static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
+{
+	struct rb_node *n;
+
+	n = rb_first(&root_lookup->root);
 	while (n) {
 		struct root_info *entry;
 		int ret;
@@ -672,6 +666,30 @@ int list_subvols(int fd, int print_parent)
 		n = rb_next(n);
 	}
 
+	return 0;
+}
+
+int list_subvols(int fd, int print_parent)
+{
+	struct root_lookup root_lookup;
+	struct rb_node *n;
+	int ret;
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
 	/* now that we have all the subvol-relative paths filled in,
 	 * we have to string the subvols together so that we can get
 	 * a path all the way back to the FS root
@@ -679,8 +697,24 @@ int list_subvols(int fd, int print_parent)
 	n = rb_last(&root_lookup.root);
 	while (n) {
 		struct root_info *entry;
+		u64 root_id;
+		u64 level;
+		u64 parent_id;
+		char *path;
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, print_parent);
+		resolve_root(&root_lookup, entry, &root_id, &parent_id,
+				&level, &path);
+		if (print_parent) {
+			printf("ID %llu parent %llu top level %llu path %s\n",
+				(unsigned long long)root_id,
+				(unsigned long long)parent_id,
+				(unsigned long long)level, path);
+		} else {
+			printf("ID %llu top level %llu path %s\n",
+				(unsigned long long)root_id,
+				(unsigned long long)level, path);
+		}
+		free(path);
 		n = rb_prev(n);
 	}
 
-- 
1.7.3.4

