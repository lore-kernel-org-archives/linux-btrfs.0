Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaGGOgE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 10:36:04 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s67Ea34l013371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 14:36:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s67Ea1DT004341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 14:36:02 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67Ea1EH004354
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 14:36:01 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix Segmentation fault of btrfs-convert
Date: Mon,  7 Jul 2014 22:35:53 +0800
Message-Id: <1404743753-24856-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recently we merge a memory leak fix, which fails xfstests/btrfs/012,
the cause is that it only frees @fs_devices but leaves it on the global
fs_uuid list, which cause a 'Segmentation fault' over running command
btrfs-convert.  This fixes the problem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 volumes.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index a61928c..8b827fa 100644
--- a/volumes.c
+++ b/volumes.c
@@ -184,11 +184,17 @@ again:
 	seed_devices = fs_devices->seed;
 	fs_devices->seed = NULL;
 	if (seed_devices) {
+		struct btrfs_fs_devices *orig;
+
+		orig = fs_devices;
 		fs_devices = seed_devices;
+		list_del(&orig->list);
+		free(orig);
 		goto again;
+	} else {
+		list_del(&fs_devices->list);
+		free(fs_devices);
 	}
-
-	free(fs_devices);
 	return 0;
 }
 
-- 
1.8.1.4

