Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3BAH6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 02:58:30 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 12/13] Btrfs-progs: Fix a small memory leak in managing the btrfs list filter
Date: Fri,  1 Feb 2013 15:56:31 +0800
Message-Id: <1359705392-7485-13-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359705392-7485-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 57 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 9f1d2a4..5e51a26 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -303,9 +303,9 @@ static int cmd_subvol_list(int argc, char **argv)
 	struct btrfs_list_filter_set *filter_set;
 	struct btrfs_list_comparer_set *comparer_set;
 	u64 flags = 0;
-	int fd;
+	int fd = -1;
 	u64 top_id;
-	int ret;
+	int ret = -1, uerr = 0;
 	int c;
 	char *subvol;
 	int is_tab_result = 0;
@@ -356,8 +356,10 @@ static int cmd_subvol_list(int argc, char **argv)
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_GEN);
-			if (ret)
-				usage(cmd_subvol_list_usage);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
 			break;
 
 		case 'c':
@@ -365,18 +367,23 @@ static int cmd_subvol_list(int argc, char **argv)
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_CGEN);
-			if (ret)
-				usage(cmd_subvol_list_usage);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
 			break;
 		case 'S':
 			ret = btrfs_list_parse_sort_string(optarg,
 							   &comparer_set);
-			if (ret)
-				usage(cmd_subvol_list_usage);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
 			break;
 
 		default:
-			usage(cmd_subvol_list_usage);
+			uerr = 1;
+			goto out;
 		}
 	}
 
@@ -384,25 +391,29 @@ static int cmd_subvol_list(int argc, char **argv)
 		btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_FLAGS,
 					flags);
 
-	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_subvol_list_usage);
+	if (check_argc_exact(argc - optind, 1)) {
+		uerr = 1;
+		goto out;
+	}
 
 	subvol = argv[optind];
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		return 12;
+		goto out;
 	}
 	if (!ret) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		return 13;
+		ret = -1;
+		goto out;
 	}
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
+		ret = -1;
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
-		return 12;
+		goto out;
 	}
 
 	top_id = btrfs_list_get_path_rootid(fd);
@@ -423,9 +434,16 @@ static int cmd_subvol_list(int argc, char **argv)
 	else
 		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
 				BTRFS_LIST_LAYOUT_DEFAULT, NULL);
-	if (ret)
-		return 19;
-	return 0;
+
+out:
+	if (filter_set)
+		btrfs_list_free_filter_set(filter_set);
+	if (comparer_set)
+		btrfs_list_free_comparer_set(comparer_set);
+	if (uerr)
+		usage(cmd_subvol_list_usage);
+
+	return ret;
 }
 
 static const char * const cmd_snapshot_usage[] = {
@@ -636,6 +654,9 @@ static int cmd_subvol_get_default(int argc, char **argv)
 
 	ret = btrfs_list_subvols_print(fd, filter_set, NULL,
 		BTRFS_LIST_LAYOUT_DEFAULT, NULL);
+
+	if (filter_set)
+		btrfs_list_free_filter_set(filter_set);
 	if (ret)
 		return 19;
 	return 0;
@@ -855,6 +876,8 @@ static int cmd_subvol_show(int argc, char **argv)
 		free(get_ri.name);
 	if (get_ri.full_path)
 		free(get_ri.full_path);
+	if (filter_set)
+		btrfs_list_free_filter_set(filter_set);
 
 out:
 	if (mntfd >= 0)
-- 
1.8.1.227.g44fe835

