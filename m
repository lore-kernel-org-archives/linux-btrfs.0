Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45450 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbbEOGaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 02:30:30 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs-progs: Add '-U' and '-u' option for btrfstune.
Date: Fri, 15 May 2015 14:28:25 +0800
Message-ID: <1431671306-22262-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add two options, '-U' and '-u' for btrfstune.

For '-u', it is used to change fsid to a random new UUID.
For '-U', it is used to change fsid to a specified UUID.

Both will also change the internal use only chunk_tree_uuid to a random
new UUID.

Although there is a GNU getopt extension "::" to get optional
option-argument, but is forbidden by POSIX.1-2008, so use split options
here.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 5 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 1d5af33..e324f83 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -406,23 +406,27 @@ static void print_usage(void)
 	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
-	fprintf(stderr, "\t-f \t\tforce to set or clear flags, make sure that you are aware of the dangers\n");
+	fprintf(stderr, "\t-f \t\tforce to do dangerous operation, make sure that you are aware of the dangers\n");
+	fprintf(stderr, "\t-U [uuid]\t\tchange fsid, if uuid is not given, use a random one\n");
 }
 
 int main(int argc, char *argv[])
 {
 	struct btrfs_root *root;
+	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_WRITES;
 	int success = 0;
 	int total = 0;
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
 	int skinny_flag = 0;
+	int random_fsid = 0;
+	char *new_fsid_str = NULL;
 	int ret;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "S:rxf");
+		int c = getopt(argc, argv, "S:rxfuU:");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -439,6 +443,14 @@ int main(int argc, char *argv[])
 		case 'f':
 			force = 1;
 			break;
+		case 'U':
+			ctree_flags |= OPEN_CTREE_IGNORE_FSID_MISMATCH;
+			new_fsid_str = optarg;
+			break;
+		case 'u':
+			ctree_flags |= OPEN_CTREE_IGNORE_FSID_MISMATCH;
+			random_fsid = 1;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -453,13 +465,37 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (!(seeding_flag + extrefs_flag + skinny_flag)) {
+	if (random_fsid && new_fsid_str) {
+		fprintf(stderr,
+			"ERROR: Random fsid can't be used with specified fsid\n");
+		return 1;
+	}
+	if (!(seeding_flag + extrefs_flag + skinny_flag) &&
+	    !(random_fsid || new_fsid_str)) {
 		fprintf(stderr,
 			"ERROR: At least one option should be assigned.\n");
 		print_usage();
 		return 1;
 	}
 
+	if (new_fsid_str) {
+		uuid_t tmp;
+
+		ret = uuid_parse(new_fsid_str, tmp);
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: Could not parse UUID: %s\n",
+				new_fsid_str);
+			return 1;
+		}
+		if (!test_uuid_unique(new_fsid_str)) {
+			fprintf(stderr,
+				"ERROR: Fsid %s is not unique\n",
+				new_fsid_str);
+			return 1;
+		}
+	}
+
 	ret = check_mounted(device);
 	if (ret < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
@@ -470,7 +506,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	root = open_ctree(device, 0, OPEN_CTREE_WRITES);
+	root = open_ctree(device, 0, ctree_flags);
 
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
@@ -483,7 +519,8 @@ int main(int argc, char *argv[])
 			ret = ask_user("We are going to clear the seeding flag, are you sure?");
 			if (!ret) {
 				fprintf(stderr, "Clear seeding flag canceled\n");
-				return 1;
+				ret = 1;
+				goto out;
 			}
 		}
 
@@ -505,6 +542,25 @@ int main(int argc, char *argv[])
 		total++;
 	}
 
+	if (random_fsid || new_fsid_str) {
+		if (!force) {
+			fprintf(stderr,
+				"Warning: It's highly recommended to run 'btrfs check' before this operation\n");
+			fprintf(stderr,
+				"Also canceling running UUID change progress may cause corruption\n");
+			ret = ask_user("We are going to change UUID, are your sure?");
+			if (!ret) {
+				fprintf(stderr, "UUID change canceled\n");
+				ret = 1;
+				goto out;
+			}
+		}
+		ret = change_uuid(root->fs_info, new_fsid_str);
+		if (!ret)
+			success++;
+		total++;
+	}
+
 	if (success == total) {
 		ret = 0;
 	} else {
@@ -512,6 +568,7 @@ int main(int argc, char *argv[])
 		ret = 1;
 		fprintf(stderr, "btrfstune failed\n");
 	}
+out:
 	close_ctree(root);
 
 	return ret;
-- 
2.4.0

