From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/3] Btrfs-progs: refactor resolve_root() function a bit
Date: Mon, 12 Mar 2012 20:05:46 +0200
Message-ID: <1331575547-5796-3-git-send-email-idryomov@gmail.com>
References: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
Cc: idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331575547-5796-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Don't pass a pointer to root_id to resolve_root().  It's always the same as
ri->root_id, passing a pointer hints that root_id can somehow change which is
not true.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs-list.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 44a73de..cc1dc66 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -200,7 +200,7 @@ static int add_root(struct root_lookup *root_lookup,
  * in by lookup_ino_path
  */
 static int resolve_root(struct root_lookup *rl, struct root_info *ri,
-			u64 *root_id, u64 *parent_id, u64 *top_id, char **path)
+			u64 *parent_id, u64 *top_id, char **path)
 {
 	char *full_path = NULL;
 	int len = 0;
@@ -254,7 +254,6 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		}
 	}
 
-	*root_id = ri->root_id;
 	*path = full_path;
 
 	return 0;
@@ -692,23 +691,23 @@ int list_subvols(int fd, int print_parent)
 	n = rb_last(&root_lookup.root);
 	while (n) {
 		struct root_info *entry;
-		u64 root_id;
 		u64 level;
 		u64 parent_id;
 		char *path;
+
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, &root_id, &parent_id,
-				&level, &path);
+		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
 		if (print_parent) {
 			printf("ID %llu parent %llu top level %llu path %s\n",
-				(unsigned long long)root_id,
+				(unsigned long long)entry->root_id,
 				(unsigned long long)parent_id,
 				(unsigned long long)level, path);
 		} else {
 			printf("ID %llu top level %llu path %s\n",
-				(unsigned long long)root_id,
+				(unsigned long long)entry->root_id,
 				(unsigned long long)level, path);
 		}
+
 		free(path);
 		n = rb_prev(n);
 	}
@@ -914,17 +913,17 @@ char *path_for_root(int fd, u64 root)
 	n = rb_last(&root_lookup.root);
 	while (n) {
 		struct root_info *entry;
-		u64 root_id;
 		u64 parent_id;
 		u64 level;
 		char *path;
+
 		entry = rb_entry(n, struct root_info, rb_node);
-		resolve_root(&root_lookup, entry, &root_id, &parent_id, &level,
-				&path);
-		if (root_id == root)
+		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
+		if (entry->root_id == root)
 			ret_path = path;
 		else
 			free(path);
+
 		n = rb_prev(n);
 	}
 
-- 
1.7.9.1

