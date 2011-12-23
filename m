From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Fri, 23 Dec 2011 12:24:54 -0500
Message-ID: <20111223172454.GT19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has two commits:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One is Al's patch in response to my last pull request, but with one small
change to call d_instantiate before trying to log the inode in
btrfs_link.

The other is a double unlock that Dan Carpenter found.  These did get
rebased this morning before I pushed them out, but I reran tests after
the rebase.

Chris Mason (1) commits (+2/-1):
    Btrfs: fix worker lock misuse in find_worker

Al Viro (1) commits (+5/-4):
    Btrfs: call d_instantiate after all ops are setup

Total: (2) commits (+7/-5)

 fs/btrfs/async-thread.c |    3 ++-
 fs/btrfs/inode.c        |    9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)
