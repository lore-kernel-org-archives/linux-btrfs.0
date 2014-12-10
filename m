Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbaLJPHA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:07:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6881BAB09
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 15:06:59 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/3] btrfs-progs: subvol delete: rename variable to match the option name
Date: Wed, 10 Dec 2014 16:06:58 +0100
Message-Id: <76b9cc5126555183f6fb8e7e0b3225337859b5a2.1418223711.git.dsterba@suse.cz>
In-Reply-To: <cover.1418223710.git.dsterba@suse.cz>
References: <cover.1418223710.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-subvolume.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b14f86e06cb4..15d4b975a916 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -218,10 +218,10 @@ static int cmd_subvol_delete(int argc, char **argv)
 	char	*path;
 	DIR	*dirstream = NULL;
 	int verbose = 0;
-	int sync_mode = 0;
+	int commit_mode = 0;
 	struct option long_options[] = {
-		{"commit-after", no_argument, NULL, 'c'},  /* sync mode 1 */
-		{"commit-each", no_argument, NULL, 'C'},  /* sync mode 2 */
+		{"commit-after", no_argument, NULL, 'c'},  /* commit mode 1 */
+		{"commit-each", no_argument, NULL, 'C'},  /* commit mode 2 */
 		{NULL, 0, NULL, 0}
 	};
 
@@ -235,10 +235,10 @@ static int cmd_subvol_delete(int argc, char **argv)
 
 		switch(c) {
 		case 'c':
-			sync_mode = 1;
+			commit_mode = 1;
 			break;
 		case 'C':
-			sync_mode = 2;
+			commit_mode = 2;
 			break;
 		case 'v':
 			verbose++;
@@ -253,8 +253,8 @@ static int cmd_subvol_delete(int argc, char **argv)
 
 	if (verbose > 0) {
 		printf("Transaction commit: %s\n",
-			!sync_mode ? "none (default)" :
-			sync_mode == 1 ? "at the end" : "after each");
+			!commit_mode ? "none (default)" :
+			commit_mode == 1 ? "at the end" : "after each");
 	}
 
 	cnt = optind;
@@ -310,7 +310,7 @@ again:
 	}
 
 	printf("Delete subvolume (%s): '%s/%s'\n",
-		sync_mode == 2 || (sync_mode == 1 && cnt + 1 == argc)
+		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
 		? "commit" : "no-commit", dname, vname);
 	strncpy_null(args.name, vname);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
@@ -323,7 +323,7 @@ again:
 		goto out;
 	}
 
-	if (sync_mode == 1) {
+	if (commit_mode == 1) {
 		res = wait_for_commit(fd);
 		if (res < 0) {
 			fprintf(stderr,
@@ -347,7 +347,7 @@ out:
 		goto again;
 	}
 
-	if (sync_mode == 2 && fd != -1) {
+	if (commit_mode == 2 && fd != -1) {
 		res = wait_for_commit(fd);
 		if (res < 0) {
 			fprintf(stderr,
-- 
2.1.3

