Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42580 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3IMOEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 10:04:22 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 13 Sep 2013 19:25:39 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id E5D90E0057
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 19:35:08 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8DE6FLn28180692
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 19:36:15 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8DE4DLo010757
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 19:34:14 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chandra.seetharaman@us.ibm.com,
        alexander.karbstein@gmail.com
Subject: [PATCH] Btrfs: btrfs_ioctl_default_subvol: Revert back to toplevel subvolume when arg is 0
Date: Fri, 13 Sep 2013 19:34:10 +0530
Message-ID: <3458610.yWSLv9Ftnr@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes it possible to set BTRFS_FS_TREE_OBJECTID as the default
subvolume by passing a subvolume id of 0.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a5b946..a059c3c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3310,7 +3310,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	}
 
 	if (!objectid)
-		objectid = root->root_key.objectid;
+		objectid = BTRFS_FS_TREE_OBJECTID;
 
 	location.objectid = objectid;
 	location.type = BTRFS_ROOT_ITEM_KEY;
-- 
1.8.3.1


