From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Fri, 27 May 2011 15:55:49 -0400
Message-ID: <1306525303-sup-718@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I always thought that I'd be retired and with my flying car at the
beach by the time 3.0 came out, but I've setup the for-linus branch of
the btrfs-unstable tree for pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

This pull request is probably the biggest I've sent, but it isn't
a code dump into our shiny new .0 rc.  The bulk of the changes are
three separate projects that have been going on for 6-8 months:

	A new btrfs inode allocation cache (Li Zefan)
	Delayed metadata insertion into the btree (Miao Xe)
	Device scrubbing (Arne Jansen)

On top of that Dave Sterba kicked in a series of code cleanups and Josef
Bacik did some really nice tuning.  The short log lists a few other
cleanups and fixes too.

I coded up a mount -o autodefrag that will detect random writes
into existing files and kick off background defragging.  It is well
suited to bdb or sqlite databases, but not virtualization images or big
databases (yet).  Once I make sure it doesn't defrag files over and over
again, I'll move this toward the default.

David Sterba (17) commits (+310/-3253):
    btrfs: rename variables clashing with global function names (+53/-53)
    btrfs: use printk_ratelimited instead of printk_ratelimit (+10/-24)
    btrfs: drop unused parameter from btrfs_release_path (+160/-160)
    btrfs: drop unused parameter from extent_map_tree_init (+5/-7)
    btrfs: drop unused argument from extent_io_tree_init (+10/-12)
    btrfs: remove nested duplicate variable declarations (+0/-4)
    btrfs: drop gfp parameter from alloc_extent_buffer (+7/-9)
    btrfs: drop gfp parameter from find_extent_buffer (+4/-6)
    btrfs: drop gfp parameter from alloc_extent_map (+16/-17)
    btrfs: use unsigned type for single bit bitfield (+4/-4)
    btrfs: remove old unused commented out code (+1/-2071)
    btrfs: Document a mutex lock/unlock sequence (+12/-0)
    btrfs: make functions static when possible (+7/-7)
    btrfs: unify checking of IS_ERR and null (+17/-17)
    btrfs: remove unused function prototypes (+0/-43)
    btrfs: remove all unused functions (+1/-817)
    btrfs: fix dereference before check (+3/-2)

Li Zefan (8) commits (+1449/-665):
    Btrfs: Make the code for reading/writing free space cache generic (+204/-154)
    Btrfs: setup free ino caching in a more asynchronous way (+22/-6)
    Btrfs: Support reading/writing on disk free ino cache (+236/-19)
    Btrfs: Remove unused btrfs_block_group_free_space() (+0/-16)
    Btrfs: Make free space cache code generic (+271/-223)
    Btrfs: Cache free inode numbers in memory (+500/-53)
    Btrfs: Always use 64bit inode number (+208/-182)
    Btrfs: Use bitmap_set/clear() (+8/-12)

Xiao Guangrong (7) commits (+134/-59):
    Btrfs: allocate extent state and check the result properly (+26/-8)
    Btrfs: using rcu lock in the reader side of devices list (+72/-36)
    Btrfs: fix the race between reading and updating devices (+9/-0)
    Btrfs: fix the race between remove dev and alloc chunk (+6/-0)
    Btrfs: fix bh leak on __btrfs_open_devices path (+1/-0)
    Btrfs: fix unsafe usage of merge_state (+14/-8)
    Btrfs: drop unnecessary device lock (+6/-7)

Arne Jansen (6) commits (+1822/-361):
    btrfs scrub: don't coalesce pages that are logically discontiguous (+2/-1)
    btrfs: move btrfs_cmp_device_free_bytes to super.c (+26/-28)
    btrfs: quasi-round-robin for chunk allocation (+177/-305)
    btrfs: add readonly flag (+16/-12)
    btrfs: heed alloc_start (+1/-4)
    btrfs: scrub (+1600/-11)

Tsutomu Itoh (5) commits (+43/-36):
    Btrfs: BUG_ON is deleted from the caller of btrfs_truncate_item & btrfs_extend_item (+2/-17)
    Btrfs: return error code to caller when btrfs_previous_item fails (+3/-2)
    Btrfs: return error code to caller when btrfs_del_item fails (+19/-11)
    Btrfs: return error to caller if read_one_inode() fails (+18/-6)
    Btrfs: check return value of btrfs_inc_extent_ref() (+1/-0)

