From: Dan Carpenter <error27@gmail.com>
Subject: [patch 1/3] btrfs: checking for NULL instead of IS_ERR()
Date: Sat, 20 Mar 2010 14:22:10 +0300
Message-ID: <20100320112210.GV5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_get_extent() never returns NULL, only a valid pointer or ERR_PTR()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2845c6c..15f661d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -511,7 +511,7 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
 
-		if (!em)
+		if (IS_ERR(em))
 			return 0;
 	}
 
