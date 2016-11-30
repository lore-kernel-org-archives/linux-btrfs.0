Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47913 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752557AbcK3NLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 08:11:17 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs updates for 4.10
Date: Wed, 30 Nov 2016 14:11:09 +0100
Message-Id: <cover.1480511073.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here's my first pull request for 4.10. Assorted patches that have been in
for-next, mostly fixes and some cleanups. I'm expecting to send one more before
the rc1, I don't see much reason to hold the current queue back for any longer.

----------------------------------------------------------------
The following changes since commit e5517c2a5a49ed5e99047008629f1cd60246ea0e:

  Linux 4.9-rc7 (2016-11-27 13:08:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.10

for you to fetch changes up to 515bdc479097ec9d5f389202842345af3162f71c:

  Merge branch 'misc-4.10' into for-chris-4.10-20161130 (2016-11-30 14:02:20 +0100)

----------------------------------------------------------------
Adam Borowski (1):
      btrfs: make block group flags in balance printks human-readable

Christoph Hellwig (9):
      btrfs: don't abuse REQ_OP_* flags for btrfs_map_block
      btrfs: use bio iterators for the decompression handlers
      btrfs: don't access the bio directly in the raid5/6 code
      btrfs: don't access the bio directly in the direct I/O code
      btrfs: don't access the bio directly in btrfs_csum_one_bio
      btrfs: use bi_size
      btrfs: calculate end of bio offset properly
      btrfs: refactor __btrfs_lookup_bio_sums to use bio_for_each_segment_all
      btrfs: use bio_for_each_segment_all in __btrfsic_submit_bio

Christophe JAILLET (1):
      btrfs: remove redundant check of btrfs_iget return value

David Sterba (17):
      btrfs: remove unused headers, statfs.h
      btrfs: remove stale comment from btrfs_statfs
      btrfs: rename helper macros for qgroup and aux data casts
      btrfs: reada, cleanup remove unneeded variable in __readahead_hook
      btrfs: reada, remove unused parameter from __readahead_hook
      btrfs: reada, sink start parameter to btree_readahead_hook
      btrfs: reada, remove pointless BUG_ON in reada_find_extent
      btrfs: reada, remove pointless BUG_ON check for fs_info
      btrfs: remove trivial helper btrfs_find_tree_block
      btrfs: delete unused member from superblock
      btrfs: introduce helpers for updating eb uuids
      btrfs: use new helpers to set uuids in eb
      btrfs: use specialized page copying helpers in btrfs_clone_extent_buffer
      btrfs: remove constant parameter to memset_extent_buffer and rename it
      btrfs: add optimized version of eb to eb copy
      btrfs: store and load values of stripes_min/stripes_max in balance status item
      Merge branch 'misc-4.10' into for-chris-4.10-20161130

Domagoj Tršan (1):
      btrfs: change btrfs_csum_final result param type to u8

Jeff Mahoney (3):
      btrfs: remove old tree_root dirent processing in btrfs_real_readdir()
      btrfs: increment ctx->pos for every emitted or skipped dirent in readdir
      btrfs: Ensure proper sector alignment for btrfs_free_reserved_data_space

Josef Bacik (2):
      Btrfs: fix file extent corruption
      Btrfs: abort transaction if fill_holes() fails

Liu Bo (1):
      Btrfs: adjust len of writes if following a preallocated extent

Nick Terrell (1):
      btrfs: Call kunmap if zlib_inflateInit2 fails

Omar Sandoval (1):
      Btrfs: deal with existing encompassing extent map in btrfs_get_extent()

Qu Wenruo (4):
      btrfs: qgroup: Add comments explaining how btrfs qgroup works
      btrfs: qgroup: Rename functions to make it follow reserve,trace,account steps
      btrfs: Export and move leaf/subtree qgroup helpers to qgroup.c
      btrfs: qgroup: Fix qgroup data leaking by using subtree tracing

Shailendra Verma (1):
      btrfs: return early from failed memory allocations in ioctl handlers

Wang Xiaoguang (3):
      btrfs: cleanup: use already calculated value in btrfs_should_throttle_delayed_refs()
      btrfs: add necessary comments about tickets_id
      btrfs: improve delayed refs iterations

Xiaoguang Wang (1):
      btrfs: remove useless comments

 fs/btrfs/check-integrity.c       |  32 ++---
 fs/btrfs/compression.c           | 142 ++++++++-------------
 fs/btrfs/compression.h           |  12 +-
 fs/btrfs/ctree.c                 |  49 +++-----
 fs/btrfs/ctree.h                 |  14 ++-
 fs/btrfs/delayed-inode.c         |   3 +-
 fs/btrfs/delayed-inode.h         |   2 +-
 fs/btrfs/delayed-ref.c           |  20 ++-
 fs/btrfs/delayed-ref.h           |   8 ++
 fs/btrfs/disk-io.c               |  30 ++---
 fs/btrfs/disk-io.h               |   4 +-
 fs/btrfs/extent-tree.c           | 263 ++++-----------------------------------
 fs/btrfs/extent_io.c             |  49 ++++++--
 fs/btrfs/extent_io.h             |   9 +-
 fs/btrfs/file-item.c             |  55 ++++----
 fs/btrfs/file.c                  |  35 +++++-
 fs/btrfs/free-space-cache.c      |  10 +-
 fs/btrfs/inode.c                 | 163 ++++++++----------------
 fs/btrfs/ioctl.c                 |  32 ++---
 fs/btrfs/lzo.c                   |  17 +--
 fs/btrfs/qgroup.c                | 256 ++++++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.h                |  64 +++++++++-
 fs/btrfs/raid56.c                |  16 +--
 fs/btrfs/reada.c                 |  28 ++---
 fs/btrfs/relocation.c            | 164 ++++++++++--------------
 fs/btrfs/scrub.c                 |  17 +--
 fs/btrfs/super.c                 |   4 -
 fs/btrfs/tests/extent-io-tests.c |   2 +-
 fs/btrfs/tree-log.c              |   2 +-
 fs/btrfs/volumes.c               |  64 +++++-----
 fs/btrfs/volumes.h               |  25 +++-
 fs/btrfs/zlib.c                  |  16 +--
 include/trace/events/btrfs.h     |   2 +-
 33 files changed, 782 insertions(+), 827 deletions(-)
