From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 03/11] Btrfs: check the return value of io_ctl_init()
Date: Wed, 11 Jan 2012 13:52:37 +0800
Message-ID: <4F0D23A5.8010705@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

It can return -ENOMEM.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4e55af3..e4eb222 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -637,7 +637,10 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (!num_entries)
 		return 0;
 
-	io_ctl_init(&io_ctl, inode, root);
+	ret = io_ctl_init(&io_ctl, inode, root);
+	if (ret)
+		return ret;
+
 	ret = readahead_cache(inode);
 	if (ret)
 		goto out;
@@ -851,7 +854,9 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (!i_size_read(inode))
 		return -1;
 
-	io_ctl_init(&io_ctl, inode, root);
+	ret = io_ctl_init(&io_ctl, inode, root);
+	if (ret)
+		return -1;
 
 	/* Get the cluster for this block_group if it exists */
 	if (block_group && !list_empty(&block_group->cluster_list))
-- 
1.7.3.1
