Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:37062 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab3DKQWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:22:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.26 OK)
	with ESMTP id p03acep3BCj0dO for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 18:22:08 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] Btrfs-progs: enhance 'btrfs subvolume list'
Date: Thu, 11 Apr 2013 18:22:08 +0200
Message-Id: <8c3c7c8ec1747e9fe96ccf17ccc2b6669e1d1fb8.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs subvolume list" gets a new option "--fields=..." which allows
to specify which pieces of information about subvolumes shall be
printed. This is necessary because this commit also adds all the so
far missing items from the root_item like the received UUID, all
generation values and all time values.

The parameters to the "--fields" option is a list of items to print:
--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,
         stime,rtime,path,rootid,parent,topid,all

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c     | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-list.h     |  1 +
 cmds-subvolume.c | 57 +++++++++++++++++++++----------------------------------
 man/btrfs.8.in   | 19 +++++++------------
 4 files changed, 88 insertions(+), 47 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 2d53290..5f69922 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -144,9 +144,39 @@ static struct {
 	},
 };
 
+static char *all_field_items[] = {
+	[BTRFS_LIST_OBJECTID]		= "rootid",
+	[BTRFS_LIST_GENERATION]		= "gen",
+	[BTRFS_LIST_CGENERATION]	= "cgen",
+	[BTRFS_LIST_OGENERATION]	= "ogen",
+	[BTRFS_LIST_SGENERATION]	= "sgen",
+	[BTRFS_LIST_RGENERATION]	= "rgen",
+	[BTRFS_LIST_PARENT]		= "parent",
+	[BTRFS_LIST_TOP_LEVEL]		= "topid",
+	[BTRFS_LIST_CTIME]		= "ctime",
+	[BTRFS_LIST_OTIME]		= "otime",
+	[BTRFS_LIST_STIME]		= "stime",
+	[BTRFS_LIST_RTIME]		= "rtime",
+	[BTRFS_LIST_UUID]		= "uuid",
+	[BTRFS_LIST_PUUID]		= "puuid",
+	[BTRFS_LIST_RUUID]		= "ruuid",
+	[BTRFS_LIST_DIRID]		= "dirid",
+	[BTRFS_LIST_PATH]		= "path",
+	[BTRFS_LIST_ALL]		= "all",
+	[BTRFS_LIST_MAX]		= NULL,
+};
+
 static btrfs_list_filter_func all_filter_funcs[];
 static btrfs_list_comp_func all_comp_funcs[];
 
+void btrfs_list_clear_all_print_columns(void)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_ALL; i++)
+		btrfs_list_columns[i].need_print = 0;
+}
+
 void btrfs_list_setup_print_column(enum btrfs_list_column_enum column)
 {
 	int i;
@@ -257,6 +287,16 @@ static int  btrfs_list_get_sort_item(char *sort_name)
 	return -1;
 }
 
+static int btrfs_list_get_field_item(char *field_name)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_LIST_MAX; i++)
+		if (strcmp(field_name, all_field_items[i]) == 0)
+			return i;
+	return -1;
+}
+
 struct btrfs_list_comparer_set *btrfs_list_alloc_comparer_set(void)
 {
 	struct btrfs_list_comparer_set *set;
@@ -1897,6 +1937,24 @@ int btrfs_list_parse_sort_string(char *optarg,
 	return 0;
 }
 
+int btrfs_list_parse_fields_string(char *optarg)
+{
+	char *p;
+	int column;
+
+	btrfs_list_clear_all_print_columns();
+
+	while ((p = strtok(optarg, ",")) != NULL) {
+		column = btrfs_list_get_field_item(p);
+		if (column < 0)
+			return -1;
+		btrfs_list_setup_print_column(column);
+		optarg = NULL;
+	}
+
+	return 0;
+}
+
 /*
  * This function is used to parse the argument of filter condition.
  *
diff --git a/btrfs-list.h b/btrfs-list.h
index 27be3b1..7e03948 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -173,6 +173,7 @@ enum btrfs_list_comp_enum {
 
 int btrfs_list_parse_sort_string(char *optarg,
 				 struct btrfs_list_comparer_set **comps);
+int btrfs_list_parse_fields_string(char *optarg);
 int btrfs_list_parse_filter_string(char *optarg,
 				   struct btrfs_list_filter_set **filters,
 				   enum btrfs_list_filter_enum type);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e97297a..add655e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -282,19 +282,16 @@ out:
  * - lowercase for enabling specific items in the output
  */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-agopurts] [-G [+|-]value] [-C [+|-]value] "
