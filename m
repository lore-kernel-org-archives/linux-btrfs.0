From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] Cleanups II, unused code removal
Date: Thu,  5 May 2011 15:39:57 +0200
Message-ID: <cover.1304595715.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

another round of cleanups, removing unused code. No functional chanes.
The diffstat is quite big, please have a look if you feel that some code
is unused by accident.


thanks,
david

David Sterba (3):
  btrfs: remove unused function prototypes
  btrfs: remove all unused functions
  btrfs: remove old unused commented out code

 fs/btrfs/ctree.h            |   90 ---
 fs/btrfs/delayed-ref.c      |  114 ---
 fs/btrfs/delayed-ref.h      |    6 -
 fs/btrfs/disk-io.c          |   56 --
 fs/btrfs/disk-io.h          |   18 -
 fs/btrfs/extent-tree.c      | 1661 +------------------------------------------
 fs/btrfs/extent_io.c        |  227 ------
 fs/btrfs/extent_io.h        |   30 -
 fs/btrfs/free-space-cache.c |   15 -
 fs/btrfs/free-space-cache.h |    1 -
 fs/btrfs/inode.c            |  224 ------
 fs/btrfs/locking.c          |   25 -
 fs/btrfs/locking.h          |    2 -
 fs/btrfs/ref-cache.c        |  164 -----
 fs/btrfs/ref-cache.h        |   24 -
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/root-tree.c        |   47 --
 fs/btrfs/sysfs.c            |   65 --
 fs/btrfs/transaction.c      |  134 ----
 fs/btrfs/transaction.h      |    3 -
 fs/btrfs/tree-log.h         |    1 -
 fs/btrfs/volumes.c          |   19 -
 fs/btrfs/volumes.h          |    5 -
 23 files changed, 2 insertions(+), 2931 deletions(-)

-- 
1.7.5.1.169.g505a1

