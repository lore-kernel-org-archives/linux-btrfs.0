Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29266 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3DPE4e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 00:56:34 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3G4uXZA014546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 04:56:33 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G4uWoF010285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 04:56:33 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G4uWx2001170
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 04:56:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/11 v3] btrfs-progs: no pending balance is not an error
Date: Tue, 16 Apr 2013 12:58:15 +0800
Message-Id: <1366088295-7316-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <516BA1C6.2040003@oracle.com>
References: <516BA1C6.2040003@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Having no balance running/ paused/completed is a normal
situation, so the current output message should be positive
with return val zero.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-balance.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index f5dc317..cffa807 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -616,6 +616,12 @@ static const char * const cmd_balance_status_usage[] = {
 	NULL
 };
 
+/* Checks the status of the balance if any
+ * return codes:
+ *   2 : Error failed to know if there is any pending balance
+ *   1 : Successful to know status of a pending balance
+ *   0 : When there is no pending balance or completed
+ */
 static int cmd_balance_status(int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
@@ -654,7 +660,7 @@ static int cmd_balance_status(int argc, char **argv)
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+		return 2;
 	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_PROGRESS, &args);
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
+		return 2;
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

