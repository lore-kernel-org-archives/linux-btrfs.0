Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3LBGCc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 01:02:32 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB262Vex012487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:32 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262VsW028710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:31 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB262Vd4006212
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 06:02:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: fix backref after init-csum-tree
Date: Mon,  2 Dec 2013 14:11:54 +0800
Message-Id: <1385964715-23355-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1385964715-23355-1-git-send-email-anand.jain@oracle.com>
References: <1385964715-23355-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfsck reports backref error after running init-csum-tree

btrfsck --init-csum-tree /dev/sdc
btrfsck /dev/sdc
::
ref mismatch on [29474816 16384] extent item 1, found 0
Backref 29474816 root 7 not referenced back 0x1101d30
Incorrect global backref count on 29474816 found 1 wanted 0
backpointer mismatch on [29474816 16384]
owner ref check failed [29474816 16384]
Errors found in extent allocation tree or chunk allocation
::

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-check.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index afad8a1..6a8d351 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6161,6 +6161,7 @@ int cmd_check(int argc, char **argv)
 		} else if (option_index == 2) {
 			printf("Creating a new CRC tree\n");
 			init_csum_tree = 1;
+			repair = 1;
 			ctree_flags |= OPEN_CTREE_WRITES;
 		} else if (option_index == 3) {
 			init_extent_tree = 1;
@@ -6234,6 +6235,11 @@ int cmd_check(int argc, char **argv)
 		ret = btrfs_commit_transaction(trans, info->csum_root);
 		if (ret)
 			exit(1);
+
+		ret = check_chunks_and_extents(root);
+		if (ret)
+			fprintf(stderr,
+				"Errors found in extent allocation tree or chunk allocation\n");
 		goto out;
 	}
 	ret = check_chunks_and_extents(root);
-- 
1.7.1

