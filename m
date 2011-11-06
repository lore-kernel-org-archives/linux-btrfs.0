From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs pull request
Date: Sun, 6 Nov 2011 13:38:51 -0500
Message-ID: <20111106183851.GA4339@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This pull request is pretty beefy, it ended up merging a number of long
running projects and cleanup queues.  I've got btrfs patches in the new
kernel.org btrfs repo.  There are two different branches with the same
changes.  for-linus is against 3.1 and has also been tested against
Linus' tree as of yesterday.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The next-merged branch is the same btrfs code, but has a merge
commit for the current linux-next tree.  There was only a single
conflict, linux-next has a fix for code that no longer exists, so the
merge is just to take my code.  I know Linus won't end up using
this, it's just to demonstrate the conflict in case he ends up with that
patch.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next-merged

The big features in this pull are:

Many cleanups and optimizations from Josef.  Many of these fixup the
enospc throttling in btrfs, where we try to start IO to make sure we can
do all the allocations we've promised we'll do.  The end result is a
dramatic improvement in random write workloads among many others.

Arne Jansen and Jan Schmidt have improved the scrubber and provided
utilities to walk btrfs' many backrefs.  The scrubber is much faster
thanks to extensive btree readahead and instead of just telling you a
specific block is bad, it tells you which btree or which file was
impacted by that bad block.

There are also progs updates to give you the same backref walking from
the command line.

SUSE and Fujitsu have a nice set of error handling fixes, and Li Zefan
also closed out some problems in the mount -o autodefrag mode.

I kicked in an array of backup tree roots.  If a given mount fails to go
through because a tree root is bad, you can mount -o recovery and it'll
walk through the array and try older versions of the FS.

I also spent a lot of time refining Fujitsu's log tree improvements.
This code has been around for quite a while, and I really wanted to get
it in this time.  But yesterday I hit corruptions when I mixed heavy
fsyncs with heavy snapshotting, and I wasn't able to fix things in time
for this merge window.

Josef Bacik (60) commits (+1847/-1238):
    Btrfs: don't check bytes_pinned to determine if we should commit the transaction (+0/-11)
    Btrfs: allow callers to specify if flushing can occur for btrfs_block_rsv_check (+10/-10)
    Btrfs: be smarter about committing the transaction in reserve_metadata_bytes (+67/-19)
    Btrfs: release metadata from global reserve if we have to fallback for unlink (+4/-1)
    Btrfs: wait for ordered extents if we're in trouble when shrinking delalloc (+17/-8)
    Btrfs: add a io_ctl struct and helpers for dealing with the space cache (+375/-318)
    Btrfs: seperate out btrfs_block_rsv_check out into 2 different functions (+37/-24)
    Btrfs: check the return value of filemap_write_and_wait in the space cache (+5/-2)
    Btrfs: don't increase the block_rsv's size when emergency allocating space (+0/-3)
    Btrfs: use the global reserve when truncating the free space cache inode (+17/-5)
    Btrfs: make sure to unset trans->block_rsv before running delayed refs (+11/-0)
    Btrfs: only reserve space in fallocate if we have to do a preallocate (+16/-6)
    Btrfs: stop passing a trans handle all around the reservation code (+39/-43)
    Btrfs: skip looking for delalloc if we don't have ->fill_delalloc (+5/-1)
    Btrfs: if we have a lot of pinned space, commit the transaction (+15/-0)
    Btrfs: release trans metadata bytes before flushing delayed refs (+3/-8)
    Btrfs: make a delayed_block_rsv for the delayed item insertion (+13/-7)
    Btrfs: ratelimit the generation printk for the free space cache (+7/-5)
    Btrfs: use the global reserve as a backup for deleting inodes (+11/-1)
    Btrfs: allow shrink_delalloc flush the needed reclaimed pages (+3/-2)
    Btrfs: only inherit btrfs specific flags when creating files (+11/-6)
    Btrfs: break out of orphan cleanup if we can't make progress (+11/-0)
    Btrfs: move stuff around in btrfs_inode to get better packing (+3/-3)
    Btrfs: reserve some space for an orphan item when unlinking (+8/-1)
    Btrfs: wait for ordered extents if we didn't reclaim enough (+1/-1)
    Btrfs: check unused against how much space we actually want (+1/-1)
    Btrfs: put the block group cache after we commit the super (+3/-3)
    Btrfs: inline checksums into the disk free space cache (+172/-68)
    Btrfs: use the inode's mapping mask for allocating pages (+18/-6)
    Btrfs: fix space leak when we fail to make an allocation (+14/-6)
    Btrfs: don't skip writing out a empty block groups cache (+6/-4)
    Btrfs: use the transactions block_rsv for the csum root (+10/-6)
    Btrfs: fix call to btrfs_search_slot in free space cache (+1/-1)
    Btrfs: use d_obtain_alias when mounting subvol/subvolid (+1/-24)
    Btrfs: allow us to overcommit our enospc reservations (+88/-18)
    Btrfs: don't get the block_rsv in btrfs_free_tree_block (+0/-4)
    Btrfs: handle enospc accounting for free space inodes (+47/-23)
    Btrfs: reduce the amount of space needed for truncates (+15/-4)
    Btrfs: kill the orphan space calculation for snapshots (+0/-90)
    Btrfs: use bytes_may_use for all ENOSPC reservations (+112/-82)
    Btrfs: optimize how we account for space in truncate (+29/-29)
    Btrfs: fix how we reserve space for deleting inodes (+38/-11)
    Btrfs: don't flush the cache inode before writing it (+0/-4)
    Btrfs: take overflow into account in reserving space (+1/-1)
    Btrfs: don't try to commit in btrfs_block_rsv_check (+4/-25)
    Btrfs: fix the amount of space reserved for unlink (+10/-1)
    Btrfs: fix regression in re-setting a large xattr (+11/-0)
    Btrfs: introduce mount option no_space_cache (+22/-10)
    Btrfs: delay iput when deleting a block group (+1/-1)
    Btrfs: kill btrfs_truncate_reserve_metadata (+0/-34)
    Btrfs: fix how we mount subvol=<whatever> (+135/-64)
    Btrfs: calculate checksum space correctly (+118/-8)
    Btrfs: kill the durable block rsv stuff (+17/-101)
    Btrfs: fix delayed insertion reservation (+49/-8)
    Btrfs: fix orphan cleanup regression (+17/-19)
    Btrfs: kill unused parts of block_rsv (+6/-22)
    Btrfs: introduce convert_extent_bit (+190/-0)
    Btrfs: set truncate block rsv's size (+2/-0)
    Btrfs: kill reserved_bytes in inode (+0/-8)
    Btrfs: stop using write_one_page (+20/-67)

