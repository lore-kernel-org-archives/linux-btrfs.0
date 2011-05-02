From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 00/12] Cleanups, cruft removal
Date: Mon, 2 May 2011 16:01:50 +0200
Message-ID: <20110502140150.GC12709@twin.jikos.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patch series, with the updated mutex patch, can be pulled from

	git://repo.or.cz/linux-2.6/btrfs-unstable.git #cleanups


David Sterba (12):
      btrfs: rename variables clashing with global function names
      btrfs: remove nested duplicate variable declarations
      btrfs: fix dereference before check
      btrfs: unify checking of IS_ERR and null
      btrfs: make functions static when possible
      btrfs: drop unused argument from extent_io_tree_init
      btrfs: drop unused parameter from extent_map_tree_init
      btrfs: drop gfp parameter from alloc_extent_map
      btrfs: drop gfp parameter from find_extent_buffer
      btrfs: drop gfp parameter from alloc_extent_buffer
      btrfs: drop unused parameter from btrfs_release_path
      btrfs: Document a mutex lock/unlock sequence


 fs/btrfs/acl.c              |    2 +-
 fs/btrfs/compression.c      |   42 +++++++++---------
 fs/btrfs/compression.h      |    2 +-
 fs/btrfs/ctree.c            |   33 +++++++-------
 fs/btrfs/ctree.h            |    4 +-
 fs/btrfs/dir-item.c         |    2 +-
 fs/btrfs/disk-io.c          |   31 ++++++-------
 fs/btrfs/extent-tree.c      |   64 ++++++++++++++++-----------
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
 25 files changed, 294 insertions(+), 294 deletions(-)

