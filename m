Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37198 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbbJTLdZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 07:33:25 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9KBXPFd002317
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 11:33:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9KBXOdu010993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 11:33:24 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t9KBXNue007077
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 11:33:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs-progs: remove compressed option from 'qgroup limit'
Date: Tue, 20 Oct 2015 19:32:59 +0800
Message-Id: <1445340779-9084-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current design of btrfs quota doesn't support "quota limit after
compression" after 
commit e2d1f92399af ("btrfs: qgroup: do a reservation in a higher level.")

So remove it to make things clear.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Documentation/btrfs-qgroup.asciidoc | 4 ----
 cmds-qgroup.c                       | 9 ---------
 2 files changed, 13 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 57cf012..454b074 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -73,10 +73,6 @@ is used if possible.
 +
 `Options`
 +
--c::::
-limit amount of data after compression. This is the default, it is currently not
-possible to turn off this option.
-+
 -e::::
 limit space exclusively assigned to this qgroup.
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 48c1733..9f76232 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -382,8 +382,6 @@ static const char * const cmd_qgroup_limit_usage[] = {
 	"btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
 	"Set the limits a subvolume quota group.",
 	"",
-	"-c   limit amount of data after compression. This is the default,",
-	"     it is currently not possible to turn off this option.",
 	"-e   limit space exclusively assigned to this qgroup",
 	NULL
 };
@@ -396,7 +394,6 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	char *path = NULL;
 	struct btrfs_ioctl_qgroup_limit_args args;
 	unsigned long long size;
-	int compressed = 0;
 	int exclusive = 0;
 	DIR *dirstream = NULL;
 
@@ -406,9 +403,6 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		if (c < 0)
 			break;
 		switch (c) {
-		case 'c':
-			compressed = 1;
-			break;
 		case 'e':
 			exclusive = 1;
 			break;
@@ -426,9 +420,6 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	}
 
 	memset(&args, 0, sizeof(args));
-	if (compressed)
-		args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
-				  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
 	if (exclusive) {
 		args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
 		args.lim.max_exclusive = size;
-- 
1.8.2.1

