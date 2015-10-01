Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19501 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbbJANzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 09:55:37 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t91Dta2Z027863
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 13:55:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t91DtZB1023363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 13:55:36 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t91DtZmL017372
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 13:55:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: fix fs logging for multi device
Date: Thu,  1 Oct 2015 21:55:25 +0800
Message-Id: <1443707725-1568-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of multi device btrfs fs, using one of device for
the logging purpose it quite confusing, instead use the
fsid. FSID is bit long, but the device path can be long
as well in some cases.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0bc61fb..181db38 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -190,12 +190,12 @@ static const char * const logtypes[] = {
 
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
-	struct super_block *sb = fs_info->sb;
 	char lvl[4];
 	struct va_format vaf;
 	va_list args;
 	const char *type = logtypes[4];
 	int kern_level;
+	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
 
 	va_start(args, fmt);
 
@@ -212,7 +212,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	printk("%sBTRFS: %pU %s: %pV\n", lvl, fs_devs->fsid, type, &vaf);
 
 	va_end(args);
 }
-- 
2.4.1

