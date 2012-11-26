Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51677 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2KZDAK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 22:00:10 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAQ30950017746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 03:00:10 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAQ3091B016117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 03:00:09 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAQ309vl003179
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Nov 2012 21:00:09 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix an while-loop of listxattr
Date: Mon, 26 Nov 2012 10:58:36 +0800
Message-Id: <1353898716-6527-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we found an invalid xattr dir item, we'd better try the next one instead.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 3f4e2d6..e9d3840 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -265,7 +265,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 		if (verify_dir_item(root, leaf, di))
-			continue;
+			goto next;
 
 		name_len = btrfs_dir_name_len(leaf, di);
 		total_size += name_len + 1;
-- 
1.7.7.6

