From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 00/11] Btrfs: some patches for 3.3
Date: Wed, 11 Jan 2012 13:51:42 +0800
Message-ID: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The biggest one is a fix for fstrim, and there's a fix for on-disk
free space cache. Others are small fixes and cleanups.

The last three have been sent weeks ago.

The patchset is also available in this repo:

	git://repo.or.cz/linux-btrfs-devel.git for-chris

Note there's a small confict with Al Viro's vfs changes.

Li Zefan (11):
      Btrfs: add pinned extents to on-disk free space cache correctly
      Btrfs: avoid possible NULL deref in io_ctl_drop_pages()
      Btrfs: check the return value of io_ctl_init()
      Btrfs: remove BUG_ON()s in btrfs_ioctl_setflags()
      Btrfs: reserve metadata space in btrfs_ioctl_setflags()
      Btrfs: don't pass a trans handle unnecessarily in volumes.c
      Btrfs: don't pre-allocate btrfs bio
      Btrfs: simplfy calculation of stripe length for discard operation
      Btrfs: rewrite btrfs_trim_block_group()
      Btrfs: update global block_rsv when creating a new block group
      Btrfs: fix possible deadlock when opening a seed device

 fs/btrfs/disk-io.c          |    2 -
 fs/btrfs/extent-tree.c      |    3 +-
 fs/btrfs/free-space-cache.c |  293 +++++++++++++++++++++++++++++--------------
 fs/btrfs/ioctl.c            |   20 +++-
 fs/btrfs/volumes.c          |  189 ++++++++++------------------
 fs/btrfs/volumes.h          |    3 +-
 6 files changed, 280 insertions(+), 230 deletions(-)