Jan Schmidt (13) commits (+1954/-303):
    btrfs: new ioctls to do logical->inode and inode->path resolving (+162/-0)
    btrfs scrub: add fixup code for errors on nodatasum files (+183/-6)
    btrfs: integrating raid-repair and scrub-fixup-nodatasum (+67/-25)
    btrfs: Moved repair code from inode.c to extent_io.c (+393/-159)
    btrfs: added helper functions to iterate backrefs (+851/-1)
    btrfs: btrfs_multi_bio replaced with btrfs_bio (+90/-78)
    btrfs: Do not use bio->bi_bdev after submission (+1/-1)
    btrfs: add mirror_num to extent_read_full_page (+6/-6)
    btrfs scrub: print paths of corrupted files (+163/-6)
    btrfs scrub: use int for mirror_num, not u64 (+4/-4)
    btrfs scrub: bugfix: mirror_num off by one (+6/-6)
    btrfs scrub: added unverified_errors (+26/-11)
    btrfs: Put mirror_num in bi_bdev (+2/-0)

Chris Mason (10) commits (+490/-67):
    Btrfs: make sure to flush queued bios if write_cache_pages waits (+22/-10)
    Btrfs: don't wait as long for more batches during SSD log commit (+2/-2)
    Btrfs: fix extent_buffer leak in the metadata IO error handling (+1/-0)
    Btrfs: ClearPageError during writepage and clean_tree_block (+10/-1)
    Btrfs: make sure btrfs_remove_free_space doesn't leak EAGAIN (+3/-1)
    Btrfs: fix the new inspection ioctls for 32 bit compat (+15/-16)
    Btrfs: stop the readahead threads on failed mount (+1/-0)
    Btrfs: fix extent pinning bugs in the tree log (+59/-8)
    Btrfs: fix race during transaction joins (+8/-5)
    Btrfs: add a log of past tree roots (+369/-24)

