Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32685 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaJaSCJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:09 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/11] Btrfs-progs: add the ability to delete items
Date: Fri, 31 Oct 2014 14:01:19 -0400
Message-ID: <1414778489-4049-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somtetimes you just need to delete an item, add that functionality to
btrfs-corrupt-block.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 171c81d..af9ae4d 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -111,6 +111,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-I An item to corrupt (must also specify the field "
 		"to corrupt and a root+key for the item)\n");
 	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
+	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
 	exit(1);
 }
 
@@ -811,6 +812,39 @@ out:
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
@@ -828,6 +862,7 @@ static struct option long_options[] = {
 	{ "key", 1, NULL, 'K'},
 	{ "item", 0, NULL, 'I'},
 	{ "dir-item", 0, NULL, 'D'},
+	{ "delete", 0, NULL, 'd'},
 	{ 0, 0, 0, 0}
 };
 
@@ -993,6 +1028,7 @@ int main(int ac, char **av)
 	int chunk_tree = 0;
 	int corrupt_item = 0;
 	int corrupt_di = 0;
+	int delete = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -1004,7 +1040,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:ID", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDd", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1060,6 +1096,8 @@ int main(int ac, char **av)
 				break;
 			case 'I':
 				corrupt_item = 1;
+			case 'd':
+				delete = 1;
 				break;
 			default:
 				print_usage();
@@ -1167,6 +1205,11 @@ int main(int ac, char **av)
 		if (!key.objectid)
 			print_usage();
 		ret = corrupt_btrfs_item(root, &key, field);
+	}
+	if (delete) {
+		if (!key.objectid)
+			print_usage();
+		ret = delete_item(root, &key);
 		goto out_close;
 	}
 	if (key.objectid || key.offset || key.type) {
-- 
1.8.3.1

