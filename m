From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs pull for 2.6.39-rc2
Date: Tue, 05 Apr 2011 04:12:27 -0400
Message-ID: <1301990214-sup-7585@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs unstable tree has some bug fixes for
btrfs.  One fixes a regression from readonly snapshot support (2.6.38),
where we can incorrectly treat a subvolume as readonly.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

Tsutomu Itoh (3) commits (+21/-4):
    Btrfs: fix memory leak in btrfs_ioctl_start_sync() (+3/-1)
    Btrfs: fix compiler warning in file.c (+1/-1)
    Btrfs: fix /proc/mounts info. (+17/-2)

Li Zefan (2) commits (+38/-10):
    Btrfs: Fix oops for defrag with compression turned on (+8/-9)
    Btrfs: Fix uninitialized root flags for subvolumes (+30/-1)

Josef Bacik (2) commits (+78/-6):
    Btrfs: fix free space cache when there are pinned extents and clusters V2 (+78/-4)
    Btrfs: don't warn in btrfs_add_orphan (+0/-2)

Yoshinori Sano (1) commits (+1/-0):
    Btrfs: fix memory leak in start_transaction()

Johann Lombardi (1) commits (+5/-3):
    Btrfs: fix subvol_sem leak in btrfs_rename()

Miao Xie (1) commits (+2/-2):
    btrfs: clear __GFP_FS flag in the space cache inode

-chris

Total: (10) commits (+145/-25)

 fs/btrfs/ctree.h            |    4 ++
 fs/btrfs/disk-io.c          |    4 ++-
 fs/btrfs/file.c             |    2 +-
 fs/btrfs/free-space-cache.c |   84 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c            |   29 +++++++--------
 fs/btrfs/ioctl.c            |    8 ++++-
 fs/btrfs/root-tree.c        |   18 +++++++++
 fs/btrfs/super.c            |   19 +++++++++-
 fs/btrfs/transaction.c      |    2 +
 9 files changed, 145 insertions(+), 25 deletions(-)
