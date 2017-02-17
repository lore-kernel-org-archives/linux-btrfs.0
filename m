Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33213 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934293AbdBQOnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:49 -0500
Received: by mail-wm0-f66.google.com with SMTP id v77so2935047wmv.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:48 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/38] More btrfs_inode cleanups 
Date: Fri, 17 Feb 2017 16:42:51 +0200
Message-Id: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David, 

Here is another round of inode vs btrfs_inode cleanups. This time 
the size of the module is slightly increased: 

   text	   data	    bss	    dec	    hex	filename
 934690	  50443	  18568	1003701	  f50b5	fs/btrfs/btrfs.ko-patched

   text	   data	    bss	    dec	    hex	filename
 933874	  50443	  18568	1002885	  f4d85	fs/btrfs/btrfs.ko-nonpatches

However, the overall BTRFS_I invocations are trimmed down by 18. This 
stats has been acquired by the following command: 
git grep -c BTRFS_I fs/btrfs/ | cut -d':' -f2 | paste -sd+ - | bc 

There are still plenty of functions that could undergo simplification
so I expect further patches to reduce the size of the btrfs module. 


Nikolay Borisov (38):
  btrfs: Make btrfs_log_all_parents take btrfs_inode
  btrfs: Make btrfs_insert_dir_item take btrfs_inode
  btrfs: make btrfs_set_inode_index_count take btrfs_inode
  btrfs: Make btrfs_set_inode_index take btrfs_inode
  btrfs: Make btrfs_i_size_write take btrfs_inode
  btrfs: make btrfs_is_free_space_inode take btrfs_inode
  btrfs: make btrfs_alloc_data_chunk_ondemand take btrfs_inode
  btrfs: Make drop_outstanding_extent take btrfs_inode
  btrfs: Make calc_csum_metadata_size take btrfs_inode
  btrfs: Make btrfs_orphan_reserve_metadata take btrfs_inode
  btrfs: Make btrfs_orphan_release_metadata take btrfs_inode
  btrfs: Make btrfs_delalloc_reserve_metadata take btrfs_inode
  btrfs: ale btrfs_delalloc_release_metadata take btrfs_inode
  btrfs: Make (__)btrfs_add_inode_defrag take btrfs_inode
  btrfs: Make btrfs_requeue_inode_defrag take btrfs_inode
  btrfs: Make btrfs_drop_extent_cache take btrfs_inode
  btrfs: Make hole_mergeable take btrfs_inode
  btrfs: Make fille_holes take btrfs_inode
  btrfs: Make btrfs_mark_extent_written take btrfs_inode
  btrfs: Make btrfs_lookup_ordered_range take btrfs_inode
  btrfs: Make check_can_nocow take btrfs_inode
  btrfs: Make lock_and_cleanup_extent_if_need take btrfs_inode
  btrfs: make free_io_failure take btrfs_inode
  btrfs: make btrfs_print_data_csum_error take btrfs_inode
  btrfs: make check_compressed_csum take btrfs_inode
  btrfs: make repair_io_failure take btrfs_inode
  btrfs: make clean_io_failure take btrfs_inode
  btrfs: make btrfs_free_io_failure_record take btrfs_inode
  btrfs: make btrfs_orphan_del take btrfs_inode
  btrfs: Make btrfs_orphan_add take btrfs_inode
  btrfs: Make check_parent_dirs_for_sync take btrfs_inode
  btrfs: make btrfs_log_inode_parent take btrfs_inode
  btrfs: Make btrfs_extent_item_to_extent_map take btrfs_inode
  btrfs: Make btrfs_clear_bit_hook take btrfs_inode
  btrfs: Make clone_update_extent_map take btrfs_inode
  btrfs: Make check_extent_to_block take btrfs_inode
  btrfs: Make get_extent_t take btrfs_inode
  btrfs: Make btrfs_del_delalloc_inode take btrfs_inode

 fs/btrfs/btrfs_inode.h      |  22 ++--
 fs/btrfs/compression.c      |  10 +-
 fs/btrfs/ctree.h            |  28 ++---
 fs/btrfs/delayed-inode.c    |   2 +-
 fs/btrfs/dir-item.c         |   6 +-
 fs/btrfs/disk-io.c          |   6 +-
 fs/btrfs/extent-tree.c      | 135 +++++++++++-----------
 fs/btrfs/extent_io.c        |  52 ++++-----
 fs/btrfs/extent_io.h        |  15 ++-
 fs/btrfs/file-item.c        |  11 +-
 fs/btrfs/file.c             | 119 ++++++++++---------
 fs/btrfs/free-space-cache.c |   4 +-
 fs/btrfs/inode-map.c        |   2 +-
 fs/btrfs/inode.c            | 275 ++++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c            |  29 +++--
 fs/btrfs/ordered-data.c     |   6 +-
 fs/btrfs/ordered-data.h     |   2 +-
 fs/btrfs/relocation.c       |  14 +--
 fs/btrfs/scrub.c            |  10 +-
 fs/btrfs/transaction.c      |   6 +-
 fs/btrfs/tree-log.c         |  77 ++++++-------
 21 files changed, 408 insertions(+), 423 deletions(-)

-- 
2.7.4

