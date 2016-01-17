Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58615 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbcAQXaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 18:30:39 -0500
Date: Sun, 17 Jan 2016 18:30:34 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160117233033.aowuldoul2cfuaad@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.5 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

This has our usual assortment of fixes and cleanups, but the biggest
change included is Omar Sandoval's free space tree.  It's not the
default yet, mounting -o space_cache=v2 enables it and sets a readonly
compat bit.  The tree can actually be deleted and regenerated if there
are any problems, but it has held up really well in testing so far.

For very large filesystems (30T+) our existing free space caching code
can end up taking a huge amount of time during commits.  The new tree
based code is faster and less work overall to update as the commit
progresses.

Omar worked on this during the summer and we'll hammer on it in
production here at FB over the next few months.

David Sterba (36) commits (+320/-341):
    btrfs: verbose error when we find an unexpected item in sys_array (+3/-0)
    btrfs: statfs: report zero available if metadata are exhausted (+24/-0)
    btrfs tests: replace whole ops structure for free space tests (+8/-6)
    btrfs: preallocate path for snapshot creation at ioctl time (+8/-6)
    btrfs: don't use slab cache for struct btrfs_delalloc_work (+2/-12)
    btrfs: do an allocation earlier during snapshot creation (+9/-11)
    btrfs: constify remaining structs with function pointers (+8/-8)
    btrfs: remove a trivial helper btrfs_set_buffer_uptodate (+3/-9)
    btrfs: make extent_range_clear_dirty_for_io return void (+2/-3)
    btrfs: use GFP_KERNEL for allocations in ioctl handlers (+5/-5)
    btrfs: sink parameter wait to btrfs_alloc_delalloc_work (+4/-4)
    btrfs: cleanup, use enum values for btrfs_path reada (+30/-30)
    btrfs: make extent_clear_unlock_delalloc return void (+3/-4)
    btrfs: make clear_extent_buffer_uptodate return void (+2/-3)
    btrfs: drop unused parameter from lock_extent_bits (+27/-27)
    btrfs: make clear_extent_bit helpers static inline (+38/-48)
    btrfs: use smaller type for btrfs_path lowest_level (+1/-1)
    btrfs: make extent_range_redirty_for_io return void (+2/-3)
    btrfs: use GFP_KERNEL for xattr and acl allocations (+3/-3)
    btrfs: use GFP_KERNEL for allocations of workqueues (+2/-2)
    btrfs: drop duplicate prefix from scrub workqueues (+5/-5)
    btrfs: better packing of btrfs_delayed_extent_op (+12/-15)
    btrfs: make set_extent_buffer_uptodate return void (+2/-3)
    btrfs: remove wait from struct btrfs_delalloc_work (+3/-9)
    btrfs: make set_extent_bit helpers static inline (+46/-56)
    btrfs: allocate root item at snapshot ioctl time (+13/-6)
    btrfs: cleanup, remove stray return statements (+0/-9)
    btrfs: handle invalid num_stripes in sys_array (+8/-0)
    btrfs: use smaller type for btrfs_path locks (+1/-1)
    btrfs: use smaller type for btrfs_path reada (+1/-1)
    btrfs: make end_extent_writepage return void (+3/-6)
    btrfs: make set_range_writeback return void (+1/-2)
    btrfs: put delayed item hook into inode (+29/-31)
    btrfs: make btrfs_close_one_device static (+2/-2)
    btrfs: make lock_extent static inline (+6/-6)
    btrfs: constify static arrays (+4/-4)

Filipe Manana (13) commits (+209/-74):
    Btrfs: fix race between free space endio workers and space cache writeout (+19/-0)
    Btrfs: fix fitrim discarding device area reserved for boot loader's use (+10/-10)
    Btrfs: fix unprotected list operations at btrfs_write_dirty_block_groups (+17/-2)
    Btrfs: fix race when finishing dev replace leading to transaction abort (+15/-2)
    Btrfs: fix error path when failing to submit bio for direct IO write (+27/-27)
    Btrfs: fix leaking of ordered extents after direct IO write error (+38/-5)
    Btrfs: fix deadlock between direct IO write and defrag/readpages (+13/-17)
    Btrfs: fix transaction handle leak on failure to create hard link (+4/-2)
    Btrfs: fix number of transaction units required to create symlink (+3/-1)
    Btrfs: don't leave dangling dentry if symlink creation failed (+7/-4)
    Btrfs: send, don't BUG_ON() when an empty symlink is found (+15/-1)
    Btrfs: fix memory leaks after transaction is aborted (+17/-0)
    Btrfs: fix locking bugs when defragging leaves (+24/-3)

