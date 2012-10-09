Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab2JIQ16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 12:27:58 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 34DA0A3D7A
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2012 18:27:58 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs-progs: add option c to show ogeneration
Date: Tue,  9 Oct 2012 18:27:54 +0200
Message-Id: <1349800075-4888-3-git-send-email-dsterba@suse.cz>
In-Reply-To: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
References: <1349800075-4888-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will also pair the 'C' filter.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-subvolume.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index a2dece6..7a0b49f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -277,12 +277,13 @@ out:
  * - lowercase for enabling specific items in the output
  */
 static const char * const cmd_subvol_list_usage[] = {
-	"btrfs subvolume list [-agpurts] [-G [+|-]value] [-C [+|-]value] "
+	"btrfs subvolume list [-acgpurts] [-G [+|-]value] [-C [+|-]value] "
 	"[--sort=gen,ogen,rootid,path] <path>",
 	"List subvolumes (and snapshots)",
 	"",
 	"-p           print parent ID",
 	"-a           print all the subvolumes in the filesystem.",
+	"-c           print the ogeneration of the subvolume",
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-t           print the result as a table",
 	"-g           print the generation of the subvolume",
@@ -324,7 +325,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	optind = 1;
 	while(1) {
 		c = getopt_long(argc, argv,
-				    "agpsurG:C:t", long_options, NULL);
+				    "acgpsurG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -335,6 +336,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'a':
 			is_list_all = 1;
 			break;
+		case 'c':
+			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
+			break;
 		case 'g':
 			btrfs_list_setup_print_column(BTRFS_LIST_GENERATION);
 			break;
-- 
1.7.6.233.gd79bc

