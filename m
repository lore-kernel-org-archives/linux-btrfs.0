Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64316 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab3JGHZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:12 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 12/12] Btrfs-progs: add '-h' options to print sizes in human readable format
Date: Mon, 7 Oct 2013 15:21:48 +0800
Message-Id: <1381130508-8458-13-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a short cut for people who don't want to use '--block-size',it
will print sizes in human readable format.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 17 +++++++++++++---
 qgroup.c      | 62 +++++++++++++++++++++++++++++++++++++++++++++++------------
 qgroup.h      |  2 ++
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 912cc42..7ea752b 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -204,6 +204,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 static const char * const cmd_qgroup_show_usage[] = {
 	"btrfs qgroup show [options] <path>",
 	"Show subvolume quota groups.",
+	"-h		print size in human readable format",
 	"-p		print parent qgroup id",
 	"-c		print child qgroup id",
 	"-r		print max referenced size of qgroup",
@@ -246,7 +247,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt_long(argc, argv, "pcreFf",
+		c = getopt_long(argc, argv, "pcreFfh",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -280,11 +281,21 @@ static int cmd_qgroup_show(int argc, char **argv)
 				usage(cmd_qgroup_show_usage);
 			break;
 		case 'B':
-			block_size = parse_block_size(optarg);
-			if (block_size < 0) {
+			ret = parse_block_size(optarg);
+			if (ret < 0) {
 				fprintf(stderr, "Invalid block size\n");
 				usage(cmd_qgroup_show_usage);
 			}
+			/* force to print in human readable format
+			 * if -h is given
+			 */
+			if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+				break;
+			else
+				block_size = ret;
+			break;
+		case 'h':
+			block_size = BTRFS_QGROUP_PRINT_HUMAN_READABLE;
 			break;
 		default:
 			usage(cmd_qgroup_show_usage);
diff --git a/qgroup.c b/qgroup.c
index 0de6c7d..b1b7cef 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -206,15 +206,27 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = block_size_snprintf((signed long long)qgroup->rfer, tmp,
-					sizeof(tmp), block_size);
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(
+					(signed long long)qgroup->rfer,
+					tmp, sizeof(tmp));
+		else
+			len = block_size_snprintf(
+					(signed long long)qgroup->rfer,
+					tmp, sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = block_size_snprintf((signed long long)qgroup->excl, tmp,
-					sizeof(tmp), block_size);
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(
+					(signed long long)qgroup->excl,
+					tmp, sizeof(tmp));
+		else
+			len = block_size_snprintf(
+					(signed long long)qgroup->excl,
+					tmp, sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
@@ -224,14 +236,22 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = block_size_snprintf(qgroup->max_rfer, tmp,
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(qgroup->max_rfer, tmp,
+					sizeof(tmp));
+		else
+			len = block_size_snprintf(qgroup->max_rfer, tmp,
 					sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		printf("%s", tmp);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = block_size_snprintf(qgroup->max_excl, tmp,
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(qgroup->max_excl, tmp,
+					sizeof(tmp));
+		else
+			len = block_size_snprintf(qgroup->max_excl, tmp,
 					sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		printf("%s", tmp);
@@ -917,28 +937,46 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = block_size_snprintf((signed long long)bq->rfer, tmp,
-					sizeof(tmp), block_size);
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(
+					(signed long long)bq->rfer,
+					tmp, sizeof(tmp));
+		else
+			len = block_size_snprintf((signed long long)bq->rfer,
+					tmp, sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = block_size_snprintf((signed long long)bq->excl, tmp,
-					sizeof(tmp), block_size);
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(
+					(signed long long)bq->excl,
+					tmp, sizeof(tmp));
+		else
+			len = block_size_snprintf((signed long long)bq->excl,
+					tmp, sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = block_size_snprintf(bq->max_rfer, tmp,
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(bq->max_rfer, tmp,
+					sizeof(tmp));
+		else
+			len = block_size_snprintf(bq->max_rfer, tmp,
 					sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = block_size_snprintf(bq->max_excl, tmp,
+		if (block_size == BTRFS_QGROUP_PRINT_HUMAN_READABLE)
+			len = pretty_size_snprintf(bq->max_excl, tmp,
+					sizeof(tmp));
+		else
+			len = block_size_snprintf(bq->max_excl, tmp,
 					sizeof(tmp), block_size);
 		BUG_ON(len < 0);
 		if (btrfs_qgroup_columns[column].max_len < len)
diff --git a/qgroup.h b/qgroup.h
index 1113a24..aa05de5 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -22,6 +22,8 @@
 #include "ioctl.h"
 #include "kerncompat.h"
 
+#define BTRFS_QGROUP_PRINT_HUMAN_READABLE (-1)
+
 struct btrfs_qgroup;
 
 typedef int (*btrfs_qgroup_filter_func)(struct btrfs_qgroup *, u64);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
