Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbaIEIwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Sep 2014 04:52:43 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s858qgFA007043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Sep 2014 08:52:43 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s858qfv2017420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Sep 2014 08:52:42 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s858qfTv024815
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Sep 2014 08:52:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: force overwrite should wipe stale SB
Date: Fri,  5 Sep 2014 23:51:24 +0800
Message-Id: <1409932284-30895-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a test case which says it all..

mkfs.xfs -f $DEV
mkfs.btrfs -f $DEV
mount $DEV $MNT
mount: /dev/vdiskc: more filesystems detected. This should not happen,
       use -t <type> to explicitly specify the filesystem type or
       use wipefs(8) to clean up the device.

mount: you must specify the filesystem type

with this patch btrfs_prepare_device() also wipes old FS if any,
btrfs_prepare_device() is called after we have verified that
user has provided -f option.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/utils.c b/utils.c
index 0064587..8b0c751 100644
--- a/utils.c
+++ b/utils.c
@@ -678,6 +678,35 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void wipe_existing_fs(int fd)
+{
+	blkid_probe     pr = NULL;
+
+	pr = blkid_new_probe();
+	if (!pr)
+		return;
+
+	if (blkid_probe_set_device(pr, fd, 0, 0))
+		goto out;
+
+	blkid_probe_enable_superblocks(pr, 1);
+	blkid_probe_set_superblocks_flags(pr,
+				BLKID_SUBLKS_MAGIC |
+				BLKID_SUBLKS_TYPE |
+				BLKID_SUBLKS_USAGE |
+				BLKID_SUBLKS_LABEL |
+				BLKID_SUBLKS_UUID);
+
+	blkid_probe_enable_partitions(pr, 1);
+
+	while (blkid_do_probe(pr) == 0)
+		blkid_do_wipe(pr, 0);
+
+	fsync(fd);
+out:
+	blkid_free_probe(pr);
+}
+
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 			   u64 max_block_count, int *mixed, int discard)
 {
@@ -729,6 +758,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		return 1;
 	}
 
+	wipe_existing_fs(fd);
+
 	*block_count_ret = block_count;
 	return 0;
 }
-- 
1.7.1

