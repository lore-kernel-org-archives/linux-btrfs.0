From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: mask out gfp flasg in releasepage
Date: Thu, 26 Jan 2012 18:33:02 +0100
Message-ID: <1327599182-889-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btree_releasepage is a callback and can be passed unknown gfp flags and then
they may end up in kmem_cache_alloc called from alloc_extent_state, slab
allocator will BUG_ON when there is HIGHMEM or DMA32 flag set.

This may happen when btrfs is mounted from a loop device, which masks out
__GFP_IO flag. The check in try_release_extent_state

3399                 if ((mask & GFP_NOFS) == GFP_NOFS)
3400                         mask = GFP_NOFS;

will not work and passes unfiltered flags further resulting in crash at
mm/slab.c:2963

 [<000000000024ae4c>] cache_alloc_refill+0x3b4/0x5c8
 [<000000000024c810>] kmem_cache_alloc+0x204/0x294
 [<00000000001fd3c2>] mempool_alloc+0x52/0x170
 [<000003c000ced0b0>] alloc_extent_state+0x40/0xd4 [btrfs]
 [<000003c000cee5ae>] __clear_extent_bit+0x38a/0x4cc [btrfs]
 [<000003c000cee78c>] try_release_extent_state+0x9c/0xd4 [btrfs]
 [<000003c000cc4c66>] btree_releasepage+0x7e/0xd0 [btrfs]
 [<0000000000210d84>] shrink_page_list+0x6a0/0x724
 [<0000000000211394>] shrink_inactive_list+0x230/0x578
 [<0000000000211bb8>] shrink_list+0x6c/0x120
 [<0000000000211e4e>] shrink_zone+0x1e2/0x228
 [<0000000000211f24>] shrink_zones+0x90/0x254
 [<0000000000213410>] do_try_to_free_pages+0xac/0x420
 [<0000000000213ae0>] try_to_free_pages+0x13c/0x1b0
 [<0000000000204e6c>] __alloc_pages_nodemask+0x5b4/0x9a8
 [<00000000001fb04a>] grab_cache_page_write_begin+0x7e/0xe8

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index da4457f..4c86711 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -961,6 +961,13 @@ static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	map = &BTRFS_I(page->mapping->host)->extent_tree;
 
+	/*
+	 * We need to mask out eg. __GFP_HIGHMEM and __GFP_DMA32 as we're doing
+	 * slab allocation from alloc_extent_state down the callchain where
+	 * it'd hit a BUG_ON as those flags are not allowed.
+	 */
+	gfp_flags &= ~GFP_SLAB_BUG_MASK;
+
 	ret = try_release_extent_state(map, tree, page, gfp_flags);
 	if (!ret)
 		return 0;
-- 
1.7.8

