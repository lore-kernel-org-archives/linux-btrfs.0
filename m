Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3GYRaS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:18 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHUHmc017923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:17 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUFif029333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:16 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUFO7006934
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:15 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs-progs: mkfs.c overwrites fd without appropriate close
Date: Fri, 26 Jul 2013 01:35:28 +0800
Message-Id: <1374773730-29957-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 60f906c..66f558a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1570,6 +1570,8 @@ int main(int ac, char **av)
 		 * occur by the following processing.
 		 * (btrfs_register_one_device() fails if O_EXCL is on)
 		 */
+		if (fd > 0)
+			close(fd);
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open %s: %s\n", file,
@@ -1581,7 +1583,6 @@ int main(int ac, char **av)
 		if (ret) {
 			fprintf(stderr, "skipping duplicate device %s in FS\n",
 				file);
-			close(fd);
 			continue;
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-- 
1.7.1

