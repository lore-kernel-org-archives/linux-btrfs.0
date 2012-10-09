Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab2JIQ16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 12:27:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id BBCF2A30B9
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2012 18:27:57 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs-progs: add option g to show generation, do not show it by default
Date: Tue,  9 Oct 2012 18:27:53 +0200
Message-Id: <1349800075-4888-2-git-send-email-dsterba@suse.cz>
In-Reply-To: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
References: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The generation was not printed so far, and adding 'g' will pair the 'G'
filter.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-list.c     |    2 +-
 cmds-subvolume.c |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e5f0f96..3821064 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -105,7 +105,7 @@ struct {
 	{
 		.name		= "gen",
 		.column_name	= "Gen",
-		.need_print	= 1,
+		.need_print	= 0,
 	},
 	{
 		.name		= "cgen",
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 61be38a..a2dece6 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -277,7 +277,7 @@ out:
  * - lowercase for enabling specific items in the output
  */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-apurts] [-G [+|-]value] [-C [+|-]value] "
+	"btrfs subvolume list [-agpurts] [-G [+|-]value] [-C [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
@@ -285,6 +285,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-a           print all the subvolumes in the filesystem.",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-t           print the result as a table",
+	"-g           print the generation of the subvolume",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
 	"-G [+|-]value",
@@ -323,7 +324,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "apsurG:C:t", long_options, NULL);
+				    "agpsurG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -334,6 +335,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'a':
 			is_list_all = 1;
 			break;
+		case 'g':
+			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
+			break;
 		case 't':
 			is_tab_result = 1;
 			break;
-- 
1.7.6.233.gd79bc

