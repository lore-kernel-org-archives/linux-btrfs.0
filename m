Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33601 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3JAMzB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 08:55:01 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B2AAE9A06A1
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Oct 2013 06:55:00 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id K9Jz5vqjk8HuarGt (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 06:55:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add ability to corrupt metadata block fields
Date: Tue, 1 Oct 2013 08:54:58 -0400
Message-ID: <1380632098-1160-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allows us to garble the generation field of a metadata block.  We
will search down to the block, set the bogus generation and write the block back
out.  I used this for verifying a transid fix patch for btrfsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-corrupt-block.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 117 insertions(+), 3 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 1f54b36..2d76ceb 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -102,6 +102,8 @@ static void print_usage(void)
 		"the field to corrupt)\n");
 	fprintf(stderr, "\t-x The file extent item to corrupt (must also "
 		"specify -i for the inode and -f for the field to corrupt)\n");
+	fprintf(stderr, "\t-m The metadata block to corrupt (must also "
+		"specify -f for the field to corrupt)\n");
 	fprintf(stderr, "\t-f The field in the item to corrupt\n");
 	exit(1);
 }
@@ -138,7 +140,9 @@ static void corrupt_keys(struct btrfs_trans_handle *trans,
 	}
 	btrfs_mark_buffer_dirty(eb);
 	if (!trans) {
-		csum_tree_block(root, eb, 0);
+		u16 csum_size =
+			btrfs_super_csum_size(root->fs_info->super_copy);
+		csum_tree_block_size(eb, csum_size, 0);
 		write_extent_to_disk(eb);
 	}
 }
@@ -296,6 +300,11 @@ enum btrfs_file_extent_field {
 	BTRFS_FILE_EXTENT_BAD,
 };
 
+enum btrfs_metadata_block_field {
+	BTRFS_METADATA_BLOCK_GENERATION,
+	BTRFS_METADATA_BLOCK_BAD,
+};
+
 static enum btrfs_inode_field convert_inode_field(char *field)
 {
 	if (!strncmp(field, "isize", FIELD_BUF_LEN))
@@ -310,6 +319,14 @@ static enum btrfs_file_extent_field convert_file_extent_field(char *field)
 	return BTRFS_FILE_EXTENT_BAD;
 }
 
+static enum btrfs_metadata_block_field
+convert_metadata_block_field(char *field)
+{
+	if (!strncmp(field, "generation", FIELD_BUF_LEN))
+		return BTRFS_METADATA_BLOCK_GENERATION;
+	return BTRFS_METADATA_BLOCK_BAD;
+}
+
 static u64 generate_u64(u64 orig)
 {
 	u64 ret;
@@ -435,6 +452,87 @@ out:
 	return ret;
 }
 
+static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
+				  char *field)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct extent_buffer *eb;
+	struct btrfs_key key, root_key;
+	enum btrfs_metadata_block_field corrupt_field;
+	u64 root_objectid;
+	u64 orig, bogus;
+	u8 level;
+	int ret;
+
+	corrupt_field = convert_metadata_block_field(field);
+	if (corrupt_field == BTRFS_METADATA_BLOCK_BAD) {
+		fprintf(stderr, "Invalid field %s\n", field);
+		return -EINVAL;
+	}
+
+	eb = read_tree_block(root, block, root->leafsize, 0);
+	if (!eb) {
+		fprintf(stderr, "Couldn't read in tree block %s\n", field);
+		return -EINVAL;
+	}
+	root_objectid = btrfs_header_owner(eb);
+	level = btrfs_header_level(eb);
+	if (level)
+		btrfs_node_key_to_cpu(eb, &key, 0);
+	else
+		btrfs_item_key_to_cpu(eb, &key, 0);
+	free_extent_buffer(eb);
+
+	root_key.objectid = root_objectid;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &root_key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Couldn't finde owner root %llu\n",
+			key.objectid);
+		return PTR_ERR(root);
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		fprintf(stderr, "Couldn't start transaction %ld\n",
+			PTR_ERR(trans));
+		return PTR_ERR(trans);
+	}
+
+	path->lowest_level = level;
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching to node %d\n", ret);
+		goto out;
+	}
+	eb = path->nodes[level];
+
+	ret = 0;
+	switch (corrupt_field) {
+	case BTRFS_METADATA_BLOCK_GENERATION:
+		orig = btrfs_header_generation(eb);
+		bogus = generate_u64(orig);
+		btrfs_set_header_generation(eb, bogus);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	btrfs_mark_buffer_dirty(path->nodes[level]);
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct option long_options[] = {
 	/* { "byte-count", 1, NULL, 'b' }, */
 	{ "logical", 1, NULL, 'l' },
@@ -447,6 +545,7 @@ static struct option long_options[] = {
 	{ "chunk-tree", 0, NULL, 'U' },
 	{ "inode", 1, NULL, 'i'},
 	{ "file-extent", 1, NULL, 'x'},
+	{ "metadata-block", 1, NULL, 'm'},
 	{ "field", 1, NULL, 'f'},
 	{ 0, 0, 0, 0}
 };
@@ -608,6 +707,7 @@ int main(int ac, char **av)
 	int corrupt_block_keys = 0;
 	int chunk_rec = 0;
 	int chunk_tree = 0;
+	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
 	char field[FIELD_BUF_LEN];
@@ -617,7 +717,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -675,6 +775,15 @@ int main(int ac, char **av)
 					print_usage();
 				}
 				break;
+			case 'm':
+				errno = 0;
+				metadata_block = atoll(optarg);
+				if (errno) {
+					fprintf(stderr, "error converting "
+						"%d\n", errno);
+					print_usage();
+				}
+				break;
 			default:
 				print_usage();
 		}
@@ -760,7 +869,12 @@ int main(int ac, char **av)
 		btrfs_commit_transaction(trans, root);
 		goto out_close;
 	}
-
+	if (metadata_block) {
+		if (!strlen(field))
+			print_usage();
+		ret = corrupt_metadata_block(root, metadata_block, field);
+		goto out_close;
+	}
 	/*
 	 * If we made it here and we have extent set then we didn't specify
 	 * inode and we're screwed.
-- 
1.8.3.1

