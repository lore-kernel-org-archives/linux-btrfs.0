From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v3 0/3] Btrfs: Readonly snapshots
Date: Thu, 23 Dec 2010 16:15:16 +0800
Message-ID: <4D130514.9080704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patchset adds readonly-snapshots support. You can create a
readonly snapshot, and you can also set a snapshot (subvolume also)
readonly/writable on the fly.

A few readonly checks are added in setattr, permission, remove_xattr
and set_xattr callbacks, as well as in some ioctls.

The patchset is also available in:
	git://repo.or.cz/linux-btrfs-devel.git readonly-snapshots

---
 fs/btrfs/ctree.h       |    7 ++
 fs/btrfs/inode.c       |    8 ++
 fs/btrfs/ioctl.c       |  199 ++++++++++++++++++++++++++++++++++++------------
 fs/btrfs/ioctl.h       |    3 +
 fs/btrfs/transaction.c |    8 ++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/xattr.c       |   18 +++++
 7 files changed, 195 insertions(+), 49 deletions(-)
