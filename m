Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23529 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AGDzZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 22:55:25 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r073tOX9014292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 03:55:25 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r073tO7t008528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 03:55:24 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r073tOKT020726
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 21:55:24 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix off-by-one in lseek
Date: Mon,  7 Jan 2013 11:53:08 +0800
Message-Id: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lock end is inclusive.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 77061bf..1e16b6d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2241,6 +2241,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 	if (lockend <= lockstart)
 		lockend = lockstart + root->sectorsize;
 
+	lockend--;
 	len = lockend - lockstart + 1;
 
 	len = max_t(u64, len, root->sectorsize);
-- 
1.7.7.6

