From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Sun, 6 May 2012 09:35:41 -0400
Message-ID: <20120506133541.GB30809@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch in the btrfs git repo has some fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The big ones here are a memory leak we introduced in rc1, and 
a scheduling while atomic if the transid on disk doesn't match the
transid we expected.  This happens for corrupt blocks, or out of date
disks.

It also fixes up the ioctl definition for our ioctl to resolve logical
inode numbers.  The __u32 was a merging error and doesn't match what we
ship in the progs.

Chris Mason (2) commits (+36/-17):
    Btrfs: avoid sleeping in verify_parent_transid while atomic (+34/-17)
    Btrfs: Add properly locking around add_root_to_dirty_list (+2/-0)

Stefan Behrens (1) commits (+7/-0):
    Btrfs: fix crash in scrub repair code when device is missing

Josef Bacik (1) commits (+2/-2):
    Btrfs: fix page leak when allocing extent buffers

Alexander Block (1) commits (+2/-2):
    btrfs: Fix mismatching struct members in ioctl.h

Total: (5) commits (+47/-21)

 fs/btrfs/ctree.c       |   28 +++++++++++++++++++---------
 fs/btrfs/disk-io.c     |   18 +++++++++++++-----
 fs/btrfs/disk-io.h     |    3 ++-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |    4 ++--
 fs/btrfs/ioctl.h       |    4 ++--
 fs/btrfs/scrub.c       |    7 +++++++
 fs/btrfs/tree-log.c    |    2 +-
 8 files changed, 47 insertions(+), 21 deletions(-)
