Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFTTUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 15:20:36 -0400
Date: Fri, 20 Jun 2014 22:20:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, Sasha Levin <sasha.levin@oracle.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: fix error code in btrfs_init_test_fs()
Message-ID: <20140620192010.GB19824@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We had intended to return a negative error code here, but we use the
wrong variable so it returns success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 9626252..8e7225f 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -65,7 +65,7 @@ int btrfs_init_test_fs(void)
 	if (IS_ERR(test_mnt)) {
 		printk(KERN_ERR "btrfs: cannot mount test file system\n");
 		unregister_filesystem(&test_type);
-		return ret;
+		return PTR_ERR(test_mnt);
 	}
 	return 0;
 }
