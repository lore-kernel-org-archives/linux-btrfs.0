From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs pull round two
Date: Tue, 02 Aug 2011 16:33:04 -0400
Message-ID: <1312315404-sup-6084@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This has the rest of the btrfs cleanups for 3.1.  The bulk of this is
error handing fixes from SUSE and cleanups from Fujitsu.

Josef figured out that my attempts to optimize writepage were
actually doing much more IO than we needed to, so this simplifies our
writepage code to only write the one page we were sent.

Linus, the btrfs-unstable tree has two branches to choose from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

or

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus-merged

There were minor conflicts in the acl cleanup and the btrfs writepage
function.  for-linus-merged has my merge, while for-linus is unmerged
against 3.0.

Li Zefan (11) commits (+98/-355):
    Btrfs: make acl functions really no-op if acl is not enabled (+15/-21)
    Btrfs: check the nodatasum flag when writing compressed files (+10/-4)
    Btrfs: remove a BUG_ON() in btrfs_commit_transaction() (+2/-4)
    Btrfs: remove redundant code for dir item lookup (+2/-28)
    Btrfs: copy string correctly in INO_LOOKUP ioctl (+1/-2)
    Btrfs: clean up code for merging extent maps (+21/-38)
    Btrfs: clean up code for extent_map lookup (+29/-56)
    Btrfs: clean up search_extent_mapping() (+3/-14)
    Btrfs: remove remaining ref-cache code (+0/-120)
    Btrfs: fix readahead in file defrag (+8/-16)
    Btrfs: use wait_event() (+7/-52)

Mark Fasheh (8) commits (+82/-34):
    btrfs: Don't BUG_ON alloc_path errors in btrfs_truncate_inode_items (+5/-4)
    btrfs: Don't BUG_ON alloc_path errors in btrfs_read_locked_inode (+17/-5)
    btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot (+6/-2)
    btrfs: Don't BUG_ON alloc_path errors in replay_one_buffer() (+9/-3)
    btrfs: Don't BUG_ON alloc_path errors in find_next_chunk (+8/-2)
    btrfs: Don't BUG_ON alloc_path errors in btrfs_balance() (+4/-2)
    btrfs: don't BUG_ON btrfs_alloc_path() errors (+29/-11)
    btrfs: make btrfs_set_root_node void (+4/-5)

Xiao Guangrong (4) commits (+30/-52):
    Btrfs: remove unused members from struct extent_state (+0/-2)
    Btrfs: clean up for find_first_extent_bit() (+24/-40)
    Btrfs: clean up for wait_extent_bit() (+1/-5)
    Btrfs: clean up for insert_state() (+5/-5)

Josef Bacik (2) commits (+3/-11):
    Btrfs: don't call writepages from within write_full_page (+0/-10)
    Btrfs: don't print the leaf if we had an error (+3/-1)

Jeff Mahoney (1) commits (+34/-62):
    btrfs: Make extent-io callbacks that never fail return void

Wanlong Gao (1) commits (+5/-6):
    Btrfs:don't check the return value of __btrfs_add_inode_defrag

Mitch Harder (1) commits (+2/-5):
    Btrfs: Remove unused variable 'last_index' in file.c

Tsutomu Itoh (1) commits (+9/-4):
    Btrfs: return error to caller when btrfs_unlink() failes

liubo (1) commits (+3/-1):
    Btrfs: fix oops while writing data to SSD partitions

WuBo (1) commits (+7/-3):
    Btrfs: Protect the readonly flag of block group

Total: (31) commits

 fs/btrfs/Makefile      |    4 +-
 fs/btrfs/acl.c         |   17 -----
 fs/btrfs/compression.c |   14 +++-
 fs/btrfs/ctree.h       |   30 +++++++---
 fs/btrfs/dir-item.c    |   30 +---------
 fs/btrfs/extent-tree.c |   45 +++++++++++----
 fs/btrfs/extent_io.c   |  140 +++++++++++++------------------------------
 fs/btrfs/extent_io.h   |   20 +++----
 fs/btrfs/extent_map.c  |  155 +++++++++++++++--------------------------------
 fs/btrfs/file-item.c   |    7 ++-
 fs/btrfs/file.c        |   21 +++----
 fs/btrfs/inode.c       |   98 ++++++++++++++++--------------
 fs/btrfs/ioctl.c       |    3 +-
 fs/btrfs/ref-cache.c   |   68 ---------------------
 fs/btrfs/ref-cache.h   |   52 ----------------
 fs/btrfs/root-tree.c   |    5 +-
 fs/btrfs/transaction.c |   65 +++-----------------
 fs/btrfs/tree-log.c    |   12 +++-
 fs/btrfs/volumes.c     |   12 +++-
 19 files changed, 269 insertions(+), 529 deletions(-)
