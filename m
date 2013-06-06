Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33146 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FFNiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 09:38:54 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r56Dcr3W027365
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Jun 2013 13:38:54 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r56DcqJ1028302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Jun 2013 13:38:53 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r56DcqEY027075
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Jun 2013 13:38:52 GMT
Message-ID: <51B090EA.6040209@oracle.com>
Date: Thu, 06 Jun 2013 21:38:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix the code comments for LZO compression workspace
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

Fix the code comments for lzo compression workspace.
The buf item is used to store the decompressed data
and cbuf is used to store the compressed data.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/btrfs/lzo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 743b86f..f93151a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -31,8 +31,8 @@
 
 struct workspace {
 	void *mem;
-	void *buf;	/* where compressed data goes */
-	void *cbuf;	/* where decompressed data goes */
+	void *buf;	/* where decompressed data goes */
+	void *cbuf;	/* where compressed data goes */
 	struct list_head list;
 };
 
-- 
1.7.9.5
