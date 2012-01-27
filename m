From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Fri, 27 Jan 2012 11:34:16 -0500
Message-ID: <20120127163416.GE991@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[ sorry resend without bad auto-complete for lkml ]

Hi Linus,

We've got a variety pack of fixes in the for-linus branch of the btrfs
repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are all smaller fixes caught from different testers, benchmarks
and the occasional compiler warning.

Josef Bacik (3) commits (+3/-2):
    Btrfs: use cluster->window_start when allocating from a cluster bitmap (+1/-1)
    Btrfs: advance window_start if we're using a bitmap (+1/-0)
    Btrfs: make sure a bitmap has enough bytes (+1/-1)

Stefan Behrens (1) commits (+6/-5):
    Btrfs: fix warning for 32-bit build of fs/btrfs/check-integrity.c

Jan Schmidt (1) commits (+2/-2):
    Btrfs: fix uninit warning in backref.c

Liu Bo (1) commits (+1/-1):
    Btrfs: do not defrag a file partially

Mitch Harder (1) commits (+2/-0):
    Btrfs: Check for NULL page in extent_range_uptodate

Chris Mason (1) commits (+8/-2):
    Btrfs: fix reservations in btrfs_page_mkwrite

David Sterba (1) commits (+7/-0):
    btrfs: mask out gfp flags in releasepage

Jan Kara (1) commits (+4/-2):
    btrfs: Fix busyloops in transaction waiting code

Miao Xie (1) commits (+27/-22):
    Btrfs: fix enospc error caused by wrong checks of the chunk

Total: (11) commits (+60/-36)

 fs/btrfs/backref.c          |    4 +-
 fs/btrfs/check-integrity.c  |   11 +++++----
 fs/btrfs/disk-io.c          |    7 ++++++
 fs/btrfs/extent-tree.c      |   49 +++++++++++++++++++++++-------------------
 fs/btrfs/extent_io.c        |    2 +
 fs/btrfs/free-space-cache.c |    5 ++-
 fs/btrfs/inode.c            |   10 +++++++-
 fs/btrfs/ioctl.c            |    2 +-
 fs/btrfs/tree-log.c         |    6 +++-
 9 files changed, 60 insertions(+), 36 deletions(-)

