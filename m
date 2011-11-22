From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Mon, 21 Nov 2011 20:30:31 -0500
Message-ID: <20111122013031.GG28259@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the linux-btrfs repo has some important fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The most important in the bunch fixes the btrfs cache flushing.  This
one probably explains many of the corruptions that have been reported,
especially on multi-device filesystems.  I had a hard time hitting it
locally, partially because it is much less likely to happen for fsync
based commits and most of my tests used fsyncs to exercise the commit
code.  Ceph users running with -o notreelog were dramatically more
likely to trigger the corruptions.

The problem was that btrfs was triggering cache flushes before the last
copy of the super block, instead of doing them before the first copy.
We also needed to be more careful about getting flushes done to all the
devices in a multi-device FS before writing any of the supers.  To help
verify the new code, I wrote up a writeback-caching elevator, which I
sent posted earlier today for comments/review.

Many thanks to Alexandre Oliva and Arne Jansen for helping nail this
down.

Outside of the cache flushes, we also have a fix from Liu Bo for
corruptions when snapshotting with mount -o inode_cache enabled.

My for-linus branch is still against 3.1, but these were tested on Linus
git as well.

Josef Bacik (3) commits (+90/-42):
    Btrfs: wait on caching if we're loading the free space cache (+81/-41)
    Btrfs: clear pages dirty for io and set them extent mapped (+5/-0)
    Btrfs: sectorsize align offsets in fiemap (+4/-1)

Chris Mason (2) commits (+141/-18):
    Btrfs: remove free-space-cache.c WARN during log replay (+7/-1)
    Btrfs: fix barrier flushes (+134/-17)

Li Zefan (2) commits (+16/-38):
    Btrfs: avoid unnecessary bitmap search for cluster setup (+4/-38)
    Btrfs: fix to search one more bitmap for cluster setup (+12/-0)

Jan Schmidt (1) commits (+4/-4):
    btrfs: mirror_num should be int, not u64

Jeff Mahoney (1) commits (+9/-6):
    btrfs: Fix up 32/64-bit compatibility for new ioctls

Liu Bo (1) commits (+26/-1):
    Btrfs: fix tree corruption after multi-thread snapshots and inode_cache flush

Arnd Hannemann (1) commits (+3/-3):
    Btrfs: prefix resize related printks with btrfs:

David Sterba (1) commits (+4/-2):
    btrfs: fix stat blocks accounting

Total: (12) commits (+290/-111)

 fs/btrfs/backref.c          |    2 +-
 fs/btrfs/ctree.c            |   17 +++++-
 fs/btrfs/ctree.h            |    5 +-
 fs/btrfs/disk-io.c          |  147 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent-tree.c      |  119 +++++++++++++++++++++++------------
 fs/btrfs/extent_io.c        |    9 ++-
 fs/btrfs/extent_io.h        |    2 +-
 fs/btrfs/free-space-cache.c |   63 ++++++++-----------
 fs/btrfs/inode.c            |    6 +-
 fs/btrfs/ioctl.c            |   15 +++--
 fs/btrfs/scrub.c            |    2 +-
 fs/btrfs/transaction.c      |    8 +++
 fs/btrfs/volumes.h          |    6 ++
 13 files changed, 290 insertions(+), 111 deletions(-)
