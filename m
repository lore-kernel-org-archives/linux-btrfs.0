From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: hold enough space for global_rsv
Date: Tue, 17 Jan 2012 17:51:59 +0800
Message-ID: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've kept hitting enospc warnings of global_rsv while running defragment on
files:
btrfs: block rsv returned -28
WARNING: at fs/btrfs/extent-tree.c:5984 btrfs_alloc_free_block+0x333/0x340 [btrfs]()
...

I used a fio jobs to create a file with lots of fragments:
$ filefrag /mnt/btrfs/foobar
/mnt/btrfs/foobar: 66964 extents found

and then "btrfs fi defrag /mnt/btrfs/foobar && sync" would pop the warnings.

I found that the global_rsv size is just not enough for defragment, and didn't
find any space leak in using global_rsv, so double it and go ahead.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8603ee4..77ea23c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3979,7 +3979,7 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	num_bytes += div64_u64(data_used + meta_used, 50);
 
 	if (num_bytes * 3 > meta_used)
-		num_bytes = div64_u64(meta_used, 3);
+		num_bytes = div64_u64(meta_used, 3) * 2;
 
 	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
 }
-- 
1.6.5.2

