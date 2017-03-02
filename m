Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55937 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751420AbdCBUUR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Mar 2017 15:20:17 -0500
From: Chris Mason <clm@fb.com>
Subject: [GIT PULL] Btrfs
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <573654bd-d330-0170-f2c4-953fe8011911@fb.com>
Date: Thu, 2 Mar 2017 15:19:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.11 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

Has Btrfs round two.  These are mostly a continuation of Dave Sterba's collection
of cleanups, but Filipe also has some bug fixes and performance improvements.

Nikolay Borisov (42) commits (+611/-579):
    btrfs: Make lock_and_cleanup_extent_if_need take btrfs_inode (+14/-14)
    btrfs: Make btrfs_delalloc_reserve_metadata take btrfs_inode (+39/-38)
    btrfs: Make btrfs_extent_item_to_extent_map take btrfs_inode (+10/-8)
    btrfs: all btrfs_delalloc_release_metadata take btrfs_inode (+22/-19)
    btrfs: make btrfs_inode_resume_unlocked_dio take btrfs_inode (+3/-4)
    btrfs: make btrfs_alloc_data_chunk_ondemand take btrfs_inode (+7/-6)
    btrfs: make btrfs_inode_block_unlocked_dio take btrfs_inode (+3/-3)
    btrfs: Make btrfs_orphan_release_metadata take btrfs_inode (+8/-8)
    btrfs: Make btrfs_orphan_reserve_metadata take btrfs_inode (+7/-7)
    btrfs: Make check_parent_dirs_for_sync take btrfs_inode (+14/-14)
    btrfs: make btrfs_free_io_failure_record take btrfs_inode (+9/-7)
    btrfs: Make btrfs_lookup_ordered_range take btrfs_inode (+19/-18)
    btrfs: Make (__)btrfs_add_inode_defrag take btrfs_inode (+17/-16)
    btrfs: make btrfs_print_data_csum_error take btrfs_inode (+8/-7)
    btrfs: make btrfs_is_free_space_inode take btrfs_inode (+20/-19)
    btrfs: make btrfs_set_inode_index_count take btrfs_inode (+8/-8)
    btrfs: Make btrfs_requeue_inode_defrag take btrfs_inode (+5/-5)
    btrfs: Make clone_update_extent_map take btrfs_inode (+13/-14)
    btrfs: Make btrfs_mark_extent_written take btrfs_inode (+6/-6)
    btrfs: Make btrfs_drop_extent_cache take btrfs_inode (+30/-26)
    btrfs: Make calc_csum_metadata_size take btrfs_inode (+12/-15)
    btrfs: Make drop_outstanding_extent take btrfs_inode (+11/-12)
    btrfs: Make btrfs_del_delalloc_inode take btrfs_inode (+7/-7)
    btrfs: make btrfs_log_inode_parent take btrfs_inode (+24/-26)
    btrfs: Make btrfs_set_inode_index take btrfs_inode (+13/-13)
    btrfs: Make btrfs_clear_bit_hook take btrfs_inode (+25/-21)
    btrfs: Make check_extent_to_block take btrfs_inode (+6/-5)
    btrfs: make check_compressed_csum take btrfs_inode (+4/-5)
    btrfs: Make btrfs_insert_dir_item take btrfs_inode (+7/-7)
    btrfs: Make btrfs_log_all_parents take btrfs_inode (+5/-5)
    btrfs: Make btrfs_i_size_write take btrfs_inode (+18/-19)
    btrfs: make repair_io_failure take btrfs_inode (+12/-11)
    btrfs: Make btrfs_orphan_add take btrfs_inode (+24/-22)
    btrfs: make btrfs_orphan_del take btrfs_inode (+20/-20)
    btrfs: make clean_io_failure take btrfs_inode (+15/-14)
    btrfs: Make btrfs_add_nondir take btrfs_inode (+13/-9)
    btrfs: make free_io_failure take btrfs_inode (+13/-11)
    btrfs: Make check_can_nocow take btrfs_inode (+12/-10)
    btrfs: Make btrfs_add_link take btrfs_inode (+26/-23)
    btrfs: Make get_extent_t take btrfs_inode (+59/-54)
    btrfs: Make hole_mergeable take btrfs_inode (+5/-4)
    btrfs: Make fill_holes take btrfs_inode (+18/-19)

