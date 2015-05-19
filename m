Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11907 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933069AbbESOVI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 10:21:08 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t4JEGVo3018937
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 07:21:07 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1ug43urpxa-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 07:21:07 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add the ability to remove csums
Date: Tue, 19 May 2015 10:21:04 -0400
Message-ID: <1432045264-5285-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes we need to test what happens when we're missing a csum for a range, so
add an option to btrfs-corrupt-block to be able to remove a csum range.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index f332bdf..7fa92ab 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -110,6 +110,9 @@ static void print_usage(void)
 	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
 	fprintf(stderr, "\t-d Delete this item (must specify -K)\n");
 	fprintf(stderr, "\t-r Operate on this root (only works with -d)\n");
+	fprintf(stderr, "\t-C Delete a csum for the specified bytenr.  When "
+		"used with -b it'll delete that many bytes, otherwise it's "
+		"just sectorsize\n");
 	exit(1);
 }
 
@@ -843,6 +846,26 @@ out:
 	return ret;
 }
 
+static int delete_csum(struct btrfs_root *root, u64 bytenr, u64 bytes)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	root = root->fs_info->csum_root;
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		fprintf(stderr, "Couldn't start transaction %ld\n",
+			PTR_ERR(trans));
+		return PTR_ERR(trans);
+	}
+
+	ret = btrfs_del_csums(trans, root, bytenr, bytes);
+	if (ret)
+		fprintf(stderr, "Error deleting csums %d\n", ret);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
 /* corrupt item using NO cow.
  * Because chunk recover will recover based on whole partition scaning,
  * If using COW, chunk recover will use the old item to recover,
@@ -1009,6 +1032,7 @@ int main(int ac, char **av)
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
 	u64 root_objectid = 0;
+	u64 csum_bytenr = 0;
 	char field[FIELD_BUF_LEN];
 
 	field[0] = '\0';
@@ -1037,10 +1061,11 @@ int main(int ac, char **av)
 			{ "dir-item", 0, NULL, 'D'},
 			{ "delete", 0, NULL, 'd'},
 			{ "root", 0, NULL, 'r'},
+			{ "csum", 1, NULL, 'C'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDdr:",
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDdr:C:",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1104,6 +1129,9 @@ int main(int ac, char **av)
 			case 'r':
 				root_objectid = arg_strtou64(optarg);
 				break;
+			case 'C':
+				csum_bytenr = arg_strtou64(optarg);
+				break;
 			default:
 				print_usage();
 		}
@@ -1206,6 +1234,10 @@ int main(int ac, char **av)
 		ret = corrupt_dir_item(root, &key, field);
 		goto out_close;
 	}
+	if (csum_bytenr) {
+		ret = delete_csum(root, csum_bytenr, bytes);
+		goto out_close;
+	}
 	if (corrupt_item) {
 		if (!key.objectid)
 			print_usage();
-- 
1.8.3.1

