Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:61104 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaEWMoo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 08:44:44 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so4889327wes.14
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 05:44:43 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: debug-tree, add option to dump a single tree
Date: Fri, 23 May 2014 14:44:29 +0100
Message-Id: <1400852669-2100-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Very often while debugging filesystems with many subvolumes and/or
snapshots, specially when they are large, I want to see only the
content of one of the trees. So this change just adds an option
to btrfs-debug-tree to allow to specify the id of the tree we're
interesting in dumping to stdout.

Example:  btrfs-debug-tree -t 257 /dev/sdc

Will only dump the tree of the first snapshot or subvolume that was
created.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-debug-tree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index cb6c106..36e1115 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -41,6 +41,8 @@ static int print_usage(void)
 	fprintf(stderr, "\t-u : print info of uuid tree only\n");
 	fprintf(stderr, "\t-b block_num : print info of the specified block"
                     " only\n");
+	fprintf(stderr,
+		"\t-t tree_id : print only the tree with the given id\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -136,12 +138,13 @@ int main(int ac, char **av)
 	int root_backups = 0;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
+	u64 tree_id = 0;
 
 	radix_tree_init();
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "deb:rRu");
+		c = getopt(ac, av, "deb:rRut:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -164,6 +167,9 @@ int main(int ac, char **av)
 			case 'b':
 				block_only = arg_strtou64(optarg);
 				break;
+			case 't':
+				tree_id = arg_strtou64(optarg);
+				break;
 			default:
 				print_usage();
 		}
@@ -208,7 +214,7 @@ int main(int ac, char **av)
 		goto close_root;
 	}
 
-	if (!(extent_only || uuid_tree_only)) {
+	if (!(extent_only || uuid_tree_only || tree_id)) {
 		if (roots_only) {
 			printf("root tree: %llu level %d\n",
 			     (unsigned long long)info->tree_root->node->start,
@@ -268,6 +274,8 @@ again:
 					      0);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
+			if (tree_id && found_key.objectid != tree_id)
+				goto next;
 
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
-- 
1.9.1

