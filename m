Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60351 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbaJJU5r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:47 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKu9r9028584
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:47 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxprq81nh-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:47 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/12] Btrfs-progs: add ability to corrupt dir items
Date: Fri, 10 Oct 2014 16:57:16 -0400
Message-ID: <1412974637-31334-12-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to test the dir index corruption fixing patches in fsck we need to add
functionality to btrfs-corrupt-block to corrupt dir item fields.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 3e36f90..66d9f02 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -111,6 +111,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
 	fprintf(stderr, "\t-I An item to corrupt (must also specify the field "
 		"to corrupt and a root+key for the item)\n");
+	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
 	exit(1);
 }
 
@@ -304,6 +305,12 @@ enum btrfs_file_extent_field {
 	BTRFS_FILE_EXTENT_BAD,
 };
 
+enum btrfs_dir_item_field {
+	BTRFS_DIR_ITEM_NAME,
+	BTRFS_DIR_ITEM_LOCATION_OBJECTID,
+	BTRFS_DIR_ITEM_BAD,
+};
+
 enum btrfs_metadata_block_field {
 	BTRFS_METADATA_BLOCK_GENERATION,
 	BTRFS_METADATA_BLOCK_SHIFT_ITEMS,
@@ -364,6 +371,15 @@ static enum btrfs_item_field convert_item_field(char *field)
 	return BTRFS_ITEM_BAD;
 }
 
+static enum btrfs_dir_item_field convert_dir_item_field(char *field)
+{
+	if (!strncmp(field, "name", FIELD_BUF_LEN))
+		return BTRFS_DIR_ITEM_NAME;
+	if (!strncmp(field, "location_objectid", FIELD_BUF_LEN))
+		return BTRFS_DIR_ITEM_LOCATION_OBJECTID;
+	return BTRFS_DIR_ITEM_BAD;
+}
+
 static u64 generate_u64(u64 orig)
 {
 	u64 ret;
@@ -448,6 +464,80 @@ out:
 	return ret;
 }
 
+static int corrupt_dir_item(struct btrfs_root *root, struct btrfs_key *key,
+			    char *field)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_dir_item *di;
+	struct btrfs_path *path;
+	char *name;
+	struct btrfs_key location;
+	struct btrfs_disk_key disk_key;
+	unsigned long name_ptr;
+	enum btrfs_dir_item_field corrupt_field =
+		convert_dir_item_field(field);
+	u64 bogus;
+	u16 name_len;
+	int ret;
+
+	if (corrupt_field == BTRFS_DIR_ITEM_BAD) {
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
+		return PTR_ERR(trans);
+	}
+
+	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		fprintf(stderr, "Error searching for dir item %d\n", ret);
+		goto out;
+	}
+
+	di = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_dir_item);
+
+	switch (corrupt_field) {
+	case BTRFS_DIR_ITEM_NAME:
+		name_len = btrfs_dir_name_len(path->nodes[0], di);
+		name = malloc(name_len);
+		if (!name) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		name_ptr = (unsigned long)(di + 1);
+		read_extent_buffer(path->nodes[0], name, name_ptr, name_len);
+		name[0]++;
+		write_extent_buffer(path->nodes[0], name, name_ptr, name_len);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		free(name);
+		goto out;
+	case BTRFS_DIR_ITEM_LOCATION_OBJECTID:
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
+		bogus = generate_u64(location.objectid);
+		location.objectid = bogus;
+		btrfs_cpu_key_to_disk(&disk_key, &location);
+		btrfs_set_dir_item_key(path->nodes[0], di, &disk_key);
+		btrfs_mark_buffer_dirty(path->nodes[0]);
+		goto out;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
 
 static int corrupt_inode(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 inode, char *field)
@@ -772,6 +862,7 @@ static struct option long_options[] = {
 	{ "key", 1, NULL, 'K'},
 	{ "delete", 0, NULL, 'd'},
 	{ "item", 0, NULL, 'I'},
+	{ "dir-item", 0, NULL, 'D'},
 	{ 0, 0, 0, 0}
 };
 
@@ -937,6 +1028,7 @@ int main(int ac, char **av)
 	int chunk_tree = 0;
 	int delete = 0;
 	int corrupt_item = 0;
+	int corrupt_di = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -948,7 +1040,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:dI",
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:dID",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1005,6 +1097,9 @@ int main(int ac, char **av)
 			case 'I':
 				corrupt_item = 1;
 				break;
+			case 'D':
+				corrupt_di = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -1113,6 +1208,12 @@ int main(int ac, char **av)
 		ret = corrupt_btrfs_item(root, &key, field);
 		goto out_close;
 	}
+	if (corrupt_di) {
+		if (!key.objectid || !strlen(field))
+			print_usage();
+		ret = corrupt_dir_item(root, &key, field);
+		goto out_close;
+	}
 	if (key.objectid || key.offset || key.type) {
 		if (!strlen(field))
 			print_usage();
-- 
1.8.3.1

