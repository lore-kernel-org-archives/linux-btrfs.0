Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbcI2Lgt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 07:36:49 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs, for 4.9, part 1
Date: Thu, 29 Sep 2016 13:36:46 +0200
Message-Id: <cover.1475148294.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm sending the first batch for 4.9, mostly fixes, stability improvements and
cleanups. There might be a second pull if the patches get reviewed, anything
space handling related or qgroups.
Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 08895a8b6b06ed2323cd97a36ee40a116b3db8ed:

  Linux 4.8-rc8 (2016-09-25 18:47:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-4.9

for you to fetch changes up to 196e02490c934398f894e5cb0ee1ac8ad13ca576:

  Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf (2016-09-26 19:50:44 +0200)

----------------------------------------------------------------
Anand Jain (1):
      btrfs: fix a possible umount deadlock

Arnd Bergmann (1):
      btrfs: fix btrfs_no_printk stub helper

David Sterba (1):
      btrfs: create example debugfs file only in debugging build

Eric Sandeen (1):
      btrfs: fix perms on demonstration debugfs interface

Goldwyn Rodrigues (3):
      btrfs: Do not reassign count in btrfs_run_delayed_refs
      btrfs: Remove already completed TODO comment
      btrfs: parent_start initialization cleanup

Jeff Mahoney (7):
      btrfs: add dynamic debug support
      btrfs: clean the old superblocks before freeing the device
      btrfs: unsplit printed strings
      btrfs: convert printk(KERN_* to use pr_* calls
      btrfs: convert pr_* to btrfs_* where possible
      btrfs: convert send's verbose_printk to btrfs_debug
      btrfs: btrfs_debug should consume fs_info when DEBUG is not defined

Josef Bacik (5):
      Btrfs: add a flags field to btrfs_fs_info
      Btrfs: kill the start argument to read_extent_buffer_pages
      Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written
      Btrfs: don't leak reloc root nodes on error
      Btrfs: don't BUG() during drop snapshot

Liu Bo (13):
      Btrfs: fix memory leak of block group cache
      Btrfs: remove BUG() in raid56
      Btrfs: fix memory leak in reading btree blocks
      Btrfs: bail out if block group has different mixed flag
      Btrfs: return gracefully from balance if fs tree is corrupted
      Btrfs: memset to avoid stale content in btree node block
      Btrfs: remove BUG_ON in start_transaction
      Btrfs: add error handling for extent buffer in print tree
      Btrfs: improve check_node to avoid reading corrupted nodes
      Btrfs: kill BUG_ON in run_delayed_tree_ref
      Btrfs: fix memory leak in do_walk_down
      Btrfs: memset to avoid stale content in btree leaf
      Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf

Lu Fengqi (1):
      btrfs: fix check_shared for fiemap ioctl

Luis Henriques (2):
      btrfs: Fix warning "variable ‘blocksize’ set but not used"
      btrfs: Fix warning "variable ‘gen’ set but not used"

Masahiro Yamada (1):
      btrfs: squash lines for simple wrapper functions

Naohiro Aota (1):
      btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs

Qu Wenruo (1):
      btrfs: extend btrfs_set_extent_delalloc and its friends to support in-band dedupe and subpage size patchset

 fs/btrfs/backref.c            | 409 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/btrfs_inode.h        |  11 --
 fs/btrfs/check-integrity.c    | 342 +++++++++++------------------------
 fs/btrfs/compression.c        |   6 +-
 fs/btrfs/ctree.c              |  56 ++----
 fs/btrfs/ctree.h              | 116 ++++++++----
 fs/btrfs/delayed-inode.c      |  25 ++-
 fs/btrfs/delayed-ref.c        |  15 +-
 fs/btrfs/dev-replace.c        |  21 ++-
 fs/btrfs/dir-item.c           |   7 +-
 fs/btrfs/disk-io.c            | 237 ++++++++++++++++--------
 fs/btrfs/disk-io.h            |   2 +
 fs/btrfs/extent-tree.c        | 200 ++++++++++++---------
 fs/btrfs/extent_io.c          | 170 +++++++++++-------
 fs/btrfs/extent_io.h          |   4 +-
 fs/btrfs/file.c               |  43 ++++-
 fs/btrfs/free-space-cache.c   |  21 ++-
 fs/btrfs/free-space-cache.h   |   6 +-
 fs/btrfs/free-space-tree.c    |  20 ++-
 fs/btrfs/inode-map.c          |  31 ++--
 fs/btrfs/inode.c              |  70 +++++---
 fs/btrfs/ioctl.c              |  14 +-
 fs/btrfs/lzo.c                |   6 +-
 fs/btrfs/ordered-data.c       |   4 +-
 fs/btrfs/print-tree.c         |  93 +++++-----
 fs/btrfs/qgroup.c             |  77 ++++----
 fs/btrfs/raid56.c             |   5 +-
 fs/btrfs/reada.c              |  32 ++--
 fs/btrfs/relocation.c         |  47 +++--
 fs/btrfs/root-tree.c          |  18 +-
 fs/btrfs/scrub.c              |  58 +++---
 fs/btrfs/send.c               |  79 ++++----
 fs/btrfs/super.c              |  62 ++++---
 fs/btrfs/sysfs.c              |  19 +-
 fs/btrfs/tests/inode-tests.c  |  12 +-
 fs/btrfs/tests/qgroup-tests.c |   2 +-
 fs/btrfs/transaction.c        |  49 +++--
 fs/btrfs/transaction.h        |   1 +
 fs/btrfs/tree-log.c           |  12 +-
 fs/btrfs/uuid-tree.c          |  27 +--
 fs/btrfs/volumes.c            | 221 ++++++++++++-----------
 fs/btrfs/volumes.h            |   2 +-
 fs/btrfs/zlib.c               |   8 +-
 43 files changed, 1574 insertions(+), 1086 deletions(-)
