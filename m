Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21845 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2LOLqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 06:46:35 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBFBkYl1020511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:35 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBFBkX8S003257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:34 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBFBkXRB002676
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 05:46:33 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] Btrfs-progs: Add -x option to btrfs subvol list to display snapshots in tree format
Date: Sat, 15 Dec 2012 19:52:08 +0800
Message-Id: <1355572328-32281-6-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
References: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This will add new option -x to the btrfs subvol list
sub-command to display the snapshots under its parent subvol
with appropriate indentation.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-subvolume.c |    6 ++-
 man/btrfs.8.in   |    4 +-
 3 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 571efd0..43c279c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -150,6 +150,11 @@ struct {
 	},
 };
 
+struct str_print {
+	char path[BTRFS_PATH_NAME_MAX];
+	char otime[256];
+};
+
 static btrfs_list_filter_func all_filter_funcs[];
 static btrfs_list_comp_func all_comp_funcs[];
 
@@ -1414,6 +1419,133 @@ static void print_single_volume_info_default(struct root_info *subv)
 	printf("\n");
 }
 
+static void print_single_volume_info_tree(struct root_info *subv,
+	struct str_print *sp)
+{
+	char tstr[256];
+
+	sprintf(sp->path, "%s", subv->full_path);
+	if (subv->otime)
+		strftime(tstr, 256, "%X %d-%m-%Y", localtime(&subv->otime));
+	else
+		strcpy(tstr, "-");
+	sprintf(sp->otime, "%s", tstr);
+}
+
+int snapshot_is_orphan(struct root_lookup *root_tree, void *uuid)
+{
+	struct rb_node *n;
+	struct root_info *entry;
+
+	n = rb_first(&root_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, sort_node);
+		if ( ! uuid_compare(entry->uuid, uuid)) {
+			return 0;
+		}
+		n = rb_next(n);
+	}
+	return 1;
+}
+
+void * print_snapshots_of(struct root_lookup *root_tree, void *uuid,
+	int indent, struct str_print *sp)
+{
+	struct rb_node *n;
+	struct root_info *entry;
+	int i = indent;
+	char ispace[BTRFS_PATH_NAME_MAX + 256];
+	char *ispacep = ispace;
+
+	n = rb_first(&root_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, sort_node);
+		if ( ! uuid_compare(entry->puuid, uuid)) {
+			while(i--) {
+				sprintf(ispacep,"%s"," ");
+				ispacep++;
+			}
+			print_single_volume_info_tree(entry, sp);
+			strcat(ispace, sp->path);
+			strcpy(sp->path, ispace);
+			sp++;
+			sp = (struct str_print *) print_snapshots_of(root_tree,
+				entry->uuid, indent+1, sp);
+		}
+		i = indent;
+		n = rb_next(n);
+	}
+	return sp;
+}
+
+void print_subvol_tree(struct root_lookup *root_tree)
+{
+	struct rb_node *n;
+	struct root_info *entry;
+	int listlen = 0;
+	int max_slen = 0;
+	int pad;
+	int stmp;
+	int i;
+	struct str_print *head;
+	struct str_print *cur;
+
+	n = rb_first(&root_tree->root);
+	while (n) {
+		listlen++;
+		n = rb_next(n);
+	}
+	head = (struct str_print *) malloc(sizeof(struct str_print)*listlen);
+	memset(head, 0, sizeof(struct str_print)*listlen);
+
+	cur = head;
+	n = rb_first(&root_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, sort_node);
+		if ( uuid_is_null(entry->puuid)) {
+			print_single_volume_info_tree(entry, cur);
+			cur++;
+			cur = (struct str_print *) print_snapshots_of(root_tree,
+					entry->uuid, 1, cur);
+		}
+		n = rb_next(n);
+	}
+	n = rb_first(&root_tree->root);
+	while (n) {
+		entry = rb_entry(n, struct root_info, sort_node);
+		if ( !uuid_is_null(entry->puuid)
+			&& snapshot_is_orphan(root_tree, entry->puuid)) {
+			print_single_volume_info_tree(entry, cur);
+			cur++;
+			cur = (struct str_print *) print_snapshots_of(root_tree,
+					entry->uuid, 1, cur);
+		}
+		n = rb_next(n);
+	}
+	//BUG_ON(cur != (head + (sizeof(struct str_print) * listlen)));
+
+	cur = head;
+	for (i=0; i < listlen; i++) {
+		stmp = strlen(cur->path);
+		if (stmp > max_slen)
+			max_slen = stmp;
+		cur++;
+	}
+
+	cur = head;
+	for (i=0; i < listlen; i++) {
+		printf("%s", cur->path);
+		pad = max_slen - strlen(cur->path) + 1;
+		while(pad--)
+			printf("%s"," ");
+		printf("%s"," ");
+		printf("%s", cur->otime);
+		printf("\n");
+		cur++;
+	}
+	free(head);
+}
+
 static void print_all_volume_info_tab_head()
 {
 	int i;
@@ -1467,6 +1599,9 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
 			n = rb_next(n);
 		}
 		break;
+	case 2: // tree format
+		print_subvol_tree(sorted_tree);
+		break;
 	default:
 		printf("ERROR: default switch print_all_volume_info\n");
 		return;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 411a5de..4f2704f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -281,6 +281,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-q           print the parent uuid of snapshots",
 	"-t           print the result as a table",
+	"-x           print the result as a tree",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
 	"-g [+|-]value",
@@ -319,7 +320,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "apsuqrg:c:t", long_options, NULL);
+				    "apsuqrg:c:tx", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -333,6 +334,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 't':
 			layout = 1;
 			break;
+		case 'x':
+			layout = 2;
+			break;
 		case 's':
 			btrfs_list_setup_filter(&filter_set,
 						BTRFS_LIST_FILTER_SNAPSHOT_ONLY,
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..1bb0415 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprtxs] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -124,6 +124,8 @@ and top level. The parent's ID may be used at mount time via the
 
 \fB-t\fP print the result as a table.
 
+\fB-x\fP print the result as a tree.
+
 \fB-a\fP print all the subvolumes in the filesystem.
 
 \fB-r\fP only readonly subvolumes in the filesystem wille be listed.
-- 
1.7.1

