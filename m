Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:34771 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbJBQuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 12:50:04 -0400
From: axel@tty0.ch
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [PATCH 3/4] btrfs-progs: add option "--time-format=short|iso|unix|locale" to subvolume list
Date: Fri,  2 Oct 2015 18:41:22 +0200
Message-Id: <1443804083-876-4-git-send-email-axel@tty0.ch>
In-Reply-To: <1443804083-876-1-git-send-email-axel@tty0.ch>
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Affects time format of "otime". Supporting unix time and ISO8601 makes
the output of "subvolume list" machine-readable.

Default is "short", keeping default output as it was before (I suggest
changing the default to "iso", as with "short" is it not clear to the
user if localtime or gmtime is printed, and it does not contain
whitespace).

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 Documentation/btrfs-subvolume.asciidoc |  3 ++
 btrfs-list.c                           | 65 +++++++++++++++++++++++++++++-----
 btrfs-list.h                           |  1 +
 cmds-subvolume.c                       | 10 ++++++
 4 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index afbec83..b4a8c68 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -137,6 +137,9 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
 for --sort you can combine some items together by \',', just like
 -sort=+ogen,-gen,path,rootid.
 
+--time-format=short|iso|unix|locale::::
+print times in format: short, ISO 8601, unix (seconds), or current locale.
+
 *set-default* <id> <path>::
 Set the subvolume of the filesystem <path> which is mounted as
 default.
diff --git a/btrfs-list.c b/btrfs-list.c
index ff337f9..f8396e7 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -114,6 +114,15 @@ static struct {
 static btrfs_list_filter_func all_filter_funcs[];
 static btrfs_list_comp_func all_comp_funcs[];
 
+enum btrfs_list_time_format_enum {
+	BTRFS_LIST_TIME_FORMAT_SHORT,
+	BTRFS_LIST_TIME_FORMAT_ISO,
+	BTRFS_LIST_TIME_FORMAT_UNIX,
+	BTRFS_LIST_TIME_FORMAT_LOCALE,
+};
+
+static enum btrfs_list_time_format_enum btrfs_list_time_format = BTRFS_LIST_TIME_FORMAT_SHORT;
+
 void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
 {
 	int i;
@@ -1338,10 +1347,35 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
+static void print_timestamp(time_t time)
+{
+	char tstr[256];
+	struct tm tm;
+
+	switch(btrfs_list_time_format) {
+		case BTRFS_LIST_TIME_FORMAT_SHORT:
+			localtime_r(&time, &tm);
+			strftime(tstr, 256, "%Y-%m-%d %X", &tm);
+			break;
+		case BTRFS_LIST_TIME_FORMAT_ISO:
+			localtime_r(&time, &tm);
+			strftime(tstr, 256, "%FT%T%z", &tm);
+			break;
+		case BTRFS_LIST_TIME_FORMAT_UNIX:
+			gmtime_r(&time, &tm);
+			strftime(tstr, 256, "%s", &tm);
+			break;
+		case BTRFS_LIST_TIME_FORMAT_LOCALE:
+			localtime_r(&time, &tm);
+			strftime(tstr, 256, "%c", &tm);
+			break;
+	}
+	printf("%s", tstr);
+}
+
 static void print_subvolume_column(struct root_info *subv,
 				   enum btrfs_list_column_enum column)
 {
-	char tstr[256];
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 
 	BUG_ON(column >= BTRFS_LIST_ALL || column < 0);
@@ -1363,14 +1397,10 @@ static void print_subvolume_column(struct root_info *subv,
 		printf("%llu", subv->top_id);
 		break;
 	case BTRFS_LIST_OTIME:
-		if (subv->otime) {
-			struct tm tm;
-
-			localtime_r(&subv->otime, &tm);
-			strftime(tstr, 256, "%Y-%m-%d %X", &tm);
-		} else
-			strcpy(tstr, "-");
-		printf("%s", tstr);
+		if (subv->otime)
+			print_timestamp(subv->otime);
+		else
+			printf("-");
 		break;
 	case BTRFS_LIST_UUID:
 		if (uuid_is_null(subv->uuid))
@@ -1918,6 +1948,23 @@ int btrfs_list_parse_filter_string(char *opt_arg,
 	return 0;
 }
 
+int btrfs_list_parse_time_format(const char *format)
+{
+	if (strcmp(format, "short") == 0)
+		btrfs_list_time_format = BTRFS_LIST_TIME_FORMAT_SHORT;
+	else if (strcmp(format, "unix") == 0)
+		btrfs_list_time_format = BTRFS_LIST_TIME_FORMAT_UNIX;
+	else if (strcmp(format, "locale") == 0)
+		btrfs_list_time_format = BTRFS_LIST_TIME_FORMAT_LOCALE;
+	else if (strcmp(optarg, "iso") == 0)
+		btrfs_list_time_format = BTRFS_LIST_TIME_FORMAT_ISO;
+	else {
+		fprintf(stderr, "Unknown time format %s\n", format);
+		return 1;
+	};
+	return 0;
+}
+
 int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 {
 	int  ret;
diff --git a/btrfs-list.h b/btrfs-list.h
index 397eb3e..dd2eebf 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -159,6 +159,7 @@ int btrfs_list_parse_sort_string(char *optarg,
 int btrfs_list_parse_filter_string(char *optarg,
 				   struct btrfs_list_filter_set **filters,
 				   enum btrfs_list_filter_enum type);
+int btrfs_list_parse_time_format(const char *format);
 void btrfs_list_setup_print_column(enum btrfs_list_column_enum column);
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void);
 void btrfs_list_free_filter_set(struct btrfs_list_filter_set *filter_set);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 26a08f1..fefefac 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -443,6 +443,8 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             list the subvolume in order of gen, ogen, rootid or path",
 	"             you also can add '+' or '-' in front of each items.",
 	"             (+:ascending, -:descending, ascending default)",
+	"--time-format=short|iso|unix|locale",
+	"             print timestamps in given format",
 	NULL,
 };
 
@@ -468,6 +470,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		int c;
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, 'S'},
+			{"time-format", required_argument, NULL, 'T'},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -551,6 +554,13 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'T':
+			ret = btrfs_list_parse_time_format(optarg);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
+			break;
 
 		default:
 			uerr = 1;
-- 
2.4.9

