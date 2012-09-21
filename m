Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51009 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2IUG5M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 02:57:12 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8L6v9TY023659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:57:10 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8L6v8H7017903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 06:57:09 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8L6v8PR030364
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 01:57:08 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs-progs: fix the btrfs-debug-tree usage
Date: Fri, 21 Sep 2012 14:59:44 +0800
Message-Id: <1348210784-29681-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 debug-tree.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index 94ffd8e..0e391fc 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -30,7 +30,7 @@
 
 static int print_usage(void)
 {
-	fprintf(stderr, "usage: debug-tree [ -e ] device\n");
+	fprintf(stderr, "usage: debug-tree [-derR] [-b <num>] device\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -51,6 +51,8 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 					     btrfs_node_blockptr(eb, i),
 					     size,
 					     btrfs_node_ptr_generation(eb, i));
+		if(!next)
+			BUG();
 		if (btrfs_is_leaf(next) &&
 		    btrfs_header_level(eb) != 1)
 			BUG();
-- 
1.7.1

