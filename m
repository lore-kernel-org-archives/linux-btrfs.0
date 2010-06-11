From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.35
Date: Fri, 11 Jun 2010 15:37:31 -0400
Message-ID: <20100611193731.GA3018@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of the btrfs-unstable tree is a collection of fixes
and cleanups, including two btrfs regressions from rc1:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

One is an freeing blocks on an FS converted from ext34 to btrfs,
and the other is a fallocate fix.

The rest are the usual small bug fixes.

Dan Carpenter (11) commits (+24/-17):
    Btrfs: handle error returns from btrfs_lookup_dir_item() (+2/-0)
    Btrfs: btrfs_read_fs_root_no_name() returns ERR_PTRs (+4/-0)
    Btrfs: unwind after btrfs_start_transaction() errors (+1/-1)
    Btrfs: remove unneeded null check in btrfs_rename() (+1/-3)
    Btrfs: The file argument for fsync() is never null (+1/-1)
    Btrfs: handle ERR_PTR from posix_acl_from_xattr() (+2/-0)
    Btrfs: btrfs_lookup_dir_item() can return ERR_PTR (+1/-1)
    Btrfs: uninitialized data is check_path_shared() (+1/-1)
    Btrfs: handle kzalloc() failure in open_ctree() (+5/-2)
    Btrfs: silence sparse warnings in ioctl.c (+4/-6)
    Btrfs: btrfs_iget() returns ERR_PTR (+2/-2)

Zheng Yan (2) commits (+6/-4):
    Btrfs: Fix BUG_ON for fs converted from extN (+2/-1)
    Btrfs: Fix null dereference in relocation.c (+4/-3)

Liu Bo (2) commits (+14/-4):
    Btrfs: Add error check for add_to_page_cache_lru (+13/-3)
    Btrfs: fix break in btrfs_insert_some_items() (+1/-1)

Julia Lawall (2) commits (+9/-17):
    Btrfs: Use memdup_user (+6/-14)
    Btrfs: Use ERR_CAST (+3/-3)

Shi Weihua (2) commits (+6/-0):
    Btrfs: prohibit a operation of changing acl's mask when noacl mount option used (+3/-0)
    Btrfs: should add a permission check for setfacl (+3/-0)

Miao Xie (2) commits (+9/-1):
    Btrfs: fix loop device on top of btrfs (+1/-0)
    Btrfs: fix remap_file_pages error (+8/-1)

Sage Weil (1) commits (+0/-3):
    Btrfs: avoid BUG when dropping root and reference in same transaction

Andi Kleen (1) commits (+2/-94):
    BTRFS: Clean up unused variables -- nonbugs

Josef Bacik (1) commits (+1/-1):
    Btrfs: fix fallocate regression

Prarit Bhargava (1) commits (+1/-1):
    Btrfs: Fix warning in tree_search()

Total: (25) commits (+72/-142)

 fs/btrfs/acl.c          |    8 ++++++++
 fs/btrfs/compression.c  |   18 +++++++++++++-----
 fs/btrfs/ctree.c        |   20 +-------------------
 fs/btrfs/disk-io.c      |   22 +++++++++-------------
 fs/btrfs/extent-tree.c  |    5 ++---
 fs/btrfs/extent_io.c    |    9 ---------
 fs/btrfs/extent_map.c   |    4 ++--
 fs/btrfs/file.c         |   12 ++++++++++--
 fs/btrfs/inode.c        |   22 +++-------------------
 fs/btrfs/ioctl.c        |   36 ++++++++++++------------------------
 fs/btrfs/ordered-data.c |    4 +---
 fs/btrfs/relocation.c   |    7 ++++---
 fs/btrfs/root-tree.c    |    5 -----
 fs/btrfs/super.c        |   14 +++++++-------
 fs/btrfs/tree-defrag.c  |    2 --
 fs/btrfs/tree-log.c     |   15 ---------------
 fs/btrfs/volumes.c      |    4 ----
 fs/btrfs/xattr.c        |    2 --
 fs/btrfs/zlib.c         |    5 -----
 19 files changed, 72 insertions(+), 142 deletions(-)
