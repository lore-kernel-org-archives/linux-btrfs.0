From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL 1/2] Btrfs changes for 3.3-rc
Date: Tue, 17 Jan 2012 15:13:23 -0500
Message-ID: <20120117200909.GE3658@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This is pull request #1 of 2, since I have a viro's VFS changes too.
This one is against 3.2.  Against your current tree, there's a small
conflict in fs/btrfs/ioctl.c.  My pull request with viro's changes has a
tree where I've resolved the conflict.

Please pull the for-linus branch of the btrfs repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The biggest change in here is Ilya Dryomov's reworking of the btrfs
balance code.  It can now pause, resume, give status updates, and
restripe between different raid levels.  It also lets you filter the
balance based on metadata/data profiles, and lets you only balance
mostly empty block groups.

We also have a big set of changes to fix up the backref walker.  This is
used by scrub to report on which files are impacted by a given block,
and it will later be used by the per-subvolume quota code.

This also closes out the allocator fixes from Alexandre Oliva, and adds
a new debugging option that verifies the btrees send down at write time.
The idea here is to catch inconsistent trees during the commit, missed
writes, and other bugs in the kernel code.  From a diffstat point of
view, this is the biggest change.

Li Zefan fixed up seed devices and the bulk trimming code, and Josef
Bacik kicked in allocator trace points.

Ilya Dryomov (21) commits (+1403/-116):
    Btrfs: allow for resuming restriper after it was paused (+15/-0)
    Btrfs: add basic infrastructure for selective balancing (+71/-2)
    Btrfs: soft profile changing mode (aka soft convert) (+29/-0)
    Btrfs: introduce masks for chunk type and profile (+22/-27)
    Btrfs: do not reduce profile in do_chunk_alloc() (+19/-1)
    Btrfs: make avail_*_alloc_bits fields dynamic (+20/-0)
    Btrfs: add basic restriper infrastructure (+281/-41)
    Btrfs: add BTRFS_AVAIL_ALLOC_BIT_SINGLE bit (+36/-9)
    Btrfs: virtual address space subset filter (+21/-0)
    Btrfs: implement online profile changing (+129/-1)
    Btrfs: get rid of *_alloc_profile fields (+6/-16)
    Btrfs: save balance parameters to disk (+231/-1)
    Btrfs: add balance progress reporting (+84/-5)
    Btrfs: allow for canceling restriper (+53/-3)
    Btrfs: add skip_balance mount option (+17/-5)
    Btrfs: allow for pausing restriper (+94/-3)
    Btrfs: recover balance on mount (+139/-2)
    Btrfs: devid subset filter (+47/-0)
    Btrfs: profiles filter (+28/-0)
    Btrfs: devid filter (+24/-0)
    Btrfs: usage filter (+37/-0)

Li Zefan (11) commits (+280/-230):
    Btrfs: simplfy calculation of stripe length for discard operation (+31/-64)
    Btrfs: add pinned extents to on-disk free space cache correctly (+20/-21)
    Btrfs: update global block_rsv when creating a new block group (+1/-0)
    Btrfs: don't pass a trans handle unnecessarily in volumes.c (+9/-14)
    Btrfs: fix possible deadlock when opening a seed device (+7/-4)
    Btrfs: reserve metadata space in btrfs_ioctl_setflags() (+1/-1)
    Btrfs: avoid possible NULL deref in io_ctl_drop_pages() (+5/-3)
    Btrfs: remove BUG_ON()s in btrfs_ioctl_setflags() (+14/-4)
    Btrfs: check the return value of io_ctl_init() (+7/-2)
    Btrfs: rewrite btrfs_trim_block_group() (+164/-71)
    Btrfs: don't pre-allocate btrfs bio (+21/-46)

Josef Bacik (7) commits (+349/-53):
    Btrfs: add a delalloc mutex to inodes for delalloc reservations (+7/-16)
    Btrfs: do not use btrfs_end_transaction_throttle everywhere (+10/-10)
    Btrfs: protect orphan block rsv with spin_lock (+19/-4)
    Btrfs: don't call btrfs_throttle in file write (+0/-1)
    Btrfs: release space on error in page_mkwrite (+1/-1)
    Btrfs: add allocator tracepoints (+193/-1)
    Btrfs: space leak tracepoints (+119/-20)

