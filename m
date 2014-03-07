Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCGXmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 18:42:22 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s27NgLsw019865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 23:42:21 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27NgKca010993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 23:42:20 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27NgKHs017743
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 23:42:20 GMT
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: koen.de.wit@oracle.com
Subject: [PATCH] Btrfs: return EPERM when deleting a default subvolume
Date: Fri,  7 Mar 2014 15:41:46 -0800
Message-Id: <1394235706-24780-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error message is confusing:

 # btrfs sub delete /mnt/mysub/
 Delete subvolume '/mnt/mysub'
 ERROR: cannot delete '/mnt/mysub' - Directory not empty

The error message does not make sense to me: It's not about deleting a
directory but it's a subvolume, and it doesn't matter if the subvolume is
empty or not.

Maybe EPERM or is more appropriate in this case, combined with an explanatory
kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
it is configured as default subvolume.")

Reported-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 fs/btrfs/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a6d8efa..c380854 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1797,7 +1797,10 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	if (di && !IS_ERR(di)) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
 		if (key.objectid == root->root_key.objectid) {
-			ret = -ENOTEMPTY;
+			ret = -EPERM;
+			printk(KERN_ERR "subvolume %llu cannot be deleted "
+			       "because it is configured as default "
+			       "subvolume.\n", key.objectid);
 			goto out;
 		}
 		btrfs_release_path(path);
-- 
1.7.9.5

