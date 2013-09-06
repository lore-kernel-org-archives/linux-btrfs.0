Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58747 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3IFN0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 09:26:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 78D267C042F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Sep 2013 07:26:22 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id CW3xb0tNRJazAiAh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 06 Sep 2013 07:26:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: setup framework to corrupt specific fields of an inode V2
Date: Fri, 6 Sep 2013 09:26:19 -0400
Message-ID: <1378473979-2432-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem with his fs where he had a bogus isize on his
directory.  In order to make sure my patch for fsck fixes this properly I needed
to be able to corrupt an inode like this, which is what this patch is for.
Eventually I want to extend this to corrupt everything so we can integrate tests
into btrfs-progs to run btrfsck against to make sure we don't regress on fixing
things with btrfsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: rework the error handling for our options so that each individual mode
can check its own requirements, making it less confusing and error prone.

 btrfs-corrupt-block.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 8176fad..65cebfc 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -32,6 +32,8 @@
 #include "list.h"
 #include "version.h"
 
+#define FIELD_BUF_LEN 80
+
 struct extent_buffer *debug_corrupt_block(struct btrfs_root *root, u64 bytenr,
 				     u32 blocksize, int copy)
 {
@@ -93,6 +95,9 @@ static void print_usage(void)
 	fprintf(stderr, "\t-b Number of bytes to be corrupted\n");
 	fprintf(stderr, "\t-e Extent to be corrupted\n");
 	fprintf(stderr, "\t-E The whole extent free to be corrupted\n");
+	fprintf(stderr, "\t-i The inode item to corrupt (must also specify "
+		"the field to corrupt\n");
+	fprintf(stderr, "\t-f The field in the item to corrupt\n");
 	exit(1);
 }
 
@@ -268,6 +273,83 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 	}
 }
 
+enum btrfs_inode_field {
+	BTRFS_INODE_FIELD_ISIZE,
+	BTRFS_INODE_FIELD_BAD,
+};
+
+static enum btrfs_inode_field convert_field(char *field)
+{
+	if (!strncmp(field, "isize", FIELD_BUF_LEN))
+		return BTRFS_INODE_FIELD_ISIZE;
+	return BTRFS_INODE_FIELD_BAD;
+}
+
+static int corrupt_inode(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root, u64 inode, char *field)
+{
+	struct btrfs_inode_item *ei;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	enum btrfs_inode_field corrupt_field = convert_field(field);
+	u64 bogus;
+	u64 orig;
+	int ret;
+
+	if (corrupt_field == BTRFS_INODE_FIELD_BAD) {
+		fprintf(stderr, "Invalid field %s\n", field);
+		return -EINVAL;
+	}
+
+	key.objectid = inode;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		if (!path->slots[0]) {
+			fprintf(stderr, "Couldn't find inode %Lu\n", inode);
+			ret = -ENOENT;
+			goto out;
+		}
+		path->slots[0]--;
+		ret = 0;
+	}
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid != inode) {
+		fprintf(stderr, "Couldn't find inode %Lu\n", inode);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_inode_item);
+	switch (corrupt_field) {
+	case BTRFS_INODE_FIELD_ISIZE:
+		orig = btrfs_inode_size(path->nodes[0], ei);
+		do {
+			bogus = rand();
+		} while (bogus == orig);
+
+		btrfs_set_inode_size(path->nodes[0], ei, bogus);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct option long_options[] = {
 	/* { "byte-count", 1, NULL, 'b' }, */
 	{ "logical", 1, NULL, 'l' },
@@ -276,6 +358,8 @@ static struct option long_options[] = {
 	{ "extent-record", 0, NULL, 'e' },
 	{ "extent-tree", 0, NULL, 'E' },
 	{ "keys", 0, NULL, 'k' },
+	{ "inode", 1, NULL, 'i'},
+	{ "field", 1, NULL, 'f'},
 	{ 0, 0, 0, 0}
 };
 
@@ -294,12 +378,15 @@ int main(int ac, char **av)
 	int extent_rec = 0;
 	int extent_tree = 0;
 	int corrupt_block_keys = 0;
+	u64 inode = 0;
+	char field[FIELD_BUF_LEN];
 
+	field[0] = '\0';
 	srand(128);
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEk", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEki:f:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -314,7 +401,7 @@ int main(int ac, char **av)
 				break;
 			case 'c':
 				copy = atoi(optarg);
-				if (copy == 0) {
+				if (copy <= 0) {
 					fprintf(stderr,
 						"invalid copy number\n");
 					print_usage();
@@ -337,6 +424,17 @@ int main(int ac, char **av)
 			case 'k':
 				corrupt_block_keys = 1;
 				break;
+			case 'i':
+				inode = atoll(optarg);
+				if (inode == 0) {
+					fprintf(stderr,
+						"invalid inode number\n");
+					print_usage();
+				}
+				break;
+			case 'f':
+				strncpy(field, optarg, FIELD_BUF_LEN);
+				break;
 			default:
 				print_usage();
 		}
@@ -344,10 +442,6 @@ int main(int ac, char **av)
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
-	if (logical == 0 && !extent_tree)
-		print_usage();
-	if (copy < 0)
-		print_usage();
 
 	dev = av[optind];
 
@@ -361,6 +455,9 @@ int main(int ac, char **av)
 	}
 	if (extent_rec) {
 		struct btrfs_trans_handle *trans;
+
+		if (logical == 0)
+			print_usage();
 		trans = btrfs_start_transaction(root, 1);
 		ret = corrupt_extent (trans, root, logical, 0);
 		btrfs_commit_transaction(trans, root);
@@ -374,6 +471,20 @@ int main(int ac, char **av)
 		btrfs_commit_transaction(trans, root);
 		goto out_close;
 	}
+	if (inode) {
+		struct btrfs_trans_handle *trans;
+
+		if (!strlen(field))
+			print_usage();
+		printf("corrupting inode\n");
+		trans = btrfs_start_transaction(root, 1);
+		ret = corrupt_inode(trans, root, inode, field);
+		btrfs_commit_transaction(trans, root);
+		goto out_close;
+	}
+
+	if (logical == 0)
+		print_usage();
 
 	if (bytes == 0)
 		bytes = root->sectorsize;
-- 
1.7.7.6

