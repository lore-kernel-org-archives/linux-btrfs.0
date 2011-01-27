From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 00/12] Btrfs: Some bug fixes
Date: Thu, 27 Jan 2011 16:42:14 +0800
Message-ID: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Those patches (except the last two) have been sent to the mailing list
before, and they fix real bugs (but not critical bugs). Please consider
queue them for 2.6.38.

The free-space cache fixes were reviewed by Josef. Other patches fix
some memory leaks, fix an acl bug, and fix the file clone ioctl.

Note: not all the patches are from Fujitsu.

Those patches can be pulled from:

	git://repo.or.cz/linux-btrfs-devel.git bug-fixes


Ian Kent (1):
      Btrfs: Fix memory leak on finding existing super

Li Zefan (8):
      btrfs: Fix threshold calculation for block groups smaller than 1GB
      btrfs: Add helper function free_bitmap()
      btrfs: Free fully occupied bitmap in cluster
      btrfs: Update stats when allocating from a cluster
      btrfs: Add a helper try_merge_free_space()
      btrfs: Check mergeable free space when removing a cluster
      Btrfs: Fix memory leak at umount
      Btrfs: Fix file clone when source offset is not 0

Miao Xie (2):
      Btrfs: Don't return acl info when mounting with noacl option
      Btrfs: Fix memory leak in writepage fixup work

Tero Roponen (1):
      Btrfs: Free correct pointer after using strsep

 fs/btrfs/acl.c              |    6 ++
 fs/btrfs/disk-io.c          |    2 +
 fs/btrfs/free-space-cache.c |  161 ++++++++++++++++++++++++++-----------------
 fs/btrfs/inode.c            |    1 +
 fs/btrfs/ioctl.c            |    5 +-
 fs/btrfs/super.c            |    7 ++-
 6 files changed, 117 insertions(+), 65 deletions(-)
