Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbaGOHEq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 03:04:46 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6F74jW5010597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:04:46 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F74iWZ007713
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:04:45 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F74iFg012724
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:04:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: fix compilation warning in function btrfs_read_dev_super
Date: Tue, 15 Jul 2014 15:25:41 +0800
Message-Id: <1405409141-7573-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

disk-io.c: In function ‘btrfs_read_dev_super’:
disk-io.c:1217: warning: ‘ret’ may be used uninitialized in this function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 142197a..d10d647 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1214,7 +1214,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	u8 data[BTRFS_SUPER_INFO_SIZE];
 	struct btrfs_super_block *buf = (struct btrfs_super_block *) data;
 	int i;
-	int ret;
+	int ret = -ENOENT;
 	int max_super = super_recover ? BTRFS_SUPER_MIRROR_MAX : 1;
 	u64 transid = 0;
 	u64 bytenr;
-- 
2.0.0.153.g79dcccc

