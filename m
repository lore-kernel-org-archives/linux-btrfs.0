Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:38440 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbbJBQuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 12:50:04 -0400
From: axel@tty0.ch
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to print a simple space-separated table (making it machine-readable)
Date: Fri,  2 Oct 2015 18:41:23 +0200
Message-Id: <1443804083-876-5-git-send-email-axel@tty0.ch>
In-Reply-To: <1443804083-876-1-git-send-email-axel@tty0.ch>
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old implementation used tabs "\t", and tried to work around problems
by guessing amount of tabs needed (e.g. "\t\t" after top level", with
buggy output as soon as empty uuids are printed). This will never work
correctly, as tab width is a user-defined setting in the terminal.

Keep it simple and don't reimplement the wheel, for nice tabular
output we have the "column" command from util-linux:

    btrfs subvolume list -t <path> | column -t

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 btrfs-list.c | 40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index f8396e7..c09257a 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -45,12 +45,12 @@ struct root_lookup {
 };
 
 static struct {
-	char	*name;
+	char	*name;  /* machine-readable column identifier: [a-z_]+ */
 	char	*column_name;
 	int	need_print;
 } btrfs_list_columns[] = {
 	{
-		.name		= "ID",
+		.name		= "id",
 		.column_name	= "ID",
 		.need_print	= 0,
 	},
@@ -70,7 +70,7 @@ static struct {
 		.need_print	= 0,
 	},
 	{
-		.name		= "top level",
+		.name		= "top_level",
 		.column_name	= "Top Level",
 		.need_print	= 0,
 	},
@@ -1465,13 +1465,10 @@ static void print_single_volume_info_table(struct root_info *subv)
 		if (!btrfs_list_columns[i].need_print)
 			continue;
 
-		print_subvolume_column(subv, i);
-
-		if (i != BTRFS_LIST_PATH)
-			printf("\t");
+		if (i != 0)
+			printf(" ");
 
-		if (i == BTRFS_LIST_TOP_LEVEL)
-			printf("\t");
+		print_subvolume_column(subv, i);
 	}
 	printf("\n");
 }
@@ -1496,30 +1493,17 @@ static void print_single_volume_info_default(struct root_info *subv)
 static void print_all_volume_info_tab_head(void)
 {
 	int i;
-	int len;
-	char barrier[20];
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (btrfs_list_columns[i].need_print)
-			printf("%s\t", btrfs_list_columns[i].name);
-
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
-	}
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		memset(barrier, 0, sizeof(barrier));
+		if (!btrfs_list_columns[i].need_print)
+			continue;
 
-		if (btrfs_list_columns[i].need_print) {
-			len = strlen(btrfs_list_columns[i].name);
-			while (len--)
-				strcat(barrier, "-");
+		if (i != 0)
+			printf(" ");
 
-			printf("%s\t", barrier);
-		}
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
+		printf(btrfs_list_columns[i].name);
 	}
+	printf("\n");
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
-- 
2.4.9

