Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:31946 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933129AbaCTJnj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:39 -0400
Date: Thu, 20 Mar 2014 11:43:35 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: btrfs: remove dead code in handle_options
Message-ID: <20140320094334.GA10167@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just cleanup: remove useless return type, while loop and dead code.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 btrfs.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 16458ef..25257b6 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -212,31 +212,20 @@ static int cmd_version(int argc, char **argv)
 	return 0;
 }
 
-static int handle_options(int *argc, char ***argv)
+static void handle_options(int *argc, char ***argv)
 {
-	char **orig_argv = *argv;
-
-	while (*argc > 0) {
+	if (*argc > 0) {
 		const char *arg = (*argv)[0];
-		if (arg[0] != '-')
-			break;
-
-		if (!strcmp(arg, "--help")) {
-			break;
-		} else if (!strcmp(arg, "--version")) {
-			break;
-		} else {
-			fprintf(stderr, "Unknown option: %s\n", arg);
-			fprintf(stderr, "usage: %s\n",
-				btrfs_cmd_group.usagestr[0]);
-			exit(129);
-		}
-
-		(*argv)++;
-		(*argc)--;
+		if (arg[0] != '-' ||
+		    !strcmp(arg, "--help") ||
+		    !strcmp(arg, "--version"))
+			return;
+		fprintf(stderr, "Unknown option: %s\n", arg);
+		fprintf(stderr, "usage: %s\n",
+			btrfs_cmd_group.usagestr[0]);
+		exit(129);
 	}
-
-	return (*argv) - orig_argv;
+	return;
 }
 
 static const struct cmd_group btrfs_cmd_group = {
-- 
1.8.5.3

