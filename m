Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42699 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaGOIFX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 04:05:23 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6F85Mec031461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 08:05:22 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F85LFb011359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 08:05:21 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F85KsL006352
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 08:05:21 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: fix wrong message about forcing the mixed group profile
Date: Tue, 15 Jul 2014 16:26:20 +0800
Message-Id: <1405412780-9297-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the added disk is small, the function btrfs_prepare_device() would
print message indicating that mixed group is forced, apparently thats
not true

reproducer:

mkfs.btrfs -f -draid1 -mraid1 /dev/sdd /dev/sdc
::
SMALL VOLUME: forcing mixed metadata/data groups <---- WRONG

mount /dev/sdd /btrfs

btrfs fi df /btrfs
Data, RAID1: total=126.25MiB, used=128.00KiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=126.25MiB, used=112.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index 673134e..fbc5bde 100644
--- a/utils.c
+++ b/utils.c
@@ -705,10 +705,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
 
-	if (block_count < BTRFS_MKFS_SMALL_VOLUME_SIZE && !(*mixed)) {
-		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
+	if (block_count < BTRFS_MKFS_SMALL_VOLUME_SIZE && !(*mixed))
 		*mixed = 1;
-	}
 
 	if (discard) {
 		/*
-- 
2.0.0.153.g79dcccc

