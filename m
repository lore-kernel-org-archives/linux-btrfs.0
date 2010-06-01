From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: uninitialized data is check_path_shared()
Date: Tue, 1 Jun 2010 10:23:11 +0200
Message-ID: <20100601082311.GM5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

refs can be used with uninitialized data if btrfs_lookup_extent_info()
fails on the first pass through the loop.  In the original code if that
happens then check_path_shared() probably returns 1, but with this patch
it will continue through the loop.

I'm not super familiar with this code so please look it over carefully.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fa6ccc1..9640dae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2673,7 +2673,7 @@ static int check_path_shared(struct btrfs_root *root,
 	struct extent_buffer *eb;
 	int level;
 	int ret;
-	u64 refs;
+	u64 refs = 0;
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level])
