From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.39
Date: Mon, 28 Mar 2011 08:08:28 -0400
Message-ID: <1301312919-sup-1222@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The kernel.org mirror is making me pay for a mistake in my push last
night.  I'm still waiting for it to update the mirrors with the correct
commits, so I've got the proper sha down below.

Linus, I've pushed out two branches for you, for-linus and
for-linus-unmerged

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

The correct top commit in for-linus: 08aca535a2150e951c6f1d882bea6ef1a1c31822

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus-unmerged

The correct top commit in for-linus-unmerged: d9d04879321af570ea7285c6dad92d9c3cd108a1

The reason there are two is because there was a conflict in
fs/btrfs/volumes.c. Jens' unplugging code and the new btrfs fitrim
support were both changing the same code.  The merge isn't too bad, his
stuff was just removing the tests for an unplugging function, but I
wanted to provide a wrapped up merge commit just in case.

So, for-linus-unmerged is against 2.6.38, and for-linus is against your
git tree as of Friday.  The shortlog/diffstat below don't include the merge
commit.

This pull has per-file controls in btrfs for the compression and nocow
flags.  This goes in through the standard chattr interface, and Ted did
ack the new flags.

We also have support for the FITRIM ioctl, which will let us discard in
bulk.  It will be very interesting to compare the performance of online
discard vs bulk trim, and it is possible to run both at the same time.

There are also many error handling fixes, allocator performance fixes,
code cleanups, a switch to the new truncate handling code, and a few
other small fixes.  This might be the first pull in a long time without
the words ENOSPC in it, but I'm sure we've fixed that too.

Josef Bacik (22) commits (+790/-674):
    Btrfs: check free space in block group before searching for a cluster (+10/-0)
    Btrfs: deal with min_bytes appropriately when looking for a cluster (+4/-5)
    Btrfs: make sure to remove the orphan item from the in-memory list (+6/-0)
    Btrfs: mark the bio with an error if we have a failure in dio (+8/-0)
    Btrfs: fix how we deal with the pages array in the write path (+5/-4)
    Btrfs: add a comment explaining what btrfs_cont_expand does (+6/-0)
    Btrfs: return error if the range we want to map is bogus (+1/-0)
    Btrfs: check return value of btrfs_search_slot properly (+2/-0)
    Btrfs: use mark_inode_dirty when expanding the file (+1/-15)
    Btrfs: cleanup error handling in the truncate path (+45/-19)
    Btrfs: cleanup how we setup free space clusters (+182/-185)
    Btrfs: don't allocate dip->csums when doing writes (+5/-2)
    Btrfs: don't be as aggressive about using bitmaps (+16/-3)
    Btrfs: add checks to verify dir items are correct (+50/-0)
    Btrfs: check items for correctness as we search (+95/-124)
    Btrfs: change reserved_extents to an atomic_t (+29/-21)
    Btrfs: only add orphan items when truncating (+18/-27)
    Btrfs: handle errors in btrfs_orphan_cleanup (+50/-23)
    Btrfs: use a slab for the free space entries (+29/-16)
    Btrfs: convert to the new truncate sequence (+40/-47)
    Btrfs: simplify our write path (+180/-175)
    Btrfs: fix formatting in file.c (+8/-8)

liubo (6) commits (+779/-36):
    Btrfs: fix memory leak of empty filesystem after balance (+6/-0)
    Btrfs: fix OOPS of empty filesystem after balance (+30/-0)
    Btrfs: add initial tracepoint support for btrfs (+727/-11)
    btrfs: make inode ref log recovery faster (+11/-24)
    Btrfs: fix return value of setflags ioctl (+3/-1)
    Btrfs: add datacow flag in inode flag (+2/-0)

Li Dongyang (4) commits (+359/-51):
    Btrfs: make btrfs_map_block() return entire free extent for each device of RAID0/1/10/DUP (+129/-22)
    Btrfs: adjust btrfs_discard_extent() return errors and trimmed bytes (+31/-19)
    Btrfs: add btrfs_trim_fs() to handle FITRIM (+190/-1)
    Btrfs: make update_reserved_bytes() public (+9/-9)

Tsutomu Itoh (3) commits (+96/-37):
    Btrfs: check return value of btrfs_alloc_path() (+27/-14)
    Btrfs: check return value of read_tree_block() (+15/-0)
    Btrfs: cleanup some BUG_ON() (+54/-23)

Miao Xie (2) commits (+6/-3):
    btrfs: fix possible deadlock by clearing __GFP_FS flag (+4/-1)
    btrfs: use GFP_NOFS instead of GFP_KERNEL (+2/-2)

Chris Mason (2) commits (+28/-25):
    Btrfs: use RCU instead of a spinlock to protect the root node (+8/-19)
    Btrfs: fix __btrfs_map_block on 32 bit machines (+20/-6)

Al Viro (2) commits (+28/-11):
    btrfs: don't mess with i_nlink of unlocked inode in rename() (+25/-11)
    btrfs: check link counter overflow in link(2) (+3/-0)

Yoshinori Sano (1) commits (+12/-0):
    Btrfs: fix uncheck memory allocations

Mark Fasheh (1) commits (+1/-1):
    btrfs: return EXDEV when linking from different subvolumes

Liu Bo (1) commits (+72/-7):
    Btrfs: Per file/directory controls for COW and compression

David Sterba (1) commits (+2/-1):
    btrfs: properly access unaligned checksum buffer

Total: (45) commits (+2173/-846)

 fs/btrfs/btrfs_inode.h       |    3 +-
 fs/btrfs/compression.c       |   17 +-
 fs/btrfs/ctree.c             |  159 +---------
 fs/btrfs/ctree.h             |   19 +-
 fs/btrfs/delayed-ref.c       |    6 +
 fs/btrfs/dir-item.c          |   45 +++-
 fs/btrfs/disk-io.c           |  132 ++++++++-
 fs/btrfs/extent-tree.c       |  229 +++++++++++----
 fs/btrfs/extent_io.c         |    3 +
 fs/btrfs/extent_io.h         |    1 +
 fs/btrfs/file-item.c         |    5 +-
 fs/btrfs/file.c              |  388 +++++++++++++------------
 fs/btrfs/free-space-cache.c  |  510 ++++++++++++++++++++-------------
 fs/btrfs/free-space-cache.h  |    2 +
 fs/btrfs/inode-map.c         |    3 +-
 fs/btrfs/inode.c             |  366 +++++++++++++++--------
 fs/btrfs/ioctl.c             |  100 ++++++-
 fs/btrfs/ordered-data.c      |    8 +
 fs/btrfs/relocation.c        |    8 +-
 fs/btrfs/root-tree.c         |    6 +-
 fs/btrfs/super.c             |    5 +
 fs/btrfs/transaction.c       |   14 +-
 fs/btrfs/tree-log.c          |   57 ++--
 fs/btrfs/volumes.c           |  180 +++++++++--
 fs/btrfs/volumes.h           |   12 +
 fs/btrfs/xattr.c             |    2 +
 include/linux/fs.h           |    2 +
 include/trace/events/btrfs.h |  667 ++++++++++++++++++++++++++++++++++++++++++
 28 files changed, 2138 insertions(+), 811 deletions(-)
