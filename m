Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbJEI4b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:56:31 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t958uU7C026375
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:56:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t958uT9h029609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:56:30 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t958uT3s003449
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:56:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add missing brelse when superblock checksum fails
Date: Mon,  5 Oct 2015 16:55:20 +0800
Message-Id: <1444035320-9400-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

looks like oversight, call brelse() when checksum fails.
further down the code in the non error path we do call
brelse() and so we don't see brelse() in the goto error..
paths.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7191b32..99d0804 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2665,6 +2665,7 @@ int open_ctree(struct super_block *sb,
 	if (btrfs_check_super_csum(bh->b_data)) {
 		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
 		err = -EINVAL;
+		brelse(bh);
 		goto fail_alloc;
 	}
 
-- 
2.4.1

