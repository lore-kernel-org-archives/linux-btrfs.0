Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38487 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbbHNKfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:35:11 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 21/23] Btrfs: fix fs logging for multi device
Date: Fri, 14 Aug 2015 18:33:06 +0800
Message-Id: <1439548388-29686-22-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
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
index 56c0174..a8a0109 100644
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

