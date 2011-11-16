From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] btrfs scrub: handle -ENOMEM from init_ipath()
Date: Wed, 16 Nov 2011 11:28:01 +0300
Message-ID: <20111116082801.GE10264@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

init_ipath() can return an ERR_PTR(-ENOMEM).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ed11d38..b72ee47 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -256,6 +256,11 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	btrfs_release_path(swarn->path);
 
 	ipath = init_ipath(4096, local_root, swarn->path);
+	if (IS_ERR(ipath)) {
+		ret = PTR_ERR(ipath);
+		ipath = NULL;
+		goto err;
+	}
 	ret = paths_from_inode(inum, ipath);
 
 	if (ret < 0)
