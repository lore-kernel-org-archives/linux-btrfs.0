From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 0/5] Btrfs: Readonly snapshots
Date: Thu, 09 Dec 2010 17:09:38 +0800
Message-ID: <4D009CD2.3060805@cn.fujitsu.com>
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

Note: I've changed the async snapshot ABI. So if the patchset is acceptable,
the first patch has to be merged into .37 to avoid ABI breakage.

---
 fs/btrfs/ctree.h       |    3 +
 fs/btrfs/disk-io.c     |   36 +++++----
 fs/btrfs/inode.c       |    8 ++
 fs/btrfs/ioctl.c       |  193 +++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.h       |   19 ++++-
 fs/btrfs/transaction.c |    8 ++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/xattr.c       |   18 +++++
 8 files changed, 230 insertions(+), 56 deletions(-)
