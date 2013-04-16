Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37916 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3DPJ1C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:27:02 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3G9R1qO007096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:27:01 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G9R0rH013431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:27:00 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G9R0tq013428
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:27:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: delete unused function btrfs_read_super_device
Date: Tue, 16 Apr 2013 17:28:44 +0800
Message-Id: <1366104524-10710-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 volumes.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/volumes.c b/volumes.c
index b555ded..7a9b6f0 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1643,15 +1643,6 @@ static int read_one_dev(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf)
-{
-	struct btrfs_dev_item *dev_item;
-
-	dev_item = (struct btrfs_dev_item *)offsetof(struct btrfs_super_block,
-						     dev_item);
-	return read_one_dev(root, buf, dev_item);
-}
-
 int btrfs_read_sys_array(struct btrfs_root *root)
 {
 	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
-- 
1.8.1.227.g44fe835

