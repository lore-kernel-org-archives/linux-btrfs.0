Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25175 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbcC2OWy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:22:54 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 08/12] btrfs: add check not to mount a spare device
Date: Tue, 29 Mar 2016 22:22:25 +0800
Message-Id: <1459261349-32206-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Spare devices can be scanned but shouldn't be mountable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7f02f1766037..b99329e37965 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2806,6 +2806,14 @@ int open_ctree(struct super_block *sb,
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

