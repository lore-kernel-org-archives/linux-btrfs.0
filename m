Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56041 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751448AbcLPRwH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 12:52:07 -0500
Date: Fri, 16 Dec 2016 12:01:57 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20161216170157.jbgeb7ed3scmqq6v@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.10 branch has our merge window fun:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.10

There is a trivial conflict with your current git, my resolution is
here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.10-merged

Jeff Mahoney and Dave Sterba have a really nice set of cleanups in here,
and Christoph pitched in corrections/improvements to make btrfs use
proper helpers for bio walking instead of doing it by hand.

There are some key fixes as well, including some long standing bugs that
took forever to track down in btrfs_drop_extents and during balance.

-chris

Jeff Mahoney (22) commits (+4537/-4467):
    btrfs: call functions that always use the same root with fs_info instead (+115/-102)
    btrfs: split btrfs_wait_marked_extents into normal and tree log functions (+58/-40)
    btrfs: take an fs_info directly when the root is not used otherwise (+1119/-1243)
    btrfs: increment ctx->pos for every emitted or skipped dirent in readdir (+4/-23)
    btrfs: call functions that overwrite their root parameter with fs_info (+52/-60)
    btrfs: Ensure proper sector alignment for btrfs_free_reserved_data_space (+7/-0)
    btrfs: remove old tree_root dirent processing in btrfs_real_readdir() (+37/-80)
    btrfs: root->fs_info cleanup, btrfs_calc_{trans,trunc}_metadata_size (+37/-32)
    btrfs: remove root parameter from transaction commit/end routines (+188/-211)
    btrfs: root->fs_info cleanup, access fs_info->delayed_root directly (+13/-24)
    btrfs: root->fs_info cleanup, add fs_info convenience variables (+2251/-2016)
    btrfs: pull node/sector/stripe sizes out of root and into fs_info (+432/-414)
    btrfs: alloc_reserved_file_extent trace point should use extent_root (+2/-1)
    btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere (+68/-70)
    btrfs: root->fs_info cleanup, update_block_group{,flags} (+14/-14)
    btrfs: struct reada_control.root -> reada_control.fs_info (+8/-7)
    btrfs: btrfs_init_new_device should use fs_info->dev_root (+4/-3)
    btrfs: struct btrfsic_state->root should be an fs_info (+10/-10)
    btrfs: convert extent-tree tracepoints to use fs_info (+30/-36)
    btrfs: root->fs_info cleanup, lock/unlock_chunks (+47/-47)
    btrfs: simplify btrfs_wait_cache_io prototype (+34/-27)
    btrfs: root->fs_info cleanup, io_ctl_init (+7/-7)

David Sterba (17) commits (+166/-168):
    btrfs: store and load values of stripes_min/stripes_max in balance status item (+4/-0)
    btrfs: remove constant parameter to memset_extent_buffer and rename it (+21/-21)
    btrfs: use specialized page copying helpers in btrfs_clone_extent_buffer (+1/-1)
    btrfs: reada, cleanup remove unneeded variable in __readahead_hook (+1/-5)
    btrfs: reada, remove unused parameter from __readahead_hook (+4/-4)
    btrfs: rename helper macros for qgroup and aux data casts (+21/-14)
    btrfs: reada, remove pointless BUG_ON in reada_find_extent (+0/-1)
    btrfs: reada, sink start parameter to btree_readahead_hook (+5/-9)
    btrfs: reada, remove pointless BUG_ON check for fs_info (+0/-1)
    btrfs: remove trivial helper btrfs_find_tree_block (+7/-15)
    btrfs: opencode chunk locking, remove helpers (+43/-53)
    btrfs: introduce helpers for updating eb uuids (+24/-0)
    btrfs: add optimized version of eb to eb copy (+18/-2)
    btrfs: remove stale comment from btrfs_statfs (+0/-4)
    btrfs: use new helpers to set uuids in eb (+17/-34)
    btrfs: delete unused member from superblock (+0/-1)
    btrfs: remove unused headers, statfs.h (+0/-3)

