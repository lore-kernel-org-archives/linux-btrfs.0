Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44107 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3GISuZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 14:50:25 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so4992144wes.40
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 11:50:24 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs-progs: remove duplicated code in cmds-restore.c
Date: Tue,  9 Jul 2013 19:49:53 +0100
Message-Id: <1373395794-29140-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
References: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The module cmds-restore.c was defining its own next_leaf()
function, which did exactly the same as btrfs_next_leaf()
from ctree.c.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-restore.c |   62 +++++---------------------------------------------------
 1 file changed, 5 insertions(+), 57 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index eca528d..ed4815a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -148,58 +148,6 @@ static int decompress(char *inbuf, char *outbuf, u64 compress_len,
 	return -1;
 }
 
-int next_leaf(struct btrfs_root *root, struct btrfs_path *path)
-{
-	int slot;
-	int level = 1;
-	struct extent_buffer *c;
-	struct extent_buffer *next = NULL;
-
-	for (; level < BTRFS_MAX_LEVEL; level++) {
-		if (path->nodes[level])
-			break;
-	}
-
-	if (level == BTRFS_MAX_LEVEL)
-		return 1;
-
-	slot = path->slots[level] + 1;
-
-	while(level < BTRFS_MAX_LEVEL) {
-		if (!path->nodes[level])
-			return 1;
-
-		slot = path->slots[level] + 1;
-		c = path->nodes[level];
-		if (slot >= btrfs_header_nritems(c)) {
-			level++;
-			if (level == BTRFS_MAX_LEVEL)
-				return 1;
-			continue;
-		}
-
-		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
-
-		next = read_node_slot(root, c, slot);
-		break;
-	}
-	path->slots[level] = slot;
-	while(1) {
-		level--;
-		c = path->nodes[level];
-		free_extent_buffer(c);
-		path->nodes[level] = next;
-		path->slots[level] = 0;
-		if (!level)
-			break;
-		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
-		next = read_node_slot(root, next, 0);
-	}
-	return 0;
-}
-
 static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 {
 	struct extent_buffer *leaf = path->nodes[0];
@@ -447,7 +395,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 
 	leaf = path->nodes[0];
 	while (!leaf) {
-		ret = next_leaf(root, path);
+		ret = btrfs_next_leaf(root, path);
 		if (ret < 0) {
 			fprintf(stderr, "Error getting next leaf %d\n",
 				ret);
@@ -470,7 +418,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		}
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			do {
-				ret = next_leaf(root, path);
+				ret = btrfs_next_leaf(root, path);
 				if (ret < 0) {
 					fprintf(stderr, "Error searching %d\n", ret);
 					btrfs_free_path(path);
@@ -569,7 +517,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		if (verbose > 1)
 			printf("No leaf after search, looking for the next "
 			       "leaf\n");
-		ret = next_leaf(root, path);
+		ret = btrfs_next_leaf(root, path);
 		if (ret < 0) {
 			fprintf(stderr, "Error getting next leaf %d\n",
 				ret);
@@ -596,7 +544,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
 			do {
-				ret = next_leaf(root, path);
+				ret = btrfs_next_leaf(root, path);
 				if (ret < 0) {
 					fprintf(stderr, "Error searching %d\n",
 						ret);
@@ -937,7 +885,7 @@ again:
 		goto out;
 	}
 	do {
-		ret = next_leaf(root, path);
+		ret = btrfs_next_leaf(root, path);
 		if (ret < 0) {
 			fprintf(stderr, "Error getting next leaf %d\n",
 				ret);
-- 
1.7.9.5

