Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab2LKOZT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 09:25:19 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, cwillu@cwillu.com,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] Btrfs-progs: add '-o' option into subvolume list command
Date: Tue, 11 Dec 2012 15:24:59 +0100
Message-Id: <1355235900-10252-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1355235900-10252-1-git-send-email-lczerner@redhat.com>
References: <1355235900-10252-1-git-send-email-lczerner@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit introduces new option '-o' to list only subvolumes under the
specified path. This does not change subvolume list  behaviour. It has
been default in the past and it is even with this commit.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 cmds-subvolume.c |   11 ++++++++---
 man/btrfs.8.in   |    6 ++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 37cb8cc..0aa7467 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -272,7 +272,7 @@ out:
 }
 
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-apurts] [-g [+|-]value] [-c [+|-]value] "
+	"btrfs subvolume list [-aopurts] [-g [+|-]value] [-c [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
@@ -280,6 +280,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
 	"             to the given <path>",
+	"-o           print only subvolumes bellow specified path",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
@@ -309,6 +310,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	char *subvol;
 	int is_tab_result = 0;
 	int is_list_all = 0;
+	int is_only_in_path = 1;
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
 		{0, 0, 0, 0}
@@ -320,7 +322,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "apsurg:c:t", long_options, NULL);
+				    "aopsurg:c:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -331,6 +333,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'a':
 			is_list_all = 1;
 			break;
+		case 'o':
+			is_only_in_path = 1;
+			break;
 		case 't':
 			is_tab_result = 1;
 			break;
@@ -407,7 +412,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		btrfs_list_setup_filter(&filter_set,
 					BTRFS_LIST_FILTER_FULL_PATH,
 					top_id);
-	else
+	else if (is_only_in_path)
 		btrfs_list_setup_filter(&filter_set,
 					BTRFS_LIST_FILTER_TOPID_EQUAL,
 					top_id);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index d6d8e94..1e314eb 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -11,7 +11,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-aoprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
@@ -108,7 +108,7 @@ Create a subvolume in \fI<dest>\fR (or in the current directory if
 \fI<dest>\fR is omitted).
 .TP
 
-\fBsubvolume list\fR\fI [-aprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
+\fBsubvolume list\fR\fI [-aoprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
 .RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
@@ -127,6 +127,8 @@ and top level. The parent's ID may be used at mount time via the
 \fB-a\fP print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
 
+\fB-o\fP print only subvolumes bellow specified <path>.
+
 \fB-r\fP only readonly subvolumes in the filesystem wille be listed.
 
 \fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
-- 
1.7.7.6

