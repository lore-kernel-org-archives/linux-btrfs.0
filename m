Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33811 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IFSPE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 14:15:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7E27C7C0351
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Sep 2013 12:15:04 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id konBIypzgol04GUi (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 06 Sep 2013 12:15:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add ability to corrupt file extent disk bytenr
Date: Fri, 6 Sep 2013 14:15:01 -0400
Message-ID: <1378491301-4866-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a corrupt fs where one of his file extents pointed to a completely
bogus disk bytenr.  This patch allows us to corrupt a file system in a similar
way in order to test btrfsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-corrupt-block.c |  117 +++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 65cebfc..dc85889 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -97,6 +97,8 @@ static void print_usage(void)
 	fprintf(stderr, "\t-E The whole extent free to be corrupted\n");
 	fprintf(stderr, "\t-i The inode item to corrupt (must also specify "
 		"the field to corrupt\n");
+	fprintf(stderr, "\t-x The file extent item to corrupt (must also "
+		"specify -i for the inode and -f for the field to corrupt)\n");
 	fprintf(stderr, "\t-f The field in the item to corrupt\n");
 	exit(1);
 }
@@ -278,20 +280,41 @@ enum btrfs_inode_field {
 	BTRFS_INODE_FIELD_BAD,
 };
 
-static enum btrfs_inode_field convert_field(char *field)
+enum btrfs_file_extent_field {
+	BTRFS_FILE_EXTENT_DISK_BYTENR,
+	BTRFS_FILE_EXTENT_BAD,
+};
+
+static enum btrfs_inode_field convert_inode_field(char *field)
 {
 	if (!strncmp(field, "isize", FIELD_BUF_LEN))
 		return BTRFS_INODE_FIELD_ISIZE;
 	return BTRFS_INODE_FIELD_BAD;
 }
 
+static enum btrfs_file_extent_field convert_file_extent_field(char *field)
+{
+	if (!strncmp(field, "disk_bytenr", FIELD_BUF_LEN))
+		return BTRFS_FILE_EXTENT_DISK_BYTENR;
+	return BTRFS_FILE_EXTENT_BAD;
+}
+
+static u64 generate_u64(u64 orig)
+{
+	u64 ret;
+	do {
+		ret = rand();
+	} while (ret == orig);
+	return ret;
+}
+
 static int corrupt_inode(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 inode, char *field)
 {
 	struct btrfs_inode_item *ei;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	enum btrfs_inode_field corrupt_field = convert_field(field);
+	enum btrfs_inode_field corrupt_field = convert_inode_field(field);
 	u64 bogus;
 	u64 orig;
 	int ret;
@@ -334,10 +357,7 @@ static int corrupt_inode(struct btrfs_trans_handle *trans,
 	switch (corrupt_field) {
 	case BTRFS_INODE_FIELD_ISIZE:
 		orig = btrfs_inode_size(path->nodes[0], ei);
-		do {
-			bogus = rand();
-		} while (bogus == orig);
-
+		bogus = generate_u64(orig);
 		btrfs_set_inode_size(path->nodes[0], ei, bogus);
 		break;
 	default:
@@ -350,6 +370,60 @@ out:
 	return ret;
 }
 
+static int corrupt_file_extent(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, u64 inode, u64 extent,
+			       char *field)
+{
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	enum btrfs_file_extent_field corrupt_field;
+	u64 bogus;
+	u64 orig;
+	int ret = 0;
+
+	corrupt_field = convert_file_extent_field(field);
+	if (corrupt_field == BTRFS_FILE_EXTENT_BAD) {
+		fprintf(stderr, "Invalid field %s\n", field);
+		return -EINVAL;
+	}
+
+	key.objectid = inode;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = extent;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		fprintf(stderr, "Couldn't find extent %llu for inode %llu\n",
+			extent, inode);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	switch (corrupt_field) {
+	case BTRFS_FILE_EXTENT_DISK_BYTENR:
+		orig = btrfs_file_extent_disk_bytenr(path->nodes[0], fi);
+		bogus = generate_u64(orig);
+		btrfs_set_file_extent_disk_bytenr(path->nodes[0], fi, bogus);
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
@@ -359,6 +433,7 @@ static struct option long_options[] = {
 	{ "extent-tree", 0, NULL, 'E' },
 	{ "keys", 0, NULL, 'k' },
 	{ "inode", 1, NULL, 'i'},
+	{ "file-extent", 1, NULL, 'x'},
 	{ "field", 1, NULL, 'f'},
 	{ 0, 0, 0, 0}
 };
@@ -379,6 +454,7 @@ int main(int ac, char **av)
 	int extent_tree = 0;
 	int corrupt_block_keys = 0;
 	u64 inode = 0;
+	u64 file_extent = (u64)-1;
 	char field[FIELD_BUF_LEN];
 
 	field[0] = '\0';
@@ -386,7 +462,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEki:f:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEki:f:x:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -435,6 +511,15 @@ int main(int ac, char **av)
 			case 'f':
 				strncpy(field, optarg, FIELD_BUF_LEN);
 				break;
+			case 'x':
+				errno = 0;
+				file_extent = atoll(optarg);
+				if (errno) {
+					fprintf(stderr, "error converting "
+						"%d\n", errno);
+					print_usage();
+				}
+				break;
 			default:
 				print_usage();
 		}
@@ -476,13 +561,27 @@ int main(int ac, char **av)
 
 		if (!strlen(field))
 			print_usage();
-		printf("corrupting inode\n");
+
 		trans = btrfs_start_transaction(root, 1);
-		ret = corrupt_inode(trans, root, inode, field);
+		if (file_extent == (u64)-1) {
+			printf("corrupting inode\n");
+			ret = corrupt_inode(trans, root, inode, field);
+		} else {
+			printf("corrupting file extent\n");
+			ret = corrupt_file_extent(trans, root, inode,
+						  file_extent, field);
+		}
 		btrfs_commit_transaction(trans, root);
 		goto out_close;
 	}
 
+	/*
+	 * If we made it here and we have extent set then we didn't specify
+	 * inode and we're screwed.
+	 */
+	if (file_extent != (u64)-1)
+		print_usage();
+
 	if (logical == 0)
 		print_usage();
 
-- 
1.7.7.6

