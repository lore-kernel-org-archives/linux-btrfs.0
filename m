From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [BUG] Chunk allocation fails when the system meta-data block group
 is full
Date: Thu, 21 Jul 2011 17:08:22 +0800
Message-ID: <4E27EC86.3030006@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Everyone

I found there is an bug in the code of the chunk allocation by reading
the code, That is:

  If we allocate lots of the meta-data chunks or data chunks, and make
  the system meta-data block group be full, then we can not allocate
  any chunk for ever, even though there is lots of free disk space.

It is because Btrfs do not allocate any new system meta-data chunk when
the old block group is full, and then we have no system meta-data space
to store the new meta-data chunk information.

This bug is hard to be triggered in the normal way, because we need
lots of disk space to allocate new meta-data chunks, and fill the
system meta-data block group. So I used a tricky method to triggered
this bug:
1. modify the source of Btrfs to exclude most free space of the system
   meta-data block group, and change the max size of the deta chunk,
   by this way, we can allocate lots of the chunks and fill the system
   meta-data block group easily. (See the attached patch)
2. create a new Btrfs filesystem. (Data profile: single)
3. mount the new filesystem.
4. create a large file
(Oops happened)
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:2602!
[SNIP]
Call Trace:
 [<ffffffffa034069e>] btrfs_alloc_chunk+0x71/0x84 [btrfs]
 [<ffffffffa031453f>] do_chunk_alloc+0x28e/0x2f3 [btrfs]
 [<ffffffffa0316ef6>] btrfs_reserve_extent+0xfb/0x1c2 [btrfs]
 [<ffffffffa0327dc6>] cow_file_range+0x1c0/0x32b [btrfs]
 [<ffffffffa03285dd>] run_delalloc_range+0xb7/0x33f [btrfs]
 [<ffffffffa033afbd>] __extent_writepage+0x1c1/0x5d0 [btrfs]
 [<ffffffffa03395ee>] ? clear_extent_buffer_uptodate+0x85/0x85 [btrfs]
 [<ffffffffa033b8fe>] extent_write_cache_pages.clone.0+0x176/0x2ad [btrfs]
 [<ffffffffa033bb23>] extent_writepages+0x3e/0x53 [btrfs]
 [<ffffffffa03252b0>] ? uncompress_inline+0x122/0x122 [btrfs]
 [<ffffffffa032516c>] btrfs_writepages+0x22/0x24 [btrfs]
 [<ffffffff810c95cc>] do_writepages+0x1c/0x28
 [<ffffffff81123a5a>] writeback_single_inode+0xc2/0x1c3
 [<ffffffff81123f32>] writeback_sb_inodes+0xcc/0x15a
 [<ffffffff81124801>] writeback_inodes_wb+0x10a/0x11c
 [<ffffffff810c8ca6>] balance_dirty_pages_ratelimited_nr+0x2f9/0x3fd
 [<ffffffffa032f7fd>] __btrfs_buffered_write+0x298/0x315 [btrfs]
 [<ffffffff81119891>] ? file_update_time+0xf2/0x10c
 [<ffffffffa032fc41>] btrfs_file_aio_write+0x3c7/0x47e [btrfs]
 [<ffffffff8110690a>] do_sync_write+0xc6/0x103
 [<ffffffff811cc010>] ? security_file_permission+0x29/0x2e
 [<ffffffff8110729a>] vfs_write+0xa9/0x105
 [<ffffffff811073af>] sys_write+0x45/0x6c
 [<ffffffff81451bd2>] system_call_fastpath+0x16/0x1b
[SNIP] 
RIP  [<ffffffffa033eb0a>] __finish_chunk_alloc+0x176/0x1f8 [btrfs]
 RSP <ffff8801377cf448>
---[ end trace 5a55cd7f2763cc4c ]---

If my analysis is right, and this bug actually exists, I think we can fix this bug by
splitting the chunk allocation to two steps:

  1. do chunk allocation and in-memory information update
  2. update the meta-data and the system meta-data according to all the new chunks
     allocated at the 1st step.

And we also split the 1st step to 3 sub-steps:

  1. If we want to allocate a system meta-data chunk, or the free space of old
     system meta-data block group is not enough though we don't want to allocate
     a system meta-data chunk, we allocate a new system meta-data chunk and update
     the system meta-data space information in the memory.
  2. If we want to allocate a meta-data chunk, or the free space of old meta-data
     block group is not enough though we don't want to allocate a meta-data chunk,
     we allocate a new meta-data chunk and update the meta-data space information
     in the memory.
  3. If we want to allocate a data chunk, we allocate a new data chunk.

Does anyone have other good idea to fix it?

Thanks
Miao

(The patch that make the bug be triggered easily)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1860fa8..8d4ab87 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7012,6 +7012,12 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 */
 		exclude_super_stripes(root, cache);
 
+		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			ret = add_excluded_extent(root, cache->key.objectid,
+						  cache->key.offset - 4096);
+			BUG_ON(ret);
+		}
+
 		/*
 		 * check for two cases, either we are full, and therefore
 		 * don't need to bother with the caching work since we won't
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..96c0c5e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2357,8 +2357,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
-		max_stripe_size = 1024 * 1024 * 1024;
-		max_chunk_size = 10 * max_stripe_size;
+//		max_stripe_size = 1024 * 1024 * 1024;
+//		max_chunk_size = 10 * max_stripe_size;
+		max_stripe_size = 64 * 1024 * 1024;
+		max_chunk_size = 2 * max_stripe_size;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 		max_stripe_size = 256 * 1024 * 1024;
 		max_chunk_size = max_stripe_size;

