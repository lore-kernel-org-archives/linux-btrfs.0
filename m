Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700AbaLJPG4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:06:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F3371AB09
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 15:06:55 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs-progs: subvol delete: add verbosity option
Date: Wed, 10 Dec 2014 16:06:55 +0100
Message-Id: <a68f4f8d9308a7edc66d4a426fb075f4ec585d52.1418223710.git.dsterba@suse.cz>
In-Reply-To: <cover.1418223710.git.dsterba@suse.cz>
References: <cover.1418223710.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an the option -v and use it for the transaction commit mode message.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-subvolume.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 4e452f4f4eb7..b14f86e06cb4 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -66,7 +66,7 @@ static int cmd_subvol_create(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "c:i:");
+		int c = getopt(argc, argv, "c:i:v");
 		if (c < 0)
 			break;
 
@@ -217,6 +217,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	char	*dupvname = NULL;
 	char	*path;
 	DIR	*dirstream = NULL;
+	int verbose = 0;
 	int sync_mode = 0;
 	struct option long_options[] = {
 		{"commit-after", no_argument, NULL, 'c'},  /* sync mode 1 */
@@ -239,6 +240,9 @@ static int cmd_subvol_delete(int argc, char **argv)
 		case 'C':
 			sync_mode = 2;
 			break;
+		case 'v':
+			verbose++;
+			break;
 		default:
 			usage(cmd_subvol_delete_usage);
 		}
@@ -247,9 +251,11 @@ static int cmd_subvol_delete(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_subvol_delete_usage);
 
-	printf("Transaction commit: %s\n",
-		!sync_mode ? "none (default)" :
-		sync_mode == 1 ? "at the end" : "after each");
+	if (verbose > 0) {
+		printf("Transaction commit: %s\n",
+			!sync_mode ? "none (default)" :
+			sync_mode == 1 ? "at the end" : "after each");
+	}
 
 	cnt = optind;
 
-- 
2.1.3

