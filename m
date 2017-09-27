Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:36737 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965241AbdI0CBV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 22:01:21 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4267EAC005A
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:01:14 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 6C39046E7DA
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:01:13 +0900 (JST)
Subject: [PATCH v2 1/5] btrfs-progs: subvol: exchange subvol del
 --commit-after and --commit-each
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Message-ID: <4ea9ba07-a36e-57f6-57a5-331f064482da@jp.fujitsu.com>
Date: Wed, 27 Sep 2017 11:01:09 +0900
MIME-Version: 1.0
In-Reply-To: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code is reversed in --commit-after and --commit-each operation.
i.e. --commit-after means --commit-each actually. This patch fix this
and also introduces enum type for more readable code.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-subvolume.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 666f6e0..9e561f3 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -263,6 +263,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	DIR	*dirstream = NULL;
 	int verbose = 0;
 	int commit_mode = 0;
+	enum { COMMIT_AFTER = 1, COMMIT_EACH = 2 };
 
 	while (1) {
 		int c;
@@ -279,10 +280,10 @@ static int cmd_subvol_delete(int argc, char **argv)
 
 		switch(c) {
 		case 'c':
-			commit_mode = 1;
+			commit_mode = COMMIT_AFTER;
 			break;
 		case 'C':
-			commit_mode = 2;
+			commit_mode = COMMIT_EACH;
 			break;
 		case 'v':
 			verbose++;
@@ -298,7 +299,7 @@ static int cmd_subvol_delete(int argc, char **argv)
 	if (verbose > 0) {
 		printf("Transaction commit: %s\n",
 			!commit_mode ? "none (default)" :
-			commit_mode == 1 ? "at the end" : "after each");
+			commit_mode == COMMIT_AFTER ? "at the end" : "after each");
 	}
 
 	cnt = optind;
@@ -338,7 +339,7 @@ again:
 	}
 
 	printf("Delete subvolume (%s): '%s/%s'\n",
-		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
+		commit_mode == COMMIT_EACH || (commit_mode == COMMIT_AFTER && cnt + 1 == argc)
 		? "commit" : "no-commit", dname, vname);
 	memset(&args, 0, sizeof(args));
 	strncpy_null(args.name, vname);
@@ -350,7 +351,7 @@ again:
 		goto out;
 	}
 
-	if (commit_mode == 1) {
+	if (commit_mode == COMMIT_EACH) {
 		res = wait_for_commit(fd);
 		if (res < 0) {
 			error("unable to wait for commit after '%s': %s",
@@ -373,7 +374,7 @@ out:
 		goto again;
 	}
 
-	if (commit_mode == 2 && fd != -1) {
+	if (commit_mode == COMMIT_AFTER && fd != -1) {
 		res = wait_for_commit(fd);
 		if (res < 0) {
 			error("unable to do final sync after deletion: %s",
-- 
2.9.5

