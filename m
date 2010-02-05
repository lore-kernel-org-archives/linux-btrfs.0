From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.33
Date: Thu, 4 Feb 2010 20:59:14 -0500
Message-ID: <20100205015913.GA2770@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a small collection of fixes.  These are mostly bugs, but I put in
one of Josef's safer performance tweaks as well.

Aneesh Kumar K.V (1) commits (+3/-1):
    Btrfs: apply updated fallocate i_size fix

Josef Bacik (1) commits (+2/-44):
    Btrfs: do not try and lookup the file extent when finishing ordered io

Miao Xie (1) commits (+8/-2):
    Btrfs: remove BUG_ON() due to mounting bad filesystem

Roel Kluin (1) commits (+1/-1):
    Btrfs: make error return negative in btrfs_sync_file()

Zheng Yan (2) commits (+5/-6):
    Btrfs: fix race between allocate and release extent buffer. (+1/-2)
    Btrfs: Fix oopsen when dropping empty tree. (+4/-4)

Total: (6) commits

 fs/btrfs/disk-io.c     |    7 +++++-
 fs/btrfs/extent-tree.c |    8 +++----
 fs/btrfs/extent_io.c   |    3 --
 fs/btrfs/file.c        |    2 -
 fs/btrfs/inode.c       |   50 ++++---------------------------------------------
 fs/btrfs/relocation.c  |    3 +-
 6 files changed, 19 insertions(+), 54 deletions(-)
