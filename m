Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30115 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbcCJEXi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 23:23:38 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH RESEND] Btrfs: fix fs logging for multi device
Date: Thu, 10 Mar 2016 12:23:28 +0800
Message-Id: <1457583808-4123-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of multi device btrfs fs, using one of device for
the logging purpose is quite confusing, instead use the
fsid. FSID is bit long, but the device path can be long
as well in some cases.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fe80f73..07d55cd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -204,12 +204,12 @@ static const char * const logtypes[] = {
 
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
 
@@ -226,7 +226,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	printk("%sBTRFS: %pU %s: %pV\n", lvl, fs_devs->fsid, type, &vaf);
 
 	va_end(args);
 }
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
