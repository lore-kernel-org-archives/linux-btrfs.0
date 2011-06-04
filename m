From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Sat, 04 Jun 2011 10:37:18 -0400
Message-ID: <1307197108-sup-8188@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"Linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has our collection of fixes.  It's a little bigger than usual for rc2
because it includes Josef's queue of Btrfs changes.  It seemed best to
split them so we could concentrate on looking for any issues in the new
btrfs rc1 code from Fujitsu.  His tree is bug fixes and journal lock
reduction.

Some people have reported the initial caching of the free inode number
map (which happens only once when it is first enabled) is sucking down
too much CPU and IO time on their systems.  We don't have that one fixed
yet, but this pull does clean up a few other problems in the new inode
number allocatgor.  It also turns it off by default (mount -o
inode_cache to enable).

I was on the fence for turning this on by default, but we've already
kicked out three bugs so it seems best to keep it optional until 3.1.

Josef Bacik (15) commits (+478/-386):
    Btrfs: don't try to allocate from a block group that doesn't have enough space (+8/-0)
    Btrfs: take away the num_items argument from btrfs_join_transaction (+42/-48)
    Btrfs: make sure to use the delalloc reserve when filling delalloc (+2/-0)
    Btrfs: don't save the inode cache if we are deleting this root (+5/-0)
    Btrfs: don't look at the extent buffer level 3 times in a row (+0/-3)
    Btrfs: map the node block when looking for readahead targets (+21/-2)
    Btrfs: set range_start to the right start in count_range_bits (+1/-1)
    Btrfs: if we've already started a trans handle, use that one (+19/-0)
    Btrfs: check for duplicate entries in the free space cache (+24/-3)
    Btrfs: try not to sleep as much when doing slow caching (+11/-8)
    Btrfs: fix how we do space reservation for truncate (+123/-37)
    Btrfs: leave spinning on lookup and map the leaf (+12/-0)
    Btrfs: kill BTRFS_I(inode)->block_group (+13/-110)
    Btrfs: don't always do readahead (+20/-5)
    Btrfs: kill trans_mutex (+177/-169)

Chris Mason (3) commits (+54/-9):
    Btrfs: make sure we don't overflow the free space cache crc page (+19/-8)
    Btrfs: fix uninit variable in the delayed inode code (+1/-0)
    Btrfs: add mount -o inode_cache (+34/-1)

David Sterba (3) commits (+26/-21):
    btrfs: use btrfs_ino to access inode number (+5/-4)
    btrfs: fix uninitialized variable warning (+1/-1)
    btrfs: add helper for fs_info->closing (+20/-16)

Arne Jansen (3) commits (+70/-53):
    btrfs: scrub: don't reuse bios and pages (+65/-49)
    btrfs: scrub: add explicit plugging (+4/-3)
    btrfs: false BUG_ON when degraded (+1/-1)

liubo (1) commits (+6/-0):
    Btrfs: don't save the inode cache in non-FS roots

Total: (25) commits

 fs/btrfs/btrfs_inode.h      |    3 -
 fs/btrfs/ctree.c            |   28 +++-
 fs/btrfs/ctree.h            |   22 +++-
 fs/btrfs/delayed-inode.c    |    8 +-
 fs/btrfs/disk-io.c          |   36 +++---
 fs/btrfs/extent-tree.c      |  103 ++++++++++-----
 fs/btrfs/extent_io.c        |    2 +-
 fs/btrfs/file.c             |   10 +-
 fs/btrfs/free-space-cache.c |   70 ++++++++---
 fs/btrfs/inode-map.c        |   34 +++++-
 fs/btrfs/inode.c            |  261 +++++++++++++++++++------------------
 fs/btrfs/ioctl.c            |   26 ++---
 fs/btrfs/relocation.c       |   34 +++--
 fs/btrfs/scrub.c            |  123 ++++++++++--------
 fs/btrfs/super.c            |    8 +-
 fs/btrfs/transaction.c      |  302 +++++++++++++++++++++++--------------------
 fs/btrfs/transaction.h      |   29 +---
 fs/btrfs/volumes.c          |    2 +-
 fs/btrfs/xattr.c            |    2 -
 19 files changed, 635 insertions(+), 468 deletions(-)
