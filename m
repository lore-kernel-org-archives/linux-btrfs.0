Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46072 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaEICBP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 22:01:15 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4921EAk008951
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 9 May 2014 02:01:15 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4921DOK005819
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 9 May 2014 02:01:14 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4921CXP014239
	for <linux-btrfs@vger.kernel.org>; Fri, 9 May 2014 02:01:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix EIO on reading file after ioctl clone works on it
Date: Fri,  9 May 2014 10:01:02 +0800
Message-Id: <1399600862-3141-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For inline data extent, we need to make its length aligned, otherwise,
we can get a phantom extent map which confuses readpages() to return -EIO.

This can be detected by xfstests/btrfs/035.

Reported-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ad7de9..2f6d7b1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3120,6 +3120,8 @@ process_slot:
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 				u64 skip = 0;
 				u64 trim = 0;
+				u64 aligned_end = 0;
+
 				if (off > key.offset) {
 					skip = off - key.offset;
 					new_key.offset += skip;
@@ -3136,9 +3138,11 @@ process_slot:
 				size -= skip + trim;
 				datal -= skip + trim;
 
+				aligned_end = ALIGN(new_key.offset + datal,
+						    root->sectorsize);
 				ret = btrfs_drop_extents(trans, root, inode,
 							 new_key.offset,
-							 new_key.offset + datal,
+							 aligned_end,
 							 1);
 				if (ret) {
 					if (ret != -EOPNOTSUPP)
-- 
1.8.1.4

