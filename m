Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46589 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2HCJvb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:31 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 3/9] Btrfs-progs: refactor resolve_root() function a bit
Date: Fri,  3 Aug 2012 17:48:52 +0800
Message-Id: <1343987338-10612-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Ilya Dryomov <idryomov@gmail.com>

Don't pass a pointer to root_id to resolve_root().  It's always the same as
ri->root_id, passing a pointer hints that root_id can somehow change which is
not true.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 btrfs-list.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 680dd03..5c21cac 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -202,7 +202,7 @@ static int add_root(struct root_lookup *root_lookup,
  * in by lookup_ino_path
  */
 static int resolve_root(struct root_lookup *rl, struct root_info *ri,
-			u64 *root_id, u64 *parent_id, u64 *top_id, char **path)
+			u64 *parent_id, u64 *top_id, char **path)
 {
 	char *full_path = NULL;
 	int len = 0;
@@ -256,7 +256,6 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		}
 	}
 
-	*root_id = ri->root_id;
 	*path = full_path;
 
 	return 0;
@@ -700,23 +699,23 @@ int list_subvols(int fd, int print_parent)
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
@@ -922,17 +921,17 @@ char *path_for_root(int fd, u64 root)
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
1.7.1