Chris Mason (4) commits (+689/-144):
    Btrfs: update the delayed inode code to use the btrfs_ino helper. (+7/-6)
    Btrfs: use the device_list_mutex during write_dev_supers (+2/-2)
    Btrfs: return -ENOMEM in clear_extent_bit (+2/-1)
    Btrfs: add mount -o auto_defrag (+678/-135)

Sergei Trofimovich (3) commits (+7/-3):
    btrfs: don't spin in shrink_delalloc if there is nothing to free (+4/-0)
    btrfs: fix typo 'testeing' -> 'testing' (+2/-2)
    btrfs: typo: 'btrfS' -> 'btrfs' (+1/-1)

Jan Schmidt (1) commits (+169/-2):
    btrfs: new ioctls for scrub

liubo (1) commits (+3/-0):
    Btrfs: do not flush csum items of unchanged file data during treelog

Miao Xie (1) commits (+2074/-91):
    btrfs: implement delayed inode items operation

Julia Lawall (1) commits (+4/-1):
    fs/btrfs: Add missing btrfs_free_path

Andi Kleen (1) commits (+0/-4):
    BTRFS: Remove unused node_lock

Ilya Dryomov (1) commits (+80/-207):
    btrfs scrub: make fixups sync

Jamey Sharp (1) commits (+0/-43):
    btrfs: Delete unused version.sh script.

Hugo Mills (1) commits (+1/-3):
    btrfs: Ensure the tree search ioctl returns the right number of records

Total: (58) commits

 fs/btrfs/Makefile           |    2 +-
 fs/btrfs/acl.c              |    2 +-
 fs/btrfs/btrfs_inode.h      |   15 +
 fs/btrfs/compression.c      |   47 +-
 fs/btrfs/compression.h      |    2 +-
 fs/btrfs/ctree.c            |   51 +-
 fs/btrfs/ctree.h            |  244 +++---
 fs/btrfs/delayed-inode.c    | 1695 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-inode.h    |  141 +++
 fs/btrfs/delayed-ref.c      |  114 ---
 fs/btrfs/delayed-ref.h      |    6 -
 fs/btrfs/dir-item.c         |   39 +-
 fs/btrfs/disk-io.c          |  210 +++--
 fs/btrfs/disk-io.h          |   19 +-
 fs/btrfs/export.c           |   25 +-
 fs/btrfs/extent-tree.c      | 2014 ++++---------------------------------------
 fs/btrfs/extent_io.c        |  324 ++------
 fs/btrfs/extent_io.h        |   40 +-
 fs/btrfs/extent_map.c       |    8 +-
 fs/btrfs/extent_map.h       |    4 +-
 fs/btrfs/file-item.c        |   38 +-
 fs/btrfs/file.c             |  302 ++++++-
 fs/btrfs/free-space-cache.c |  993 +++++++++++++---------
 fs/btrfs/free-space-cache.h |   48 +-
 fs/btrfs/inode-item.c       |    2 -
 fs/btrfs/inode-map.c        |  444 ++++++++++-
 fs/btrfs/inode-map.h        |   13 +
 fs/btrfs/inode.c            |  700 ++++++---------
 fs/btrfs/ioctl.c            |  624 +++++++++++---
 fs/btrfs/ioctl.h            |  107 ++-
 fs/btrfs/locking.c          |   25 -
 fs/btrfs/locking.h          |    2 -
 fs/btrfs/ref-cache.c        |  164 ----
 fs/btrfs/ref-cache.h        |   24 -
 fs/btrfs/relocation.c       |   67 +-
 fs/btrfs/root-tree.c        |   61 +--
 fs/btrfs/scrub.c            | 1369 +++++++++++++++++++++++++++++
 fs/btrfs/super.c            |   51 +-
 fs/btrfs/sysfs.c            |   77 --
 fs/btrfs/transaction.c      |  196 ++---
 fs/btrfs/transaction.h      |    5 +-
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |  208 +++--
 fs/btrfs/tree-log.h         |    1 -
 fs/btrfs/version.sh         |   43 -
 fs/btrfs/volumes.c          |  657 ++++++---------
 fs/btrfs/volumes.h          |   27 +-
 fs/btrfs/xattr.c            |   12 +-
 48 files changed, 6594 insertions(+), 4670 deletions(-)
