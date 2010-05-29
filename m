From: Dan Carpenter <error27@gmail.com>
Subject: [patch 1/11] btrfs: handle error returns from
	btrfs_lookup_dir_item()
Date: Sat, 29 May 2010 11:40:57 +0200
Message-ID: <20100529094056.GB5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_lookup_dir_item() fails, we should can just let the mount fail
with an error.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d34b2df..28b53f1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -360,6 +360,8 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 */
 	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
 	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
+	if (IS_ERR(di))
+		return ERR_CAST(di);
 	if (!di) {
 		/*
 		 * Ok the default dir item isn't there.  This is weird since