Christoph Hellwig (9) commits (+176/-233):
    btrfs: refactor __btrfs_lookup_bio_sums to use bio_for_each_segment_all (+11/-21)
    btrfs: use bio_for_each_segment_all in __btrfsic_submit_bio (+11/-19)
    btrfs: don't access the bio directly in btrfs_csum_one_bio (+10/-11)
    btrfs: don't access the bio directly in the direct I/O code (+3/-4)
    btrfs: use bio iterators for the decompression handlers (+55/-112)
    btrfs: don't access the bio directly in the raid5/6 code (+6/-10)
    btrfs: don't abuse REQ_OP_* flags for btrfs_map_block (+70/-49)
    btrfs: calculate end of bio offset properly (+8/-2)
    btrfs: use bi_size (+2/-5)

Filipe Manana (5) commits (+25/-33):
    Btrfs: fix emptiness check for dirtied extent buffers at check_leaf() (+12/-1)
    Btrfs: remove unused code when creating and merging reloc trees (+0/-19)
    Btrfs: remove rb_node field from the delayed ref node structure (+0/-6)
    Btrfs: fix relocation incorrectly dropping data references (+12/-3)
    Btrfs: fix qgroup rescan worker initialization (+1/-4)

Qu Wenruo (4) commits (+308/-330):
    btrfs: qgroup: Rename functions to make it follow reserve,trace,account steps (+18/-17)
    btrfs: Export and move leaf/subtree qgroup helpers to qgroup.c (+240/-217)
    btrfs: qgroup: Fix qgroup data leaking by using subtree tracing (+23/-96)
    btrfs: qgroup: Add comments explaining how btrfs qgroup works (+28/-0)

Robbie Ko (3) commits (+5/-6):
    Btrfs: fix tree search logic when replaying directory entry deletes (+1/-2)
    Btrfs: fix deadlock caused by fsync when logging directory entries (+2/-2)
    Btrfs: fix enospc in hole punching (+2/-2)

Wang Xiaoguang (3) commits (+42/-7):
    btrfs: cleanup: use already calculated value in btrfs_should_throttle_delayed_refs() (+1/-1)
    btrfs: add necessary comments about tickets_id (+4/-0)
    btrfs: improve delayed refs iterations (+37/-6)

Liu Bo (2) commits (+12/-6):
    Btrfs: adjust len of writes if following a preallocated extent (+5/-3)
    Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty (+7/-3)

Chris Mason (2) commits (+11/-8):
    Revert "Btrfs: adjust len of writes if following a preallocated extent" (+3/-5)
    Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors (+8/-3)

Josef Bacik (2) commits (+29/-5):
    Btrfs: abort transaction if fill_holes() fails (+17/-2)
    Btrfs: fix file extent corruption (+12/-3)

Omar Sandoval (1) commits (+3/-3):
    Btrfs: deal with existing encompassing extent map in btrfs_get_extent()

Maxim Patlasov (1) commits (+19/-2):
    btrfs: limit async_work allocation and worker func duration

Xiaoguang Wang (1) commits (+3/-10):
    btrfs: remove useless comments

Adam Borowski (1) commits (+40/-3):
    btrfs: make block group flags in balance printks human-readable

Nick Terrell (1) commits (+1/-0):
    btrfs: Call kunmap if zlib_inflateInit2 fails

Christophe JAILLET (1) commits (+0/-2):
    btrfs: remove redundant check of btrfs_iget return value

Domagoj Tršan (1) commits (+6/-6):
    btrfs: change btrfs_csum_final result param type to u8

Shailendra Verma (1) commits (+6/-15):
    btrfs: return early from failed memory allocations in ioctl handlers

