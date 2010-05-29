From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/11] btrfs: btrfs_iget() returns ERR_PTR
Date: Sat, 29 May 2010 11:42:19 +0200
Message-ID: <20100529094219.GC5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_iget() returns an ERR_PTR() on failure and not null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 28b53f1..f2393b3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -392,8 +392,8 @@ setup_root:
 	location.offset = 0;
 
 	inode = btrfs_iget(sb, &location, new_root, &new);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 	/*
 	 * If we're just mounting the root most subvol put the inode and return
