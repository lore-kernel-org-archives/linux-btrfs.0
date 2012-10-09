Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2JIQ16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 12:27:58 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id BBD74A3D59
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2012 18:27:57 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs-progs: upcase filter options
Date: Tue,  9 Oct 2012 18:27:52 +0200
Message-Id: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename filter options in 'subvol list' subcommand, that way we can
distinguish them from the options that just show some option in the
output and can have a matching uppercase filter.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-subvolume.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ac39f7b..61be38a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -271,8 +271,13 @@ out:
 	return ret;
 }
 
+/*
+ * Naming of options:
+ * - uppercase for filters and sort options
+ * - lowercase for enabling specific items in the output
+ */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-apurts] [-g [+|-]value] [-c [+|-]value] "
+	"btrfs subvolume list [-apurts] [-G [+|-]value] [-C [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
@@ -282,10 +287,10 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
-	"-g [+|-]value",
+	"-G [+|-]value",
 	"             filter the subvolumes by generation",
 	"             (+value: >= value; -value: <= value; value: = value)",
-	"-c [+|-]value",
+	"-C [+|-]value",
 	"             filter the subvolumes by ogeneration",
 	"             (+value: >= value; -value: <= value; value: = value)",
 	"--sort=gen,ogen,rootid,path",
@@ -318,7 +323,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "apsurg:c:t", long_options, NULL);
+				    "apsurG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -345,7 +350,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
-		case 'g':
+		case 'G':
 			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
@@ -354,7 +359,7 @@ static int cmd_subvol_list(int argc, char **argv)
 				usage(cmd_subvol_list_usage);
 			break;
 
-		case 'c':
+		case 'C':
 			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			ret = btrfs_list_parse_filter_string(optarg,
 							&filter_set,
-- 
1.7.6.233.gd79bc

