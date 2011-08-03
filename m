From: Simon Kirby <sim@hostway.ca>
Subject: Hot rb_next, setup_cluster_no_bitmap
Date: Wed, 3 Aug 2011 15:06:55 -0700
Message-ID: <20110803220655.GE20966@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Since upgrading from 2.6.35+bits to 2.6.38 and then more recently to 3.0,
our "big btrfs backup box" with 20 * 3 TB AOE-attached btrfs volumes
started showing more CPU usage and backups were no longer completing in a
day. I tried Linus HEAD from yesterday merged with btrfs for-linus (same
as Linus HEAD as of today), and things are better again, but "perf top"
output still looks pretty interesting after a night of rsync running:

     samples  pcnt function                           DSO
     _______ _____ __________________________________ ______________

    13537.00 59.2% rb_next                            [kernel]
     3539.00 15.5% _raw_spin_lock                     [kernel]
     1668.00  7.3% setup_cluster_no_bitmap            [kernel]
      799.00  3.5% tree_search_offset                 [kernel]
      476.00  2.1% fill_window                        [kernel]
      370.00  1.6% find_free_extent                   [kernel]
      238.00  1.0% longest_match                      [kernel]
      128.00  0.6% build_tree                         [kernel]
       95.00  0.4% pqdownheap                         [kernel]
       79.00  0.3% chksum_update                      [kernel]
       72.00  0.3% btrfs_find_space_cluster           [kernel]
       65.00  0.3% deflate_fast                       [kernel]
       61.00  0.3% memcpy                             [kernel]

With call-graphs enabled:

-     50.24%  btrfs-transacti  [kernel.kallsyms]  [k] rb_next
   - rb_next
      - 97.36% setup_cluster_no_bitmap
           btrfs_find_space_cluster
           find_free_extent
           btrfs_reserve_extent
           btrfs_alloc_free_block
           __btrfs_cow_block
         + btrfs_cow_block
      - 2.29% btrfs_find_space_cluster
           find_free_extent
           btrfs_reserve_extent
           btrfs_alloc_free_block
           __btrfs_cow_block
           btrfs_cow_block
         - btrfs_search_slot
            - 56.96% lookup_inline_extent_backref
               - 97.23% __btrfs_free_extent
                    run_clustered_refs
                  - btrfs_run_delayed_refs
                     - 91.23% btrfs_commit_transaction
                          transaction_kthread
                          kthread
                          kernel_thread_helper
                     - 8.77% btrfs_write_dirty_block_groups
                          commit_cowonly_roots
                          btrfs_commit_transaction
                          transaction_kthread
                          kthread
                          kernel_thread_helper
               - 2.77% insert_inline_extent_backref
                    __btrfs_inc_extent_ref
                    run_clustered_refs
                    btrfs_run_delayed_refs
                    btrfs_commit_transaction
                    transaction_kthread
                    kthread
                    kernel_thread_helper
            - 41.03% btrfs_insert_empty_items
               - 99.89% run_clustered_refs
                  - btrfs_run_delayed_refs
                     + 89.93% btrfs_commit_transaction
                     + 10.07% btrfs_write_dirty_block_groups
            + 1.87% btrfs_write_dirty_block_groups
-      7.41%  btrfs-transacti  [kernel.kallsyms]  [k] setup_cluster_no_bitmap
   + setup_cluster_no_bitmap
+      4.34%            rsync  [kernel.kallsyms]  [k] _raw_spin_lock
+      3.68%            rsync  [kernel.kallsyms]  [k] rb_next
+      3.09%  btrfs-transacti  [kernel.kallsyms]  [k] tree_search_offset
+      1.40%  btrfs-delalloc-  [kernel.kallsyms]  [k] fill_window
+      1.31%  btrfs-transacti  [kernel.kallsyms]  [k] _raw_spin_lock
+      1.19%  btrfs-delalloc-  [kernel.kallsyms]  [k] longest_match
+      1.18%  btrfs-delalloc-  [kernel.kallsyms]  [k] deflate_fast
+      1.09%  btrfs-transacti  [kernel.kallsyms]  [k] find_free_extent
+      0.90%  btrfs-delalloc-  [kernel.kallsyms]  [k] pqdownheap
+      0.67%  btrfs-delalloc-  [kernel.kallsyms]  [k] compress_block
+      0.66%  btrfs-delalloc-  [kernel.kallsyms]  [k] build_tree
+      0.61%            rsync  [kernel.kallsyms]  [k] page_fault

rb_next() from setup_cluster_no_bitmap() is very hot. From the
annotated assembly output, it looks like the "while (window_free <=
min_bytes)" loop is where the CPU is spending most of the time.

A few thoughts:

Shouldn't (window_free <= min_bytes) be (window_free < min_bytes)?

I'm not really up to speed with SMP memory caching behaviour, but I'm
thinking the constant list creation of bitmap entries from the shared
free_space_cache objects might be helping bounce around these pages
between CPUs, which is why instructions that deference the object
pointers always seem to be cache misses...Or there's just too much of
this stuff in memory for it to fit in cache. Top of slabtop -sc:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
1760061 1706286 96%   0.97K  53351       33   1707232K nfs_inode_cache
1623423 1617242 99%   0.95K  49279       33   1576928K btrfs_inode_cache
788998  676959  85%   0.55K  28204       28    451264K radix_tree_node
1379889 1344544 97%   0.19K  65709       21    262836K dentry
1399100 1248587 89%   0.16K  55964       25    223856K extent_buffers
1077876 1007921 93%   0.11K  29941       36    119764K journal_head

This is all per-blockgroup, but I don't know how many blockgroups the
thing keeps looking at. There are 20 mounted volumes, as I mentioned.
16 GB of memory, and 4 apparent cores (dual HT Xeon).

The calculation for comparison with max_gap and entry->offset -
window_start > (min_bytes * 2) are also the hot parts of the loop, but
this is not much compared to the initial deference within rb_next() that
pretty much always looks to be a cache miss. It would seem that not
walking so much would be worthwhile, if possible.

So, are all of the gap avoidance and stuff really necessary? I presume
this is to try to avoid fragmentation. Would it make sense to leave some
kind of pointer hanging around pointing to the last useful offset, or
something? (eg: make the block group checking circular instead of walking
the whole thing.) I'm just stabbing in the dark without more counters to
see what's really going on here.

I see Josef's 86d4a77ba3dc4ace238a0556541a41df2bd71d49 introduced the
bitmaps list. I could try temporarily reverting this (some fixups needed)
if anybody thinks my cache bouncing idea might be slightly possible.

Cheers!

Simon-
