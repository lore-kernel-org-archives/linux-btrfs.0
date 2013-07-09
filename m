Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52096 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3GISu1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 14:50:27 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so5222665wgh.16
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 11:50:25 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] Btrfs-progs: remove unneeded leaf checks in cmds-restore
Date: Tue,  9 Jul 2013 19:49:54 +0100
Message-Id: <1373395794-29140-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_search_slot() returns a value >= 0, then we can be
sure that path->nodes[i] is not NULL for each i between 0 to
tree height - 1. The function btrfs_next_leaf() also ensures
any path->nodes[i] is not NULL as long as it returns 0.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |  118 ++++++++++++++++++--------------------------------------
 1 file changed, 37 insertions(+), 81 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index ed4815a..baa9cab 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -394,21 +394,6 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	}
 
 	leaf = path->nodes[0];
-	while (!leaf) {
-		ret = btrfs_next_leaf(root, path);
-		if (ret < 0) {
-			fprintf(stderr, "Error getting next leaf %d\n",
-				ret);
-			btrfs_free_path(path);
-			return ret;
-		} else if (ret > 0) {
-			/* No more leaves to search */
-			btrfs_free_path(path);
-			return 0;
-		}
-		leaf = path->nodes[0];
-	}
-
 	while (1) {
 		if (loops++ >= 1024) {
 			ret = ask_to_continue(file);
@@ -417,19 +402,17 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 			loops = 0;
 		}
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
-			do {
-				ret = btrfs_next_leaf(root, path);
-				if (ret < 0) {
-					fprintf(stderr, "Error searching %d\n", ret);
-					btrfs_free_path(path);
-					return ret;
-				} else if (ret) {
-					/* No more leaves to search */
-					btrfs_free_path(path);
-					goto set_size;
-				}
-				leaf = path->nodes[0];
-			} while (!leaf);
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error searching %d\n", ret);
+				btrfs_free_path(path);
+				return ret;
+			} else if (ret) {
+				/* No more leaves to search */
+				btrfs_free_path(path);
+				goto set_size;
+			}
+			leaf = path->nodes[0];
 			continue;
 		}
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
@@ -513,27 +496,6 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 	leaf = path->nodes[0];
-	while (!leaf) {
-		if (verbose > 1)
-			printf("No leaf after search, looking for the next "
-			       "leaf\n");
-		ret = btrfs_next_leaf(root, path);
-		if (ret < 0) {
-			fprintf(stderr, "Error getting next leaf %d\n",
-				ret);
-			btrfs_free_path(path);
-			return ret;
-		} else if (ret > 0) {
-			/* No more leaves to search */
-			if (verbose)
-				printf("Reached the end of the tree looking "
-				       "for the directory\n");
-			btrfs_free_path(path);
-			return 0;
-		}
-		leaf = path->nodes[0];
-	}
-
 	while (leaf) {
 		if (loops++ >= 1024) {
 			printf("We have looped trying to restore files in %s "
@@ -543,24 +505,22 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		}
 
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
-			do {
-				ret = btrfs_next_leaf(root, path);
-				if (ret < 0) {
-					fprintf(stderr, "Error searching %d\n",
-						ret);
-					btrfs_free_path(path);
-					return ret;
-				} else if (ret > 0) {
-					/* No more leaves to search */
-					if (verbose)
-						printf("Reached the end of "
-						       "the tree searching the"
-						       " directory\n");
-					btrfs_free_path(path);
-					return 0;
-				}
-				leaf = path->nodes[0];
-			} while (!leaf);
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error searching %d\n",
+					ret);
+				btrfs_free_path(path);
+				return ret;
+			} else if (ret > 0) {
+				/* No more leaves to search */
+				if (verbose)
+					printf("Reached the end of "
+					       "the tree searching the"
+					       " directory\n");
+				btrfs_free_path(path);
+				return 0;
+			}
+			leaf = path->nodes[0];
 			continue;
 		}
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
@@ -884,20 +844,16 @@ again:
 		ret = 0;
 		goto out;
 	}
-	do {
-		ret = btrfs_next_leaf(root, path);
-		if (ret < 0) {
-			fprintf(stderr, "Error getting next leaf %d\n",
-				ret);
-			goto out;
-		} else if (ret > 0) {
-			fprintf(stderr, "No more leaves\n");
-			goto out;
-		}
-	} while (!path->nodes[0]);
-	if (path->nodes[0])
-		goto again;
-	printf("Couldn't find a dir index item\n");
+	ret = btrfs_next_leaf(root, path);
+	if (ret < 0) {
+		fprintf(stderr, "Error getting next leaf %d\n",
+			ret);
+		goto out;
+	} else if (ret > 0) {
+		fprintf(stderr, "No more leaves\n");
+		goto out;
+	}
+	goto again;
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.7.9.5

