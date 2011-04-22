From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 00/12] Cleanups, cruft removal
Date: Fri, 22 Apr 2011 11:41:00 +0200
Message-ID: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[resending, did not reach the list yesterday]

Hi,

sending out first bunch of function interface cleanups, removing unused
parameters in the easily reviewable cases, plus some compiler warning fixes. No
functional changes.

There is a measurable effect on code text size
(master is Linux 2.6.39-rc4 f0e615c3)

   text    data     bss     dec     hex filename
 518973    8112     216  527301   80bc5 btrfs.ko.master
 517594    8112     216  525922   80662 btrfs.ko.cleanups

smaller runtime stack footprint will gain some speedup. There are still 100+
warnings about unused parameters, but some of them need deeper look into
hisotry to verify that it's safe to remove them or are used within a longer
callchain.

Such cleanups may break yet unmerged features (eg. automerge succesful with
scrub, a few trivial conflicts with ino-alloc), so I'd like to hear if is the
right time to send such patches.


thanks,
david
---

David Sterba (12):
  btrfs: rename variables clashing with global function names
  btrfs: remove nested duplicate variable declarations
  btrfs: fix dereference before check
  btrfs: unify checking of IS_ERR and null
  btrfs: remove useless mutex lock/unlock sequences
  btrfs: make functions static when possible
  btrfs: drop unused argument from extent_io_tree_init
  btrfs: drop unused parameter from extent_map_tree_init
  btrfs: drop gfp parameter from alloc_extent_map
  btrfs: drop gfp parameter from find_extent_buffer
  btrfs: drop gfp parameter from alloc_extent_buffer
  btrfs: drop unused parameter from btrfs_release_path

 fs/btrfs/acl.c              |    2 +-
 fs/btrfs/compression.c      |   42 +++++++++---------
 fs/btrfs/compression.h      |    2 +-
 fs/btrfs/ctree.c            |   33 +++++++-------
 fs/btrfs/ctree.h            |    4 +-
 fs/btrfs/dir-item.c         |    2 +-
 fs/btrfs/disk-io.c          |   31 ++++++-------
 fs/btrfs/extent-tree.c      |   58 +++++++++++-------------
 fs/btrfs/extent_io.c        |   52 ++++++++++-----------
 fs/btrfs/extent_io.h        |   10 ++---
 fs/btrfs/extent_map.c       |    8 +--
 fs/btrfs/extent_map.h       |    4 +-
 fs/btrfs/file-item.c        |   12 +++---
 fs/btrfs/file.c             |   18 ++++----
 fs/btrfs/free-space-cache.c |   21 ++++-----
 fs/btrfs/inode.c            |   88 ++++++++++++++++++------------------
 fs/btrfs/ioctl.c            |   12 +++---
 fs/btrfs/relocation.c       |   36 ++++++++--------
 fs/btrfs/root-tree.c        |   10 ++--
 fs/btrfs/super.c            |    4 +-
 fs/btrfs/transaction.c      |    3 +-
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |  102 +++++++++++++++++++++---------------------
 fs/btrfs/volumes.c          |   22 +++++-----
 fs/btrfs/xattr.c            |    4 +-
 25 files changed, 282 insertions(+), 300 deletions(-)

-- 
1.7.5.rc3
