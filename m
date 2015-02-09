Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6896 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760826AbbBIUDx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:53 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 01/16] Btrfs-progs: let btrfs-corrupt-block specify a root
Date: Mon, 9 Feb 2015 15:03:04 -0500
Message-ID: <1423512199-16552-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes we want to corrupt specific keys or delete items on different roots,
so allow btrfs-corrupt-block to take a root objectid so we can corrupt a
specific root.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 5db18a1..f332bdf 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -109,6 +109,7 @@ static void print_usage(void)
 		"to corrupt and a root+key for the item)\n");
 	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
 	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
+	fprintf(stderr, "\t-r Operate on this root (only works with -d)\n");
 	exit(1);
 }
 
@@ -1007,6 +1008,7 @@ int main(int ac, char **av)
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
+	u64 root_objectid = 0;
 	char field[FIELD_BUF_LEN];
 
 	field[0] = '\0';
@@ -1034,11 +1036,12 @@ int main(int ac, char **av)
 			{ "item", 0, NULL, 'I'},
 			{ "dir-item", 0, NULL, 'D'},
 			{ "delete", 0, NULL, 'd'},
+			{ "root", 0, NULL, 'r'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDd", long_options,
-				&option_index);
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDdr:",
+				long_options, &option_index);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -1098,6 +1101,9 @@ int main(int ac, char **av)
 			case 'd':
 				delete = 1;
 				break;
+			case 'r':
+				root_objectid = arg_strtou64(optarg);
+				break;
 			default:
 				print_usage();
 		}
@@ -1206,9 +1212,25 @@ int main(int ac, char **av)
 		ret = corrupt_btrfs_item(root, &key, field);
 	}
 	if (delete) {
+		struct btrfs_root *target = root;
+
 		if (!key.objectid)
 			print_usage();
-		ret = delete_item(root, &key);
+		if (root_objectid) {
+			struct btrfs_key root_key;
+
+			root_key.objectid = root_objectid;
+			root_key.type = BTRFS_ROOT_ITEM_KEY;
+			root_key.offset = (u64)-1;
+
+			target = btrfs_read_fs_root(root->fs_info, &root_key);
+			if (IS_ERR(target)) {
+				fprintf(stderr, "Couldn't find root %llu\n",
+					(unsigned long long)root_objectid);
+				print_usage();
+			}
+		}
+		ret = delete_item(target, &key);
 		goto out_close;
 	}
 	if (key.objectid || key.offset || key.type) {
-- 
1.8.3.1

