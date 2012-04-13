From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Fri, 13 Apr 2012 09:38:29 -0400
Message-ID: <20120413133829.GY29506@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has btrfs fixes and updates:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The top commit is the only one that isn't strictly a bug fix.  It
updates the btrfs metadata checker code to support metadata blocks
larger than the page size.  This code isn't compiled in by default, and
it is only used by developers.  I put it at the top so you could just
peel it off if you didn't want it.  I also put a for-linus-min branch
without this commit:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-min

The others are pure bug fixes.  We have a use-after-free in there, along
with errors when mount -o discard is enabled, and a BUG_ON(we should
compile with UP more often).

Stefan Behrens (1) commits (+415/-146):
    Btrfs: change integrity checker to support big blocks

Chris Mason (2) commits (+2/-2):
    Revert "Btrfs: increase the global block reserve estimates" (+1/-1)
    Btrfs: fix uninit variable in repair_eb_io_failure (+1/-1)

Dave Jones (1) commits (+5/-4):
    Btrfs: fix use-after-free in __btrfs_end_transaction

Liu Bo (1) commits (+18/-2):
    Btrfs: fix eof while discarding extents

Ilya Dryomov (1) commits (+2/-3):
    Btrfs: remove lock assert from get_restripe_target()

Josef Bacik (1) commits (+3/-10):
    Btrfs: use commit root when loading free space cache

Tsutomu Itoh (1) commits (+10/-0):
    Btrfs: check return value of bio_alloc() properly

Total: (8) commits (+455/-167)

 fs/btrfs/check-integrity.c  |  561 ++++++++++++++++++++++++++++++++-----------
 fs/btrfs/compression.c      |    2 +
 fs/btrfs/extent-tree.c      |   11 +-
 fs/btrfs/extent_io.c        |    6 +-
 fs/btrfs/free-space-cache.c |    9 +-
 fs/btrfs/scrub.c            |    4 +
 fs/btrfs/transaction.c      |    9 +-
 fs/btrfs/volumes.c          |   20 +-
 8 files changed, 455 insertions(+), 167 deletions(-)
