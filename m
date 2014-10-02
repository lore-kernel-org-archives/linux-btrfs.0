Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43827 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbaJBSuX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 14:50:23 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s92IkLth014637
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Oct 2014 11:50:22 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1ps8sv8s3j-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 11:50:22 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add the ability to delete items
Date: Thu, 2 Oct 2014 14:50:17 -0400
Message-ID: <1412275817-8005-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somtetimes you just need to delete an item, add that functionality to
btrfs-corrupt-block.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 22390b5..278a56f 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -108,6 +108,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-K The key to corrupt in the format "
 		"<num>,<num>,<num> (must also specify -f for the field)\n");
 	fprintf(stderr, "\t-f The field in the item to corrupt\n");
+	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
 	exit(1);
 }
 
@@ -645,6 +646,39 @@ out:
 	return ret;
 }
 
+static int delete_item(struct btrfs_root *root, struct btrfs_key *key)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	int ret;
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
+	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		fprintf(stderr, "Error searching to node %d\n", ret);
+		goto out;
+	}
+	ret = btrfs_del_item(trans, root, path);
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
@@ -660,6 +694,7 @@ static struct option long_options[] = {
 	{ "metadata-block", 1, NULL, 'm'},
 	{ "field", 1, NULL, 'f'},
 	{ "key", 1, NULL, 'K'},
+	{ "delete", 0, NULL, 'd'},
 	{ 0, 0, 0, 0}
 };
 
@@ -823,6 +858,7 @@ int main(int ac, char **av)
 	int corrupt_block_keys = 0;
 	int chunk_rec = 0;
 	int chunk_tree = 0;
+	int delete = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -834,7 +870,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:d", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -885,6 +921,9 @@ int main(int ac, char **av)
 					print_usage();
 				}
 				break;
+			case 'd':
+				delete = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -981,6 +1020,12 @@ int main(int ac, char **av)
 		ret = corrupt_metadata_block(root, metadata_block, field);
 		goto out_close;
 	}
+	if (delete) {
+		if (!key.objectid)
+			print_usage();
+		ret = delete_item(root, &key);
+		goto out_close;
+	}
 	if (key.objectid || key.offset || key.type) {
 		if (!strlen(field))
 			print_usage();
-- 
1.8.3.1