Total: (77) commits (+5389/-5304)

 fs/btrfs/async-thread.c                |   14 +
 fs/btrfs/async-thread.h                |    1 +
 fs/btrfs/backref.c                     |   10 +-
 fs/btrfs/check-integrity.c             |  103 +--
 fs/btrfs/check-integrity.h             |    5 +-
 fs/btrfs/compression.c                 |  196 ++--
 fs/btrfs/compression.h                 |   12 +-
 fs/btrfs/ctree.c                       |  495 +++++-----
 fs/btrfs/ctree.h                       |  241 ++---
 fs/btrfs/delayed-inode.c               |  147 ++-
 fs/btrfs/delayed-inode.h               |   21 +-
 fs/btrfs/delayed-ref.c                 |   20 +-
 fs/btrfs/delayed-ref.h                 |   14 +-
 fs/btrfs/dev-replace.c                 |   68 +-
 fs/btrfs/dev-replace.h                 |    4 +-
 fs/btrfs/dir-item.c                    |   45 +-
 fs/btrfs/disk-io.c                     |  595 ++++++------
 fs/btrfs/disk-io.h                     |   34 +-
 fs/btrfs/export.c                      |   10 +-
 fs/btrfs/extent-tree.c                 | 1551 ++++++++++++++------------------
 fs/btrfs/extent_io.c                   |  112 ++-
 fs/btrfs/extent_io.h                   |   17 +-
 fs/btrfs/file-item.c                   |  207 ++---
 fs/btrfs/file.c                        |  249 ++---
 fs/btrfs/free-space-cache.c            |  164 ++--
 fs/btrfs/free-space-cache.h            |   12 +-
 fs/btrfs/free-space-tree.c             |   44 +-
 fs/btrfs/inode-item.c                  |   11 +-
 fs/btrfs/inode-map.c                   |   22 +-
 fs/btrfs/inode.c                       |  910 +++++++++----------
 fs/btrfs/ioctl.c                       |  603 +++++++------
 fs/btrfs/lzo.c                         |   17 +-
 fs/btrfs/ordered-data.c                |   38 +-
 fs/btrfs/ordered-data.h                |    4 +-
 fs/btrfs/print-tree.c                  |   19 +-
 fs/btrfs/print-tree.h                  |    4 +-
 fs/btrfs/props.c                       |    5 +-
 fs/btrfs/qgroup.c                      |  299 +++++-
 fs/btrfs/qgroup.h                      |   64 +-
 fs/btrfs/raid56.c                      |   78 +-
 fs/btrfs/raid56.h                      |    8 +-
 fs/btrfs/reada.c                       |   62 +-
 fs/btrfs/relocation.c                  |  453 +++++-----
 fs/btrfs/root-tree.c                   |   28 +-
 fs/btrfs/scrub.c                       |  181 ++--
 fs/btrfs/send.c                        |   33 +-
 fs/btrfs/super.c                       |  138 ++-
 fs/btrfs/tests/btrfs-tests.c           |   13 +-
 fs/btrfs/tests/btrfs-tests.h           |    4 +-
 fs/btrfs/tests/extent-buffer-tests.c   |    7 +-
 fs/btrfs/tests/extent-io-tests.c       |    7 +-
 fs/btrfs/tests/free-space-tests.c      |   18 +-
 fs/btrfs/tests/free-space-tree-tests.c |    9 +-
 fs/btrfs/tests/inode-tests.c           |   16 +-
 fs/btrfs/tests/qgroup-tests.c          |   11 +-
 fs/btrfs/transaction.c                 |  615 +++++++------
 fs/btrfs/transaction.h                 |   29 +-
 fs/btrfs/tree-log.c                    |  202 +++--
 fs/btrfs/uuid-tree.c                   |   23 +-
 fs/btrfs/volumes.c                     |  845 +++++++++--------
 fs/btrfs/volumes.h                     |   70 +-
 fs/btrfs/xattr.c                       |   21 +-
 fs/btrfs/zlib.c                        |   16 +-
 include/trace/events/btrfs.h           |   67 +-
 64 files changed, 4713 insertions(+), 4628 deletions(-)
