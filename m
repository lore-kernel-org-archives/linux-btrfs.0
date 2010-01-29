From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.33
Date: Fri, 29 Jan 2010 12:35:25 -0500
Message-ID: <20100129173525.GA2819@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753961Ab0A2RhO@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The btrfs-unstable master branch has some updates:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

It will pull into either 2.6.32 or 2.6.33-git.

These are bug fixes, mostly around btrfs multi-device code and replacing
failed drives.  It also includes a fix for the orphan cleanup fix in the
last pull, this version is much better.

Outside of fixes, this adds mount -o compress-force, which won't back
off compressing files when part of the file doesn't compress well.

Aneesh Kumar K.V (1) commits (+9/-4):
    Btrfs: Use correct values when updating inode i_size on fallocate

Chris Mason (1) commits (+11/-2):
    Btrfs: Add mount -o compress-force

Josef Bacik (4) commits (+15/-10):
    Btrfs: do not mark the chunk as readonly if in degraded mode (+5/-0)
    Btrfs: check total number of devices when removing missing (+2/-2)
    Btrfs: check return value of open_bdev_exclusive properly (+2/-2)
    Btrfs: run orphan cleanup on default fs root (+6/-6)

Miao Xie (1) commits (+0/-14):
    Btrfs: remove tree_search() in extent_map.c

Yang Hongyang (1) commits (+1/-0):
    Btrfs: fix a memory leak in btrfs_init_acl

Total: (8) commits

 fs/btrfs/acl.c        |    1 +
 fs/btrfs/ctree.h      |    1 +
 fs/btrfs/disk-io.c    |    6 ++++++
 fs/btrfs/extent_map.c |   14 --------------
 fs/btrfs/inode.c      |   22 +++++++++++-----------
 fs/btrfs/super.c      |    9 ++++++++-
 fs/btrfs/volumes.c    |   13 +++++++++----
 7 files changed, 36 insertions(+), 30 deletions(-)
