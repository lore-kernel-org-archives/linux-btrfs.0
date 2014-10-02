Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28131 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbaJBTM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 15:12:28 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s92J7awt020021
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 12:12:27 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pscd2822v-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 12:12:24 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: corrupt btrfs items in btrfs-corrup-block
Date: Thu, 2 Oct 2014 15:12:20 -0400
Message-ID: <1412277140-9753-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For testing fsck against completely broken btrfs_items.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 278a56f..c58f01a 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -109,6 +109,8 @@ static void print_usage(void)
 		"<num>,<num>,<num> (must also specify -f for the field)\n");
 	fprintf(stderr, "\t-f The field in the item to corrupt\n");
 	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
+	fprintf(stderr, "\t-I An item to corrupt (must also specify the field "
+		"to corrupt and a root+key for the item)\n");
 	exit(1);
 }
 
@@ -308,6 +310,11 @@ enum btrfs_metadata_block_field {
 	BTRFS_METADATA_BLOCK_BAD,
 };
 
+enum btrfs_item_field {
+	BTRFS_ITEM_OFFSET,
+	BTRFS_ITEM_BAD,
+};
+
 enum btrfs_key_field {
 	BTRFS_KEY_OBJECTID,
 	BTRFS_KEY_TYPE,
@@ -350,6 +357,13 @@ static enum btrfs_key_field convert_key_field(char *field)
 	return BTRFS_KEY_BAD;
 }
 
+static enum btrfs_item_field convert_item_field(char *field)
+{
+	if (!strncmp(field, "offset", FIELD_BUF_LEN))
+		return BTRFS_ITEM_OFFSET;
+	return BTRFS_ITEM_BAD;
+}
+
 static u64 generate_u64(u64 orig)
 {
 	u64 ret;
@@ -359,6 +373,15 @@ static u64 generate_u64(u64 orig)
 	return ret;
 }
 
+static u32 generate_u32(u32 orig)
+{
+	u32 ret;
+	do {
+		ret = rand();
+	} while (ret == orig);
+	return ret;
+}
+
 static u8 generate_u8(u8 orig)
 {
 	u8 ret;
@@ -679,6 +702,58 @@ out:
 	return ret;
 }
 
+static int corrupt_btrfs_item(struct btrfs_root *root, struct btrfs_key *key,
+			      char *field)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	enum btrfs_item_field corrupt_field;
+	u32 orig, bogus;
+	int ret;
+
+	corrupt_field = convert_item_field(field);
+	if (corrupt_field == BTRFS_ITEM_BAD) {
+		fprintf(stderr, "Invalid field %s\n", field);
+		return -EINVAL;
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
+	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
+	if (ret != 0) {
+		fprintf(stderr, "Error searching to node %d\n", ret);
+		goto out;
+	}
+
+	ret = 0;
+	switch (corrupt_field) {
+	case BTRFS_ITEM_OFFSET:
+		orig = btrfs_item_offset_nr(path->nodes[0], path->slots[0]);
+		bogus = generate_u32(orig);
+		btrfs_set_item_offset(path->nodes[0],
+				      btrfs_item_nr(path->slots[0]), bogus);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct option long_options[] = {
 	/* { "byte-count", 1, NULL, 'b' }, */
 	{ "logical", 1, NULL, 'l' },
@@ -695,6 +770,7 @@ static struct option long_options[] = {
 	{ "field", 1, NULL, 'f'},
 	{ "key", 1, NULL, 'K'},
 	{ "delete", 0, NULL, 'd'},
+	{ "item", 0, NULL, 'I'},
 	{ 0, 0, 0, 0}
 };
 
@@ -859,6 +935,7 @@ int main(int ac, char **av)
 	int chunk_rec = 0;
 	int chunk_tree = 0;
 	int delete = 0;
+	int corrupt_item = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -870,8 +947,8 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:d", long_options,
-				&option_index);
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:dI",
+				long_options, &option_index);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -924,6 +1001,9 @@ int main(int ac, char **av)
 			case 'd':
 				delete = 1;
 				break;
+			case 'I':
+				corrupt_item = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -1026,6 +1106,12 @@ int main(int ac, char **av)
 		ret = delete_item(root, &key);
 		goto out_close;
 	}
+	if (corrupt_item) {
+		if (!key.objectid)
+			print_usage();
+		ret = corrupt_btrfs_item(root, &key, field);
+		goto out_close;
+	}
 	if (key.objectid || key.offset || key.type) {
 		if (!strlen(field))
 			print_usage();
-- 
1.8.3.1

