Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25504 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbaJaSBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:01:47 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/11] Btrfs-progs: allow fsck to take the tree bytenr
Date: Fri, 31 Oct 2014 14:01:21 -0400
Message-ID: <1414778489-4049-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes we have a pretty corrupted fs but have an old tree bytenr that we
could use, add the ability to specify the tree root bytenr.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2a5f823..38f8d11 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7546,6 +7546,7 @@ static struct option long_options[] = {
 	{ "backup", 0, NULL, 0 },
 	{ "subvol-extents", no_argument, NULL, 'E' },
 	{ "qgroup-report", 0, NULL, 'Q' },
+	{ "tree-root", 1, NULL, 'r' },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -7561,6 +7562,7 @@ const char * const cmd_check_usage[] = {
 	"--check-data-csum           verify checkums of data blocks",
 	"--qgroup-report             print a report on qgroup consistency",
 	"--subvol-extents            print subvolume extents and sharing state",
+	"--tree-root                 use the given bytenr for the tree root",
 	NULL
 };
 
@@ -7571,6 +7573,7 @@ int cmd_check(int argc, char **argv)
 	struct btrfs_fs_info *info;
 	u64 bytenr = 0;
 	u64 subvolid = 0;
+	u64 tree_root_bytenr = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	u64 num;
@@ -7581,7 +7584,7 @@ int cmd_check(int argc, char **argv)
 
 	while(1) {
 		int c;
-		c = getopt_long(argc, argv, "as:b", long_options,
+		c = getopt_long(argc, argv, "as:br:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -7608,6 +7611,9 @@ int cmd_check(int argc, char **argv)
 			case 'E':
 				subvolid = arg_strtou64(optarg);
 				break;
+			case 'r':
+				tree_root_bytenr = arg_strtou64(optarg);
+				break;
 			case '?':
 			case 'h':
 				usage(cmd_check_usage);
@@ -7651,7 +7657,8 @@ int cmd_check(int argc, char **argv)
 	if (repair)
 		ctree_flags |= OPEN_CTREE_PARTIAL;
 
-	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
+	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
+				  ctree_flags);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		ret = -EIO;
-- 
1.8.3.1

