From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Fri, 9 Mar 2012 21:01:50 -0500
Message-ID: <20120310020150.GW29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have two additional and btrfs fixes in my for-linus branch

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One is a casting error that leads to memory corruption on i386 during
scrub, and the other fixes a corner case in the backref walking code
(also triggered by scrub).

These are reviewed and tested.  I was holding off on this while trying
to track enospc bug reports, but it isn't yet clear if those are
regressions.  These are valid fixes either way.

Chris Mason (1) commits (+1/-1):
    Btrfs: fix casting error in scrub reada code

Li Zefan (1) commits (+6/-2):
    btrfs: fix locking issues in find_parent_nodes()

Total: (2) commits (+7/-3)
 fs/btrfs/backref.c |    8 ++++++--
 fs/btrfs/reada.c   |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)
