Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:16396 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3FZPSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:18:00 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 31.28 OK)
	with ESMTP id 6031fep5QF43IE for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Jun 2013 17:17:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 5/5] Btrfs-progs: add option to btrfs-debug-tree to print uuid tree only
Date: Wed, 26 Jun 2013 17:17:59 +0200
Message-Id: <b586203e77ae2694d13875b3a08e8e9ea8e5fbfd.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-debug-tree.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index bae7f94..c0eae9b 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -30,13 +30,14 @@
 
 static int print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-debug-tree [ -e ] [ -d ] [ -r ] [ -R ]\n");
+	fprintf(stderr, "usage: btrfs-debug-tree [-e] [-d] [-r] [-R] [-u]\n");
 	fprintf(stderr, "                        [-b block_num ] device\n");
 	fprintf(stderr, "\t-e : print detailed extents info\n");
 	fprintf(stderr, "\t-d : print info of btrfs device and root tree dirs"
                     " only\n");
 	fprintf(stderr, "\t-r : print info of roots only\n");
 	fprintf(stderr, "\t-R : print info of roots and root backups\n");
+	fprintf(stderr, "\t-u : print info of uuid tree only\n");
 	fprintf(stderr, "\t-b block_num : print info of the specified block"
                     " only\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
@@ -129,6 +130,7 @@ int main(int ac, char **av)
 	int slot;
 	int extent_only = 0;
 	int device_only = 0;
+	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
 	u64 block_only = 0;
@@ -138,7 +140,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "deb:rR");
+		c = getopt(ac, av, "deb:rRu");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -151,6 +153,9 @@ int main(int ac, char **av)
 			case 'r':
 				roots_only = 1;
 				break;
+			case 'u':
+				uuid_tree_only = 1;
+				break;
 			case 'R':
 				roots_only = 1;
 				root_backups = 1;
@@ -201,7 +206,7 @@ int main(int ac, char **av)
 		return 0;
 	}
 
-	if (!extent_only) {
+	if (!(extent_only || uuid_tree_only)) {
 		if (roots_only) {
 			printf("root tree: %llu level %d\n",
 			     (unsigned long long)info->tree_root->node->start,
@@ -250,7 +255,7 @@ again:
 		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
 			struct extent_buffer *buf;
-			int skip = extent_only | device_only;
+			int skip = extent_only | device_only | uuid_tree_only;
 
 			offset = btrfs_item_ptr_offset(leaf, slot);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
@@ -268,9 +273,9 @@ again:
 					printf("root");
 				break;
 			case BTRFS_EXTENT_TREE_OBJECTID:
-				if (!device_only)
+				if (!device_only && !uuid_tree_only)
 					skip = 0;
-				if (!extent_only && !device_only)
+				if (!skip)
 					printf("extent");
 				break;
 			case BTRFS_CHUNK_TREE_OBJECTID:
@@ -279,8 +284,10 @@ again:
 				}
 				break;
 			case BTRFS_DEV_TREE_OBJECTID:
-				skip = 0;
-				printf("device");
+				if (!uuid_tree_only)
+					skip = 0;
+				if (!skip)
+					printf("device");
 				break;
 			case BTRFS_FS_TREE_OBJECTID:
 				if (!skip) {
@@ -331,6 +338,12 @@ again:
 					printf("quota");
 				}
 				break;
+			case BTRFS_UUID_TREE_OBJECTID:
+				if (!extent_only && !device_only)
+					skip = 0;
+				if (!skip)
+					printf("uuid");
+				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
 				if (!skip) {
 					printf("multiple");
@@ -368,7 +381,7 @@ no_node:
 		goto again;
 	}
 
-	if (extent_only || device_only)
+	if (extent_only || device_only || uuid_tree_only)
 		return 0;
 
 	if (root_backups)
-- 
1.8.3