-	"[--sort=gen,ogen,rootid,path] <path>",
+	"btrfs subvolume list [-roast] [-G [+|-]value] [-C [+|-]value] "
+	"[--sort=gen,ogen,rootid,path] "
+	"[--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,"
+	"otime,stime,rtime,path,rootid,parent,topid,all] <path>",
 	"List subvolumes (and snapshots)",
 	"",
-	"-p           print parent ID",
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
 	"             to the given <path>",
-	"-c           print the ogeneration of the subvolume",
-	"-g           print the generation of the subvolume",
 	"-o           print only subvolumes bellow specified path",
-	"-u           print the uuid of subvolumes (and snapshots)",
-	"-q           print the parent uuid of the snapshots",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -308,6 +305,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             list the subvolume in order of gen, ogen, rootid or path",
 	"             you also can add '+' or '-' in front of each items.",
 	"             (+:ascending, -:descending, ascending default)",
+	"--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,",
+	"         stime,rtime,path,rootid,parent,topid,all",
+	"             explicitly specify the fields to print",
 	NULL,
 };
 
@@ -326,32 +326,30 @@ static int cmd_subvol_list(int argc, char **argv)
 	int is_only_in_path = 0;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
+		{"fields", 1, NULL, 'F'},
 		{0, 0, 0, 0}
 	};
 
 	filter_set = btrfs_list_alloc_filter_set();
 	comparer_set = btrfs_list_alloc_comparer_set();
 
+	/* by default we shall print the following columns*/
+	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
+	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
+	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
+
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "acgopqsurG:C:t", long_options, NULL);
+				    "roastG:C:", long_options, NULL);
 		if (c < 0)
 			break;
 
 		switch(c) {
-		case 'p':
-			btrfs_list_setup_print_column(BTRFS_LIST_PARENT);
-			break;
 		case 'a':
 			is_list_all = 1;
 			break;
-		case 'c':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			break;
-		case 'g':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-			break;
 		case 'o':
 			is_only_in_path = 1;
 			break;
@@ -362,20 +360,11 @@ static int cmd_subvol_list(int argc, char **argv)
 			btrfs_list_setup_filter(&filter_set,
 						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
 						0);
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
-			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
-			break;
-		case 'u':
-			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
-			break;
-		case 'q':
-			btrfs_list_setup_print_column(BTRFS_LIST_PUUID);
 			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
 		case 'G':
-			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_GEN);
@@ -384,9 +373,7 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
-
 		case 'C':
-			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
 							BTRFS_LIST_FILTER_CGEN);
@@ -403,7 +390,13 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
-
+		case 'F':
+			ret = btrfs_list_parse_fields_string(optarg);
+			if (ret) {
+				uerr = 1;
+				goto out;
+			}
+			break;
 		default:
 			uerr = 1;
 			goto out;
@@ -454,12 +447,6 @@ static int cmd_subvol_list(int argc, char **argv)
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
 
-	/* by default we shall print the following columns*/
-	btrfs_list_setup_print_column(BTRFS_LIST_OBJECTID);
-	btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
-	btrfs_list_setup_print_column(BTRFS_LIST_TOP_LEVEL);
-	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
-
 	if (is_tab_result)
 		ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
 				BTRFS_LIST_LAYOUT_TABLE,
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..d9af323 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-roast] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] [--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -130,7 +130,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fR
+\fBsubvolume list\fP\fI [-roast] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] [--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all] <path>\fP
 .RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -140,21 +140,13 @@ subvolume.
 
 The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
 at mount time via the \fIsubvolid=\fR option.
-If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
-and top level. The parent's ID may be used at mount time via the
-\fIsubvolrootid=\fR option.
+The parent's ID may be used at mount time via the \fIsubvolrootid=\fR option.
 
 \fB-t\fP print the result as a table.
 
 \fB-a\fP print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
 
-\fB-c\fP print the ogeneration of the subvolume, aliases: ogen or origin generation
-
-\fB-g\fP print the generation of the subvolume
-
-\fB-u\fP print the UUID of the subvolume
-
 \fB-o\fP print only subvolumes bellow specified <path>.
 
 \fB-r\fP only readonly subvolumes in the filesystem will be listed.
@@ -170,7 +162,10 @@ neither '+' nor '-', it means = value.
 list subvolumes in the filesystem that its ogeneration is
 >=, <= or = value. The usage is the same to '-g' option.
 
-\fB--sort=rootid,gen,ogen,path\fP
+\fB--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,stime,rtime,path,rootid,parent,topid,all\fP
+explicitly specify the fields to print.
+
+\fB--sort=gen,ogen,path,rootid\fP
 list subvolumes in order by specified items.
 you can add '+' or '-' in front of each items, '+' means ascending, '-'
 means descending. The default is ascending.
-- 
1.8.2.1

