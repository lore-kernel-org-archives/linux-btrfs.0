Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51065 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbKIK5q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:46 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvktP014217
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvkJU008095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:46 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvkS7018196
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/15] btrfs: add check not to mount a spare device
Date: Mon,  9 Nov 2015 18:56:25 +0800
Message-Id: <1447066589-3835-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Spare devices can be scanned but shouldn't be mountable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 38e0385..3662c0a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2768,6 +2768,14 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	if (btrfs_super_incompat_flags(disk_super) &
+			BTRFS_FEATURE_INCOMPAT_SPARE_DEV) {
+		/*You can only scan a spare device but not mount*/
+		printk(KERN_ERR "BTRFS: You can't mount a spare device\n");
+		err = -ENOTSUPP;
+		goto fail_alloc;
+	}
+
 	/*
 	 * Leafsize and nodesize were always equal, this is only a sanity check.
 	 */
-- 
2.4.1

