From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes for 2.6.31-rc
Date: Fri, 7 Aug 2009 15:01:09 -0400
Message-ID: <20090807190109.GI17129@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Linus, please pull these from the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

These are relatively small bug fixes, including two fixes for 
tree-log recovery on mount (one oops and one infinite loop).

Bartlomiej Zolnierkiewicz (1) commits (+1/-2):
    Btrfs: remove superfluous NULL pointer check in btrfs_rename()

Chris Mason (1) commits (+17/-4):
    Btrfs: make sure the async caching thread advances the key

Josef Bacik (1) commits (+64/-9):
    Btrfs: fix btrfs_remove_from_free_space corner case

Julia Lawall (1) commits (+3/-3):
    Btrfs: correct error-handling zlib error handling

Yan Zheng (1) commits (+7/-2):
    Btrfs: fix balancing oops when invalidate_inode_pages2 returns EBUSY

Total: (5) commits

 fs/btrfs/extent-tree.c      |   21 ++++++++++--
 fs/btrfs/free-space-cache.c |   73 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/inode.c            |    3 -
 fs/btrfs/relocation.c       |    9 ++++-
 fs/btrfs/zlib.c             |    6 +--
 5 files changed, 92 insertions(+), 20 deletions(-)
