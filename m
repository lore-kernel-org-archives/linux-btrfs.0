From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Sun, 12 Jun 2011 07:57:34 -0400
Message-ID: <1307879298-sup-3080@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has our current queue of fixes.  Josef's is the biggest pile, mostly in
the allocator.  Josef and I both managed to merge his patch to avoid
mapping the extent buffer if skip_locking was set, git merge is just a
little too easy sometimes (I double checked the resulting code).

We've also got some fixes for the new scrub code, and a regression fix
for the new use of current->journal_info in nested transactions.

Josef Bacik (9) commits (+178/-65):
    Btrfs: don't commit the transaction if we dont have enough pinned bytes (+7/-0)
    Btrfs: don't map extent buffer if path->skip_locking is set (+7/-3)
    Btrfs: cache bitmaps when searching for a cluster (+49/-5)
    Btrfs: noinline the cluster searching functions (+10/-8)
    Btrfs: unlock the trans lock properly (+1/-1)
    Btrfs: fix the allocator loop logic (+25/-23)
    Btrfs: fix duplicate checking logic (+3/-3)
    Btrfs: fix bitmap regression (+69/-19)

Arne Jansen (3) commits (+39/-32):
    btrfs: remove unneeded includes from scrub.c (+0/-6)
    btrfs: scrub: errors in tree enumeration (+34/-23)
    btrfs: reinitialize scrub workers (+5/-3)

Li Zefan (2) commits (+15/-10):
    Btrfs: use join_transaction in btrfs_evict_inode() (+1/-1)
    Btrfs: avoid stack bloat in btrfs_ioctl_fs_info() (+14/-9)

Chris Mason (1) commits (+5/-4):
    Btrfs: make sure to recheck for bitmaps in clusters

Sage Weil (1) commits (+4/-1):
    Btrfs: clear current->journal_info on async transaction commit

Ilya Dryomov (1) commits (+2/-6):
    Btrfs - use %pU to print fsid

Jan Schmidt (1) commits (+1/-1):
    Btrfs: fix extent state leak on failed nodatasum reads

David Sterba (1) commits (+1/-2):
    btrfs: fix unlocked access of delalloc_inodes

richard kennedy (1) commits (+1/-1):
    btrfs: remove 64bit alignment padding to allow extent_buffer to fit into one fewer cacheline

Total: (20) commits (+246/-122)
 fs/btrfs/ctree.c            |   10 ++-
 fs/btrfs/disk-io.c          |    5 +-
 fs/btrfs/extent-tree.c      |   55 +++++++++------
 fs/btrfs/extent_io.h        |    2 +-
 fs/btrfs/free-space-cache.c |  163 ++++++++++++++++++++++++++++++++++---------
 fs/btrfs/inode.c            |    4 +-
 fs/btrfs/ioctl.c            |   23 ++++---
 fs/btrfs/scrub.c            |   69 ++++++++++--------
 fs/btrfs/transaction.c      |    7 ++-
 fs/btrfs/volumes.c          |    8 +--
 10 files changed, 233 insertions(+), 113 deletions(-)
