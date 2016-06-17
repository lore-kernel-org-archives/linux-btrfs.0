Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:58075 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbcFQRXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 13:23:10 -0400
From: weiyj_lk@163.com
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Omar Sandoval <osandov@fb.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix error return code in btrfs_init_test_fs()
Date: Fri, 17 Jun 2016 17:20:40 +0000
Message-Id: <1466184040-10721-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the kern_mount() error handling
case instead of 0(ret is set to 0 by register_filesystem), as done
elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/btrfs/tests/btrfs-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 10eb249..02223f3 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -68,7 +68,7 @@ int btrfs_init_test_fs(void)
 	if (IS_ERR(test_mnt)) {
 		printk(KERN_ERR "btrfs: cannot mount test file system\n");
 		unregister_filesystem(&test_type);
-		return ret;
+		return PTR_ERR(test_mnt);
 	}
 	return 0;
 }



