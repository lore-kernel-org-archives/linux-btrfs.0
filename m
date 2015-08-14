Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34221 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbbHNKdw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:52 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 19/23] Btrfs: avoid user cli usage error logging into the sys log
Date: Fri, 14 Aug 2015 18:33:04 +0800
Message-Id: <1439548388-29686-20-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5803c45..f3ca87d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -198,7 +198,6 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 
 	if (IS_ERR(*bdev)) {
 		ret = PTR_ERR(*bdev);
-		printk(KERN_INFO "BTRFS: open %s failed\n", device_path);
 		goto error;
 	}
 
-- 
2.4.1

