From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/5] btrfs: Readonly snapshots
Date: Mon, 29 Nov 2010 16:02:31 +0800
Message-ID: <4CF35E17.6050705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(Cc: Sage Weil <sage@newdream.net> for changes in async snapshots)

This patchset adds readonly-snapshots support. You can create a
readonly snapshot, and you can also set a snapshot readonly/writable
on the fly.

A few readonly checks are added in setattr, permission, remove_xattr
and set_xattr callbacks, as well as in some ioctls.

You can also try it out by pulling (based on the master branch of
Chris' tree):
	git://repo.or.cz/linux-btrfs-devel.git readonly-snapshots

Note: I changed the async snapshot ABI. So if the patchset is acceptable,
the first patch has to be merged into .37 to avoid ABI breakage.

---
 fs/btrfs/ctree.h       |    3 +
 fs/btrfs/disk-io.c     |   36 +++++++-----
 fs/btrfs/inode.c       |    8 +++
 fs/btrfs/ioctl.c       |  147 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.h       |   16 ++++-
 fs/btrfs/transaction.c |    8 +++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/xattr.c       |   18 ++++++
 8 files changed, 196 insertions(+), 41 deletions(-)