Li Zefan (7) commits (+47/-24):
    Btrfs: fix wrong max_to_defrag in btrfs_defrag_file() (+1/-1)
    Btrfs: honor extent thresh during defragmentation (+26/-11)
    Btrfs: remove BUG_ON() in compress_file_range() (+5/-1)
    Btrfs: use i_size_read() in btrfs_defrag_file() (+4/-3)
    Btrfs: fix defragmentation regression (+4/-2)
    Btrfs: fix direct-io vs nodatacow (+1/-2)
    Btrfs: fix array bound checking (+6/-4)

Ilya Dryomov (6) commits (+22/-21):
    Btrfs: pass the correct root to lookup_free_space_inode() (+1/-1)
    Btrfs: rename btrfs_bio multi -> bbio for consistency (+15/-15)
    Btrfs: fix a potential btrfs_bio leak on scrub fixups (+1/-0)
    Btrfs: stop leaking btrfs_bios on readahead (+2/-0)
    Btrfs: fix a bug when opening seed devices (+1/-1)
    Btrfs: close all bdevs on mount failure (+2/-4)

Arne Jansen (6) commits (+1130/-70):
    btrfs: add an extra wait mode to read_extent_buffer_pages (+9/-6)
    btrfs: initial readahead code and prototypes (+967/-1)
    btrfs: add READAHEAD extent buffer flag (+35/-0)
    btrfs: state information for readahead (+31/-0)
    btrfs: use readahead API for scrub (+50/-62)
    btrfs: hooks for readahead (+38/-1)

David Sterba (3) commits (+105/-77):
    btrfs: do not allow mounting non-subvolumes via subvol option (+19/-0)
    btrfs: separate superblock items out of fs_info (+78/-76)
    btrfs: ratelimit WARN_ON in use_block_rsv (+8/-1)

Zheng Yan (1) commits (+4/-1):
    btrfs: check file extent backref offset underflow

Lukas Czerner (1) commits (+5/-1):
    btrfs: return EINVAL if start > total_bytes in fitrim ioctl

Daniel J Blueman (1) commits (+6/-2):
    btrfs: fix oops on failure path

Liu Bo (1) commits (+1/-1):
    Btrfs: do not set EXTENT_DIRTY along with EXTENT_DELALLOC

Diego Calleja (1) commits (+1/-3):
    btrfs: fix memory leak in btrfs_defrag_file

Jeff Liu (1) commits (+8/-2):
    btrfs: trivial fix, a potential memory leak in btrfs_parse_early_options()

Miao Xie (1) commits (+7/-0):
    Btrfs: fix race between multi-task space allocation and caching space

Tsutomu Itoh (1) commits (+7/-10):
    Btrfs: fix return value of btrfs_get_acl()

Total: (113) commits

 fs/btrfs/Makefile           |    3 +-
 fs/btrfs/acl.c              |   17 +-
 fs/btrfs/backref.c          |  776 +++++++++++++++++++++++++++++++++++
 fs/btrfs/backref.h          |   62 +++
 fs/btrfs/btrfs_inode.h      |   17 +-
 fs/btrfs/compression.c      |    3 +-
 fs/btrfs/ctree.c            |   10 +-
 fs/btrfs/ctree.h            |  198 ++++++++--
 fs/btrfs/delayed-inode.c    |   50 ++-
 fs/btrfs/disk-io.c          |  434 +++++++++++++++++---
 fs/btrfs/disk-io.h          |    4 +-
 fs/btrfs/extent-tree.c      |  848 +++++++++++++++++++++++---------------
 fs/btrfs/extent_io.c        |  614 +++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h        |   23 +-
 fs/btrfs/file-item.c        |   17 +-
 fs/btrfs/file.c             |   25 +-
 fs/btrfs/free-space-cache.c |  926 +++++++++++++++++++++++++----------------
 fs/btrfs/inode-map.c        |    6 +-
 fs/btrfs/inode.c            |  457 +++++++--------------
 fs/btrfs/ioctl.c            |  227 +++++++++--
 fs/btrfs/ioctl.h            |   29 ++
 fs/btrfs/print-tree.c       |    8 +-
 fs/btrfs/reada.c            |  951 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/relocation.c       |   24 +-
 fs/btrfs/scrub.c            |  591 ++++++++++++++++++++++-----
 fs/btrfs/super.c            |  298 +++++++++-----
 fs/btrfs/transaction.c      |  146 +++----
 fs/btrfs/tree-log.c         |   19 +-
 fs/btrfs/volumes.c          |  207 ++++++----
 fs/btrfs/volumes.h          |   18 +-
 fs/btrfs/xattr.c            |   11 +
 31 files changed, 5416 insertions(+), 1603 deletions(-)
