From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/4] Btrfs: A few small bug fixes
Date: Wed, 13 Apr 2011 15:42:01 +0800
Message-ID: <4DA553C9.2040807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Those bugs are small, and the fixes are simple and straitforward.

You can pull from:

	git://repo.or.cz/linux-btrfs-devel.git for-chris



Li Zefan (2):
      Btrfs: Check if btrfs_next_leaf() returns error in btrfs_listxattr()
      Btrfs: Check if btrfs_next_leaf() returns error in btrfs_real_readdir()

Miao Xie (2):
      Btrfs: Fix incorrect inode nlink in btrfs_link()
      Btrfs: Check validity before setting an acl

---
 fs/btrfs/acl.c   |    9 +++++----
 fs/btrfs/inode.c |   34 +++++++++++++---------------------
 fs/btrfs/xattr.c |   33 ++++++++++++---------------------
 3 files changed, 30 insertions(+), 46 deletions(-)

