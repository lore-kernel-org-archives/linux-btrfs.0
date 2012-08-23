Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17697 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2HWI7E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 04:59:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7N8x2mE023357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 08:59:03 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7N8x1IK012559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 08:59:02 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7N8x1xR005364
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 03:59:01 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use larger limit for transition of logical to inode
Date: Thu, 23 Aug 2012 16:56:29 +0800
Message-Id: <1345712189-6455-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
References: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the change of the kernel side.

Transition of logical to inode used to have a limit 4096 on inode container's
size, but the limit is not large enough for a data with a great many of refs,
so when resolving logical address, we can end up with
"ioctl ret=0, bytes_left=0, bytes_missing=19944, cnt=510, missed=2493"

This changes to regard 4096 as the lowest limit.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9449b84..525915f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3232,7 +3232,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		goto out;
 	}
 
-	size = min_t(u32, loi->size, 4096);
+	size = max_t(u32, loi->size, 4096);
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-- 
1.7.7.6

