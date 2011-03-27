From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V2] btrfs: fix possible deadlock by clearing __GFP_FS flag
Date: Sun, 27 Mar 2011 20:27:30 +0800
Message-ID: <4D8F2D32.3000601@cn.fujitsu.com>
References: <4D8EF048.5050203@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Josef Bacik <josef@redhat.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8EF048.5050203@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Changelog V1 -> V2:
- modify the explanation of the deadlock.
- clear __GFP_FS flag in the free space's page cache.

Using the GFP_HIGHUSER_MOVABLE flag to allocate the metadata's page may cause
deadlock.
  Task1
  open()
    ...
    btrfs_search_slot()
      ...
      btrfs_cow_block()
	...
	alloc_page()
	  ...
	  do_try_to_free_pages()
	    shrink_slab()
	    ...
	      shrink_icache_memory()
		...
		btrfs_evict_inode()
		  ...
		  btrfs_search_slot()

If the path is locked by task1, the deadlock happens.

So the btree's page cache and free space's page cache  is different with the
file's page cache, it can not allocate pages by GFP_HIGHUSER_MOVABLE flag,
we must clear __GFP_FS flag in their i_mapping's flag.

Reported-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c          |    2 ++
 fs/btrfs/free-space-cache.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

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
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a039065..57df380 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -88,6 +88,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	}
 	spin_unlock(&block_group->lock);
 
+	inode->i_mapping->flags &= ~__GFP_FS;
+
 	return inode;
 }
 
-- 
1.7.4
