From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Sat, 28 Apr 2012 08:27:48 -0400
Message-ID: <20120428122748.GJ7340@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has our collection of bug fixes.  I missed the last rc because I thought
our patches were making NFS crash during my xfs test runs.  Turns out it
was an NFS client bug fixed by someone else while I tried to bisect it.

All of these fixes are small, but some are fairly high impact.  The
biggest are fixes for our mount -o remount handling, a deadlock due
to GFP_KERNEL allocations in readdir, and a RAID10 error handling bug.

This was tested against both 3.3 and Linus' master as of this morning.

Stefan Behrens (4) commits (+7/-19):
    Btrfs: don't count CRC or header errors twice while scrubbing (+0/-15)
    Btrfs: fix btrfs_ioctl_dev_info() crash on missing device (+4/-1)
    Btrfs: fix that check_int_data mount option was ignored (+1/-1)
    Btrfs: fix block_rsv and space_info lock ordering (+2/-2)

Jan Schmidt (3) commits (+20/-8):
    Btrfs: don't call free_extent_buffer twice in iterate_irefs (+3/-5)
    Btrfs: add missing read locks in backref.c (+15/-2)
    Btrfs: fix repair code for RAID10 (+2/-1)

Arne Jansen (3) commits (+39/-26):
    btrfs: don't add both copies of DUP to reada extent tree (+13/-0)
    btrfs: fix race in reada (+23/-20)
    btrfs: don't return EINTR (+3/-6)

Li Zefan (3) commits (+32/-25):
    Btrfs: avoid possible use-after-free in clear_extent_bit() (+21/-15)
    Btrfs: retrurn void from clear_state_bit (+2/-5)
    Btrfs: avoid setting ->d_op twice (+9/-5)

Daniel J Blueman (2) commits (+3/-1):
    Btrfs: Fix space checking during fs resize (+1/-1)
    Btrfs: Prevent root_list corruption (+2/-0)

Chris Mason (2) commits (+8/-31):
    Btrfs: avoid deadlocks from GFP_KERNEL allocations during btrfs_real_readdir (+1/-29)
    Btrfs: reduce lock contention during extent insertion (+7/-2)

Josef Bacik (2) commits (+17/-21):
    Btrfs: always store the mirror we read the eb from (+17/-20)
    Btrfs: do not start delalloc inodes during sync (+0/-1)

Jesper Juhl (1) commits (+2/-0):
    Btrfs: Make free_ipath() deal gracefully with NULL pointers

Liu Bo (1) commits (+3/-3):
    Btrfs: do not mount when we have a sectorsize unequal to PAGE_SIZE

Julia Lawall (1) commits (+3/-1):
    fs/btrfs/volumes.c: add missing free_fs_devices

Ilya Dryomov (1) commits (+4/-2):
    Btrfs: fix max chunk size check in chunk allocator

Dan Carpenter (1) commits (+2/-0):
    Btrfs: double unlock bug in error handling

David Sterba (1) commits (+5/-1):
    btrfs: add missing unlocks to transaction abort paths

Sergei Trofimovich (1) commits (+4/-2):
    btrfs: fix early abort in 'remount'

Total: (26) commits

 fs/btrfs/backref.c     |   27 +++++++++++++++++------
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/disk-io.c     |   22 +++++++++----------
 fs/btrfs/extent-tree.c |   15 ++++++-------
 fs/btrfs/extent_io.c   |   56 ++++++++++++++++++++++++------------------------
 fs/btrfs/extent_io.h   |    4 ++--
 fs/btrfs/file.c        |    9 ++++++--
 fs/btrfs/inode.c       |   54 ++++++++++++++++------------------------------
 fs/btrfs/ioctl.c       |    5 ++++-
 fs/btrfs/reada.c       |   48 +++++++++++++++++++++++++----------------
 fs/btrfs/relocation.c  |    4 +++-
 fs/btrfs/scrub.c       |   15 -------------
 fs/btrfs/super.c       |    7 +++---
 fs/btrfs/transaction.c |    6 +++++-
 fs/btrfs/volumes.c     |   13 +++++++----
 15 files changed, 148 insertions(+), 139 deletions(-)
