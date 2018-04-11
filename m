Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39775 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751872AbeDKGoW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 02:44:22 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 033EB4D0EFC7
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 14:44:16 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: remove meaningless process
Date: Wed, 11 Apr 2018 14:44:13 +0800
Message-ID: <1523429053-6834-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable do_wait is synchronized with the variable do_background,
when if(do_background) is true, if(!do_wait) is also true, so parent
process will goto out immediately. The following wait never be run.

And if option -B is chosen, when do_background is 0 and do_wait is 1,
there is no need to fork a child process to wait for scrub over.
So remove unnecessary process.

Since parent process go out immediately, so remove SIGINT process of
parent process too.

Changelog:
v2: remove the SIGINT process of parent process.
v1: remove do_wait variable and wait process

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-scrub.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index efd7db94..c5f908f4 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -312,16 +312,6 @@ static void scrub_sigint_record_progress(int signal)
 		perror("Scrub cancel failed");
 }
 
-static int scrub_handle_sigint_parent(void)
-{
-	struct sigaction sa = {
-		.sa_handler = SIG_IGN,
-		.sa_flags = SA_RESTART,
-	};
-
-	return sigaction(SIGINT, &sa, NULL);
-}
-
 static int scrub_handle_sigint_child(int fd)
 {
 	struct sigaction sa = {
@@ -1109,7 +1099,6 @@ static int scrub_start(int argc, char **argv, int resume)
 	int print_raw = 0;
 	char *path;
 	int do_background = 1;
-	int do_wait = 0;
 	int do_print = 0;
 	int do_quiet = 0;
 	int do_record = 1;
@@ -1147,7 +1136,6 @@ static int scrub_start(int argc, char **argv, int resume)
 		switch (c) {
 		case 'B':
 			do_background = 0;
-			do_wait = 1;
 			do_print = 1;
 			break;
 		case 'd':
@@ -1374,28 +1362,10 @@ static int scrub_start(int argc, char **argv, int resume)
 		}
 
 		if (pid) {
-			int stat;
-			scrub_handle_sigint_parent();
 			if (!do_quiet)
 				printf("scrub %s on %s, fsid %s (pid=%d)\n",
 				       n_start ? "started" : "resumed",
 				       path, fsid, pid);
-			if (!do_wait) {
-				err = 0;
-				goto out;
-			}
-			ret = wait(&stat);
-			if (ret != pid) {
-				error_on(!do_quiet, "wait failed (ret=%d): %m",
-					ret);
-				err = 1;
-				goto out;
-			}
-			if (!WIFEXITED(stat) || WEXITSTATUS(stat)) {
-				error_on(!do_quiet, "scrub process failed");
-				err = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
-				goto out;
-			}
 			err = 0;
 			goto out;
 		}
-- 
2.14.3



