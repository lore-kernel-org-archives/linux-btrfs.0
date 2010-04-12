From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Mon, 12 Apr 2010 16:00:54 -0400
Message-ID: <20100412200054.GS13327@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

The last pull was missing two fixes, which you can find in the
master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Josef's commit helps close another enospc problem, and the other one
fixes an oops where we try to allocate a zero sized extent off the
drive.

Chris Mason (1) commits (+6/-0):
    Btrfs: make sure the chunk allocator doesn't create zero length chunks

Josef Bacik (1) commits (+15/-5):
    Btrfs: fix data enospc check overflow

Total: (2) commits

 fs/btrfs/extent-tree.c |   20 +++++++++++++++-----
 fs/btrfs/volumes.c     |    6 ++++++
 2 files changed, 21 insertions(+), 5 deletions(-)
