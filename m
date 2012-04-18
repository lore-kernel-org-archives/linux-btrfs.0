From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] Btrfs: cleanup: use consistent lock naming
Date: Wed, 18 Apr 2012 09:59:29 +0300
Message-ID: <20120418065928.GF12831@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It confuses Smatch that we use two names for the same lock.  Plus the
shorter name is nicer.  This doesn't change how the code works, it's
just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0bb9dc..29c0445 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3578,7 +3578,7 @@ again:
 	space_info->chunk_alloc = 0;
 	spin_unlock(&space_info->lock);
 out:
-	mutex_unlock(&extent_root->fs_info->chunk_mutex);
+	mutex_unlock(&fs_info->chunk_mutex);
 	return ret;
 }
 
