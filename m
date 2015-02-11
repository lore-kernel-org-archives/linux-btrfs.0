Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39824 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbbBLEcx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:32:53 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t1C4WpAC011164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:52 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t1C4Wo5E002334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:51 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t1C4WoH7000519
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: procfs-devlist: backport global rcu-string non support
Date: Thu, 12 Feb 2015 04:32:30 +0800
Message-Id: <1423686751-5053-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
References: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/procfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/procfs.c b/fs/btrfs/procfs.c
index d16a76b..4aec759 100644
--- a/fs/btrfs/procfs.c
+++ b/fs/btrfs/procfs.c
@@ -1,9 +1,9 @@
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
-#include <linux/rcustring.h>
 #include "ctree.h"
 #include "volumes.h"
+#include "rcu-string.h"
 
 #define BTRFS_PROC_PATH		"fs/btrfs"
 #define BTRFS_PROC_DEVLIST	"devlist"
@@ -67,7 +67,7 @@ again_fs_devs:
 			BTRFS_SEQ_PRINT("\t\tdev_addr:\t%p\n", device);
 			rcu_read_lock();
 			BTRFS_SEQ_PRINT("\t\tdevice:\t\t%s\n",
-				device->name ? rcu_string_dereference(device->name): "(null)");
+				device->name ? rcu_str_deref(device->name): "(null)");
 			rcu_read_unlock();
 			BTRFS_SEQ_PRINT("\t\tdevid:\t\t%llu\n", device->devid);
 			if (device->dev_root) {
-- 
2.0.0.153.g79dcccc

