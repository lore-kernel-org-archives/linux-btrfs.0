Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbIOIsI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 04:48:08 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t8F8m8Ge009869
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t8F8m8KX030495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:08 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t8F8m7Lw024001
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 08:48:08 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: optimize not to scan repeated fsid mount points
Date: Tue, 15 Sep 2015 16:46:23 +0800
Message-Id: <1442306783-1288-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
References: <1442306783-1288-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fsid can be mounted multiple times, with different subvolid.
And we don't have to scan a mount point if we already have
that in the scanned list.

And thus nicely avoids the following warning with multiple
subvol mounts on older kernel like 2.6.32 where
BTRFS_IOC_GET_FSLABEL ioctl does not exist.

./btrfs fi show -m
Label: none  uuid: 31845933-611e-422d-ae6f-386e57ad81aa
	Total devices 2 FS bytes used 172.00KiB
	devid    1 size 3.00GiB used 642.38MiB path /dev/sdd
	devid    2 size 3.00GiB used 622.38MiB path /dev/sde

warning, device 2 is missing
warning devid 2 not found already
warning, device 2 is missing
warning devid 2 not found already

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 793df0e..e2049cc 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -468,6 +468,10 @@ static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 			goto out;
 		}
 
+		/* skip all fs already shown as mounted fs */
+		if (is_seen_fsid(fs_info_arg.fsid))
+			continue;
+
 		ret = get_label_mounted(mnt->mnt_dir, label);
 		/* provide backward kernel compatibility */
 		if (ret == -ENOTTY)
-- 
2.4.1