David Sterba (16) commits (+139/-124):
    btrfs: use predefined limits for calculating maximum number of pages for compression (+6/-5)
    btrfs: derive maximum output size in the compression implementation (+9/-14)
    btrfs: merge nr_pages input and output parameter in compress_pages (+11/-15)
    btrfs: merge length input and output parameter in compress_pages (+18/-20)
    btrfs: add dummy callback for readpage_io_failed and drop checks (+10/-3)
    btrfs: do proper error handling in btrfs_insert_xattr_item (+2/-1)
    btrfs: drop checks for mandatory extent_io_ops callbacks (+3/-4)
    btrfs: constify device path passed to relevant helpers (+22/-18)
    btrfs: document existence of extent_io ops callbacks (+26/-11)
    btrfs: handle allocation error in update_dev_stat_item (+2/-1)
    btrfs: export compression buffer limits in a header (+15/-10)
    btrfs: constify name of subvolume in creation helpers (+3/-3)
    btrfs: constify buffers used by compression helpers (+3/-3)
    btrfs: remove BUG_ON from __tree_mod_log_insert (+0/-2)
    btrfs: constify input buffer of btrfs_csum_data (+3/-3)
    btrfs: let writepage_end_io_hook return void (+6/-11)

Filipe Manana (8) commits (+163/-27):
    Btrfs: do not create explicit holes when replaying log tree if NO_HOLES enabled (+5/-0)
    Btrfs: try harder to migrate items to left sibling before splitting a leaf (+7/-0)
    Btrfs: fix assertion failure when freeing block groups at close_ctree() (+9/-6)
    Btrfs: incremental send, fix unnecessary hole writes for sparse files (+86/-2)
    Btrfs: fix use-after-free due to wrong order of destroying work queues (+7/-2)
    Btrfs: incremental send, do not delay rename when parent inode is new (+16/-3)
    Btrfs: fix data loss after truncate when using the no-holes feature (+6/-13)
    Btrfs: bulk delete checksum items in the same leaf (+27/-1)

Robbie Ko (3) commits (+25/-3):
    Btrfs: send, fix failure to rename top level inode due to name collision (+4/-1)
    Btrfs: incremental send, do not issue invalid rmdir operations (+13/-0)
    Btrfs: fix leak of subvolume writers counter (+8/-2)

Total: (69) commits (+938/-733)

 fs/btrfs/btrfs_inode.h       |  31 ++-
 fs/btrfs/compression.c       |  43 ++---
 fs/btrfs/compression.h       |  30 ++-
 fs/btrfs/ctree.c             |   9 +-
 fs/btrfs/ctree.h             |  39 ++--
 fs/btrfs/delayed-inode.c     |   2 +-
 fs/btrfs/dev-replace.c       |   5 +-
 fs/btrfs/dev-replace.h       |   5 +-
 fs/btrfs/dir-item.c          |   9 +-
 fs/btrfs/disk-io.c           |  32 ++--
 fs/btrfs/disk-io.h           |   2 +-
 fs/btrfs/extent-tree.c       | 144 +++++++-------
 fs/btrfs/extent_io.c         |  75 ++++----
 fs/btrfs/extent_io.h         |  50 +++--
 fs/btrfs/file-item.c         |  40 +++-
 fs/btrfs/file.c              | 139 +++++++-------
 fs/btrfs/free-space-cache.c  |   5 +-
 fs/btrfs/inode-map.c         |   2 +-
 fs/btrfs/inode.c             | 445 ++++++++++++++++++++++---------------------
 fs/btrfs/ioctl.c             |  38 ++--
 fs/btrfs/lzo.c               |  12 +-
 fs/btrfs/ordered-data.c      |   9 +-
 fs/btrfs/ordered-data.h      |   7 +-
 fs/btrfs/relocation.c        |  17 +-
 fs/btrfs/scrub.c             |  11 +-
 fs/btrfs/send.c              | 125 +++++++++++-
 fs/btrfs/tests/inode-tests.c |  46 ++---
 fs/btrfs/transaction.c       |   6 +-
 fs/btrfs/tree-log.c          |  97 +++++-----
 fs/btrfs/volumes.c           |  21 +-
 fs/btrfs/volumes.h           |  12 +-
 fs/btrfs/zlib.c              |   9 +-
 32 files changed, 861 insertions(+), 656 deletions(-)
