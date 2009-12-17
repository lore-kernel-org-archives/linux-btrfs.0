From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.33-git
Date: Thu, 17 Dec 2009 16:59:25 -0500
Message-ID: <20091217215925.GB2804@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765421AbZLQWAN@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

This btrfs update is mostly a collection of fixes.  Josef has the
snapshot-supported yum update code pending, but I wanted to give that
some more time to cook before we send it out.

Linus please pull the for-linus branch of the btrfs-unstable tree

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

This has the same code as the master branch (which is based on 2.6.32),
but it is merged Linus' current git.  There is only one trivial
conflict.

This includes a patch to fail mounting if you send btrfs a mount option
it doesn't understand.  So, if you've got something like nodataum in
your fstab you'll find errors instead of silently ignoring it.

Josef patched the block group code to make smaller metadata block groups
by default.  This helps us waste less metadata space in general.

Chris Mason (1) commits (+9/-4):
    Btrfs: make sure fallocate properly starts a transaction

Josef Bacik (1) commits (+2/-11):
    Btrfs: make metadata chunks smaller

Matthew Wilcox (1) commits (+2/-0):
    Btrfs: Show discard option in /proc/mounts

Sage Weil (1) commits (+8/-1):
    Btrfs: fail mount on bad mount options

TARUISI Hiroaki (1) commits (+4/-0):
    Btrfs: deny sys_link across subvolumes.

Zheng Yan (13) commits (+1155/-907):
    Btrfs: Pass transaction handle to security and ACL initialization functions (+96/-63)
    Btrfs: Avoid orphan inodes cleanup during committing transaction (+17/-16)
    Btrfs: Avoid orphan inodes cleanup while replaying log (+55/-36)
    Btrfs: Fix btrfs_drop_extent_cache for skip pinned case (+3/-7)
    Btrfs: don't add extent 0 to the free space cache v2 (+9/-1)
    Btrfs: Make truncate(2) more ENOSPC friendly (+212/-137)
    Btrfs: Make fallocate(2) more ENOSPC friendly (+32/-33)
    Btrfs: Fix disk_i_size update corner case (+127/-56)
    Btrfs: Avoid superfluous tree-log writeout (+47/-31)
    Btrfs: Fix per root used space accounting (+47/-27)
    Btrfs: Rewrite btrfs_drop_extents (+277/-423)
    Btrfs: Add btrfs_duplicate_item (+143/-59)
    Btrfs: Add delayed iput (+90/-18)

Total: (18) commits

 fs/btrfs/acl.c          |   23 -
 fs/btrfs/btrfs_inode.h  |    5 
 fs/btrfs/ctree.c        |  229 ++++++++++------
 fs/btrfs/ctree.h        |   40 ++
 fs/btrfs/dir-item.c     |   19 -
 fs/btrfs/disk-io.c      |   27 +
 fs/btrfs/extent-tree.c  |   72 +++--
 fs/btrfs/file.c         |  669 +++++++++++++++++++-----------------------------
 fs/btrfs/inode.c        |  585 ++++++++++++++++++++++++++---------------
 fs/btrfs/ioctl.c        |   34 +-
 fs/btrfs/ordered-data.c |  115 ++++++--
 fs/btrfs/ordered-data.h |    5 
 fs/btrfs/relocation.c   |   38 +-
 fs/btrfs/super.c        |   15 -
 fs/btrfs/transaction.c  |   44 +--
 fs/btrfs/transaction.h  |    6 
 fs/btrfs/tree-log.c     |   86 +++---
 fs/btrfs/volumes.c      |    2 
 fs/btrfs/xattr.c        |   80 +++--
 fs/btrfs/xattr.h        |    9 
 20 files changed, 1180 insertions(+), 923 deletions(-)