Omar Sandoval (9) commits (+2926/-108):
    Btrfs: wire up the free space tree to the extent tree (+33/-3)
    Btrfs: introduce the free space B-tree on-disk format (+40/-1)
    Btrfs: add extent buffer bitmap sanity tests (+160/-16)
    Btrfs: add helpers for read-only compat bits (+82/-0)
    Btrfs: add extent buffer bitmap operations (+155/-0)
    Btrfs: add free space tree sanity tests (+646/-48)
    Btrfs: add free space tree mount option (+88/-10)
    Btrfs: implement the free space B-tree (+1686/-4)
    Btrfs: refactor caching_thread() (+36/-26)

Chris Mason (3) commits (+31/-17):
    btrfs: don't run delayed references while we are creating the free space tree (+28/-16)
    btrfs: fix warning on uninit variable in btrfs_finish_chunk_alloc (+1/-1)
    btrfs: fix compiling with CONFIG_BTRFS_DEBUG enabled. (+2/-0)

Alexandru Moise (3) commits (+12/-12):
    btrfs: switch __btrfs_fs_incompat return type from int to bool (+1/-1)
    btrfs: pass proper enum type to start_transaction() (+10/-5)
    btrfs: zero out delayed node upon allocation (+1/-6)

Geliang Tang (3) commits (+36/-106):
    btrfs: use list_for_each_entry_safe in free-space-cache.c (+4/-10)
    btrfs: use list_for_each_entry* in check-integrity.c (+26/-79)
    btrfs: use list_for_each_entry* in backref.c (+6/-17)

Byongho Lee (2) commits (+149/-180):
    btrfs: remove unused inode argument from uncompress_inline() (+2/-3)
    Btrfs: use linux/sizes.h to represent constants (+147/-177)

Anand Jain (1) commits (+1/-0):
    Btrfs: add missing brelse when superblock checksum fails

Zhao Lei (1) commits (+0/-8):
    btrfs: Support convert to -d dup for btrfs-convert

Josef Bacik (1) commits (+15/-2):
    Btrfs: igrab inode in writepage

Sam Tygier (1) commits (+7/-0):
    Btrfs: Check metadata redundancy on balance

Total: (73) commits (+3706/-848)

 fs/btrfs/Makefile                      |    5 +-
 fs/btrfs/acl.c                         |    4 +-
 fs/btrfs/async-thread.c                |    4 +-
 fs/btrfs/backref.c                     |   23 +-
 fs/btrfs/btrfs_inode.h                 |    4 +
 fs/btrfs/check-integrity.c             |  105 +--
 fs/btrfs/ctree.c                       |   11 +-
 fs/btrfs/ctree.h                       |  178 +++-
 fs/btrfs/delayed-inode.c               |    7 +-
 fs/btrfs/delayed-ref.c                 |    4 +-
 fs/btrfs/delayed-ref.h                 |    8 +-
 fs/btrfs/disk-io.c                     |   49 +-
 fs/btrfs/disk-io.h                     |    5 +-
 fs/btrfs/extent-tree.c                 |  200 ++--
 fs/btrfs/extent-tree.h                 |    0
 fs/btrfs/extent_io.c                   |  310 ++++---
 fs/btrfs/extent_io.h                   |  136 ++-
 fs/btrfs/file-item.c                   |    4 +-
 fs/btrfs/file.c                        |    8 +-
 fs/btrfs/free-space-cache.c            |   28 +-
 fs/btrfs/free-space-cache.h            |    2 +-
 fs/btrfs/free-space-tree.c             | 1591 ++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-tree.h             |   72 ++
 fs/btrfs/inode-map.c                   |    8 +-
 fs/btrfs/inode.c                       |  312 ++++---
 fs/btrfs/ioctl.c                       |   74 +-
 fs/btrfs/locking.c                     |    2 -
 fs/btrfs/raid56.c                      |    2 -
 fs/btrfs/relocation.c                  |   12 +-
 fs/btrfs/scrub.c                       |   16 +-
 fs/btrfs/send.c                        |   16 +-
 fs/btrfs/send.h                        |    4 +-
 fs/btrfs/super.c                       |   84 +-
 fs/btrfs/tests/btrfs-tests.c           |   58 ++
 fs/btrfs/tests/btrfs-tests.h           |   10 +
 fs/btrfs/tests/extent-io-tests.c       |  149 ++-
 fs/btrfs/tests/free-space-tests.c      |  239 ++---
 fs/btrfs/tests/free-space-tree-tests.c |  571 ++++++++++++
 fs/btrfs/tests/inode-tests.c           |    2 +-
 fs/btrfs/tests/qgroup-tests.c          |   20 +-
 fs/btrfs/transaction.c                 |   50 +-
 fs/btrfs/transaction.h                 |    2 +
 fs/btrfs/tree-defrag.c                 |   27 +-
 fs/btrfs/volumes.c                     |   93 +-
 fs/btrfs/volumes.h                     |    3 +-
 fs/btrfs/xattr.c                       |    4 +-
 include/trace/events/btrfs.h           |    3 +-
 47 files changed, 3690 insertions(+), 829 deletions(-)
