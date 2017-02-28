Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdB1PKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 10:10:42 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs cleanups for 4.11, part 2
Date: Tue, 28 Feb 2017 16:09:57 +0100
Message-Id: <cover.1488289094.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is the second half of the 4.11 batch, the rest of the cleanups. Please
pull, thanks.

The following changes since commit 6288d6eabc7505f42dda34a2c2962f91914be3a4:

  Btrfs: use the correct type when creating cow dio extent (2017-02-22 15:55:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-part2

for you to fetch changes up to 20a7db8ab3f2057a518448b1728d504ffadef65e:

  btrfs: add dummy callback for readpage_io_failed and drop checks (2017-02-28 14:29:24 +0100)

----------------------------------------------------------------
David Sterba (16):
      btrfs: constify device path passed to relevant helpers
      btrfs: constify input buffer of btrfs_csum_data
      btrfs: constify buffers used by compression helpers
      btrfs: constify name of subvolume in creation helpers
      btrfs: merge length input and output parameter in compress_pages
      btrfs: merge nr_pages input and output parameter in compress_pages
      btrfs: export compression buffer limits in a header
      btrfs: use predefined limits for calculating maximum number of pages for compression
      btrfs: derive maximum output size in the compression implementation
      btrfs: remove BUG_ON from __tree_mod_log_insert
      btrfs: handle allocation error in update_dev_stat_item
      btrfs: do proper error handling in btrfs_insert_xattr_item
      btrfs: let writepage_end_io_hook return void
      btrfs: document existence of extent_io ops callbacks
      btrfs: drop checks for mandatory extent_io_ops callbacks
      btrfs: add dummy callback for readpage_io_failed and drop checks

Nikolay Borisov (42):
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
      btrfs: all btrfs_delalloc_release_metadata take btrfs_inode
      btrfs: Make (__)btrfs_add_inode_defrag take btrfs_inode
      btrfs: Make btrfs_requeue_inode_defrag take btrfs_inode
      btrfs: Make btrfs_drop_extent_cache take btrfs_inode
      btrfs: Make hole_mergeable take btrfs_inode
      btrfs: Make fill_holes take btrfs_inode
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
      btrfs: Make btrfs_add_link take btrfs_inode
      btrfs: Make btrfs_add_nondir take btrfs_inode
      btrfs: make btrfs_inode_block_unlocked_dio take btrfs_inode
      btrfs: make btrfs_inode_resume_unlocked_dio take btrfs_inode

 fs/btrfs/btrfs_inode.h       |  31 ++--
 fs/btrfs/compression.c       |  43 ++---
 fs/btrfs/compression.h       |  30 ++--
 fs/btrfs/ctree.c             |   2 -
 fs/btrfs/ctree.h             |  39 ++--
 fs/btrfs/delayed-inode.c     |   2 +-
 fs/btrfs/dev-replace.c       |   5 +-
 fs/btrfs/dev-replace.h       |   5 +-
 fs/btrfs/dir-item.c          |   9 +-
 fs/btrfs/disk-io.c           |  17 +-
 fs/btrfs/disk-io.h           |   2 +-
 fs/btrfs/extent-tree.c       | 135 +++++++-------
 fs/btrfs/extent_io.c         |  75 ++++----
 fs/btrfs/extent_io.h         |  50 ++++--
 fs/btrfs/file-item.c         |  12 +-
 fs/btrfs/file.c              | 139 ++++++++-------
 fs/btrfs/free-space-cache.c  |   5 +-
 fs/btrfs/inode-map.c         |   2 +-
 fs/btrfs/inode.c             | 416 ++++++++++++++++++++++---------------------
 fs/btrfs/ioctl.c             |  38 ++--
 fs/btrfs/lzo.c               |  12 +-
 fs/btrfs/ordered-data.c      |   9 +-
 fs/btrfs/ordered-data.h      |   7 +-
 fs/btrfs/relocation.c        |  17 +-
 fs/btrfs/scrub.c             |  11 +-
 fs/btrfs/tests/inode-tests.c |  46 ++---
 fs/btrfs/transaction.c       |   6 +-
 fs/btrfs/tree-log.c          |  92 +++++-----
 fs/btrfs/volumes.c           |  21 ++-
 fs/btrfs/volumes.h           |  12 +-
 fs/btrfs/zlib.c              |   9 +-
 31 files changed, 673 insertions(+), 626 deletions(-)
