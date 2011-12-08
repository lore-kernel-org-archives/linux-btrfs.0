From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Thu, 8 Dec 2011 14:24:35 -0500
Message-ID: <20111208192435.GR8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs repository:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a few more fixes.  The most notable here are two more patches from
Alexandre's batch of allocator fixes.  The other two fix corner cases in
the state code and in the code to add devices.

Alexandre Oliva (2) commits (+49/-51):
    Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE (+18/-8)
    Btrfs: try cluster but don't advance in search list (+31/-43)

Liu Bo (1) commits (+16/-8):
    Btrfs: drop spin lock when memory alloc fails

Li Zefan (1) commits (+1/-1):
    Btrfs: check if the to-be-added device is writable

Total: (4) commits (+66/-60)

 fs/btrfs/extent-tree.c |  100 +++++++++++++++++++++++------------------------
 fs/btrfs/extent_io.c   |   24 ++++++++----
 fs/btrfs/volumes.c     |    2 +-
 3 files changed, 66 insertions(+), 60 deletions(-)
