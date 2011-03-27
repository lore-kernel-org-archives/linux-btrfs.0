From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix possible deadlock by clearing __GFP_FS flag
Date: Sun, 27 Mar 2011 16:07:36 +0800
Message-ID: <4D8EF048.5050203@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Using the GFP_HIGHUSER_MOVABLE flag to allocate the metadata's page may cause
deadlock.
  Task1					Kswap0 task
  open()
    ...
    btrfs_search_slot()
      ...
      btrfs_cow_block()
	...
	alloc_page()
	  wait for reclaiming
					shrink_slab()
					  ...
					  shrink_icache_memory()
					    ...
					    btrfs_evict_inode()
					      ...
					      btrfs_search_slot()

If the path is locked by task1, the deadlock happens.

So the btree's page cache is different with the file's page cache, it can not
allocate pages by GFP_HIGHUSER_MOVABLE flag, we must clear __GFP_FS flag in
GFP_HIGHUSER_MOVABLE flag.

Reported-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..cf55fa0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1632,6 +1632,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_bdi;
 	}
 
+	fs_info->btree_inode->i_mapping->flags &= ~__GFP_FS;
+
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
-- 
1.7.4