Arne Jansen (6) commits (+665/-158):
    Btrfs: generic data structure to build unique lists (+289/-1)
    Btrfs: put back delayed refs that are too new (+47/-23)
    Btrfs: add sequence numbers to delayed refs (+108/-0)
    Btrfs: always save ref_root in delayed refs (+12/-18)
    Btrfs: add nested locking mode for paths (+54/-2)
    Btrfs: mark delayed refs as for cow (+155/-114)

Jan Schmidt (5) commits (+977/-264):
    Btrfs: add waitqueue instead of doing busy waiting for more delayed refs (+74/-1)
    Btrfs: make sure we're not using obsolete code in btrfs_get_extent (+1/-1)
    Btrfs: added btrfs_find_all_roots() (+788/-0)
    Btrfs: added helper btrfs_next_item() (+7/-0)
    Btrfs: new backref walking code (+107/-262)

Stefan Behrens (4) commits (+3203/-11):
    Btrfs: Makefile changes to optionally include btrfs integrity check (+1/-0)
    Btrfs: add config option to enable btrfs integrity check (+19/-0)
    Btrfs: integrate integrity check module into btrfs (+79/-11)
    Btrfs: add optional integrity check code (+3104/-0)

Chris Mason (4) commits (+23/-32):
    Btrfs: use bigger metadata chunks on bigger filesystems (+5/-1)
    Btrfs: run chunk allocations while we do delayed refs (+11/-12)
    Btrfs: lower the bar for chunk allocation (+3/-18)
    Btrfs: use larger system chunks (+4/-1)

Alexandre Oliva (3) commits (+72/-77):
    Btrfs: test free space only for unclustered allocation (+23/-11)
    Btrfs: don't set up allocation result twice (+0/-3)
    Btrfs: revamp clustered allocation logic (+49/-63)

Miao Xie (1) commits (+1/-7):
    Btrfs: fix btrfsck error 400 when truncating a compressed

Total: (62) commits (+6949/-921)

 fs/btrfs/Kconfig             |   19 +
 fs/btrfs/Makefile            |    3 +-
 fs/btrfs/backref.c           | 1131 ++++++++++++----
 fs/btrfs/backref.h           |    5 +
 fs/btrfs/btrfs_inode.h       |    3 +
 fs/btrfs/check-integrity.c   | 3068 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/check-integrity.h   |   36 +
 fs/btrfs/ctree.c             |   42 +-
 fs/btrfs/ctree.h             |  237 +++-
 fs/btrfs/delayed-inode.c     |   45 +-
 fs/btrfs/delayed-ref.c       |  153 ++-
 fs/btrfs/delayed-ref.h       |  104 ++-
 fs/btrfs/disk-io.c           |   49 +-
 fs/btrfs/extent-tree.c       |  465 +++++--
 fs/btrfs/extent_io.c         |    6 +-
 fs/btrfs/extent_io.h         |    2 +
 fs/btrfs/file.c              |   11 +-
 fs/btrfs/free-space-cache.c  |  417 ++++---
 fs/btrfs/inode-map.c         |    4 +
 fs/btrfs/inode.c             |   66 +-
 fs/btrfs/ioctl.c             |  261 ++++-
 fs/btrfs/ioctl.h             |   54 +
 fs/btrfs/locking.c           |   53 +-
 fs/btrfs/relocation.c        |   20 +-
 fs/btrfs/scrub.c             |   12 +-
 fs/btrfs/super.c             |   47 +-
 fs/btrfs/transaction.c       |   20 +-
 fs/btrfs/tree-log.c          |    2 +-
 fs/btrfs/ulist.c             |  220 +++
 fs/btrfs/ulist.h             |   68 +
 fs/btrfs/volumes.c           |  988 ++++++++++++---
 fs/btrfs/volumes.h           |   54 +-
 fs/btrfs/xattr.c             |    2 +-
 include/trace/events/btrfs.h |  203 +++
 34 files changed, 6949 insertions(+), 921 deletions(-)
