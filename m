Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44499 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3HNEbb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 00:31:31 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7E4VUlD026592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 04:31:31 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7E4VTwY029726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 04:31:30 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7E4VTWO000279
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 04:31:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Fix: mkfs.c overwrites fd without appropriate close patch
Date: Wed, 14 Aug 2013 12:37:31 +0800
Message-Id: <1376455051-12436-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
References: <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_add_to_fsid() saves the fd in the device list.
 close_ctree() will retrive the device list to handle
 the close(). So the device fd shouldn't closed here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 8183879..73f5425 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1548,8 +1548,6 @@ int main(int ac, char **av)
 		 * occur by the following processing.
 		 * (btrfs_register_one_device() fails if O_EXCL is on)
 		 */
-		if (fd > 0)
-			close(fd);
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open %s: %s\n", file,
@@ -1561,6 +1559,7 @@ int main(int ac, char **av)
 		if (ret) {
 			fprintf(stderr, "skipping duplicate device %s in FS\n",
 				file);
+			close(fd);
 			continue;
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-- 
1.7.1

