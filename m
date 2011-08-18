From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Thu, 18 Aug 2011 14:04:55 -0400
Message-ID: <1313690367-sup-3240@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"BTRFS Mailing list" <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs-unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Has our current pull request for 3.1-rc.  The for-linus branch includes
3.1-rc2 because it two fixes from Dan Carpenter and Jeff Mahoney that
only apply to 3.1.

The master branch of btrfs-unstable is based on 3.0, and includes
everything except those two changes.

This is a variety pack of fixes.  We do have another fix pending for a
race in our readdir optimizations, but Josef will work that out with Al
Viro and send it in later this week (or early next).

Chris Mason (1) commits (+17/-0):
    Btrfs: force unplugs when switching from high to regular priority bios

Dan Carpenter (2) commits (+10/-4):
    btrfs: unlock on error in btrfs_file_llseek() (+8/-4)
    btrfs: memory leak in btrfs_add_inode_defrag() (+2/-0)

Jeff Mahoney (1) commits (+8/-4):
    btrfs: btrfs_permission's RO check shouldn't apply to device nodes

Josef Bacik (2) commits (+43/-2):
    Btrfs: set i_size properly when fallocating (+14/-0)
    Btrfs: detect wether a device supports discard (+29/-2)

Li Zefan (1) commits (+2/-4):
    Btrfs: use plain page_address() in header fields setget functions

Miao Xie (2) commits (+12/-6):
    Btrfs: fix uninitialized sync_pending (+1/-1)
    Btrfs: fix wrong free space information (+11/-5)

Sage Weil (1) commits (+4/-0):
    Btrfs: truncate pages from clone ioctl target range

Tsutomu Itoh (1) commits (+16/-10):
    Btrfs: forced readonly when btrfs_drop_snapshot() fails

liubo (3) commits (+72/-14):
    Btrfs: check if there is enough space for balancing smarter (+35/-6)
    Btrfs: fix a bug of balance on full multi-disk partitions (+13/-4)
    Btrfs: fix an oops of log replay (+24/-4)

Total: (14) commits (+183/-43)

 fs/btrfs/ctree.h            |   10 ++---
 fs/btrfs/extent-tree.c      |   75 +++++++++++++++++++++++++++++++++---------
 fs/btrfs/file.c             |   28 ++++++++++++++--
 fs/btrfs/free-space-cache.c |   16 ++++++---
 fs/btrfs/inode.c            |   12 ++++--
 fs/btrfs/ioctl.c            |    4 ++
 fs/btrfs/tree-log.c         |   28 ++++++++++++++--
 fs/btrfs/volumes.c          |   51 +++++++++++++++++++++++++++--
 fs/btrfs/volumes.h          |    2 +
 9 files changed, 183 insertions(+), 43 deletions(-)
