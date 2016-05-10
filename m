Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbcEJOJp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:09:45 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 07/13] btrfs: add check not to mount a spare device
Date: Tue, 10 May 2016 22:09:26 +0800
Message-Id: <1462889372-5274-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Spare devices can be scanned but shouldn't be mountable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65c9f19d8017..e9fca3bc7e42 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2811,6 +2811,14 @@ int open_ctree(struct super_block *sb,
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
 	 * Needn't use the lock because there is no other task which will
 	 * update the flag.
-- 
2.7.0

