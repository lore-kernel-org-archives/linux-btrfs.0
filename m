Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaC1IG2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 04:06:28 -0400
Date: Fri, 28 Mar 2014 11:06:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: kmalloc() doesn't return an ERR_PTR
Message-ID: <20140328080600.GD25192@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error handling was copy and pasted from memdup_user().  It should be
checking for NULL obviously.

Fixes: abccd00f8af2 ('btrfs: Fix 32/64-bit problem with BTRFS_SET_RECEIVED_SUBVOL ioctl')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0401397..27d551c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4531,9 +4531,8 @@ static long btrfs_ioctl_set_received_subvol_32(struct file *file,
 	}
 
 	args64 = kmalloc(sizeof(*args64), GFP_NOFS);
-	if (IS_ERR(args64)) {
-		ret = PTR_ERR(args64);
-		args64 = NULL;
+	if (!args64) {
+		ret = -ENOMEM;
 		goto out;
 	}
 
