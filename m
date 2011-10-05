From: David Sterba <dsterba@suse.cz>
Subject: [GIT PULL] Cleanups for 3.2
Date: Wed,  5 Oct 2011 12:21:22 +0200
Message-ID: <cover.1317746377.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm sending a short series containg some rather simple cleanups which I came
accross while going through code (like opencoded macros which hide semantics).
As they could clash with other patches being merged I generated them. I would
like to see them merged of course, but do not want to make merging harder and I
can regenerate them any time when the main features/fixes are integrated.

I've added one patch which is not new but has not been merged yet. It separates
the super_block items from fs_info structure. New features add more items to
fs_info and this patch will make some space.

You can pull this series from

git://repo.or.cz/linux-2.6/btrfs-unstable.git cleanups-for-3.2

thanks,
david
---

David Sterba (8):
  btrfs: separate superblock items out of fs_info
  btrfs: fix misleading variable name for flags
  btrfs: use unsigned long type for extent state bits
  btrfs: no need to mask out GFP_HIGHMEM in radix preload
  btrfs: kill key type helpers
  btrfs: use ALIGN instead of open-coded variants
  btrfs: use DIV_ROUND_UP instead of open-coded variants
  btrfs: cleanup: use BUG_ON when appropriate

 fs/btrfs/compression.c      |   12 ++++----
 fs/btrfs/ctree.c            |    8 ++---
 fs/btrfs/ctree.h            |   23 ++++++----------
 fs/btrfs/delayed-inode.c    |    8 +++---
 fs/btrfs/dir-item.c         |   10 +++---
 fs/btrfs/disk-io.c          |   23 ++++++++--------
 fs/btrfs/export.c           |    4 +-
 fs/btrfs/extent-tree.c      |   53 ++++++++++++++++----------------------
 fs/btrfs/extent_io.c        |   59 ++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.h        |   33 ++++++++++++++----------
 fs/btrfs/file-item.c        |   29 ++++++++------------
 fs/btrfs/file.c             |   21 ++++++--------
 fs/btrfs/free-space-cache.c |    3 +-
 fs/btrfs/inode-item.c       |   10 +++---
 fs/btrfs/inode.c            |   56 +++++++++++++++++++----------------------
 fs/btrfs/ioctl.c            |   14 +++++-----
 fs/btrfs/lzo.c              |    3 +-
 fs/btrfs/ordered-data.h     |    3 +-
 fs/btrfs/orphan.c           |    4 +-
 fs/btrfs/print-tree.c       |   10 ++-----
 fs/btrfs/root-tree.c        |    4 +-
 fs/btrfs/scrub.c            |    6 ++--
 fs/btrfs/super.c            |   17 ++++++++---
 fs/btrfs/transaction.c      |   10 +++---
 fs/btrfs/tree-log.c         |   10 +++---
 fs/btrfs/volumes.c          |   35 ++++++++++++-------------
 fs/btrfs/xattr.c            |    4 +-
 fs/btrfs/zlib.c             |    3 +-
 28 files changed, 227 insertions(+), 248 deletions(-)

-- 
1.7.6
