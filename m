Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50468 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3DOGh3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 02/11, RESEND] btrfs-progs: no pending balance is not an error
Date: Mon, 15 Apr 2013 14:38:08 +0800
Message-Id: <1366007897-26567-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Having no balance running/ paused/completed is a normal
situation, so the current output message should be positive
with return val zero.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-balance.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index f5dc317..a968e0d 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -616,6 +616,12 @@ static const char * const cmd_balance_status_usage[] = {
 	NULL
 };
 
+/* Checks the status of the balance if any
+ * return codes:
+ *  -1 : Error failed to know if there is any pending balance
+ *   1 : Successful to know status of a pending balance
+ *   0 : When there is no pending balance or completed
+ */
 static int cmd_balance_status(int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
@@ -662,9 +668,13 @@ static int cmd_balance_status(int argc, char **argv)
 	close(fd);
 
 	if (ret < 0) {
+		if (e == ENOTCONN) {
+			printf("No balance found on '%s'\n", path);
+			return 0;
+		}
 		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
-			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
-		return 19;
+			path, strerror(e));
+		return -1;
 	}
 
 	if (args.state & BTRFS_BALANCE_STATE_RUNNING) {
@@ -688,7 +698,7 @@ static int cmd_balance_status(int argc, char **argv)
 	if (verbose)
 		dump_ioctl_balance_args(&args);
 
-	return 0;
+	return 1;
 }
 
 const struct cmd_group balance_cmd_group = {
-- 
1.8.1.227.g44fe835

