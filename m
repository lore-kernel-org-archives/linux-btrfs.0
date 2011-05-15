From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Sun, 15 May 2011 10:47:23 -0400
Message-ID: <1305470325-sup-6477@shiny>
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi everyone,

The master branch of the btrfs unstable tree has a few more fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

These include small fixes in the new per-file flags, an oops in
the btrfs acl code and ENOSPC fixes for mixed block groups (used in very
small filesystems).

Li Zefan (3) commits (+15/-10):
    Btrfs: fix FS_IOC_SETFLAGS ioctl (+2/-0)
    Btrfs: fix FS_IOC_GETFLAGS ioctl (+7/-0)
    fs: remove FS_COW_FL (+6/-10)

Daniel J Blueman (1) commits (+3/-2):
    Prevent oopsing in posix_acl_valid()

liubo (1) commits (+26/-11):
    Btrfs: fix easily get into ENOSPC in mixed case

Total: (5) commits (+44/-23)

 fs/btrfs/acl.c         |    5 +++--
 fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++++++++-----------
 fs/btrfs/ioctl.c       |   24 +++++++++++++++---------
 include/linux/fs.h     |    1 -
 4 files changed, 44 insertions(+), 23 deletions(-)
