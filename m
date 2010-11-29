From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.37-rc
Date: Mon, 29 Nov 2010 11:00:57 -0500
Message-ID: <1291045745-sup-8236@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a collection of btrfs bug fixes.

The three most important fixes here address crashes in the btrfs
O_DIRECT code, add a migrate_page operation to avoid metadata corruption
as btree pages go through migration, and fix up our NFS support.

Otherwise we have assorted correctness fixes, many of which were kicked
out by xfsqa.

-chris

Josef Bacik (11) commits (+241/-54):
    Btrfs: make btrfs_add_nondir take parent inode as an argument (+16/-22)
    Btrfs: fix typo in fallocate to make it honor actual size (+5/-4)
    Btrfs: hold i_mutex when calling btrfs_log_dentry_safe (+7/-0)
    Btrfs: setup blank root and fs_info for mount time (+33/-7)
    Btrfs: make sure new inode size is ok in fallocate (+4/-0)
    Btrfs: use dget_parent where we can UPDATED (+43/-12)
    Btrfs: handle the space_cache option properly (+1/-0)
    Btrfs: update inode ctime when using links (+1/-0)
    Btrfs: fix more ESTALE problems with NFS (+1/-0)
    Btrfs: handle NFS lookups properly (+76/-0)
    Btrfs: fix fiemap (+54/-9)

Chris Mason (4) commits (+124/-9):
    Btrfs: deal with DIO bios that span more than one ordered extent (+89/-4)
    Btrfs: avoid NULL pointer deref in try_release_extent_buffer (+4/-2)
    Btrfs: don't use migrate page without CONFIG_MIGRATION (+6/-1)
    Btrfs: add migrate page for metadata inode (+25/-2)

Li Zefan (3) commits (+6/-6):
    btrfs: Check if dest_offset is block-size aligned before cloning file (+3/-4)
    btrfs: Show device attr correctly for symlinks (+1/-0)
    btrfs: Set file size correctly in file clone (+2/-2)

Miao Xie (3) commits (+195/-45):
    btrfs: cleanup duplicate bio allocating functions (+8/-18)
    btrfs: fix free dip and dip->csums twice (+3/-6)
    btrfs: fix panic caused by direct IO (+184/-21)

Mariusz Kozlowski (1) commits (+3/-3):
    btrfs: make 1-bit signed fileds unsigned

Arne Jansen (1) commits (+1/-1):
    btrfs: Fix early enospc because 'unused' calculated with wrong sign.

Ian Kent (1) commits (+6/-0):
    Btrfs - fix race between btrfs_get_sb() and umount

Total: (24) commits (+576/-118)

 fs/btrfs/compression.c  |   15 +---
 fs/btrfs/ctree.h        |    6 +-
 fs/btrfs/disk-io.c      |   38 +++++-
 fs/btrfs/export.c       |   76 ++++++++++++
 fs/btrfs/extent-tree.c  |    2 +-
 fs/btrfs/extent_io.c    |   77 ++++++++++---
 fs/btrfs/extent_io.h    |    3 +
 fs/btrfs/file.c         |    7 +
 fs/btrfs/inode.c        |  294 ++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.c        |   31 ++++--
 fs/btrfs/ordered-data.c |   67 +++++++++++
 fs/btrfs/ordered-data.h |    3 +
 fs/btrfs/super.c        |   41 ++++++-
 fs/btrfs/transaction.c  |    5 +-
 fs/btrfs/tree-log.c     |   21 +++-
 15 files changed, 572 insertions(+), 114 deletions(-)
