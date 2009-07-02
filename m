From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Thu, 2 Jul 2009 15:10:35 -0400
Message-ID: <20090702191035.GA3832@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Here are some btrfs updates.  Most of them are small bug fixes, but the
large commit from Yan Zheng is step one in getting snapshot deletion
rolling.  There is also has a nice CPU usage reduction for
streaming writes to a file.

Linus, please pull the master branch of btrfs-unstable:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Chris Mason (3) commits (+15/-9):
    Btrfs: don't log the inode in file_write while growing the file (+4/-1)
    Btrfs: fix the file clone ioctl for preallocated extents (+4/-2)
    Btrfs: honor nodatacow/sum mount options for new files (+7/-6)

Josef Bacik (1) commits (+11/-1):
    Btrfs: account for space we may use in fallocate

Yan Zheng (1) commits (+395/-181):
    Btrfs: update backrefs while dropping snapshot

Total: (5) commits

 fs/btrfs/ctree.h       |    3 
 fs/btrfs/extent-tree.c |  564 +++++++++++++++++++++++++++++++++----------------
 fs/btrfs/file.c        |    5 
 fs/btrfs/inode.c       |   25 +-
 fs/btrfs/ioctl.c       |    6 
 fs/btrfs/relocation.c  |    5 
 fs/btrfs/transaction.c |    4 
 7 files changed, 421 insertions(+), 191 deletions(-)
