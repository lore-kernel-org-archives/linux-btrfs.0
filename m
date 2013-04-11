Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:61750 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab3DKQWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:22:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 31.26 OK)
	with ESMTP id p028b3p3BDBwyS for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 18:22:08 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] Btrfs-progs: make the btrfs-list output more compact
Date: Thu, 11 Apr 2013 18:22:06 +0200
Message-Id: <b5b1097ace300b4a3e5626a4bfe9ad795ab48fe4.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following commit will add many additional columns to the output.
Therefore the current commit adds a width for each column. It replaces
to uncondionally add a <TAB> after each column which makes the output
much wider than necessary.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c | 79 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index a5d6e9b..70da9a3 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -50,30 +50,37 @@ static struct {
 	char	*name;
 	char	*column_name;
 	int	need_print;
+	int	width;
 } btrfs_list_columns[] = {
 	{
 		.name		= "ID",
 		.column_name	= "ID",
+		.width		= 6,
 	},
 	{
 		.name		= "gen",
 		.column_name	= "Gen",
+		.width		= 6,
 	},
 	{
 		.name		= "cgen",
 		.column_name	= "CGen",
+		.width		= 6,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
+		.width		= 7,
 	},
 	{
 		.name		= "top level",
 		.column_name	= "Top Level",
+		.width		= 10,
 	},
 	{
 		.name		= "otime",
 		.column_name	= "OTime",
+		.width		= 21,
 	},
 	{
 		.name		= "parent_uuid",
@@ -82,14 +89,17 @@ static struct {
 	{
 		.name		= "uuid",
 		.column_name	= "UUID",
+		.width		= 38,
 	},
 	{
 		.name		= "path",
 		.column_name	= "Path",
+		.width		= 0,
 	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
+		.width		= 0,
 	},
 };
 
@@ -1309,29 +1319,30 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-static void print_subvolume_column(struct root_info *subv,
-				   enum btrfs_list_column_enum column)
+static int print_subvolume_column(struct root_info *subv,
+				  enum btrfs_list_column_enum column)
 {
 	char tstr[256];
 	char uuidparse[37];
+	int width;
 
 	BUG_ON(column >= BTRFS_LIST_ALL || column < 0);
 
 	switch (column) {
 	case BTRFS_LIST_OBJECTID:
-		printf("%llu", subv->root_id);
+		width = printf("%llu", subv->root_id);
 		break;
 	case BTRFS_LIST_GENERATION:
-		printf("%llu", subv->gen);
+		width = printf("%llu", subv->gen);
 		break;
 	case BTRFS_LIST_OGENERATION:
-		printf("%llu", subv->ogen);
+		width = printf("%llu", subv->ogen);
 		break;
 	case BTRFS_LIST_PARENT:
-		printf("%llu", subv->ref_tree);
+		width = printf("%llu", subv->ref_tree);
 		break;
 	case BTRFS_LIST_TOP_LEVEL:
-		printf("%llu", subv->top_id);
+		width = printf("%llu", subv->top_id);
 		break;
 	case BTRFS_LIST_OTIME:
 		if (subv->otime)
@@ -1339,29 +1350,34 @@ static void print_subvolume_column(struct root_info *subv,
 				 localtime(&subv->otime));
 		else
 			strcpy(tstr, "-");
-		printf("%s", tstr);
+		width = printf("%s", tstr);
 		break;
 	case BTRFS_LIST_UUID:
 		if (uuid_is_null(subv->uuid))
 			strcpy(uuidparse, "-");
 		else
 			uuid_unparse(subv->uuid, uuidparse);
-		printf("%s", uuidparse);
+		width = printf("%s", uuidparse);
 		break;
 	case BTRFS_LIST_PUUID:
 		if (uuid_is_null(subv->puuid))
 			strcpy(uuidparse, "-");
 		else
 			uuid_unparse(subv->puuid, uuidparse);
-		printf("%s", uuidparse);
+		width = printf("%s", uuidparse);
 		break;
 	case BTRFS_LIST_PATH:
 		BUG_ON(!subv->full_path);
-		printf("%s", subv->full_path);
+		width = printf("%s", subv->full_path);
 		break;
 	default:
+		width = 0;
 		break;
 	}
+
+	if (width < 0)
+		width = 0;
+	return width;
 }
 
 static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefix)
@@ -1383,18 +1399,15 @@ static void print_single_volume_info_raw(struct root_info *subv, char *raw_prefi
 static void print_single_volume_info_table(struct root_info *subv)
 {
 	int i;
+	int width;
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
 		if (!btrfs_list_columns[i].need_print)
 			continue;
 
-		print_subvolume_column(subv, i);
-
-		if (i != BTRFS_LIST_PATH)
-			printf("\t");
-
-		if (i == BTRFS_LIST_TOP_LEVEL)
-			printf("\t");
+		width = print_subvolume_column(subv, i);
+		while (width++ < btrfs_list_columns[i].width)
+			printf(" ");
 	}
 	printf("\n");
 }
@@ -1410,7 +1423,7 @@ static void print_single_volume_info_default(struct root_info *subv)
 		printf("%s ", btrfs_list_columns[i].name);
 		print_subvolume_column(subv, i);
 
-		if (i != BTRFS_LIST_PATH)
+		if (i != BTRFS_LIST_ALL - 1)
 			printf(" ");
 	}
 	printf("\n");
@@ -1419,30 +1432,30 @@ static void print_single_volume_info_default(struct root_info *subv)
 static void print_all_volume_info_tab_head()
 {
 	int i;
-	int len;
-	char barrier[20];
+	int width;
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (btrfs_list_columns[i].need_print)
-			printf("%s\t", btrfs_list_columns[i].name);
+		if (!btrfs_list_columns[i].need_print)
+			continue;
 
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
+		width = printf("%s", btrfs_list_columns[i].column_name);
+		while (width++ < btrfs_list_columns[i].width)
+			printf(" ");
 	}
+	printf("\n");
 
 	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		memset(barrier, 0, sizeof(barrier));
-
 		if (btrfs_list_columns[i].need_print) {
-			len = strlen(btrfs_list_columns[i].name);
-			while (len--)
-				strcat(barrier, "-");
+			width = strlen(btrfs_list_columns[i].column_name);
+			while (width--)
+				printf("-");
 
-			printf("%s\t", barrier);
+			width = strlen(btrfs_list_columns[i].column_name);
+			while (width++ < btrfs_list_columns[i].width)
+				printf(" ");
 		}
-		if (i == BTRFS_LIST_ALL-1)
-			printf("\n");
 	}
+	printf("\n");
 }
 
 static void print_all_volume_info(struct root_lookup *sorted_tree,
-- 
1.8.2.1

